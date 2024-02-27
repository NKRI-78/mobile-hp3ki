import 'package:hp3ki/data/models/ppob_v2/pln/inquiry_pra.dart';

class MockInquiryPLNPraBayar {
  static const InquiryPLNPrabayarData expectedInquiryPLNPrabayarData = InquiryPLNPrabayarData(
    kodeProduk: "Any",
    waktu: "Anytime",
    idpel1: "any",
    idpel2: "any",
    idpel3: "any",
    namaPelanggan: "Testing",
    periode: "Anytime",
    nominal: "999",
    admin: "Test",
    uid: "Any",
    pin: "Any",
    ref1: "any",
    ref2: "any",
    ref3: "any",
    status: "Any",
    ket: "Any",
    saldoTerpotong: "Any",
    sisaSaldo: "ANy",
    urlStruk: "Any,"
  );

  static final Map<String, dynamic> dummyInquiryPLNPrabayarJson =
      expectedInquiryPLNPrabayarData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "body": dummyInquiryPLNPrabayarJson,
  };
}
