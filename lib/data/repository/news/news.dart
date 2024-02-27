import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/news/news.dart';
import 'package:hp3ki/data/models/news/single_news.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';

class NewsRepo {
  Dio? dioClient;

  NewsRepo({ required this.dioClient }) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<NewsModel?> getNews() async {
    try {
      Response res = await dioClient!.get("${AppConstants.baseUrl}/api/v1/news");
      Map<String, dynamic> dataJson = res.data;
      NewsModel data = NewsModel.fromJson(dataJson);
      return data;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<SingleNewsModel?> getNewsDetail({required String newsId}) async {
    try {
      Response res = await dioClient!.post("${AppConstants.baseUrl}/api/v1/news/detail", data: {
        "id": newsId,
      });
      Map<String, dynamic> dataJson = res.data;
      SingleNewsModel data = SingleNewsModel.fromJson(dataJson);
      return data;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
}