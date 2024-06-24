import 'package:flutter/material.dart';
import 'package:hp3ki/data/models/region_dropdown/city.dart';
import 'package:hp3ki/data/models/region_dropdown/district.dart';
import 'package:hp3ki/data/models/region_dropdown/province.dart';
import 'package:hp3ki/data/models/region_dropdown/subdisctrict.dart';
import 'package:hp3ki/data/repository/region_dropdown/region_dropdown.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/views/basewidgets/dialog/custom/custom.dart';

enum ProvinceStatus { loading, loaded, error, empty }
enum CityStatus { loading, loaded, error, empty }
enum DistrictStatus { loading, loaded, error, empty }
enum SubdistrictStatus { loading, loaded, error, empty }

class RegionDropdownProvider with ChangeNotifier {
  final RegionDropdownRepo rr;

  RegionDropdownProvider({ required this.rr, });

  late TextEditingController currentProvinceIdC;
  late TextEditingController currentCityIdC;
  late TextEditingController currentDistrictIdC;
  late TextEditingController currentSubdistrictIdC;

  String? _currentProvince;
  String? get currentProvince => _currentProvince;

  String? _currentCity;
  String? get currentCity => _currentCity;

  String? _currentDistrict;
  String? get currentDistrict => _currentDistrict;

  String? _currentSubdistrict;
  String? get currentSubdistrict => _currentSubdistrict;

  List<ProvinceData>? _provinces;
  List<ProvinceData>? get provinces => _provinces;

  List<CityData>? _cities;
  List<CityData>? get cities => _cities;

  List<DistrictData>? _districts;
  List<DistrictData>? get districts => _districts;

  List<SubdistrictData>? _subdistricts;
  List<SubdistrictData>? get subdistricts => _subdistricts;

  DistrictStatus _districtStatus = DistrictStatus.empty;
  DistrictStatus get districtStatus => _districtStatus;

  SubdistrictStatus _subdistrictStatus = SubdistrictStatus.empty;
  SubdistrictStatus get subdistrictStatus => _subdistrictStatus;

  CityStatus _cityStatus = CityStatus.empty;
  CityStatus get cityStatus => _cityStatus;

  ProvinceStatus _provinceStatus = ProvinceStatus.empty;
  ProvinceStatus get provinceStatus => _provinceStatus;

  void setStateCityStatus(CityStatus cityStatus) {
    _cityStatus = cityStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateDistrictStatus(DistrictStatus districtStatus) {
    _districtStatus = districtStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateSubdistrictStatus(SubdistrictStatus subdistrictStatus) {
    _subdistrictStatus = subdistrictStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateProvinceStatus(ProvinceStatus provinceStatus) {
    _provinceStatus = provinceStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void initRegion(context) {
    currentProvinceIdC = TextEditingController();
    currentCityIdC = TextEditingController();
    currentDistrictIdC = TextEditingController();
    currentSubdistrictIdC = TextEditingController();
    _currentProvince = "";
    _currentCity = "";
    _currentDistrict = "";
    _currentSubdistrict = "";
    currentProvinceIdC.text = "";
    currentCityIdC.text = "";
    currentDistrictIdC.text = "";
    currentSubdistrictIdC.text = "";
    setStateProvinceStatus(ProvinceStatus.empty);
    setStateCityStatus(CityStatus.empty);
    setStateDistrictStatus(DistrictStatus.empty);
    setStateSubdistrictStatus(SubdistrictStatus.empty);
    getProvince(context);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setCurrentProvince(BuildContext context, {required String name}) {
    _currentProvince = name;
    _currentCity = "";
    _currentDistrict = "";
    _currentSubdistrict = "";
    currentCityIdC.text = "";
    currentDistrictIdC.text = "";
    currentSubdistrictIdC.text = "";
    setStateCityStatus(CityStatus.empty);
    setStateDistrictStatus(DistrictStatus.empty);
    setStateSubdistrictStatus(SubdistrictStatus.empty);
    getCities(context, province: name);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setCurrentCity(BuildContext context, {required String name}) {
    _currentCity = name;
    _currentDistrict = "";
    _currentSubdistrict = "";
    currentDistrictIdC.text = "";
    currentSubdistrictIdC.text = "";
    setStateDistrictStatus(DistrictStatus.empty);
    setStateSubdistrictStatus(SubdistrictStatus.empty);
    getDistricts(context, city: name);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setCurrentDistrict(BuildContext context, {required String name}) {
    _currentDistrict = name;
    currentSubdistrictIdC.text = "";
    _currentSubdistrict = "";
    setStateSubdistrictStatus(SubdistrictStatus.empty);
    getSubdistricts(context, district: name);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setCurrentSubdistrict({required String name}) {
    _currentSubdistrict = name;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getProvince(BuildContext context) async {
    setStateProvinceStatus(ProvinceStatus.loading);
    try {   
      _provinces = [];
      ProvinceModel? rm = await rr.getProvinces();
      List<ProvinceData> provinces = rm!.data!;
      if(provinces.isNotEmpty) {
        _provinces!.addAll(provinces);
        setStateProvinceStatus(ProvinceStatus.loaded);
      } else {
        setStateProvinceStatus(ProvinceStatus.empty);
      }
    } on CustomException {
      CustomDialog.showUnexpectedError(context, errorCode: 'RDR01');
      setStateProvinceStatus(ProvinceStatus.error);
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      setStateProvinceStatus(ProvinceStatus.error);
      CustomDialog.showUnexpectedError(context, errorCode: 'RDP01');
    }
  }

  Future<void> getCities(BuildContext context, {required String province}) async {
    setStateCityStatus(CityStatus.loading);
    try {   
      _cities = [];
      CityModel? rm = await rr.getCities(province: province);
      List<CityData> cities = rm!.data!;
      if(cities.isNotEmpty) {
        _cities!.addAll(cities);
        setStateCityStatus(CityStatus.loaded);
      } else {
        setStateCityStatus(CityStatus.empty);
      }
    } on CustomException {
      CustomDialog.showUnexpectedError(context, errorCode: 'RDR02');
      setStateCityStatus(CityStatus.error);
    }catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'RDP02');
      setStateCityStatus(CityStatus.error);
    }
  }

  Future<void> getDistricts(BuildContext context, {required String city}) async {
    setStateDistrictStatus(DistrictStatus.loading);
    try {   
      _districts = [];
      DistrictModel? rm = await rr.getDistricts(city: city);
      List<DistrictData> districts = rm!.data!;
      if(districts.isNotEmpty) {
        _districts!.addAll(districts);
        setStateDistrictStatus(DistrictStatus.loaded);
      } else {
        setStateDistrictStatus(DistrictStatus.empty);
      }
    } on CustomException {
      CustomDialog.showUnexpectedError(context, errorCode: 'RDR03');
      setStateDistrictStatus(DistrictStatus.error);
    }catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'RDP03');
      setStateDistrictStatus(DistrictStatus.error);
    }
  }

  Future<void> getSubdistricts(BuildContext context, {required String district}) async {
    setStateSubdistrictStatus(SubdistrictStatus.loading);
    try {   
      _subdistricts = [];
      SubdistrictModel? rm = await rr.getSubdistricts(district: district);
      List<SubdistrictData> subdistricts = rm!.data!;
      if(subdistricts.isNotEmpty) {
        _subdistricts!.addAll(subdistricts);
        setStateSubdistrictStatus(SubdistrictStatus.loaded);
      } else {
        setStateSubdistrictStatus(SubdistrictStatus.empty);
      }
    } on CustomException {
      CustomDialog.showUnexpectedError(context, errorCode: 'RDR04');
      setStateSubdistrictStatus(SubdistrictStatus.error);
    }catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'RDP04');
      setStateSubdistrictStatus(SubdistrictStatus.error);
    }
  }

}