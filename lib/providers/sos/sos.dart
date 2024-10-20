import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/utils/color_resources.dart';

import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/shared_preferences.dart';

import 'package:hp3ki/views/basewidgets/dialog/custom/custom.dart';

import 'package:hp3ki/data/repository/sos/sos.dart';
import 'package:hp3ki/providers/location/location.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:hp3ki/views/screens/home/home.dart';

enum SosStatus { idle, loading, loaded, empty, error }

class SosProvider with ChangeNotifier {
  final LocationProvider lp;
  final SosRepo sr;

  SosProvider({
    required this.sr,
    required this.lp
  });

  SosStatus _sosStatus = SosStatus.idle;
  SosStatus get sosStatus => _sosStatus;

  void setStateSosStatus(SosStatus sosStatus) {
    _sosStatus = sosStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> sendSos(BuildContext context, {required String type, required String message}) async {
    setStateSosStatus(SosStatus.loading);
    try {
<<<<<<< HEAD
      await sr.sendSos(
        type: type, 
        message: message, 
        lat: lp.getCurrentLat.toString(),
        lng: lp.getCurrentLng.toString(),
        userId: SharedPrefs.getUserId(),
      );
      NS.pushReplacement(context, const DashboardScreen());
      ShowSnackbar.snackbar(getTranslated('SENT_SOS', context), '', ColorResources.success);
=======
      if(lp.getCurrentLat.toString() != "0.0" && lp.getCurrentLng.toString() != "0.0") {
        await sr.sendSos(
          type: type, 
          message: message, 
          lat: lp.getCurrentLat.toString(),
          lng: lp.getCurrentLng.toString(),
          userId: SharedPrefs.getUserId(),
        );
        NS.pushReplacement(context, const DashboardScreen());
        ShowSnackbar.snackbar(context, getTranslated('SENT_SOS', context), '', ColorResources.success);
      } else {
        ShowSnackbar.snackbar(context, getTranslated('PLEASE_ACTIVATE_LOCATION', context), '', ColorResources.error);
      }
>>>>>>> 3de3b56a677787d3a71350f1578c9cfdc07bb277
      setStateSosStatus(SosStatus.loaded);
    } on CustomException catch(e) {
      debugPrint(e.cause.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'SR01');
      setStateSosStatus(SosStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      CustomDialog.showUnexpectedError(context, errorCode: 'SP01');
      setStateSosStatus(SosStatus.error);
    }
  }

}