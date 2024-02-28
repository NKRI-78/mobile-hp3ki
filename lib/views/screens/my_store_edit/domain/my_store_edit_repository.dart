import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/shared_preferences.dart';

class MyStoreEditRepository {
  final Dio client;

  MyStoreEditRepository({required this.client});

  Future<String> uploadMedia(File image) async {
    try {
      final formData = FormData.fromMap({
        "folder": "stores",
        "media": await MultipartFile.fromFile(
          image.path,
        ),
      });
      final resUpload = await client
          .post(AppConstants.baseUrl + '/api/v1/media', data: formData);

      return resUpload.data['data']['path'];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStore({
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
    required String path,
    required String description,
    required bool open,
  }) async {
    try {
      final userId = SharedPrefs.getUserId();

      await client.post("${AppConstants.baseUrl}/api/v1/store", data: {
        "name": name,
        "owner": userId,
        "description": description,
        "picture": path,
        "province": province,
        "city": city,
        "district": district,
        "subdistrict": subDistrict,
        "postal_code": postalCode,
        "address": detailAddress,
        "email": email,
        "phone": phone,
        "lat": lat.toString(),
        "lng": long.toString(),
        "open": open ? "1" : "0",
      });
    } on DioError catch (e) {
      debugPrint(e.response.toString());
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
