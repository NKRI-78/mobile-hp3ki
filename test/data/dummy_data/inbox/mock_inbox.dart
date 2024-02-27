import 'package:hp3ki/data/models/inbox/inbox.dart';

class MockInbox {
  static const InboxData expectedInboxData = InboxData(
    id: "75f42fef-7343-4d2b-bf43-032dae449572",
    title: "InboxData Test",
    subject: "Testing",
    description: "This is just a test.",
    link: "-",
    user: User(
      email: "test@mail.com",
    ),
    read: true,
    createdAt: "31 May 2023",
    updatedAt: "31 May 2023",
  );

  static final Map<String, dynamic> dummyInboxJson = expectedInboxData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "pageDetail": {
      "badges": 1,
      "total": 1,
      "per_page": 1,
      "next_page": 1,
      "prev_page": 1,
      "current_page": 1,
      "next_url": "nothing",
      "prev_url": "nothing",
    },
    "data": [dummyInboxJson],
  };
}
