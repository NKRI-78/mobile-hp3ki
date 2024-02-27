import 'package:flutter_test/flutter_test.dart';
import 'package:hp3ki/data/models/job/job.dart';

import '../../dummy_data/job/mock_job.dart';

void main() {
  group("Test JobData initialization from json", () {
    late Map<String, dynamic> apiJobAsJson;
    late JobData expectedApiJob;

    setUp(() {
      apiJobAsJson = MockJob.dummyJobJson;
      expectedApiJob = MockJob.expectedJobData;
    });

    test('should be an Job data', () {
      //act
      var result = JobData.fromJson(apiJobAsJson);
      //assert
      expect(result, isA<JobData>());
    });

    test('should not be an Job model', () {
      //act
      var result = JobData.fromJson(apiJobAsJson);
      //assert
      expect(result, isNot(JobModel()));
    });

    test('result should be as expected', () {
      //act
      var result = JobData.fromJson(apiJobAsJson);
      //assert
      expect(result, expectedApiJob);
    });
  });
}
