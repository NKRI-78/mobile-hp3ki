import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:hp3ki/providers/internet/internet.dart';
import 'package:hp3ki/providers/news/news.dart';

import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/screens/connection/connection.dart';

import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/extension.dart';
import 'package:hp3ki/utils/color_resources.dart';

import 'package:hp3ki/localization/language_constraints.dart';

class NewsScreen extends StatefulWidget {
  final bool? fromHome;

  const NewsScreen({
    this.fromHome,
    Key? key
  }) : super(key: key);

  @override
  State<NewsScreen> createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {

  Future<void> getData() async {
    if(mounted) {
      await context.read<NewsProvider>().getNews(context);
    }
  }
  
  @override 
  void initState() {
    super.initState();
  }

  @override 
  void dispose() {
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
          
          backgroundColor: ColorResources.greyLightPrimary,
          body: internetProvider.internetStatus == InternetStatus.disconnected
            ? const NoConnectionScreen()
            : buildConnectionAvailableContent(),
        );
      }
    );   
  }

  LayoutBuilder buildConnectionAvailableContent() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Consumer<NewsProvider>(
          builder: (BuildContext context, NewsProvider newsProvider, Widget? child) {
            return RefreshIndicator(
              backgroundColor: ColorResources.greyLightPrimary,
              color: ColorResources.primary,
              onRefresh: () {
                return Future.sync(() {
                  newsProvider.getNews(context);
                });
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  buildAppBar(context),
                  if(newsProvider.newsStatus == NewsStatus.loading) 
                    buildLoadingContent(),
                  if(newsProvider.newsStatus == NewsStatus.empty) 
                    buildLoadingContent(),
                  if(newsProvider.newsStatus == NewsStatus.loaded)        
                    buildContent(newsProvider),
                ],
              )
            );
          },
        ); 
      },
    );
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return CustomAppBar(title: 'Berita', fromHome: widget.fromHome).buildSliverAppBar(context);
  }

  SliverList buildLoadingContent() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int i) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[300]!, 
            child:  Container(
              margin: const EdgeInsets.only(
                top: Dimensions.marginSizeDefault,
                left: Dimensions.marginSizeLarge,
                right: Dimensions.marginSizeLarge  
              ),
              height: 80.0,
              decoration: BoxDecoration(
                color: ColorResources.white,
                borderRadius: BorderRadius.circular(6.0)
              ),
            )
          );
        },
        childCount: 5,
      ),
    );
  }

  SliverPadding buildContent(NewsProvider newsProvider) {
    return SliverPadding(
      padding: const EdgeInsets.only(
        top: 30.0,
        bottom: 150.0
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int i) {
            return Card(
              elevation: 8.0,
              margin: const EdgeInsets.only(
                top: 10.0, 
                left: 25.0,
                right: 25.0,
                bottom: 10.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
              ),
              color: ColorResources.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.0),
                onDoubleTap: () { },
                onTap: () async {
                  await newsProvider.getNewsDetail(
                    context,
                    newsId: newsProvider.news[i].id!,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                
                    Expanded(
                      flex: 6,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0)
                        ),
                        child: CachedNetworkImage(
                          imageUrl: newsProvider.news[i].image!,
                          imageBuilder: (BuildContext context, ImageProvider image) {
                            return Container(
                              width: double.infinity,
                              height: 125.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: image
                                )
                              ),
                            );
                          },
                          placeholder: (BuildContext context, String value) {
                            return Container(
                              width: double.infinity,
                              height: 125.0,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage("assets/images/logo/logo.png")
                                )
                              ),
                            ); 
                          },
                          errorWidget: (BuildContext context, String value, dynamic _) {
                            return Container(
                              width: double.infinity,
                              height: 125.0,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage("assets/images/logo/logo.png")
                                )
                              ),
                            );  
                          },
                        ),
                      ),
                    ),
              
                    Expanded(
                      flex: 12,
                      child: Container(
                        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(newsProvider.news[i].title.toString().length > 85 
                              ? "${newsProvider.news[i].title.toString().substring(0, 85)}..."
                              : newsProvider.news[i].title.toString().toTitleCase(),
                              style: poppinsRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(Helper.formatDate(DateTime.parse(Helper.getFormatedDate(newsProvider.news[i].createdAt))),
                                  style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: ColorResources.grey,
                                  ),
                                ),
                                Text(getTranslated('READ_MORE', context),
                                  style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: ColorResources.primary,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    )
                  ],
                ),
              ),
            );
          },
          childCount: newsProvider.news.length
        )
      ),
    );
  }
}