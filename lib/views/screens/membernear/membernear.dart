import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hp3ki/data/models/membernear/membernear.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hp3ki/providers/location/location.dart';
import 'package:provider/provider.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/providers/membernear/membernear.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class MembernearScreen extends StatefulWidget {
  const MembernearScreen({ Key? key }) : super(key: key);

  @override
  State<MembernearScreen> createState() => MembernearScreenState();
}

class MembernearScreenState extends State<MembernearScreen> {
  Completer<GoogleMapController> mapsC = Completer();

  late ScrollController sc;

  Future<void> getData() async {
    if(mounted) {
      await context.read<LocationProvider>().getCurrentPosition(context);
    }
    if(mounted) {
      await context.read<MembernearProvider>().getMembernear(context);
    }
  }

  @override 
  void initState() {
    super.initState();

    Future.wait([getData()]);

    sc = ScrollController();
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
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return RefreshIndicator(
            backgroundColor: ColorResources.primary,
            color: ColorResources.white,
            onRefresh: () {
              return Future.sync(() {
                context.read<MembernearProvider>().getMembernear(context);
              });
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                buildAppBar(context),
                context.watch<MembernearProvider>().membernearStatus == MembernearStatus.loading 
                ? buildLoadingContent() 
                : context.watch<MembernearProvider>().membernearStatus == MembernearStatus.error 
                  ? buildErrorContent(context)
                  : buildContentNotEmpty()
              ],
            ),
          );
        },
      ),
    );  
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return const CustomAppBar(title: 'Member Near').buildSliverAppBar(context);
  }

  SliverFillRemaining buildLoadingContent() {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: SpinKitThreeBounce(
          color: ColorResources.primary,
          size: 20.0
        ),
      )
    );
  }

  SliverFillRemaining buildErrorContent(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text(getTranslated("THERE_WAS_PROBLEM", context),
          style: poppinsRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault
          ),
        )
      )
    );
  }

  SliverFillRemaining buildContentNotEmpty() {
    final screenSize = MediaQuery.sizeOf(context);
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Stack(
      clipBehavior: Clip.none,
      children: [
      
        Consumer<MembernearProvider>(
          builder: (BuildContext context, MembernearProvider membernearProvider, Widget? child) {
            return GoogleMap(
              mapType: MapType.normal,
              gestureRecognizers: {}..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              buildingsEnabled: false,
              mapToolbarEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(membernearProvider.getCurrentLat, membernearProvider.getCurrentLng),
                zoom: 15.0,
              ),
              markers: Set.from(membernearProvider.markers),
              onMapCreated: (GoogleMapController c) {
                membernearProvider.gMapController = c;
              },
            );
          },
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: screenSize.height * 0.4,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                buildMemberList(screenSize),
                buildLabel(screenSize),
              ],
            ),
          ),
        ),
    ],
    )
    );
  }

  Align buildLabel(Size screenSize) {
    final height = screenSize.height;
    final width = screenSize.width;
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 75),
        height: height * 0.05,
        width: width * 0.5,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorResources.white,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(getTranslated("MEMBER_NEAR", context),
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              fontWeight: FontWeight.w600,
              color: ColorResources.primary,
            ),
          ),
        ),
      ),
    );
  }

  Align buildMemberList(Size screenSize) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: screenSize.height * 0.3,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorResources.primary,
              ColorResources.primary.withOpacity(0.5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          ),                
        ),
        child: Consumer<MembernearProvider>(
          builder: (BuildContext context, MembernearProvider membernearProvider, Widget? child) {
            if(membernearProvider.membernearStatus == MembernearStatus.loading) {
              return MasonryGridView.builder(
                gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                scrollDirection: Axis.vertical,
                controller: sc,
                itemCount: membernearProvider.membernearData.length,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int i) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!, 
                    highlightColor: Colors.grey[200]!,
                    child: Container(
                      width: 70.0,
                      height: 70.0,
                      margin: const EdgeInsets.only(bottom: 5.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        color: ColorResources.white,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                    )                                
                  );
                }
              );
            }
            if(membernearProvider.membernearStatus == MembernearStatus.error) {
              return Center(
                child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                  style: poppinsRegular.copyWith(
                    color: ColorResources.black,
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w600
                  ),
                ),
              );
            }
            if(membernearProvider.membernearStatus == MembernearStatus.empty) {
              return Center(
                child: Text(getTranslated("THERE_IS_NO_DATA", context),
                  style: poppinsRegular.copyWith(
                    color: ColorResources.black,
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w600
                  ),
                ),
              );
            }
            return MasonryGridView.builder(  
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              scrollDirection: Axis.vertical,
              controller: sc,
              itemCount: membernearProvider.membernearData.length,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.only(
                top: 35.0,
                left: 35.0,
                right: 35.0,
              ),
              itemBuilder: (BuildContext context, int i) {
                final User? user = membernearProvider.membernearData[i].user;
                final distance = membernearProvider.membernearData[i].distance;
                return buildMemberItem(membernearProvider, context, i, user, distance, screenSize);
              },
            );
          },
        )
      ),
    );
  }

  GestureDetector buildMemberItem(MembernearProvider membernearProvider, BuildContext context, int i, User? user, String? distance, Size screenSize) {
    final height = screenSize.height * 0.1;
    final width = screenSize.width * 0.5;
    return GestureDetector(
      onTap: () => membernearProvider.navigateTo(
        context,
        membernearProvider.membernearData[i]
      ),
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.all(10.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: height * 0.7,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorResources.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: kElevationToShadow[3],
                ),
                child: Material(
                  color: const Color.fromRGBO(0, 0, 0, 0),
                  child: InkWell(
                    onTap: () => membernearProvider.navigateTo(
                      context,
                      membernearProvider.membernearData[i]
                    ),
                    onDoubleTap: () { },
                    borderRadius: BorderRadius.circular(15.0),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(user?.name ?? "...",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: poppinsRegular.copyWith(
                              color: ColorResources.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(distance ?? "...",
                            style: poppinsRegular.copyWith(
                              color: ColorResources.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: kElevationToShadow[1],
                ),
                child: CachedNetworkImage(
                  imageUrl: user?.avatar == "" || user?.avatar == null 
                    ? "https://www.nicepng.com/png/detail/933-9332131_profile-picture-default-png.png"
                    : user!.avatar!,
                  fit: BoxFit.fill,
                  imageBuilder: (context, imageProvider) {
                    return CircleAvatar(
                      radius: 25.0,
                      backgroundImage: imageProvider,
                    );
                  },
                  errorWidget: (BuildContext context, String error, dynamic _) {
                    return CircleAvatar(
                      radius: 25.0,
                      child: Image.asset("assets/images/logo/logo.png"),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}