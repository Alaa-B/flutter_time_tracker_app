import 'package:flutter/material.dart';
import 'validator.dart';

import '../../../services/auth.dart';
import 'email_sign_in_model.dart';

class EmailSignInChangeModel with EmailAndPasswordValidator, ChangeNotifier {
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;
  final AuthBase auth;

  EmailSignInChangeModel({
    this.isLoading = false,
    this.submitted = false,
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    required this.auth,
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

  void updatePassword(String? password) => updateWith(password: password);

  void updateEmail(String? email) => updateWith(password: email);

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;

    updateWith(
        submitted: false,
        isLoading: false,
        email: "",
        password: "",
        formType: formType);
  }

  Future<void> submit() async {
    updateWith(
      submitted: true,
      isLoading: true,
    );
    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
