import 'package:hp3ki/data/models/organization/organization.dart';

class MockOrganization {
  static const OrganizationData expectedOrganizationData = OrganizationData(
    id: "addcbeaa-ae74-450e-a396-9b00c91474ab",
    name: "Expected Organization",
    createdAt: "26 May 2023",
  );

  static final Map<String, dynamic> dummyOrganizationJson =
      expectedOrganizationData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": [dummyOrganizationJson],
  };
}
