import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/data/models/membernear/membernear.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';

class MembernearRepo {
  Dio? dioClient;

  MembernearRepo({ required this.dioClient }) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<MemberNearModel?> getMembernear({
    required double lat, 
    required double lng,
    required String userId,
  }) async {
    try {
      Response res = await dioClient!.post("${AppConstants.baseUrl}/api/v1/membernear", data: {
        "origin_lat": lat,
        "origin_lng": lng,
        "user_id": userId,
      });
      MemberNearModel data = MemberNearModel.fromJson(res.data);
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