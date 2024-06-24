import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/maintenance/demo.dart';
import 'package:hp3ki/data/models/maintenance/maintenance.dart';
import 'package:hp3ki/data/repository/maintenance/maintenance.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:hp3ki/utils/constant.dart';
import '../../../helpers/dio_test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';
import '../../dummy_data/maintenance/mock_demo.dart';
import '../../dummy_data/maintenance/mock_maintenance.dart';

void main() {
  const String path = "${AppConstants.baseUrl}/api/v1/maintenance";
  late DioAdapter mockDioAdapter;
  late MockDio mockDioClient;
  late MaintenanceRepo dataSource;

  setUpAll(() async {
    mockDioClient = MockDioHelper.getClient();
    mockDioAdapter = MockDioHelper.getDioAdapter(path, mockDioClient);
    when(mockDioClient.httpClientAdapter)
        .thenAnswer((_) => mockDioClient.httpClientAdapter = mockDioAdapter);
    dataSource = MaintenanceRepo(dioClient: mockDioClient);
  });

  group('Maintenance Api Test (repository)', () {
    group("Get Maintenance Status", () {
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: path);
        when(mockDioClient.get(path)).thenThrow(dioError);

        //act
        final call = dataSource.getMaintenanceStatus();

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: path);
        when(mockDioClient.get(path)).thenThrow(dioError);

        //act
        final call = dataSource.getMaintenanceStatus();

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<MaintenanceModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockMaintenance.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: path),
            statusCode: 200,
          );
          when(mockDioClient.get(path)).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getMaintenanceStatus();

          //assert
          expect(call, isA<Future<MaintenanceModel?>>());
        },
      );
    });

    group("Get Demo Status", () {
      const String diffPath = path+'/show-demo';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.getDemoStatus();

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.getDemoStatus();

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<DemoModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockDemo.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(diffPath)).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.getDemoStatus();

          //assert
          expect(call, isA<Future<DemoModel?>>());
        },
      );
    });
  });
}
