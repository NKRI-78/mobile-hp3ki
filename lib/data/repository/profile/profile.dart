import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hp3ki/data/models/enterpreneurs_additional_data/business.dart';
import 'package:hp3ki/data/models/enterpreneurs_additional_data/classifications.dart';
import 'package:hp3ki/data/models/user/user.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/utils/exceptions.dart';

class ProfileRepo {
  Dio? dioClient;

  ProfileRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<int> remote() async {
    try {
      Response res = await dioClient!.get("/api/v1/admin/remote");
      Map<String, dynamic> data = res.data;
      return data["data"]["is_active"];
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    }catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<UserModel?> getProfile(String userId) async {
    try {
      Response res = await dioClient!.post("${AppConstants.baseUrl}/user-service/profile", data: {
        "user_id": userId,
      });
      UserModel user = UserModel.fromJson(res.data);
      return user;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    }catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<BusinessModel?> getBusinessList() async {
    try {
      Response res = await dioClient!.get("${AppConstants.baseUrl}/api/v1/form/business");
      BusinessModel business = BusinessModel.fromJson(res.data);
      return business;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    }catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<ClassificationModel?> getClassificationList() async {
    try {
      Response res = await dioClient!.get("${AppConstants.baseUrl}/api/v1/form/classification");
      ClassificationModel classification = ClassificationModel.fromJson(res.data);
      return classification;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    }catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> fulfillJobData(Object data, String formJobType) async {
    try {
      await dioClient!.post("${AppConstants.baseUrl}/api/v1/organization/data-$formJobType",
        data: data
      );
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> updateProfile({required Object data}) async {
    try {
      await dioClient!.post("${AppConstants.baseUrl}/user-service/profile/update",
        data: data,
      );
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> updateProfilePicture({required String pfpPath, required String userId}) async {
    try {
      await dioClient!.post("${AppConstants.baseUrl}/user-service/profile/update",
        data: {
          "avatar": pfpPath,
          "user_id": userId,
        }
      );
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> updateProfileNameOrAddress({required String name, required String address, required String userId}) async {
    try {
      await dioClient!.post("${AppConstants.baseUrl}/user-service/profile/update",
        data: {
          "fullname": name,
          "address_ktp": address,
          "user_id": userId,
        }
      );
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
}