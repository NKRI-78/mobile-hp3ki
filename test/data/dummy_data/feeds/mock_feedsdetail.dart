import 'package:hp3ki/data/models/feed/feedsdetail.dart';
import 'package:hp3ki/utils/constant.dart';

import 'mock_feedmedia.dart';

class MockFeedDetail {
  static const User expectedUserOne = User(
    uid: "7b695fed-6657-4c86-97f6-cda143451731",
    fullname: "Person 01",
    profilePic: AppConstants.avatarDebug,
    email: "person1@mail.com",
  );
  static const User expectedUserTwo = User(
    uid: "ee27b328-8941-47ba-9e5b-4b2b165be193",
    fullname: "Person 02",
    profilePic: AppConstants.avatarError,
    email: "person2@mail.com",
  );
  static ForumDetailBody expectedForumDetailBody = ForumDetailBody(
    uid: "adccba28-5d05-46a7-a791-1a18b7178f59",
    caption: "Hello, this is automatically posted by unit test",
    media: [MockFeedMedia.expectedFeedMedia],
    user: expectedUserOne,
    forumComments: const ForumComments(
      total: 1,
      comments: [
        CommentElement(
          uid: "6f27562b-9413-41c7-a1ce-c836d27a6906",
          user: expectedUserTwo,
          comment: "Hello, this comment sent automatically",
          commentLikes: Likes(
            total: 1,
            likes: [
              Like(
                user: expectedUserOne,
              )
            ],
          ),
          commentReplies: CommentReplies(total: 1, replies: [
            CommentReply(
              uid: "b26efa91-28b7-4764-9d8d-2c8ec4705df4",
              reply: "Hello, this reply sent automatically",
              user: expectedUserOne,
            ),
          ]),
        ),
      ],
    ),
    forumLikes: const Likes(
      total: 1,
      likes: [
        Like(
          user: expectedUserTwo,
        )
      ],
    ),
    forumType: "post",
    createdAt: DateTime.parse('2023-05-31'),
  );

  static final Map<String, dynamic> dummyUserOne = {
    "uid": "7b695fed-6657-4c86-97f6-cda143451731",
    "name": "Person 01",
    "avatar": AppConstants.avatarDebug,
    "email": "person1@mail.com",
  };
  static final Map<String, dynamic> dummyUserTwo = {
    "uid": "ee27b328-8941-47ba-9e5b-4b2b165be193",
    "name": "Person 02",
    "avatar": AppConstants.avatarError,
    "email": "person2@mail.com",
  };
  static final Map<String, dynamic> dummyForumDetailBodyJson = {
    "uid": "adccba28-5d05-46a7-a791-1a18b7178f59",
    "caption": "Hello, this is automatically posted by unit test",
    "media": [MockFeedMedia.dummyFeedMediaJson],
    "user": dummyUserOne,
    "forum_comments": {
      "total": 1,
      "comments": [
        {
          "uid": "6f27562b-9413-41c7-a1ce-c836d27a6906",
          "comment": "Hello, this comment sent automatically",
          "comment_likes": {
            "total": 1,
            "likes": [
              {
                "user": dummyUserOne,
              },
            ],
          },
          "comment_replies": {
            "total": 1,
            "replies": [
              {
                "uid": "b26efa91-28b7-4764-9d8d-2c8ec4705df4",
                "reply": "Hello, this reply sent automatically",
                "user": dummyUserOne,
              },
            ]
          },
          "user": dummyUserTwo,
        },
      ],
    },
    "forum_likes": {
      "total": 1,
      "likes": [
        {
          "uid": "b1d0f290-4f38-4821-a4fc-0c6eb7372ede",
          "user": dummyUserTwo,
        }
      ],
    },
    "forum_type": "post",
    "created_at": DateTime.parse('2023-05-31').toString(),
  };

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "comment_paginate": {
      "total": 1,
      "per_page": 1,
      "next_page": 2,
      "prev_page": 1,
      "current_page": 1,
      "next_url": "nextUrl",
      "prev_url": "prevUrl",
    },
    "data": dummyForumDetailBodyJson,
  };
}
