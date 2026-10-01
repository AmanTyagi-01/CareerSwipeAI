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

      expect(find.text('Upload Your Resume'), findsOneWidget);
      expect(find.text('Get AI-powered analysis and optimization insights'), findsOneWidget);
      expect(find.text('Tap to Upload Resume'), findsOneWidget);
      expect(find.text('PDF, DOC, or DOCX (max 10MB)'), findsOneWidget);
      expect(find.text('Select File'), findsOneWidget);
    });

    testWidgets('shows supported formats section', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ResumeUploadScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Supported Formats'), findsOneWidget);
      expect(find.text('PDF'), findsOneWidget);
      expect(find.text('DOC'), findsOneWidget);
      expect(find.text('DOCX'), findsOneWidget);
    });

    testWidgets('shows tips section', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ResumeUploadScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tips for best results:'), findsOneWidget);
      expect(find.text('Use standard fonts (Arial, Calibri, Times New Roman)'), findsOneWidget);
      expect(find.text('Avoid tables, images, and complex formatting'), findsOneWidget);
    });
  });
}
