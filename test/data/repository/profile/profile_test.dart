import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/enterpreneurs_additional_data/business.dart';
import 'package:hp3ki/data/models/enterpreneurs_additional_data/classifications.dart';
import 'package:hp3ki/data/models/user/user.dart';
import 'package:hp3ki/data/repository/profile/profile.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:hp3ki/utils/constant.dart';
import '../../../helpers/dio_test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';
import '../../dummy_data/enterpreneurs_additional_data/mock_business.dart';
import '../../dummy_data/enterpreneurs_additional_data/mock_classifications.dart';
import '../../dummy_data/user/mock_user.dart';

void main() {
  const String any = "any";
  const Object anyObj = { "any": any, };
  const String path = "${AppConstants.baseUrl}/user-service/profile";
  late DioAdapter mockDioAdapter;
  late MockDio mockDioClient;
  late ProfileRepo dataSource;

  setUpAll(() async {
    mockDioClient = MockDioHelper.getClient();
    mockDioAdapter = MockDioHelper.getDioAdapter(path, mockDioClient);
    when(mockDioClient.httpClientAdapter)
        .thenAnswer((_) => mockDioClient.httpClientAdapter = mockDioAdapter);
    dataSource = ProfileRepo(dioClient: mockDioClient);
  });

  group('Profile Api Test (repository)', () {
    group("Get Profile", () {
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: path);
        when(mockDioClient.post(path, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getProfile(any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: path);
        when(mockDioClient.post(path, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getProfile(any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<UserModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockUser.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: path),
            statusCode: 200,
          );
          when(mockDioClient.post(path, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getProfile(any);

          //assert
          expect(call, isA<Future<UserModel?>>());
        },
      );
    });

    group("Get Business List", () {
      const String diffPath = AppConstants.baseUrl+'/api/v1/form/business';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.getBusinessList();

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.getBusinessList();

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<BusinessModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockBusiness.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(diffPath)).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getBusinessList();

          //assert
          expect(call, isA<Future<BusinessModel?>>());
        },
      );
    });

    group("Get Classification List", () {
      const String diffPath = AppConstants.baseUrl+'/api/v1/form/classification';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.getClassificationList();

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.getClassificationList();

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<ClassificationModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockClassification.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(diffPath)).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getClassificationList();

          //assert
          expect(call, isA<Future<ClassificationModel?>>());
        },
      );
    });

    group("Get Classification List", () {
      const String diffPath = AppConstants.baseUrl+'/api/v1/form/classification';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.getClassificationList();

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.getClassificationList();

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<ClassificationModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockClassification.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(diffPath)).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getClassificationList();

          //assert
          expect(call, isA<Future<ClassificationModel?>>());
        },
      );
    });

    group("Fulfill Job Data", () {
      const String diffPath = AppConstants.baseUrl+'/api/v1/organization/data-$any';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.fulfillJobData(anyObj, any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.fulfillJobData(anyObj, any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () async {
          //arrange
          final mockResponseData = MockClassification.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.fulfillJobData(anyObj, any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Update Profile", () {
      const String diffPath = path+'/update';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.updateProfile(data: anyObj);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.updateProfile(data: anyObj);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () async {
          //arrange
          final mockResponseData = MockClassification.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.updateProfile(data: anyObj);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Update Profile Picture", () {
      const String diffPath = path+'/update';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.updateProfilePicture(pfpPath: any, userId: any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.updateProfilePicture(pfpPath: any, userId: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () async {
          //arrange
          final mockResponseData = MockClassification.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.updateProfilePicture(pfpPath: any, userId: any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Update Profile Name or Address", () {
      const String diffPath = path+'/update';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.updateProfileNameOrAddress(name: any, address: any, userId: any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.updateProfileNameOrAddress(name: any, address: any, userId: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () async {
          //arrange
          final mockResponseData = MockClassification.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.updateProfileNameOrAddress(name: any, address: any, userId: any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });
  });
}
