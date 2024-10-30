import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hp3ki/providers/ecommerce/ecommerce.dart';
import 'package:hp3ki/views/screens/ecommerce/product/widget/product_item.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/views/basewidgets/button/bounce.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';

import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/utils/extension.dart';
import 'package:hp3ki/utils/box_shadow.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/helper.dart';

import 'package:hp3ki/data/models/user/user.dart';

import 'package:hp3ki/providers/banner/banner.dart';
import 'package:hp3ki/providers/inbox/inbox.dart';
import 'package:hp3ki/providers/location/location.dart';
import 'package:hp3ki/providers/news/news.dart';
import 'package:hp3ki/providers/profile/profile.dart';
import 'package:hp3ki/providers/firebase/firebase.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/views/screens/about/about_menu.dart';
import 'package:hp3ki/views/screens/auth/sign_in.dart';
import 'package:hp3ki/views/screens/calendar/calendar.dart';
import 'package:hp3ki/views/screens/checkin/checkin.dart';
import 'package:hp3ki/views/screens/ecommerce/product/products.dart';
import 'package:hp3ki/views/screens/feed/index.dart';
import 'package:hp3ki/views/screens/maintain/maintain.dart';
import 'package:hp3ki/views/screens/media/media.dart';
import 'package:hp3ki/views/screens/membernear/membernear.dart';
import 'package:hp3ki/views/screens/news/detail.dart';
import 'package:hp3ki/views/screens/notification/index.dart';
import 'package:hp3ki/views/screens/profile/profile.dart';
import 'package:hp3ki/views/screens/sos/indexv2.dart';
import 'package:hp3ki/views/screens/news/index.dart';

class DashboardScreen extends StatefulWidget {
  final int? index;

  const DashboardScreen({Key? key, this.index}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late PanelController panelC;

  int selectedIndex = 0;

  dynamic currentBackPressTime;

  List widgetOptions = [];

  void onItemTapped(int index) {
    final String membershipStatus = SharedPrefs.getUserMemberType().trim();

    if(index == 2) {
      if (membershipStatus != "PLATINUM" || membershipStatus == "-") {
        context.read<ProfileProvider>().showNonPlatinumLimit(context);
        return;
      }
    }

    setState(() {
      panelC.close();
      selectedIndex = index;
    });
  }

  Future<bool> willPopScope() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
      now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ShowSnackbar.snackbar(getTranslated("PRESS_TWICE_BACK", context), "", ColorResources.primary);
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(true);
  }

  Future<void> getData1() async {
    if (mounted) {
      setState(() {
        widgetOptions = [
          const HomeScreen(),
          const NewsScreen(fromHome: true),
          const FeedIndex(),
          const NotificationScreen(),
        ];
      });
    }
  }

  Future<void> getData2() async {
    if (mounted) {
      setState(() {
        widgetOptions = [
          const HomeScreen(),
          const NewsScreen(fromHome: true),
          const FeedIndex(),
          const NotificationScreen(),
        ];
      });
    }
  }

  Future<void> getData() async {
    if (!mounted) return;
      await context.read<ProfileProvider>().remote();
    if (!mounted) return;
      await context.read<EcommerceProvider>().fetchAllProduct(search: "");
  }

  @override
  void initState() {
    super.initState();

    panelC = PanelController();

    selectedIndex = widget.index == null 
    ? 0 
    : widget.index!;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.read<ProfileProvider>().isActive == 1) {
        getData1();
      } else {
        getData2();
      }
    });

    Future.microtask(() => getData());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPopScope,
      child: Scaffold(
        key: scaffoldKey,
        endDrawerEnableOpenDragGesture: false,
        extendBody: true,
        body: !SharedPrefs.isLoggedIn()
      ? widgetOptions.elementAt(selectedIndex)
      : SlidingUpPanel(
          controller: panelC,
          maxHeight: MediaQuery.of(context).size.height,
          color: Colors.transparent,
          panelSnapping: true,
          panel: buildMenuPanel(),
          body: widgetOptions.isEmpty
          ? const SizedBox()
          : widgetOptions.elementAt(selectedIndex),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: !SharedPrefs.isLoggedIn() 
        ? const SizedBox() 
        : buildMenuBar(),
        bottomNavigationBar: !SharedPrefs.isLoggedIn() 
        ? const SizedBox() 
        : buildNavbar(),
      ),
    );
  }

  Widget buildMenuPanel() {
    List menu = [
      {
        "name": "HP3KI",
        "icon": "logo/logo.png",
        "screen": const AboutMenuScreen(),
      },
      {
        "name": "PPOB",
        "icon": "bottomsheet/icon-ppob.png",
        "screen": const MaintainScreen(),
      },
      {
        "name": "TopUp",
        "icon": "bottomsheet/icon-topup.png",
        "screen": const MaintainScreen(),
      },
      {
        "name": "SOS",
        "icon": "bottomsheet/icon-sos.png",
        "screen": const SosScreenV2(),
      },
      {
        "name": "Media",
        "icon": "bottomsheet/icon-media.png",
        "screen": const MediaScreen(),
      },
      {
        "name": "Check-In",
        "icon": "bottomsheet/icon-checkin.png",
        "screen": const CheckInScreen(),
      },
      {
        "name": "Calender",
        "icon": "bottomsheet/icon-event.png",
        "screen": const CalendarScreen(),
      },
      {
        "name": "Member Near",
        "icon": "bottomsheet/icon-membernear.png",
        "screen": const MembernearScreen(),
      },
      {
        "name": "Mart",
        "icon": "bottomsheet/icon-mart.png",
        "screen": const ProductsScreen(),
      },
    ];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Image.asset(
            'assets/images/bottomsheet/bottomsheet.png',
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        Align(
          alignment: const Alignment(0, 0.3),
          child: AlignedGridView.count(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()
            ),
            crossAxisCount: 3,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 2.0,
            shrinkWrap: true,
            itemCount: menu.length,
            padding: const EdgeInsets.symmetric(horizontal: 75.0),
            itemBuilder: (context, index) {
           
              // return menu[index]["name"] == "Mart" ||
              //         menu[index]["name"] == "SOS" ||
              //         menu[index]["name"] == "Calender"
              //     ? context.watch<ProfileProvider>().isActive != 1
              //         ? const SizedBox()
              //         : Column(
              //             children: [
              //               Bouncing(
              //                 onPress: () {
              //                   final String membershipStatus =
              //                       SharedPrefs.getUserMemberType().trim();
              //                   final selectedMenu = menu[index];
              //                   final String selectedMenuName =
              //                       selectedMenu["name"];
              //                   final selectedMenuScreen =
              //                       selectedMenu["screen"];
              //                   if (membershipStatus != "PLATINUM" ||
              //                       membershipStatus == "-") {
              //                     if (selectedMenuName.contains("Member") ||
              //                         selectedMenuName.contains('Check') ||
              //                         selectedMenuName.contains('SOS')) {
              //                       context
              //                           .read<ProfileProvider>()
              //                           .showNonPlatinumLimit(context);
              //                     } else {
              //                       NS.push(context, selectedMenuScreen);
              //                     }
              //                   } else {
              //                     NS.push(context, selectedMenuScreen);
              //                   }
              //                 },
              //                 child: Container(
              //                   height: 80.0,
              //                   width: 80.0,
              //                   padding: const EdgeInsets.all(10.0),
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(25.0),
              //                     boxShadow: kElevationToShadow[2],
              //                     color: const Color(0xffE7E4F5),
              //                   ),
              //                   child: Image.asset(
              //                       'assets/images/${menu[index]["icon"]}'),
              //                 ),
              //               ),
              //               const SizedBox(
              //                 height: 10,
              //               ),
              //               Text(
              //                 menu[index]["name"],
              //                 style: poppinsRegular.copyWith(
              //                   color: const Color(0xff101660),
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //               )
              //             ],
              //           )
              //     :
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Bouncing(
                    onPress: () {
                      final String membershipStatus = SharedPrefs.getUserMemberType().trim();

                      final selectedMenu = menu[index];
                      final String selectedMenuName = selectedMenu["name"];
                      final selectedMenuScreen = selectedMenu["screen"];

                      if (membershipStatus != "PLATINUM" || membershipStatus == "-") {
                        if (selectedMenuName.contains("Member") || selectedMenuName.contains('Check') || selectedMenuName.contains('SOS')) {
                          context.read<ProfileProvider>().showNonPlatinumLimit(context);
                        } else {
                          NS.push(context, selectedMenuScreen);
                        }
                      } else {
                        NS.push(context, selectedMenuScreen);
                      }
                    },
                    child: Container(
                      height: 80.0,
                      width: 80.0,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: kElevationToShadow[2],
                        color: const Color(0xffE7E4F5),
                      ),
                      child:
                          Image.asset('assets/images/${menu[index]["icon"]}'),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    menu[index]["name"],
                    style: poppinsRegular.copyWith(
                      color: const Color(0xff101660),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  InkWell buildMenuBar() {
    return InkWell(
      onTap: () {
        if (panelC.isPanelOpen) {
          panelC.close();
        } else {
          panelC.open();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            const BoxShadow(
              color: ColorResources.white,
              spreadRadius: -5.0,
              blurRadius: 5.0,
            ),
            BoxShadow(
              color: ColorResources.primary.withOpacity(0.9),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/home/sidebar.png',
            width: 45.0,
            height: 45.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildNavbar() {
    const placeholder = Opacity(
      opacity: 0,
      child: IconButton(icon: Icon(Icons.no_cell), onPressed: null),
    );

    return BottomAppBar(
      color: ColorResources.transparent,
      height: 90,
      notchMargin: 12,
      child: SizedBox(
          // height: 120,
          width: double.infinity,
          child: Consumer<ProfileProvider>(
            builder: (__, profile, _) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    bottom: -(MediaQuery.of(context).padding.bottom),
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/images/home/navbar.png',
                      fit: BoxFit.fill,
                      // height: 200,
                      width: double.infinity,
                      height: Platform.isAndroid ? 100 : 150,
                      // height: 400,
                    ),
                  ),
                  profile.isActive == 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildNavbarItem(
                                  index: 0,
                                  image: "navbar-home",
                                  label: "HOME"),
                              buildNavbarItem(
                                  index: 1,
                                  image: "navbar-news",
                                  label: "NEWS"),
                              placeholder,
                              buildNavbarItem(
                                  index: 2,
                                  image: "navbar-forum",
                                  label: "FORUM"),
                              buildNotificationItem(),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildNavbarItem(
                                  index: 0,
                                  image: "navbar-home",
                                  label: "HOME"),
                              buildNavbarItem(
                                  index: 1,
                                  image: "navbar-news",
                                  label: "NEWS"),
                              placeholder,
                              buildNavbarItem(
                                  index: 2,
                                  image: "navbar-forum",
                                  label: "FORUM"),
                              buildNotificationItem(),
                            ],
                          ),
                        ),
                ],
              );
            },
          )),
    );
  }

  Consumer<InboxProvider> buildNotificationItem() {
    return Consumer<InboxProvider>(builder: (BuildContext context, InboxProvider inboxProvider, Widget? child) {
      if (inboxProvider.inboxCountStatus == InboxCountStatus.loading) {
        return buildNavbarItem(index: 3, image: "navbar-notif", label: "NOTIFICATION");
      } else if (inboxProvider.inboxCountStatus == InboxCountStatus.empty) {
        return buildNavbarItem(index: 3, image: "navbar-notif", label: "NOTIFICATION");
      } else if (inboxProvider.inboxCountStatus == InboxCountStatus.error) {
        return buildNavbarItem(index: 3, image: "navbar-notif", label: "NOTIFICATION");
      } else {
        return buildNavbarItem(index: 3, image: "navbar-notif", label: "NOTIFICATION");
        // b.Badge(
        //  position: const b.BadgePosition(
        //    end: 15.0,
        //    top: 0.0,
        //  ),
        //  badgeColor: ColorResources.error,
        //  badgeContent: Text(
        //  inboxProvider.readCount?.toString() ?? "...",
        //   style: poppinsRegular.copyWith(
        //     fontWeight: FontWeight.bold,
        //     color: ColorResources.white,
        //   ),
        // ),
        // child: );
      }
    });
  }

  Widget buildNavbarItem({
    required int index, 
    required String image, required String label}) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        children: [
          IconButton(
            onPressed: () => onItemTapped(index),
            icon: image == "navbar-news"
            ? const Icon(Icons.newspaper)
            : Image.asset('assets/images/home/$image.png',
              width: 30.0,
              height: 30.0,
              fit: BoxFit.fill,
              color: selectedIndex == index
              ? ColorResources.white
              : ColorResources.white.withOpacity(0.7),
            ),
            color: ColorResources.white,
          ),
          GlowText(
            getTranslated(label, context),
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              fontWeight: FontWeight.w500,
              color: selectedIndex == index
              ? ColorResources.white
              : ColorResources.white.withOpacity(0.7),
            ),
            glowColor: selectedIndex == index
            ? Colors.amberAccent
            : ColorResources.transparent,
            blurRadius: 10.0,
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  int currentIndex = 0;

  Future<void> getData() async {
    if (mounted) {
      await Geolocator.requestPermission();
    }
    if (mounted) {
      await Permission.notification.request();
    }
    if (mounted) {
      await Permission.photos.request();
    }
    if (mounted) {
      context.read<NewsProvider>().getNews(context);
    }
    if (mounted) {
      context.read<BannerProvider>().getBanner(context);
    }
    if (SharedPrefs.isLoggedIn()) {
      if (mounted) {
        Future.delayed(const Duration(seconds: 1), () {
          if (SharedPrefs.getUserFulfilledDataStatus() == false) {
            context.read<ProfileProvider>().showFullFillDataDialog(context);
          }
        });
      }
      if (mounted) {
        context.read<ProfileProvider>().getProfile(context);
      }
      if (mounted) {
        context.read<FirebaseProvider>().initFcm(context);
      }
      if (mounted) {
        // context.read<PPOBProvider>().initPaymentGatewayFCM(context);
      }
      if (mounted) {
        // context.read<PPOBProvider>().createWalletData(context);
      }
      if (mounted) {
        // context.read<PPOBProvider>().getBalance(context);
      }
      if (mounted) {
        context.read<ProfileProvider>().remote();
      }
      if (mounted) {
        context.read<LocationProvider>().getCurrentPosition(context);
      }
      if (mounted) {
        // await context.read<InboxProvider>().getReadCount(context);
      }
    }
  }

  @override
  void initState() {

    Future.wait([
      getData(),
      // initShop(),
    ]);

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
    return Scaffold(
      backgroundColor: ColorResources.transparent,
      body: Container(
        decoration: buildBackgroundImage(),
        child: RefreshIndicator(
          color: ColorResources.primary,
          onRefresh: () {
            return Future.sync(() {
              context.read<ProfileProvider>().remote();
              context.read<ProfileProvider>().getProfile(context);
              context.read<NewsProvider>().getNews(context);
              context.read<BannerProvider>().getBanner(context);
              context.read<FirebaseProvider>().initFcm(context);
              // context.read<PPOBProvider>().initPaymentGatewayFCM(context);
              // context.read<PPOBProvider>().getBalance(context);
              // context.read<InboxProvider>().getReadCount(context);
              context.read<LocationProvider>().getCurrentPosition(context);
            });
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              buildUserInfoBox(),
              buildBannerCarousel(),
              const SliverToBoxAdapter(
                  child: SizedBox(
                height: 30,
              )),
              buildNewsSection(),
              const SliverToBoxAdapter(
                  child: SizedBox(
                height: 30,
              )),
              buildProductsSection(),
              const SliverToBoxAdapter(
                  child: SizedBox(
                height: 50,
              )),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration buildBackgroundImage() {
    return const BoxDecoration(
        backgroundBlendMode: BlendMode.darken,
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ColorResources.primary,
              Color.fromARGB(255, 12, 59, 153),
            ]),
        image: DecorationImage(
          image: AssetImage('assets/images/background/bg.png'),
          opacity: 0.7,
          fit: BoxFit.cover,
        ));
  }

  Widget buildUserInfoBox() {
    if (context.read<ProfileProvider>().profileStatus ==
        ProfileStatus.loading) {
      return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.only(
            top: 80.0,
            left: Dimensions.marginSizeLarge,
            right: Dimensions.marginSizeLarge,
            bottom: Dimensions.marginSizeLarge,
          ),
          child: Shimmer.fromColors(
            highlightColor: Colors.grey[200]!,
            baseColor: Colors.grey[300]!,
            child: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Container(
                height: 80.0,
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.marginSizeExtraSmall,
                    vertical: Dimensions.marginSizeSmall),
              ),
            ),
          ),
        ),
      );
    } else {
      return SliverToBoxAdapter(
        child: !SharedPrefs.isLoggedIn()
          ? Container(
          margin: const EdgeInsets.only(
            top: 80.0,
            left: Dimensions.marginSizeLarge,
            right: Dimensions.marginSizeLarge,
          ),
          child: Material(
              color: ColorResources.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15.0),
                onTap: () {
                  NS.pushDown(context, const SignInScreen());
                },
                child: Hero(
                  tag: 'userBox',
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 10.0,
                    color: const Color.fromARGB(141, 68, 99, 158)
                        .withOpacity(0.7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.marginSizeExtraSmall,
                            vertical: Dimensions.marginSizeSmall),
                        child: Center(
                            child: Text(
                          "Login",
                          style: poppinsRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: ColorResources.white),
                        ))),
                  ),
                ),
              )),
        )
      : Container(
          margin: const EdgeInsets.only(
            top: 80.0,
            left: Dimensions.marginSizeLarge,
            right: Dimensions.marginSizeLarge,
          ),
          child: Material(
            color: ColorResources.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: () {
                NS.pushDown(context, const ProfileScreen());
              },
              child: Hero(
                tag: 'userBox',
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 10.0,
                  color: const Color.fromARGB(141, 68, 99, 158)
                      .withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.marginSizeExtraSmall,
                        vertical: Dimensions.marginSizeSmall),
                    child: ListTile(
                      horizontalTitleGap: 0.0,
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 40.0,
                        child: Consumer<ProfileProvider>(
                          builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {

                            if (profileProvider.profileStatus == ProfileStatus.loading) {
                              return const CircleAvatar(
                                backgroundColor:ColorResources.backgroundDisabled,
                                maxRadius: 40.0,
                              );
                            }

                            if (profileProvider.profileStatus == ProfileStatus.error) {
                              return const CircleAvatar(
                                backgroundColor:ColorResources.backgroundDisabled,
                                maxRadius: 40.0,
                              );
                            }
                            
                            UserData? user = profileProvider.user;

                            return CachedNetworkImage(
                              imageUrl: user?.avatar.toString() ?? "",
                              imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                                return CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  maxRadius: 40.0,
                                  backgroundImage: imageProvider,
                                );
                              },
                              errorWidget: (BuildContext context, String url, dynamic error) {
                                return Image.asset("assets/images/icons/ic-person.png");
                              },
                            );
                          },

                        ),
                      ),
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getTranslated("WELCOME", context),
                            style: poppinsRegular.copyWith(
                              color: ColorResources.white,
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.shopping_bag,
                                size: Dimensions.iconSizeSmall,
                                color: ColorResources.white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(getTranslated('MY_BALANCE', context),
                                style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: ColorResources.white
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              context.watch<ProfileProvider>().profileStatus == ProfileStatus.loading
                              ? "..."
                              : context.watch<ProfileProvider>().profileStatus == ProfileStatus.error
                              ? "-"
                              : 'Hi, ${context.read<ProfileProvider>().user?.fullname?.smallSentence() ?? "..."}',
                              maxLines: 1,
                              style: poppinsRegular.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.fontSizeExtraLarge,
                                color: ColorResources.white
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              Helper.formatCurrency(0),
                              textAlign: TextAlign.right,
                              style: poppinsRegular.copyWith(
                                color: ColorResources.white,
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget buildBannerCarousel() {
    return SliverToBoxAdapter(
      child: Consumer<BannerProvider>(
        builder: (BuildContext context, BannerProvider bannerProvider,
            Widget? child) {
          if (bannerProvider.bannerStatus == BannerStatus.loading) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[200]!,
              child: Container(
                height: 175.0,
                margin: const EdgeInsets.only(
                    top: 5.0, left: 25.0, right: 25.0, bottom: 20.0),
                decoration: BoxDecoration(
                  color: ColorResources.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            );
          } else if (bannerProvider.bannerStatus == BannerStatus.empty ||
              bannerProvider.bannerStatus == BannerStatus.error) {
            return Container(
              height: 180.0,
              margin: const EdgeInsets.only(
                top: 15.0,
                left: 25.0,
                right: 25.0,
              ),
              child: Center(
                  child: Column(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: ColorResources.backgroundDisabled,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/icons/ic-empty.png'),
                          fit: BoxFit.contain,
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Banner belum tersedia',
                    style: robotoRegular.copyWith(
                      color: ColorResources.white,
                    ),
                  )
                ],
              )),
            );
          } else {
            return Container(
              height: 220.0,
              width: double.infinity,
              margin: const EdgeInsets.only(
                top: Dimensions.marginSizeExtraLarge,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0)
              ),
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  initialPage: currentIndex,
                  onPageChanged: (int i, CarouselPageChangedReason reason) {
                    currentIndex = i;
                    setState(() {});
                  }),
                  itemCount: bannerProvider.banners!.length,
                  itemBuilder: (BuildContext context, int i, int z) {
                  return CachedNetworkImage(
                    imageUrl: bannerProvider.banners![i].path!,
                    imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                      return Card(
                        margin: EdgeInsets.zero,
                        color: ColorResources.transparent,
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                              fit: BoxFit.fill, 
                              image: imageProvider
                            ),
                          ),
                        ),
                      );
                    },
                    placeholder: (BuildContext context, String text) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[200]!,
                        child: Card(
                          margin: EdgeInsets.zero,
                          color: ColorResources.white,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: const DecorationImage(
                              fit: BoxFit.scaleDown, 
                              image: AssetImage('assets/images/logo/app-icon.png')
                            ),
                          ),
                        ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                        return Card(
                        margin: EdgeInsets.zero,
                        color: ColorResources.transparent,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: const DecorationImage(
                              fit: BoxFit.scaleDown, 
                              image: AssetImage('assets/images/logo/app-icon.png')
                            ),
                          ),
                        ),
                      );  
                    },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildNewsSection() {
    return SliverToBoxAdapter(child: Consumer<NewsProvider>(builder:
        (BuildContext context, NewsProvider newsProvider, Widget? child) {
      if (newsProvider.newsStatus == NewsStatus.loading) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[200]!,
          child: Container(
            height: 250.0,
            margin: const EdgeInsets.only(
                top: 5.0, left: 25.0, right: 25.0, bottom: 20.0),
            decoration: BoxDecoration(
              color: ColorResources.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        );
      } else if (newsProvider.newsStatus == NewsStatus.empty ||
          newsProvider.newsStatus == NewsStatus.error) {
        return Container(
          height: 250.0,
          margin: const EdgeInsets.only(
            top: 15.0,
            left: 25.0,
            right: 25.0,
          ),
          child: Center(
              child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: ColorResources.backgroundDisabled,
                ),
                child: const Icon(
                  Icons.newspaper_rounded,
                  size: 80,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Berita belum tersedia',
                style: robotoRegular.copyWith(
                  color: ColorResources.white,
                ),
              )
            ],
          )),
        );
      } else {
        return Column(children: [
          Padding(
            padding: const EdgeInsets.only(
              left: Dimensions.marginSizeExtraLarge,
              right: Dimensions.marginSizeExtraLarge,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Berita',
                  style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.white,
                      shadows: boxShadow),
                ),
                GestureDetector(
                  onTap: () => NS.push(context, const NewsScreen()),
                  child: Text(
                    'Lihat Semua',
                    style: poppinsRegular.copyWith(
                        color: ColorResources.yellowSecondaryV5,
                        shadows: boxShadow),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 250,
            width: double.infinity,
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: Dimensions.marginSizeExtraLarge,
              ),
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              scrollDirection: Axis.horizontal,
              itemCount: newsProvider.news.length.clamp(0, 3),
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      NS.push(context, NewsDetailScreen(
                        newsId: newsProvider.news[i].id!,
                      ));
                    },
                    child: Stack(
                      children: [
                        const SizedBox(
                          height: 300,
                          width: 300,
                        ),
                        Positioned(
                          top: 40.0,
                          child: Material(
                            color: ColorResources.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30.0),
                              onTap: () {
                                NS.push(context, NewsDetailScreen(
                                  newsId: newsProvider.news[i].id!,
                                ));
                              },
                              child: Container(
                                height: 200.0,
                                width: 300.0,
                                decoration: BoxDecoration(
                                  boxShadow: boxShadow,
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: const Color.fromARGB(141, 68, 99, 158)
                                      .withOpacity(0.7),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const SizedBox(
                                      height: 60,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                        left: Dimensions.marginSizeExtraLarge,
                                        right: Dimensions.marginSizeExtraLarge,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            newsProvider.news[i].title
                                                        .toString()
                                                        .length >
                                                    85
                                                ? "${newsProvider.news[i].title.toString().substring(0, 85)}..."
                                                : newsProvider.news[i].title
                                                    .toString()
                                                    .toTitleCase(),
                                            style: robotoRegular.copyWith(
                                              color: ColorResources.white
                                                  .withOpacity(0.8),
                                              fontSize:
                                                  Dimensions.fontSizeDefault,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                Helper.formatDate(
                                                    DateTime.parse(
                                                        Helper.getFormatedDate(
                                                            newsProvider
                                                                .news[i]
                                                                .createdAt))),
                                                style: robotoRegular.copyWith(
                                                  color:
                                                      ColorResources.hintColor,
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                getTranslated(
                                                    "READ_MORE", context),
                                                style: robotoRegular.copyWith(
                                                  color: Colors.amberAccent,
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 25.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: CachedNetworkImage(
                              imageUrl: newsProvider.news[i].image!,
                              imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                                return Container(
                                  width: 250.0,
                                  height: 140.0,
                                  decoration: BoxDecoration(
                                    color: ColorResources.white,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    )
                                  ),
                                );
                              },
                              placeholder: (BuildContext context, String value) {
                                return Container(
                                  width: 250.0,
                                  height: 140.0,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: AssetImage("assets/images/logo/logo.png")
                                    )
                                  ),
                                ); 
                              },
                              errorWidget: (BuildContext context, String value, dynamic _) {
                                return Container(
                                  width: 250.0,
                                  height: 140.0,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: AssetImage("assets/images/logo/logo.png")
                                    )
                                  ),
                                );  
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ]);
      }
    }));
  }

  Widget buildProductsSection() {
    return SliverToBoxAdapter(
      child: Consumer<NewsProvider>(
        builder: (context, provider, _) {
          if (provider.newsStatus == NewsStatus.loading) {
            return Container(
              margin: const EdgeInsets.only(
                left: Dimensions.marginSizeLarge,
                right: Dimensions.marginSizeLarge,
              ),
              child: Shimmer.fromColors(
                highlightColor: Colors.grey[200]!,
                baseColor: Colors.grey[300]!,
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Container(
                    height: 400.0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.marginSizeExtraSmall,
                        vertical: Dimensions.marginSizeSmall),
                  ),
                ),
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: Dimensions.marginSizeExtraLarge,
                    right: Dimensions.marginSizeExtraLarge,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text('Mart',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge,
                          fontWeight: FontWeight.bold,
                          color: ColorResources.white,
                          shadows: boxShadow
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          NS.push(context, const ProductsScreen());
                        },
                        child: Text('Lihat semua',
                          style: robotoRegular.copyWith(
                            color: ColorResources.yellowSecondaryV5,
                            shadows: boxShadow
                          ),
                        ),
                      )

                    ],
                  ),
                ),
                const SizedBox(height: 10),

                Consumer<EcommerceProvider>(
                  builder: (_, notifier, __) {

                    if(notifier.listProductStatus == ListProductStatus.loading) {
                      return const SizedBox(
                        height: 300.0,
                        child: Center(
                          child: SizedBox(
                            width: 16.0,
                            height: 16.0,
                            child: CircularProgressIndicator(
                              color: ColorResources.white,  
                            ),
                          )
                        )
                      );
                    }

                    if(notifier.listProductStatus == ListProductStatus.empty) {
                      return SizedBox(
                        height: 300.0,
                        child: Center(
                          child: Text("Yaa.. Produk tidak ditemukan",
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: ColorResources.white
                            ),
                          )
                        )
                      );
                    }

                    return SizedBox(
                      height: 300.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          left: 16.0,
                          right: 16.0
                        ),
                        itemCount: notifier.products.take(5).length,
                        itemBuilder: (BuildContext context, int index) {
                          final product = notifier.products[index];
                          return ProductItem(product: product);
                        },
                      ),
                    );

                  },
                ),
             
                //TO AVOID OVERLAPS WITH THE BOTTOM NAVBAR
                //THE HEIGHT IS BASED ON (NAVBAR'S HEIGHT + 40)
                const SizedBox(
                  height: 130,
                )

              ]
            );
          }
        },
      ),
    );
  }
}
