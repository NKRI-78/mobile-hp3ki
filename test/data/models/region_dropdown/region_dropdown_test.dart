import 'package:flutter_test/flutter_test.dart';
import 'package:hp3ki/data/models/region_dropdown/city.dart';
import 'package:hp3ki/data/models/region_dropdown/district.dart';
import 'package:hp3ki/data/models/region_dropdown/province.dart';
import 'package:hp3ki/data/models/region_dropdown/subdisctrict.dart';

import '../../dummy_data/region_dropdown/mock_city.dart';
import '../../dummy_data/region_dropdown/mock_district.dart';
import '../../dummy_data/region_dropdown/mock_province.dart';
import '../../dummy_data/region_dropdown/mock_subdistrict.dart';

void main() {
  group("Test CityData initialization from json", () {
    late Map<String, dynamic> apiCityAsJson;
    late CityData expectedApiCity;

    setUp(() {
      apiCityAsJson = MockCity.dummyCityJson;
      expectedApiCity = MockCity.expectedCityData;
    });

    test('should be an City data', () {
      //act
      var result = CityData.fromJson(apiCityAsJson);
      //assert
      expect(result, isA<CityData>());
    });

    test('should not be an City model', () {
      //act
      var result = CityData.fromJson(apiCityAsJson);
      //assert
      expect(result, isNot(CityModel()));
    });

    test('result should be as expected', () {
      //act
      var result = CityData.fromJson(apiCityAsJson);
      //assert
      expect(result, expectedApiCity);
    });
  });

  group("Test DistrictData initialization from json", () {
    late Map<String, dynamic> apiDistrictAsJson;
    late DistrictData expectedApiDistrict;

    setUp(() {
      apiDistrictAsJson = MockDistrict.dummyDistrictJson;
      expectedApiDistrict = MockDistrict.expectedDistrictData;
    });

    test('should be an District data', () {
      //act
      var result = DistrictData.fromJson(apiDistrictAsJson);
      //assert
      expect(result, isA<DistrictData>());
    });

    test('should not be an District model', () {
      //act
      var result = DistrictData.fromJson(apiDistrictAsJson);
      //assert
      expect(result, isNot(DistrictModel()));
    });

    test('result should be as expected', () {
      //act
      var result = DistrictData.fromJson(apiDistrictAsJson);
      //assert
      expect(result, expectedApiDistrict);
    });
  });

  group("Test SubdistrictData initialization from json", () {
    late Map<String, dynamic> apiSubdistrictAsJson;
    late SubdistrictData expectedApiSubdistrict;

    setUp(() {
      apiSubdistrictAsJson = MockSubdistrict.dummySubdistrictJson;
      expectedApiSubdistrict = MockSubdistrict.expectedSubdistrictData;
    });

    test('should be an District data', () {
      //act
      var result = SubdistrictData.fromJson(apiSubdistrictAsJson);
      //assert
      expect(result, isA<SubdistrictData>());
    });

    test('should not be an District model', () {
      //act
      var result = SubdistrictData.fromJson(apiSubdistrictAsJson);
      //assert
      expect(result, isNot(DistrictModel()));
    });

    test('result should be as expected', () {
      //act
      var result = SubdistrictData.fromJson(apiSubdistrictAsJson);
      //assert
      expect(result, expectedApiSubdistrict);
    });
  });

  group("Test ProvinceData initialization from json", () {
    late Map<String, dynamic> apiProvinceAsJson;
    late ProvinceData expectedApiProvince;

    setUp(() {
      apiProvinceAsJson = MockProvince.dummyProvinceJson;
      expectedApiProvince = MockProvince.expectedProvinceData;
    });

    test('should be an Province data', () {
      //act
      var result = ProvinceData.fromJson(apiProvinceAsJson);
      //assert
      expect(result, isA<ProvinceData>());
    });

    test('should not be an Province model', () {
      //act
      var result = ProvinceData.fromJson(apiProvinceAsJson);
      //assert
      expect(result, isNot(ProvinceModel()));
    });

    test('result should be as expected', () {
      //act
      var result = ProvinceData.fromJson(apiProvinceAsJson);
      //assert
      expect(result, expectedApiProvince);
    });
  });
}
