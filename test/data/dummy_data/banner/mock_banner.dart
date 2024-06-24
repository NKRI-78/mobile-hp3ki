import 'package:hp3ki/data/models/banner/banner.dart';

class MockBanner {
  static const BannerData expectedBannerData = BannerData(
      uid: "8a88acca-b6da-4953-aaff-963b5f9943ab",
      name: "Expected Banner",
      createdAt: "26 May 2023",
      path: "https://dummyimage.com/600x400/000/fff");

  static final Map<String, dynamic> dummyBannerJson =
      expectedBannerData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": [dummyBannerJson],
  };
}
