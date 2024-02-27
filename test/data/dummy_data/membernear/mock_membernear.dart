import 'package:hp3ki/data/models/membernear/membernear.dart';
import 'package:hp3ki/utils/constant.dart';

class MockMemberNear {
  static const MemberNearData expectedMemberNearData = MemberNearData(
      distance: "9.9 KM",
      lat: "0.0",
      lng: "0.0",
      user: User(
        avatar: AppConstants.avatarDebug,
        email: "test@mail.com",
        name: "MemberNearData Test",
        phone: "-",
      ));

  static final Map<String, dynamic> dummyMemberNearJson =
      expectedMemberNearData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "pageDetail": {
      "total": 1,
      "per_page": 1,
      "next_page": 1,
      "prev_page": 1,
      "current_page": 1,
      "next_url": "nothing",
      "prev_url": "nothing",
    },
    "data": [dummyMemberNearJson],
  };
}
