import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/checkin/checkin.dart';
import 'package:hp3ki/data/repository/checkin/checkin.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:hp3ki/utils/constant.dart';
import '../../../helpers/dio_test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';
import '../../dummy_data/checkin/mock_checkin.dart';

void main() {
  const String path = "${AppConstants.baseUrl}/api/v1/checkin";
  const String uid = "42f63b77-2b27-4c77-a2dc-08ef191b4921";
  late DioAdapter mockDioAdapter;
  late MockDio mockDioClient;
  late CheckInRepo dataSource;

  setUpAll(() async {
    mockDioClient = MockDioHelper.getClient();
    mockDioAdapter = MockDioHelper.getDioAdapter(path, mockDioClient);
    when(mockDioClient.httpClientAdapter)
        .thenAnswer((_) => mockDioClient.httpClientAdapter = mockDioAdapter);
    dataSource = CheckInRepo(dioClient: mockDioClient);
  });

  group('Check-In Api Test (repository)', () {
    group("Get Check-In", () {
      const diffPath = path + '/all';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.getCheckIn(uid);

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
        final call = dataSource.getCheckIn(uid);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<CheckInModel> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockCheckIn.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getCheckIn(uid);

          //assert
          expect(call, isA<Future<CheckInModel>>());
        },
      );
    });

    group("Join Check-In", () {
      const checkinId = "607a4292-345d-466e-b9b0-ec37fc9b1046";
      const diffPath = path + '/join';

      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.joinCheckIn(checkinId, uid);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(
          diffPath,
          data: anyNamed('data'),
        )).thenThrow(dioError);

        //act
        final call = dataSource.joinCheckIn(checkinId, uid);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when post process is success',
        () {
          //arrange
          final mockResponseData = MockCheckIn.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(
            diffPath,
            data: anyNamed('data'),
          )).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.joinCheckIn(checkinId, uid);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Create Check-In", () {
      const diffPath = path + '/assign';
      const any = "any";

      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call =
            dataSource.createCheckIn(any, any, any, any, any, any, any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(
          diffPath,
          data: anyNamed('data'),
        )).thenThrow(dioError);

        //act
        final call =
            dataSource.createCheckIn(any, any, any, any, any, any, any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when post process is success',
        () {
          //arrange
          final mockResponseData = MockCheckIn.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(
            diffPath,
            data: anyNamed('data'),
          )).thenAnswer((_) async => responseBody);

          //act
          final call =
              dataSource.createCheckIn(any, any, any, any, any, any, any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });
  });
}
