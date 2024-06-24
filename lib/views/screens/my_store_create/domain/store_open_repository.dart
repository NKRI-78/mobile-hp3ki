import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/shared_preferences.dart';

class StoreOpenRepository {
  final Dio client;

  StoreOpenRepository({required this.client});

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
      final userId = SharedPrefs.getUserId();

      String filePath = '-';

      if (file != null) {
        final formData = FormData.fromMap({
          "folder": "stores",
          "media": await MultipartFile.fromFile(
            file.path,
          ),
        });
        final resUpload = await client
            .post(AppConstants.baseUrl + "/api/v1/media", data: formData);

        filePath = resUpload.data['data']['path'];
      }

      await client.post("${AppConstants.baseUrl}/api/v1/store", data: {
        "name": name,
        "owner": userId,
        "description": description,
        "picture": filePath,
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
        "open": "0"
      });
    } on DioError catch (e) {
      debugPrint(e.response.toString());
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
