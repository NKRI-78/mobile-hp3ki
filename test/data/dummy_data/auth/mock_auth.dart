import 'package:hp3ki/data/models/auth/auth.dart';

class MockAuth {
  static const AuthUser expectedAuthUser = AuthUser(
    id: "8a88acca-b6da-4953-aaff-963b5f9943ab",
    email: "model@mail.com",
    emailActivated: true,
    name: "Expected Model",
    phone: "12345678910",
    phoneActivated: true,
    role: "Tester",
  );

  static final Map<String, dynamic> dummyAuthJson = expectedAuthUser.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": {
      "token": "token",
      "refresh_token": "refreshToken",
      "user": dummyAuthJson,
    },
  };
}
