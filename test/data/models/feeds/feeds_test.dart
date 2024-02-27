import 'package:flutter_test/flutter_test.dart';
import 'package:hp3ki/data/models/feed/feedmedia.dart';
import 'package:hp3ki/data/models/feed/feeds.dart';
import 'package:hp3ki/data/models/feed/feedsdetail.dart';

import '../../dummy_data/feeds/mock_feedmedia.dart';
import '../../dummy_data/feeds/mock_feeds.dart';
import '../../dummy_data/feeds/mock_feedsdetail.dart';

void main() {
  group("Test FeedData initialization from json", () {
    late Map<String, dynamic> apiFeedAsJson;
    late FeedData expectedApiFeed;

    setUp(() {
      apiFeedAsJson = MockFeed.dummyFeedJson;
      expectedApiFeed = MockFeed.expectedFeedData;
    });

    test('should be an Feed data', () {
      //act
      var result = FeedData.fromJson(apiFeedAsJson);
      //assert
      expect(result, isA<FeedData>());
    });

    test('should not be an Feed model', () {
      //act
      var result = FeedData.fromJson(apiFeedAsJson);
      //assert
      expect(result, isNot(FeedModel()));
    });

    test('result should be as expected', () {
      //act
      var result = FeedData.fromJson(apiFeedAsJson);
      //assert
      expect(result, expectedApiFeed);
    });
  });

  group("Test FeedMedia initialization from json", () {
    late Map<String, dynamic> apiFeedMediaAsJson;
    late FeedMedia expectedApiFeedMedia;

    setUp(() {
      apiFeedMediaAsJson = MockFeedMedia.dummyFeedMediaJson;
      expectedApiFeedMedia = MockFeedMedia.expectedFeedMedia;
    });

    test('should be an FeedMedia data', () {
      //act
      var result = FeedMedia.fromJson(apiFeedMediaAsJson);
      //assert
      expect(result, isA<FeedMedia>());
    });

    test('should not be an FeedModel', () {
      //act
      var result = FeedMedia.fromJson(apiFeedMediaAsJson);
      //assert
      expect(result, isNot(FeedModel()));
    });

    test('result should be as expected', () {
      //act
      var result = FeedMedia.fromJson(apiFeedMediaAsJson);
      //assert
      expect(result, expectedApiFeedMedia);
    });
  });

  group("Test ForumDetailBody initialization from json", () {
    late Map<String, dynamic> apiForumDetailBodyAsJson;
    late ForumDetailBody expectedApiForumDetailBody;

    setUp(() {
      apiForumDetailBodyAsJson = MockFeedDetail.dummyForumDetailBodyJson;
      expectedApiForumDetailBody = MockFeedDetail.expectedForumDetailBody;
    });

    test('should be an ForumDetailBody data', () {
      //act
      var result = ForumDetailBody.fromJson(apiForumDetailBodyAsJson);
      //assert
      expect(result, isA<ForumDetailBody>());
    });

    test('should not be an FeedModel', () {
      //act
      var result = ForumDetailBody.fromJson(apiForumDetailBodyAsJson);
      //assert
      expect(result, isNot(FeedModel()));
    });

    test('result should be as expected', () {
      //act
      var result = ForumDetailBody.fromJson(apiForumDetailBodyAsJson);
      //assert
      expect(result, expectedApiForumDetailBody);
    });
  });
}
