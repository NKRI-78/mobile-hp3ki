import 'package:hp3ki/data/models/upgrade_member/payment_channel.dart';

class MockPaymentChannel {
  static PaymentChannelData expectedPaymentChannelData = PaymentChannelData(
    id: 99,
    created: DateTime.tryParse("2023-05-29 16:44:24"),
    status: 1,
    updated: DateTime.tryParse("2023-05-29 16:44:24"),
    adminFee: 9999,
    category: Category.VIRTUAL_ACCOUNT,
    paymentCode: "999",
    paymentDescription: "This is just a test.",
    paymentGateway: PaymentGateway.OYI,
    paymentGuide: PaymentGuide.NOT_AVAILABLE,
    paymentLogo: "https://cdn-icons-png.flaticon.com/512/1019/1019607.png",
    paymentName: "Expected Payment VA",
    paymentUrl: PaymentUrl.NULL,
    totalAdminFee: 9999,
    minAmount: 9999,
    paymentMethod: PaymentMethod.BANK_TRANSFER,
  );

  static final Map<String, dynamic> dummyPaymentChannelJson =
      expectedPaymentChannelData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": [dummyPaymentChannelJson],
  };
}
