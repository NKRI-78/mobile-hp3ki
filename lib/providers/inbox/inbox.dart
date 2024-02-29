import 'package:flutter/material.dart';
import 'package:hp3ki/data/models/inbox/count.dart';
import 'package:hp3ki/data/models/inbox/inbox_payment.dart';
import 'package:hp3ki/data/repository/inbox/inbox.dart';
import 'package:hp3ki/data/models/inbox/inbox.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/views/basewidgets/dialog/custom/custom.dart';
import 'package:hp3ki/views/screens/notification/detail.dart';

enum InboxInfoStatus { idle, loading, loaded, error, empty }

enum FetchInboxInfoStatus { idle, loading, loaded, error, empty }

enum InboxPanicStatus { idle, loading, loaded, error, empty }

enum FetchInboxPanicStatus { idle, loading, loaded, error, empty }

enum InboxPaymentStatus { idle, loading, loaded, error, empty }

enum FetchInboxPaymentStatus { idle, loading, loaded, error, empty }

enum InboxCountStatus { idle, loading, loaded, error, empty }

enum InboxDetailStatus { idle, loading, loaded, error, empty }

class InboxProvider with ChangeNotifier {
  final InboxRepo ir;

  InboxProvider({required this.ir});

  int? _readCount;
  int? get readCount => _readCount;

  InboxData? _inboxDetail;
  InboxData? get inboxDetail => _inboxDetail;

  InboxPaymentData? _inboxPaymentDetail;
  InboxPaymentData? get inboxPaymentDetail => _inboxPaymentDetail;

  InboxModel? _inboxModel;
  InboxModel? get inboxModel => _inboxModel;

  int inboxInfoPageCount = 1;
  int inboxPaymentPageCount = 1;
  int inboxPanicPageCount = 1;

  bool isLoadInboxInfo = false;
  bool isLoadInboxPayment = false;
  bool isLoadInboxPanic = false;

  List<InboxData>? _inboxInfo;
  List<InboxData>? get inboxInfo => _inboxInfo;

  int? _inboxInfoCount;

  int? get inboxInfoCount => _inboxInfoCount;
  int inboxTransactionCount = 0;

  InboxPaymentModel? _inboxPaymentModel;
  InboxPaymentModel? get inboxPaymentModel => _inboxPaymentModel;

  List<InboxPaymentData>? _inboxPayment;
  List<InboxPaymentData>? get inboxPayment => _inboxPayment;

  int? _inboxPaymentCount;
  int? get inboxPaymentCount => _inboxPaymentCount;

  InboxModel? _inboxPanicModel;
  InboxModel? get inboxPanicModel => _inboxPanicModel;

  List<InboxData>? _inboxPanic;
  List<InboxData>? get inboxPanic => _inboxPanic;

  int? _inboxPanicCount;
  int? get inboxPanicCount => _inboxPanicCount;

  InboxInfoStatus _inboxInfoStatus = InboxInfoStatus.idle;
  InboxInfoStatus get inboxInfoStatus => _inboxInfoStatus;

  InboxPaymentStatus _inboxPaymentStatus = InboxPaymentStatus.idle;
  InboxPaymentStatus get inboxPaymentStatus => _inboxPaymentStatus;

  InboxPanicStatus _inboxPanicStatus = InboxPanicStatus.idle;
  InboxPanicStatus get inboxPanicStatus => _inboxPanicStatus;

  InboxCountStatus _inboxCountStatus = InboxCountStatus.idle;
  InboxCountStatus get inboxCountStatus => _inboxCountStatus;

  InboxDetailStatus _inboxDetailStatus = InboxDetailStatus.idle;
  InboxDetailStatus get inboxDetailStatus => _inboxDetailStatus;

  FetchInboxInfoStatus _fetchInboxInfoStatus = FetchInboxInfoStatus.idle;
  FetchInboxInfoStatus get fetchInboxInfoStatus => _fetchInboxInfoStatus;

  FetchInboxPaymentStatus _fetchInboxPaymentStatus =
      FetchInboxPaymentStatus.idle;
  FetchInboxPaymentStatus get fetchInboxPaymentStatus =>
      _fetchInboxPaymentStatus;

  FetchInboxPanicStatus _fetchInboxPanicStatus = FetchInboxPanicStatus.idle;
  FetchInboxPanicStatus get fetchInboxPanicStatus => _fetchInboxPanicStatus;

  void setStateInboxInfoStatus(InboxInfoStatus inboxInfoStatus) {
    _inboxInfoStatus = inboxInfoStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateInboxPanicStatus(InboxPanicStatus inboxPanicStatus) {
    _inboxPanicStatus = inboxPanicStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateInboxPaymentStatus(InboxPaymentStatus inboxPaymentStatus) {
    _inboxPaymentStatus = inboxPaymentStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateInboxCountStatus(InboxCountStatus inboxCountStatus) {
    _inboxCountStatus = inboxCountStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateInboxDetailStatus(InboxDetailStatus inboxDetailStatus) {
    _inboxDetailStatus = inboxDetailStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFetchInboxInfoStatus(FetchInboxInfoStatus fetchInboxInfoStatus) {
    _fetchInboxInfoStatus = fetchInboxInfoStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFetchInboxPaymentStatus(
      FetchInboxPaymentStatus fetchInboxPaymentStatus) {
    _fetchInboxPaymentStatus = fetchInboxPaymentStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFetchInboxPanicStatus(
      FetchInboxPanicStatus fetchInboxPanicStatus) {
    _fetchInboxPanicStatus = fetchInboxPanicStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void loadMoreInboxInfo() {
    isLoadInboxInfo = true;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void loadMoreInboxPayment() {
    isLoadInboxPayment = true;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void loadMoreInboxPanic() {
    isLoadInboxPanic = true;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void toggleMoreInboxInfo(BuildContext context,
      {required int pageCount}) async {
    await fetchMoreInboxInfo(context, page: pageCount);
    isLoadInboxInfo = false;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void toggleMoreInboxPayment(BuildContext context,
      {required int pageCount}) async {
    await fetchMoreInboxPayment(context, page: pageCount);
    isLoadInboxPayment = false;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void toggleMoreInboxPanic(BuildContext context,
      {required int pageCount}) async {
    await fetchMoreInboxPanic(context, page: pageCount);
    isLoadInboxPanic = false;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void resetInboxInfoPageCount() {
    isLoadInboxInfo = false;
    inboxInfoPageCount = 1;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void resetInboxPaymentPageCount() {
    isLoadInboxPayment = false;
    inboxPaymentPageCount = 1;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void resetInboxPanicPageCount() {
    isLoadInboxPanic = false;
    inboxPanicPageCount = 1;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getReadCount(BuildContext context) async {
    setStateInboxCountStatus(InboxCountStatus.loading);
    try {
      InboxCountModel? icm =
          await ir.getInboxCount(userId: SharedPrefs.getUserId());
      InboxCountPaymentModel? icpm =
          await ir.getInboxCountPayment(userId: SharedPrefs.getUserId());
      int? icmCount = icm?.data?.total;
      int? icpmCount = icpm?.data?.total;
      if (icmCount == 0 && icpmCount == 0 ||
          icpmCount == null && icmCount == null) {
        setStateInboxCountStatus(InboxCountStatus.empty);
      } else {
        _readCount = icmCount! + icpmCount!;
        setStateInboxCountStatus(InboxCountStatus.loaded);
      }
      resetInboxInfoPageCount();
      resetInboxPanicPageCount();
      resetInboxPaymentPageCount();
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IR01');
      setStateInboxCountStatus(InboxCountStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IP01');
      setStateInboxCountStatus(InboxCountStatus.error);
    }
  }

  Future<void> getInboxInfo(BuildContext context, {int? page}) async {
    setStateInboxInfoStatus(InboxInfoStatus.loading);
    try {
      _inboxInfo = [];
      _inboxModel = await ir.getInbox(
        userId: SharedPrefs.getUserId(),
        type: 'default',
        page: page,
      );
      _inboxInfo!.addAll(inboxModel!.data!);
      _inboxInfoCount = inboxModel!.pageDetail!.badges!;
      setStateInboxInfoStatus(InboxInfoStatus.loaded);
      if (inboxInfo!.isEmpty) {
        setStateInboxInfoStatus(InboxInfoStatus.empty);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IR02');
      setStateInboxInfoStatus(InboxInfoStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IP02');
      setStateInboxInfoStatus(InboxInfoStatus.error);
    }
  }

  Future<void> fetchMoreInboxInfo(BuildContext context, {int? page}) async {
    setStateFetchInboxInfoStatus(FetchInboxInfoStatus.loading);
    try {
      _inboxModel = await ir.getInbox(
        userId: SharedPrefs.getUserId(),
        type: 'default',
        page: page,
      );
      _inboxInfo!.addAll(inboxModel!.data!);
      _inboxInfoCount = inboxModel!.pageDetail!.badges!;
      setStateFetchInboxInfoStatus(FetchInboxInfoStatus.loaded);
      if (inboxInfo!.isEmpty) {
        setStateFetchInboxInfoStatus(FetchInboxInfoStatus.empty);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IR03');
      setStateFetchInboxInfoStatus(FetchInboxInfoStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IP03');
      setStateFetchInboxInfoStatus(FetchInboxInfoStatus.error);
    }
  }

  Future<void> getInboxPanic(BuildContext context) async {
    setStateInboxPanicStatus(InboxPanicStatus.loading);
    try {
      _inboxPanic = [];
      _inboxModel =
          await ir.getInbox(userId: SharedPrefs.getUserId(), type: 'sos');
      _inboxPanic!.addAll(inboxModel!.data!);
      _inboxPanicCount = inboxModel!.pageDetail!.badges!;
      setStateInboxPanicStatus(InboxPanicStatus.loaded);
      if (inboxPanic!.isEmpty) {
        setStateInboxPanicStatus(InboxPanicStatus.empty);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IR04');
      setStateInboxPanicStatus(InboxPanicStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IP04');
      setStateInboxPanicStatus(InboxPanicStatus.error);
    }
  }

  Future<void> fetchMoreInboxPanic(BuildContext context, {int? page}) async {
    setStateFetchInboxPanicStatus(FetchInboxPanicStatus.loading);
    try {
      _inboxModel = await ir.getInbox(
        userId: SharedPrefs.getUserId(),
        type: 'sos',
        page: page,
      );
      _inboxPanic!.addAll(inboxModel!.data!);
      _inboxPanicCount = inboxModel!.pageDetail!.badges!;
      setStateFetchInboxPanicStatus(FetchInboxPanicStatus.loaded);
      if (inboxPanic!.isEmpty) {
        setStateFetchInboxPanicStatus(FetchInboxPanicStatus.empty);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IR05');
      setStateFetchInboxPanicStatus(FetchInboxPanicStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IP05');
      setStateFetchInboxPanicStatus(FetchInboxPanicStatus.error);
    }
  }

  Future<void> getInboxPayment(BuildContext context) async {
    setStateInboxPaymentStatus(InboxPaymentStatus.loading);
    try {
      _inboxPayment = [];
      _inboxPaymentModel = await ir.getInboxPayment(
        userId: SharedPrefs.getUserId(),
      );
      InboxCountPaymentModel? count =
          await ir.getInboxCountPayment(userId: SharedPrefs.getUserId());
      Body body = inboxPaymentModel!.body!;
      if (body.data!.isEmpty) {
        setStateInboxPaymentStatus(InboxPaymentStatus.empty);
      } else {
        _inboxPayment!.addAll(body.data!);
        _inboxPaymentCount = count!.data!.total;
        setStateInboxPaymentStatus(InboxPaymentStatus.loaded);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IR06');
      setStateInboxPaymentStatus(InboxPaymentStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IP06');
      setStateInboxPaymentStatus(InboxPaymentStatus.error);
    }
  }

  Future<void> fetchMoreInboxPayment(BuildContext context, {int? page}) async {
    setStateFetchInboxPaymentStatus(FetchInboxPaymentStatus.loading);
    try {
      _inboxPaymentModel = await ir.getInboxPayment(
        userId: SharedPrefs.getUserId(),
        page: page,
      );
      InboxCountPaymentModel? count =
          await ir.getInboxCountPayment(userId: SharedPrefs.getUserId());
      Body body = inboxPaymentModel!.body!;
      _inboxPayment!.addAll(body.data!);
      _inboxPaymentCount = count!.data!.total;
      setStateInboxPaymentStatus(InboxPaymentStatus.loaded);
      if (inboxPayment!.isEmpty) {
        setStateInboxPaymentStatus(InboxPaymentStatus.empty);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IR07');
      setStateFetchInboxPaymentStatus(FetchInboxPaymentStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IP07');
      setStateFetchInboxPaymentStatus(FetchInboxPaymentStatus.error);
    }
  }

  Future<void> getInboxDetailAndUpdateInboxPayment(
    BuildContext context, {
    required int inboxId,
    required InboxPaymentData inboxSelected,
  }) async {
    setStateInboxDetailStatus(InboxDetailStatus.loading);
    try {
      _inboxDetail = null;
      _inboxPaymentDetail = inboxSelected;
      await ir.updateInboxPayment(inboxId: inboxId);
      NS.push(context, const DetailInboxScreen());
      setStateInboxDetailStatus(InboxDetailStatus.loaded);
      Future.delayed(
        const Duration(
          seconds: 1,
        ),
        () async {
          Future.wait([
            getInboxInfo(context),
            getInboxPayment(context),
            getInboxPanic(context),
            getReadCount(context),
          ]);
        },
      );
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IR08');
      setStateInboxDetailStatus(InboxDetailStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IP08');
      setStateInboxDetailStatus(InboxDetailStatus.error);
    }
  }

  Future<void> getInboxDetailAndUpdateInbox(
    BuildContext context, {
    required String inboxId,
    required InboxData inboxSelected,
  }) async {
    setStateInboxDetailStatus(InboxDetailStatus.loading);
    try {
      _inboxPaymentDetail = null;
      _inboxDetail = inboxSelected;
      await ir.updateInbox(inboxId: inboxId, userId: SharedPrefs.getUserId());
      NS.push(context, const DetailInboxScreen());
      setStateInboxDetailStatus(InboxDetailStatus.loaded);
      Future.delayed(
        const Duration(
          seconds: 1,
        ),
        () async {
          Future.wait([
            getInboxInfo(context),
            getInboxPayment(context),
            getInboxPanic(context),
            getReadCount(context),
          ]);
        },
      );
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IR08');
      setStateInboxDetailStatus(InboxDetailStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'IP08');
      setStateInboxDetailStatus(InboxDetailStatus.error);
    }
  }
}