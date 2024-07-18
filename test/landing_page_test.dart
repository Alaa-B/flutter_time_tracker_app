import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:flutter_time_tracker_app/app/home/home_page.dart';
import 'package:flutter_time_tracker_app/app/landing_page.dart';
import 'package:flutter_time_tracker_app/app/sign_in/sign_in_page.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';

class MockAuth extends Mock implements AuthBase {}

void main() {
  MockAuth mockAuth;
  StreamController<UserAuth> onAuthStateChangeStreamController;

  setUp(() {
    mockAuth = MockAuth();
    onAuthStateChangeStreamController = StreamController<UserAuth>();
  });
  mockAuth = MockAuth();
  onAuthStateChangeStreamController = StreamController<UserAuth>();
  tearDown(() {
    onAuthStateChangeStreamController.close();
  });
  Future<void> pumpLandingPage(WidgetTester tester) async {
    return tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: const MaterialApp(home: LandingPage()),
      ),
    );
  }

  void stubOnAuthStateChanged(Iterable<UserAuth>? onAuthChanged) {
    onAuthStateChangeStreamController
        .addStream(Stream<UserAuth>.fromIterable(onAuthChanged ?? []));
    when(mockAuth.onStateChange).thenAnswer((_) {
      return onAuthStateChangeStreamController.stream;
    });
  }

  group('Landing page stream test', () {
    testWidgets('waiting stream', (WidgetTester tester) async {
      stubOnAuthStateChanged([]);
      await pumpLandingPage(tester);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    testWidgets('null user', (WidgetTester tester) async {
      stubOnAuthStateChanged([UserAuth(uid: null)]);
      await pumpLandingPage(tester);
      await tester.pump();
      expect(find.byType(SignInPage), findsOneWidget);
    });
    testWidgets('active user', (WidgetTester tester) async {
      stubOnAuthStateChanged([UserAuth(uid: 'abc')]);
      await pumpLandingPage(tester);
      await tester.pump();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
