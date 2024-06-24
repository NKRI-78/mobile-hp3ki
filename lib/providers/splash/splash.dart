import 'package:flutter/material.dart';
import 'package:hp3ki/data/models/maintenance/maintenance.dart';
import 'package:hp3ki/data/repository/maintenance/maintenance.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/shared_preferences.dart';

enum MaintenanceStatus { loading, loaded, error, idle }

class SplashProvider extends ChangeNotifier {
  final MaintenanceRepo mr;

  SplashProvider({
    required this.mr,
  });

  MaintenanceStatus _maintenanceStatus = MaintenanceStatus.idle;
  MaintenanceStatus get maintenanceStatus => _maintenanceStatus;

  late List<String> _languageList;
  final int _languageIndex = 0;

  List<String> get languageList => _languageList;
  int get languageIndex => _languageIndex;

  bool? _isMaintenance;
  bool? get isMaintenance => _isMaintenance;

  void setStateMaintenanceStatus(MaintenanceStatus maintenanceStatus) {
    _maintenanceStatus = maintenanceStatus;
    Future.delayed(Duration.zero, () =>  notifyListeners());
  }

  Future<bool> initConfig() {
    _languageList = ['English', 'Indonesia'];
    Future.delayed(Duration.zero, () => notifyListeners());
    return Future.value(true);
  }

  bool isSkipOnboarding() {
    return SharedPrefs.isSkipOnboarding();
  }
  
  void dispatchOnboarding(bool onboarding) {
    SharedPrefs.setOnboarding(onboarding);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getMaintenanceStatus(BuildContext context) async {
    setStateMaintenanceStatus(MaintenanceStatus.loading);
    try {
      MaintenanceModel? mm = await mr.getMaintenanceStatus();
      _isMaintenance = mm!.data!.maintenance!;
      debugPrint(isMaintenance!.toString());
      setStateMaintenanceStatus(MaintenanceStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateMaintenanceStatus(MaintenanceStatus.error);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      setStateMaintenanceStatus(MaintenanceStatus.error);
    }
  }

}
