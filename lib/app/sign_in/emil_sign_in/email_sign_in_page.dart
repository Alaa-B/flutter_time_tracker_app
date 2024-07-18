import 'package:flutter/material.dart';
import 'email_sign_in_form_change_notifier.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Sign In',
          textAlign: TextAlign.center,
        ),
        elevation: 3.0,
      ),
      body: EmailSignInFormChangeNotifier.create(context),
    );
  }
}
