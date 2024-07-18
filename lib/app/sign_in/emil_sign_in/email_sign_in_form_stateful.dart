import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/widgets/platform_exception_alert_dialog.dart';

import '/services/auth.dart';
import '/widgets/form_submit_button.dart';
import 'email_sign_in_model.dart';
import 'validator.dart';

class EmailSignInFormStateful extends StatefulWidget
    with EmailAndPasswordValidator {
  EmailSignInFormStateful({super.key, this.onSignedIn});
  final VoidCallback? onSignedIn;

  @override
  State<EmailSignInFormStateful> createState() =>
      _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;

  String get _password => _passwordController.text;
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      if (widget.onSignedIn != null) {
        widget.onSignedIn!();
      }
    } on FirebaseException catch (e) {
      if (!mounted) return;

      PlatformExceptionAlertDialog(
        title: 'Failed To Sign In',
        firebaseException: e,
      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void toggleFormType() {
    setState(() {
      _submitted = false;
      _formType == EmailSignInFormType.signIn
          ? _formType = EmailSignInFormType.register
          : _formType = EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create An Account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need An Account ,Register'
        : 'have An Account ,Sign In';

    bool submitEnable = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        _isLoading == false;

    return [
      _buildEmailTextField(),
      const SizedBox(height: 8),
      _buildPasswordTextField(),
      const SizedBox(height: 12),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnable ? _submit : null,
      ),
      TextButton(
        onPressed: !_isLoading ? toggleFormType : null,
        child: Text(
          secondaryText,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      )
    ];
  }

  void _emailEditingComplete() {
    final nextFocusNode = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(nextFocusNode);
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      key: const Key('email'),
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Email@email.com',
        errorText: showErrorText ? widget.emailIsNotValid : null,
        enabled: _isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: _emailEditingComplete,
      onChanged: (email) => updateState(),
    );
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      key: const Key('password'),
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.passwordIsNotValid : null,
        enabled: _isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onChanged: (password) => updateState(),
      onEditingComplete: _submit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildChildren(),
          ),
        ),
      ),
    );
  }

  void updateState() {
    // debugPrint('email: $_email ,password: $_password');
    setState(() {});
  }
}
