abstract class StringValidator {
  bool isValid(String? value);
}

class NonEmptyStringValidator extends StringValidator {
  @override
  bool isValid(String? value) {
    if (value == null ){
      return false;
    }
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidator {
  final  emailValidator = NonEmptyStringValidator();
  final  passwordValidator = NonEmptyStringValidator();
  final String emailIsNotValid = 'email can\'t be empty';
  final String passwordIsNotValid = 'password can\'t be empty';

}
