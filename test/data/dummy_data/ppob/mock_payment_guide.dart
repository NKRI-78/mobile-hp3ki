import 'package:hp3ki/data/models/ppob_v2/payment_guide.dart';

class MockPaymentGuide {
  static const PaymentGuideData expectedPaymentGuideData = PaymentGuideData(
    category: 'test',
    channel: 'T35T',
    logo: 'Test',
    name: 'Testing',
    steps: [
      StepModel(
        step: 1,
        description: 'This is just a test.',
      )
    ]
  );

  static final Map<String, dynamic> dummyPaymentGuideJson =
      expectedPaymentGuideData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "code": 0,
    "message": "Ok",
    "body": [dummyPaymentGuideJson],
  };
}
