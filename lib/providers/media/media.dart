import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import 'package:hp3ki/data/repository/media/media.dart';

enum MediaStatus { idle, loading, loaded, error, empty }

class MediaProvider extends ChangeNotifier {
  final MediaRepo mr;
  MediaProvider({required this.mr });

  Future<Response?> postMedia(File file) async {
    try {
      Response res = await mr.postMedia(file);
      return res;
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }
}