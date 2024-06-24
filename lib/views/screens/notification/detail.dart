import 'package:flutter/services.dart';
import 'package:hp3ki/data/models/ppob_v2/payment_guide.dart';
import 'package:hp3ki/providers/inbox/inbox.dart';
import 'package:hp3ki/providers/internet/internet.dart';
import 'package:hp3ki/providers/ppob/ppob.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:hp3ki/views/screens/connection/connection.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailInboxScreen extends StatefulWidget {
  const DetailInboxScreen({Key? key, required this.type}) : super(key: key);

  final String type;

  @override
  _DetailInfoPageState createState() => _DetailInfoPageState();
}

class _DetailInfoPageState extends State<DetailInboxScreen> {
  String? url;
  String? title;
  String? va;
  String? content;
  String? titleMore;
  String? date;
  double latitude = 0;
  double longitude = 0;

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
    if (mounted) {
      final provider = context.read<InboxProvider>();
      title = provider.inboxDetail?.title ??
          provider.inboxPaymentDetail?.title ??
          "...";

      latitude = provider.inboxDetail?.latitude ?? 0;
      longitude = provider.inboxDetail?.longitude ?? 0;

      content = provider.inboxDetail?.description ??
          provider.inboxPaymentDetail?.description ??
          "...";
      va = provider.inboxPaymentDetail?.field1 ?? "-";
      date = Helper.formatDate(DateTime.parse(
          ((provider.inboxDetail?.createdAt ??
                  Helper.getFormatedDateTwo(
                      provider.inboxPaymentDetail!.createdAt!))
              .replaceAll('/', '-'))));
      url = provider.inboxDetail?.link ?? provider.inboxPaymentDetail?.link;
    }
    if (mounted) {
      if (url!.contains('howTo')) {
        context.read<PPOBProvider>().getPaymentGuide(context, url!);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    scrollC = ScrollController();
    scrollC.addListener(scrollListener);

    Future.wait([getData()]);

    if (title!.length > 24) {
      titleMore = title!.substring(0, 24);
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
    return buildUI();
  }

  Widget buildUI() {
    return Consumer<InternetProvider>(
      builder: (BuildContext context, InternetProvider internetProvider,
          Widget? child) {
        return Scaffold(
          backgroundColor: ColorResources.white,
          body: internetProvider.internetStatus == InternetStatus.disconnected
              ? const NoConnectionScreen()
              : buildConnectionAvailableContent(context),
        );
      },
    );
  }

  Widget buildConnectionAvailableContent(BuildContext context) {
    return Consumer<InboxProvider>(builder: (context, inboxProvider, child) {
      if (inboxProvider.inboxDetailStatus == InboxDetailStatus.loading) {
        return const Center(
          child: CircularProgressIndicator(color: ColorResources.primary),
        );
      }
      if (inboxProvider.inboxDetailStatus == InboxDetailStatus.empty) {
        return const Center(
          child: Text('Tidak ada detail inbox.'),
        );
      }
      if (inboxProvider.inboxDetailStatus == InboxDetailStatus.error) {
        return const Center(
          child: Text('Ada yang bermasalah.'),
        );
      }
      return CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        controller: scrollC,
        slivers: [buildAppBar(context), buildBodyContent()],
      );
    });
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: ColorResources.white,
      pinned: true,
      title: Text(
        "Inbox Masuk",
        style: poppinsRegular.copyWith(
            color: ColorResources.black,
            fontSize: Dimensions.fontSizeExtraLarge,
            fontWeight: FontWeight.w600),
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
              NS.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: Dimensions.iconSizeDefault,
            ),
          )),
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
                child: Text(title ?? "...",
                    textAlign: TextAlign.start,
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: ColorResources.black,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  date ?? DateTime.now().toString(),
                  style: poppinsRegular.copyWith(
                      color: ColorResources.grey,
                      fontSize: Dimensions.fontSizeDefault),
                )),
            const Divider(
              height: 4.0,
              thickness: 1.0,
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0, bottom: 10.0),
              child: Text(
                content ?? "...",
                style: interRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: ColorResources.black,
                ),
              ),
            ),
            va!.isEmpty || va == "-" ? Container() : buildVaContent(),
            const SizedBox(
              height: 10,
            ),
            url!.isEmpty || url == "-"
                ? Container()
                : url!.contains('howTo')
                    ? buildPaymentGuideContent()
                    : buildNormalUrlContent(),
            if (widget.type == 'sos' && latitude != 0)
              SizedBox(
                  height: 35,
                  child: TextButton(
                      onPressed: () async {
                        var address = '$latitude,$longitude';
                        String googleUrl =
                            'https://www.google.com/maps/search/?api=1&query=$address';
                        if (!await launchUrl(Uri.parse(googleUrl))) {
                          throw 'Could not open the map.';
                        }
                      },
                      child: const Text('Lihat Lokasi')))
          ],
        ),
      )
    ]));
  }

  Widget buildVaContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Virtual Account',
          style: poppinsRegular.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: Dimensions.fontSizeLarge,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5.0, bottom: 10.0),
          decoration: BoxDecoration(
            color: ColorResources.greyLightPrimary.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Material(
            color: ColorResources.transparent,
            child: InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: va!));
                ShowSnackbar.snackbar(
                    context,
                    'Nomor Virtual Account sudah tersalin',
                    '',
                    ColorResources.black);
              },
              borderRadius: BorderRadius.circular(10.0),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      va ?? "...",
                      style: poppinsRegular.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorResources.greenHour,
                        fontSize: Dimensions.fontSizeExtraLarge,
                      ),
                    ),
                    const Icon(
                      Icons.copy,
                      color: ColorResources.greyDarkPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPaymentGuideContent() {
    return Consumer<PPOBProvider>(builder: (context, provider, _) {
      if (provider.paymentGuideStatus == PaymentGuideStatus.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.paymentGuideStatus == PaymentGuideStatus.error) {
        return const Center(
          child: Text('Ada yang bermasalah'),
        );
      } else {
        return Container(
          margin: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: provider.listPaymentGuide.length,
              itemBuilder: (BuildContext context, int i) {
                final PaymentGuideData data = provider.listPaymentGuide[i];
                return ExpansionTile(
                    initiallyExpanded: false,
                    title: Text(data.name!,
                        style: poppinsRegular.copyWith(
                            color: ColorResources.black,
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w600)),
                    childrenPadding: const EdgeInsets.all(10.0),
                    tilePadding: EdgeInsets.zero,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.centerLeft,
                    children: data.steps!
                        .asMap()
                        .map((int key, StepModel step) => MapEntry(
                            key,
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${step.step}. ${step.description!}",
                                style: robotoRegular.copyWith(
                                    color: ColorResources.black),
                              ),
                            )))
                        .values
                        .toList());
              }),
        );
      }
    });
  }

  Container buildNormalUrlContent() {
    return Container(
      margin: const EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: GestureDetector(
        onTap: () async {
          await launchUrlString(url!);
        },
        child: Html(
            onLinkTap:
                (String? url, Map<String, String> attributes, element) async {
              await launchUrlString(url!);
            },
            style: {
              'body': Style(
                color: ColorResources.blueDrawerPrimary,
              ),
            },
            data: url),
      ),
    );
  }
}
