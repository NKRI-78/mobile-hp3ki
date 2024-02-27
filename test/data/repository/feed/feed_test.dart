import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hp3ki/data/models/feed/feeds.dart';
import 'package:hp3ki/data/models/feed/feedsdetail.dart';
import 'package:hp3ki/data/repository/feed/feed.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:hp3ki/utils/constant.dart';
import '../../../helpers/dio_test_helper.dart';
import '../../../helpers/read_file.dart';
import '../../../helpers/test_helper.mocks.dart';
import '../../dummy_data/feeds/mock_feeds.dart';
import '../../dummy_data/feeds/mock_feedsdetail.dart';

void main() {
  const String path = "${AppConstants.baseUrl}/api/v1/forum";
  const String any = "any";
  late File tempFile;
  late DioAdapter mockDioAdapter;
  late MockDio mockDioClient;
  late FeedRepo dataSource;

  setUpAll(() async {
    tempFile = readFile('data/dummy_data/feeds/mock_feeds.dart');
    mockDioClient = MockDioHelper.getClient();
    mockDioAdapter = MockDioHelper.getDioAdapter(path, mockDioClient);
    when(mockDioClient.httpClientAdapter)
        .thenAnswer((_) => mockDioClient.httpClientAdapter = mockDioAdapter);
    dataSource = FeedRepo(dioClient: mockDioClient);
  });

  group('Feed Api Test (repository)', () {
    group("Delete Comment", () {
      const diffPath = path + "/comment/delete/any";
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.deleteComment(any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.deleteComment(any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(diffPath))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.deleteComment(any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Like Comment", () {
      const diffPath = path + '/comment/like';

      test('Should throw internal server error when post process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.likeComment(any, any, any);

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
        final call = dataSource.likeComment(any, any, any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when post process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
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
          final call = dataSource.likeComment(any, any, any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Delete Reply", () {
      const diffPath = path + "/reply/delete/any";
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.deleteReply(any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.get(diffPath)).thenThrow(dioError);

        //act
        final call = dataSource.deleteReply(any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(diffPath))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.deleteReply(any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Send Reply", () {
      const diffPath = path + "/reply";
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.sendReply(any, any, any, any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.sendReply(any, any, any, any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.sendReply(any, any, any, any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Like Forum", () {
      const diffPath = path + "/like";
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.likeForum(any, any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.likeForum(any, any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.likeForum(any, any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Delete Forum", () {
      const diffPath = path + "/delete/any";
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(
          diffPath,
        )).thenThrow(dioError);

        //act
        final call = dataSource.deleteForum(any);

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
        final call = dataSource.deleteForum(any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(
            diffPath,
          )).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.deleteForum(any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Fetch Forum Detail", () {
      const diffPath = path + "/any?comment_page=1";
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(
          diffPath,
        )).thenThrow(dioError);

        //act
        final call = dataSource.fetchForumDetail(any);

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
        final call = dataSource.fetchForumDetail(any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<ForumDetail?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeedDetail.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(
            diffPath,
          )).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.fetchForumDetail(any);

          //assert
          expect(call, isA<Future<ForumDetail?>>());
        },
      );
    });

    group("Fetch More Comment", () {
      const page = 1;
      const diffPath = path + "/any?comment_page=1";
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(
          diffPath,
        )).thenThrow(dioError);

        //act
        final call = dataSource.fetchMoreComment(any, page);

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
        final call = dataSource.fetchMoreComment(any, page);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<ForumDetail?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeedDetail.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(
            diffPath,
          )).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.fetchMoreComment(any, page);

          //assert
          expect(call, isA<Future<ForumDetail?>>());
        },
      );
    });

    group("Fetch Most Recent Feeds", () {
      const page = 1;
      const diffPath =
          path + "?search=&page=$page&limit=5&forum_highlight_type=MOST_RECENT";
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(
          diffPath,
        )).thenThrow(dioError);

        //act
        final call = dataSource.fetchFeedMostRecent(page);

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
        final call = dataSource.fetchFeedMostRecent(page);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<FeedModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(
            diffPath,
          )).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.fetchFeedMostRecent(page);

          //assert
          expect(call, isA<Future<FeedModel?>>());
        },
      );
    });

    group("Fetch Most Popular Feeds", () {
      const page = 1;
      const diffPath = path +
          "?search=&page=$page&limit=5&forum_highlight_type=MOST_POPULAR";
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.get(
          diffPath,
        )).thenThrow(dioError);

        //act
        final call = dataSource.fetchFeedMostPopular(page);

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
        final call = dataSource.fetchFeedMostPopular(page);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<FeedModel?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.get(
            diffPath,
          )).thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.fetchFeedMostPopular(page);

          //assert
          expect(call, isA<Future<FeedModel?>>());
        },
      );
    });

    group("Upload Feed Media", () {
      const diffPath = AppConstants.baseUrl + "/api/v1/media";
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.uploadMedia(any, tempFile);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.uploadMedia(any, tempFile);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<Response?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.uploadMedia(any, tempFile);

          //assert
          expect(call, isA<Future<Response?>>());
        },
      );
    });

    group("Upload Feed Media Filepicker", () {
      late FilePickerResult file;
      const diffPath = AppConstants.baseUrl + "/api/v1/media";

      setUp(() async {
        PlatformFile platformFile = PlatformFile(name: 'mock_feeds.dart', size: tempFile.lengthSync(), path: tempFile.path);
        file = FilePickerResult([platformFile]);   
      });

      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.uploadMediaFilePicker(any, file);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.uploadMediaFilePicker(any, file);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<Response?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.uploadMediaFilePicker(any, file);

          //assert
          expect(call, isA<Future<Response?>>());
        },
      );
    });

    group("Create Forum Media", () {
      const diffPath = path + "/media";
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.createForumMedia(any, any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.createForumMedia(any, any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.createForumMedia(any, any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Send Post Text", () {
      const diffPath = path;
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.sendPostText(any, any, any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.sendPostText(any, any, any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<Response?> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.sendPostText(any, any, any);

          //assert
          expect(call, isA<Future<Response?>>());
        },
      );
    });

    group("Send Post Link", () {
      const diffPath = path;
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.sendPostLink(any, any, any, any);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.sendPostLink(any, any, any, any);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.sendPostLink(any, any, any, any);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Send Post Doc", () {
      const diffPath = path;
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.sendPostDoc(any, any, any,);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.sendPostDoc(any, any, any,);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.sendPostDoc(any, any, any,);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Send Post Image", () {
      const diffPath = path;
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.sendPostImage(any, any, any,);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.sendPostImage(any, any, any,);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.sendPostImage(any, any, any,);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Send Post Image Camera", () {
      const diffPath = path;
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.sendPostImageCamera(any, any, any,);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.sendPostImageCamera(any, any, any,);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.sendPostImageCamera(any, any, any,);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Send Post Video", () {
      const diffPath = path;
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.sendPostVideo(any, any, any,);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.sendPostVideo(any, any, any,);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.sendPostVideo(any, any, any,);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });

    group("Send Comment", () {
      const diffPath = path+'/comment';
      test('Should throw internal server error when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getInternalServerError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.sendComment(any, any, any,);

        //assert
        expect(call, throwsException);
      });

      test('Should throw DioErrorType.other when fetch process is failed',
          () async {
        //arrange
        final dioError = MockDioHelper.getOtherError(path: diffPath);
        when(mockDioClient.post(diffPath, data: anyNamed('data')))
            .thenThrow(dioError);

        //act
        final call = dataSource.sendComment(any, any, any,);

        //assert
        expect(call, throwsException);
      });

      test(
        'Should returns a Future<void> when fetch process is success',
        () {
          //arrange
          final mockResponseData = MockFeed.expectedResponseModel;
          final responseBody = Response(
            data: mockResponseData,
            requestOptions: RequestOptions(path: diffPath),
            statusCode: 200,
          );
          when(mockDioClient.post(diffPath, data: anyNamed('data')))
              .thenAnswer((_) async => responseBody);

          //act
          final call = dataSource.sendComment(any, any, any,);

          //assert
          expect(call, isA<Future<void>>());
        },
      );
    });
  });
}
