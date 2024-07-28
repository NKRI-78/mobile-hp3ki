import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hp3ki/providers/feedv2/feed.dart';

import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/views/screens/feed/post_detail.dart';

import 'package:hp3ki/views/screens/feed/widgets/input_post.dart';
import 'package:hp3ki/views/screens/feed/notification.dart';
import 'package:hp3ki/views/screens/feed/posts.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';

class FeedIndex extends StatefulWidget {
  const FeedIndex({Key? key}) : super(key: key);

  @override
  FeedIndexState createState() => FeedIndexState();
}

class FeedIndexState extends State<FeedIndex> with TickerProviderStateMixin {

  late TabController tabController;
  late FeedProviderV2 feedProviderV2;

  GlobalKey g1Key = GlobalKey();
  GlobalKey g2Key = GlobalKey();
  GlobalKey g3Key = GlobalKey();

  GlobalKey<RefreshIndicatorState> refreshIndicatorKey1 = GlobalKey<RefreshIndicatorState>();
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey2 = GlobalKey<RefreshIndicatorState>();
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey3 = GlobalKey<RefreshIndicatorState>();
  
  FocusNode groupsFocusNode = FocusNode();
  FocusNode commentFocusNode = FocusNode();

  Future refresh(BuildContext context) async {
    Future.sync((){
      feedProviderV2.fetchFeedMostRecent(context);
      feedProviderV2.fetchFeedPopuler(context);
      feedProviderV2.fetchFeedSelf(context);
    });
  }

  @override
  void initState() {
    super.initState();
    feedProviderV2 = context.read<FeedProviderV2>();
    Future.delayed(Duration.zero, () {
      if(mounted) {
        feedProviderV2.fetchFeedMostRecent(context);
        feedProviderV2.fetchFeedPopuler(context);
        feedProviderV2.fetchFeedSelf(context);    
      }
    });
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }
  
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget tabSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: TabBar(
        controller: tabController,
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
        labelStyle: robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeSmall
        ),
      tabs: [
        Tab(text: getTranslated("LATEST", context)),
        Tab(text: getTranslated("POPULAR", context)),
        Tab(text: getTranslated("ME", context)),
      ]),
    );
  }

  Widget tabbarviewsection(BuildContext context) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: tabController,
      children: [

        Consumer<FeedProviderV2>(
          builder: (BuildContext context, FeedProviderV2 feedProviderv2, Widget? child) {
            if (feedProviderv2.feedRecentStatus == FeedRecentStatus.loading) {
              return const Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primary,
                ),
              );
            }
            if (feedProviderv2.feedRecentStatus == FeedRecentStatus.empty) {
              return Center(
                child: Text(getTranslated("THERE_IS_NO_POST", context), style: robotoRegular)
              );
            }
            if (feedProviderv2.feedRecentStatus == FeedRecentStatus.error) {
              return Center(
                child: Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular)
              );
            }
            return NotificationListener<ScrollNotification>(
              child: RefreshIndicator(
                backgroundColor: ColorResources.primary,
                color: ColorResources.white,
                key: refreshIndicatorKey1,
                  onRefresh: () => refresh(context),
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int i) {
                      return Container(
                        color: Colors.blueGrey[50],
                        height: 40.0,
                      );
                    },
                    physics: const AlwaysScrollableScrollPhysics(),
                    key: g1Key,
                    itemCount: feedProviderv2.forum1.length,
                    itemBuilder: (BuildContext content, int i) {
                    if (feedProviderv2.forum1.length == i) {
                      return const Center(
                        child: SpinKitThreeBounce(
                          size: 20.0,
                          color: ColorResources.primary,
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, NS.fromLeft(PostDetailScreen(postId: feedProviderV2.forum1[i].id!))).then((_) => setState(() {
                          feedProviderV2.fetchFeedMostRecent(context);
                        }));
                      },
                      child: Posts(
                        i: i,
                        forum: feedProviderV2.forum1,
                      ),
                    );
                  }
                ),
              ),
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollEndNotification) {
                  if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                    if (feedProviderv2.hasMore) {
                      feedProviderv2.loadMoreRecent(context: context);
                    }
                  }
                }
                return false;
              },
            );
          },
        ),

        Consumer<FeedProviderV2>(
          builder: (BuildContext context, FeedProviderV2 feedProviderv2, Widget? child) {
            if (feedProviderv2.feedPopulerStatus == FeedPopulerStatus.loading) {
              return const Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primary,
                ),
              );
            }
            if (feedProviderv2.feedPopulerStatus == FeedPopulerStatus.empty) {
              return Center(
                child: Text(getTranslated("THERE_IS_NO_POST", context), style: robotoRegular)
              );
            }
            if (feedProviderv2.feedPopulerStatus == FeedPopulerStatus.error) {
              return Center(
                child: Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular)
              );
            }
            return NotificationListener<ScrollNotification>(
              child: RefreshIndicator(
                backgroundColor: ColorResources.primary,
                color: ColorResources.white,
                key: refreshIndicatorKey2,
                  onRefresh: () => refresh(context),
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int i) {
                      return Container(
                        color: Colors.blueGrey[50],
                        height: 40.0,
                      );
                    },
                    physics: const AlwaysScrollableScrollPhysics(),
                    key: g2Key,
                    itemCount: feedProviderv2.forum2.length,
                    itemBuilder: (BuildContext content, int i) {
                    if (feedProviderv2.forum2.length == i) {
                      return const Center(
                        child: SpinKitThreeBounce(
                          size: 20.0,
                          color: ColorResources.primary,
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, NS.fromLeft(PostDetailScreen(postId: feedProviderV2.forum1[i].id!))).then((_) => setState(() {
                          feedProviderV2.fetchFeedPopuler(context);
                        }));
                      },
                      child: Posts(
                        i: i,
                        forum: feedProviderv2.forum2,
                      ),
                    );
                  }
                ),
              ),
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollEndNotification) {
                  if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                    if (feedProviderv2.hasMore2) {
                      feedProviderv2.loadMorePopuler(context: context);
                    }
                  }
                }
                return false;
              },
            );
          },
        ),
        
        Consumer<FeedProviderV2>(
          builder: (BuildContext context, FeedProviderV2 feedProviderv2, Widget? child) {
            if (feedProviderv2.feedSelfStatus == FeedSelfStatus.loading) {
              return const Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primary,
                ),
              );
            }
            if (feedProviderv2.feedSelfStatus == FeedSelfStatus.empty) {
              return Center(
                child: Text(getTranslated("THERE_IS_NO_POST", context), style: robotoRegular)
              );
            }
            if (feedProviderv2.feedSelfStatus == FeedSelfStatus.error) {
              return Center(
                child: Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular)
              );
            }
            return NotificationListener<ScrollNotification>(
              child: RefreshIndicator(
                backgroundColor: ColorResources.primary,
                color: ColorResources.white,
                key: refreshIndicatorKey3,
                  onRefresh: () => refresh(context),
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int i) {
                      return Container(
                        color: Colors.blueGrey[50],
                        height: 40.0,
                      );
                    },
                    physics: const AlwaysScrollableScrollPhysics(),
                    key: g3Key,
                    itemCount: feedProviderv2.forum3.length,
                    itemBuilder: (BuildContext content, int i) {
                    if (feedProviderv2.forum3.length == i) {
                      return const SpinKitThreeBounce(
                        size: 20.0,
                        color: ColorResources.primary,
                      );
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, NS.fromLeft(PostDetailScreen(postId: feedProviderV2.forum1[i].id!))).then((_) => setState(() {
                          feedProviderV2.fetchFeedSelf(context);
                        }));
                      },
                      child: Posts(
                        i: i,
                        forum: feedProviderv2.forum3,
                      ),
                    );
                  }
                ),
              ),
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollEndNotification) {
                  if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                    if (feedProviderv2.hasMore3) {
                      feedProviderv2.loadMoreSelf(context: context);
                    }
                  }
                }
                return false;
              },
            );
          },
        )
      ]
    );
  } 

  @override
  Widget build(BuildContext context) {
    return buildUI(); 
  }

  Widget buildUI() {
    return Scaffold(
     body: NestedScrollView(
       physics: const ScrollPhysics(),
       headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return [
            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              backgroundColor: ColorResources.white,
              automaticallyImplyLeading: false,
              title: Text('Community Feed',
                style: robotoRegular.copyWith(
                  color: ColorResources.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: Dimensions.fontSizeDefault
                )
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    NS.push(context, const NotificationScreen());
                  },
                  icon: const Icon(
                    Icons.notifications,
                    color: ColorResources.primary
                  ),
                ),
              ],
              elevation: 0.0,
              forceElevated: true,
              pinned: true,
              centerTitle: true,
              floating: true,
            ),
            const InputPostComponent(),
            tabSection(context)
          ];
         },
        body: tabbarviewsection(context),
      )
    );
  }
}