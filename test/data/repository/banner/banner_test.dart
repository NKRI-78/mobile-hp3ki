import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/banner/banner.dart';
import 'package:hp3ki/data/repository/banner/banner.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:hp3ki/utils/constant.dart';
import '../../../helpers/dio_test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';
import '../../dummy_data/banner/mock_banner.dart';

void main() {
  const String path = "${AppConstants.baseUrl}/api/v1/banner";
  late DioAdapter mockDioAdapter;
  late MockDio mockDioClient;
  late BannerRepo dataSource;

  setUpAll(() async {
    mockDioClient = MockDioHelper.getClient();
    mockDioAdapter = MockDioHelper.getDioAdapter(path, mockDioClient);
    when(mockDioClient.httpClientAdapter)
        .thenAnswer((_) => mockDioClient.httpClientAdapter = mockDioAdapter);
    dataSource = BannerRepo(dioClient: mockDioClient);
  });

  group('Banner Api Test (repository)', () {
    group("Get Banner", () {
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: path);
        when(mockDioClient.get(path)).thenThrow(dioError);

        //act
        final call = dataSource.getBanner();

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: path);
        when(mockDioClient.get(path)).thenThrow(dioError);

        //act
        final call = dataSource.getBanner();

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<BannerModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockBanner.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: path),
            statusCode: 200,
          );
          when(mockDioClient.get(path)).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getBanner();

          //assert
          expect(call, isA<Future<BannerModel?>>());
        },
      );
    });
  });
}
