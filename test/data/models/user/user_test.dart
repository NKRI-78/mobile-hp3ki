import 'package:flutter_test/flutter_test.dart';
import 'package:hp3ki/data/models/user/user.dart';
import '../../dummy_data/user/mock_user.dart';

void main() {
  group("Test User initialization from json", () {
    late Map<String, dynamic> apiUserAsJson;
    late UserData expectedApiUser;

    setUp(() {
      apiUserAsJson = MockUser.dummyUserJson;
      expectedApiUser = MockUser.expectedUserData;
    });

    test('should be an UserData', () {
      //act
      var result = UserData.fromJson(apiUserAsJson);
      //assert
      expect(result, isA<UserData>());
    });

    test('should not be an User model', () {
      //act
      var result = UserData.fromJson(apiUserAsJson);
      //assert
      expect(result, isNot(UserModel()));
    });

    test('result should be as expected', () {
      //act
      var result = UserData.fromJson(apiUserAsJson);
      //assert
      expect(result, expectedApiUser);
    });
  });
}
