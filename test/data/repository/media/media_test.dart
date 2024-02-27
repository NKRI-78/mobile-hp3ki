import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/media/media.dart';
import 'package:hp3ki/data/repository/media/media.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:hp3ki/utils/constant.dart';
import '../../../helpers/dio_test_helper.dart';
import '../../../helpers/read_file.dart';
import '../../../helpers/test_helper.mocks.dart';
import '../../dummy_data/media/mock_media.dart';

void main() {
  late File file;
  const String any = "any";
  const String path = "${AppConstants.baseUrl}/api/v1/media";
  late DioAdapter mockDioAdapter;
  late MockDio mockDioClient;
  late MediaRepo dataSource;

  setUpAll(() async {
    file = readFile('data/dummy_data/media/mock_media.dart');
    mockDioClient = MockDioHelper.getClient();
    mockDioAdapter = MockDioHelper.getDioAdapter(path, mockDioClient);
    when(mockDioClient.httpClientAdapter)
        .thenAnswer((_) => mockDioClient.httpClientAdapter = mockDioAdapter);
    dataSource = MediaRepo(dioClient: mockDioClient);
  });

  group('Media Api Test (repository)', () {
    group("Get Media Status", () {
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: path);
        when(mockDioClient.post(path, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getMediaPath(any, file);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: path);
        when(mockDioClient.post(path, data: anyNamed('data'))).thenThrow(dioError);

        //act
        final call = dataSource.getMediaPath(any, file);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<MediaModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockMedia.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: path),
            statusCode: 200,
          );
          when(mockDioClient.post(path, data: anyNamed('data'))).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getMediaPath(any, file);

          //assert
          expect(call, isA<Future<MediaModel?>>());
        },
      );
    });
  });
}
