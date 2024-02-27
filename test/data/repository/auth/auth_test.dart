import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/auth/auth.dart';
import 'package:hp3ki/data/models/job/job.dart';
import 'package:hp3ki/data/models/organization/organization.dart';
import 'package:hp3ki/data/repository/auth/auth.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:hp3ki/utils/constant.dart';
import '../../../helpers/dio_test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';
import '../../dummy_data/auth/mock_auth.dart';
import '../../dummy_data/job/mock_job.dart';
import '../../dummy_data/organization/mock_organization.dart';

void main() {
  const String path = "${AppConstants.baseUrl}/api/v1";
  late DioAdapter mockDioAdapter;
  late MockDio mockDioClient;
  late AuthRepo dataSource;

  setUpAll(() async {
    mockDioClient = MockDioHelper.getClient();
    mockDioAdapter = MockDioHelper.getDioAdapter(path, mockDioClient);
    when(mockDioClient.httpClientAdapter)
        .thenAnswer((_) => mockDioClient.httpClientAdapter = mockDioAdapter);
    dataSource = AuthRepo(dioClient: mockDioClient);
  });

  group('Auth Api Test (repository)', () {
    group("Get Jobs", () {
      const diffPath = path + '/job';

      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.getJobs();

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: path);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.getJobs();

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<JobModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockJob.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(diffPath))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getJobs();

          //assert
          expect(call, isA<Future<JobModel?>>());
        },
      );
    });

    group("Get Organizations", () {
      const diffPath = path + '/organization';

      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.getOrganizations();

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.getOrganizations();

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<OrganizationModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockOrganization.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(diffPath))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getOrganizations();

          //assert
          expect(call, isA<Future<OrganizationModel?>>());
        },
      );
    });

    group("Login", () {
      const diffPath = path + '/auth/login';
      const email = "test@mail.com";
      const password = "12345678";

      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: path);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.login(email, password);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.login(email, password);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<AuthModel> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockAuth.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.login(email, password);

          //assert
          expect(call, isA<Future<AuthModel>>());
        },
      );
    });

    group("Login", () {
      const diffPath = path + '/auth/login';
      const email = "test@mail.com";
      const password = "12345678";

      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: path);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.login(email, password);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.login(email, password);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<AuthModel> when post process is success',
        () {
          //arrange
          final mockResponseData = MockAuth.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.login(email, password);

          //assert
          expect(call, isA<Future<AuthModel>>());
        },
      );
    });

    group("Register", () {
      const diffPath = path + '/auth/register';
      const data = {
        "any": "any",
      };
      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: path);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.register(data);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.register(data);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<AuthModel> when post process is success',
        () {
          //arrange
          final mockResponseData = MockAuth.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.register(data);

          //assert
          expect(call, isA<Future<AuthModel>>());
        },
      );
    });

    group("Change Password", () {
      const diffPath = path + '/auth/change-password';
      const email = "test@mail.com";
      const oldPass = "12345678";
      const newPass = "87654321";
      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: path);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.changePassword(email, oldPass, newPass);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.changePassword(email, oldPass, newPass);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when post process is success',
        () {
          //arrange
          final mockResponseData = MockAuth.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.changePassword(email, oldPass, newPass);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Set New Password", () {
      const diffPath = path + '/auth/change-password';
      const email = "test@mail.com";
      const oldPass = "12345678";
      const newPass = "87654321";
      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: path);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.setNewPassword(email, oldPass, newPass);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.setNewPassword(email, oldPass, newPass);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when post process is success',
        () {
          //arrange
          final mockResponseData = MockAuth.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.setNewPassword(email, oldPass, newPass);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Forget Password", () {
      const diffPath = path + '/auth/forgot-password';
      const email = "test@mail.com";

      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: path);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.forgetPassword(email);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.forgetPassword(email);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when post process is success',
        () {
          //arrange
          final mockResponseData = MockAuth.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.forgetPassword(email);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Apply Change Email OTP", () {
      const diffPath = path + '/auth/update-email';
      const oldEmail = "test@mail.com";
      const newEmail = "model@mail.com";

      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: path);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.applyChangeEmailOtp(oldEmail, newEmail);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.applyChangeEmailOtp(oldEmail, newEmail);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when post process is success',
        () {
          //arrange
          final mockResponseData = MockAuth.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.applyChangeEmailOtp(oldEmail, newEmail);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Verify OTP", () {
      const diffPath = path + '/auth/verify-otp';
      const email = "test@mail.com";
      const otp = "1234";

      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: path);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.verifyOtp(email, otp);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.verifyOtp(email, otp);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when post process is success',
        () {
          //arrange
          final mockResponseData = MockAuth.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.verifyOtp(email, otp);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Resend OTP", () {
      const diffPath = path + '/auth/resend-otp';
      const email = "test@mail.com";

      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: path);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.resendOtp(email);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.resendOtp(email);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when post process is success',
        () {
          //arrange
          final mockResponseData = MockAuth.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.resendOtp(email);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Login Social Media", () {
      const diffPath = path + '/auth/social-media';
      const email = "test@mail.com";
      const name = "Test";

      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: path);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.loginSocialMedia(email: email, name: name);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.loginSocialMedia(email: email, name: name);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when post process is success',
        () {
          //arrange
          final mockResponseData = MockAuth.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.loginSocialMedia(email: email, name: name);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });
  });
}
