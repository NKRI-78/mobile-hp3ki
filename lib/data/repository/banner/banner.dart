import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/banner/banner.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';

class BannerRepo {
  Dio? dioClient;

  BannerRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<BannerModel?> getBanner() async {
    try {
      Response res = await dioClient!.get("${AppConstants.baseUrl}/api/v1/banner");
      Map<String, dynamic> dataJson = res.data;
      BannerModel data = BannerModel.fromJson(dataJson);
      return data;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
}