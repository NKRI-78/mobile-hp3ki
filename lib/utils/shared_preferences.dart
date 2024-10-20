import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hp3ki/data/models/auth/auth.dart';
import 'package:hp3ki/data/models/user/user.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _instance;

  static Future init() async {
    _instance = await SharedPreferences.getInstance();
  }

  static bool isSkipOnboarding() {
    return _instance!.getBool("onboarding") == null ? false : true;
  }

  static void setOnboarding(bool value) {
    _instance!.setBool('onboarding', value);
  }

  static double? getLat() {
    return _instance!.getDouble('lat');
  }

  static double? getLng() {
    return _instance!.getDouble('lng');
  }

  static double getLatCheckIn() {
    return _instance!.getDouble('latCheckIn') ?? 0.0;
  }

  static double getLngCheckIn() {
    return _instance!.getDouble('lngCheckIn') ?? 0.0;
  }

  static void writeLatLng(double lat, double lng) {
    _instance!.setDouble("lat", lat);
    _instance!.setDouble("lng", lng);
  }

  static void writeLatLngCheckIn(double lat, double lng) {
    _instance!.setDouble("latCheckIn", lat);
    _instance!.setDouble("lngCheckIn", lng);
  }

  static String? getRegFullname() {
    return _instance!.getString('reg_fullname');
  }

  static String? getRegPhone() {
    return _instance!.getString('reg_phone');
  }

  static String? getRegEmail() {
    return _instance!.getString('reg_email');
  }

  static String? getRegPassword() {
    return _instance!.getString('reg_password');
  }

  static String? getRegOrgName() {
    return _instance!.getString('reg_organization_name');
  }

  static String? getRegJobName() {
    return _instance!.getString('reg_job_name');
  }

  static String? getRegJob() {
    return _instance!.getString('reg_job');
  }

  static void writeRegJobName(String? value) {
    _instance!.setString('reg_job_name', value ?? "...");
  }

  static void writeRegOrgName(String? value) {
    _instance!.setString('reg_organization_name', value ?? "...");
  }

  static void writeRegisterData({
    required String fullname,
    required String email,
    required String password,
    required String phone,
    required String organization,
    required String job,
    required String referral,
  }) {
    _instance!.setString("reg_fullname", fullname);
    _instance!.setString("reg_email", email);
    _instance!.setString("reg_password", password);
    _instance!.setString("reg_phone", phone);
    _instance!.setString("reg_organization", organization);
    _instance!.setString("reg_job", job);
    _instance!.setString("reg_referral", referral);
  }

  static Object getRegisterObject() {
    Object data = {
      "fullname": _instance!.getString("reg_fullname"),
      "email": _instance!.getString("reg_email"),
      "password": _instance!.getString("reg_password"),
      "phone": _instance!.getString("reg_phone"),
      "organization": _instance!.getString("reg_organization"),
      "job": _instance!.getString("reg_job"),
      "referral": _instance!.getString("reg_referral")
    };
    return data;
  }

  static void deleteIfUserRegistered() {
    _instance!.remove("email_otp");
    _instance!.remove("reg_fullname");
    _instance!.remove("reg_email");
    _instance!.remove("reg_password");
    _instance!.remove("reg_phone");
    _instance!.remove("reg_organization");
    _instance!.remove("reg_organization_name");
    _instance!.remove("reg_job");
    _instance!.remove("reg_job_name");
    _instance!.remove("reg_referral");
  }

  static String getLanguageCode() {
    return _instance!.getString(AppConstants.languageCode) ?? 'id';
  }

  static String getCountryCode() {
    return _instance!.getString(AppConstants.countryCode) ?? 'ID';
  }

  static void saveLanguagePrefs(Locale locale) {
    _instance!.setString(AppConstants.languageCode, locale.languageCode);
    _instance!.setString(AppConstants.countryCode, locale.countryCode!);
  }

  static String getCurrentNameAddress() {
    return _instance!.getString("currentNameAddress") ??
        "Lokasi tidak ditemukan";
  }

  static String getCurrentNameAddressCheckIn() {
    return _instance!.getString("currentNameAddressCheckIn") ??
        "Lokasi tidak ditemukan";
  }

  static void writeCurrentAddress(String address) {
    _instance!.setString("currentNameAddress", address);
  }

  static void writeCurrentAddressCheckIn(String address) {
    _instance!.setString("currentNameAddressCheckIn", address);
  }

  static void writeOtherMemberPosition(double position) {
    _instance!.setDouble("otherMemberPosition", position);
  }

  static void deleteOtherMemberPosition() {
    _instance!.remove("otherMemberPosition");
  }

  static String getForgetEmail() {
    return _instance!.getString('forget_email')!;
  }

  static void writeForgetEmail(String email) {
    _instance!.setString("forget_email", email);
  }

  static String getEmailOTP() {
    return _instance!.getString('email_otp')!;
  }

  static void writeEmailOTP(AuthUser user) {
    _instance!.setString('email_otp', user.email!);
  }

  static void writeChangeEmailData(String email) {
    _instance!.setString("email_otp", email);
    _instance!.setString("reg_email", email);
  }

  static void writeLoginTemp(AuthUser user) {
    _instance!.setString('email_otp', user.email!);
    _instance!.setString("reg_phoneNumber", user.phone!);
  }

  static bool isLoggedIn() {
    return _instance!.containsKey("token");
  }

  static String getUserToken() {
    return _instance!.getString("token") ?? "-";
  }

  static void writeAuthData(AuthData authData) {
    _instance!.setString(
        "auth",
        json.encode({
          "token": authData.token,
          "refreshToken": authData.refreshToken,
          "uid": authData.user!.id,
          "name": authData.user!.name,
          "email": authData.user!.email,
          "phone": authData.user!.phone,
          "role": authData.user!.role,
        }));
  }

  static void writeAuthToken() {
    Map<String, dynamic> prefs = json.decode(_instance!.getString("auth")!);
    _instance!.setString("token", prefs["token"]);
    _instance!.setString("refreshToken", prefs["refreshToken"]);
  }

  static String getUserName() {
    Map<String, dynamic> prefs = json.decode(_instance!.getString("auth")!);
    return prefs["fullname"] ?? "-";
  }

  static String getUserAvatar() {
    Map<String, dynamic> prefs = json.decode(_instance!.getString("user")!);
    return prefs["avatar"] ?? "-";
  }

  static String getUserEmail() {
    Map<String, dynamic> prefs = json.decode(_instance!.getString("auth")!);
    return prefs["email"] ?? "-";
  }

  static String getUserPhone() {
    Map<String, dynamic> prefs = json.decode(_instance!.getString("auth")!);
    return prefs["phone"] ?? "-";
  }

  static String getUserId() {
    Map<String, dynamic> prefs = json.decode(_instance!.getString("auth")!);
    return prefs["uid"] ?? "-";
  }

  static String getUserMemberType() {
    Map<String, dynamic> prefs = json.decode(_instance!.getString("user")!);
    return prefs["member_type"] ?? "-";
  }

  static bool? getUserFulfilledDataStatus() {
    Map<String, dynamic> prefs = json.decode(_instance!.getString("user")!);
    return prefs["fulfilled_data"] ?? "-";
  }

  static void writeUserData(UserData user) {
    _instance!.setString("user",
      json.encode({
        "id": user.id,
        "avatar": user.avatar,
        "fullname": user.fullname,
        "email": user.email,
        "phone": user.phone,
        "role": user.role,
        "pic_ktp": user.picKtp,
        "address_ktp": user.addressKtp,
        "no_ktp": user.noKtp,
        "no_member": user.noMember,
        "job": user.job,
        "organization": user.organization,
        "member_type": user.memberType,
        "fulfilled_data": user.fulfilledUserData,
      })
    );
  }

  static void deleteData() {
    _instance!.remove("auth");
    _instance!.remove("user");
    _instance!.remove("token");
    _instance!.remove("refreshToken");
    deleteIfUserRegistered();
    deleteJobDataForm();
  }

  static void writeEnterpreneursData({
    required String nameInstance,
    required String addressInstance,
    required String jobProvinceId,
    required String jobProvince,
    required String jobCityId,
    required String jobCity,
    required String jobDistrictId,
    required String jobDistrict,
    required String jobSubdistrictId,
    required String jobSubdistrict,
    required String formOfBusiness,
    required String formOfClassification,
    required String employeeCount,
    required String personResponsible,
    required String noPersonResponsible,
  }) {
    _instance!.setString("name_instance", nameInstance);
    _instance!.setString("address_instance", addressInstance);
    _instance!.setString("job_province_id", jobProvinceId);
    _instance!.setString("job_province", jobProvince);
    _instance!.setString("job_city_id", jobCityId);
    _instance!.setString("job_city", jobCity);
    _instance!.setString("job_district_id", jobDistrictId);
    _instance!.setString("job_district", jobDistrict);
    _instance!.setString("job_subdistrict_id", jobSubdistrictId);
    _instance!.setString("job_subdistrict", jobSubdistrict);
    _instance!.setString("form_of_business", formOfBusiness);
    _instance!.setString("form_of_classification", formOfClassification);
    _instance!.setString("employee_count", employeeCount);
    _instance!.setString("person_responsible", personResponsible);
    _instance!.setString("no_person_responsible", noPersonResponsible);
  }

  static Object getEnterpreneursData() {
    Object data = {
      "name_instance": _instance!.getString("name_instance"),
      "address_instance": _instance!.getString("address_instance"),
      "province_id": _instance!.getString("job_province_id"),
      "province": _instance!.getString("job_province"),
      "city_id": _instance!.getString("job_city_id"),
      "city": _instance!.getString("job_city"),
      "district_id": _instance!.getString("job_district_id"),
      "district": _instance!.getString("job_district"),
      "subdistrict_id": _instance!.getString("job_subdistrict_id"),
      "subdistrict": _instance!.getString("job_subdistrict"),
      "form_of_business": _instance!.getString("form_of_business"),
      "form_of_classification": _instance!.getString("form_of_classification"),
      "employee_count": _instance!.getString("employee_count"),
      "person_responsible": _instance!.getString("person_responsible"),
      "no_person_responsible": _instance!.getString("no_person_responsible"),
      "user_id": getUserId(),
    };
    return data;
  }

  static Object getOtherJobData() {
    Object data = {
      "name_instance": _instance!.getString("name_instance"),
      "address_instance": _instance!.getString("address_instance"),
      "province_id": _instance!.getString("job_province_id"),
      "province": _instance!.getString("job_province"),
      "city_id": _instance!.getString("job_city_id"),
      "city": _instance!.getString("job_city"),
      "district_id": _instance!.getString("job_district_id"),
      "district": _instance!.getString("job_district"),
      "subdistrict_id": _instance!.getString("job_subdistrict_id"),
      "subdistrict": _instance!.getString("job_subdistrict"),
      "form_of_business": _instance!.getString("form_of_business"),
      "form_of_classification": _instance!.getString("form_of_classification"),
      "user_id": getUserId(),
    };
    return data;
  }

  static void writeOtherJobData({
    required String nameInstance,
    required String addressInstance,
    required String jobProvinceId,
    required String jobProvince,
    required String jobCityId,
    required String jobCity,
    required String jobDistrictId,
    required String jobDistrict,
    required String jobSubdistrictId,
    required String jobSubdistrict,
    required String formOfBusiness,
    required String formOfClassification,
  }) {
    _instance!.setString("name_instance", nameInstance);
    _instance!.setString("address_instance", addressInstance);
    _instance!.setString("job_province_id", jobProvinceId);
    _instance!.setString("job_province", jobProvince);
    _instance!.setString("job_city_id", jobCityId);
    _instance!.setString("job_city", jobCity);
    _instance!.setString("job_district_id", jobDistrictId);
    _instance!.setString("job_district", jobDistrict);
    _instance!.setString("job_subdistrict_id", jobSubdistrictId);
    _instance!.setString("job_subdistrict", jobSubdistrict);
    _instance!.setString("form_of_business", formOfBusiness);
    _instance!.setString("form_of_classification", formOfClassification);
  }

  static void deleteJobDataForm() {
    _instance!.remove("name_instance");
    _instance!.remove("address_instance");
    _instance!.remove("job_province_id");
    _instance!.remove("job_province");
    _instance!.remove("job_city_id");
    _instance!.remove("job_city");
    _instance!.remove("job_district_id");
    _instance!.remove("job_district");
    _instance!.remove("job_subdistrict_id");
    _instance!.remove("job_subdistrict");
    _instance!.remove("form_of_business");
    _instance!.remove("form_of_classification");
    _instance!.remove("employee_count");
    _instance!.remove("person_responsible");
    _instance!.remove("no_person_responsible");
  }

  static Object getPersonalDataObject() {
    Object data = {
      "fullname": _instance!.getString('personal_fullname'),
      "address_ktp": _instance!.getString('personal_addressKtp'),
      "pic_ktp": _instance!.getString('personal_picKtp'),
      "no_ktp": _instance!.getString('personal_noKtp'),
      "avatar": _instance!.getString('personal_avatar'),
      "user_id": getUserId(),
      "province_id": _instance!.getString('personal_provinceId'),
      "province": _instance!.getString('personal_province'),
      "city_id": _instance!.getString('personal_cityId'),
      "city": _instance!.getString('personal_city'),
      "district_id": _instance!.getString('personal_districtId'),
      "district": _instance!.getString('personal_district'),
      "subdistrict_id": _instance!.getString('personal_subdistrictId'),
      "subdistrict": _instance!.getString('personal_subdistrict'),
    };
    return data;
  }

  static void writePersonalData({
    required String fullname,
    required String addressKtp,
    required String picKtp,
    required String noKtp,
    required String avatar,
    required String provinceId,
    required String province,
    required String cityId,
    required String city,
    required String districtId,
    required String district,
    required String subdistrictId,
    required String subdistrict,
  }) {
    _instance!.setString('personal_fullname', fullname);
    _instance!.setString('personal_addressKtp', addressKtp);
    _instance!.setString('personal_picKtp', picKtp);
    _instance!.setString('personal_noKtp', noKtp);
    _instance!.setString('personal_avatar', avatar);
    _instance!.setString('personal_provinceId', provinceId);
    _instance!.setString('personal_province', province);
    _instance!.setString('personal_cityId', cityId);
    _instance!.setString('personal_city', city);
    _instance!.setString('personal_districtId', districtId);
    _instance!.setString('personal_district', district);
    _instance!.setString('personal_subdistrictId', subdistrictId);
    _instance!.setString('personal_subdistrict', subdistrict);
  }

  static void deletePersonalDataForm() {
    _instance!.remove('personal_fullname');
    _instance!.remove('personal_addressKtp');
    _instance!.remove('personal_picKtp');
    _instance!.remove('personal_noKtp');
    _instance!.remove('personal_avatar');
    _instance!.remove('personal_provinceId');
    _instance!.remove('personal_province');
    _instance!.remove('personal_cityId');
    _instance!.remove('personal_city');
    _instance!.remove('personal_districtId');
    _instance!.remove('personal_district');
    _instance!.remove('personal_subdistrictId');
    _instance!.remove('personal_subdistrict');
  }
}
