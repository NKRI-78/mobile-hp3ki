import 'package:dio/dio.dart';
import 'package:hp3ki/data/repository/sos/sos.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:hp3ki/utils/constant.dart';
import '../../../helpers/dio_test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';
import '../../dummy_data/banner/mock_banner.dart';

void main() {
  const String any = "any";
  const String path = "${AppConstants.baseUrl}/api/v1/sos";
  late DioAdapter mockDioAdapter;
  late MockDio mockDioClient;
  late SosRepo dataSource;

  setUpAll(() async {
    mockDioClient = MockDioHelper.getClient();
    mockDioAdapter = MockDioHelper.getDioAdapter(path, mockDioClient);
    when(mockDioClient.httpClientAdapter)
        .thenAnswer((_) => mockDioClient.httpClientAdapter = mockDioAdapter);
    dataSource = SosRepo(dioClient: mockDioClient);
  });

  group('Sos Api Test (repository)', () {
    group("Send SOS", () {
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: path);
        when(mockDioClient.post(path, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.sendSos(type: any, message: any, userId: any, lat: any, lng: any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: path);
        when(mockDioClient.post(path, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.sendSos(type: any, message: any, userId: any, lat: any, lng: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockBanner.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: path),
            statusCode: 200,
          );
          when(mockDioClient.post(path, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.sendSos(type: any, message: any, userId: any, lat: any, lng: any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });
  });
}
