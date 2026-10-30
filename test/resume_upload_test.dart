import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:career_swipe_ai/presentation/screens/resume/resume_upload_screen.dart';
import 'package:career_swipe_ai/presentation/widgets/common/animated_background.dart';

void main() {
  setUpAll(() {
    AnimatedBackground.debugDisableAnimations = true;
  });

  group('ResumeUploadScreen Widget Tests', () {
    testWidgets('renders upload area', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ResumeUploadScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('My Resume'), findsOneWidget);
      expect(find.text('Aman_Tyagi_Resume.pdf'), findsOneWidget);
      expect(find.text('Tap to Upload New Resume'), findsOneWidget);
      expect(find.text('Supports PDF, DOC, DOCX up to 10MB'), findsOneWidget);
      expect(find.text('Extracted Information'), findsOneWidget);
      expect(find.text('AI Suggestions'), findsOneWidget);
      expect(find.text('Improve with AI'), findsOneWidget);
    });
  });
}
