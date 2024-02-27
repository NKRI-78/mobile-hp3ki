import 'package:hp3ki/data/models/inbox/count.dart';

class MockInboxCount {
  static const InboxCountData expectedInboxCountData = InboxCountData(
    total: 1,
  );

  static final Map<String, dynamic> dummyInboxCountJson = expectedInboxCountData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": dummyInboxCountJson,
  };
}

class MockInboxCountPayment {
  static const InboxCountPaymentData expectedInboxCountPaymentData = InboxCountPaymentData(
    total: 1,
  );

  static final Map<String, dynamic> dummyInboxCountPaymentJson = expectedInboxCountPaymentData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "body": dummyInboxCountPaymentJson,
  };
}
