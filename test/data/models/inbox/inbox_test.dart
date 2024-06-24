import 'package:flutter_test/flutter_test.dart';
import 'package:hp3ki/data/models/inbox/count.dart';
import 'package:hp3ki/data/models/inbox/inbox.dart';
import 'package:hp3ki/data/models/inbox/inbox_payment.dart';

import '../../dummy_data/inbox/mock_inbox.dart';
import '../../dummy_data/inbox/mock_inbox_count.dart';
import '../../dummy_data/inbox/mock_inbox_payment.dart';

void main() {
  group("Test InboxData initialization from json", () {
    late Map<String, dynamic> apiInboxAsJson;
    late InboxData expectedApiInbox;

    setUp(() {
      apiInboxAsJson = MockInbox.dummyInboxJson;
      expectedApiInbox = MockInbox.expectedInboxData;
    });

    test('should be an Inbox data', () {
      //act
      var result = InboxData.fromJson(apiInboxAsJson);
      //assert
      expect(result, isA<InboxData>());
    });

    test('should not be an Inbox model', () {
      //act
      var result = InboxData.fromJson(apiInboxAsJson);
      //assert
      expect(result, isNot(InboxModel()));
    });

    test('result should be as expected', () {
      //act
      var result = InboxData.fromJson(apiInboxAsJson);
      //assert
      expect(result, expectedApiInbox);
    });
  });

  group("Test InboxPaymentData initialization from json", () {
    late Map<String, dynamic> apiInboxPaymentAsJson;
    late InboxPaymentData expectedApiInboxPayment;

    setUp(() {
      apiInboxPaymentAsJson = MockInboxPayment.dummyInboxPaymentJson;
      expectedApiInboxPayment = MockInboxPayment.expectedInboxPaymentData;
    });

    test('should be an InboxPayment data', () {
      //act
      var result = InboxPaymentData.fromJson(apiInboxPaymentAsJson);
      //assert
      expect(result, isA<InboxPaymentData>());
    });

    test('should not be an InboxPayment model', () {
      //act
      var result = InboxPaymentData.fromJson(apiInboxPaymentAsJson);
      //assert
      expect(result, isNot(InboxPaymentModel()));
    });

    test('result should be as expected', () {
      //act
      var result = InboxPaymentData.fromJson(apiInboxPaymentAsJson);
      //assert
      expect(result, expectedApiInboxPayment);
    });
  });

  group("Test InboxCountData initialization from json", () {
    late Map<String, dynamic> apiInboxCountAsJson;
    late InboxCountData expectedApiInboxCount;

    setUp(() {
      apiInboxCountAsJson = MockInboxCount.dummyInboxCountJson;
      expectedApiInboxCount = MockInboxCount.expectedInboxCountData;
    });

    test('should be an InboxCount data', () {
      //act
      var result = InboxCountData.fromJson(apiInboxCountAsJson);
      //assert
      expect(result, isA<InboxCountData>());
    });

    test('should not be an InboxCount model', () {
      //act
      var result = InboxCountData.fromJson(apiInboxCountAsJson);
      //assert
      expect(result, isNot(InboxCountModel()));
    });

    test('result should be as expected', () {
      //act
      var result = InboxCountData.fromJson(apiInboxCountAsJson);
      //assert
      expect(result, expectedApiInboxCount);
    });
  });

  group("Test InboxCountPaymentData initialization from json", () {
    late Map<String, dynamic> apiInboxCountPaymentAsJson;
    late InboxCountPaymentData expectedApiInboxCountPayment;

    setUp(() {
      apiInboxCountPaymentAsJson = MockInboxCountPayment.dummyInboxCountPaymentJson;
      expectedApiInboxCountPayment = MockInboxCountPayment.expectedInboxCountPaymentData;
    });

    test('should be an InboxCountPayment data', () {
      //act
      var result = InboxCountPaymentData.fromJson(apiInboxCountPaymentAsJson);
      //assert
      expect(result, isA<InboxCountPaymentData>());
    });

    test('should not be an InboxCountPayment model', () {
      //act
      var result = InboxCountPaymentData.fromJson(apiInboxCountPaymentAsJson);
      //assert
      expect(result, isNot(InboxCountModel()));
    });

    test('result should be as expected', () {
      //act
      var result = InboxCountPaymentData.fromJson(apiInboxCountPaymentAsJson);
      //assert
      expect(result, expectedApiInboxCountPayment);
    });
  });
}
