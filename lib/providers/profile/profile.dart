import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:hp3ki/data/models/enterpreneurs_additional_data/business.dart';
import 'package:hp3ki/data/models/enterpreneurs_additional_data/classifications.dart';
import 'package:hp3ki/data/models/user/user.dart';
import 'package:hp3ki/data/repository/profile/profile.dart';
import 'package:hp3ki/providers/auth/auth.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/views/basewidgets/dialog/custom/custom.dart';
import 'package:hp3ki/views/screens/auth/form_pelatihan.dart';
import 'package:hp3ki/views/screens/auth/form_pendidik.dart';
import 'package:hp3ki/views/screens/auth/form_pimpinan.dart';
import 'package:hp3ki/views/screens/auth/form_wirausaha.dart';
import 'package:hp3ki/views/screens/home/home.dart';

enum FulfillPersonalDataStatus { loading, loaded, error, idle }

enum FulfillJobDataStatus { loading, loaded, error, idle }

enum ProfileStatus { loading, loaded, error, empty }

enum ProfilePictureStatus { loading, loaded, error, empty }

enum UpdateProfileStatus { loading, loaded, error, empty }

enum BusinessStatus { loading, loaded, error, empty }

enum ClassificationStatus { loading, loaded, error, empty }

class ProfileProvider with ChangeNotifier {
  final AuthProvider ap;
  final ProfileRepo pr;

  ProfileProvider({
    required this.ap,
    required this.pr,
  });

  int isActive = 0;

  UserData? _user;
  UserData? get user => _user;

  late String formJobType;

  List<BusinessData>? _businessList;
  List<BusinessData>? get businessList => _businessList;

  List<ClassificationData>? _classificationList;
  List<ClassificationData>? get classificationList => _classificationList;

  FulfillPersonalDataStatus _fulfillPersonalDataStatus =
      FulfillPersonalDataStatus.idle;
  FulfillPersonalDataStatus get fulfillPersonalDataStatus =>
      _fulfillPersonalDataStatus;

  FulfillJobDataStatus _fulfillJobDataStatus = FulfillJobDataStatus.idle;
  FulfillJobDataStatus get fulfillJobDataStatus => _fulfillJobDataStatus;

  ProfileStatus _profileStatus = ProfileStatus.empty;
  ProfileStatus get profileStatus => _profileStatus;

  ProfilePictureStatus _profilePictureStatus = ProfilePictureStatus.empty;
  ProfilePictureStatus get profilePictureStatus => _profilePictureStatus;

  UpdateProfileStatus _updateProfileStatus = UpdateProfileStatus.empty;
  UpdateProfileStatus get updateProfileStatus => _updateProfileStatus;

  BusinessStatus _businessStatus = BusinessStatus.empty;
  BusinessStatus get businessStatus => _businessStatus;

  ClassificationStatus _classificationStatus = ClassificationStatus.empty;
  ClassificationStatus get classificationStatus => _classificationStatus;

  void setStateFulfillJobDataStatus(FulfillJobDataStatus fulfillJobDataStatus) {
    _fulfillJobDataStatus = fulfillJobDataStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFulfillPersonalDataStatus(
      FulfillPersonalDataStatus fulfillPersonalDataStatus) {
    _fulfillPersonalDataStatus = fulfillPersonalDataStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateProfileStatus(ProfileStatus profileStatus) {
    _profileStatus = profileStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateProfilePictureStatus(ProfilePictureStatus profilePictureStatus) {
    _profilePictureStatus = profilePictureStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateUpdateProfileStatus(UpdateProfileStatus updateProfileStatus) {
    _updateProfileStatus = updateProfileStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateBusinessStatus(BusinessStatus businessStatus) {
    _businessStatus = businessStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateClassificationStatus(ClassificationStatus classificationStatus) {
    _classificationStatus = classificationStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void showFullFillDataDialog(context) {
    CustomDialog.showFulfillData(context);
  }

  Future<int> remote() async {
    var remote = await pr.remote();
    isActive = remote;
    Future.delayed(Duration.zero, () => notifyListeners());
    return isActive;
  }

  Future<void> getProfile(BuildContext context) async {
    setStateProfileStatus(ProfileStatus.loading);
    try {
      UserModel? um = await pr.getProfile(SharedPrefs.getUserId());
      UserData user = um!.data!;
      if (user.id!.isNotEmpty) {
        _user = user;
        SharedPrefs.writeUserData(user);
        setStateProfileStatus(ProfileStatus.loaded);
      } else {
        setStateProfileStatus(ProfileStatus.empty);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showForceLogoutError(context, error: e.toString());
      setStateProfileStatus(ProfileStatus.error);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PP01');
      setStateProfileStatus(ProfileStatus.error);
    }
  }

  Future<void> getBusinessList(BuildContext context) async {
    setStateBusinessStatus(BusinessStatus.loading);
    try {
      _businessList = [];
      BusinessModel? um = await pr.getBusinessList();
      List<BusinessData> business = um!.data!;
      if (business.isNotEmpty) {
        _businessList!.addAll(business);
        setStateBusinessStatus(BusinessStatus.loaded);
      } else {
        setStateBusinessStatus(BusinessStatus.empty);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PR02');
      setStateBusinessStatus(BusinessStatus.error);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PP02');
      setStateBusinessStatus(BusinessStatus.error);
    }
  }

  Future<void> getClassificationList(BuildContext context) async {
    setStateClassificationStatus(ClassificationStatus.loading);
    try {
      _classificationList = [];
      ClassificationModel? um = await pr.getClassificationList();
      List<ClassificationData> classification = um!.data!;
      if (classification.isNotEmpty) {
        _classificationList!.addAll(classification);
        setStateClassificationStatus(ClassificationStatus.loaded);
      } else {
        setStateClassificationStatus(ClassificationStatus.empty);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PR03');
      setStateClassificationStatus(ClassificationStatus.error);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PP03');
      setStateClassificationStatus(ClassificationStatus.error);
    }
  }

  Future<void> setPersonalData(BuildContext context) async {
    setStateFulfillPersonalDataStatus(FulfillPersonalDataStatus.loading);
    try {
      String jobTypeId = SharedPrefs.getRegJob() ?? user!.jobId!;
      switch (jobTypeId) {
        case "66a56a67-06e5-4310-850b-4bc6f364f50b":
          formJobType = "leaders";
          NS.push(context, const FormPimpinanScreen());
          break;
        case "4ed49552-5600-47e3-9630-a9c322e954f4":
          formJobType = "educators";
          NS.push(context, const FormPendidikScreen());
          break;
        case "ff3c0873-1fc8-45ef-a380-aaf38190be14":
          formJobType = "trainnings";
          NS.push(context, const FormPelatihanScreen());
          break;
        case "15fcd407-3a94-4504-9cbf-eda1d742e987":
          formJobType = "enterpreneurs";
          NS.push(context, const FormWirausahaScreen());
          break;
        default:
          CustomDialog.showError(context,
              error: 'Form untuk profesi anda tidak ditemukan');
      }

      Future.delayed(
        const Duration(seconds: 1),
        () async {
          setStateFulfillPersonalDataStatus(FulfillPersonalDataStatus.loaded);
        },
      );
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PR04');
      setStateFulfillPersonalDataStatus(FulfillPersonalDataStatus.error);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PP04');
      setStateFulfillPersonalDataStatus(FulfillPersonalDataStatus.error);
    }
  }

  Future<void> fulfillJobData(BuildContext context) async {
    setStateFulfillJobDataStatus(FulfillJobDataStatus.loading);
    Object data = formJobType == "enterpreneurs"
        ? SharedPrefs.getEnterpreneursData()
        : SharedPrefs.getOtherJobData();
    Object personalData = SharedPrefs.getPersonalDataObject();
    try {
      await Future.wait([
        pr.fulfillJobData(data, formJobType),
        pr.updateProfile(data: personalData),
      ]);
      SharedPrefs.deleteIfUserRegistered();
      getProfile(context);
      SharedPrefs.deleteJobDataForm();
      SharedPrefs.deletePersonalDataForm();
      NS.pushReplacement(context, const DashboardScreen());
      Future.delayed(
        const Duration(seconds: 1),
        () async {
          setStateFulfillJobDataStatus(FulfillJobDataStatus.loaded);
        },
      );
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PR05');
      setStateFulfillJobDataStatus(FulfillJobDataStatus.error);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'P505');
      setStateFulfillJobDataStatus(FulfillJobDataStatus.error);
    }
  }

  Future<void> updateProfilePicture(BuildContext context,
      {required String pfpPath}) async {
    setStateProfilePictureStatus(ProfilePictureStatus.loading);
    try {
      await pr.updateProfilePicture(
        pfpPath: pfpPath,
        userId: SharedPrefs.getUserId(),
      );
      getProfile(context);
      setStateProfilePictureStatus(ProfilePictureStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showError(context, error: e.toString());
      setStateProfilePictureStatus(ProfilePictureStatus.error);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      CustomDialog.showError(context, error: e.toString());
      setStateProfilePictureStatus(ProfilePictureStatus.error);
    }
  }

  Future<void> updateProfileNameOrAddress(BuildContext context,
      {required String? name, required String? address}) async {
    setStateUpdateProfileStatus(UpdateProfileStatus.loading);
    try {
      await pr.updateProfileNameOrAddress(
        name: name ?? user!.fullname!,
        address: address ?? user!.addressKtp!,
        userId: SharedPrefs.getUserId(),
      );
      setStateUpdateProfileStatus(UpdateProfileStatus.loaded);
      NS.pop();
      getProfile(context);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showError(context, error: e.toString());
      setStateUpdateProfileStatus(UpdateProfileStatus.error);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'PP07');
      setStateUpdateProfileStatus(UpdateProfileStatus.error);
    }
  }

  AwesomeDialog showNonPlatinumLimit(context) {
    return CustomDialog.showWarningMemberNonPlatinum(context,
        warning:
            "Fitur ini dibatasi karena anda belum menjadi member platinum, silahkan upgrade member terlebih dahulu.");
  }
}
