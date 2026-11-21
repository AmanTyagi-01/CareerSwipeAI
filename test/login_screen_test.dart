import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:career_swipe_ai/presentation/screens/auth/login_screen.dart';
import 'package:career_swipe_ai/theme/editorial_theme.dart';

void main() {
  setUpAll(() {
    EditorialTypography.debugDisableGoogleFonts = true;
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

      // Editorial screen: "CareerSwipe AI" header + stat row
      expect(find.text('CareerSwipe AI'), findsOneWidget);
      // Google Workspace sign-in button
      expect(find.text('Continue with Google Workspace'), findsOneWidget);
      // Work email section divider
      expect(find.text('OR SIGN IN WITH WORK EMAIL'), findsOneWidget);
      // Two TextFormFields (email + password)
      expect(find.byType(TextFormField), findsNWidgets(2));
      // Submit button
      expect(find.text('Unlock Career Dossier'), findsOneWidget);
      // Link to sign up
      expect(find.text('Create candidate account'), findsOneWidget);
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

      // Try to submit with empty fields using the editorial button label
      await tester.tap(find.text('Unlock Career Dossier'));
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
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.tap(find.text('Unlock Career Dossier'));
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

      expect(find.text('Forgot password?'), findsOneWidget);
    });
  });
}
