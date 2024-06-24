import 'package:hp3ki/data/models/inbox/inbox_payment.dart';

class MockInboxPayment {
  static const InboxPaymentData expectedInboxPaymentData = InboxPaymentData(
    id: 0,
    title: 'Any',
    description: 'This is just a test.',
    field1: "any",
    field2: Field2.UNPAID,
    field3: "Any",
    field4: "Any",
    field5: "Any",
    isRead: true,
    link: "Any",
    type: "Any",
    createdAt: "13 June 2023",
  );

  static final Map<String, dynamic> dummyInboxPaymentJson = expectedInboxPaymentData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "body": {
      "pageDetail": {
        "total": 1,
        "per_page": 1,
        "next_page": 1,
        "prev_page": 1,
        "current_page": 1,
        "next_url": "nothing",
        "prev_url": "nothing",
      },
      "data": [dummyInboxPaymentJson]
    },
  };
}
