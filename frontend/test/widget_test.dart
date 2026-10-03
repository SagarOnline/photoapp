// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photoapp/features/auth/providers/auth_status_provider.dart';
import 'package:photoapp/main.dart';

class FakeAuthStatus extends AuthStatus {
  @override
  bool get isAuthenticated => false;
}

void main() {
  testWidgets('unauthenticated users see all sign-in options', (
    WidgetTester tester,
  ) async {
    final authStatus = FakeAuthStatus();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authStatusProvider.overrideWithValue(authStatus)],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Continue with Phone Number'), findsOneWidget);
    expect(find.text('Continue with Email'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Apple'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    authStatus.dispose();
  });

  testWidgets('tapping email sign-in opens the email OTP flow', (
    WidgetTester tester,
  ) async {
    final authStatus = FakeAuthStatus();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authStatusProvider.overrideWithValue(authStatus)],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue with Email'));
    await tester.pumpAndSettle();

    expect(find.text('Sign in with email'), findsOneWidget);
    expect(find.text('Send code'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    authStatus.dispose();
  });
}
