import '../core/errors/exceptions.dart';
import '../core/utils/app_utils.dart';
import '../data/models/resume_model.dart';

class AIService {
  AIService();

  Future<ResumeAnalysisModel> analyzeResume(ResumeModel resume, {String? extractedText}) async {
    try {
      // In production, this calls a cloud function or AI API
      // For demo, we'll simulate the analysis

      await Future.delayed(const Duration(seconds: 2)); // Simulate processing

      // Simulated AI analysis results
      final analysis = ResumeAnalysisModel(
        id: AppUtils.generateId(),
        userId: resume.userId,
        resumeId: resume.id,
        atsScore: _generateScore(65, 95),
        keywordMatch: _generateScore(60, 90),
        formattingScore: _generateScore(70, 98),
        contentScore: _generateScore(65, 92),
        detectedSkills: const [
          'Flutter', 'Dart', 'Firebase', 'State Management',
          'REST APIs', 'UI/UX Design', 'Git', 'Agile',
        ],
        missingSkills: const [
          'CI/CD', 'Unit Testing', 'GraphQL', 'Native Development',
          'Performance Optimization', 'Accessibility',
        ],
        strengths: const [
          'Strong mobile development experience',
          'Clean and modern UI design skills',
          'Good understanding of state management patterns',
          'Experience with cloud services integration',
        ],
        improvements: const [
          'Add more quantifiable achievements',
          'Include CI/CD pipeline experience',
          'Mention specific performance metrics',
          'Add testing methodology details',
          'Include more leadership examples',
        ],
        keywords: const [
          'Flutter', 'Mobile Development', 'Cross-platform',
          'Firebase', 'REST API', 'Git', 'Agile', 'Scrum',
          'UI/UX', 'State Management', 'Dart',
        ],
        summary: 'Your resume demonstrates strong technical skills in mobile development with Flutter. The formatting is clean and ATS-friendly. To improve, focus on adding quantifiable achievements, expanding your testing experience, and including more leadership examples.',
        sectionScores: {
          'contact_info': _generateScore(80, 100),
          'summary': _generateScore(60, 85),
          'experience': _generateScore(70, 95),
          'education': _generateScore(75, 100),
          'skills': _generateScore(65, 90),
          'projects': _generateScore(50, 80),
        },
        analyzedAt: DateTime.now(),
        isComplete: true,
      );

      return analysis;
    } catch (e) {
      throw AIException(message: 'Failed to analyze resume: $e');
    }
  }

  Future<List<Map<String, dynamic>>> matchJobs(String userId, List<String> skills, String? experienceLevel) async {
    try {
      // In production, this would use embeddings and vector search
      // For demo, return mock matches
      await Future.delayed(const Duration(milliseconds: 500));

      return [
        {'jobId': 'job_1', 'matchScore': 0.92, 'reason': 'Strong Flutter and Firebase match'},
        {'jobId': 'job_2', 'matchScore': 0.87, 'reason': 'Mobile development expertise aligned'},
        {'jobId': 'job_3', 'matchScore': 0.81, 'reason': 'UI/UX skills match requirements'},
        {'jobId': 'job_4', 'matchScore': 0.76, 'reason': 'Cross-platform experience relevant'},
      ];
    } catch (e) {
      throw AIException(message: 'Failed to match jobs: $e');
    }
  }

  Future<Map<String, dynamic>> getCareerRecommendations(String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      return {
        'recommendedSkills': [
          'GraphQL', 'Docker', 'Kubernetes', 'AWS',
          'Machine Learning', 'Blockchain', 'Web3',
        ],
        'careerPaths': [
          {
            'title': 'Senior Mobile Engineer',
            'description': 'Lead mobile development teams and architect complex applications',
            'timeline': '2-3 years',
            'requiredSkills': ['Architecture Patterns', 'Team Leadership', 'Performance Tuning'],
          },
          {
            'title': 'Full-Stack Developer',
            'description': 'Expand into backend development with Node.js or Python',
            'timeline': '1-2 years',
            'requiredSkills': ['Node.js', 'Python', 'Database Design', 'API Development'],
          },
          {
            'title': 'Tech Lead',
            'description': 'Technical leadership and strategic decision making',
            'timeline': '3-5 years',
            'requiredSkills': ['System Design', 'Mentoring', 'Project Management', 'Communication'],
          },
        ],
        'salaryInsights': {
          'currentRange': '\$80k - \$120k',
          'potentialRange': '\$120k - \$180k',
          'growthAreas': ['Specialization', 'Leadership', 'Architecture'],
        },
      };
    } catch (e) {
      throw AIException(message: 'Failed to get recommendations: $e');
    }
  }

  double _generateScore(int min, int max) {
    return (min + (max - min) * (DateTime.now().millisecond / 1000)).toDouble();
  }
}
