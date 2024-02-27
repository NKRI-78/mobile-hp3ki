import 'package:hp3ki/data/models/enterpreneurs_additional_data/classifications.dart';

class MockClassification {
  static const ClassificationData expectedClassificationData =
      ClassificationData(
          id: "7760155b-d600-4c01-8d19-dd108368c9fe",
          name: "Classification Data Test");

  static final Map<String, dynamic> dummyClassificationJson =
      expectedClassificationData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": [dummyClassificationJson],
  };
}
