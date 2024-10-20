import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/data/models/checkin/checkin.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';

class CheckInRepo {
  Dio? dioClient;

  CheckInRepo({ required this.dioClient, }){
    dioClient ??= DioManager.shared.getClient();
  } 

  Future<CheckInModel> getCheckIn(String userId) async {
    try {
      Response res = await dioClient!.post("${AppConstants.baseUrl}/api/v1/checkin/all", data: {
        "user_id": userId,
      });
      Map<String, dynamic> cim = res.data;
      CheckInModel data = CheckInModel.fromJson(cim);
      return data;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  //unused
  Future<List> getCheckInDetailData(int checkInId) async {
    try {
      Response res = await dioClient!.get("${AppConstants.baseUrl}/chekin_detail/$checkInId");
      List cdm = res.data;
      return cdm;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> joinCheckIn(String checkInId, String userId) async {
    try {
      await dioClient!.post("${AppConstants.baseUrl}/api/v1/checkin/join", data: {
        "checkin_id": checkInId,
        "user_id": userId,
      });
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  //unused
  Future<void> checkInSavePostId(BuildContext context, int checkInId, String postId) async {
    try {
      await dioClient!.post("${AppConstants.baseUrl}/content-service/checkin-post",
        data: {
          "checkin_id": checkInId,
          "post_id": postId
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

  Future<void> createCheckIn(String caption, String desc, 
      String date, 
      String start, String end, 
      String placeName, String lat, String lng,
      String userId
    ) async {
    try {
      await dioClient!.post("${AppConstants.baseUrl}/api/v1/checkin/assign", data: {
        "title": caption,
        "desc": desc,
        "location": placeName,
        "lat": lat,
        "lng": lng,
        "start": start,
        "end": end,
        "user_id": userId,
        "checkin_date": date,
      });
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> deleteCheckIn( BuildContext context, String checkInId,) async {
    try {
      await dioClient!.post("${AppConstants.baseUrl}/api/v1/checkin/delete", data: {
        "id": checkInId,
      });
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
}