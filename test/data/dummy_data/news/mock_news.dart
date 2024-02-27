import 'package:hp3ki/data/models/news/news.dart';

class MockNews {
  static const NewsData expectedNewsData = NewsData(
    id: "194c4521-f7c8-43e7-8dab-b6ca46c2cf3a",
    title: "NewsData Test",
    desc: "This is just a test.",
    image: "https://dummyimage.com/600x400/000/fff",
    createdAt: "31 May 2023",
  );

  static final Map<String, dynamic> dummyNewsJson = expectedNewsData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": [dummyNewsJson],
  };
}
