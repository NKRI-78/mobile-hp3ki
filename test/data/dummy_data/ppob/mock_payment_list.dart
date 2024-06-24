import 'package:hp3ki/data/models/ppob_v2/payment_list.dart';

class MockPaymentList {
  static const PaymentListData expectedPaymentListData = PaymentListData(
    category: "001",
    channel: "Test Channel",
    classId: "cc9816e2-4455-426f-9e30-7ab2641ea53a",
    guide: "Test",
    isDirect: true,
    minAmount: 9999,
    name: "Test Payment List",
    paymentCode: "T35T",
    paymentDescription: "This is just a test",
    paymentGateway: "Test",
    paymentLogo: "Test",
    paymentMethod: "Test",
    paymentName: "Test Payment",
    paymentUrl: "Test",
    paymentUrlV2: "Test",
    totalAdminFee: 999,
  );

  static final Map<String, dynamic> dummyPaymentListJson =
      expectedPaymentListData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "body": [dummyPaymentListJson],
  };
}
