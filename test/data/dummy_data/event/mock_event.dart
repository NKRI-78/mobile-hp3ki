import 'package:hp3ki/data/models/event/event.dart';

class MockEvent {
  static const EventData expectedEventData = EventData(
    id: "90110090-cbe2-4ea7-b84b-c3235b390f5d",
    picture: "https://dummyimage.com/600x400/000/fff",
    title: "Expected Event",
    description: "This is just a test.",
    date: "31 May 2023",
    location: "Jakarta",
    paid: true,
    joined: true,
    start: "11.00",
    end: "12.00",
  );

  static final Map<String, dynamic> dummyEventJson = expectedEventData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": [dummyEventJson],
  };
}
