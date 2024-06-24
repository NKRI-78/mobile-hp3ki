import 'package:flutter/material.dart';
import 'package:hp3ki/data/models/auth/auth.dart';
import 'package:hp3ki/data/models/job/job.dart';
import 'package:hp3ki/data/models/organization/organization.dart';
import 'package:hp3ki/services/database.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/views/basewidgets/dialog/custom/custom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hp3ki/views/screens/auth/change_password.dart';
import 'package:hp3ki/views/screens/auth/otp.dart';
import 'package:hp3ki/views/screens/auth/sign_up.dart';
import 'package:hp3ki/views/screens/home/home.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/data/repository/auth/auth.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:hp3ki/views/screens/auth/sign_in.dart';

enum RegisterStatus { loading, loaded, error, idle }

enum FulfillStatus { loading, loaded, error, idle }

enum ForgetPasswordStatus { loading, loaded, error, idle }

enum ChangePasswordStatus { loading, loaded, error, idle }

enum LoginStatus { loading, loaded, error, idle }

enum LoginGoogleStatus { loading, loaded, error, idle }

enum LoginFacebookStatus { loading, loaded, error, idle }

enum JobStatus { loading, loaded, error, empty }

enum OrganizationStatus { loading, loaded, error, empty }

enum ResendOtpStatus { idle, loading, loaded, error, empty }

enum VerifyOtpStatus { idle, loading, loaded, error, empty }

enum ApplyChangeEmailOtpStatus { idle, loading, loaded, error, empty }

class AuthProvider with ChangeNotifier {
  final AuthRepo ar;

  AuthProvider({required this.ar});

  bool changeEmail = true;
  String? otp;
  String whenCompleteCountdown = "start";
  String changeEmailName = "";
  String emailCustom = "";

  TextEditingController otpTextController = TextEditingController();

  GoogleSignIn googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _userFromGoogle;
  GoogleSignInAccount? get userFromGoogle => _userFromGoogle;

  List<Map<String, dynamic>> menus = [];

  List<JobData>? _jobs = [];
  List<JobData>? get jobs => _jobs;

  List<OrganizationData>? _organizations = [];
  List<OrganizationData>? get organizations => _organizations;

  LoginStatus _loginStatus = LoginStatus.idle;
  LoginStatus get loginStatus => _loginStatus;

  LoginGoogleStatus _loginGoogleStatus = LoginGoogleStatus.idle;
  LoginGoogleStatus get loginGoogleStatus => _loginGoogleStatus;

  LoginFacebookStatus _loginFacebookStatus = LoginFacebookStatus.idle;
  LoginFacebookStatus get loginFacebookStatus => _loginFacebookStatus;

  VerifyOtpStatus _verifyOtpStatus = VerifyOtpStatus.idle;
  VerifyOtpStatus get verifyOtpStatus => _verifyOtpStatus;

  ApplyChangeEmailOtpStatus _applyChangeEmailOtpStatus =
      ApplyChangeEmailOtpStatus.idle;
  ApplyChangeEmailOtpStatus get applyChangeEmailOtpStatus =>
      _applyChangeEmailOtpStatus;

  RegisterStatus _registerStatus = RegisterStatus.idle;
  RegisterStatus get registerStatus => _registerStatus;

  FulfillStatus _fulfillStatus = FulfillStatus.idle;
  FulfillStatus get fulfillStatus => _fulfillStatus;

  ResendOtpStatus _resendOtpStatus = ResendOtpStatus.idle;
  ResendOtpStatus get resendOtpStatus => _resendOtpStatus;

  ForgetPasswordStatus _forgetPasswordStatus = ForgetPasswordStatus.idle;
  ForgetPasswordStatus get forgetPasswordStatus => _forgetPasswordStatus;

  ChangePasswordStatus _changePasswordStatus = ChangePasswordStatus.idle;
  ChangePasswordStatus get changePasswordStatus => _changePasswordStatus;

  JobStatus _jobStatus = JobStatus.empty;
  JobStatus get jobStatus => _jobStatus;

  OrganizationStatus _organizationStatus = OrganizationStatus.empty;
  OrganizationStatus get organizationStatus => _organizationStatus;

  void setStateLoginStatus(LoginStatus loginStatus) {
    _loginStatus = loginStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateLoginGoogleStatus(LoginGoogleStatus loginGoogleStatus) {
    _loginGoogleStatus = loginGoogleStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateLoginFacebookStatus(LoginFacebookStatus loginFacebookStatus) {
    _loginFacebookStatus = loginFacebookStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFulfillStatus(FulfillStatus fulfillStatus) {
    _fulfillStatus = fulfillStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateRegisterStatus(RegisterStatus registerStatus) {
    _registerStatus = registerStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setVerifyOtpStatus(VerifyOtpStatus verifyOtpStatus) {
    _verifyOtpStatus = verifyOtpStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setResendOtpStatus(ResendOtpStatus resendOtpStatus) {
    _resendOtpStatus = resendOtpStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setApplyChangeEmailOtpStatus(
      ApplyChangeEmailOtpStatus applyChangeEmailOtpStatus) {
    _applyChangeEmailOtpStatus = applyChangeEmailOtpStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateForgetPasswordStatus(ForgetPasswordStatus forgotPasswordStatus) {
    _forgetPasswordStatus = forgotPasswordStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateChangePasswordStatus(ChangePasswordStatus changePasswordStatus) {
    _changePasswordStatus = changePasswordStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateJobStatus(JobStatus jobStatus) {
    _jobStatus = jobStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateOrganizationStatus(OrganizationStatus organizationStatus) {
    _organizationStatus = organizationStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> login(
      BuildContext context, String emailOrPhone, String password) async {
    setStateLoginStatus(LoginStatus.loading);
    try {
      AuthModel auth = await ar.login(
        emailOrPhone,
        password,
      );
      AuthUser user = auth.data!.user!;
      SharedPrefs.writeAuthData(auth.data!);
      SharedPrefs.writeLoginTemp(user);
      if (user.emailActivated == true) {
        SharedPrefs.deleteIfUserRegistered();
        SharedPrefs.writeAuthToken();
        NS.pushReplacement(context, const DashboardScreen());
      } else {
        NS.pushReplacement(context, const OtpScreen());
      }
      Future.delayed(
        const Duration(seconds: 1),
        () {
          setStateLoginStatus(LoginStatus.loaded);
        },
      );
    } on CustomException catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      setStateLoginStatus(LoginStatus.error);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'AP01');
      setStateLoginStatus(LoginStatus.error);
    }
  }

  Future<void> register(BuildContext context) async {
    setStateRegisterStatus(RegisterStatus.loading);
    Object data = SharedPrefs.getRegisterObject();

    try {
      AuthModel auth = await ar.register(data);
      SharedPrefs.writeEmailOTP(auth.data!.user!);
      SharedPrefs.writeAuthData(auth.data!);
      NS.pushReplacement(context, const OtpScreen());
      Future.delayed(
        const Duration(seconds: 1),
        () async {
          setStateRegisterStatus(RegisterStatus.loaded);
        },
      );
    } on CustomException catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      setStateRegisterStatus(RegisterStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'AP02');
      setStateRegisterStatus(RegisterStatus.error);
    }
  }

  Future<void> changePassword(
      BuildContext context, String oldPassword, String newPassword) async {
    setStateChangePasswordStatus(ChangePasswordStatus.loading);
    try {
      await ar.changePassword(
        SharedPrefs.getUserEmail(),
        oldPassword,
        newPassword,
      );
      ShowSnackbar.snackbar(
          context,
          getTranslated("UPDATE_PASSWORD_SUCCESS", context),
          "",
          ColorResources.success);
      NS.pop(context);
      setStateChangePasswordStatus(ChangePasswordStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showError(context, error: e.toString());
      setStateChangePasswordStatus(ChangePasswordStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'AP03');
      setStateChangePasswordStatus(ChangePasswordStatus.error);
    }
  }

  Future<void> setNewPassword(
      BuildContext context, String oldPassword, String newPassword) async {
    setStateChangePasswordStatus(ChangePasswordStatus.loading);
    try {
      await ar.setNewPassword(
          SharedPrefs.getForgetEmail(), oldPassword, newPassword);
      ShowSnackbar.snackbar(
          context,
          getTranslated("UPDATE_PASSWORD_SUCCESS", context),
          "",
          ColorResources.success);
      NS.pushReplacement(context, const SignInScreen());
      setStateChangePasswordStatus(ChangePasswordStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showError(context, error: e.toString());
      setStateChangePasswordStatus(ChangePasswordStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'AP04');
      setStateChangePasswordStatus(ChangePasswordStatus.error);
    }
  }

  Future<void> forgetPassword(BuildContext context, String email) async {
    setStateForgetPasswordStatus(ForgetPasswordStatus.loading);
    try {
      await ar.forgetPassword(email);
      ShowSnackbar.snackbar(
          context,
          'Silahkan cek email Anda untuk mendapatkan kode verifikasi',
          "",
          ColorResources.success,
          const Duration(seconds: 2));
      SharedPrefs.writeForgetEmail(email);
      NS.pushReplacement(
          context, const ChangePasswordScreen(isFromForget: true));
      setStateForgetPasswordStatus(ForgetPasswordStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showError(context, error: e.toString());
      setStateForgetPasswordStatus(ForgetPasswordStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'AP05');
      setStateForgetPasswordStatus(ForgetPasswordStatus.error);
      ShowSnackbar.snackbar(
          context,
          getTranslated("THERE_WAS_PROBLEM", context),
          "",
          ColorResources.error);
    }
  }

  Future<void> resendOtpCall(BuildContext context) async {
    try {
      whenCompleteCountdown = "start";
      Future.delayed(Duration.zero, () => notifyListeners());
      await resendOtp(context, changeEmailName);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> applyChangeEmailOtp(BuildContext context) async {
    changeEmailName = SharedPrefs.getEmailOTP();
    bool emailValid = RegExp(r"[a-zA-Z0-9_]+@[a-zA-Z]+\.(com|net|org)$")
        .hasMatch(changeEmailName);
    bool newEmailValid = RegExp(r"[a-zA-Z0-9_]+@[a-zA-Z]+\.(com|net|org)$")
        .hasMatch(emailCustom);
    if (!emailValid || !newEmailValid) {
      CustomDialog.showError(context,
          error: getTranslated("INVALID_FORMAT_EMAIL", context));
      return;
    } else {
      if (emailCustom.trim().isNotEmpty) {
        changeEmailName = emailCustom;
      }
      Future.delayed(Duration.zero, () => notifyListeners());
    }
    try {
      setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus.loading);
      await ar.applyChangeEmailOtp(
        changeEmailName,
        SharedPrefs.getEmailOTP(),
      );
      changeEmail = true;
      SharedPrefs.writeChangeEmailData(changeEmailName);
      ShowSnackbar.snackbar(
          context,
          "Silahkan cek kembali email anda, $changeEmailName",
          "",
          ColorResources.success);
      setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus.loaded);
    } on CustomException catch (e) {
      changeEmailName = SharedPrefs.getEmailOTP();
      changeEmail = false;
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'AP06');
      setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus.error);
    }
  }

  void cleanText() {
    otpTextController.text = "";
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void cancelCustomEmail() {
    changeEmail = true;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void changeEmailCustom() {
    changeEmail = !changeEmail;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void emailCustomChange(String val) {
    emailCustom = val;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void completeCountDown() {
    whenCompleteCountdown = "completed";
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void otpCompleted(v) {
    otp = v;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> verifyOtp(BuildContext context) async {
    setVerifyOtpStatus(VerifyOtpStatus.loading);
    try {
      if (otp!.isEmpty || otp == "") {
        ShowSnackbar.snackbar(
            context, 'Isi OTP terlebih dahulu!', '', ColorResources.error);
        return;
      }
      AuthModel auth = await ar.verifyOtp(changeEmailName, otp!);
      SharedPrefs.writeAuthData(auth.data!);
      SharedPrefs.writeAuthToken();
      NS.pushReplacement(context, const DashboardScreen());
      Future.delayed(const Duration(seconds: 1), () async {
        setVerifyOtpStatus(VerifyOtpStatus.loaded);
      });
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showErrorCustom(context,
          title: '', message: "Kode OTP yang anda masukkan salah");
      setVerifyOtpStatus(VerifyOtpStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'AP07');
      setVerifyOtpStatus(VerifyOtpStatus.error);
    }
  }

  Future<void> resendOtp(BuildContext context, String email) async {
    setResendOtpStatus(ResendOtpStatus.loading);
    try {
      await ar.resendOtp(
        email,
      );
      ShowSnackbar.snackbar(
          context,
          "${getTranslated('CHECK_YOUR_EMAIL', context)} $email, ${getTranslated('TO_SEE_THE_OTP', context)}",
          "",
          ColorResources.success);
      setResendOtpStatus(ResendOtpStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'AR08');
      setResendOtpStatus(ResendOtpStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'AP08');
      setResendOtpStatus(ResendOtpStatus.error);
    }
  }

  Future<List<JobData>> getJobs(BuildContext context) async {
    setStateJobStatus(JobStatus.loading);
    try {
      _jobs = [];
      JobModel? jm = await ar.getJobs();
      List<JobData>? jobData = jm!.data!;
      if (jobData.isNotEmpty) {
        _jobs!.addAll(jobData);
        setStateJobStatus(JobStatus.loaded);
      } else {
        setStateJobStatus(JobStatus.empty);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'AR09');
      setStateJobStatus(JobStatus.error);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'AP09');
      setStateJobStatus(JobStatus.error);
    }
    return [];
  }

  Future<List<OrganizationData>> getOrganizations(BuildContext context) async {
    setStateOrganizationStatus(OrganizationStatus.loading);
    try {
      _organizations = [];
      OrganizationModel? om = await ar.getOrganizations();
      List<OrganizationData>? organizationData = om!.data!;
      if (organizationData.isNotEmpty) {
        _organizations!.addAll(organizationData);
        setStateOrganizationStatus(OrganizationStatus.loaded);
      } else {
        setStateOrganizationStatus(OrganizationStatus.empty);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'AR10');
      setStateOrganizationStatus(OrganizationStatus.error);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'AP10');
      setStateOrganizationStatus(OrganizationStatus.error);
    }
    return [];
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    setStateLoginGoogleStatus(LoginGoogleStatus.loading);
    final firebaseInstance = FirebaseAuth.instance;
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setStateLoginGoogleStatus(LoginGoogleStatus.idle);
        return;
      }
      _userFromGoogle = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await firebaseInstance.signInWithCredential(credential);

      AuthModel auth = await ar.loginSocialMedia(
          email: firebaseInstance.currentUser!.email!,
          name: firebaseInstance.currentUser!.displayName!);

      SharedPrefs.writeAuthData(
        auth.data!,
      );
      SharedPrefs.writeAuthToken();
      NS.pushReplacement(context, const DashboardScreen());

      Future.delayed(
        const Duration(seconds: 2),
        () {
          googleSignIn.disconnect();
          firebaseInstance.signOut();
          setStateLoginGoogleStatus(LoginGoogleStatus.loaded);
        },
      );
    } on CustomException catch (e) {
      if (e.toString().contains("Pengguna")) {
        NS.push(
            context,
            SignUpScreen(
              email: firebaseInstance.currentUser!.email!,
              name: firebaseInstance.currentUser!.displayName!,
            ));
      } else {
        CustomDialog.showUnexpectedError(context, errorCode: 'AR11');
      }
      googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
      setStateLoginGoogleStatus(LoginGoogleStatus.error);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'AP11');
      setStateLoginGoogleStatus(LoginGoogleStatus.error);
    }
  }

  void deleteData() {
    SharedPrefs.deleteData();
    DBHelper.deleteAccounts();
  }

  void logout(BuildContext context) {
    googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    deleteData();
    Future.delayed(const Duration(milliseconds: 500), () {
      NS.pushReplacementUntil(context, const SignInScreen());
    });
  }
}
