import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/event/event.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';

class EventRepo {
  Dio? dioClient;

  EventRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<List<EventData>?> getEvent({required String userId}) async {
    try {
      Response response = await dioClient!.post("${AppConstants.baseUrl}/api/v1/event", data: {
        "user_id": userId,
      });
      EventModel em = EventModel.fromJson(response.data);
      List<EventData>? result = em.data;
      return result;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> joinEvent({required String eventId, required String userId}) async {
    try {
      await dioClient!.post("${AppConstants.baseUrl}/api/v1/event/join", 
        data: {
          "event_id": eventId,
          "user_id": userId,
        }
      ); 
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  //unused
  Future<void> presentEvent(BuildContext context, {required String eventId}) async {
    try {
      await dioClient!.post("${AppConstants.baseUrl}/content-service/event/present", 
        data: {
          "event_id": eventId,
          "user_id": 'ar.getUserId()'
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