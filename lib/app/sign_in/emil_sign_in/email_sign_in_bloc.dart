import 'dart:async';

import 'package:rxdart/rxdart.dart';
import '/services/auth.dart';
import 'email_sign_in_model.dart';

class EmailSignInBloc {
  final AuthBase auth;

  EmailSignInBloc({required this.auth});

  final _modelSubject =
      BehaviorSubject<EmailSignInModel>.seeded(EmailSignInModel());

  // final StreamController<EmailSignInModel> _modelController =
  //     StreamController<EmailSignInModel>();

  // Stream<EmailSignInModel> get modelStream => _modelController.stream;

  Stream<EmailSignInModel> get modelStream => _modelSubject.stream;

  // EmailSignInModel _model = EmailSignInModel();
  EmailSignInModel get _model => _modelSubject.value;
  void dispose() {
    // _modelController.close();
    _modelSubject.close();
  }

  void updateModel({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    //update model
    _modelSubject.add(_model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    ));
    //add updated model to modelController
    // _modelController.add(_model);
  }

  void updateEmail(String? email) => updateModel(password: email);

  void updatePassword(String? password) => updateModel(password: password);

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;

    updateModel(
        submitted: false,
        isLoading: false,
        email: "",
        password: "",
        formType: formType);
  }

  Future<void> submit() async {
    updateModel(
      submitted: true,
      isLoading: true,
    );
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {
      updateModel(isLoading: false);
      rethrow;
    }
  }
}
