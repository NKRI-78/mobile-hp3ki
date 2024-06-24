import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/ppob_v2/denom_pulsa.dart';
import 'package:hp3ki/data/models/ppob_v2/payment_guide.dart';
import 'package:hp3ki/data/models/ppob_v2/payment_list.dart';
import 'package:hp3ki/data/models/ppob_v2/pln/inquiry_pra.dart';
import 'package:hp3ki/data/models/ppob_v2/pln/list_price_pra.dart';
import 'package:hp3ki/data/models/ppob_v2/wallet_balance.dart';
import 'package:hp3ki/data/models/ppob_v2/wallet_denom.dart';
import 'package:hp3ki/data/repository/ppob_v2/ppob_v2.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:hp3ki/utils/constant.dart';
import '../../../helpers/dio_test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';
import '../../dummy_data/ppob/mock_denom_pulsa.dart';
import '../../dummy_data/ppob/mock_payment_guide.dart';
import '../../dummy_data/ppob/mock_wallet_balance.dart';
import '../../dummy_data/ppob/mock_wallet_denom.dart';
import '../../dummy_data/ppob/pln/mock_inquiry_pra.dart';
import '../../dummy_data/ppob/pln/mock_list_price_pra.dart';
import '../../dummy_data/upgrade_member/mock_payment_channel.dart';

void main() {
  const String path = AppConstants.baseUrlPpob;
  const String any = "any";
  late DioAdapter mockDioAdapter;
  late MockDio mockDioClient;
  late PPOBRepo dataSource;

  setUpAll(() async {
    mockDioClient = MockDioHelper.getClient();
    mockDioAdapter = MockDioHelper.getDioAdapter(path, mockDioClient);
    when(mockDioClient.httpClientAdapter)
        .thenAnswer((_) => mockDioClient.httpClientAdapter = mockDioAdapter);
    dataSource = PPOBRepo(dioClient: mockDioClient);
  });

  group('PPOB Api Test (repository)', () {
    group("Get Wallet Denom", () {
      const diffPath = path + '/get/denom';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.getWalletDenom();

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.getWalletDenom();

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<WalletDenomModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockWalletDenom.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(diffPath))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getWalletDenom();

          //assert
          expect(call, isA<Future<WalletDenomModel?>>());
        },
      );
    });

    group("Get Wallet Balance", () {
      const diffPath = path + '/get/balance';
      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getWalletBalance(userId: any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getWalletBalance(userId: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<WalletBalanceModel?> when post process is success',
        () {
          //arrange
          final mockResponseData = MockWalletBalance.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getWalletBalance(userId: any);

          //assert
          expect(call, isA<Future<WalletBalanceModel?>>());
        },
      );
    });

    group("Inquiry TopUp Balance", () {
      const diffPath = path + '/inquiry/topup/balance';
      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.inquiryTopUpBalance(
          productId: any,
          channel: any,
          email: any,
          phone: any,
          userId: any,
        );

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
        final call = dataSource.inquiryTopUpBalance(
          productId: any,
          channel: any,
          email: any,
          phone: any,
          userId: any,
        );

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when post process is success',
        () {
          //arrange
          final mockResponseData = MockWalletBalance.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.inquiryTopUpBalance(
            productId: any,
            channel: any,
            email: any,
            phone: any,
            userId: any,
          );

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Get Payment List", () {
      const diffPath = path + '/payment_v2/pub/v1/payment/channels';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(
          diffPath,
        )).thenThrow(dioError);

        //act
        final call = dataSource.getPaymentList();

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.get(
          diffPath,
        )).thenThrow(dioError);

        //act
        final call = dataSource.getPaymentList();

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<PaymentListModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockPaymentChannel.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(
            diffPath,
          )).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getPaymentList();

          //assert
          expect(call, isA<Future<PaymentListModel?>>());
        },
      );
    });

    group("Init Payment Gateway FCM", () {
      const diffPath = path + '/fcm';
      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(
          diffPath,
          data: anyNamed('data')
        )).thenThrow(dioError);

        //act
        final call = dataSource.initPaymentGatewayFCM(token: any, userId: any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(
          diffPath,
          data: anyNamed('data')
        )).thenThrow(dioError);

        //act
        final call = dataSource.initPaymentGatewayFCM(token: any, userId: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when post process is success',
        () {
          //arrange
          final mockResponseData = MockPaymentChannel.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(
            diffPath,
            data: anyNamed('data')
          )).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.initPaymentGatewayFCM(token: any, userId: any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Get Denom Pulsa", () {
      const diffPath = path + '/inquiry/pulsa?prefix=$any&type=$any';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(
          diffPath,
        )).thenThrow(dioError);

        //act
        final call = dataSource.getDenomPulsa(prefix: any, type: any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.get(
          diffPath,
        )).thenThrow(dioError);

        //act
        final call = dataSource.getDenomPulsa(prefix: any, type: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<DenomPulsaModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockDenomPulsa.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(
            diffPath,
          )).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getDenomPulsa(prefix: any, type: any);

          //assert
          expect(call, isA<Future<DenomPulsaModel?>>());
        },
      );
    });

    group("Post Inquiry PLN Prabayar", () {
      const diffPath = path + '/inquiry/pln-prabayar';
      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(
          diffPath,
          data: anyNamed('data')
        )).thenThrow(dioError);

        //act
        final call = dataSource.postInquiryPLNPrabayar(idPel: any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(
          diffPath,
          data: anyNamed('data')
        )).thenThrow(dioError);

        //act
        final call = dataSource.postInquiryPLNPrabayar(idPel: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<InquiryPLNPrabayarModel?> when post process is success',
        () {
          //arrange
          final mockResponseData = MockInquiryPLNPraBayar.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(
            diffPath,
            data: anyNamed('data')
          )).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.postInquiryPLNPrabayar(idPel: any);

          //assert
          expect(call, isA<Future<InquiryPLNPrabayarModel?>>());
        },
      );
    });

    group("Pay PLN Prabayar", () {
      const diffPath = path + '/pay/pln-prabayar';
      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(
          diffPath,
          data: anyNamed('data')
        )).thenThrow(dioError);

        //act
        final call = dataSource.payPLNPrabayar(idPel: any, refTwo: any, nominal: any, userId: any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(
          diffPath,
          data: anyNamed('data')
        )).thenThrow(dioError);

        //act
        final call = dataSource.payPLNPrabayar(idPel: any, refTwo: any, nominal: any, userId: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when post process is success',
        () {
          //arrange
          final mockResponseData = MockInquiryPLNPraBayar.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(
            diffPath,
            data: anyNamed('data')
          )).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.payPLNPrabayar(idPel: any, refTwo: any, nominal: any, userId: any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Pay Pulsa", () {
      const diffPath = path + '/pay/pulsa';
      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(
          diffPath,
          data: anyNamed('data')
        )).thenThrow(dioError);

        //act
        final call = dataSource.payPulsa(productCode: any, phone: any, userId: any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(
          diffPath,
          data: anyNamed('data')
        )).thenThrow(dioError);

        //act
        final call = dataSource.payPulsa(productCode: any, phone: any, userId: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when post process is success',
        () {
          //arrange
          final mockResponseData = MockInquiryPLNPraBayar.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(
            diffPath,
            data: anyNamed('data')
          )).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.payPulsa(productCode: any, phone: any, userId: any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Get List PLN Prabayar", () {
      const diffPath = path + '/price/list-pln-prabayar';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(
          diffPath,
        )).thenThrow(dioError);

        //act
        final call = dataSource.getListPricePLNPrabayar();

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.get(
          diffPath,
        )).thenThrow(dioError);

        //act
        final call = dataSource.getListPricePLNPrabayar();

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<ListPricePraBayarModel> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockListPricePraBayar.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(
            diffPath,
          )).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getListPricePLNPrabayar();

          //assert
          expect(call, isA<Future<ListPricePraBayarModel>>());
        },
      );
    });

    group("Create Wallet Data", () {
      const diffPath = path + '/create/wallet';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(
          diffPath,
          data: anyNamed('data')
        )).thenThrow(dioError);

        //act
        final call = dataSource.createWalletData(userId: any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(
          diffPath,
          data: anyNamed('data')
        )).thenThrow(dioError);

        //act
        final call = dataSource.createWalletData(userId: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockListPricePraBayar.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(
            diffPath,
            data: anyNamed('data')
          )).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.createWalletData(userId: any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Get Payment Guide", () {
      const diffPath = AppConstants.baseUrlHelpPayment + '/$any';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get( diffPath, )).thenThrow(dioError);

        //act
        final call = dataSource.getPaymentGuide(url: diffPath);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.get( diffPath, )).thenThrow(dioError);

        //act
        final call = dataSource.getPaymentGuide(url: diffPath);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<PaymentGuideModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockPaymentGuide.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get( diffPath, )).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getPaymentGuide(url: diffPath);

          //assert
          expect(call, isA<Future<PaymentGuideModel?>>());
        },
      );
    });
  });
}
