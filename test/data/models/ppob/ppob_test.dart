import 'package:flutter_test/flutter_test.dart';
import 'package:hp3ki/data/models/ppob_v2/denom_pulsa.dart';
import 'package:hp3ki/data/models/ppob_v2/payment_guide.dart';
import 'package:hp3ki/data/models/ppob_v2/payment_list.dart';
import 'package:hp3ki/data/models/ppob_v2/pln/inquiry_pasca.dart';
import 'package:hp3ki/data/models/ppob_v2/pln/inquiry_pra.dart';
import 'package:hp3ki/data/models/ppob_v2/pln/list_price_pra.dart';
import 'package:hp3ki/data/models/ppob_v2/wallet_balance.dart';
import 'package:hp3ki/data/models/ppob_v2/wallet_denom.dart';

import '../../dummy_data/ppob/mock_denom_pulsa.dart';
import '../../dummy_data/ppob/mock_payment_guide.dart';
import '../../dummy_data/ppob/mock_payment_list.dart';
import '../../dummy_data/ppob/mock_wallet_balance.dart';
import '../../dummy_data/ppob/mock_wallet_denom.dart';
import '../../dummy_data/ppob/pln/mock_inquiry_pasca.dart';
import '../../dummy_data/ppob/pln/mock_inquiry_pra.dart';
import '../../dummy_data/ppob/pln/mock_list_price_pra.dart';

void main() {
  group("Test WalletDenomData initialization from json", () {
    late Map<String, dynamic> apiWalletDenomAsJson;
    late WalletDenomData expectedApiWalletDenom;

    setUp(() {
      apiWalletDenomAsJson = MockWalletDenom.dummyWalletDenomJson;
      expectedApiWalletDenom = MockWalletDenom.expectedWalletDenomData;
    });

    test('should be an WalletDenom data', () {
      //act
      var result = WalletDenomData.fromJson(apiWalletDenomAsJson);
      //assert
      expect(result, isA<WalletDenomData>());
    });

    test('should not be an WalletDenom model', () {
      //act
      var result = WalletDenomData.fromJson(apiWalletDenomAsJson);
      //assert
      expect(result, isNot(WalletDenomModel()));
    });

    test('result should be as expected', () {
      //act
      var result = WalletDenomData.fromJson(apiWalletDenomAsJson);
      //assert
      expect(result, expectedApiWalletDenom);
    });
  });

  group("Test WalletBalanceData initialization from json", () {
    late Map<String, dynamic> apiWalletBalanceAsJson;
    late WalletBalanceData expectedApiWalletBalance;

    setUp(() {
      apiWalletBalanceAsJson = MockWalletBalance.dummyWalletBalanceJson;
      expectedApiWalletBalance = MockWalletBalance.expectedWalletBalanceData;
    });

    test('should be an WalletBalance data', () {
      //act
      var result = WalletBalanceData.fromJson(apiWalletBalanceAsJson);
      //assert
      expect(result, isA<WalletBalanceData>());
    });

    test('should not be an WalletBalance model', () {
      //act
      var result = WalletBalanceData.fromJson(apiWalletBalanceAsJson);
      //assert
      expect(result, isNot(WalletBalanceModel()));
    });

    test('result should be as expected', () {
      //act
      var result = WalletBalanceData.fromJson(apiWalletBalanceAsJson);
      //assert
      expect(result, expectedApiWalletBalance);
    });
  });

  group("Test PaymentListData initialization from json", () {
    late Map<String, dynamic> apiPaymentListAsJson;
    late PaymentListData expectedApiPaymentList;

    setUp(() {
      apiPaymentListAsJson = MockPaymentList.dummyPaymentListJson;
      expectedApiPaymentList = MockPaymentList.expectedPaymentListData;
    });

    test('should be an PaymentList data', () {
      //act
      var result = PaymentListData.fromJson(apiPaymentListAsJson);
      //assert
      expect(result, isA<PaymentListData>());
    });

    test('should not be an PaymentList model', () {
      //act
      var result = PaymentListData.fromJson(apiPaymentListAsJson);
      //assert
      expect(result, isNot(PaymentListModel()));
    });

    test('result should be as expected', () {
      //act
      var result = PaymentListData.fromJson(apiPaymentListAsJson);
      //assert
      expect(result, expectedApiPaymentList);
    });
  });

  group("Test DenomPulsaData initialization from json", () {
    late Map<String, dynamic> apiDenomPulsaAsJson;
    late DenomPulsaData expectedApiDenomPulsa;

    setUp(() {
      apiDenomPulsaAsJson = MockDenomPulsa.dummyDenomPulsaJson;
      expectedApiDenomPulsa = MockDenomPulsa.expectedDenomPulsaData;
    });

    test('should be an DenomPulsa data', () {
      //act
      var result = DenomPulsaData.fromJson(apiDenomPulsaAsJson);
      //assert
      expect(result, isA<DenomPulsaData>());
    });

    test('should not be an DenomPulsa model', () {
      //act
      var result = DenomPulsaData.fromJson(apiDenomPulsaAsJson);
      //assert
      expect(result, isNot(DenomPulsaModel()));
    });

    test('result should be as expected', () {
      //act
      var result = DenomPulsaData.fromJson(apiDenomPulsaAsJson);
      //assert
      expect(result, expectedApiDenomPulsa);
    });
  });

  group("Test InquiryPLNPrabayarData initialization from json", () {
    late Map<String, dynamic> apiInquiryPLNPrabayarAsJson;
    late InquiryPLNPrabayarData expectedApiInquiryPLNPrabayar;

    setUp(() {
      apiInquiryPLNPrabayarAsJson = MockInquiryPLNPraBayar.dummyInquiryPLNPrabayarJson;
      expectedApiInquiryPLNPrabayar = MockInquiryPLNPraBayar.expectedInquiryPLNPrabayarData;
    });

    test('should be an InquiryPLNPrabayar data', () {
      //act
      var result = InquiryPLNPrabayarData.fromJson(apiInquiryPLNPrabayarAsJson);
      //assert
      expect(result, isA<InquiryPLNPrabayarData>());
    });

    test('should not be an InquiryPLNPrabayar model', () {
      //act
      var result = InquiryPLNPrabayarData.fromJson(apiInquiryPLNPrabayarAsJson);
      //assert
      expect(result, isNot(InquiryPLNPrabayarModel()));
    });

    test('result should be as expected', () {
      //act
      var result = InquiryPLNPrabayarData.fromJson(apiInquiryPLNPrabayarAsJson);
      //assert
      expect(result, expectedApiInquiryPLNPrabayar);
    });
  });

  group("Test InquiryPLNPascaBayarData initialization from json", () {
    late Map<String, dynamic> apiInquiryPLNPascaBayarAsJson;
    late InquiryPLNPascaBayarData expectedApiInquiryPLNPascaBayar;

    setUp(() {
      apiInquiryPLNPascaBayarAsJson = MockInquiryPLNPascaBayar.dummyInquiryPLNPascaBayarJson;
      expectedApiInquiryPLNPascaBayar = MockInquiryPLNPascaBayar.expectedInquiryPLNPascaBayarData;
    });

    test('should be an InquiryPLNPascaBayar data', () {
      //act
      var result = InquiryPLNPascaBayarData.fromJson(apiInquiryPLNPascaBayarAsJson);
      //assert
      expect(result, isA<InquiryPLNPascaBayarData>());
    });

    test('should not be an InquiryPLNPascabayar model', () {
      //act
      var result = InquiryPLNPascaBayarData.fromJson(apiInquiryPLNPascaBayarAsJson);
      //assert
      expect(result, isNot(InquiryPLNPascabayarModel()));
    });

    test('result should be as expected', () {
      //act
      var result = InquiryPLNPascaBayarData.fromJson(apiInquiryPLNPascaBayarAsJson);
      //assert
      expect(result, expectedApiInquiryPLNPascaBayar);
    });
  });

  group("Test ListPricePraBayarData initialization from json", () {
    late Map<String, dynamic> apiListPricePraBayarAsJson;
    late ListPricePraBayarData expectedApiListPricePraBayar;

    setUp(() {
      apiListPricePraBayarAsJson = MockListPricePraBayar.dummyListPricePraBayarJson;
      expectedApiListPricePraBayar = MockListPricePraBayar.expectedListPricePraBayarData;
    });

    test('should be an ListPricePraBayar data', () {
      //act
      var result = ListPricePraBayarData.fromJson(apiListPricePraBayarAsJson);
      //assert
      expect(result, isA<ListPricePraBayarData>());
    });

    test('should not be an ListPricePraBayar model', () {
      //act
      var result = ListPricePraBayarData.fromJson(apiListPricePraBayarAsJson);
      //assert
      expect(result, isNot(ListPricePraBayarModel()));
    });

    test('result should be as expected', () {
      //act
      var result = ListPricePraBayarData.fromJson(apiListPricePraBayarAsJson);
      //assert
      expect(result, expectedApiListPricePraBayar);
    });
  });

  group("Test PaymentGuideData initialization from json", () {
    late Map<String, dynamic> apiPaymentGuideAsJson;
    late PaymentGuideData expectedApiPaymentGuide;

    setUp(() {
      apiPaymentGuideAsJson = MockPaymentGuide.dummyPaymentGuideJson;
      expectedApiPaymentGuide = MockPaymentGuide.expectedPaymentGuideData;
    });

    test('should be an PaymentGuide data', () {
      //act
      var result = PaymentGuideData.fromJson(apiPaymentGuideAsJson);
      //assert
      expect(result, isA<PaymentGuideData>());
    });

    test('should not be an PaymentGuide model', () {
      //act
      var result = PaymentGuideData.fromJson(apiPaymentGuideAsJson);
      //assert
      expect(result, isNot(PaymentGuideModel()));
    });

    test('result should be as expected', () {
      //act
      var result = PaymentGuideData.fromJson(apiPaymentGuideAsJson);
      //assert
      expect(result, expectedApiPaymentGuide);
    });
  });
}
