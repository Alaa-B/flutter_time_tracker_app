import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/app/sign_in/sign_in_bloc.dart';
import '/services/auth.dart';
import '/widgets/platform_exception_alert_dialog.dart';
import 'emil_sign_in/email_sign_in_page.dart';
import 'sign_in_button.dart';
import 'social_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({
    super.key,
    required this.manger,
    required this.isLoading,
  });
  final SignInManger manger;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManger>(
          create: (_) => SignInManger(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManger>(
            builder: (BuildContext context, manger, _) =>
                SignInPage(manger: manger, isLoading: isLoading.value),
          ),
        ),
      ),
    );
  }

  void signInError(
    BuildContext context, {
    FirebaseException? firebaseException,
    PlatformException? platformException,
  }) {
    PlatformExceptionAlertDialog(
      title: 'sign in failed',
      firebaseException: firebaseException,
      platformException: platformException,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manger.signInAnonymously();
    } on FirebaseException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Failed To Sign In',
        firebaseException: e,
      );
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manger.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != "ERROR_ABORTED_BY_USER") {
        if (!context.mounted) return;
        signInError(
          context,
          platformException: e,
        );
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manger.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != "ERROR_ABORTED_BY_USER") {
        if (!context.mounted) return;
        signInError(
          context,
          platformException: e,
        );
      }
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) => const EmailSignInPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Time Tracker',
          textAlign: TextAlign.center,
        ),
        elevation: 3.0,
      ),
      body: _myBody(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _myBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(
            height: 26,
          ),
          SocialSignInButton(
            assetText: 'images/google-logo.png',
            text: 'SignIn with Google',
            color: Colors.white70,
            textColor: Colors.black87,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          const SizedBox(
            height: 8,
          ),
          SocialSignInButton(
            assetText: 'images/facebook-logo.png',
            color: const Color(0xff334d92),
            text: 'Sign In With facebook',
            textColor: Colors.black87,
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          const SizedBox(
            height: 8,
          ),
          SignInButton(
            key: const Key('sign_in_button'),
            color: Colors.teal[700],
            text: 'Sign In With Email',
            textColor: Colors.white,
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'or',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(
            height: 8,
          ),
          SignInButton(
            color: Colors.lime,
            text: 'Go Anonymous',
            textColor: Colors.black87,
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return (isLoading)
        ? const SizedBox(
            height: 40,
            width: 40,
            child: Center(child: CircularProgressIndicator()),
          )
        : const Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          );
  }
}
