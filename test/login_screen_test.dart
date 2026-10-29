import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:career_swipe_ai/presentation/screens/auth/login_screen.dart';
import 'package:career_swipe_ai/presentation/widgets/common/animated_background.dart';

void main() {
  setUpAll(() {
    AnimatedBackground.debugDisableAnimations = true;
  });

  group('LoginScreen Widget Tests', () {
    testWidgets('renders login form elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify form elements exist
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to continue your career journey'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('validates email field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Try to submit with empty fields
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Should show validation error
      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('validates password field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Enter email but no password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Should show password validation error
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('shows forgot password link', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Forgot Password?'), findsOneWidget);
    });
  });
}
