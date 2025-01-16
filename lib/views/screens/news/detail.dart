import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';

import 'package:hp3ki/providers/news/news.dart';

import 'package:hp3ki/views/webview/webview.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsId;

  const NewsDetailScreen({
    required this.newsId,
    Key? key,
  }) : super(key: key);

  @override
  NewsDetailScreenState createState() => NewsDetailScreenState();
}

class NewsDetailScreenState extends State<NewsDetailScreen> {
  bool loading = false;

  String imageUrl = "";
  String title = "";
  String content = "";
  String titleMore = "";
  String date = "";

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

    if (!mounted) return;
    await context
        .read<NewsProvider>()
        .getNewsDetail(context, newsId: widget.newsId.toString());

    setState(() {
      loading = false;
    });

    imageUrl = loading
        ? "..."
        : context.read<NewsProvider>().newsDetail!.image.toString();
    title = loading
        ? "..."
        : context.read<NewsProvider>().newsDetail!.title.toString();
    content = loading
        ? "..."
        : context.read<NewsProvider>().newsDetail!.desc.toString();
    date =
        loading ? "..." : context.read<NewsProvider>().newsDetail!.createdAt!;

    if (title.length > 24) {
      titleMore = title.substring(0, 24);
    } else {
      titleMore = title;
    }
  }

  @override
  void initState() {
    super.initState();

    scrollC = ScrollController();
    scrollC.addListener(scrollListener);

    Future.microtask(() => getData());
  }

  @override
  void dispose() {
    scrollC.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.white,
        body: Consumer<NewsProvider>(builder: (context, newsProvider, child) {
          if (newsProvider.newsDetailStatus == NewsDetailStatus.loading) {
            return const Center(
                child: CircularProgressIndicator(
              color: ColorResources.primary,
            ));
          }
          if (newsProvider.newsDetailStatus == NewsDetailStatus.empty) {
            return const Center(child: Text('Tidak ada detail berita.'));
          }
          if (newsProvider.newsDetailStatus == NewsDetailStatus.loading) {
            return const Center(child: Text('Ada yang salah.'));
          }
          return CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            controller: scrollC,
            slivers: [buildAppBar(context), buildBodyContent()],
          );
        }));
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
          )),
      actions: [
        Container(
          margin: const EdgeInsets.all(8.0),
          height: 40.0,
          width: 40.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0), color: Colors.black54),
          child: Builder(
            builder: (BuildContext context) {
              return PopupMenuButton(
                  onSelected: (int i) async {
                    switch (i) {
                      case 1:
                        ProgressDialog pr = ProgressDialog(context: context);
                        try {
                          PermissionStatus statusStorage =
                              await Permission.storage.status;
                          if (!statusStorage.isGranted) {
                            await Permission.storage.request();
                          }
                          pr.show(
                              max: 1,
                              msg:
                                  '${getTranslated("DOWNLOADING", context)}...');
                          await GallerySaver.saveImage(imageUrl);
                          pr.close();
                          ShowSnackbar.snackbar(
                              getTranslated("SAVE_TO_GALLERY", context),
                              "",
                              ColorResources.success);
                        } catch (e, stacktrace) {
                          pr.close();
                          ShowSnackbar.snackbar(
                              getTranslated("THERE_WAS_PROBLEM", context),
                              "",
                              ColorResources.error);
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
                              right: Dimensions.paddingSizeSmall),
                          textStyle: poppinsRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault),
                          child: Text(getTranslated("DOWNLOAD", context),
                              style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: ColorResources.black)),
                          value: 1,
                        ),
                      ]);
            },
          ),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.fitHeight,
              placeholder: (BuildContext context, String url) {
                return Center(
                    child: Image.asset(
                  'assets/images/logo/logo-aspro.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fitHeight,
                ));
              },
              errorWidget: (BuildContext context, String url, dynamic error) {
                return Center(
                    child: Image.asset(
                  'assets/images/logo/logo-aspro.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fitHeight,
                ));
              }),
        ),
        title: AnimatedOpacity(
          opacity: isShrink ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 150),
          child: Text(
            titleMore + "...",
            maxLines: 1,
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              fontWeight: FontWeight.bold,
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
          mainAxisSize: MainAxisSize.min,
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
                    )),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  date,
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
              child: HtmlWidget(
                content.toString(),
                onTapUrl: (String? val) {
                  debugPrint(val.toString());
                  return false;
                },
                customStylesBuilder: (element) {
                  if (element.localName == 'body') {
                    return {'margin': '0', 'padding': '0'};
                  }
                  return null;
                },
                customWidgetBuilder: (element) {
                  if (element.localName == 'a') {
                    final url = element.attributes['href'];
                    NS.push(context, WebViewScreen(url: url!, title: title));

                    return null;
                  }

                  if (element.localName == 'span') {
                    final text = element.text.trim();
                    if (text.contains('https://')) {
                      final url = text.substring(text.indexOf('https://'));
                      NS.push(context, WebViewScreen(url: url, title: title));

                      return null;
                    }
                  }

                  return null;
                },
              ),

              //  Html(
              //   onLinkTap: (String? url, Map<String, String> attributes, element) async {
              //     NS.push(context, WebViewScreen(
              //       url: url!,
              //       title: title
              //     ));
              //   },
              //   style: {
              //     'a': Style(
              //       color: ColorResources.blueDrawerPrimary,
              //     ),
              //     'body': Style(
              //       fontSize: FontSize.larger
              //     ),
              //   },
              //   data: content
              // ),
            ),
          ],
        ),
      )
    ]));
  }
}
