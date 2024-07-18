import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'email_sign_in_bloc.dart';
import '../../../widgets/platform_exception_alert_dialog.dart';
import '../../../services/auth.dart';
import '../../../widgets/form_submit_button.dart';
import 'email_sign_in_model.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  const EmailSignInFormBlocBased({super.key, required this.bloc});

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) => EmailSignInFormBlocBased(bloc: bloc),
      ),
    );
  }

  @override
  State<EmailSignInFormBlocBased> createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
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
      await widget.bloc.submit();
      if (!mounted) return;
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      if (!context.mounted) return;
      PlatformExceptionAlertDialog(
        title: 'Failed To Sign In',
        firebaseException: e,
      ).show(context);
    }
  }

  void toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      const SizedBox(height: 12.0),
      _buildPasswordTextField(model),
      const SizedBox(height: 12.0),
      FormSubmitButton(
        text: model.primaryTextButton,
        onPressed: model.submitEnable ? _submit : null,
      ),
      const SizedBox(height: 8.0),
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

  void _emailEditingComplete(EmailSignInModel model) {
    final nextFocusNode = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(nextFocusNode);
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
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
      onEditingComplete: () => _emailEditingComplete(model),
      onChanged: (email) => widget.bloc.updateEmail,
    );
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
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
      onChanged: (password) => widget.bloc.updateModel(password: password),
      onEditingComplete: _submit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapShot) {
          final EmailSignInModel model = snapShot.data!;
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(model),
            ),
          );
        });
  }
}
