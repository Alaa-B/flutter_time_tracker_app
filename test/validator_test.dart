import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_time_tracker_app/app/sign_in/emil_sign_in/validator.dart';

void main() {
  test('String not empty', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid('test'), true);
  });
  test('String is empty', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(''), false);
  });
  test('String is null', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(null), false);
  });
}
