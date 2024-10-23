import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hp3ki/views/screens/comingsoon/comingsoon.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:shimmer/shimmer.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_indicator/carousel_indicator.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

import 'package:hp3ki/views/screens/ppob/topup/topup.dart';
import 'package:hp3ki/views/screens/donate/donate_detail.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({ Key? key }) : super(key: key);

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  late ScrollController sc;

  int currentIndex = 0;

  Future<void> getData() async {
    // if(mounted) {
    //   context.read<BannerProvider>().getBanner(context);
    // }
  }

  @override
  void initState() {
    sc = ScrollController();

    getData();

    super.initState();
  }

  @override
  void dispose() {
    sc.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: buildBackgroundImage(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          controller: sc,
          slivers: [
            buildAppBar(),
            SliverStack(
              children: [
                buildBodyContent(),
                buildBalanceSection(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration buildBackgroundImage() {
    return const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background/background.png'),
          fit: BoxFit.cover,
        )
      );
  }

  SliverAppBar buildAppBar() {
    return SliverAppBar(
      backgroundColor: ColorResources.transparent,
      toolbarHeight: 60.0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        systemNavigationBarColor: ColorResources.transparent,
      ),
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
        child: Text(getTranslated("DONATE", context),
          style: poppinsRegular.copyWith(
            fontSize: Dimensions.fontSizeExtraLarge,
            fontWeight: FontWeight.bold,
            color: ColorResources.white,
            letterSpacing: 1.0
          ),
        ),
      ),
      leading: Container(),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
          child: Row(
            children: [
              IconButton(
                //FIXME: benerin pas apinya jadi
                onPressed: () => debugPrint('a'),
                icon: const Icon(
                  Icons.history,
                  size: Dimensions.iconSizeLarge,
                  color: ColorResources.white,
                ),
                tooltip: getTranslated("HISTORY", context),
              ),
            ],
          ),
        )
      ],
      expandedHeight: 100.0,
    );
  }

  Widget buildBalanceSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          left: Dimensions.paddingSizeExtraLarge,
          right: Dimensions.paddingSizeExtraLarge
        ),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/images/icons/ic-donation.png',
                      fit: BoxFit.fitWidth,
                      height: 50.0,
                      width: 50.0,
                    ),
                    const SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const SizedBox(height: 15,),
                        Text('Rp 175.000',
                          style: poppinsRegular.copyWith(
                            color: ColorResources.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(getTranslated('YOUR_BALANCE', context),
                          style: poppinsRegular.copyWith(
                            color: ColorResources.black.withOpacity(0.4),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () => NS.push(context, const TopUpScreen()),
                  child: Text(getTranslated('TOPUP', context),
                    style: poppinsRegular.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorResources.primary
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

  Widget buildBodyContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge,),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(35.0),
              topLeft: Radius.circular(35.0)
            ),
            color: ColorResources.white
          ),
          child: Column(
            children: [
              const SizedBox(height: 50.0,),
              buildDonationSection(),
              const SizedBox(height: 15,),
              buildBannerCarousel(),
              const SizedBox(height: 45.0,),
              buildSelectedDonationSection(),
              //TO PREVENT THE NAVBAR
              const SizedBox(height: 80,)
            ],
          ),
        ),
      ),
    );
  }


  Widget buildDonationSection() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(getTranslated('HAPPINESS', context),
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: ColorResources.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 15,),
        SizedBox(
          height: 310,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  DelayedDisplay(
                    delay: const Duration(seconds: 1),
                    child: InkWell(
                      onTap: () => NS.push(context, DonateDetailScreen(
                          title: 'Bantu orang ini yang sedang tertimpa musibah banjir',
                          amount: 'Rp 126.873.000',
                          imageUrl: 'https://static.dw.com/image/56233122_605.jpg',
                          date: DateTime.now()
                        )
                      ),
                      splashColor: ColorResources.black,
                      borderRadius: BorderRadius.circular(20.0),
                      child: SizedBox(
                        height: 320.0,
                        width: 300.0,
                        child: Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          color: ColorResources.white,
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0)
                                  )
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: 'https://static.dw.com/image/56233122_605.jpg',
                                  imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                                    return Container(
                                      height: 200.0,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0)
                                        ),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill
                                        )
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Bantu orang ini yang sedang tertimpa musibah banjir',
                                      style: poppinsRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: ColorResources.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(getTranslated('ACCUMULATED_AMOUNT', context),
                                      style: poppinsRegular.copyWith(
                                        color: ColorResources.black.withOpacity(0.4)
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text('Rp 126.873.000',
                                      style: poppinsRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                  const SizedBox(width: 15,)
                ],
              );
            }, 
          ),
        ),
      ],
    );
  }

  Widget buildBannerCarousel() {
    List banner = [
      'https://www.ycabfoundation.org/wp-content/uploads/2019/05/Banner-KitaBisa-Faozan.jpg',
      'https://kitabisa.com/_next/image?url=https%3A%2F%2Fimgix.kitabisa.com%2F35944a08-a0b8-4148-9eca-485d7ed66481.jpg%3Fauto%3Dformat%26ch%3DWidth%2CDPR%2CSave-Data%2CViewport-Width&w=1080&q=75',
      'https://imgix.kitabisa.com/f441ee06-cc08-497e-83c2-4255a61a84e8.jpg?auto=format&ch=Width,DPR,Save-Data,Viewport-Width',
    ];

    // return 
    // Consumer<BannerProvider>(
    //   builder: (BuildContext context, BannerProvider bannerProvider, Widget? child) {
    //     if(bannerProvider.bannerStatus == BannerStatus.loading) {
    //       return Shimmer.fromColors(
    //         baseColor: Colors.grey[300]!,
    //         highlightColor: Colors.grey[200]!,
    //         child: Container(
    //           height: 200.0,
    //           margin: const EdgeInsets.only(
    //             top: 5.0,
    //             left: 25.0,
    //             right: 25.0,
    //             bottom: 20.0
    //           ),
    //           decoration: BoxDecoration(
    //             color: ColorResources.white,
    //             borderRadius: BorderRadius.circular(15.0),
    //           ),
    //         ),
    //       );
    //     }
        //FIXME: benerin pas apinya jadi

        // if(bannerProvider.bannerStatus == BannerStatus.empty) {
        //   return Container(
        //     height: 200.0,
        //     margin: const EdgeInsets.only(
        //       top: 5.0,
        //       left: 25.0,
        //       right: 25.0,
        //       bottom: 20.0
        //     ),
        //     child: Center(
        //       child: Text(getTranslated("THERE_IS_NO_DATA", context),
        //         style: poppinsRegular.copyWith(
        //           fontSize: Dimensions.fontSizeDefault,
        //           fontWeight: FontWeight.w600,
        //           color: ColorResources.white
        //         ),
        //       ),
        //     ),
        //   );
        // }
        return Container(
          height: 200.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              DelayedDisplay(
                delay: const Duration(seconds: 1),
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 1.0,
                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    initialPage: currentIndex,
                    onPageChanged: (int i, CarouselPageChangedReason reason) {
                      currentIndex = i;
                      setState(() {});
                    }
                  ),
                  // itemCount: bannerProvider.banners.length,
                  itemCount: banner.length,
                  itemBuilder: (BuildContext context, int i, int z){
                    return CachedNetworkImage(
                      // imageUrl: "${AppConstants.baseUrlFeedImg}/${bannerProvider.banners[i].media![0].path}",
                      imageUrl: banner[i],
                      imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                        return Card(
                          margin: EdgeInsets.zero,
                          color: ColorResources.transparent,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
                      placeholder: (BuildContext context, String val) {
                        return Shimmer.fromColors(
                          highlightColor: Colors.grey[200]!,
                          baseColor: Colors.grey[300]!,
                          child: Card(
                            margin: EdgeInsets.zero,
                            color: ColorResources.white,
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: ColorResources.white
                              ),
                            ),
                          ),
                        ); 
                      },
                      errorWidget: (BuildContext context, String text, dynamic _) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[200]!,
                          child: Card(
                            margin: EdgeInsets.zero,
                            color: ColorResources.white,
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: ColorResources.white
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Positioned(
                bottom: -30.0,
                left: 0.0,
                right: 0.0,
                child: Center(
                  child: CarouselIndicator(
                    activeColor: ColorResources.primary,
                    color: ColorResources.backgroundDisabled,
                    width: 15.0,
                    height: 15.0,
                    cornerRadius: 30.0,
                    space: 10.0,
                    count: banner.length,
                    index: currentIndex,
                  ),
                ),
              ),
            ]
          ),
        );
    //   },
    // );
  }


  Widget buildSelectedDonationSection() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(getTranslated('PREF_DONATION', context),
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: ColorResources.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 15,),
        SizedBox(
          height: 330,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  DelayedDisplay(
                    delay: const Duration(seconds: 1),
                    child: InkWell(
                      onTap: () => NS.push(context, const ComingSoonScreen(title: 'Donasi Pilihan')),
                      splashColor: ColorResources.black,
                      borderRadius: BorderRadius.circular(20.0),
                      child: SizedBox(
                        height: 315.0,
                        width: 250.0,
                        child: Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          color: ColorResources.white,
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0)
                                  )
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: 'https://static.republika.co.id/uploads/images/inpicture_slide/kegiatan-sedekah-jumat-yang-digalakkan-pemkot_200831231356-545.jpg',
                                  imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                                    return Container(
                                      height: 150.0,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0)
                                        ),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill
                                        )
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Sedekah makanan untuk daerah yang terkena bencana',
                                      style: poppinsRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: ColorResources.black,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text('Kelurahan Bojongsari',
                                      style: poppinsRegular.copyWith(
                                        color: ColorResources.black.withOpacity(0.4)
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 10,),
                                    Text(getTranslated('ACCUMULATED_AMOUNT', context),
                                      style: poppinsRegular.copyWith(
                                        color: ColorResources.black.withOpacity(0.4)
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text('Rp 126.873.000',
                                      style: poppinsRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                  const SizedBox(width: 15,)
                ],
              );
            }, 
          ),
        ),
      ],
    );
  }
}