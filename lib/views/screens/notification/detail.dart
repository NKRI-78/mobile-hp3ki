import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:hp3ki/providers/inbox/inbox.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class DetailInboxScreen extends StatefulWidget {
  const DetailInboxScreen({
    Key? key, 
    required this.inboxId,
    required this.type,
    required this.paymentMethod,
    required this.paymentChannel,
  }) : super(key: key);

  final String inboxId;
  final String type;
  final String paymentMethod;
  final String paymentChannel;

  @override
  DetailInboxScreenState createState() => DetailInboxScreenState();
}

class DetailInboxScreenState extends State<DetailInboxScreen> {

  bool loading = false;
  
  String title = "";
  String content = "";
  String link = "";
  String date = "";

  String latitude = "";
  String longitude = "";

  String titleMore = "";

  late ScrollController scrollC;

  bool lastStatus = true;

  void scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return scrollC.hasClients && scrollC.offset > (250 - kToolbarHeight);
  }

  Future<void> getData() async {
    setState(() {
      loading = true;
    });

    if(!mounted) return;
      await context.read<InboxProvider>().getInboxDetail(id: widget.inboxId);

      setState(() {
        loading = false;
      });

    if (!mounted) return;
      final provider = context.read<InboxProvider>();

      title = loading ? "..." : provider.inboxDetailData.title ?? "...";
      content = loading ? "..." : provider.inboxDetailData.description ?? "...";
      link = loading ? "..." : provider.inboxDetailData.link ?? "..."; 
      latitude = loading ? "..." : provider.inboxDetailData.lat ?? "...";
      longitude = loading ? "..." : provider.inboxDetailData.lng ?? "...";
      date = loading ? "..." : provider.inboxDetailData.createdAt ?? '...';
  }

  @override
  void initState() {
    super.initState();

    scrollC = ScrollController();
    scrollC.addListener(scrollListener);

    Future.microtask(() => getData());

    if (title.length > 24) {
      titleMore = title.substring(0, 24);
    } else {
      titleMore = title;
    }
  }

  @override
  void dispose() {
    scrollC.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,  
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, "refetch");
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: widget.type == "sos" 
        ? Container(
            margin: const EdgeInsets.all(15),
            child: ElevatedButton(
              onPressed: () async {
                var address = '$latitude,$longitude';
                String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$address';
                if (!await launchUrl(Uri.parse(googleUrl))) {
                  throw 'Could not open the map.';
                }
              }, 
              child: Text("Lihat lokasi",
                style: robotoRegular.copyWith(
                  fontWeight: FontWeight.bold
                ),
              )
            ),
          ) 
        : const SizedBox(),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()
          ),
          controller: scrollC,
          slivers: [
            buildAppBar(context), 
            buildBodyContent()
          ],
        ),
      ),
    );
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: ColorResources.white,
      pinned: true,
      title: Text("Inbox Masuk",
        style: poppinsRegular.copyWith(
          color: ColorResources.black,
          fontSize: Dimensions.fontSizeExtraLarge,
          fontWeight: FontWeight.bold
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8.0),
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0), color: Colors.black54),
        child: IconButton(
          color: ColorResources.white,
          onPressed: () {
            NS.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            size: Dimensions.iconSizeDefault,
          ),
        )
      ),
    );
  }

  SliverList buildBodyContent() {
    return SliverList(
      delegate: SliverChildListDelegate([

        Container(
          margin: const EdgeInsets.all(Dimensions.marginSizeExtraLarge),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 5.0),
                child: AnimatedOpacity(
                  opacity: isShrink ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  child: Text(title,
                    textAlign: TextAlign.start,
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: ColorResources.black,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  date,
                  style: poppinsRegular.copyWith(
                  color: ColorResources.grey,
                  fontSize: Dimensions.fontSizeDefault),
                )
              ),
              const Divider(
                height: 4.0,
                thickness: 1.0,
              ),
              widget.type == "sos" 
              ? Container(
                  margin: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Mayday Mayday",
                        style: robotoRegular.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorResources.black
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(content,
                        style: robotoRegular.copyWith(
                          color: ColorResources.black
                        ),
                      ),
                    ],
                  ),
                )
              : widget.type == "payment.va" 
              ? Container(
                  margin: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                  child: Text("Silahkan melakukan pembayaran menggunakan VIRTUAL ACCOUNT ${widget.paymentMethod} dengan no VA $link",
                    style: interRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: ColorResources.black,
                    ),
                  ),
                ) 
              : widget.type == "payment.emoney" 
              ? Container(
                  margin: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                  child: Column(
                    children: [
                        
                      Text("Silahkan melakukan pembayaran menggunakan ${widget.paymentMethod}",
                        style: interRegular.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: ColorResources.black,
                        ),
                      ),   

                      CachedNetworkImage(
                        imageUrl: link
                      )

                    ]
                  )
                ) 
              : Container(
                  margin: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                  child: Text(content,
                  style: interRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: ColorResources.black,
                  ),
                ),
              )    
            ],
          ),
        )

      ])
    );
  }


  // Widget buildPaymentGuideContent() {
  //   return Consumer<PPOBProvider>(builder: (context, provider, _) {
  //     if (provider.paymentGuideStatus == PaymentGuideStatus.loading) {
  //       return const Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     } else if (provider.paymentGuideStatus == PaymentGuideStatus.error) {
  //       return const Center(
  //         child: Text('Ada yang bermasalah'),
  //       );
  //     } else {
  //       return Container(
  //         margin: const EdgeInsets.only(
  //           left: 25.0, 
  //           right: 25.0
  //         ),
  //         child: ListView.builder(
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           padding: EdgeInsets.zero,
  //           itemCount: provider.listPaymentGuide.length,
  //           itemBuilder: (BuildContext context, int i) {
  //             final PaymentGuideData data = provider.listPaymentGuide[i];

  //             return ExpansionTile(
  //               initiallyExpanded: false,
  //               title: Text(data.name!,
  //                 style: poppinsRegular.copyWith(
  //                 color: ColorResources.black,
  //                 fontSize: Dimensions.fontSizeDefault,
  //                 fontWeight: FontWeight.bold)
  //               ),
  //               childrenPadding: const EdgeInsets.all(10.0),
  //               tilePadding: EdgeInsets.zero,
  //               expandedCrossAxisAlignment: CrossAxisAlignment.start,
  //               expandedAlignment: Alignment.centerLeft,
  //               children: data.steps!
  //               .asMap()
  //               .map((int key, StepModel step) => MapEntry(key,
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Text(
  //                       "${step.step}. ${step.description!}",
  //                       style: robotoRegular.copyWith(
  //                           color: ColorResources.black),
  //                     ),
  //                   )
  //                 )
  //               ).values.toList()
  //             );
  //           }
  //         ),
  //       );
  //     }
  //   });
  // }

  // Container buildNormalUrlContent() {
  //   return Container(
  //     margin: const EdgeInsets.only(top: 5.0, bottom: 10.0),
  //     child: GestureDetector(
  //       onTap: () async {
  //         await launchUrlString(url!);
  //       },
  //       child: Html(
  //         onLinkTap:
  //             (String? url, Map<String, String> attributes, element) async {
  //           await launchUrlString(url!);
  //         },
  //         style: {
  //           'body': Style(
  //             color: ColorResources.blueDrawerPrimary,
  //           ),
  //         },
  //         data: url
  //       ),
  //     ),
  //   );
  // }

}
