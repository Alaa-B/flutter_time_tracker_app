import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_time_tracker_app/app/home/models/job.dart';

void main() {
  group('job', () {
    test('job with data', () {
      final job = Job.fromMap({
        'name': 'typing',
        'ratePerHour': 20,
      }, 'abc');
      expect(job.name, 'typing');
      expect(job.ratePerHour, 20);
      expect(job.id, 'abc');
    });
  });
}
