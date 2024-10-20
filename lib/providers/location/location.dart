import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/maps/google_maps_place_picker.dart';

class LocationProvider extends ChangeNotifier {
  LocationProvider();

  GoogleMapController? googleMapC; 
  GoogleMapController? googleMapCCheckIn; 

  Future<void> getCurrentPosition(BuildContext context) async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      SharedPrefs.writeLatLng(position.latitude, position.longitude);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      SharedPrefs.writeCurrentAddress("${place.thoroughfare} ${place.subThoroughfare} \n${place.locality}, ${place.postalCode}");
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    } 
  }

  Future<void> getOtherMemberPosition({required String otherMemberLat, required String otherMemberLng}) async {
    try {
      SharedPrefs.deleteOtherMemberPosition();
      double otherMemberPosition = Geolocator.distanceBetween(
        getCurrentLat,
        getCurrentLng,
        double.parse(otherMemberLat),
        double.parse(otherMemberLng),
      );
      SharedPrefs.writeOtherMemberPosition(otherMemberPosition);
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }
  
  Future<void> updateCurrentPosition(BuildContext context, PickResult position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.geometry!.location.lat, position.geometry!.location.lng);
      Placemark place = placemarks[0]; 
      SharedPrefs.writeLatLng(
        position.geometry!.location.lat,
        position.geometry!.location.lng,
      );
      SharedPrefs.writeCurrentAddress("${place.thoroughfare} ${place.subThoroughfare} \n${place.locality}, ${place.postalCode}");
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> getCurrentPositionCheckIn(BuildContext context) async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      SharedPrefs.writeLatLngCheckIn(position.latitude, position.longitude);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      SharedPrefs.writeCurrentAddressCheckIn("${place.thoroughfare} ${place.subThoroughfare} \n${place.locality}, ${place.postalCode}");
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    } 
  }

  Future<void> updateCurrentPositionCheckIn(BuildContext context, PickResult position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.geometry!.location.lat, position.geometry!.location.lng);
      Placemark place = placemarks[0]; 
      SharedPrefs.writeLatLngCheckIn(
        position.geometry!.location.lat,
        position.geometry!.location.lng,
      );
      SharedPrefs.writeCurrentAddressCheckIn("${place.thoroughfare} ${place.subThoroughfare} \n${place.locality}, ${place.postalCode}");
      googleMapCCheckIn?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.geometry!.location.lat, position.geometry!.location.lng),
            zoom: 15.0
          )
        )
      );
      NS.pop();
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  String get getCurrentNameAddress => SharedPrefs.getCurrentNameAddress(); 

  String get getCurrentNameAddressCheckIn => SharedPrefs.getCurrentNameAddressCheckIn(); 

  double get getCurrentLat => SharedPrefs.getLat();
  
  double get getCurrentLng => SharedPrefs.getLng();

  double get getCurrentLatCheckIn => SharedPrefs.getLatCheckIn();

  double get getCurrentLngCheckIn => SharedPrefs.getLngCheckIn();
}
