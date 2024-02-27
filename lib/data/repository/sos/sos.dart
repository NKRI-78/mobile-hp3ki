import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';

class SosRepo {
  Dio? dioClient;
  
  SosRepo({ required this.dioClient }) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<void> sendSos({
      required String type,
      required String message,
      required String userId,
      required String lat,
      required String lng,
    }) async {
    try {
      await dioClient!.post('${AppConstants.baseUrl}/api/v1/sos',
        data: {
          "title": type,
          "message": message,
          "origin_lat": lat,
          "origin_lng": lng,
          "user_id": userId
        }
      );
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

}