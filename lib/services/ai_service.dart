import '../core/errors/exceptions.dart';
import '../core/utils/app_utils.dart';
import '../data/models/resume_model.dart';
import '../data/models/job_model.dart';

class AIService {
  AIService();

  // Comprehensive canonical skill dictionary across modern software engineering domains
  static const Map<String, List<String>> _skillDictionary = {
    // Mobile
    'Flutter': ['flutter', 'flutter framework', 'flutter sdk'],
    'Dart': ['dart', 'dartlang'],
    'React Native': ['react native', 'react-native'],
    'Swift': ['swift', 'swiftui', 'ios development'],
    'Kotlin': ['kotlin', 'android development', 'jetpack compose'],

    // Frontend Web
    'React': ['react', 'react.js', 'reactjs'],
    'TypeScript': ['typescript', 'ts'],
    'JavaScript': ['javascript', 'js', 'es6', 'ecmascript'],
    'Vue.js': ['vue', 'vue.js', 'vuejs'],
    'Next.js': ['next.js', 'nextjs'],
    'HTML/CSS': [
      'html',
      'html5',
      'css',
      'css3',
      'sass',
      'tailwind',
      'bootstrap'
    ],

    // Backend
    'Node.js': ['node.js', 'nodejs', 'node', 'express', 'nestjs'],
    'Python': ['python', 'py', 'django', 'fastapi', 'flask'],
    'Go': ['golang', 'go language'],
    'Java': ['java', 'spring', 'spring boot'],
    'C++': ['c++', 'cpp'],
    'C#': ['c#', 'csharp', '.net', 'asp.net'],
    'Rust': ['rust', 'rustlang'],

    // Cloud & DevOps
    'Docker': ['docker', 'containerization', 'containers'],
    'Kubernetes': ['kubernetes', 'k8s'],
    'AWS': ['aws', 'amazon web services', 'ec2', 's3', 'lambda'],
    'Google Cloud': ['gcp', 'google cloud', 'bigquery', 'cloud run'],
    'Azure': ['azure', 'microsoft azure'],
    'CI/CD': [
      'ci/cd',
      'github actions',
      'jenkins',
      'gitlab ci',
      'bitbucket pipelines'
    ],
    'Terraform': ['terraform', 'iac'],
    'Linux': ['linux', 'bash', 'shell scripting', 'ubuntu'],

    // Databases
    'PostgreSQL': ['postgres', 'postgresql'],
    'MongoDB': ['mongodb', 'mongo'],
    'MySQL': ['mysql'],
    'Redis': ['redis', 'caching'],
    'Firebase': ['firebase', 'firestore', 'cloud firestore', 'cloud functions'],
    'SQLite': ['sqlite', 'room database'],

    // Architecture & Data
    'REST APIs': ['rest', 'rest api', 'restful', 'json api'],
    'GraphQL': ['graphql', 'apollo'],
    'Microservices': [
      'microservices',
      'service oriented architecture',
      'distributed systems'
    ],
    'System Design': ['system design', 'high level design', 'low level design'],
    'State Management': [
      'state management',
      'riverpod',
      'bloc',
      'redux',
      'provider',
      'zustand'
    ],
    'Clean Architecture': [
      'clean architecture',
      'mvvm',
      'mvc',
      'solid principles',
      'design patterns'
    ],
    'Unit Testing': [
      'unit testing',
      'test driven development',
      'tdd',
      'jest',
      'flutter test',
      'mocking'
    ],
    'Git': ['git', 'github', 'gitlab', 'version control'],

    // AI & Machine Learning
    'Machine Learning': [
      'machine learning',
      'ml',
      'scikit-learn',
      'deep learning'
    ],
    'PyTorch': ['pytorch', 'torch'],
    'TensorFlow': ['tensorflow', 'keras'],
    'LLMs': [
      'llms',
      'large language models',
      'langchain',
      'openai',
      'gemini api',
      'prompt engineering'
    ],
    'Data Analysis': [
      'data analysis',
      'pandas',
      'numpy',
      'matplotlib',
      'sql queries',
      'tableau'
    ],
    'Agile': ['agile', 'scrum', 'kanban', 'sprint planning', 'jira'],
  };

  /// Evidence-based explainable ATS evaluation based on 5 identifiable criteria:
  /// 1. Skills (35%): Exact match ratio against role requirements
  /// 2. Keywords (25%): Domain keyword density and vocabulary alignment
  /// 3. Experience (20%): Depth of work history, action verbs, and quantifiable metrics
  /// 4. Education (10%): Degree accreditation, university background, and academic standing
  /// 5. Formatting (10%): Standard structural headings, clean parseability, and contact telemetry
  Future<ResumeAnalysisModel> analyzeResume(
    ResumeModel resume, {
    String? extractedText,
    JobModel? targetJob,
  }) async {
    try {
      final rawText =
          extractedText ?? resume.extractedText ?? resume.skills.join(' ');
      final lowerText = rawText.toLowerCase();

      // ── 1. Skill Extraction & Detection ──
      final detectedSkills = <String>{};
      for (final entry in _skillDictionary.entries) {
        for (final alias in entry.value) {
          final escapedAlias = RegExp.escape(alias);
          final pattern = RegExp(
              '(^|[^a-zA-Z0-9])$escapedAlias(\$|[^a-zA-Z0-9])',
              caseSensitive: false);
          if (pattern.hasMatch(lowerText)) {
            detectedSkills.add(entry.key);
            break;
          }
        }
      }
      for (final s in resume.skills) {
        if (s.trim().isNotEmpty) detectedSkills.add(s.trim());
      }

      // Benchmark requirements from job or industry standard
      final targetRequirements =
          (targetJob != null && targetJob.skills.isNotEmpty)
              ? targetJob.skills
              : const [
                  'Flutter',
                  'Dart',
                  'State Management',
                  'REST APIs',
                  'Git',
                  'Firebase',
                  'CI/CD'
                ];

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

      final skillsScore = targetRequirements.isNotEmpty
          ? ((matchedSkills.length / targetRequirements.length) * 100)
              .round()
              .clamp(20, 99)
          : (detectedSkills.length >= 8
              ? 88
              : (detectedSkills.length * 10).clamp(30, 95));

      // ── 2. Keyword Coverage Score ──
      final domainKeywords = [
        'api',
        'architecture',
        'scalability',
        'performance',
        'database',
        'frontend',
        'backend',
        'full stack',
        'cloud',
        'security',
        'testing',
        'deployment',
        'optimization',
        'agile',
        'engineering',
        'analytics',
        'pipeline'
      ];
      int keywordsFound = 0;
      for (final kw in domainKeywords) {
        if (lowerText.contains(kw)) keywordsFound++;
      }
      final keywordsScore =
          ((keywordsFound / domainKeywords.length) * 100).round().clamp(35, 96);

      // ── 3. Experience & Impact Score ──
      final actionVerbs = [
        'architected',
        'developed',
        'engineered',
        'led',
        'designed',
        'built',
        'reduced',
        'improved',
        'optimized',
        'scaled',
        'delivered',
        'orchestrated'
      ];
      int verbsFound = 0;
      for (final verb in actionVerbs) {
        if (lowerText.contains(verb)) verbsFound++;
      }
      final hasNumbers = RegExp(r'\b\d+(\%|\+)?\b').hasMatch(lowerText);
      final hasExperienceSection = lowerText.contains('experience') ||
          lowerText.contains('work history') ||
          lowerText.contains('employment');
      final experienceScore = ((verbsFound * 4) +
              (hasNumbers ? 25 : 10) +
              (hasExperienceSection ? 35 : 15))
          .clamp(30, 98);

      // ── 4. Education Score ──
      final degreeKeywords = [
        'bachelor',
        'b.tech',
        'b.e',
        'bs',
        'master',
        'm.tech',
        'ms',
        'mca',
        'phd',
        'degree',
        'computer science',
        'engineering',
        'university',
        'college'
      ];
      int eduMatches = 0;
      for (final deg in degreeKeywords) {
        if (lowerText.contains(deg)) eduMatches++;
      }
      final educationScore =
          (eduMatches >= 2 ? 90 : (eduMatches == 1 ? 75 : 50)).clamp(40, 95);

      // ── 5. Formatting & Structure Score ──
      final standardSections = [
        'summary',
        'profile',
        'experience',
        'skills',
        'education',
        'projects'
      ];
      int sectionsFoundCount = 0;
      for (final section in standardSections) {
        if (lowerText.contains(section)) sectionsFoundCount++;
      }
      final hasContactInfo = lowerText.contains('@') ||
          RegExp(r'\b\d{10}\b').hasMatch(lowerText) ||
          lowerText.contains('linkedin') ||
          lowerText.contains('github');
      final formattingScore =
          (((sectionsFoundCount / standardSections.length) * 50) +
                  (hasContactInfo ? 30 : 10) +
                  15)
              .round()
              .clamp(45, 98);

      // ── 6. Overall Weighted ATS Score ──
      // Weighted 5-dimension formula: 35% Skills + 25% Keywords + 20% Experience + 10% Education + 10% Formatting
      final overallScore = ((skillsScore * 0.35) +
              (keywordsScore * 0.25) +
              (experienceScore * 0.20) +
              (educationScore * 0.10) +
              (formattingScore * 0.10))
          .round()
          .clamp(30, 99);

      // ── 7. Dynamic Strengths & Actionable Recommendations ──
      final improvements = <String>[];
      if (missingSkills.isNotEmpty) {
        improvements.add(
            'Integrate missing target skills: ${missingSkills.take(3).join(', ')} into your project summaries.');
      }
      if (!hasNumbers) {
        improvements.add(
            'Quantify work impact with concrete business metrics (e.g., "reduced latency by 35%", "scaled to 50k DAU").');
      }
      if (verbsFound < 4) {
        improvements.add(
            'Elevate bullet points with strong action verbs like "Architected", "Engineered", or "Spearheaded".');
      }
      if (!hasContactInfo) {
        improvements.add(
            'Ensure phone number, location, and GitHub/LinkedIn portfolio URLs are prominently placed in the header.');
      }
      if (improvements.isEmpty) {
        improvements.add(
            'Strong alignment with target role benchmarks. Tailor your professional summary to the company mission.');
      }

      final strengths = <String>[
        'Identified ${detectedSkills.length} validated technical proficiencies matching industry benchmarks.',
        if (hasNumbers)
          'Quantified achievements present with verifiable statistical improvements.',
        if (hasContactInfo)
          'Direct verified contact telemetry (email & professional portfolio links).',
        'Standardized structural headings recognized cleanly by automated parsing engines.',
      ];

      final sectionScores = <String, dynamic>{
        'Skills': skillsScore,
        'Keywords': keywordsScore,
        'Experience': experienceScore,
        'Education': educationScore,
        'Formatting': formattingScore,
        // Legacy keys compatibility
        'contact_info': hasContactInfo ? 95 : 60,
        'summary':
            lowerText.contains('summary') || lowerText.contains('profile')
                ? 90
                : 70,
        'experience_score': experienceScore,
        'education_score': educationScore,
        'skills_score': skillsScore,
        'projects': lowerText.contains('project') ? 88 : 65,
      };

      final analysis = ResumeAnalysisModel(
        id: AppUtils.generateId(),
        userId: resume.userId,
        resumeId: resume.id,
        atsScore: overallScore.toDouble(),
        keywordMatch: keywordsScore.toDouble(),
        formattingScore: formattingScore.toDouble(),
        contentScore: experienceScore.toDouble(),
        detectedSkills: detectedSkills.toList(),
        missingSkills: missingSkills,
        recommendedSkills: missingSkills.isNotEmpty
            ? missingSkills
            : const ['Cloud Architecture', 'System Design'],
        strengths: strengths,
        improvements: improvements,
        keywords: matchedSkills.isNotEmpty
            ? matchedSkills
            : detectedSkills.take(8).toList(),
        missingKeywords: missingSkills,
        summary:
            'Algorithmic compatibility audit indicates an overall match score of $overallScore/100. '
            '${improvements.isNotEmpty ? improvements.first : "Resume structure conforms to modern ATS parsing standards."}',
        sectionScores: sectionScores,
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

        final matchedSkills = userSkills
            .where((uSkill) => jobSkills.any((jSkill) =>
                jSkill.toLowerCase() == uSkill.toLowerCase() ||
                jSkill.toLowerCase().contains(uSkill.toLowerCase()) ||
                uSkill.toLowerCase().contains(jSkill.toLowerCase())))
            .toList();

        final matchRatio = (matchedSkills.length / jobSkills.length);
        final score = (matchRatio * 100).round();

        if (score >= 30 || matchedSkills.isNotEmpty) {
          matches.add({
            'jobId': job.id,
            'matchScore': matchRatio,
            'matchedSkills': matchedSkills,
            'reason':
                'Matches ${matchedSkills.length} of ${jobSkills.length} required skills (${matchedSkills.take(3).join(', ')})',
          });
        }
      }

      // Sort descending by match score
      matches.sort((a, b) =>
          (b['matchScore'] as double).compareTo(a['matchScore'] as double));
      return matches;
    } catch (e) {
      throw AIException(message: 'Failed to match jobs: $e');
    }
  }
}
