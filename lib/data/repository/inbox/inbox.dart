import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import 'package:hp3ki/data/models/inbox/count.dart';
import 'package:hp3ki/data/models/inbox/detail.dart';
import 'package:hp3ki/data/models/inbox/inbox.dart';

import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';

class InboxRepo {
  Dio? dioClient;

  InboxRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<InboxModel?> getInbox({
    required String userId, 
    required String type,
    int? page = 1
  }) async {
    try {
      Response res = await dioClient!.post("${AppConstants.baseUrl}/api/v1/inbox?page=$page&limit=50",
      data: {
        "user_id": userId,
        "type": type,
      });
      InboxModel data = InboxModel.fromJson(res.data);
      return data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  }

  Future<InboxDetailModel> getInboxDetail({
    required String id
  }) async {
    try {
     Response res = await dioClient!.post("${AppConstants.baseUrl}/api/v1/inbox/detail",
      data: {
        "id": id,
      });
      InboxDetailModel data = InboxDetailModel.fromJson(res.data);
      return data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage); 
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  }

  Future<InboxCountModel?> getInboxCount({required String userId}) async {
    try {
      Response res = await dioClient!.post("${AppConstants.baseUrl}/api/v1/inbox/badges", data: {
        "user_id": userId,
      });
      InboxCountModel data = InboxCountModel.fromJson(res.data);
      return data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
  
  Future<void> updateInboxPayment({required int inboxId}) async {
    try {
      await dioClient!.post("${AppConstants.baseUrlPpob}/inbox/update", data: {
        "id": inboxId,
      });
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  // Future<InboxPaymentModel?> getInboxPayment(
  //     {required String userId, int? page = 1}) async {
  //   try {
  //     Response res = await dioClient!
  //         .post("${AppConstants.baseUrlPpob}/inbox?page=$page&limit=6", data: {
  //       "user_id": userId,
  //       "origin": "hp3ki",
  //     });
  //     InboxPaymentModel data = InboxPaymentModel.fromJson(res.data);
  //     return data;
  //   } on DioError catch (e) {
  //     final errorMessage = DioExceptions.fromDioError(e).toString();
  //     throw CustomException(errorMessage);
  //   } catch (e, stacktrace) {
  //     debugPrint(stacktrace.toString());
  //     throw CustomException(stacktrace.toString());
  //   }
  // }

  // Future<InboxCountPaymentModel?> getInboxCountPayment({
  //   required String userId
  // }) async {
  //   try {
  //     Response res = await dioClient!
  //         .post("${AppConstants.baseUrlPpob}/inbox/badges", data: {
  //       "user_id": userId,
  //       "origin": "hp3ki",
  //     });
  //     Map<String, dynamic> dataJson = res.data;
  //     InboxCountPaymentModel data = InboxCountPaymentModel.fromJson(dataJson);
  //     return data;
  //   } on DioError catch (e) {
  //     debugPrint(e.response!.data.toString());
  //     final errorMessage = DioExceptions.fromDioError(e).toString();
  //     throw CustomException(errorMessage);
  //   } catch (e, stacktrace) {
  //     debugPrint(stacktrace.toString());
  //     throw CustomException(stacktrace.toString());
  //   }
  // }
}
