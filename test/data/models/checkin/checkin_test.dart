import 'package:flutter_test/flutter_test.dart';
import 'package:hp3ki/data/models/checkin/checkin.dart';
import '../../dummy_data/checkin/mock_checkin.dart';

void main() {
  group("Test CheckInData initialization from json", () {
    late Map<String, dynamic> apiCheckInAsJson;
    late CheckInData expectedApiCheckIn;

    setUp(() {
      apiCheckInAsJson = MockCheckIn.dummyCheckInJson;
      expectedApiCheckIn = MockCheckIn.expectedCheckInData;
    });

    test('should be an CheckIn data', () {
      //act
      var result = CheckInData.fromJson(apiCheckInAsJson);
      //assert
      expect(result, isA<CheckInData>());
    });

    test('should not be an CheckIn model', () {
      //act
      var result = CheckInData.fromJson(apiCheckInAsJson);
      //assert
      expect(result, isNot(CheckInModel()));
    });

    test('result should be as expected', () {
      //act
      var result = CheckInData.fromJson(apiCheckInAsJson);
      //assert
      expect(result, expectedApiCheckIn);
    });
  });
}
