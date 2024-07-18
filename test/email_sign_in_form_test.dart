import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:flutter_time_tracker_app/app/sign_in/emil_sign_in/email_sign_in_form_stateful.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';

class MockAuth extends Mock implements AuthBase {}

void main() {
  MockAuth mockAuth;

  setUp(() {
    mockAuth = MockAuth();
  });
  mockAuth = MockAuth();
  Future<void> pumpEmailSignInForm(WidgetTester tester,
      [VoidCallback? onSignedIn]) async {
    return tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: Scaffold(
            body: EmailSignInFormStateful(
              onSignedIn: onSignedIn,
            ),
          ),
        ),
      ),
    );
  }

  void stubSignInWithEmailAndPasswordSucceeds() {
    when(mockAuth.signInWithEmailAndPassword(any, any))
        .thenAnswer((_) => Future<UserAuth>.value(UserAuth(uid: 'abc')));
  }

  void stubSignInWithEmailAndPasswordThrew() {
    when(mockAuth.signInWithEmailAndPassword(any, any))
        .thenThrow(FirebaseException(plugin: '', code: 'ERROR_WRONG_PASSWORD'));
  }

  group('sign in', () {
    testWidgets('sign in with empty email & password',
        (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, () => signedIn = true);
      final signInButton = find.text('Sign In');
      await tester.tap(signInButton);
      verifyNever(mockAuth.signInWithEmailAndPassword('', ''));
      expect(signedIn, false);
    });

    testWidgets('sign in with email & password', (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, () => signedIn = true);
      stubSignInWithEmailAndPasswordSucceeds();
      const email = 'email@email.com';
      const password = 'password';

      final emailField = find.byKey(const Key('email'));
      expect(emailField, findsOneWidget);

      final passwordField = find.byKey(const Key('password'));
      expect(passwordField, findsOneWidget);

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.pump();

      final signInButton = find.text('Sign In');
      await tester.tap(signInButton);
      verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
      expect(signedIn, true);
    });

    testWidgets('sign in with wrong email & password',
        (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, () => signedIn = true);
      stubSignInWithEmailAndPasswordThrew();
      const email = 'email@email.com';
      const password = 'password';

      final emailField = find.byKey(const Key('email'));
      expect(emailField, findsOneWidget);

      final passwordField = find.byKey(const Key('password'));
      expect(passwordField, findsOneWidget);

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.pump();

      final signInButton = find.text('Sign In');
      await tester.tap(signInButton);
      verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
      expect(signedIn, false);
    });
  });

  void stubRegisterSucceeds() {
    when(mockAuth.createUserWithEmailAndPassword(any, any))
        .thenAnswer((_) => Future<UserAuth>.value(UserAuth(uid: 'abc')));
  }

  void stubRegisterFailed() {
    when(mockAuth.createUserWithEmailAndPassword(any, any))
        .thenThrow(FirebaseException(plugin: '', code: 'invalid-email'));
  }

  group('createAccountButton', () {
    testWidgets('createAccountButton with empty email & password',
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      final registerButton = find.byType(TextButton);
      expect(registerButton, findsOneWidget);
      await tester.tap(registerButton);
      await tester.pump();

      final crateAccountButton = find.byType(ElevatedButton);
      expect(crateAccountButton, findsOneWidget);

      await tester.tap(crateAccountButton);
      verifyNever(mockAuth.createUserWithEmailAndPassword(any, any));
    });

    testWidgets('createAccountButton with email & password',
        (WidgetTester tester) async {
      bool registered = false;

      await pumpEmailSignInForm(tester, () => registered = true);
      stubRegisterSucceeds();
      await tester.pump();

      final registerButton = find.text('Need An Account ,Register');
      expect(registerButton, findsOneWidget);
      await tester.tap(registerButton);
      await tester.pump();

      const email = 'email@email.com';
      const password = 'password';

      final emailField = find.byKey(const Key('email'));
      expect(emailField, findsOneWidget);

      final passwordField = find.byKey(const Key('password'));
      expect(passwordField, findsOneWidget);

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.pump();

      final createAccountButton = find.text('Create An Account');
      await tester.tap(createAccountButton);
      verify(mockAuth.createUserWithEmailAndPassword(email, password))
          .called(1);
      expect(registered, true);
    });

    testWidgets('createAccountButton with email & password',
        (WidgetTester tester) async {
      bool registered = false;
      await pumpEmailSignInForm(tester, () => registered = true);

      stubRegisterFailed();
      await tester.pump();

      final registerButton = find.text('Need An Account ,Register');
      expect(registerButton, findsOneWidget);
      await tester.tap(registerButton);
      await tester.pump();

      const email = 'email@email.com';
      const password = 'password';

      final emailField = find.byKey(const Key('email'));
      expect(emailField, findsOneWidget);

      final passwordField = find.byKey(const Key('password'));
      expect(passwordField, findsOneWidget);

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.pump();

      final createAccountButton = find.text('Create An Account');
      await tester.tap(createAccountButton);
      verify(mockAuth.createUserWithEmailAndPassword(email, password))
          .called(1);
      expect(registered, false);
    });
  });
}
