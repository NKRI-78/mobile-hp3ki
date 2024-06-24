import 'package:hp3ki/data/models/enterpreneurs_additional_data/business.dart';

class MockBusiness {
  static const BusinessData expectedBusinessData = BusinessData(
    id: "4dbe147c-292d-499c-b3d7-23ab981eb70d",
    name: "Business Data Testing",
  );

  static final Map<String, dynamic> dummyBusinessJson =
      expectedBusinessData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": [dummyBusinessJson],
  };
}
