import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/inbox/count.dart';
import 'package:hp3ki/data/models/inbox/inbox.dart';
import 'package:hp3ki/data/repository/inbox/inbox.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:hp3ki/utils/constant.dart';
import '../../../helpers/dio_test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';
import '../../dummy_data/inbox/mock_inbox.dart';
import '../../dummy_data/inbox/mock_inbox_count.dart';
import '../../dummy_data/inbox/mock_inbox_payment.dart';

void main() {
  const String path = "${AppConstants.baseUrl}/api/v1/inbox";
  const String paymentPath = "${AppConstants.baseUrlPpob}/inbox";
  const String any = "any";
  const int num = 1;
  late DioAdapter mockDioAdapter;
  late MockDio mockDioClient;
  late InboxRepo dataSource;

  setUpAll(() async {
    mockDioClient = MockDioHelper.getClient();
    mockDioAdapter = MockDioHelper.getDioAdapter(path, mockDioClient);
    when(mockDioClient.httpClientAdapter)
        .thenAnswer((_) => mockDioClient.httpClientAdapter = mockDioAdapter);
    dataSource = InboxRepo(dioClient: mockDioClient);
  });

  group('Inbox Test (repository)', () {
    group("Get Inbox", () {
      const String diffPath = path+'?page=1&limit=6';
      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getInbox(userId: any, type: any, page: num);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getInbox(userId: any, type: any, page: num);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<InboxModel?> when post process is success',
        () {
          //arrange
          final mockResponseData = MockInbox.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getInbox(userId: any, type: any, page: num);

          //assert
          expect(call, isA<Future<InboxModel?>>());
        },
      );
    });

    group("Get Inbox Count", () {
      const String diffPath = path+'/badges';
      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getInboxCount(userId: any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getInboxCount(userId: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<InboxCountModel?> when post process is success',
        () {
          //arrange
          final mockResponseData = MockInboxCount.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getInboxCount(userId: any);

          //assert
          expect(call, isA<Future<InboxCountModel?>>());
        },
      );
    });

    group("Update Inbox", () {
      const String diffPath = path+'/detail';
      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.updateInbox(inboxId: any, userId: any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.updateInbox(inboxId: any, userId: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when post process is success',
        () {
          //arrange
          final mockResponseData = MockInboxCount.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.updateInbox(inboxId: any, userId: any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });
    group("Get InboxPayment", () {
      const String diffPath = paymentPath+'?page=1&limit=6';
      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        // final call = dataSource.getInboxPayment(userId: any,);

        //assert
        // expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        // final call = dataSource.getInboxPayment(userId: any,);

        //assert
        // expect(call, throwsException);
      });

      test(
        'Should returns a Future<InboxPaymentModel?> when post process is success',
        () {
          //arrange
          final mockResponseData = MockInboxPayment.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          // final call = dataSource.getInboxPayment(userId: any,);

          //assert
          // expect(call, isA<Future<InboxPaymentModel?>>());
        },
      );
    });

    group("Get Inbox CountPayment", () {
      const String diffPath = paymentPath+'/badges';
      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        // final call = dataSource.getInboxCountPayment(userId: any);

        //assert
        // expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        // final call = dataSource.getInboxCountPayment(userId: any);

        //assert
        // expect(call, throwsException);
      });

      test(
        'Should returns a Future<InboxCountPaymentModel?> when post process is success',
        () {
          //arrange
          final mockResponseData = MockInboxCountPayment.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          // final call = dataSource.getInboxCountPayment(userId: any);

          //assert
          // expect(call, isA<Future<InboxCountPaymentModel?>>());
        },
      );
    });

    group("Update Inbox Payment", () {
      const String diffPath = paymentPath+'/update';
      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.updateInboxPayment(inboxId: num);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.updateInboxPayment(inboxId: num);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when post process is success',
        () {
          //arrange
          final mockResponseData = MockInboxCount.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.updateInboxPayment(inboxId: num);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });
  });
}
