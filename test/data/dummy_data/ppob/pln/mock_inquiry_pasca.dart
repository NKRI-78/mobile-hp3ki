import 'package:hp3ki/data/models/ppob_v2/pln/inquiry_pasca.dart';

class MockInquiryPLNPascaBayar {
  static const InquiryPLNPascaBayarData expectedInquiryPLNPascaBayarData = InquiryPLNPascaBayarData(
    inquiryStatus: "Testing",
    productCode: "T35T",
    productName: "Testing",
    productPrice: 9999,
    productId: "Any",
    accountNumber1: "Any",
    accountNumber2: "Any",
    classId: "Any",
    data: InquiryPLNPascaBayarUserData(
      accountName: "Testing",
      admin: "any",
      amount: 5000,
    ),
    transactionId: "Any",
    transactionRef: "Any",
  );

  static final Map<String, dynamic> dummyInquiryPLNPascaBayarJson =
      expectedInquiryPLNPascaBayarData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "body": dummyInquiryPLNPascaBayarJson,
  };
}
