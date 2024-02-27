import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/news/news.dart';
import 'package:hp3ki/data/models/news/single_news.dart';
import 'package:hp3ki/data/repository/news/news.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:hp3ki/utils/constant.dart';
import '../../../helpers/dio_test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';
import '../../dummy_data/news/mock_news.dart';
import '../../dummy_data/news/mock_single_news.dart';

void main() {
  const String any = "any";
  const String path = "${AppConstants.baseUrl}/api/v1/news";
  late DioAdapter mockDioAdapter;
  late MockDio mockDioClient;
  late NewsRepo dataSource;

  setUpAll(() async {
    mockDioClient = MockDioHelper.getClient();
    mockDioAdapter = MockDioHelper.getDioAdapter(path, mockDioClient);
    when(mockDioClient.httpClientAdapter)
        .thenAnswer((_) => mockDioClient.httpClientAdapter = mockDioAdapter);
    dataSource = NewsRepo(dioClient: mockDioClient);
  });

  group('News Api Test (repository)', () {
    group("Get News", () {
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: path);
        when(mockDioClient.get(path)).thenThrow(dioError);

        //act
        final call = dataSource.getNews();

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: path);
        when(mockDioClient.get(path)).thenThrow(dioError);

        //act
        final call = dataSource.getNews();

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<NewsModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockNews.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: path),
            statusCode: 200,
          );
          when(mockDioClient.get(path)).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getNews();

          //assert
          expect(call, isA<Future<NewsModel?>>());
        },
      );
    });

    group("Get News Detail", () {
      const String diffPath = path+'/detail';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getNewsDetail(newsId: any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getNewsDetail(newsId: any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<SingleNewsModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockSingleNews.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getNewsDetail(newsId: any);

          //assert
          expect(call, isA<Future<SingleNewsModel?>>());
        },
      );
    });
  });
}
