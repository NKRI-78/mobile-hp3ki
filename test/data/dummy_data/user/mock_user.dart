import 'package:hp3ki/data/models/user/user.dart';
import 'package:hp3ki/utils/constant.dart';

class MockUser {
  static const UserData expectedUserData = UserData(
    id: "607a4292-345d-466e-b9b0-ec37fc9b1046",
    email: "model@mail.com",
    phone: "12345678910",
    role: "Tester",
    addressKtp: "Somewhere",
    avatar: AppConstants.avatarDebug,
    fulfilledUserData: true,
    fullname: "UserData Test",
    job: "Tester",
    jobId: "dd3adc9e-e56b-477f-a10d-85cf52e0bfcb",
    memberType: "TESTING",
    remainingDays: 1,
    noKtp: "123456789101112",
    noMember: "UN1TT35T",
    organization: "Testing",
    picKtp: AppConstants.avatarError,
  );

  static final Map<String, dynamic> dummyUserJson = expectedUserData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": dummyUserJson,
  };
}
