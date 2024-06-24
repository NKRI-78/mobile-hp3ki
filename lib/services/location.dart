import 'dart:async';

import 'package:location/location.dart';

class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({
    required this.latitude, 
    required this.longitude
  });
}

class LocationService {
  late UserLocation currentLocation;
  Location location = Location();

  StreamController<UserLocation> locationC = StreamController<UserLocation>.broadcast();

  LocationService() {
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) {
          locationC.add(UserLocation(
            latitude: locationData.latitude!,
            longitude: locationData.longitude!,
          ));
        });
      }
    });
  }

  Stream<UserLocation> get locationStream => locationC.stream;
}