import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/providers/feed/feed.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/views/screens/feed/widgets/input_post.dart';
import 'package:hp3ki/views/screens/feed/posts.dart';

class FeedIndex extends StatefulWidget {
  const FeedIndex({Key? key}) : super(key: key);

  @override
  _FeedIndexState createState() => _FeedIndexState();
}

class _FeedIndexState extends State<FeedIndex> with TickerProviderStateMixin {
  late ScrollController recentFeedC;
  late ScrollController popularFeedC;
  late ScrollController selfFeedC;

  late TabController tabC;

  Future<void> refresh(BuildContext context) async {
    Future.sync((){
      context.read<FeedProvider>().fetchFeedMostRecent(context);
      context.read<FeedProvider>().fetchFeedMostPopular(context);
      context.read<FeedProvider>().fetchFeedSelf(context);
    });
  }

  Future<void> getData() async {
    Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.getBool("isAccept") == null) {
        termsAndCondition();
      } 
      if(mounted) {
        await Permission.storage.request();
        Permission.storage.isDenied.then((value) async {
          await Permission.storage.request();
        });
      }
      if(mounted) {
        context.read<FeedProvider>().fetchFeedMostRecent(context);    
      }
      if(mounted) {
        context.read<FeedProvider>().fetchFeedMostPopular(context);
      }
      if(mounted) {
        context.read<FeedProvider>().fetchFeedSelf(context);
      }
    });
  }
  
  recentFeedControllerListener() {
    if(recentFeedC.position.pixels >= recentFeedC.position.maxScrollExtent){
      context.read<FeedProvider>().loadPageRecent = true;
      context.read<FeedProvider>().fetchFeedMostRecentLoad(context);
      context.read<FeedProvider>().stopLoadPageRecent();
    }
  }
    
  popularFeedControllerListener() {
    if(popularFeedC.position.pixels >= popularFeedC.position.maxScrollExtent){
      context.read<FeedProvider>().loadPagePopular = true;
      context.read<FeedProvider>().fetchFeedMostPopularLoad(context);
      context.read<FeedProvider>().stopLoadPagePopular();
    }
  }
    
  selfFeedControllerListener() {
    if(selfFeedC.position.pixels >= selfFeedC.position.maxScrollExtent){
      context.read<FeedProvider>().loadPageSelf = true;
      context.read<FeedProvider>().fetchFeedSelfLoad(context);
      context.read<FeedProvider>().stopLoadPageSelf();
    }
  }

  @override
  void initState() {
    super.initState();

    recentFeedC = ScrollController();
    recentFeedC.addListener(recentFeedControllerListener);
    popularFeedC = ScrollController();
    popularFeedC.addListener(popularFeedControllerListener);
    selfFeedC = ScrollController();
    selfFeedC.addListener(selfFeedControllerListener);

    tabC = TabController(length: 3, vsync: this, initialIndex: 0);

    Future.microtask(() {
      getData();
    },);
  }


  @override
  void dispose() {
    tabC.dispose();

    recentFeedC.removeListener(recentFeedControllerListener);
    recentFeedC.dispose();
    popularFeedC.removeListener(popularFeedControllerListener);
    popularFeedC.dispose();
    selfFeedC.removeListener(selfFeedControllerListener);
    selfFeedC.dispose();

    super.dispose();
  }

  void termsAndCondition() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (BuildContext context, Animation<double> double, _) {
        return Center(
          child: Material(
            color: ColorResources.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              height: 580,
              decoration: BoxDecoration(
                color: ColorResources.primary, 
                borderRadius: BorderRadius.circular(20.0)
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: const EdgeInsets.only(top: 0.0, left: 0.0),
                      child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset("assets/images/background/shading-top-left.png")
                      )
                    )
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.only(top: 0.0, right: 0.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset("assets/images/background/shading-right.png")
                      )
                    )
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: const EdgeInsets.only(top: 200.0, right: 0.0),
                      child: Image.asset("assets/images/background/shading-right-bottom.png")
                    )
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Text("It's important that you understand what",
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w300,
                            color: ColorResources.white
                          ),
                        ),
                        
                        const SizedBox(height: 8.0),

                        Text("information hp3ki collects.",
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w300,
                            color: ColorResources.white
                          ),
                        ),

                        const SizedBox(height: 8.0),

                        Text("Some examples of data hp3ki collects and users are:",
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w300,
                            color: ColorResources.white
                          ),
                        ),

                        const SizedBox(height: 8.0),

                        Text("● Your Information & Content",
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w600,
                            color: ColorResources.white
                          ),
                        ),

                        const SizedBox(height: 8.0),

                        Text("This may include any information you share with us,\nfor example; your create a post and another users\ncan like your post or comment also you can delete\nyour post.",
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w300,
                            color: ColorResources.white
                          ),
                        ),

                        const SizedBox(height: 8.0),

                        Text("● Photos, Videos & Documents",
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w600,
                            color: ColorResources.white
                          ),
                        ),

                        const SizedBox(height: 8.0),

                        Text("This may include your can post on media\nphotos, videos, or documents",
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w300,
                            color: ColorResources.white
                          ),
                        ),

                        const SizedBox(height: 8.0),

                        Text("● Embedded Links",
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w600,
                            color: ColorResources.white
                          ),
                        ),

                        const SizedBox(height: 8.0),

                        Text("This may include your can post on link\nsort of news, etc",
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w300,
                            color: ColorResources.white
                          ),
                        ),
                      ]
                    ) 
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            left: 30.0,
                            right: 30.0,
                            bottom: 30.0,
                          ),
                          child: CustomButton(
                            isBorderRadius: true,
                            btnColor: ColorResources.white,
                            btnTextColor: ColorResources.primary,
                            onTap: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setBool("isAccept", true);
                              NS.pop(context);
                            }, 
                            btnTxt: "Agree"
                          ),
                        )
                      ],
                    ) 
                  )
                ],
              ),
            ),
          )
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }
        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  Widget tabSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: TabBar(
        controller: tabC,
        unselectedLabelColor: ColorResources.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ColorResources.white,
        indicator: const BubbleTabIndicator(
          indicatorHeight: 30.0,
          indicatorRadius: 10.0,
          padding: EdgeInsets.zero,
          indicatorColor: ColorResources.primary,
          tabBarIndicatorSize: TabBarIndicatorSize.tab,
        ),
        labelStyle: poppinsRegular.copyWith(
          fontSize: Dimensions.fontSizeDefault
        ),
      tabs: [
        Tab(text: getTranslated("LATEST", context)),
        Tab(text: getTranslated("POPULAR", context)),
        Tab(text: getTranslated("ME", context)),
      ]),
    );
  }

  Widget tabbarviewsection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 90.0),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabC,
        children: [
          buildFeedRecent(),
          buildFeedPopular(),
          buildFeedSelf()
        ]
      ),
    );
  }

  Consumer<FeedProvider> buildFeedRecent() {
    return Consumer<FeedProvider>(
        builder: (BuildContext context, FeedProvider feedProvider, Widget? child) {
          if (feedProvider.feedMostRecentStatus == FeedMostRecentStatus.loading) {
            return const Center(
              child: SpinKitThreeBounce(
                size: 20.0,
                color: ColorResources.primary,
              ),
            );
          }
          if (feedProvider.feedMostRecentStatus == FeedMostRecentStatus.empty) {
            return Center(
              child: Text(getTranslated("THERE_IS_NO_POST", context), style: poppinsRegular)
            );
          }
          return RefreshIndicator(
            backgroundColor: ColorResources.primary,
            color: ColorResources.white,
            onRefresh: () => refresh(context),
            child: ListView.separated(
              controller: recentFeedC,
              separatorBuilder: (BuildContext context, int i) {
                return Container(
                  color: Colors.blueGrey[50],
                  height: 20.0,
                );
              },
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: feedProvider.loadPageRecent == true 
              ? feedProvider.g1List.length + 1 
              : feedProvider.g1List.length,
              itemBuilder: (BuildContext content, int i) {
              // if (feedProvider.g1List.length == i) {
              //   return const Center(
              //     child: SpinKitThreeBounce(
              //       size: 20.0,
              //       color: ColorResources.primary,
              //     ),
              //   );
              // }
              return Posts(
                i: i,
                feedData: feedProvider.g1List,
              );
            }
          ),
        );
      },
    );
  }

  Consumer<FeedProvider> buildFeedPopular() {
    return Consumer<FeedProvider>(
        builder: (BuildContext context, FeedProvider feedProvider, Widget? child) {
          if(feedProvider.feedMostPopularStatus == FeedMostPopularStatus.loading) {
            return const SpinKitThreeBounce(
              size: 20.0,
              color: ColorResources.primary
            );
          } 
          if(feedProvider.feedMostPopularStatus == FeedMostPopularStatus.empty) {
            return Center(
              child: Text(getTranslated("THERE_IS_NO_POST", context), style: poppinsRegular)
            );
          }
          return RefreshIndicator(
            backgroundColor: ColorResources.primary,
            color: ColorResources.white,
              onRefresh: () => refresh(context),
              child: ListView.separated(
                controller: popularFeedC,
                separatorBuilder: (BuildContext context, int i) {
                  return Container(
                    color: Colors.blueGrey[50],
                    height: 20.0,
                  );
                },
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: feedProvider.loadPagePopular == true ? feedProvider.g2List.length + 1 : feedProvider.g2List.length,
                itemBuilder: (BuildContext content, int i) {
                // if (feedProvider.g2List.length == i) {
                //   return const Center(
                //     child: SpinKitThreeBounce(
                //       size: 20.0,
                //       color: ColorResources.primary,
                //     ),
                //   );
                // }
                return Posts(
                  i: i,
                  feedData: feedProvider.g2List,
                );
              }
            ),
          );
        },
      );
  }

  Consumer<FeedProvider> buildFeedSelf() {
    return Consumer<FeedProvider>(
        builder: (BuildContext context, FeedProvider feedProvider, Widget? child) {
          if(feedProvider.feedSelfStatus == FeedSelfStatus.loading) {
            return const Center(
              child: SpinKitThreeBounce(
                size: 20.0,
                color: ColorResources.primary,
              )
            );
          } 
          if(feedProvider.feedSelfStatus == FeedSelfStatus.empty) {
            return Center(
              child: Text(getTranslated("THERE_IS_NO_POST", context), 
                style: poppinsRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault
                )
              )
            );
          }
        return RefreshIndicator(
          backgroundColor: ColorResources.primary,
          color: ColorResources.white,
            onRefresh: () => refresh(context),
            child: ListView.separated(
              controller: selfFeedC,
              separatorBuilder: (BuildContext context, int i) {
                return Container(
                  color: Colors.blueGrey[50],
                  height: 20.0,
                );
              },
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: feedProvider.loadPageSelf == true ? feedProvider.g3List.length + 1 : feedProvider.g3List.length,
              itemBuilder: (BuildContext content, int i) {
              // if (feedProvider.g3List.length == i) {
              //   return const SpinKitThreeBounce(
              //     size: 20.0,
              //     color: ColorResources.primary,
              //   );
              // }
              return Posts(
                i: i,
                feedData: feedProvider.g3List,
              );
            }
          ),
        );
      },
    );
  } 

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: ColorResources.white,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      forceElevated: true,
      pinned: true,
      centerTitle: true,
      floating: true,
      title: Text('Community Feed',
        style: poppinsRegular.copyWith(
          color: ColorResources.black,
          fontSize: Dimensions.fontSizeLarge,
          fontWeight: FontWeight.bold
        ),
      ),
      leading: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildUI(); 
  }

  Widget buildUI() {
    return Scaffold(
    
    body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
        return [
          buildAppBar(context),
          const InputPostComponent(),
          tabSection(context)
        ];
      },
        body: tabbarviewsection(context),
      )
    );
  }
}