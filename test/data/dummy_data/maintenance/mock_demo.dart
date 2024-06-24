import 'package:hp3ki/data/models/maintenance/demo.dart';

class MockDemo {
  static const DemoData expectedDemoData = DemoData(
    showDemo: true,
  );

  static final Map<String, dynamic> dummyDemoJson = expectedDemoData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": dummyDemoJson,
  };
}
