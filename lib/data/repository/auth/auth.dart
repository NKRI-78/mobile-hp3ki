import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:hp3ki/data/models/auth/auth.dart';
import 'package:hp3ki/data/models/job/job.dart';
import 'package:hp3ki/data/models/organization/organization.dart';

import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/shared_preferences.dart';

class AuthRepo {
  Dio? dioClient;
  
  AuthRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<JobModel?> getJobs() async {
    try {
      Response res = await dioClient!.get("${AppConstants.baseUrl}/api/v1/job");
      JobModel data = JobModel.fromJson(res.data);
      return data;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<OrganizationModel?> getOrganizations() async {
    try {
      Response res = await dioClient!.get("${AppConstants.baseUrl}/api/v1/organization");
      OrganizationModel data = OrganizationModel.fromJson(res.data);
      return data;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    }catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<AuthModel> login(String emailOrPhone, String password) async {
    try {
      Response res = await dioClient!.post("${AppConstants.baseUrl}/api/v1/auth/login",
        data: {
          "email": emailOrPhone, 
          "password": password
        }
      ); 
      Map<String, dynamic> data = res.data;
      AuthModel auth = AuthModel.fromJson(data);
      return auth;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
  
  Future<AuthModel> register(Object data) async {
    try {
      Response res = await dioClient!.post("${AppConstants.baseUrl}/api/v1/auth/register",
        data: data
      );
      Map<String, dynamic> resData = res.data;
      AuthModel auth = AuthModel.fromJson(resData);
      return auth;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> changePassword(String email, String oldPassword, String newPassword) async {
    try {
      await dioClient!.post("${AppConstants.baseUrl}/api/v1/auth/change-password", data: {
        "email": email,
        "old_password": oldPassword,
        "new_password": newPassword,
        "is_forget": false,
      });
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> setNewPassword(String email, String oldPassword, String newPassword) async {
    try {
      await dioClient!.post("${AppConstants.baseUrl}/api/v1/auth/change-password", data: {
        "email": email,
        "old_password": oldPassword,
        "new_password": newPassword,
        "is_forget": true,
      });
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> forgetPassword(String email) async {
    try {
      await dioClient!.post("${AppConstants.baseUrl}/api/v1/auth/forgot-password",
        data: {
          "email": email   
        }
      );
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> applyChangeEmailOtp(String email, String oldEmail) async {
    try {
      await dioClient!.post("${AppConstants.baseUrl}/api/v1/auth/update-email", data: {
        "old_email": oldEmail,
        "new_email": email,
      });
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    }catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<AuthModel> verifyOtp(String email, String otp) async {
    try {
      Response res = await dioClient!.post("${AppConstants.baseUrl}/api/v1/auth/verify-otp", data: {
          "email": email,
          "otp": otp,
        }
      );
      Map<String, dynamic> data = res.data;
      AuthModel auth = AuthModel.fromJson(data);
      return auth;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> resendOtp(String email) async {
    try {
      await dioClient!.post("${AppConstants.baseUrl}/api/v1/auth/resend-otp", data: {
        "email": email,
      });
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<AuthModel> loginSocialMedia({required String email, required String name}) async {
    try {
      Response res = await dioClient!.post("${AppConstants.baseUrl}/api/v1/auth/social-media", data: {
        "email": email,
      });
      Map<String, dynamic> data = res.data;
      AuthModel auth = AuthModel.fromJson(data);
      return auth;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  String getUserId() {
    return SharedPrefs.getUserId();
  }

  String getUserAvatar() {
    return SharedPrefs.getUserAvatar();
  }

  String getUserFullname() {
    return SharedPrefs.getUserName();
  }

  String getUserEmail() {
    return SharedPrefs.getUserEmail();
  }
}