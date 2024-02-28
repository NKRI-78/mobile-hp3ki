import 'package:flutter/material.dart';
import 'package:hp3ki/views/screens/shipping_address_add/domain/shipping_address_add_repository.dart';

import 'package:uuid/uuid.dart';

class ShippingAddressAddProvider with ChangeNotifier {
  final ShippingAddressAddRepository repo;

  ShippingAddressAddProvider({required this.repo});

  Future<void> addAddress({
    required String address,
    required String postalCode,
    required String province,
    required String city,
    required String district,
    required String subDistrict,
    required String name,
    required double lat,
    required double lng,
    required String phoneNumber,
  }) async {
    try {
      final uid = const Uuid().v4();
      await repo.addOrUpdateAddress(
        uid: uid,
        address: address,
        postalCode: postalCode,
        province: province,
        city: city,
        district: district,
        subDistrict: subDistrict,
        name: name,
        lat: lat,
        lng: lng,
        phoneNumber: phoneNumber,
      );
    } catch (e) {
      rethrow;
    }
  }
}
