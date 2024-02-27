import 'package:flutter/material.dart';
import 'package:hp3ki/data/models/maintenance/demo.dart';
import 'package:hp3ki/data/repository/maintenance/maintenance.dart';
import 'package:hp3ki/utils/exceptions.dart';

enum DemoStatus { loading, loaded, error, idle }

class MaintenanceProvider extends ChangeNotifier {
  final MaintenanceRepo mr;
  MaintenanceProvider({
    required this.mr,
  });

  DemoStatus _demoStatus = DemoStatus.idle;
  DemoStatus get demoStatus => _demoStatus;

  bool? _isDemo;
  bool? get isDemo => _isDemo;

  void setStateDemoStatus(DemoStatus demoStatus) {
    _demoStatus = demoStatus;
    Future.delayed(Duration.zero, () =>  notifyListeners());
  }

  Future<void> getDemoStatus(BuildContext context) async {
    setStateDemoStatus(DemoStatus.loading);
    try {
      DemoModel? mm = await mr.getDemoStatus();
      _isDemo = mm!.data!.showDemo!;
      debugPrint('isDemo = $isDemo');
      setStateDemoStatus(DemoStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateDemoStatus(DemoStatus.error);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      setStateDemoStatus(DemoStatus.error);
    }
  }

}
