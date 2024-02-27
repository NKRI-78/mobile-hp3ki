import 'package:flutter_test/flutter_test.dart';
import 'package:hp3ki/data/models/auth/auth.dart';
import '../../dummy_data/auth/mock_auth.dart';

void main() {
  group("Test AuthUser initialization from json", () {
    late Map<String, dynamic> apiAuthAsJson;
    late AuthUser expectedApiAuth;

    setUp(() {
      apiAuthAsJson = MockAuth.dummyAuthJson;
      expectedApiAuth = MockAuth.expectedAuthUser;
    });

    test('should be an auth user', () {
      //act
      var result = AuthUser.fromJson(apiAuthAsJson);
      //assert
      expect(result, isA<AuthUser>());
    });

    test('should not be an auth model', () {
      //act
      var result = AuthUser.fromJson(apiAuthAsJson);
      //assert
      expect(result, isNot(AuthModel()));
    });

    test('result should be as expected', () {
      //act
      var result = AuthUser.fromJson(apiAuthAsJson);
      //assert
      expect(result, expectedApiAuth);
    });
  });
}
