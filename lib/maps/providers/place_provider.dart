import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../src/models/pick_result.dart';
import '../src/place_picker.dart';
import 'package:flutter_google_maps_webservices/geocoding.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PlaceProvider extends ChangeNotifier {
  PlaceProvider(
    String apiKey,
    String? proxyBaseUrl,
    Client? httpClient,
    Map<String, dynamic> apiHeaders,
  ) {
    places = GoogleMapsPlaces(
      apiKey: apiKey,
      baseUrl: proxyBaseUrl,
      httpClient: httpClient,
      apiHeaders: apiHeaders as Map<String, String>?,
    );

    geocoding = GoogleMapsGeocoding(
      apiKey: apiKey,
      baseUrl: proxyBaseUrl,
      httpClient: httpClient,
      apiHeaders: apiHeaders as Map<String, String>?,
    );
  }

  static PlaceProvider of(BuildContext context, {bool listen = true}) =>
      Provider.of<PlaceProvider>(context, listen: listen);

  late GoogleMapsPlaces places;
  late GoogleMapsGeocoding geocoding;
  String? sessionToken;
  bool isOnUpdateLocationCooldown = false;
  LocationAccuracy? desiredAccuracy;
  bool isAutoCompleteSearching = false;

  Future<void> updateCurrentLocation(bool forceAndroidLocationManager) async {
    try {
      await Permission.location.request();
      if (await Permission.location.request().isGranted) {
        currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: desiredAccuracy ?? LocationAccuracy.best);
      } else {
        currentPosition = null;
      }
    } catch (e) {
      debugPrint(e.toString());
      currentPosition = null;
    }

    notifyListeners();
  }

  Position? _currentPoisition;
  Position? get currentPosition => _currentPoisition;
  set currentPosition(Position? newPosition) {
    _currentPoisition = newPosition;
    notifyListeners();
  }

  Timer? _debounceTimer;
  Timer? get debounceTimer => _debounceTimer;
  set debounceTimer(Timer? timer) {
    _debounceTimer = timer;
    notifyListeners();
  }

  CameraPosition? _previousCameraPosition;
  CameraPosition? get prevCameraPosition => _previousCameraPosition;
  setPrevCameraPosition(CameraPosition? prePosition) {
    _previousCameraPosition = prePosition;
  }

  CameraPosition? _currentCameraPosition;
  CameraPosition? get cameraPosition => _currentCameraPosition;
  setCameraPosition(CameraPosition? newPosition) {
    _currentCameraPosition = newPosition;
  }

  PickResult? _selectedPlace;
  PickResult? get selectedPlace => _selectedPlace;
  set selectedPlace(PickResult? result) {
    _selectedPlace = result;
    notifyListeners();
  }

  SearchingState _placeSearchingState = SearchingState.idle;
  SearchingState get placeSearchingState => _placeSearchingState;
  set placeSearchingState(SearchingState newState) {
    _placeSearchingState = newState;
    notifyListeners();
  }

  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;
  set mapController(GoogleMapController? controller) {
    _mapController = controller;
    notifyListeners();
  }

  PinState _pinState = PinState.preparing;
  PinState get pinState => _pinState;
  set pinState(PinState newState) {
    _pinState = newState;
    notifyListeners();
  }

  bool _isSeachBarFocused = false;
  bool get isSearchBarFocused => _isSeachBarFocused;
  set isSearchBarFocused(bool focused) {
    _isSeachBarFocused = focused;
    notifyListeners();
  }

  MapType _mapType = MapType.normal;
  MapType get mapType => _mapType;
  setMapType(MapType mapType, {bool notify = false}) {
    _mapType = mapType;
    if (notify) notifyListeners();
  }

  switchMapType() {
    _mapType = MapType.values[(_mapType.index + 1) % MapType.values.length];
    if (_mapType == MapType.none) _mapType = MapType.normal;

    notifyListeners();
  }
}