import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hp3ki/data/models/membernear/membernear.dart';
import 'package:hp3ki/data/repository/membernear/membernear.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/views/basewidgets/dialog/custom/custom.dart';
import 'package:hp3ki/providers/location/location.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/marker_icon.dart';

enum MembernearStatus { idle, loading, loaded, empty, error }

class MembernearProvider with ChangeNotifier {
  final LocationProvider lp;
  final MembernearRepo nr;

  MembernearProvider({
    required this.lp,
    required this.nr
  });

  GoogleMapController? gMapController;

  List<Marker> _markers = [];
  List<Marker> get markers => [..._markers];

  List<MemberNearData> _membernearData = [];
  List<MemberNearData> get membernearData => [..._membernearData];
  
  MembernearStatus _membernearStatus = MembernearStatus.loading;
  MembernearStatus get membernearStatus => _membernearStatus; 

  void setStateMembernearStatus(MembernearStatus membernearStatus) {
    _membernearStatus = membernearStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getMembernear(BuildContext context) async {
    try {
      _membernearData = [];
      _markers = [];
      MemberNearModel? mnm = await nr.getMembernear(
        userId: SharedPrefs.getUserId(),
        lat: lp.getCurrentLat,
        lng: lp.getCurrentLng
      );
      List<MemberNearData> nd = mnm!.data!;
      for (MemberNearData membernear in nd) {
        _markers.add(Marker(
          markerId: MarkerId(membernear.user!.phone!),
          onTap: () {
            buildResponseModalBottomSheet(context, membernear);
          },
          icon: await MarkerIcon.downloadResizePictureCircle("https://www.shutterstock.com/image-vector/default-avatar-profile-icon-social-600nw-1677509740.jpg",
            size: 100,
            addBorder: true,
            borderColor: ColorResources.success,
            borderSize: 15.0,
          ),
          infoWindow: InfoWindow(
            title: membernear.user?.name ?? "...",
          ),
          position: LatLng(double.parse(membernear.lat ?? "0.0"), double.parse(membernear.lng ?? "0.0"))
        ));
      }
      _membernearData.addAll(nd);
      setStateMembernearStatus(MembernearStatus.loaded);
      if(membernearData.isEmpty) {
        setStateMembernearStatus(MembernearStatus.empty);
      }
    } on CustomException catch(e) {
      debugPrint(e.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'MNR01');
      setStateMembernearStatus(MembernearStatus.error);
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'MNP01');
      setStateMembernearStatus(MembernearStatus.error);
    }
  }

  Future<void> navigateTo(BuildContext context, MemberNearData membernear) async{
    final phone = MarkerId(membernear.user?.phone ?? "0.0");
    final lat = double.parse(membernear.lat ?? "0.0");
    final lng = double.parse(membernear.lng ?? "0.0");
    final selectedMemberPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 15.0
    );

    gMapController!.showMarkerInfoWindow(phone);
    gMapController!.animateCamera(CameraUpdate.newCameraPosition(selectedMemberPosition));
    buildResponseModalBottomSheet(context, membernear);
  }

  Future<dynamic> buildResponseModalBottomSheet(BuildContext context, MemberNearData membernear) {
    return showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: ColorResources.transparent,
      backgroundColor: ColorResources.transparent,
      elevation: 0.0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context, 
      builder: (BuildContext context) {
        return Container(
          height: 370.0,
          decoration: const BoxDecoration(
            color: ColorResources.transparent
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 320.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorResources.primary,
                        ColorResources.primary.withOpacity(0.5),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)
                    )
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    const CircleAvatar(
                      maxRadius: 50.0,
                      backgroundImage: NetworkImage("https://www.shutterstock.com/image-vector/default-avatar-profile-icon-social-600nw-1677509740.jpg"
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(membernear.user?.name ?? "...",
                      style: poppinsRegular.copyWith(
                        fontSize: Dimensions.fontSizeOverLarge,
                        fontWeight: FontWeight.w600,
                        color: ColorResources.white
                      )
                    ),
                    const SizedBox(height: 8.0),
                    Text(membernear.distance ?? "0.0 KM",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: poppinsRegular.copyWith(
                        fontSize: Dimensions.fontSizeOverLarge,
                        fontWeight: FontWeight.w600,
                        color: ColorResources.white,
                      )
                    ),
                    const SizedBox(height: 50.0),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await openWhatsApp(membernear, context);
                      },
                      icon: const Icon(Icons.chat),
                      label: const Text('Hubungi melalui WhatsApp', 
                        style: poppinsRegular,
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        );
      }
    );
  }

  Future<void> openWhatsApp(MemberNearData membernear, BuildContext context) async {
    final url = Platform.isAndroid
      ? "whatsapp://send?phone=${membernear.user?.phone ?? 0}"
      : "https://wa.me/${membernear.user?.phone ?? 0}";
    final uri = Uri.parse(url);
    
    if(await canLaunchUrl(uri)){
      await launchUrl(uri);
    } else {
      ShowSnackbar.snackbar(context, 'Nomor ini tidak bisa dihubungi', '', ColorResources.error);
    }
  }

  double get getCurrentLat => lp.getCurrentLat;
  double get getCurrentLng => lp.getCurrentLng;
}