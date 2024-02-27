import 'package:flutter_test/flutter_test.dart';
import 'package:hp3ki/data/models/news/news.dart';
import 'package:hp3ki/data/models/news/single_news.dart';

import '../../dummy_data/news/mock_news.dart';
import '../../dummy_data/news/mock_single_news.dart';

void main() {
  group("Test NewsData initialization from json", () {
    late Map<String, dynamic> apiNewsAsJson;
    late NewsData expectedApiNews;

    setUp(() {
      apiNewsAsJson = MockNews.dummyNewsJson;
      expectedApiNews = MockNews.expectedNewsData;
    });

    test('should be an News data', () {
      //act
      var result = NewsData.fromJson(apiNewsAsJson);
      //assert
      expect(result, isA<NewsData>());
    });

    test('should not be an News model', () {
      //act
      var result = NewsData.fromJson(apiNewsAsJson);
      //assert
      expect(result, isNot(NewsModel()));
    });

    test('result should be as expected', () {
      //act
      var result = NewsData.fromJson(apiNewsAsJson);
      //assert
      expect(result, expectedApiNews);
    });
  });

  group("Test SingleNewsData initialization from json", () {
    late Map<String, dynamic> apiSingleNewsAsJson;
    late SingleNewsData expectedApiSingleNews;

    setUp(() {
      apiSingleNewsAsJson = MockSingleNews.dummySingleNewsJson;
      expectedApiSingleNews = MockSingleNews.expectedSingleNewsData;
    });

    test('should be an SingleNews data', () {
      //act
      var result = SingleNewsData.fromJson(apiSingleNewsAsJson);
      //assert
      expect(result, isA<SingleNewsData>());
    });

    test('should not be an SingleNews model', () {
      //act
      var result = SingleNewsData.fromJson(apiSingleNewsAsJson);
      //assert
      expect(result, isNot(SingleNewsModel()));
    });

    test('result should be as expected', () {
      //act
      var result = SingleNewsData.fromJson(apiSingleNewsAsJson);
      //assert
      expect(result, expectedApiSingleNews);
    });
  });
}
