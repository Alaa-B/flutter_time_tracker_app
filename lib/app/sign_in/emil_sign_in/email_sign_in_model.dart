import 'validator.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidator {
  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;

  EmailSignInModel({
    this.isLoading = false,
    this.submitted = false,
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
  });

  String get primaryTextButton {
    return formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create An Account';
  }

  String get secondaryTextButton {
    return formType == EmailSignInFormType.signIn
        ? 'Need An Account ,Register'
        : 'have An Account ,Sign In';
  }

  bool get submitEnable {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        isLoading == false;
  }

  String? get showEmailErrorText {
    bool canSubmit = submitted && !emailValidator.isValid(email);
    return canSubmit ? emailIsNotValid : null;
  }

  String? get showPasswordErrorText {
    bool canSubmit = submitted && !emailValidator.isValid(password);
    return canSubmit ? passwordIsNotValid : null;
  }

  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
