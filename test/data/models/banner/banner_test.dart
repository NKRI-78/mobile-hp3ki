import 'package:flutter_test/flutter_test.dart';
import 'package:hp3ki/data/models/banner/banner.dart';
import '../../dummy_data/banner/mock_banner.dart';

void main() {
  group("Test BannerData initialization from json", () {
    late Map<String, dynamic> apiBannerAsJson;
    late BannerData expectedApiBanner;

    setUp(() {
      apiBannerAsJson = MockBanner.dummyBannerJson;
      expectedApiBanner = MockBanner.expectedBannerData;
    });

    test('should be an banner data', () {
      //act
      var result = BannerData.fromJson(apiBannerAsJson);
      //assert
      expect(result, isA<BannerData>());
    });

    test('should not be an banner model', () {
      //act
      var result = BannerData.fromJson(apiBannerAsJson);
      //assert
      expect(result, isNot(BannerModel()));
    });

    test('result should be as expected', () {
      //act
      var result = BannerData.fromJson(apiBannerAsJson);
      //assert
      expect(result, expectedApiBanner);
    });
  });
}
