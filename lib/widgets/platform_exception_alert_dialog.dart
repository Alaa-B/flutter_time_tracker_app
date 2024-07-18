import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '/widgets/platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    super.key,
    required String title,
    FirebaseException? firebaseException,
    PlatformException? platformException,
  }) : super(
          title: title,
          content: _message(
                firebaseException: firebaseException,
                platformException: platformException,
              ) ??
              "some error happened!",
          defaultActionText: 'OK',
        );

  static String? _message({
    FirebaseException? firebaseException,
    PlatformException? platformException,
  }) {
    debugPrint("$firebaseException");
    return (platformException == null)
        ? _errors[firebaseException?.code] ??
            firebaseException?.message ??
            'Error Happened'
        : platformException.message;
  }

  static final Map<String, String> _errors = {
    "invalid-email": "email address isn't valid.",
    "email-already-in-use":
        "already exists an account with the given email address.",
    "operation-not-allowed":
        "email/password accounts are not enabled. Enable email/password accounts in the Firebase Console, under the Auth tab.",
    "weak-password": "the password is not strong enough.",
  };
}
