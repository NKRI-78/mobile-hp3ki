import 'package:flutter_test/flutter_test.dart';
import 'package:hp3ki/data/models/maintenance/demo.dart';
import 'package:hp3ki/data/models/maintenance/maintenance.dart';
import '../../dummy_data/maintenance/mock_demo.dart';
import '../../dummy_data/maintenance/mock_maintenance.dart';

void main() {
  group("Test DemoData initialization from json", () {
    late Map<String, dynamic> apiDemoAsJson;
    late DemoData expectedApiDemo;

    setUp(() {
      apiDemoAsJson = MockDemo.dummyDemoJson;
      expectedApiDemo = MockDemo.expectedDemoData;
    });

    test('should be an Demo data', () {
      //act
      var result = DemoData.fromJson(apiDemoAsJson);
      //assert
      expect(result, isA<DemoData>());
    });

    test('should not be an Demo model', () {
      //act
      var result = DemoData.fromJson(apiDemoAsJson);
      //assert
      expect(result, isNot(DemoModel()));
    });

    test('result should be as expected', () {
      //act
      var result = DemoData.fromJson(apiDemoAsJson);
      //assert
      expect(result, expectedApiDemo);
    });
  });

  group("Test MaintenanceData initialization from json", () {
    late Map<String, dynamic> apiMaintenanceAsJson;
    late MaintenanceData expectedApiMaintenance;

    setUp(() {
      apiMaintenanceAsJson = MockMaintenance.dummyMaintenanceJson;
      expectedApiMaintenance = MockMaintenance.expectedMaintenanceData;
    });

    test('should be an Maintenance data', () {
      //act
      var result = MaintenanceData.fromJson(apiMaintenanceAsJson);
      //assert
      expect(result, isA<MaintenanceData>());
    });

    test('should not be an Maintenance model', () {
      //act
      var result = MaintenanceData.fromJson(apiMaintenanceAsJson);
      //assert
      expect(result, isNot(MaintenanceModel()));
    });

    test('result should be as expected', () {
      //act
      var result = MaintenanceData.fromJson(apiMaintenanceAsJson);
      //assert
      expect(result, expectedApiMaintenance);
    });
  });
}
