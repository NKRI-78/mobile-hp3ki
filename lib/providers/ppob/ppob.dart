import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hp3ki/data/models/ppob_v2/denom_pulsa.dart';
import 'package:hp3ki/data/models/ppob_v2/payment_guide.dart';
import 'package:hp3ki/data/models/ppob_v2/payment_list.dart';
import 'package:hp3ki/data/models/ppob_v2/wallet_balance.dart';
import 'package:hp3ki/data/models/ppob_v2/wallet_denom.dart';
import 'package:hp3ki/data/repository/ppob_v2/ppob_v2.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/views/basewidgets/dialog/custom/custom.dart';
import 'package:hp3ki/services/database.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:hp3ki/data/models/ppob_v2/pln/inquiry_pasca.dart';
import 'package:hp3ki/data/models/ppob_v2/pln/inquiry_pra.dart';
import 'package:hp3ki/data/models/ppob_v2/pln/list_price_pra.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/views/screens/ppob/confirm_paymentv2.dart';
import '../../data/models/ppob_v2/selected_payment_method.dart';

enum PayStatus { idle, loading, loaded, empty, error }

enum PayPLNPrabayarStatus { idle, loading, loaded, empty, error }

enum InquiryPLNPrabayarStatus { loading, loaded, empty, error }

enum ListPricePLNPrabayarStatus { idle, loading, loaded, empty, error }

enum InquiryPLNPascabayarStatus { loading, loaded, empty, error }

enum ListVoucherPulsaByPrefixStatus { idle, loading, loaded, empty, error }

enum ListWalletDenomStatus { loading, loaded, empty, error }

enum VaStatus { loading, loaded, empty, error }

enum PaymentGuideStatus { loading, loaded, empty, error }

enum BalanceStatus { loading, loaded, empty, error }

enum InquiryDisbursementStatus { idle, loading, loaded, empty, error }

enum DenomDisbursementStatus { idle, loading, loaded, empty, error }

enum BankDisbursementStatus { loading, loaded, empty, error }

enum ContactUserStatus { idle, loading, loaded, empty, error }

enum SelectedContactUserStatus { idle, loading, loaded, empty, error }

class PPOBProvider with ChangeNotifier {
  final PPOBRepo pr;

  PPOBProvider({
    required this.pr,
  });

  double? balance;
  double? adminFee = 6500;

  int selectedBalancePln = -1;
  String selectedPaymentMethod = "-";
  bool isSelected = false;

  late InquiryPLNPrabayarData? inquiryPLNPrabayarData;
  late InquiryPLNPascaBayarData? inquiryPLNPascaBayarData;

  List<PaymentGuideData> _listPaymentGuide = [];
  List<PaymentGuideData> get listPaymentGuide => _listPaymentGuide;

  List<ListPricePraBayarData> _listPricePLNPrabayarData = [];
  List<ListPricePraBayarData> get listPricePLNPrabayarData =>
      _listPricePLNPrabayarData;

  List<DenomPulsaData> _listVoucherPulsaByPrefixData = [];
  List<DenomPulsaData> get listVoucherPulsaByPrefixData =>
      _listVoucherPulsaByPrefixData;

  List<PaymentListData> _listVa = [];
  List<PaymentListData> get listVa => _listVa;

  List<WalletDenomData> _listWalletDenom = [];
  List<WalletDenomData> get listWalletDenom => _listWalletDenom;

  SelectedPaymentMethodData? _selectedPaymentMethodData;
  SelectedPaymentMethodData? get selectedPaymentMethodData =>
      _selectedPaymentMethodData;

  List<Map<String, dynamic>> _contactUser = [];
  List<Map<String, dynamic>> get contactUser => _contactUser;

  List<Map<String, dynamic>> _selectedContacts = [];
  List<Map<String, dynamic>> get selectedContacts => _selectedContacts;

  PayStatus _payStatus = PayStatus.idle;
  PayStatus get payStatus => _payStatus;

  PayPLNPrabayarStatus _payPLNPrabayarStatus = PayPLNPrabayarStatus.idle;
  PayPLNPrabayarStatus get payPLNPrabayarStatus => _payPLNPrabayarStatus;

  ContactUserStatus _contactUserStatus = ContactUserStatus.loading;
  ContactUserStatus get contactUserStatus => _contactUserStatus;

  SelectedContactUserStatus _selectedContactUserStatus =
      SelectedContactUserStatus.loading;
  SelectedContactUserStatus get selectedContactUserStatus =>
      _selectedContactUserStatus;

  ListPricePLNPrabayarStatus _listPricePLNPrabayarStatus =
      ListPricePLNPrabayarStatus.idle;
  ListPricePLNPrabayarStatus get listPricePLNPrabayarStatus =>
      _listPricePLNPrabayarStatus;

  InquiryPLNPrabayarStatus _inquiryPLNPrabayarStatus =
      InquiryPLNPrabayarStatus.loading;
  InquiryPLNPrabayarStatus get inquiryPLNPrabayarStatus =>
      _inquiryPLNPrabayarStatus;

  InquiryPLNPascabayarStatus _inquiryPLNPascaBayarStatus =
      InquiryPLNPascabayarStatus.empty;
  InquiryPLNPascabayarStatus get inquiryPLNPascabayarStatus =>
      _inquiryPLNPascaBayarStatus;

  ListVoucherPulsaByPrefixStatus _listVoucherPulsaByPrefixStatus =
      ListVoucherPulsaByPrefixStatus.idle;
  ListVoucherPulsaByPrefixStatus get listVoucherPulsaByPrefixStatus =>
      _listVoucherPulsaByPrefixStatus;

  BalanceStatus _balanceStatus = BalanceStatus.loading;
  BalanceStatus get balanceStatus => _balanceStatus;

  PaymentGuideStatus _paymentGuideStatus = PaymentGuideStatus.loading;
  PaymentGuideStatus get paymentGuideStatus => _paymentGuideStatus;

  InquiryDisbursementStatus _inquirydisbursementStatus =
      InquiryDisbursementStatus.idle;
  InquiryDisbursementStatus get disbursementStatus =>
      _inquirydisbursementStatus;

  ListWalletDenomStatus _listWalletDenomStatus = ListWalletDenomStatus.empty;
  ListWalletDenomStatus get listWalletDenomStatus => _listWalletDenomStatus;

  DenomDisbursementStatus _denomDisbursementStatus =
      DenomDisbursementStatus.loading;
  DenomDisbursementStatus get denomDisbursementStatus =>
      _denomDisbursementStatus;

  VaStatus _vaStatus = VaStatus.loading;
  VaStatus get vaStatus => _vaStatus;

  void clearList() {
    listPricePLNPrabayarData.clear();
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePayPLNPrabayarStatus(PayPLNPrabayarStatus payPLNPrabayarStatus) {
    _payPLNPrabayarStatus = payPLNPrabayarStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateContactUserStatus(ContactUserStatus contactUserStatus) {
    _contactUserStatus = contactUserStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateSelectedContactUserStatus(
      SelectedContactUserStatus selectedContactUserStatus) {
    _selectedContactUserStatus = selectedContactUserStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePayStatus(PayStatus payStatus) {
    _payStatus = payStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateListPricePLNPrabayarStatus(
      ListPricePLNPrabayarStatus listPricePLNPrabayarStatus) {
    _listPricePLNPrabayarStatus = listPricePLNPrabayarStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateInquiryPLNPrabayarStatus(
      InquiryPLNPrabayarStatus inquiryPLNPrabayarStatus) {
    _inquiryPLNPrabayarStatus = inquiryPLNPrabayarStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateInquiryPLNPascabayarStatus(
      InquiryPLNPascabayarStatus inquiryPLNPascaBayarStatus) {
    _inquiryPLNPascaBayarStatus = inquiryPLNPascaBayarStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateListVoucherPulsaByPrefixStatus(
      ListVoucherPulsaByPrefixStatus listVoucherPulsaByPrefixStatus) {
    _listVoucherPulsaByPrefixStatus = listVoucherPulsaByPrefixStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateListWalletDenomStatus(
      ListWalletDenomStatus listWalletDenomStatus) {
    _listWalletDenomStatus = listWalletDenomStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateVAStatus(VaStatus vaStatus) {
    _vaStatus = vaStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateBalanceStatus(BalanceStatus walletStatus) {
    _balanceStatus = walletStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePaymentGuideStatus(PaymentGuideStatus paymentGuideStatus) {
    _paymentGuideStatus = paymentGuideStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateDisbursementStatus(
      InquiryDisbursementStatus inquirydisbursementStatus) {
    _inquirydisbursementStatus = inquirydisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateDenomDisbursementStatus(
      DenomDisbursementStatus denomDisbursementStatus) {
    _denomDisbursementStatus = denomDisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> payPLNPrabayar(
    BuildContext context, {
    required String idPel,
    required String refTwo,
    required String nominal,
  }) async {
    setStatePayStatus(PayStatus.loading);
    try {
      await pr.payPLNPrabayar(
        idPel: idPel,
        refTwo: refTwo,
        nominal: nominal,
        userId: SharedPrefs.getUserId(),
      );
      setStatePayStatus(PayStatus.loaded);
      CustomDialog.buildPaymentSuccessDialog(
          context, getTranslated("PAYMENT_SUCCESSFUL", context));
    } on DioError catch (e) {
      CustomDialog.showError(context, error: e.toString());
      setStatePayStatus(PayStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePayStatus(PayStatus.error);
    }
  }

  Future<void> payPLNPascabayar(
      BuildContext context, String accountNumber, String transactionId) async {
    setStatePayStatus(PayStatus.loading);
    try {
      Dio dio = DioManager.shared.getClient();
      await dio.post("${AppConstants.baseUrlPpob}/pln/pascabayar/pay", data: {
        "productId": "49c55554-8c62-4f80-8758-d8f0cea1b63b",
        "accountNumber": accountNumber,
        "paymentMethod": "WALLET",
        "paymentChannel": "WALLET",
        "transactionId": transactionId
      });
      setStatePayStatus(PayStatus.loaded);
      CustomDialog.buildPaymentSuccessDialog(
          context, getTranslated("PAYMENT_SUCCESSFUL", context));
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        ShowSnackbar.snackbar(
            "${e.response?.data["message"]}", "", ColorResources.error);
      }
      if (e.type == DioErrorType.response) {
        if (e.response!.statusCode == 500 || e.response!.statusCode == 411) {
          debugPrint("Internal Server Error (Pay PLN Pascabayar)");
        }
        if (e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if (e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStatePayStatus(PayStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePayStatus(PayStatus.error);
    }
  }

  Future<void> purchasePulsa(BuildContext context,
      {required String productCode, required String phone}) async {
    setStatePayStatus(PayStatus.loading);
    try {
      await pr.payPulsa(
          productCode: productCode,
          phone: phone,
          userId: SharedPrefs.getUserId());
      setStatePayStatus(PayStatus.loaded);
      CustomDialog.buildPaymentSuccessDialog(context);
    } on CustomException catch (e) {
      CustomDialog.showError(context, error: e.toString());
      setStatePayStatus(PayStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PPP01');
      setStatePayStatus(PayStatus.error);
    }
  }

  Future<void> inquiryTopUp(
      BuildContext context, String productId, String paymentChannel) async {
    setStatePayStatus(PayStatus.loading);
    try {
      await pr.inquiryTopUpBalance(
        productId: productId,
        channel: paymentChannel,
        userId: SharedPrefs.getUserId(),
        phone: SharedPrefs.getUserPhone(),
        email: SharedPrefs.getUserEmail(),
      );
      CustomDialog.buildPaymentSuccessDialog(context);
      setStatePayStatus(PayStatus.loaded);
    } on CustomException catch (e) {
      CustomDialog.showError(context, error: e.toString());
      setStatePayStatus(PayStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PPP02');
      setStatePayStatus(PayStatus.error);
    }
  }

  Future<void> initPaymentGatewayFCM(BuildContext context) async {
    try {
      await pr.initPaymentGatewayFCM(
        token: await FirebaseMessaging.instance.getToken() ?? "-",
        userId: SharedPrefs.getUserId(),
      );
      debugPrint('Init PG FCM: 200');
    } on DioError catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(e.toString(), "", ColorResources.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> postInquiryPLNPrabayarStatus(
    BuildContext context, {
    required int index,
    required String idPel,
    required String price,
  }) async {
    selectedBalancePln = index;
    setStatePayPLNPrabayarStatus(PayPLNPrabayarStatus.loading);
    try {
      InquiryPLNPrabayarModel? inquiryPLNPrabayarModel =
          await pr.postInquiryPLNPrabayar(idPel: idPel);
      inquiryPLNPrabayarData = inquiryPLNPrabayarModel!.body!;

      setStatePayPLNPrabayarStatus(PayPLNPrabayarStatus.loaded);
      setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus.loaded);

      NS.push(
          context,
          ConfirmPaymentV2(
              idPelPLN: idPel,
              refTwoPLN: inquiryPLNPrabayarData!.ref2!,
              description: 'Isi PLN Prabayar sebesar $price',
              price: double.parse(price),
              productName: inquiryPLNPrabayarData!.kodeProduk!,
              accountNumber: SharedPrefs.getUserPhone(),
              adminFee: 2000,
              type: "pln-prabayar"));
    } on CustomException catch (e) {
      selectedBalancePln = -1;
      CustomDialog.showError(context, error: e.toString());
      setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus.error);
      setStatePayPLNPrabayarStatus(PayPLNPrabayarStatus.error);
    } catch (e, stacktrace) {
      selectedBalancePln = -1;
      debugPrint(stacktrace.toString());
      setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus.error);
      CustomDialog.showUnexpectedError(context, errorCode: 'PPP04');
      setStatePayPLNPrabayarStatus(PayPLNPrabayarStatus.error);
    }
  }

  Future<void> postInquiryPLNPascaBayar(
      BuildContext context, String accountNumber) async {
    setStateInquiryPLNPascabayarStatus(InquiryPLNPascabayarStatus.loading);
    try {
      Dio dio = DioManager.shared.getClient();
      Response res = await dio
          .post("${AppConstants.baseUrlPpob}/pln/pascabayar/inquiry", data: {
        "productId": "49c55554-8c62-4f80-8758-d8f0cea1b63b",
        "accountNumber": accountNumber
      });

      InquiryPLNPascabayarModel inquiryPLNPascaBayarModel =
          InquiryPLNPascabayarModel.fromJson(res.data);
      inquiryPLNPascaBayarData = inquiryPLNPascaBayarModel.body!;

      setStateInquiryPLNPascabayarStatus(InquiryPLNPascabayarStatus.loaded);

      NS.push(
          context,
          ConfirmPaymentV2(
              productId: inquiryPLNPascaBayarData!.productId!,
              description: inquiryPLNPascaBayarData!.productName!,
              price: inquiryPLNPascaBayarData!.productPrice,
              provider: inquiryPLNPascaBayarData!.productName!,
              accountNumber: inquiryPLNPascaBayarData!.accountNumber1!,
              productName: inquiryPLNPascaBayarData!.data!.accountName!,
              type: "pln-pascabayar"));
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        ShowSnackbar.snackbar(
            "${e.response?.data["message"]}", "", ColorResources.error);
      }
      if (e.type == DioErrorType.response) {
        if (e.response!.statusCode == 500 || e.response!.statusCode == 411) {
          debugPrint(
              "Internal Server Error (Post Inquiry PLN Pascabayar Status)");
        }
        if (e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if (e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateInquiryPLNPascabayarStatus(InquiryPLNPascabayarStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PPP05');
      setStateInquiryPLNPascabayarStatus(InquiryPLNPascabayarStatus.error);
    }
  }

  void clearListPricePLN() {
    _listPricePLNPrabayarData.clear();
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getListPricePLNPrabayar(context) async {
    setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.loading);
    try {
      ListPricePraBayarModel listPricePraBayarModel =
          await pr.getListPricePLNPrabayar();
      List<ListPricePraBayarData> lpPpbd = listPricePraBayarModel.body!;
      if (lpPpbd.isEmpty) {
        setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.empty);
      } else {
        _listPricePLNPrabayarData = [];
        _listPricePLNPrabayarData.addAll(lpPpbd);
        setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.loaded);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PPP06');
      setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.error);
    }
  }

  void clearVoucherPulsaByPrefix() {
    _listVoucherPulsaByPrefixData.clear();
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getVoucherPulsaByPrefix(BuildContext context,
      {required int prefix, required String type}) async {
    setStateListVoucherPulsaByPrefixStatus(
        ListVoucherPulsaByPrefixStatus.loading);
    try {
      DenomPulsaModel? listVoucherPulsaByPrefixModel =
          await pr.getDenomPulsa(prefix: prefix.toString(), type: type);
      List<DenomPulsaData>? l = listVoucherPulsaByPrefixModel?.body;
      if (l!.isEmpty) {
        setStateListVoucherPulsaByPrefixStatus(
            ListVoucherPulsaByPrefixStatus.empty);
      } else {
        _listVoucherPulsaByPrefixData = [];
        _listVoucherPulsaByPrefixData.addAll(l);
        setStateListVoucherPulsaByPrefixStatus(
            ListVoucherPulsaByPrefixStatus.loaded);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateListVoucherPulsaByPrefixStatus(
          ListVoucherPulsaByPrefixStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PPP07');
      setStateListVoucherPulsaByPrefixStatus(
          ListVoucherPulsaByPrefixStatus.error);
    }
  }

  Future<void> getVA(BuildContext context) async {
    try {
      PaymentListModel? model = await pr.getPaymentList();
      List<PaymentListData> data = model!.body!;
      if (data.isEmpty) {
        setStateVAStatus(VaStatus.empty);
      } else {
        _listVa = [];
        _listVa.addAll(data);
        setStateVAStatus(VaStatus.loaded);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateVAStatus(VaStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PPP08');
      setStateVAStatus(VaStatus.error);
    }
  }

  Future<void> getBalance(BuildContext context) async {
    setStateBalanceStatus(BalanceStatus.loading);
    try {
      WalletBalanceModel? balanceModel =
          await pr.getWalletBalance(userId: SharedPrefs.getUserId());
      balance = balanceModel!.body!.balance!.toDouble();
      setStateBalanceStatus(BalanceStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateBalanceStatus(BalanceStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PPP09');
      setStateBalanceStatus(BalanceStatus.error);
    }
  }

  Future<void> getListWalletDenom(BuildContext context) async {
    setStateListWalletDenomStatus(ListWalletDenomStatus.loading);
    try {
      _listWalletDenom = [];
      WalletDenomModel? wdm = await pr.getWalletDenom();
      List<WalletDenomData>? data = wdm?.body?.data;
      if (data?.isNotEmpty == true) {
        _listWalletDenom.addAll(data!);
        setStateListWalletDenomStatus(ListWalletDenomStatus.loaded);
      } else {
        setStateListWalletDenomStatus(ListWalletDenomStatus.empty);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateListWalletDenomStatus(ListWalletDenomStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PPP10');
      setStateListWalletDenomStatus(ListWalletDenomStatus.error);
    }
  }

  Future<void> createWalletData(BuildContext context) async {
    try {
      await pr.createWalletData(userId: SharedPrefs.getUserId());
    } on CustomException catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(e.toString(), '', ColorResources.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PPP11');
    }
  }

  Future<void> getPaymentGuide(BuildContext context, String url) async {
    setStatePaymentGuideStatus(PaymentGuideStatus.loading);
    try {
      _listPaymentGuide = [];
      PaymentGuideModel? wdm = await pr.getPaymentGuide(url: url);
      List<PaymentGuideData> data = wdm!.body!;
      if (data.isNotEmpty == true) {
        _listPaymentGuide.addAll(data);
        setStatePaymentGuideStatus(PaymentGuideStatus.loaded);
      } else {
        setStatePaymentGuideStatus(PaymentGuideStatus.empty);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStatePaymentGuideStatus(PaymentGuideStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PPP12');
      setStatePaymentGuideStatus(PaymentGuideStatus.error);
    }
  }

  Future<void> getUsers() async {
    try {
      List<Map<String, dynamic>> gu = await DBHelper.getUsers();
      _contactUser = [];
      _contactUser.addAll(gu);
      setStateContactUserStatus(ContactUserStatus.loaded);
      if (contactUser.isEmpty) {
        setStateContactUserStatus(ContactUserStatus.empty);
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateContactUserStatus(ContactUserStatus.error);
    }
  }

  Future<void> getUserStatus() async {
    try {
      _selectedContacts = [];
      List<Map<String, dynamic>> gus = await DBHelper.getUsersStatus();
      _selectedContacts.addAll(gus);
      setStateSelectedContactUserStatus(SelectedContactUserStatus.loaded);
      if (selectedContacts.isEmpty) {
        setStateSelectedContactUserStatus(SelectedContactUserStatus.empty);
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> updateUsersStatus(
      {required String name, required String phone}) async {
    try {
      await DBHelper.updateUsersStatus('contacts', data: {
        "name": name,
        "phone": phone,
      });
      Future.delayed(Duration.zero, () {
        getUserStatus();
      });
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> updateUsers(
      {required String name, required String phone}) async {
    try {
      DBHelper.resetUsersStatus('contacts');
      await DBHelper.update('contacts', data: {"name": name, "phone": phone});
      Future.delayed(Duration.zero, () {
        getUsers();
        getUserStatus();
      });
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> insertUsers(
      {required String name, required String phone}) async {
    try {
      await DBHelper.resetUsersStatus('contacts');
      await DBHelper.insert('contacts',
          data: {"id": "a", "name": name, "status": "true", "phone": phone});
      Future.delayed(Duration.zero, () {
        getUsers();
        getUserStatus();
      });
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> deleteUsers({required String id}) async {
    try {
      await DBHelper.delete('contacts', id: id);
      Future.delayed(Duration.zero, () {
        getUsers();
      });
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  void setPaymentMethod(
      {required String id, required String name, required String channel}) {
    isSelected = true;
    selectedPaymentMethod = name;
    _selectedPaymentMethodData = SelectedPaymentMethodData(
      id: id,
      name: name,
      channel: channel,
    );
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void resetPaymentMethod() {
    isSelected = false;
    selectedPaymentMethod = "Belum ada metode pembayaran";
    _selectedPaymentMethodData = const SelectedPaymentMethodData();
    Future.delayed(Duration.zero, () => notifyListeners());
  }
}
