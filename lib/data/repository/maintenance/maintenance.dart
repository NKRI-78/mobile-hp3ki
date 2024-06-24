import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hp3ki/data/models/maintenance/demo.dart';
import 'package:hp3ki/data/models/maintenance/maintenance.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/utils/exceptions.dart';

class MaintenanceRepo {
  Dio? dioClient;

  MaintenanceRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<MaintenanceModel?> getMaintenanceStatus() async {
    try {
      Response res = await dioClient!.get("${AppConstants.baseUrl}/api/v1/maintenance");
      MaintenanceModel dataJson = MaintenanceModel.fromJson(res.data);
      return dataJson;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e);
      throw CustomException(errorMessage);
    }catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      debugPrint(e.toString());
      throw CustomException(e.toString());
    }
  }

  Future<DemoModel?> getDemoStatus() async {
    try {
      Response res = await dioClient!.get("${AppConstants.baseUrl}/api/v1/maintenance/show-demo");
      DemoModel dataJson = DemoModel.fromJson(res.data);
      return dataJson;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    }catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      debugPrint(e.toString());
      throw CustomException(e.toString());
    }
  }
}