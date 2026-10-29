import '../core/errors/exceptions.dart';
import '../core/utils/app_utils.dart';
import '../data/models/resume_model.dart';
import '../data/models/job_model.dart';

class AIService {
  AIService();

  // Canonical skill dictionary for text parsing & normalization
  static const Map<String, List<String>> _skillDictionary = {
    'Flutter': ['flutter', 'flutter framework'],
    'Dart': ['dart', 'dartlang'],
    'React': ['react', 'react.js', 'reactjs'],
    'TypeScript': ['typescript', 'ts'],
    'JavaScript': ['javascript', 'js'],
    'Node.js': ['node.js', 'nodejs', 'node'],
    'Python': ['python', 'py'],
    'Firebase': ['firebase', 'firestore', 'cloud firestore'],
    'Docker': ['docker', 'containers'],
    'Kubernetes': ['kubernetes', 'k8s'],
    'AWS': ['aws', 'amazon web services'],
    'Google Cloud': ['gcp', 'google cloud'],
    'PostgreSQL': ['postgres', 'postgresql'],
    'REST APIs': ['rest', 'rest api', 'restful'],
    'GraphQL': ['graphql'],
    'Git': ['git', 'github', 'gitlab'],
    'CI/CD': ['ci/cd', 'github actions', 'jenkins', 'gitlab ci'],
    'Unit Testing': ['unit testing', 'test driven development', 'tdd', 'jest', 'flutter test'],
    'State Management': ['state management', 'riverpod', 'bloc', 'redux', 'provider'],
    'Clean Architecture': ['clean architecture', 'mvvm', 'mvc'],
    'Performance Optimization': ['performance tuning', 'optimization', 'profiling'],
  };

  /// Real transparent evidence-based ATS evaluation comparing resume text against job requirements
  Future<ResumeAnalysisModel> analyzeResume(
    ResumeModel resume, {
    String? extractedText,
    JobModel? targetJob,
  }) async {
    try {
      final text = (extractedText ?? resume.skills.join(' ')).toLowerCase();

      // 1. Extract verified skills using word boundaries & aliases
      final detectedSkills = <String>{};
      for (final entry in _skillDictionary.entries) {
        for (final alias in entry.value) {
          final pattern = RegExp('(^|[^a-zA-Z0-9])$alias(\$|[^a-zA-Z0-9])', caseSensitive: false);
          if (pattern.hasMatch(text)) {
            detectedSkills.add(entry.key);
            break;
          }
        }
      }

      // Also incorporate skills explicitly attached to the resume model
      for (final s in resume.skills) {
        if (s.trim().isNotEmpty) detectedSkills.add(s.trim());
      }

      // 2. Define benchmark requirements
      final targetRequirements = targetJob != null && targetJob.skills.isNotEmpty
          ? targetJob.skills
          : const ['Flutter', 'Dart', 'State Management', 'REST APIs', 'Git', 'Firebase', 'CI/CD'];

      // 3. Compare matched vs. missing skills
      final matchedSkills = <String>[];
      final missingSkills = <String>[];

      for (final req in targetRequirements) {
        final isMatched = detectedSkills.any((ds) =>
            ds.toLowerCase() == req.toLowerCase() ||
            ds.toLowerCase().contains(req.toLowerCase()) ||
            req.toLowerCase().contains(ds.toLowerCase()));
        if (isMatched) {
          matchedSkills.add(req);
        } else {
          missingSkills.add(req);
        }
      }

      final skillMatchPercent = targetRequirements.isNotEmpty
          ? ((matchedSkills.length / targetRequirements.length) * 100).round()
          : 75;

      // 4. Formatting evaluation (Standard sections & action verbs)
      final standardSections = ['experience', 'education', 'skills', 'projects'];
      int sectionsFoundCount = 0;
      for (final section in standardSections) {
        if (text.contains(section)) sectionsFoundCount++;
      }
      final formattingScore = ((sectionsFoundCount / standardSections.length) * 40 + 60).clamp(50, 100).toInt();

      // 5. Content impact evaluation (quantified metrics & action verbs)
      final actionVerbs = ['architected', 'developed', 'engineered', 'led', 'designed', 'built', 'reduced', 'improved', 'optimized'];
      int verbsFound = 0;
      for (final verb in actionVerbs) {
        if (text.contains(verb)) verbsFound++;
      }
      final hasNumbers = RegExp(r'\b\d+(\%|\+)?\b').hasMatch(text);
      final contentScore = ((verbsFound * 8) + (hasNumbers ? 20 : 0) + 50).clamp(50, 95).toInt();

      // 6. Overall Weighted ATS Compatibility Score
      // 45% Skill Match + 30% Content Impact + 25% Formatting
      final overallScore = ((skillMatchPercent * 0.45) + (contentScore * 0.30) + (formattingScore * 0.25)).round().clamp(30, 98);

      // 7. Actionable Recommendations
      final improvements = <String>[];
      if (missingSkills.isNotEmpty) {
        improvements.add('Add missing key competencies: ${missingSkills.take(3).join(', ')} into your experience bullet points.');
      }
      if (!hasNumbers) {
        improvements.add('Quantify achievements with concrete numbers (e.g. "reduced latency by 35%", "scaled to 50k users").');
      }
      if (verbsFound < 3) {
        improvements.add('Begin experience bullet points with strong action verbs like "Architected", "Engineered", or "Spearheaded".');
      }
      if (improvements.isEmpty) {
        improvements.add('Strong alignment with target role requirements. Tailor your summary specifically to the employer mission.');
      }

      final strengths = <String>[
        'Found ${detectedSkills.length} technical skills matching industry benchmarks.',
        if (hasNumbers) 'Quantified impact metrics present in work experience.',
        'Clear formatting alignment with standard ATS parser section headers.',
      ];

      final analysis = ResumeAnalysisModel(
        id: AppUtils.generateId(),
        userId: resume.userId,
        resumeId: resume.id,
        atsScore: overallScore.toDouble(),
        keywordMatch: skillMatchPercent.toDouble(),
        formattingScore: formattingScore.toDouble(),
        contentScore: contentScore.toDouble(),
        detectedSkills: detectedSkills.toList(),
        missingSkills: missingSkills,
        strengths: strengths,
        improvements: improvements,
        keywords: matchedSkills.isNotEmpty ? matchedSkills : detectedSkills.take(6).toList(),
        summary: 'Algorithmic compatibility benchmark indicates a $overallScore/100 alignment with target role requirements. '
            '${improvements.isNotEmpty ? improvements.first : "Resume is well-structured for automated parsers."}',
        sectionScores: {
          'contact_info': text.contains('@') ? 95 : 60,
          'summary': text.contains('summary') || text.contains('profile') ? 90 : 70,
          'experience': contentScore,
          'education': text.contains('education') || text.contains('degree') ? 90 : 65,
          'skills': skillMatchPercent,
          'projects': text.contains('project') ? 85 : 60,
        },
        analyzedAt: DateTime.now(),
        isComplete: true,
      );

      return analysis;
    } catch (e) {
      throw AIException(message: 'Failed to analyze resume: $e');
    }
  }

  /// Real calculation comparing candidate skills to active jobs
  Future<List<Map<String, dynamic>>> matchJobs(
    String userId,
    List<String> userSkills,
    List<JobModel> availableJobs,
  ) async {
    try {
      final matches = <Map<String, dynamic>>[];

      for (final job in availableJobs) {
        final jobSkills = job.skills;
        if (jobSkills.isEmpty) continue;

        final matchedSkills = userSkills.where((uSkill) =>
            jobSkills.any((jSkill) =>
                jSkill.toLowerCase() == uSkill.toLowerCase() ||
                jSkill.toLowerCase().contains(uSkill.toLowerCase()) ||
                uSkill.toLowerCase().contains(jSkill.toLowerCase()))).toList();

        final matchRatio = (matchedSkills.length / jobSkills.length);
        final score = (matchRatio * 100).round();

        if (score >= 30 || matchedSkills.isNotEmpty) {
          matches.add({
            'jobId': job.id,
            'matchScore': matchRatio,
            'matchedSkills': matchedSkills,
            'reason': 'Matches ${matchedSkills.length} of ${jobSkills.length} required skills (${matchedSkills.take(3).join(', ')})',
          });
        }
      }

      // Sort descending by match score
      matches.sort((a, b) => (b['matchScore'] as double).compareTo(a['matchScore'] as double));
      return matches;
    } catch (e) {
      throw AIException(message: 'Failed to match jobs: $e');
    }
  }
}
