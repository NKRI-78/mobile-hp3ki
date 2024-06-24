import 'dart:io';

import 'package:flutter/material.dart';

enum InternetStatus { loading, connected, disconnected }

class InternetProvider with ChangeNotifier {
  InternetProvider();

  
  InternetStatus _internetStatus = InternetStatus.loading;
  InternetStatus get internetStatus => _internetStatus;

  void setStateInternetStatus(InternetStatus internetStatus) {
    _internetStatus = internetStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<String> checkFromInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setStateInternetStatus(InternetStatus.connected);
        return "=== CONNECTED TO INTERNET ===";
      }
    } on SocketException catch (_) {
      setStateInternetStatus(InternetStatus.disconnected);
      return "=== DISCONNECTED TO INTERNET ===";
    } catch(e) {
      setStateInternetStatus(InternetStatus.disconnected);
      return "=== DISCONNECTED TO INTERNET ===";
    }
    return "=== CONNECTED TO INTERNET ===";
}

void connectingToInternet() async {
    Stream.fromFuture(checkFromInternet()).listen((event) { 

    }, onError: (e) async {
      await Future.delayed(const Duration(seconds: 2));
      connectingToInternet();
    }, onDone: () async {
      await Future.delayed(const Duration(seconds: 2));
      connectingToInternet();
    },);
}
}