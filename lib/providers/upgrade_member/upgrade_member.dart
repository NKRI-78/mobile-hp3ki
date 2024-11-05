import 'package:flutter/material.dart';
import 'package:hp3ki/data/models/payment_channel/payment_channel.dart';

import 'package:hp3ki/data/repository/upgrade_member/upgrade_member.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/exceptions.dart';

import 'package:hp3ki/data/models/package_account/package_account_model.dart';

import 'package:hp3ki/views/basewidgets/dialog/custom/custom.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';

enum PaymentChannelStatus { idle, loading, loaded, error, empty }

enum InquiryStatus { idle, loading, loaded, error, empty }

enum PaymentCallbackStatus { idle, loading, loaded, error, empty }

class UpgradeMemberProvider with ChangeNotifier {
  final UpgradeMemberRepo umr;

  UpgradeMemberProvider({
    required this.umr,
  });

  PaymentChannelStatus _paymentChannelStatus = PaymentChannelStatus.empty;
  PaymentChannelStatus get paymentChannelStatus => _paymentChannelStatus;

  InquiryStatus _inquiryStatus = InquiryStatus.empty;
  InquiryStatus get inquiryStatus => _inquiryStatus;

  PaymentCallbackStatus _paymentCallbackStatus = PaymentCallbackStatus.empty;
  PaymentCallbackStatus get paymentCallbackStatus => _paymentCallbackStatus;

  List<PaymentChannelData> _paymentChannel = [];
  List<PaymentChannelData> get paymentChannel => _paymentChannel;

  PaymentChannelData? _selectedPaymentChannel;
  PaymentChannelData? get selectedPaymentChannel => _selectedPaymentChannel;

  void setStatePaymentChannelStatus(PaymentChannelStatus paymentChannelStatus) {
    _paymentChannelStatus = paymentChannelStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateInquiryStatus(InquiryStatus inquiryStatus) {
    _inquiryStatus = inquiryStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePaymentCallbackStatus(
      PaymentCallbackStatus paymentCallbackStatus) {
    _paymentCallbackStatus = paymentCallbackStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setSelectedPaymentChannel(PaymentChannelData data) {
    _selectedPaymentChannel = data;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void undoSelectedPaymentChannel() {
    _selectedPaymentChannel = null;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getPaymentChannel(BuildContext context) async {
    setStatePaymentChannelStatus(PaymentChannelStatus.loading);
    try {
      PaymentChannelModel? paymentChannelModel = await umr.getPaymentChannel();
      _paymentChannel = [];
      if (paymentChannelModel!.data.isNotEmpty) {
        _paymentChannel.addAll(paymentChannelModel.data);
        setStatePaymentChannelStatus(PaymentChannelStatus.loaded);
      } else {
        setStatePaymentChannelStatus(PaymentChannelStatus.empty);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStatePaymentChannelStatus(PaymentChannelStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePaymentChannelStatus(PaymentChannelStatus.error);
    }
  }

  Future<void> sendPaymentInquiry(
    BuildContext context, {
    required String userId,
    required String paymentCode,
    required String channelId
  }) async {
    setStateInquiryStatus(InquiryStatus.loading);
    try {
      await umr.sendPaymentInquiry(userId: userId, paymentCode: paymentCode, channelId: channelId);
      CustomDialog.buildPaymentSuccessDialog(context);
      setStateInquiryStatus(InquiryStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(e.toString(), '', ColorResources.error);
      setStateInquiryStatus(InquiryStatus.error);
    } catch (e, stacktrace) {
      ShowSnackbar.snackbar(e.toString(), '', ColorResources.error);
      debugPrint(stacktrace.toString());
      setStateInquiryStatus(InquiryStatus.error);
    }
  }

  Future<void> sendPaymentInquiryV2(BuildContext context, {
    required String userId,
    required String paymentCode,
    required String channelId,
    required PackageAccount package
  }) async {
    setStateInquiryStatus(InquiryStatus.loading);
    try {
      await umr.sendPaymentInquiry(userId: userId, paymentCode: paymentCode, channelId: channelId, package: package);
      CustomDialog.buildPaymentSuccessDialog(context);
      setStateInquiryStatus(InquiryStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(e.toString(), '', ColorResources.error);
      setStateInquiryStatus(InquiryStatus.error);
    } catch (e, stacktrace) {
      ShowSnackbar.snackbar(e.toString(), '', ColorResources.error);
      debugPrint(stacktrace.toString());
      setStateInquiryStatus(InquiryStatus.error);
    }
  }

  Future<void> getPaymentCallback(BuildContext context,
      {required String trxId, required String amount}) async {
    setStatePaymentCallbackStatus(PaymentCallbackStatus.loading);
    try {
      await umr.getPaymentCallback(trxId: trxId, amount: amount);
      setStatePaymentCallbackStatus(PaymentCallbackStatus.loaded);
    } on CustomException catch (e) {
      //UR03
      debugPrint(e.toString());
      setStatePaymentCallbackStatus(PaymentCallbackStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePaymentCallbackStatus(PaymentCallbackStatus.error);
    }
  }
}
