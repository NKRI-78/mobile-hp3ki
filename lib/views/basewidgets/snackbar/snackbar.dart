import 'package:flutter/material.dart';

import 'package:hp3ki/services/services.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class ShowSnackbar {
  ShowSnackbar._();
  static snackbar(String content, String label, Color backgroundColor, [Duration? time]) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).clearSnackBars();
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        duration: time ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,  
        backgroundColor: backgroundColor,
        content: Text(
          content.contains('SocketException') ? "Koneksi internet anda tidak stabil. Pastikan anda terhubung ke internet." : content,
          style: robotoRegular.copyWith(
            color: ColorResources.white,
            fontSize: Dimensions.fontSizeLarge
        )),
        action: SnackBarAction(
          textColor: ColorResources.white,
          label: label,
          onPressed: () {
            ScaffoldMessenger.of(navigatorKey.currentContext!).hideCurrentSnackBar();
          }
        ),
      )
    );
  }
}