// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:career_swipe_ai/main.dart';
import 'package:career_swipe_ai/presentation/widgets/common/animated_background.dart';

void main() {
  setUpAll(() {
    AnimatedBackground.debugDisableAnimations = true;
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: CareerSwipeApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // Verify that the app builds successfully
    expect(find.byType(CareerSwipeApp), findsOneWidget);
  });
}
