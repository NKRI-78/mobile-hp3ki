import 'package:hp3ki/data/models/news/single_news.dart';

class MockSingleNews {
  static const SingleNewsData expectedSingleNewsData = SingleNewsData(
    uid: "98f4005f-17bb-42f5-8490-84d36048cdec",
    title: "SingleNewsData Test",
    desc: "This is just a test.",
    image: "https://dummyimage.com/600x400/000/fff",
    createdAt: "31 May 2023",
  );

  static final Map<String, dynamic> dummySingleNewsJson =
      expectedSingleNewsData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": dummySingleNewsJson,
  };
}
