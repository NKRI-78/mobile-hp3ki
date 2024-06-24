import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/package_account/package_account_model.dart';
import 'package:hp3ki/data/models/ppob_v2/payment_list.dart';
import 'package:hp3ki/data/models/upgrade_member/inquiry.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';

class UpgradeMemberRepo {
  Dio? dioClient;

  UpgradeMemberRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<PaymentListModel?> getPaymentChannel() async {
    try {
      Response res = await dioClient!.get(
        "${AppConstants.baseUrlPpob}/payment_v2/pub/v1/payment/channels",
      );
      Map<String, dynamic> dataJson = res.data;
      PaymentListModel data = PaymentListModel.fromJson(dataJson);
      return data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<InquiryModel?> sendPaymentInquiry(
      {required String userId,
      required String paymentCode,
      PackageAccount? package}) async {
    try {
      Response res = await dioClient!
          .post('${AppConstants.baseUrl}/api/v1/payment/inquiry', data: {
        "user_id": userId,
        "payment_code": paymentCode,
        "package": package?.toJson()
      });
      InquiryModel data = InquiryModel.fromJson(res.data);
      return data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  }

  Future<void> getPaymentCallback(
      {required String trxId, required String amount}) async {
    try {
      await dioClient!.get(
          '${AppConstants.baseUrl}/api/v1/callback?trx_id=$trxId&amount=$amount');
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  }
}
