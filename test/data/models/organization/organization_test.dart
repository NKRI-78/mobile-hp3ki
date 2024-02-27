import 'package:flutter_test/flutter_test.dart';
import 'package:hp3ki/data/models/organization/organization.dart';

import '../../dummy_data/organization/mock_organization.dart';

void main() {
  group("Test OrganizationData initialization from json", () {
    late Map<String, dynamic> apiOrganizationAsJson;
    late OrganizationData expectedApiOrganization;

    setUp(() {
      apiOrganizationAsJson = MockOrganization.dummyOrganizationJson;
      expectedApiOrganization = MockOrganization.expectedOrganizationData;
    });

    test('should be an Organization data', () {
      //act
      var result = OrganizationData.fromJson(apiOrganizationAsJson);
      //assert
      expect(result, isA<OrganizationData>());
    });

    test('should not be an Organization model', () {
      //act
      var result = OrganizationData.fromJson(apiOrganizationAsJson);
      //assert
      expect(result, isNot(OrganizationModel()));
    });

    test('result should be as expected', () {
      //act
      var result = OrganizationData.fromJson(apiOrganizationAsJson);
      //assert
      expect(result, expectedApiOrganization);
    });
  });
}
