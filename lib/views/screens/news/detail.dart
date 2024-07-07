import 'package:hp3ki/providers/internet/internet.dart';
import 'package:hp3ki/providers/news/news.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/views/screens/connection/connection.dart';
import 'package:hp3ki/views/webview/webview.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/views/basewidgets/loader/circular.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:hp3ki/utils/extension.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class DetailNewsScreen extends StatefulWidget {


  const DetailNewsScreen({ Key? key,}) : super(key: key);
  
  @override
  _DetailInfoPageState createState() => _DetailInfoPageState();
}

class _DetailInfoPageState extends State<DetailNewsScreen> {

  String? imageUrl;
  String? title;
  String? content;
  String? titleMore;
  String? date;

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
    if(mounted){
      imageUrl = context.read<NewsProvider>().newsDetail!.image;
      title = context.read<NewsProvider>().newsDetail!.title;
      content = context.read<NewsProvider>().newsDetail!.desc;
      date = context.read<NewsProvider>().newsDetail!.createdAt;
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
      builder: (BuildContext context, InternetProvider internetProvider, Widget? child) {
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
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if(newsProvider.newsDetailStatus == NewsDetailStatus.loading) {
          return const Center(child: CircularProgressIndicator(color: ColorResources.primary,));
        }
        if(newsProvider.newsDetailStatus == NewsDetailStatus.empty) {
          return const Center(child: Text('Tidak ada detail berita.'));
        }
        if(newsProvider.newsDetailStatus == NewsDetailStatus.loading) {
          return const Center(child: Text('Ada yang salah.'));
        }
        return CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          controller: scrollC,
          slivers: [
            buildAppBar(context),
            buildBodyContent()
          ],
        );
      }
    );
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: ColorResources.white,
      pinned: true,
      expandedHeight: 250.0,
      leading: Container(
        margin: const EdgeInsets.all(8.0),
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color:  Colors.black54
        ),
        child: IconButton(
          color: ColorResources.white,
          onPressed: () {
            NS.pop(context);
          },
          icon: const Icon(Icons.arrow_back,
            size: Dimensions.iconSizeDefault,
          ),
        )
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8.0),
          height: 40.0,
          width: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Colors.black54
          ),
          child: Builder(
            builder: (BuildContext context) {
              return PopupMenuButton(
                onSelected: (int i) async {
                  switch (i) {
                    case 1:
                      ProgressDialog pr = ProgressDialog(context: context);
                      try {
                        PermissionStatus statusStorage = await Permission.storage.status;
                        if(!statusStorage.isGranted) {
                          await Permission.storage.request();
                        } 
                        pr.show(
                          max: 1,
                          msg: '${getTranslated("DOWNLOADING", context)}...'
                        );
                        await GallerySaver.saveImage(imageUrl!);
                        pr.close();
                        ShowSnackbar.snackbar(context, getTranslated("SAVE_TO_GALLERY", context), "", ColorResources.success);
                      } catch(e, stacktrace) {
                        pr.close();
                        ShowSnackbar.snackbar(context, getTranslated("THERE_WAS_PROBLEM", context), "", ColorResources.error);
                        debugPrint(stacktrace.toString());
                      }
                    break;
                    default:
                  }
                },
                icon: const Icon(Icons.more_horiz),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeSmall,
                      right: Dimensions.paddingSizeSmall
                    ),
                    textStyle: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault
                    ),
                    child: Text(getTranslated("DOWNLOAD", context),
                      style: poppinsRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: ColorResources.black
                      )
                    ),
                    value: 1,
                  ),
                ]
              );                 
            },
          ),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CachedNetworkImage(
            imageUrl: imageUrl ?? "...",
            fit: BoxFit.fitHeight,
            placeholder: (BuildContext context, String url)  {
              return Center(
                child: Image.asset('assets/images/logo/logo.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fitHeight,
                )
              );
            },
            errorWidget: (BuildContext context, String url, dynamic error) {
              return Center(
                child: Image.asset('assets/images/logo/logo.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fitHeight,
                )
              );
            }
          ),
        ),
        title: AnimatedOpacity(
          opacity: isShrink ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 150),
          child: Text(
            titleMore! + "...",
            maxLines: 1,
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              fontWeight: FontWeight.w600,
              color: ColorResources.black, 
            ),
          ),
        ),
      ),
    );
  }

  SliverList buildBodyContent() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
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
                  child: Text(title!.toTitleCase(),
                  textAlign: TextAlign.start,
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: ColorResources.black,
                      fontWeight: FontWeight.w600,
                    )
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  Helper.formatDate(DateTime.parse(Helper.getFormatedDate(date))),
                  style: poppinsRegular.copyWith(
                    color: ColorResources.grey, 
                    fontSize: Dimensions.fontSizeDefault
                  ),
                )
              ),
              const Divider(
                height: 4.0,
                thickness: 1.0,
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                child: Html(
                  onLinkTap: (String? url, Map<String, String> attributes, element) async {
                    NS.push(context, WebViewScreen(
                      url: url!,
                      title: title ?? "HP3KI Webview"
                    ));
                  },
                  style: {
                    'a': Style(
                      color: ColorResources.blueDrawerPrimary,
                    ),
                    'body': Style(
                      fontSize: FontSize.larger
                    ),
                  },
                  data: content
                ),
              ),
            ],
          ),
        )
      ])
    );
  }
}
