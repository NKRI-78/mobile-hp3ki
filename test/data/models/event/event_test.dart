import 'package:flutter_test/flutter_test.dart';
import 'package:hp3ki/data/models/event/event.dart';
import '../../dummy_data/event/mock_event.dart';

void main() {
  group("Test EventData initialization from json", () {
    late Map<String, dynamic> apiEventAsJson;
    late EventData expectedApiEvent;

    setUp(() {
      apiEventAsJson = MockEvent.dummyEventJson;
      expectedApiEvent = MockEvent.expectedEventData;
    });

    test('should be an Event data', () {
      //act
      var result = EventData.fromJson(apiEventAsJson);
      //assert
      expect(result, isA<EventData>());
    });

    test('should not be an Event model', () {
      //act
      var result = EventData.fromJson(apiEventAsJson);
      //assert
      expect(result, isNot(EventModel()));
    });

    test('result should be as expected', () {
      //act
      var result = EventData.fromJson(apiEventAsJson);
      //assert
      expect(result, expectedApiEvent);
    });
  });
}
