import 'package:flutter_test/flutter_test.dart';
import 'package:hp3ki/data/models/upgrade_member/payment_channel.dart';
import 'package:hp3ki/data/models/upgrade_member/inquiry.dart';
import '../../dummy_data/upgrade_member/mock_payment_channel.dart';
import '../../dummy_data/upgrade_member/mock_inquiry.dart';

void main() {
  group("Test PaymentChannelData initialization from json", () {
    late Map<String, dynamic> apiPaymentChannelAsJson;
    late PaymentChannelData expectedApiPaymentChannel;

    setUp(() {
      apiPaymentChannelAsJson = MockPaymentChannel.dummyPaymentChannelJson;
      expectedApiPaymentChannel = MockPaymentChannel.expectedPaymentChannelData;
    });

    test('should be an PaymentChannel data', () {
      //act
      var result = PaymentChannelData.fromJson(apiPaymentChannelAsJson);
      //assert
      expect(result, isA<PaymentChannelData>());
    });

    test('should not be an PaymentChannel model', () {
      //act
      var result = PaymentChannelData.fromJson(apiPaymentChannelAsJson);
      //assert
      expect(result, isNot(PaymentChannelModel()));
    });

    test('result should be as expected', () {
      //act
      var result = PaymentChannelData.fromJson(apiPaymentChannelAsJson);
      //assert
      expect(result, expectedApiPaymentChannel);
    });
  });

  group("Test InquiryData initialization from json", () {
    late Map<String, dynamic> apiInquiryAsJson;
    late InquiryData expectedApiInquiry;

    setUp(() {
      apiInquiryAsJson = MockInquiry.dummyInquiryJson;
      expectedApiInquiry = MockInquiry.expectedInquiryData;
    });

    test('should be an Inquiry data', () {
      //act
      var result = InquiryData.fromJson(apiInquiryAsJson);
      //assert
      expect(result, isA<InquiryData>());
    });

    test('should not be an Inquiry model', () {
      //act
      var result = InquiryData.fromJson(apiInquiryAsJson);
      //assert
      expect(result, isNot(InquiryModel()));
    });

    test('result should be as expected', () {
      //act
      var result = InquiryData.fromJson(apiInquiryAsJson);
      //assert
      expect(result, expectedApiInquiry);
    });
  });
}
