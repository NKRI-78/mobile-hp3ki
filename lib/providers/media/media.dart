import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hp3ki/data/models/media/media.dart';

import 'package:hp3ki/data/repository/media/media.dart';

enum MediaStatus { idle, loading, loaded, error, empty }
enum UploadPictureStatus { idle, loading, loaded, error, empty }

class MediaProvider with ChangeNotifier {
  final MediaRepo mr;

  MediaProvider({
    required this.mr
  });

  MediaStatus _mediaStatus = MediaStatus.loading;
  MediaStatus get mediaStatus => _mediaStatus;

  UploadPictureStatus _uploadPictureStatus = UploadPictureStatus.idle;
  UploadPictureStatus get uploadPictureStatus => _uploadPictureStatus;

  MediaData? _media = const MediaData();
  MediaData? get media => _media;

  MediaModel? _mediaModel = MediaModel();
  MediaModel? get mediaModel => _mediaModel;

  void setStateUploadPictureStatus(UploadPictureStatus uploadPictureStatus) {
    _uploadPictureStatus = uploadPictureStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateMediaStatus(MediaStatus mediaStatus) {
    _mediaStatus = mediaStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<String?> uploadPicture(BuildContext context, File file) async {
    setStateUploadPictureStatus(UploadPictureStatus.loading);
    try {
      MediaData? data = await getMediaPath(
        context,
        "images",
        file,
      );
      String path = data!.path!;
      Future.delayed(const Duration(seconds: 1), () {
        setStateUploadPictureStatus(UploadPictureStatus.loaded);
      });
      return path;
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      debugPrint(e.toString());
      setStateUploadPictureStatus(UploadPictureStatus.error);
    }
    return "";
  }

  Future<MediaData?> getMediaPath(BuildContext context, String mediaType, File file) async {
    setStateMediaStatus(MediaStatus.loading);
    try {   
      _mediaModel = await mr.getMediaPath(mediaType, file);
      _media = mediaModel!.data;
      setStateMediaStatus(MediaStatus.loaded);
      if(media!.path!.isEmpty) {
        setStateMediaStatus(MediaStatus.empty);
      }
      return media;
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateMediaStatus(MediaStatus.error);
    }
    return null;
  }
}