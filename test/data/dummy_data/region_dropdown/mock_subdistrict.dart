import 'package:hp3ki/data/models/region_dropdown/subdisctrict.dart';

class MockSubdistrict {
  static const SubdistrictData expectedSubdistrictData = SubdistrictData(
    id: "194c4521-f7c8-43e7-8dab-b6ca46c2cf3a",
    name: "Testing",
  );

  static final Map<String, dynamic> dummySubdistrictJson =
      expectedSubdistrictData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": [dummySubdistrictJson],
  };
}
