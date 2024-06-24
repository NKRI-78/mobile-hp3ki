import 'package:flutter_test/flutter_test.dart';
import 'package:hp3ki/data/models/media/media.dart';

import '../../dummy_data/media/mock_media.dart';

void main() {
  group("Test MediaData initialization from json", () {
    late Map<String, dynamic> apiMediaAsJson;
    late MediaData expectedApiMedia;

    setUp(() {
      apiMediaAsJson = MockMedia.dummyMediaJson;
      expectedApiMedia = MockMedia.expectedMediaData;
    });

    test('should be an Media data', () {
      //act
      var result = MediaData.fromJson(apiMediaAsJson);
      //assert
      expect(result, isA<MediaData>());
    });

    test('should not be an Media model', () {
      //act
      var result = MediaData.fromJson(apiMediaAsJson);
      //assert
      expect(result, isNot(MediaModel()));
    });

    test('result should be as expected', () {
      //act
      var result = MediaData.fromJson(apiMediaAsJson);
      //assert
      expect(result, expectedApiMedia);
    });
  });
}
