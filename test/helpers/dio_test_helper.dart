import 'package:hp3ki/utils/constant.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';

import 'test_helper.mocks.dart';

class MockDioHelper {
  static MockDio getClient() {
    MockDio mockDioClient = MockDio();
    when(mockDioClient.options).thenAnswer((_) {
      mockDioClient.options.headers = {
        "Authorization": "Bearer ${AppConstants.tokenDebug}",
      };
      return mockDioClient.options;
    });
    return mockDioClient;
  }

  static DioAdapter getDioAdapter(String baseUrl, MockDio dio) {
    return DioAdapter(
      dio: dio,
      matcher: const FullHttpRequestMatcher(),
    );
  }

  static MockDioError getInternalServerError({required String path}) {
    return MockDioError(
      requestOptions: RequestOptions(path: path),
      response: Response(
        statusCode: 400,
        requestOptions: RequestOptions(path: path),
        data: {
          "message": "Some beautiful error",
        },
      ),
      type: DioErrorType.response,
    );
  }

  static MockDioError getOtherError({required String path}) {
    return MockDioError(
      requestOptions: RequestOptions(path: path),
      type: DioErrorType.other,
    );
  }
}
