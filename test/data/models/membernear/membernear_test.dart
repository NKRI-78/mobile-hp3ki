import 'package:flutter_test/flutter_test.dart';
import 'package:hp3ki/data/models/membernear/membernear.dart';

import '../../dummy_data/membernear/mock_membernear.dart';

void main() {
  group("Test MemberNearData initialization from json", () {
    late Map<String, dynamic> apiMemberNearAsJson;
    late MemberNearData expectedApiMemberNear;

    setUp(() {
      apiMemberNearAsJson = MockMemberNear.dummyMemberNearJson;
      expectedApiMemberNear = MockMemberNear.expectedMemberNearData;
    });

    test('should be an MemberNear data', () {
      //act
      var result = MemberNearData.fromJson(apiMemberNearAsJson);
      //assert
      expect(result, isA<MemberNearData>());
    });

    test('should not be an MemberNear model', () {
      //act
      var result = MemberNearData.fromJson(apiMemberNearAsJson);
      //assert
      expect(result, isNot(MemberNearModel()));
    });

    test('result should be as expected', () {
      //act
      var result = MemberNearData.fromJson(apiMemberNearAsJson);
      //assert
      expect(result, expectedApiMemberNear);
    });
  });
}
