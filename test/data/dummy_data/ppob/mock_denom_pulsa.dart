import 'package:hp3ki/data/models/ppob_v2/denom_pulsa.dart';

class MockDenomPulsa {
  static const DenomPulsaData expectedDenomPulsaData = DenomPulsaData(
    productCode: "T35T",
    productFee: 999,
    productName: "Testing",
    productPrice: 9999,
  );

  static final Map<String, dynamic> dummyDenomPulsaJson =
      expectedDenomPulsaData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "body": [dummyDenomPulsaJson],
  };
}
