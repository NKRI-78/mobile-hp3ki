import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/media/media.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';

class MediaRepo {
  Dio? dioClient;

  MediaRepo({ required this.dioClient }) {
    dioClient ??=  DioManager.shared.getClient();
  }

  Future<MediaModel?> getMediaPath(String mediaType, File file) async {
    try {
      String fileName = file.path.split('/').last;
      var formData = FormData.fromMap({
        "folder": mediaType,
        "media": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });
      Response res = await dioClient!.post("${AppConstants.baseUrl}/api/v1/media",
        data: formData,
      );
      Map<String, dynamic> data = res.data;
      MediaModel mm = MediaModel.fromJson(data);
      return mm;
    } on DioError catch(e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
}