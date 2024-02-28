import 'package:dio/dio.dart';
import 'package:hp3ki/utils/constant.dart';

class ShippingAddressAddRepository {
  final Dio client;

  ShippingAddressAddRepository({required this.client});

  Future<void> addOrUpdateAddress({
    required String uid,
    required String address,
    required String postalCode,
    required String province,
    required String city,
    required String district,
    required String subDistrict,
    required String name,
    required double lat,
    required double lng,
    String defaultLocation = "0",
    required String phoneNumber,
  }) async {
    try {
      await client
          .post('${AppConstants.baseUrl}/api/v1/shipping-address/', data: {
        "uid": uid,
        "address": address.replaceAll("\n", " "),
        "postal_code": postalCode,
        "province": province,
        "city": city,
        "district": district,
        "subdistrict": subDistrict,
        "name": name,
        "lat": lat,
        "lng": lng,
        "default_location": defaultLocation,
        "phone_number": phoneNumber,
      });
    } catch (e) {
      rethrow;
    }
  }
}
