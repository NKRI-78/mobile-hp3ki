import 'package:hp3ki/data/models/feed/feedmedia.dart';

class MockFeedMedia {
  static FeedMedia expectedFeedMedia = const FeedMedia(
    path: "https://dummyimage.com/600x400/000/fff",
  );

  static final Map<String, dynamic> dummyFeedMediaJson =
      expectedFeedMedia.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": dummyFeedMediaJson,
  };
}
