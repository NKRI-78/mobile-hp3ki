import 'package:hp3ki/data/models/upgrade_member/inquiry.dart';

class MockInquiry {
  static InquiryData expectedInquiryData = InquiryData(
      expired: DateTime.tryParse("2023-05-29 16:44:24"),
      noVa: "9999999999999",
      totalPayment: "Rp 99.999",
      paymentGuide: "https://www.saucedemo.com/",
      paymentChannel: "Expected Payment VA",
      detail: const [
        Detail(
          name: "Test",
        ),
      ]);

  static final Map<String, dynamic> dummyInquiryJson =
      expectedInquiryData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": dummyInquiryJson,
  };
}
