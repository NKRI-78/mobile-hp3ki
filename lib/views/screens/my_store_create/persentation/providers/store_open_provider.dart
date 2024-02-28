import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hp3ki/views/screens/my_store_create/domain/store_open_repository.dart';

class StoreOpenProvider with ChangeNotifier {
  final StoreOpenRepository repo;

  StoreOpenProvider({required this.repo});

  Future<void> createStore({
    required String email,
    required String phone,
    required String name,
    required String province,
    required String city,
    required String district,
    required String subDistrict,
    required String postalCode,
    required String detailAddress,
    required double lat,
    required double long,
    File? file,
    required String description,
  }) async {
    try {
      await repo.createStore(
          email: email,
          phone: phone,
          name: name,
          province: province,
          city: city,
          district: district,
          subDistrict: subDistrict,
          postalCode: postalCode,
          detailAddress: detailAddress,
          lat: lat,
          file: file,
          description: description,
          long: long);
    } catch (e) {
      rethrow;
    }
  }
}
