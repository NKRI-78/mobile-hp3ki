import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hp3ki/views/screens/notification/detail.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as b;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/views/screens/notification/transaction_notif_list.dart';

import 'package:hp3ki/providers/inbox/inbox.dart';

import 'package:hp3ki/data/models/inbox/inbox.dart';
import 'package:hp3ki/data/models/inbox/inbox_payment.dart';

import 'package:hp3ki/utils/extension.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> with TickerProviderStateMixin {

  late ScrollController inboxInfoViewC;
  late ScrollController inboxPaymentViewC;
  late ScrollController inboxPanicViewC;

  late TabController tabC;

  int index = 0;

  TabBar get tabBar => TabBar(
          controller: tabC,
          unselectedLabelColor: ColorResources.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: ColorResources.white,
          indicatorColor: const Color.fromARGB(255, 0, 41, 124),
          labelStyle:
              robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
          tabs: [
            Tab(
              icon: context.read<InboxProvider>().inboxPaymentStatus ==
                      InboxPaymentStatus.loading
                  ? Image.asset(
                      "assets/images/icons/pembayaran.png",
                      width: 40.0,
                      height: 40.0,
                      // color: index == 0
                      //     ? ColorResources.primary
                      //     : ColorResources.grey,
                    )
                  : context.read<InboxProvider>().inboxPaymentStatus ==
                          InboxPaymentStatus.error
                      ? Image.asset(
                          "assets/images/icons/pembayaran.png",
                          width: 40.0,
                          height: 40.0,
                          // color: index == 0
                          //     ? ColorResources.primary
                          //     : ColorResources.grey,
                        )
                      : context.read<InboxProvider>().inboxPaymentStatus ==
                                  InboxPaymentStatus.loaded &&
                              context.read<InboxProvider>().inboxPaymentCount !=
                                  0
                          ? b.Badge(
                              position:
                                  const b.BadgePosition(top: -15.0, end: -15.0),
                              padding: EdgeInsets.zero,
                              badgeContent: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  context
                                      .read<InboxProvider>()
                                      .inboxPaymentCount
                                      .toString(),
                                  // style: robotoRegular.copyWith(
                                  //     fontSize: Dimensions.fontSizeSmall,
                                  //     color: ColorResources.white),
                                ),
                              ),
                              child: Image.asset(
                                "assets/images/icons/pembayaran.png",
                                width: 40.0,
                                height: 40.0,
                                // color: index == 0
                                //     ? ColorResources.primary
                                //     : ColorResources.grey,
                              ),
                            )
                          : Image.asset(
                              "assets/images/icons/pembayaran.png",
                              width: 40.0,
                              height: 40.0,
                              // color: index == 0
                              //     ? ColorResources.primary
                              //     : ColorResources.grey,
                            ),
              child: Text(
                "Pembayaran",
                style: robotoRegular.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: Dimensions.fontSizeDefault,
                    color: index == 0
                        ? ColorResources.primary
                        : ColorResources.grey),
              ),
            ),
            Tab(
              icon: context.read<InboxProvider>().inboxPanicStatus ==
                      InboxPanicStatus.loading
                  ? Image.asset(
                      "assets/images/icons/sos.png",
                      width: 40.0,
                      height: 40.0,
                      // color: index == 1
                      //     ? ColorResources.primary
                      //     : ColorResources.grey,
                    )
                  : context.read<InboxProvider>().inboxPanicStatus ==
                          InboxPanicStatus.error
                      ? Image.asset(
                          "assets/images/icons/sos.png",
                          width: 40.0,
                          height: 40.0,
                          // color: index == 1
                          //     ? ColorResources.primary
                          //     : ColorResources.grey,
                        )
                      : context.read<InboxProvider>().inboxPanicStatus ==
                                  InboxPanicStatus.loaded &&
                              context.read<InboxProvider>().inboxPanicCount != 0
                          ? b.Badge(
                              position:
                                  const b.BadgePosition(top: -15.0, end: -15.0),
                              padding: EdgeInsets.zero,
                              badgeContent: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  context
                                      .read<InboxProvider>()
                                      .inboxPanicCount
                                      .toString(),
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: ColorResources.white),
                                ),
                              ),
                              child: Image.asset(
                                "assets/images/icons/sos.png",
                                width: 40.0,
                                height: 40.0,
                                // color: index == 1
                                //     ? ColorResources.primary
                                //     : ColorResources.grey,
                              ),
                            )
                          : Image.asset(
                              "assets/images/icons/sos.png",
                              width: 40.0,
                              height: 40.0,
                              // color: index == 1
                              //     ? ColorResources.primary
                              //     : ColorResources.grey,
                            ),
              child: Text(
                "SOS",
                style: robotoRegular.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: Dimensions.fontSizeDefault,
                    color: index == 1
                        ? ColorResources.primary
                        : ColorResources.grey),
              ),
            ),
            Tab(
              icon: context.read<InboxProvider>().inboxInfoStatus ==
                      InboxInfoStatus.loading
                  ? Image.asset(
                      "assets/images/icons/broadcast.png",
                      width: 40.0,
                      height: 40.0,
                      // color: index == 2
                      //     ? ColorResources.primary
                      //     : ColorResources.grey,
                    )
                  : context.read<InboxProvider>().inboxInfoStatus ==
                          InboxInfoStatus.error
                      ? Image.asset(
                          "assets/images/icons/broadcast.png",
                          width: 40.0,
                          height: 40.0,
                          // color: index == 2
                          //     ? ColorResources.primary
                          //     : ColorResources.grey,
                        )
                      : context.read<InboxProvider>().inboxInfoStatus ==
                                  InboxInfoStatus.loaded &&
                              context.read<InboxProvider>().inboxInfoCount != 0
                          ? b.Badge(
                              position:
                                  const b.BadgePosition(top: -15.0, end: -15.0),
                              padding: EdgeInsets.zero,
                              badgeContent: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  context
                                      .read<InboxProvider>()
                                      .inboxInfoCount!
                                      .toString(),
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: ColorResources.white),
                                ),
                              ),
                              child: Image.asset(
                                "assets/images/icons/broadcast.png",
                                width: 40.0,
                                height: 40.0,
                                // color: index == 2
                                //     ? ColorResources.primary
                                //     : ColorResources.grey,
                              ),
                            )
                          : Image.asset(
                              "assets/images/icons/broadcast.png",
                              width: 40.0,
                              height: 40.0,
                              // color: index == 2
                              //     ? ColorResources.primary
                              //     : ColorResources.grey,
                            ),
              child: Text(
                "Broadcast",
                style: robotoRegular.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: Dimensions.fontSizeDefault,
                    color: index == 2
                        ? ColorResources.primary
                        : ColorResources.grey),
              ),
            ),
            Tab(
              icon: context.read<InboxProvider>().inboxInfoStatus ==
                      InboxInfoStatus.loading
                  ? Image.asset(
                      "assets/images/icons/transaksi.png",
                      width: 40.0,
                      height: 40.0,
                      // color: index == 2
                      //     ? ColorResources.primary
                      //     : ColorResources.grey,
                    )
                  : context.read<InboxProvider>().inboxInfoStatus ==
                          InboxInfoStatus.error
                      ? Image.asset(
                          "assets/images/icons/transaksi.png",
                          width: 40.0,
                          height: 40.0,
                          // color: index == 2
                          //     ? ColorResources.primary
                          //     : ColorResources.grey,
                        )
                      : context.read<InboxProvider>().inboxInfoStatus ==
                                  InboxInfoStatus.loaded &&
                              context
                                      .read<InboxProvider>()
                                      .inboxTransactionCount !=
                                  0
                          ? b.Badge(
                              position:
                                  const b.BadgePosition(top: -15.0, end: -15.0),
                              padding: EdgeInsets.zero,
                              badgeContent: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  context
                                      .read<InboxProvider>()
                                      .inboxTransactionCount
                                      .toString(),
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: ColorResources.white),
                                ),
                              ),
                              child: Image.asset(
                                "assets/images/icons/transaksi.png",
                                width: 40.0,
                                height: 40.0,
                                // color: index == 3
                                //     ? ColorResources.primary
                                //     : ColorResources.grey,
                              ),
                            )
                          : Image.asset(
                              "assets/images/icons/transaksi.png",
                              width: 40.0,
                              height: 40.0,
                              // color: index == 2
                              //     ? ColorResources.primary
                              //     : ColorResources.grey,
                            ),
              child: Text(
                "Transaksi",
                style: robotoRegular.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: Dimensions.fontSizeDefault,
                    color: index == 3
                        ? ColorResources.primary
                        : ColorResources.grey),
              ),
            ),
          ]);

  Future<void> getData() async {
    if (mounted) {
      context.read<InboxProvider>().resetInboxInfoPageCount();
    }
    if (mounted) {
      // context.read<InboxProvider>().resetInboxPaymentPageCount();
    }
    if (mounted) {
      context.read<InboxProvider>().resetInboxPanicPageCount();
    }
    if (mounted) {
      context.read<InboxProvider>().getInboxInfo(context);
    }
    if (mounted) {
      context.read<InboxProvider>().getInboxPanic(context);
    }
    if (mounted) {
      // context.read<InboxProvider>().getInboxPayment(context);
    }
  }

  inboxInfoControllerListener() {
    if (inboxInfoViewC.position.pixels ==
            inboxInfoViewC.position.maxScrollExtent &&
        !inboxInfoViewC.position.outOfRange) {
      context.read<InboxProvider>().loadMoreInboxInfo();
      if (context.read<InboxProvider>().isLoadInboxInfo) {
        int pageCount = (context.read<InboxProvider>().inboxInfoPageCount += 1);
        context.read<InboxProvider>().toggleMoreInboxInfo(
              context,
              pageCount: pageCount,
            );
      }
    }
  }

  inboxPaymentControllerListener() {
    if (inboxPaymentViewC.position.pixels ==
            inboxPaymentViewC.position.maxScrollExtent &&
        !inboxPaymentViewC.position.outOfRange) {
      context.read<InboxProvider>().loadMoreInboxPayment();
      if (context.read<InboxProvider>().isLoadInboxPayment) {
        int pageCount =
            (context.read<InboxProvider>().inboxPaymentPageCount += 1);
        context.read<InboxProvider>().toggleMoreInboxPayment(
              context,
              pageCount: pageCount,
            );
      }
    }
  }

  inboxPanicControllerListener() {
    if (inboxPanicViewC.position.pixels ==
            inboxPanicViewC.position.maxScrollExtent &&
        !inboxPanicViewC.position.outOfRange) {
      context.read<InboxProvider>().loadMoreInboxPanic();
      if (context.read<InboxProvider>().isLoadInboxPanic) {
        int pageCount =
            (context.read<InboxProvider>().inboxPanicPageCount += 1);
        context.read<InboxProvider>().toggleMoreInboxPanic(
              context,
              pageCount: pageCount,
            );
      }
    }
  }

  Future<void> handleChanging() async {
    setState(() {
      index = tabC.index;
    });
    if (tabC.indexIsChanging) {
      if (index == 0) {
        if (mounted) {
          await context.read<InboxProvider>().getInboxInfo(context);
        }
      }
      if (index == 1) {
        if (mounted) {
          await context.read<InboxProvider>().getInboxPanic(context);
        }
      }
      if (index == 2) {
        if (mounted) {
          // await context.read<InboxProvider>().getInboxPayment(context);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    tabC = TabController(length: 4, vsync: this);
    tabC.addListener(handleChanging);

    inboxInfoViewC = ScrollController();
    inboxInfoViewC.addListener(inboxInfoControllerListener);

    inboxPaymentViewC = ScrollController();
    inboxPaymentViewC.addListener(inboxPaymentControllerListener);

    inboxPanicViewC = ScrollController();
    inboxPanicViewC.addListener(inboxPanicControllerListener);

    Future.microtask(() => getData());
  }

  @override
  void dispose() {
    inboxInfoViewC.removeListener(inboxInfoControllerListener);
    inboxInfoViewC.dispose();
    
    inboxPaymentViewC.removeListener(inboxPaymentControllerListener);
    inboxPaymentViewC.dispose();
    
    inboxPanicViewC.removeListener(inboxPanicControllerListener);
    inboxPanicViewC.dispose();

    tabC.removeListener(handleChanging);
    tabC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.greyDarkPrimary.withOpacity(0.2),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            buildAppBar(context),
          ];
        },
        body: TabBarView(
          controller: tabC,
          children: [
            index == 0 ? inboxWidgetPayment(context) : const Center(
              child: SpinKitThreeBounce(
                size: 20.0,
                color: ColorResources.primary,
              ),
            ),
            index == 1 ? inboxWidgetPanic(context) : const Center(
              child: SpinKitThreeBounce(
                size: 20.0,
                color: ColorResources.primary,
              ),
            ),
            index == 2 ? inboxWidgetInfo(context) : const Center(
              child: SpinKitThreeBounce(
                size: 20.0,
                color: ColorResources.primary,
              ),
            ),
            index == 3 ? const TransactionNotifList() : const Center(
              child: SpinKitThreeBounce(
                size: 20.0,
                color: ColorResources.primary,
              ),
            ),
          ],
        )
      )
    );
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: ColorResources.white,
      toolbarHeight: 60.0,
      leading: Container(),
      title: Text(getTranslated("NOTIFICATION", context),
        style: robotoRegular.copyWith(
          color: ColorResources.black,
          fontSize: Dimensions.fontSizeExtraLarge,
          fontWeight: FontWeight.bold
        ),
      ),
      centerTitle: true,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: ColorResources.primary
      ),
      bottom: PreferredSize(
        preferredSize: tabBar.preferredSize,
        child: ColoredBox(
          color: ColorResources.white,
          child: tabBar,
        )
      ),
    );
  }

  Widget inboxWidgetInfo(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: ColorResources.primary,
      color: ColorResources.white,
      onRefresh: () {
        return Future.sync(() {
          context.read<InboxProvider>().resetInboxInfoPageCount();
          context.read<InboxProvider>().getInboxInfo(context);
        });
      },
      child: CustomScrollView(
        controller: inboxInfoViewC,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          if (context.watch<InboxProvider>().inboxInfoStatus == InboxInfoStatus.loading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primary,
                ),
              ),
            ),
          if (context.watch<InboxProvider>().inboxInfoStatus == InboxInfoStatus.empty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                  child: Text(
                getTranslated("NO_INBOX_AVAILABLE", context),
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: ColorResources.black,
                ),
              )),
            ),
          if (context.watch<InboxProvider>().inboxInfoStatus == InboxInfoStatus.error)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: ColorResources.black,
                ),
              )),
            ),
          if (context.watch<InboxProvider>().inboxInfoStatus == InboxInfoStatus.loaded)
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 80.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int i) {
                    if (context.read<InboxProvider>().inboxInfo!.length == i) {
                      return const Center(
                        child: SpinKitThreeBounce(
                          size: 20.0,
                          color: ColorResources.primary,
                        ),
                      );
                    }
                    if (context.read<InboxProvider>().inboxInfo!.isNotEmpty) {
                      return buildNotificationItem(
                        context.read<InboxProvider>().inboxInfo!,
                        i,
                        Icons.info,
                        inboxInfoViewC,
                        "info"
                      );
                    }
                    return Container();
                  },
                  childCount: context.watch<InboxProvider>().isLoadInboxInfo == true
                  ? context.read<InboxProvider>().inboxInfo!.length + 1
                  : context.read<InboxProvider>().inboxInfo!.length,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget inboxWidgetPanic(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: ColorResources.primary,
      color: ColorResources.white,
      onRefresh: () {
        return Future.sync(() {
          context.read<InboxProvider>().resetInboxPanicPageCount();
          context.read<InboxProvider>().getInboxPanic(context);
        });
      },
      child: CustomScrollView(
        controller: inboxPanicViewC,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
      
          if (context.watch<InboxProvider>().inboxPanicStatus == InboxPanicStatus.loading)
            const SliverFillRemaining(
              hasScrollBody: false, 
              child: Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primary,
                ),
              ),
            ),
      
          if (context.watch<InboxProvider>().inboxPanicStatus == InboxPanicStatus.empty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(getTranslated("NO_INBOX_AVAILABLE", context),
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: ColorResources.black),
                )
              ),
            ),
      
          if (context.watch<InboxProvider>().inboxPanicStatus == InboxPanicStatus.error)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: ColorResources.black
                ),
              )),
            ),
      
          if (context.watch<InboxProvider>().inboxPanicStatus == InboxPanicStatus.loaded)
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 140.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int i) {
                    
                    if (context.read<InboxProvider>().inboxPanic!.length == i) {
                      return const Center(
                        child: SpinKitThreeBounce(
                          size: 20.0,
                          color: ColorResources.primary,
                        ),
                      );
                    }
                    
                    if (context.read<InboxProvider>().inboxPanic!.isNotEmpty) {
                      return buildNotificationItem(
                        context.read<InboxProvider>().inboxPanic!, 
                        i, Icons.warning, inboxPanicViewC, "sos"
                      );
                    }
                    
                    return const SizedBox();
      
                  },
                  childCount: context.watch<InboxProvider>().isLoadInboxPanic == true
                  ? context.read<InboxProvider>().inboxPanic!.length + 1
                  : context.read<InboxProvider>().inboxPanic!.length,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget inboxWidgetPayment(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: ColorResources.primary,
      color: ColorResources.white,
      onRefresh: () {
        return Future.sync(() {
          // context.read<InboxProvider>().resetInboxPaymentPageCount();
          // context.read<InboxProvider>().getInboxPayment(context);
        });
      },
      child: CustomScrollView(
        controller: inboxPaymentViewC,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: const [

          SliverFillRemaining(
            child: Center(
              child: Text("Data transaksi belum ada")
            )
          )
          // if (context.watch<InboxProvider>().inboxPaymentStatus ==
          //     InboxPaymentStatus.loading)
          //   SliverFillRemaining(
          //     hasScrollBody: false,
          //     child: loadingWidget(),
          //   ),
          // if (context.watch<InboxProvider>().inboxPaymentStatus == InboxPaymentStatus.empty)
          //   SliverFillRemaining(
          //     hasScrollBody: false,
          //     child: Center(
          //         child: Text(
          //       getTranslated("NO_INBOX_AVAILABLE", context),
          //       style: robotoRegular.copyWith(
          //         fontSize: Dimensions.fontSizeDefault,
          //         color: ColorResources.black,
          //       ),
          //     )),
          //   ),
          // if (context.watch<InboxProvider>().inboxPaymentStatus == InboxPaymentStatus.error)
          //   SliverFillRemaining(
          //     hasScrollBody: false,
          //     child: Center(
          //         child: Text(
          //       getTranslated("THERE_WAS_PROBLEM", context),
          //       style: robotoRegular.copyWith(
          //         fontSize: Dimensions.fontSizeDefault,
          //         color: ColorResources.white,
          //       ),
          //     )),
          //   ),
          // if (context.watch<InboxProvider>().inboxPaymentStatus ==
          //     InboxPaymentStatus.loaded)

            // SliverPadding(
            //   padding: const EdgeInsets.only(bottom: 80.0),
            //   sliver: SliverList(
            //     delegate: SliverChildBuilderDelegate(
            //       (BuildContext context, int i) {
            //         if (context.read<InboxProvider>().inboxPayment!.length ==
            //             i) {
            //           return loadingWidget();
            //         }
            //         if (context
            //             .read<InboxProvider>()
            //             .inboxPayment!
            //             .isNotEmpty) {
            //           return buildNotificationItem(
            //               null,
            //               i,
            //               Icons.payments,
            //               "payment",
            //               context.read<InboxProvider>().inboxPayment!);
            //         }
            //         return Container();
            //       },
            //       childCount:
            //           context.watch<InboxProvider>().isLoadInboxPayment == true
            //               ? context.read<InboxProvider>().inboxPayment!.length +
            //                   1
            //               : context.read<InboxProvider>().inboxPayment!.length,
            //     ),
            //   ),
            // )
        ],
      ),
    );
  }

  Widget buildNotificationItem(
    List<InboxData>? inbox, i, IconData icon, 
    ScrollController scrollPosition, 
    String type, [List<InboxPaymentData>? inboxPayment]
  ) {
    return InkWell(
      onTap: () async {
        final currentScrollPosition = scrollPosition.position.pixels;

        await context.read<InboxProvider>().getInboxDetailAndUpdateInbox(
          context,
          type: type,
          inboxId: inbox![i].id!,
        );

        final isRefetch = await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailInboxScreen(
            inboxId: inbox[i].id!,
            type: type
          );
        }));

        if(isRefetch != null) {
          Future.delayed(const Duration(milliseconds: 500), () {
            scrollPosition.jumpTo(currentScrollPosition);
          });
        }

      },
      child: Material(
        color: ColorResources.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: inbox?[i].read == true || inboxPayment?[i].isRead == true
                ? ColorResources.white.withOpacity(0.9)
                : ColorResources.primary.withOpacity(0.2),
          ),
          child: Container(
            decoration: BoxDecoration(
                border:
                    Border.all(width: 0.5, color: ColorResources.hintColor)),
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                inbox?[i].title == "Kebakaran" 
                ? Image.asset('assets/images/sos/wildfire.png', 
                    width: 42.0, 
                    height: 42.0
                  )
                : inbox?[i].title == "Bencana Alam"  
                ? Image.asset('assets/images/sos/disaster.png', 
                    width: 42.0, 
                    height: 42.0
                  )
                : inbox?[i].title == "Kecelakaan"  
                ? Image.asset('assets/images/sos/accident.png', 
                    width: 42.0, 
                    height: 42.0
                  )
                : inbox?[i].title == "Pencurian"  
                ? Image.asset('assets/images/sos/theft.png', 
                    width: 42.0, 
                    height: 42.0
                  )
                : inbox?[i].title == "Perampokan"  
                ? Image.asset('assets/images/sos/robbery.png', 
                    width: 42.0, 
                    height: 42.0
                  )
                : inbox?[i].title == "Kerusuhan"  
                ? Image.asset('assets/images/sos/noise.png', 
                    width: 42.0, 
                    height: 42.0
                  )
                : Icon(
                    icon,
                    size: Dimensions.iconSizeLarge,
                    color: inbox?[i].read ?? inboxPayment?[i].isRead ?? false
                    ? ColorResources.primary
                    : ColorResources.black,
                  ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                  Text(
                      (inbox?[i].title ?? inboxPayment?[i].title)
                              ?.customSentence(40) ??
                          "...",
                      style: robotoRegular.copyWith(
                          fontWeight: FontWeight.w600,
                          color: ColorResources.black,
                          fontSize: Dimensions.fontSizeExtraLarge)),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          (inbox?[i].description ??
                                      inboxPayment?[i].description)
                                  ?.customSentence(40) ??
                              "...",
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: robotoRegular.copyWith(
                              fontWeight: inbox?[i].read == true ||
                                      inboxPayment?[i].isRead == true
                                  ? null
                                  : FontWeight.w600,
                              color: ColorResources.black.withOpacity(0.7),
                              fontSize: Dimensions.fontSizeLarge)),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      Helper.formatDate(DateTime.parse((inbox?[i].createdAt ??
                              Helper.getFormatedDateTwo(
                                  inboxPayment![i].createdAt!))
                          .replaceAll('/', '-'))),
                      style: robotoRegular.copyWith(
                          color: inbox?[i].read == true ||
                                  inboxPayment?[i].isRead == true
                              ? ColorResources.greyDarkPrimary
                              : ColorResources.black,
                          fontSize: Dimensions.fontSizeLarge)),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
