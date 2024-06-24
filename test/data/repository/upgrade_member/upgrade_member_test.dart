import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/ppob_v2/payment_list.dart';
import 'package:hp3ki/data/models/upgrade_member/inquiry.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:hp3ki/data/repository/upgrade_member/upgrade_member.dart';
import 'package:hp3ki/utils/constant.dart';
import '../../../helpers/dio_test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';
import '../../dummy_data/ppob/mock_payment_list.dart';
import '../../dummy_data/upgrade_member/mock_inquiry.dart';

void main() {
  const String path = "${AppConstants.baseUrl}/api/v1/payment";
  late String mockUID;
  late DioAdapter mockDioAdapter;
  late MockDio mockDioClient;
  late UpgradeMemberRepo dataSource;

  setUpAll(() async {
    mockUID = Helper.createUniqueV4Id();
    mockDioClient = MockDioHelper.getClient();
    mockDioAdapter = MockDioHelper.getDioAdapter(path, mockDioClient);
    when(mockDioClient.httpClientAdapter)
        .thenAnswer((_) => mockDioClient.httpClientAdapter = mockDioAdapter);
    dataSource = UpgradeMemberRepo(dioClient: mockDioClient);
  });

  group('Upgrade Member Api Test (repository)', () {
    group("Get Payment Channel", () {
      const diffPath = '${AppConstants.baseUrlPpob}/payment_v2/pub/v1/payment/channels';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.getPaymentChannel();

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.getPaymentChannel();

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<PaymentListModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockPaymentList.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(diffPath)).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getPaymentChannel();

          //assert
          expect(call, isA<Future<PaymentListModel?>>());
        },
      );
    });

    group("Send Payment Inquiry", () {
      const diffPath = path + '/inquiry';
      const String paymentCode = "999";

      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(
          diffPath,
          data: anyNamed('data'),
        )).thenThrow(dioError);

        //act
        final call = dataSource.sendPaymentInquiry(
            userId: mockUID, paymentCode: paymentCode);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(
          diffPath,
          data: anyNamed('data'),
        )).thenThrow(dioError);

        //act
        final call = dataSource.sendPaymentInquiry(
            userId: mockUID, paymentCode: paymentCode);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<InquiryModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockInquiry.expectedResponseModel;
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
          final call = dataSource.sendPaymentInquiry(
              userId: mockUID, paymentCode: paymentCode);

          //assert
          expect(call, isA<Future<InquiryModel?>>());
        },
      );
    });

    group("Get Payment Callback", () {
      const String amount = "99999";
      late String trxId;
      late String diffPath;

      setUp(() {
        trxId = Helper.createUniqueId().toString();
        diffPath =
            '${AppConstants.baseUrl}/api/v1/callback?trx_id=$trxId&amount=$amount';
      });

      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call =
            dataSource.getPaymentCallback(trxId: trxId, amount: amount);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call =
            dataSource.getPaymentCallback(trxId: trxId, amount: amount);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () {
          //arrange
          final mockResponseData = {
            "status": 200,
            "error": false,
            "message": "Ok"
          };
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(diffPath))
              .thenAnswer((_) async => responseBody);

          //act
          final call =
              dataSource.getPaymentCallback(trxId: trxId, amount: amount);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });
  });
}
