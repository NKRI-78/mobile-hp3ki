import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';

class VideoServices {

  static Future<MediaInfo?> compressVideo(File file) async {
    try {
      await VideoCompress.setLogLevel(0);
      return await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.HighestQuality,
        deleteOrigin: false,
        includeAudio: true, 
      );
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      VideoCompress.cancelCompression();
    }
    return null;
  }

  static Future<String?> getDuration(File file) async {
    MediaInfo? mediaInfo = await VideoCompress.getMediaInfo(file.path);
    return (Duration(microseconds: (mediaInfo.duration! * 1000).toInt())).toString();
  }

  static Future<File> generateFileThumbnail(File f) async {
    File file = await VideoCompress.getFileThumbnail(f.path);
    return file;
  }

}