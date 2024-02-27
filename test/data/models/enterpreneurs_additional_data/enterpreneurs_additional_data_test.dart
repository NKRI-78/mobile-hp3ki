import 'package:flutter_test/flutter_test.dart';
import 'package:hp3ki/data/models/enterpreneurs_additional_data/business.dart';
import 'package:hp3ki/data/models/enterpreneurs_additional_data/classifications.dart';
import '../../dummy_data/enterpreneurs_additional_data/mock_business.dart';
import '../../dummy_data/enterpreneurs_additional_data/mock_classifications.dart';

void main() {
  group("Test BusinessData initialization from json", () {
    late Map<String, dynamic> apiBusinessAsJson;
    late BusinessData expectedApiBusiness;

    setUp(() {
      apiBusinessAsJson = MockBusiness.dummyBusinessJson;
      expectedApiBusiness = MockBusiness.expectedBusinessData;
    });

    test('should be an Business data', () {
      //act
      var result = BusinessData.fromJson(apiBusinessAsJson);
      //assert
      expect(result, isA<BusinessData>());
    });

    test('should not be an Business model', () {
      //act
      var result = BusinessData.fromJson(apiBusinessAsJson);
      //assert
      expect(result, isNot(BusinessModel()));
    });

    test('result should be as expected', () {
      //act
      var result = BusinessData.fromJson(apiBusinessAsJson);
      //assert
      expect(result, expectedApiBusiness);
    });
  });

  group("Test ClassificationData initialization from json", () {
    late Map<String, dynamic> apiClassificationAsJson;
    late ClassificationData expectedApiClassification;

    setUp(() {
      apiClassificationAsJson = MockClassification.dummyClassificationJson;
      expectedApiClassification = MockClassification.expectedClassificationData;
    });

    test('should be an Classification data', () {
      //act
      var result = ClassificationData.fromJson(apiClassificationAsJson);
      //assert
      expect(result, isA<ClassificationData>());
    });

    test('should not be an Classification model', () {
      //act
      var result = ClassificationData.fromJson(apiClassificationAsJson);
      //assert
      expect(result, isNot(ClassificationModel()));
    });

    test('result should be as expected', () {
      //act
      var result = ClassificationData.fromJson(apiClassificationAsJson);
      //assert
      expect(result, expectedApiClassification);
    });
  });
}
