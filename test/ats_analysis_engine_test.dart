import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:career_swipe_ai/data/models/job_model.dart';
import 'package:career_swipe_ai/data/models/resume_model.dart';
import 'package:career_swipe_ai/services/ai_service.dart';
import 'package:career_swipe_ai/services/document_parser_service.dart';
import 'package:career_swipe_ai/services/job_service.dart';

void main() {
  group('DocumentParserService Tests', () {
    late DocumentParserService parser;

    setUp(() {
      parser = DocumentParserService();
    });

    test('extracts text from plain text and markdown bytes', () async {
      const sampleText =
          'Aman Tyagi\nSenior Mobile Engineer\nSkills: Flutter, Dart, Riverpod, CI/CD';
      final bytes = Uint8List.fromList(utf8.encode(sampleText));

      final file = PlatformFile(
        name: 'sample_resume.txt',
        size: bytes.length,
        bytes: bytes,
      );

      final extracted = await parser.extractText(file);
      expect(extracted, contains('Aman Tyagi'));
      expect(extracted, contains('Flutter'));
      expect(extracted, contains('Riverpod'));
    });

    test('extracts text from mock DOCX XML streams (<w:t> tags)', () async {
      const docxXml = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    <w:p><w:r><w:t>Aman Tyagi</w:t></w:r></w:p>
    <w:p><w:r><w:t>Education: B.Tech Computer Science from University.</w:t></w:r></w:p>
    <w:p><w:r><w:t>Experience: Developed scalable backend systems in Python and Docker.</w:t></w:r></w:p>
  </w:body>
</w:document>''';

      final bytes = Uint8List.fromList(latin1.encode(docxXml));
      final file = PlatformFile(
        name: 'resume.docx',
        size: bytes.length,
        bytes: bytes,
      );

      final extracted = await parser.extractText(file);
      expect(extracted, contains('Aman Tyagi'));
      expect(extracted, contains('B.Tech'));
      expect(extracted, contains('Docker'));
    });

    test('extracts text from mock PDF stream (BT / Tj blocks)', () async {
      const pdfStream = '''
%PDF-1.4
1 0 obj
<< /Length 120 >>
stream
BT
/F1 12 Tf
(Aman Tyagi - Software Engineer) Tj
ET
BT
/F1 10 Tf
(Architected cloud applications improving latency by 35 percent) Tj
ET
endstream
endobj
''';

      final bytes = Uint8List.fromList(latin1.encode(pdfStream));
      final file = PlatformFile(
        name: 'resume.pdf',
        size: bytes.length,
        bytes: bytes,
      );

      final extracted = await parser.extractText(file);
      expect(extracted, contains('Aman Tyagi'));
      expect(extracted, contains('Architected'));
    });
  });

  group('AIService ATS Engine Tests (Explainable & Differentiable)', () {
    late AIService aiService;

    setUp(() {
      aiService = AIService();
    });

    test('verifies distinct resumes produce distinct, identifiable ATS scores',
        () async {
      // 1. High-caliber senior engineer resume with matching skills, metrics, and education
      final seniorResume = ResumeModel(
        id: 'res-senior',
        userId: 'usr-1',
        fileName: 'Senior_Flutter_Lead.pdf',
        fileUrl: 'file://senior.pdf',
        fileSize: 1024 * 1024,
        fileType: 'pdf',
        uploadedAt: DateTime.now(),
        skills: const [
          'Flutter',
          'Dart',
          'Riverpod',
          'REST APIs',
          'Git',
          'CI/CD',
          'Firebase',
          'Clean Architecture'
        ],
        extractedText: '''
Aman Tyagi - Lead Mobile Engineer
aman.tyagi@example.com | +91 9876543210 | github.com/AmanTyagi-01

SUMMARY
Results-driven Lead Mobile Engineer with 5+ years of experience architecting cross-platform applications.

EXPERIENCE
Lead Flutter Engineer at Tech Innovations
- Architected enterprise mobile client using Flutter, Riverpod, and Clean Architecture.
- Optimized app startup time by 42% and reduced memory footprint by 28%.
- Spearheaded CI/CD automation with GitHub Actions, reducing release cycle by 50%.
- Engineered robust offline-first caching layer with SQLite and REST APIs.

EDUCATION
B.Tech in Computer Science and Engineering, State University, First Class Honors.

PROJECTS
CareerSwipe AI: Autonomous career mobility platform serving 25k DAU.
''',
      );

      // 2. Junior resume with basic keywords, no quantified metrics
      final juniorResume = ResumeModel(
        id: 'res-junior',
        userId: 'usr-2',
        fileName: 'Junior_Developer.pdf',
        fileUrl: 'file://junior.pdf',
        fileSize: 500 * 1024,
        fileType: 'pdf',
        uploadedAt: DateTime.now(),
        skills: const ['HTML/CSS'],
        extractedText: '''
Junior Candidate
Interested in coding and web pages.
Worked on minor college website using HTML/CSS.
Looking for entry level role.
''',
      );

      // Target benchmark role: Senior Flutter Engineer
      final targetJob = JobModel(
        id: 'job-flutter',
        title: 'Senior Flutter Developer',
        company: 'Cloud Corp',
        location: 'Bengaluru, India',
        minSalary: 1500000,
        maxSalary: 3000000,
        currency: 'INR',
        jobType: 'Full-time',
        experienceLevel: 'Senior',
        isRemote: true,
        description:
            'Lead mobile app development with Flutter, Dart, Riverpod, CI/CD, and REST APIs.',
        shortDescription: 'Lead Flutter engineer',
        skills: const [
          'Flutter',
          'Dart',
          'Riverpod',
          'REST APIs',
          'CI/CD',
          'Git',
          'Firebase'
        ],
        postedAt: DateTime.now(),
      );

      final seniorAnalysis =
          await aiService.analyzeResume(seniorResume, targetJob: targetJob);
      final juniorAnalysis =
          await aiService.analyzeResume(juniorResume, targetJob: targetJob);

      // Verify non-identical ATS scores
      expect(seniorAnalysis.atsScore, isNot(equals(juniorAnalysis.atsScore)));
      expect(seniorAnalysis.atsScore, greaterThan(juniorAnalysis.atsScore));
      expect(seniorAnalysis.atsScore, greaterThanOrEqualTo(70.0));
      expect(juniorAnalysis.atsScore, lessThan(60.0));

      // Verify identifiable 5 criteria breakdown in senior analysis
      expect(seniorAnalysis.sectionScores.containsKey('Skills'), isTrue);
      expect(seniorAnalysis.sectionScores.containsKey('Keywords'), isTrue);
      expect(seniorAnalysis.sectionScores.containsKey('Experience'), isTrue);
      expect(seniorAnalysis.sectionScores.containsKey('Education'), isTrue);
      expect(seniorAnalysis.sectionScores.containsKey('Formatting'), isTrue);

      // Verify matched and missing skill attribution
      expect(seniorAnalysis.keywords, contains('Flutter'));
      expect(juniorAnalysis.missingSkills, contains('Flutter'));

      // Verify actionable improvement suggestions
      expect(juniorAnalysis.improvements.isNotEmpty, isTrue);
      expect(seniorAnalysis.strengths.isNotEmpty, isTrue);
    });
  });

  group('JobService Swipe & Persistence Tests', () {
    late JobService jobService;

    setUp(() {
      jobService = JobService();
    });

    test('records swipe and persists to saved jobs', () async {
      const testUserId = 'test-user-swipe';
      const testJobId = 'job-1';

      await jobService.recordSwipe(testUserId, testJobId, 'save');

      final savedJobs = await jobService.getSavedJobs(testUserId);
      expect(savedJobs.any((j) => j.id == testJobId), isTrue);

      // Unsave should remove it
      await jobService.unsaveJob(testUserId, testJobId);
      final updatedSavedJobs = await jobService.getSavedJobs(testUserId);
      expect(updatedSavedJobs.any((j) => j.id == testJobId), isFalse);
    });

    test('applies for job and records application in local state', () async {
      const testUserId = 'test-user-apply';
      const testJobId = 'job-2';

      await jobService.applyForJob(
        testUserId,
        testJobId,
        coverLetter: 'Passionate AI developer with PyTorch experience.',
      );

      final applied = await jobService.getAppliedJobs(testUserId);
      expect(applied.any((a) => a.jobId == testJobId), isTrue);

      // Re-applying to same job throws exception
      expect(
        () => jobService.applyForJob(testUserId, testJobId),
        throwsA(isA<Exception>()),
      );
    });
  });
}
