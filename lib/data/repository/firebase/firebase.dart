import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/utils/constant.dart';

class FirebaseRepo {
  Dio? dioClient;

  FirebaseRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<void> initFcm({ required String token, required String userId, required String lat, required String lng}) async {
    try {
      await dioClient!.post("${AppConstants.baseUrl}/api/v1/fcm", 
        data: {
          "user_id": userId,
          "token": token,
          "lat": lat,
          "lng": lng,
        }
      );
      if(kDebugMode) print('Init FCM: 200');
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
}