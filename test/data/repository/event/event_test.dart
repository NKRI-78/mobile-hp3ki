import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/event/event.dart';
import 'package:hp3ki/data/repository/event/event.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:hp3ki/utils/constant.dart';
import '../../../helpers/dio_test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';
import '../../dummy_data/event/mock_event.dart';

void main() {
  const String path = "${AppConstants.baseUrl}/api/v1/event";
  const String any = "any";
  late DioAdapter mockDioAdapter;
  late MockDio mockDioClient;
  late EventRepo dataSource;

  setUpAll(() async {
    mockDioClient = MockDioHelper.getClient();
    mockDioAdapter = MockDioHelper.getDioAdapter(path, mockDioClient);
    when(mockDioClient.httpClientAdapter)
        .thenAnswer((_) => mockDioClient.httpClientAdapter = mockDioAdapter);
    dataSource = EventRepo(dioClient: mockDioClient);
  });

  group('Event Api Test (repository)', () {
    group("Get Event", () {
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: path);
        when(mockDioClient.post(path, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.getEvent(userId: any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: path);
        when(mockDioClient.post(path, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.getEvent(userId: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<List<EventData>?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockEvent.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: path),
            statusCode: 200,
          );
          when(mockDioClient.post(path, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getEvent(userId: any);

          //assert
          expect(call, isA<Future<List<EventData>?>>());
        },
      );
    });

    group("Join Event", () {
      const diffPath = path + '/join';

      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.joinEvent(eventId: any, userId: any);

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
        final call = dataSource.joinEvent(eventId: any, userId: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when post process is success',
        () {
          //arrange
          final mockResponseData = MockEvent.expectedResponseModel;
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
          final call = dataSource.joinEvent(eventId: any, userId: any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });
  });
}
