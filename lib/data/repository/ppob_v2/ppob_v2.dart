import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/ppob_v2/payment_guide.dart';
import 'package:hp3ki/data/models/ppob_v2/pln/inquiry_pra.dart';
import 'package:hp3ki/data/models/ppob_v2/denom_pulsa.dart';
import 'package:hp3ki/data/models/ppob_v2/payment_list.dart';
import 'package:hp3ki/data/models/ppob_v2/pln/list_price_pra.dart';
import 'package:hp3ki/data/models/ppob_v2/wallet_denom.dart';
import 'package:hp3ki/data/models/ppob_v2/wallet_balance.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';

class PPOBRepo {
  Dio? dioClient;

  PPOBRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<WalletDenomModel?> getWalletDenom() async {
    try {
      Response res = await dioClient!.get("${AppConstants.baseUrlPpob}/get/denom");
      Map<String, dynamic> dataJson = res.data;
      WalletDenomModel data = WalletDenomModel.fromJson(dataJson);
      return data;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<WalletBalanceModel?> getWalletBalance({required String userId}) async {
    try {
      Response res = await dioClient!.post("${AppConstants.baseUrlPpob}/get/balance", data: {
        "user_id": userId,
        "origin": "hp3ki",
      });
      Map<String, dynamic> dataJson = res.data;
      WalletBalanceModel data = WalletBalanceModel.fromJson(dataJson);
      return data;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  }

  Future<void> inquiryTopUpBalance({
      required String productId, 
      required String channel, 
      required String userId, 
      required String phone, 
      required String email, 
    }) async {
    try {
      await dioClient!.post("${AppConstants.baseUrlPpob}/inquiry/topup/balance", data: {
        "product_id": productId,
        "channel": channel,
        "user_id": userId,
        "phone_number": phone,
        "email_address": email,
        "origin": "hp3ki",
      });
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  }

  Future<PaymentListModel?> getPaymentList() async {
    try {
      Response res = await dioClient!.get("${AppConstants.baseUrlPpob}/payment_v2/pub/v1/payment/channels",);
      Map<String, dynamic> dataJson = res.data;
      PaymentListModel data = PaymentListModel.fromJson(dataJson);
      return data;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  }

  Future<void> initPaymentGatewayFCM({required String token, required String userId}) async {
    try {
      await dioClient!.post("${AppConstants.baseUrlPpob}/fcm", data: {
        "token": token,
        "origin": "hp3ki",
        "user_id": userId,
      });
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  }

  Future<DenomPulsaModel?> getDenomPulsa({required String prefix, required String type}) async {
    try {
      Response res = await dioClient!.get("${AppConstants.baseUrlPpob}/inquiry/pulsa?prefix=$prefix&type=$type");
      Map<String, dynamic> dataJson = res.data;
      DenomPulsaModel data = DenomPulsaModel.fromJson(dataJson);
      return data;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  }

  Future<InquiryPLNPrabayarModel?> postInquiryPLNPrabayar({required String idPel}) async {
    try {
      Response res = await dioClient!.post("${AppConstants.baseUrlPpob}/inquiry/pln-prabayar", data: {
        "idpel": idPel,
      });
      Map<String, dynamic> dataJson = res.data;
      InquiryPLNPrabayarModel data = InquiryPLNPrabayarModel.fromJson(dataJson);
      return data;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  }

  //PPR08
  Future<void> payPLNPrabayar({
    required String idPel,
    required String refTwo,
    required String nominal,
    required String userId,
  }) async {
    try {
      await dioClient!.post("${AppConstants.baseUrlPpob}/pay/pln-prabayar", data: {
        "idpel": idPel,
        "ref2": refTwo,
        "nominal": nominal,
        "user_id": userId,
      });
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  }

  //PPR09
  Future<void> payPulsa({
    required String productCode,
    required String phone,
    required String userId,
  }) async {
    try {
      await dioClient!.post("${AppConstants.baseUrlPpob}/pay/pulsa", data: {
        "product_code": productCode,
        "phone": phone,
        "user_id": userId,
      });
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  }

  Future<ListPricePraBayarModel> getListPricePLNPrabayar() async {
    try {
      Response res = await dioClient!.get("${AppConstants.baseUrlPpob}/price/list-pln-prabayar");
      Map<String, dynamic> dataJson = res.data;
      ListPricePraBayarModel data = ListPricePraBayarModel.fromJson(dataJson);
      return data;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  } 

  Future<void> createWalletData({required String userId}) async {
    try {
      await dioClient!.post("${AppConstants.baseUrlPpob}/create/wallet", data: {
        "user_id": userId,
        "origin": "hp3ki",
      });
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  } 

  Future<PaymentGuideModel?> getPaymentGuide({required String url}) async {
    try {
      if(url.contains('payment/howTo')) {
        Response res = await dioClient!.get(url);
        Map<String, dynamic> dataJson = res.data;
        PaymentGuideModel? data = PaymentGuideModel.fromJson(dataJson);
        return data;
      } else {
        throw CustomException('URL not found');
      }
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  } 

}