import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/region_dropdown/province.dart';
import 'package:hp3ki/data/models/region_dropdown/city.dart';
import 'package:hp3ki/data/models/region_dropdown/district.dart';
import 'package:hp3ki/data/models/region_dropdown/subdisctrict.dart';
import 'package:hp3ki/data/repository/region_dropdown/region_dropdown.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:hp3ki/utils/constant.dart';
import '../../../helpers/dio_test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';
import '../../dummy_data/region_dropdown/mock_city.dart';
import '../../dummy_data/region_dropdown/mock_district.dart';
import '../../dummy_data/region_dropdown/mock_province.dart';
import '../../dummy_data/region_dropdown/mock_subdistrict.dart';

void main() {
  const String any = "any";
  const String path = "${AppConstants.baseUrl}/api/v1/administration";
  late DioAdapter mockDioAdapter;
  late MockDio mockDioClient;
  late RegionDropdownRepo dataSource;

  setUpAll(() async {
    mockDioClient = MockDioHelper.getClient();
    mockDioAdapter = MockDioHelper.getDioAdapter(path, mockDioClient);
    when(mockDioClient.httpClientAdapter)
        .thenAnswer((_) => mockDioClient.httpClientAdapter = mockDioAdapter);
    dataSource = RegionDropdownRepo(dioClient: mockDioClient);
  });

  group('Region Dropdown Api Test (repository)', () {
    group("Get Provinces", () {
      const String diffPath = path+'/provinces';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getProvinces();

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getProvinces();

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<ProvinceModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockProvince.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getProvinces();

          //assert
          expect(call, isA<Future<ProvinceModel?>>());
        },
      );
    });

    group("Get Cities", () {
      const String diffPath = path+'/cities';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getCities(province: any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getCities(province: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<CityModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockCity.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getCities(province: any);

          //assert
          expect(call, isA<Future<CityModel?>>());
        },
      );
    });

    group("Get Districts", () {
      const String diffPath = path+'/districts';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getDistricts(city: any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getDistricts(city: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<DistrictModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockDistrict.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getDistricts(city: any);

          //assert
          expect(call, isA<Future<DistrictModel?>>());
        },
      );
    });

    group("Get Subdistricts", () {
      const String diffPath = path+'/subdistricts';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getSubdistricts(district: any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getSubdistricts(district: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<SubdistrictModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockSubdistrict.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getSubdistricts(district: any);

          //assert
          expect(call, isA<Future<SubdistrictModel?>>());
        },
      );
    });
  });
}
