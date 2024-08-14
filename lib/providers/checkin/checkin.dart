import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:hp3ki/providers/location/location.dart';
import 'package:hp3ki/data/repository/checkin/checkin.dart';
import 'package:hp3ki/data/models/checkin/checkin.dart';
import 'package:hp3ki/utils/color_resources.dart';

enum CheckInStatus { idle, refetch, loading, loaded, error, empty }

enum CheckInStatusLoadMore { idle, loading, loaded, error, empty }

enum CheckInStatusCreate { idle, loading, loaded, error }

enum CheckInStatusJoin { idle, loading, loaded, error }

enum CheckInStatusDelete { idle, loading, loaded, error }

enum CheckInStatusDetail { idle, loading, loaded, error, empty }

enum CheckInGalleryStatus { idle, loading, loaded, error, empty }

class CheckInProvider extends ChangeNotifier {
  final CheckInRepo cr;
  final LocationProvider lp;

  CheckInProvider({
    required this.cr,
    required this.lp,
  });

  String checkInDataSelected = "";

  CheckInStatus _checkInStatus = CheckInStatus.loading;
  CheckInStatus get checkInStatus => _checkInStatus;

  CheckInStatusLoadMore _checkInStatusLoadMore = CheckInStatusLoadMore.loading;
  CheckInStatusLoadMore get checkinStatusLoadMore => _checkInStatusLoadMore;

  CheckInStatusCreate _checkInStatusCreate = CheckInStatusCreate.idle;
  CheckInStatusCreate get checkInStatusCreate => _checkInStatusCreate;

  CheckInStatusJoin _checkInStatusJoin = CheckInStatusJoin.idle;
  CheckInStatusJoin get checkInStatusJoin => _checkInStatusJoin;

  CheckInStatusDelete _checkInStatusDelete = CheckInStatusDelete.idle;
  CheckInStatusDelete get checkInStatusDelete => _checkInStatusDelete;

  CheckInStatusDetail _checkInStatusDetail = CheckInStatusDetail.idle;
  CheckInStatusDetail get checkInStatusDetail => _checkInStatusDetail;

  CheckInGalleryStatus _checkInGalleryStatus = CheckInGalleryStatus.loading;
  CheckInGalleryStatus get checkInGalleryStatus => _checkInGalleryStatus;

  List<CheckInData> _checkInData = [];
  List<CheckInData> get checkInData => [..._checkInData];

  int _checkInDetailTotalUser = 0;
  int get checkInDetailTotalUser => _checkInDetailTotalUser;

  List<User> _checkInDetail = [];
  List<User> get checkInDetail => [..._checkInDetail];

  void setStateCheckInStatus(CheckInStatus checkInStatus) {
    _checkInStatus = checkInStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCheckInStatusLoadMore(
      CheckInStatusLoadMore checkInStatusLoadMore) {
    _checkInStatusLoadMore = checkInStatusLoadMore;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCheckInStatusCreate(CheckInStatusCreate checkInStatusCreate) {
    _checkInStatusCreate = checkInStatusCreate;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCheckInStatusJoin(CheckInStatusJoin checkInStatusJoin) {
    _checkInStatusJoin = checkInStatusJoin;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCheckInStatusDelete(CheckInStatusDelete checkInStatusDelete) {
    _checkInStatusDelete = checkInStatusDelete;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCheckInStatusDetail(CheckInStatusDetail checkInStatusDetail) {
    _checkInStatusDetail = checkInStatusDetail;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCheckInGalleryStatus(CheckInGalleryStatus checkInGalleryStatus) {
    _checkInGalleryStatus = checkInGalleryStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getCheckIn(BuildContext context) async {
    setStateCheckInStatus(CheckInStatus.loading);
    try {
      _checkInData = [];
      CheckInModel cim = await cr.getCheckIn(SharedPrefs.getUserId());
      List<CheckInData>? data = cim.data;
      if (data!.isEmpty == true) {
        setStateCheckInStatus(CheckInStatus.empty);
      } else {
        _checkInData.addAll(data);
        setStateCheckInStatus(CheckInStatus.loaded);
      }
      notifyListeners();
    } on CustomException catch (e) {
      //CR01
      debugPrint(e.toString());
      setStateCheckInStatus(CheckInStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateCheckInStatus(CheckInStatus.error);
    }
  }

  Future<void> getCheckInDetail(BuildContext context, int i) async {
    setStateCheckInStatusDetail(CheckInStatusDetail.loading);
    try {
      _checkInDetail = [];
      _checkInDetailTotalUser = 0;
      List<User>? data = checkInData[i].joined?.user;
      _checkInDetailTotalUser = data!.length;
      if (data.isEmpty) {
        setStateCheckInStatusDetail(CheckInStatusDetail.empty);
      } else {
        debugPrint('loaded');
        _checkInDetail = data;
        setStateCheckInStatusDetail(CheckInStatusDetail.loaded);
      }
    } on CustomException catch (e) {
      //CR02
      debugPrint(e.toString());
      setStateCheckInStatusDetail(CheckInStatusDetail.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateCheckInStatusDetail(CheckInStatusDetail.error);
    }
  }

  Future<void> checkInSavePostId(
      BuildContext context, int checkInId, String postId) async {
    try {
      await cr.checkInSavePostId(context, checkInId, postId);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> createCheckIn(
    BuildContext context,
    String caption,
    String date,
    String start,
    String end,
    String desc,
  ) async {
    setStateCheckInStatusCreate(CheckInStatusCreate.loading);
    try {
      await cr.createCheckIn(
        caption,
        desc,
        date,
        start,
        end,
        lp.getCurrentNameAddressCheckIn,
        lp.getCurrentLat.toString(),
        lp.getCurrentLng.toString(),
        SharedPrefs.getUserId(),
      );
      NS.pop(context);
      getCheckIn(context);
      setStateCheckInStatusCreate(CheckInStatusCreate.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      setStateCheckInStatusCreate(CheckInStatusCreate.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      setStateCheckInStatusCreate(CheckInStatusCreate.error);
    }
  }

  Future<void> joinCheckIn(BuildContext context, String checkInId) async {
    checkInDataSelected = checkInId;
    setStateCheckInStatusJoin(CheckInStatusJoin.loading);
    try {
      await cr.joinCheckIn(checkInId, SharedPrefs.getUserId());
      ShowSnackbar.snackbar(context, getTranslated('JOINED', context), '', ColorResources.green);
      getCheckIn(context);
      setStateCheckInStatusJoin(CheckInStatusJoin.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      setStateCheckInStatusJoin(CheckInStatusJoin.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      setStateCheckInStatusJoin(CheckInStatusJoin.error);
    }
  }

  Future<void> deleteCheckIn(BuildContext context, String checkInId) async {
    setStateCheckInStatusDelete(CheckInStatusDelete.loading);
    try {
      await cr.deleteCheckIn(context, checkInId);
      getCheckIn(context);
      setStateCheckInStatusDelete(CheckInStatusDelete.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      setStateCheckInStatusDelete(CheckInStatusDelete.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      setStateCheckInStatusDelete(CheckInStatusDelete.error);
    }
  }
}
