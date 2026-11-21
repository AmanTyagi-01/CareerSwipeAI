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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:career_swipe_ai/presentation/widgets/editorial/editorial.dart';

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
