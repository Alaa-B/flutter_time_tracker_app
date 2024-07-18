import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:flutter_time_tracker_app/app/sign_in/sign_in_page.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';

class MockAuth extends Mock implements AuthBase {}

class MockObserver extends Mock implements NavigatorObserver {}

void main() {
  MockAuth mockAuth;
  MockObserver mockNavigatorObserver;
  setUp(() {
    mockAuth = MockAuth();
    mockNavigatorObserver = MockObserver();
  });
  mockAuth = MockAuth();
  mockNavigatorObserver = MockObserver();

  Future<void> pumpSignInPage(
    WidgetTester tester,
  ) async {
    return tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: Builder(
            builder: (context) => SignInPage.create(context),
          ),
          navigatorObservers: [mockNavigatorObserver],
        ),
      ),
    );
  }

  testWidgets('email & sign in navigation', (WidgetTester tester) async {
    await pumpSignInPage(tester);
    expect(find.byKey(const Key('sign_in_button')), findsOneWidget);
    await tester.tap(find.byKey(const Key('sign_in_button')));
    await tester.pumpAndSettle();
    // verify(mockNavigatorObserver.didPush(any!, any));
  });
}
