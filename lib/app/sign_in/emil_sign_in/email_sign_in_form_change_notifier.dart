import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'email_sign_in_change_model.dart';
import '../../../widgets/platform_exception_alert_dialog.dart';
import '../../../services/auth.dart';
import '../../../widgets/form_submit_button.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  const EmailSignInFormChangeNotifier({super.key, required this.model});

  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);

    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (context) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, _) =>
            EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  State<EmailSignInFormChangeNotifier> createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  EmailSignInChangeModel get model => widget.model;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      if (!mounted) return;

      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Failed To Sign In',
        firebaseException: e,
      ).show(context);
    }
  }

  void toggleFormType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      const SizedBox(height: 8),
      _buildPasswordTextField(),
      const SizedBox(height: 12),
      FormSubmitButton(
        text: model.primaryTextButton,
        onPressed: model.submitEnable ? _submit : null,
      ),
      TextButton(
        onPressed: !model.isLoading ? toggleFormType : null,
        child: Text(
          model.secondaryTextButton,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      )
    ];
  }

  void _emailEditingComplete() {
    final nextFocusNode = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(nextFocusNode);
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Email@email.com',
        errorText: model.showEmailErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: _emailEditingComplete,
      onChanged: (email) => model.updateWith(email: email),
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.showPasswordErrorText,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onChanged: (password) => model.updateWith(password: password),
      onEditingComplete: _submit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: _buildChildren(),
    );
  }
}
