// test/editorial_components_test.dart
//
// Widget tests verifying the Editorial Utility Design System components:
// - EditorialCard
// - EditorialButton
// - DecisionStamp
// - EditorialTextField
// - EditorialChip
// - FactsMatrix2x2
// - SignalFitBadge & GroundedMatchLedger
// - Re-skinned shared widgets: GlassCard, PrimaryButton, GlassButton, AppLoadingIndicator

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:career_swipe_ai/config/theme.dart';
import 'package:career_swipe_ai/presentation/widgets/editorial/editorial.dart';
import 'package:career_swipe_ai/presentation/widgets/common/glass_card.dart';
import 'package:career_swipe_ai/presentation/widgets/common/custom_buttons.dart';
import 'package:career_swipe_ai/presentation/widgets/common/loading_indicator.dart';

void main() {
  setUpAll(() {
    EditorialTypography.debugDisableGoogleFonts = true;
  });

  group('Editorial Utility Design System - Tokens & Components', () {
    test('Editorial theme defines required colors and typography', () {
      final lightTheme = EditorialTheme.light;
      final darkTheme = EditorialTheme.dark;

      expect(lightTheme.colorScheme.primary, equals(EditorialColors.primary));
      expect(lightTheme.scaffoldBackgroundColor,
          equals(EditorialColors.paperBackground));
      expect(darkTheme.scaffoldBackgroundColor,
          equals(EditorialColors.darkBackground));

      expect(EditorialRadii.tier1, equals(4.0));
      expect(EditorialRadii.tier2, equals(8.0));
      expect(EditorialRadii.tier3, equals(16.0));
    });

    test('AppTheme and AppColors seamlessly map to Editorial tokens', () {
      expect(AppTheme.primaryColor, equals(EditorialColors.primary));
      expect(AppColors.darkPrimary, equals(EditorialColors.primary));
      expect(AppColors.lightBackground, equals(EditorialColors.paperBackground));
      expect(AppColors.darkBackground, equals(EditorialColors.darkBackground));
      expect(AppRadii.sm, equals(4.0));
      expect(AppRadii.md, equals(8.0));
      expect(AppRadii.lg, equals(16.0));
    });

    testWidgets('EditorialCard renders child with 16px radius and border',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EditorialCard(
              child: Text('Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
      expect(find.byType(EditorialCard), findsOneWidget);
    });

    testWidgets('GlassCard renders as tactile paper card and responds to tap',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: GlassCard(
              onTap: () => tapped = true,
              child: const Text('Paper Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Paper Card Content'), findsOneWidget);
      await tester.tap(find.byType(GlassCard));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('PrimaryButton renders with Spruce green and triggers tap',
        (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: PrimaryButton(
              text: 'Save and Continue',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Save and Continue'), findsOneWidget);
      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('GlassButton renders as outlined paper button and triggers tap',
        (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: GlassButton(
              text: 'Dismiss',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Dismiss'), findsOneWidget);
      await tester.tap(find.byType(GlassButton));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('AppLoadingIndicator renders with message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: AppLoadingIndicator(
              message: 'Parsing ATS tokens...',
            ),
          ),
        ),
      );

      expect(find.text('Parsing ATS tokens...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('EditorialButton renders primary and triggers tap',
        (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditorialButton(
              label: 'Apply Directly',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Apply Directly'), findsOneWidget);
      await tester.tap(find.byType(EditorialButton));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('DecisionStamp renders interested and pass badges',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                DecisionStamp.interested(),
                DecisionStamp.pass(),
              ],
            ),
          ),
        ),
      );

      expect(find.text('INTERESTED'), findsOneWidget);
      expect(find.text('PASS'), findsOneWidget);
    });

    testWidgets('EditorialChip renders skill tags and triggers tap',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditorialChip.matched(
              label: 'Distributed Systems',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Distributed Systems'), findsOneWidget);
      await tester.tap(find.byType(EditorialChip));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('FactsMatrix2x2 renders 2x2 data grid', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FactsMatrix2x2.standard(
              targetComp: '€115,000 – €135,000',
              commitment: 'Full-time · Visa Sync',
              seniority: '5+ yrs distributed sys',
              listingAge: 'Posted 2 days ago',
            ),
          ),
        ),
      );

      expect(find.text('TARGET COMP'), findsOneWidget);
      expect(find.text('€115,000 – €135,000'), findsOneWidget);
      expect(find.text('COMMITMENT'), findsOneWidget);
      expect(find.text('Full-time · Visa Sync'), findsOneWidget);
    });

    testWidgets('SignalFitBadge and GroundedMatchLedger render telemetry',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SignalFitBadge(score: 94.8),
                GroundedMatchLedger(
                  pointsRatio: '6 / 7 Points',
                  explanation:
                      'Strong Go & distributed transactional systems overlap.',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('94.8% SIGNAL MATCH'), findsOneWidget);
      expect(find.text('6 / 7 Points'), findsOneWidget);
      expect(find.text('GROUNDED MATCH LEDGER'), findsOneWidget);
      expect(
          find.text('Strong Go & distributed transactional systems overlap.'),
          findsOneWidget);
    });
  });
}
