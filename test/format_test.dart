import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_time_tracker_app/app/home/job_entries/format.dart';

void main() {
  group('hours', () {
    test('positive', () {
      expect(Format.hours(10), '10h');
    });
    test('negative', () {
      expect(Format.hours(-10), '0h');
    });
    test('decimal', () {
      expect(Format.hours(15.5), '15.5h');
    });
    test('zero', () {
      expect(Format.hours(0), '0h');
    });
  });
  group('date', () {
    setUp(() async {
      Intl.defaultLocale = 'en_GB';
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('2023-1-19', () {
      expect(Format.date(DateTime(2023, 1, 29)), '29 Jan 2023');
    });
  });
  group('date of the week', () {
    setUp(() {
      Intl.defaultLocale = 'en_GB';
      initializeDateFormatting(Intl.defaultLocale);
    });
    test('sunday', () {
      expect(Format.dayOfWeek(DateTime(2023, 1, 29)), 'Sun');
    });
  });
  group('currency us locale', () {
    setUp(() => Intl.defaultLocale = 'en_US');
    test('positive', () {
      expect(Format.currency(10), '\$10');
    });
    test('negative', () {
      expect(Format.currency(-10), '-\$10');
    });
    test('decimal', () {
      expect(Format.currency(15.5), '\$16');
    });
    test('zero', () {
      expect(Format.currency(0), '');
    });
  });
}
