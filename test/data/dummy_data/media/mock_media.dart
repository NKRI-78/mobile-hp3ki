import 'package:hp3ki/data/models/media/media.dart';

class MockMedia {
  static MediaData expectedMediaData = const MediaData(
      name: "Media Data Test",
      path: "https://dummyimage.com/600x400/000/fff",
      mimetype: "Test",
      size: "Test01");

  static final Map<String, dynamic> dummyMediaJson = expectedMediaData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": dummyMediaJson,
  };
}
