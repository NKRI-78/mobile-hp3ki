import 'package:flutter/material.dart';
import 'package:hp3ki/data/models/package_account/package_account_model.dart';
import 'package:hp3ki/data/models/ppob_v2/payment_list.dart';
import 'package:hp3ki/data/repository/upgrade_member/upgrade_member.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/exceptions.dart';
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

  List<PaymentListData>? _paymentChannel = [];
  List<PaymentListData>? get paymentChannel => _paymentChannel;

  PaymentListData? _selectedPaymentChannel;
  PaymentListData? get selectedPaymentChannel => _selectedPaymentChannel;

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

  void setSelectedPaymentChannel(PaymentListData data) {
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
      _paymentChannel = [];
      PaymentListModel? plm = await umr.getPaymentChannel();
      if (plm!.body!.isNotEmpty) {
        _paymentChannel!.addAll(plm.body!);
        setStatePaymentChannelStatus(PaymentChannelStatus.loaded);
      } else {
        setStatePaymentChannelStatus(PaymentChannelStatus.empty);
      }
    } on CustomException catch (e) {
      //UR01
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
  }) async {
    setStateInquiryStatus(InquiryStatus.loading);
    try {
      await umr.sendPaymentInquiry(userId: userId, paymentCode: paymentCode);
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

  Future<void> sendPaymentInquiryV2(BuildContext context,
      {required String userId,
      required String paymentCode,
      required PackageAccount package}) async {
    setStateInquiryStatus(InquiryStatus.loading);
    try {
      await umr.sendPaymentInquiry(
          userId: userId, paymentCode: paymentCode, package: package);
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
