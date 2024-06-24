import 'package:hp3ki/data/models/job/job.dart';

class MockJob {
  static JobData expectedJobData = const JobData(
      id: "35c57cae-9350-43d0-951a-a519be79f886", name: "Job Data Test");

  static final Map<String, dynamic> dummyJobJson = expectedJobData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": [dummyJobJson],
  };
}
