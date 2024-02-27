import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hp3ki/data/models/feed/feedsdetail.dart';
import 'package:hp3ki/data/models/feed/feeds.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';

class FeedRepo {
  Dio? dioClient;

  FeedRepo({required this.dioClient}) {
    dioClient ??=  DioManager.shared.getClient();
  }

  Future<void> deleteComment(String commentId) async {
    try {
      await dioClient!.get("${AppConstants.baseUrlFeed}/api/v1/forum/comment/delete/$commentId");
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> likeComment(String forumId, String commentId, String userId) async {
    try {
      await dioClient!.post("${AppConstants.baseUrlFeed}/api/v1/forum/comment/like",
        data: {
          "forum_id": forumId,
          "comment_id": commentId,
          "user_id": userId,
        }
      );
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> deleteReply(String replyId) async {
    try {
      await dioClient!.get("${AppConstants.baseUrlFeed}/api/v1/forum/reply/delete/$replyId");
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> sendReply(String forumId, String commentId, String userId, String reply) async {
    try {
      await dioClient!.post("${AppConstants.baseUrlFeed}/api/v1/forum/reply",
        data: {
          "forum_id": forumId,
          "comment_id": commentId,
          "user_id": userId,
          "reply": reply
        }
      );
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> likeForum(String forumId, String userId) async {
    try {
      await dioClient!.post("${AppConstants.baseUrlFeed}/api/v1/forum/like",
        data: {
          "forum_id": forumId,
          "user_id": userId,
        }
      );
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> deleteForum(String forumId) async {
    try {
      await dioClient!.get("${AppConstants.baseUrlFeed}/api/v1/forum/delete/$forumId");
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<ForumDetail?> fetchForumDetail(String targetId) async {
    try { 
      Response res = await dioClient!.get("${AppConstants.baseUrlFeed}/api/v1/forum/$targetId?comment_page=1");
      ForumDetail data = ForumDetail.fromJson(res.data);
      return data;
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  }

  Future<ForumDetail?> fetchMoreComment(String targetId, int page) async {
    try { 
      Response res = await dioClient!.get("${AppConstants.baseUrlFeed}/api/v1/forum/$targetId?comment_page=$page");
      ForumDetail data = ForumDetail.fromJson(res.data);
      return data;
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<FeedModel?> fetchFeedMostRecent(int page) async {
    try { 
      Response res = await dioClient!.get("${AppConstants.baseUrlFeed}/api/v1/forum?search=&page=$page&limit=5&forum_highlight_type=MOST_RECENT");
      FeedModel data = FeedModel.fromJson(res.data);   
      return data;
    } on DioError catch(e) {   
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  }

  Future<FeedModel?> fetchFeedMostPopular(int page) async {
    try {
      Response res = await dioClient!.get("${AppConstants.baseUrlFeed}/api/v1/forum?search=&page=$page&limit=5&forum_highlight_type=MOST_POPULAR");
      FeedModel data = FeedModel.fromJson(res.data);   
      return data;
    } on DioError catch(e) {   
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<FeedModel?> fetchFeedSelf(int page, String userId) async {
    try {
      Response res = await dioClient!.get("${AppConstants.baseUrlFeed}/api/v1/forum?search=&page=$page&limit=5&forum_highlight_type=SELF");
      FeedModel data = FeedModel.fromJson(res.data);   
      return data;
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<Response?> uploadMedia(String mediaType, File file) async {
    try {
      String fileName = file.path.split('/').last;
      var formData = FormData.fromMap({
        "folder": mediaType,
        "media": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });
      Response res = await dioClient!.post("${AppConstants.baseUrlFeed}/api/v1/media", 
        data: formData,
      );
      return res;
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<Response?> uploadMediaFilePicker(String mediaType, FilePickerResult file) async {
    try {
      String fileName = file.paths.first!.split('/').last;
      var formData = FormData.fromMap({
        "folder": mediaType,
        "media": await MultipartFile.fromFile(
          file.paths.first!,
          filename: fileName,
        ),
      });
      Response res = await dioClient!.post("${AppConstants.baseUrlFeed}/api/v1/media", 
        data: formData,
      );
      return res;
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> createForumMedia(String forumId, String path) async {
    try {
      await dioClient!.post("${AppConstants.baseUrlFeed}/api/v1/forum/media", 
        data: {
          "forum_id": forumId,
          "path": path,
        }
      );
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<Response?> sendPostText(String text, String userId, String forumId) async {
    try {
      Response res = await dioClient!.post("${AppConstants.baseUrlFeed}/api/v1/forum", 
        data: {
          "forum_id": forumId,
          "caption": text,
          "forum_type": "text",
          "user_id": userId,
        }
      );
      return res;
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> sendPostLink(String caption, String url, String userId, String forumId) async {
    try {
      Map<String, Object> postsData = {};
      postsData = {
        "forum_id": forumId,
        "caption": caption,
        "forum_type": "document",
        "user_id": userId,
      };
    
      await dioClient!.post("${AppConstants.baseUrlFeed}/api/v1/forum", 
        data: postsData
      );
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> sendPostDoc(String forumId, String caption, String userId) async {
    try {
      Map<String, Object> postsData = {};
      postsData = {
        "forum_id": forumId,
        "caption": caption,
        "forum_type": "document",
        "user_id": userId,
      };
    
      await dioClient!.post("${AppConstants.baseUrlFeed}/api/v1/forum", 
        data: postsData
      );
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> sendPostImage(String forumId, String caption, String userId) async {
    try {
      Map<String, Object> postsData = {};
      postsData = {
        "forum_id": forumId,
        "caption": caption,
        "forum_type": "image",
        "user_id": userId,
      };
      await dioClient!.post("${AppConstants.baseUrlFeed}/api/v1/forum", 
        data: postsData
      );
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> sendPostImageCamera(String forumId, String caption, String userId) async {
    try {
      Map<String, Object> postsData = {};
      postsData = {
        "forum_id": forumId,
        "caption": caption,
        "forum_type": "image",
        "user_id": userId,
      };
    
      await dioClient!.post("${AppConstants.baseUrlFeed}/api/v1/forum", 
        data: postsData
      );
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> sendPostVideo(String forumId, String caption, String userId) async {
    try {
      Map<String, Object> postsData = {};
      postsData = {
        "forum_id": forumId,
        "caption": caption,
        "forum_type": "video",
        "user_id": userId,
      };
    
      await dioClient!.post("${AppConstants.baseUrlFeed}/api/v1/forum", 
        data: postsData
      );
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> sendComment(String content, String targetId, String userId) async {
    try {
      await dioClient!.post("${AppConstants.baseUrlFeed}/api/v1/forum/comment",
        data: {
          "forum_id": targetId,
          "user_id": userId,
          "comment": content
        }
      ); 
    } on DioError catch(e) {  
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

}