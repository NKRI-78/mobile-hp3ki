import 'package:hp3ki/data/models/maintenance/maintenance.dart';

class MockMaintenance {
  static const MaintenanceData expectedMaintenanceData = MaintenanceData(
    maintenance: true,
  );

  static final Map<String, dynamic> dummyMaintenanceJson =
      expectedMaintenanceData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": dummyMaintenanceJson,
  };
}
