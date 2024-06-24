import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hp3ki/views/screens/my_store_edit/domain/my_store_edit_repository.dart';

class MyStoreEditProvider with ChangeNotifier {
  final MyStoreEditRepository repo;

  MyStoreEditProvider({required this.repo});

  Future<void> updateStore(
      {required String email,
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
      required bool statusOpenStore,
      required String oldImage,
      required String description,
      required String storeId}) async {
    try {
      String pathFinal;
      if (file != null) {
        pathFinal = await repo.uploadMedia(file);
      } else {
        pathFinal = oldImage;
      }

      await repo.updateStore(
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
        long: long,
        path: pathFinal,
        description: description,
        open: statusOpenStore,
      );
    } catch (e) {
      rethrow;
    }
  }
}
