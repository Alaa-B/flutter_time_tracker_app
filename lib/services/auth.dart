import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuth {
  UserAuth({
    required this.uid,
    this.photoURL,
    this.displayName,
  });

  final String? uid;
  final String? photoURL;
  final String? displayName;
}

abstract class AuthBase {
  Stream<UserAuth>? get onStateChange;

  Future<UserAuth> currentUser();

  Future<UserAuth> signInWithGoogle();

  Future<UserAuth> signInWithFacebook();

  Future<UserAuth>? signInWithEmailAndPassword(String? email, String? password);

  Future<UserAuth>? createUserWithEmailAndPassword(
      String? email, String? password);

  Future<UserAuth> signInAnonymously();

  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  UserAuth _userFromFirebase(User? user) {
    return UserAuth(
        uid: user?.uid,
        photoURL: user?.photoURL,
        displayName: user?.displayName);
  }

  @override
  Stream<UserAuth>? get onStateChange {
    return _firebaseAuth
        .authStateChanges()
        .map((user) => _userFromFirebase(user));
  }

  @override
  Future<UserAuth> currentUser() async {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<UserAuth> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.idToken,
          ),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'missing google auth token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'signIn aborted by user',
      );
    }
  }

  @override
  Future<UserAuth> signInWithFacebook() async {
    final facebookLogIn = FacebookLogin();
    final result = await facebookLogIn.logIn();
    if (result.status == FacebookLoginStatus.success) {
      final FacebookAccessToken? accessToken = result.accessToken;
      final authResult = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(accessToken!.token));
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'signIn aborted by user',
      );
    }
  }

  @override
  Future<UserAuth> signInWithEmailAndPassword(
      String? email, String? password) async {
    final user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email ?? "", password: password ?? "");
    return _userFromFirebase(user.user);
  }

  @override
  Future<UserAuth> createUserWithEmailAndPassword(
      String? email, String? password) async {
    final user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email ?? "", password: password ?? "");
    return _userFromFirebase(user.user);
  }

  @override
  Future<UserAuth> signInAnonymously() async {
    final user = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(user.user);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogIn = FacebookLogin();
    await facebookLogIn.logOut();
  }
}
