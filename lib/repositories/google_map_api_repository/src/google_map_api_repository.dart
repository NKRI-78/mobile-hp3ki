import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hp3ki/repositories/google_map_api_repository/src/models/place_autocomplete.dart';

class GoogleMapApiRepository {
  GoogleMapApiRepository();

  String apiKey = 'AIzaSyCJD7w_-wHs4Pe5rWMf0ubYQFpAt2QF2RA';

  String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?';

  String urlCoor(String placeId) =>
      'https://maps.googleapis.com/maps/api/geocode/json?place_id=$placeId&key=$apiKey';

  Future<List<PlaceAutocomplete>> getPlace(String text) async {
    final response = await Dio().get(
      '${url}input=$text&radius=1500&key=$apiKey&language=id',
    );
    // print(response.data);

    if (response.statusCode == 200) {
      final data = response.data;
      List predictions = data['predictions'];
      final locationModels = predictions.map((prediction) {
        return PlaceAutocomplete(
          prediction['description'] ?? '',
          prediction['place_id'] ?? '',
        );
      }).toList();

      return locationModels;
    } else {
      return [];
    }
  }

  Future<LatLng?> getCoordinatePlace(String placeId) async {
    final response = await Dio().get(urlCoor(placeId));

    if (response.statusCode == 200) {
      final data = response.data;
      final results = data['results'] as List;
      final result = results.first;
      // print(result);
      final location = result['geometry']['location'];
      return LatLng(location['lat'] ?? 0, location['lng'] ?? 0);
    }
    return null;
  }
}
