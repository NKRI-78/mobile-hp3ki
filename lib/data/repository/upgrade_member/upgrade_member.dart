import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:hp3ki/data/models/package_account/package_account_model.dart';
import 'package:hp3ki/data/models/payment_channel/payment_channel.dart';

import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';

class UpgradeMemberRepo {
  Dio? dioClient;

  UpgradeMemberRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<PaymentChannelModel?> getPaymentChannel() async {
    try {
      Response res = await dioClient!.get("${AppConstants.baseUrl}/api/v1/payment");
      Map<String, dynamic> dataJson = res.data;
      PaymentChannelModel data = PaymentChannelModel.fromJson(dataJson);
      return data;
    } on DioError catch (e) {
      debugPrint(e.toString());
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> sendPaymentInquiry({
    required String userId,
    required String paymentCode,
    required String channelId,
    PackageAccount? package
  }) async {
    try {
      var data = {
        "user_id": userId,
        "payment_code": paymentCode,
        "payment_channel": channelId,
        "package": package?.toJson()
      };
      await dioClient!.post('${AppConstants.baseUrl}/api/v1/payment/inquiry', data: data);
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  }

  Future<void> getPaymentCallback({required String trxId, required String amount}) async {
    try {
      await dioClient!.get('${AppConstants.baseUrl}/api/v1/callback?trx_id=$trxId&amount=$amount');
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  }
}
