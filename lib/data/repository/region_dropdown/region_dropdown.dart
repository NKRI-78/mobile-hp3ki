import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hp3ki/data/models/region_dropdown/city.dart';
import 'package:hp3ki/data/models/region_dropdown/district.dart';
import 'package:hp3ki/data/models/region_dropdown/province.dart';
import 'package:hp3ki/data/models/region_dropdown/subdisctrict.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/utils/exceptions.dart';

class RegionDropdownRepo {
  Dio? dioClient;

  RegionDropdownRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<ProvinceModel?> getProvinces() async {
    try {
      Response res = await dioClient!.post(
          "${AppConstants.baseUrl}/api/v1/administration/provinces",
          data: {});
      ProvinceModel province = ProvinceModel.fromJson(res.data);
      return province;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<CityModel?> getCities({required String province}) async {
    try {
      Response res = await dioClient!
          .post("${AppConstants.baseUrl}/api/v1/administration/cities", data: {
        "province_name": province,
      });
      CityModel city = CityModel.fromJson(res.data);
      return city;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<DistrictModel?> getDistricts({required String city}) async {
    try {
      Response res = await dioClient!.post(
          "${AppConstants.baseUrl}/api/v1/administration/districts",
          data: {
            "city_name": city,
          });
      DistrictModel district = DistrictModel.fromJson(res.data);
      return district;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<SubdistrictModel?> getSubdistricts({required String district}) async {
    try {
      Response res = await dioClient!.post(
          "${AppConstants.baseUrl}/api/v1/administration/subdistricts",
          data: {
            "district_name": district,
          });
      SubdistrictModel subdistrict = SubdistrictModel.fromJson(res.data);
      return subdistrict;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
}
