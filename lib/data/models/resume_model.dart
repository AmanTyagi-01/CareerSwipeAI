import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ResumeAnalysisContext — answers to the pre-analysis questionnaire
// ─────────────────────────────────────────────────────────────────────────────
class ResumeAnalysisContext extends Equatable {
  final String targetRole;
  final String experienceLevel; // student | fresher | intern | experienced
  final String? preferredIndustry;
  final String? preferredLocation;
  final String workMode; // remote | hybrid | onsite | any
  final String? customRole;

  const ResumeAnalysisContext({
    required this.targetRole,
    required this.experienceLevel,
    this.preferredIndustry,
    this.preferredLocation,
    this.workMode = 'any',
    this.customRole,
  });

  String get effectiveRole => targetRole == 'Custom'
      ? (customRole ?? 'Software Developer')
      : targetRole;

  ResumeAnalysisContext copyWith({
    String? targetRole,
    String? experienceLevel,
    String? preferredIndustry,
    String? preferredLocation,
    String? workMode,
    String? customRole,
  }) =>
      ResumeAnalysisContext(
        targetRole: targetRole ?? this.targetRole,
        experienceLevel: experienceLevel ?? this.experienceLevel,
        preferredIndustry: preferredIndustry ?? this.preferredIndustry,
        preferredLocation: preferredLocation ?? this.preferredLocation,
        workMode: workMode ?? this.workMode,
        customRole: customRole ?? this.customRole,
      );

  Map<String, dynamic> toMap() => {
        'targetRole': targetRole,
        'experienceLevel': experienceLevel,
        'preferredIndustry': preferredIndustry,
        'preferredLocation': preferredLocation,
        'workMode': workMode,
        'customRole': customRole,
      };

  factory ResumeAnalysisContext.fromMap(Map<String, dynamic> map) =>
      ResumeAnalysisContext(
        targetRole: map['targetRole'] ?? 'Software Developer',
        experienceLevel: map['experienceLevel'] ?? 'fresher',
        preferredIndustry: map['preferredIndustry'],
        preferredLocation: map['preferredLocation'],
        workMode: map['workMode'] ?? 'any',
        customRole: map['customRole'],
      );

  @override
  List<Object?> get props => [
        targetRole,
        experienceLevel,
        preferredIndustry,
        preferredLocation,
        workMode,
        customRole
      ];
}

// ─────────────────────────────────────────────────────────────────────────────
// LearningResource — a course or resource in the roadmap
// ─────────────────────────────────────────────────────────────────────────────
class LearningResource extends Equatable {
  final String title;
  final String platform; // e.g., Coursera, YouTube, Udemy
  final String type; // course | book | project | certification
  final String? url;
  final String? duration;

  const LearningResource({
    required this.title,
    required this.platform,
    required this.type,
    this.url,
    this.duration,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'platform': platform,
        'type': type,
        'url': url,
        'duration': duration,
      };

  factory LearningResource.fromMap(Map<String, dynamic> map) =>
      LearningResource(
        title: map['title'] ?? '',
        platform: map['platform'] ?? '',
        type: map['type'] ?? 'course',
        url: map['url'],
        duration: map['duration'],
      );

  @override
  List<Object?> get props => [title, platform, type, url, duration];
}

// ─────────────────────────────────────────────────────────────────────────────
// RoadmapMonth — a single month in the learning roadmap
// ─────────────────────────────────────────────────────────────────────────────
class RoadmapMonth extends Equatable {
  final int month;
  final String theme;
  final List<String> goals;
  final List<LearningResource> resources;
  final List<String> projects;
  final List<String> certifications;

  const RoadmapMonth({
    required this.month,
    required this.theme,
    this.goals = const [],
    this.resources = const [],
    this.projects = const [],
    this.certifications = const [],
  });

  Map<String, dynamic> toMap() => {
        'month': month,
        'theme': theme,
        'goals': goals,
        'resources': resources.map((r) => r.toMap()).toList(),
        'projects': projects,
        'certifications': certifications,
      };

  factory RoadmapMonth.fromMap(Map<String, dynamic> map) => RoadmapMonth(
        month: map['month'] ?? 1,
        theme: map['theme'] ?? '',
        goals: List<String>.from(map['goals'] ?? []),
        resources: (map['resources'] as List<dynamic>?)
                ?.map((r) =>
                    LearningResource.fromMap(Map<String, dynamic>.from(r)))
                .toList() ??
            [],
        projects: List<String>.from(map['projects'] ?? []),
        certifications: List<String>.from(map['certifications'] ?? []),
      );

  @override
  List<Object?> get props =>
      [month, theme, goals, resources, projects, certifications];
}

// ─────────────────────────────────────────────────────────────────────────────
// ResumeModel — the uploaded resume file record
// ─────────────────────────────────────────────────────────────────────────────
class ResumeModel extends Equatable {
  final String id;
  final String userId;
  final String fileName;
  final String fileUrl;
  final int fileSize;
  final String fileType;
  final String? extractedText;
  final DateTime? uploadedAt;
  final bool isActive;
  final int version;
  final double atsScore;
  final List<String> skills;
  final Map<String, dynamic> atsBreakdown;

  const ResumeModel({
    required this.id,
    required this.userId,
    required this.fileName,
    required this.fileUrl,
    required this.fileSize,
    required this.fileType,
    this.extractedText,
    this.uploadedAt,
    this.isActive = true,
    this.version = 1,
    this.atsScore = 0.0,
    this.skills = const [],
    this.atsBreakdown = const {},
  });

  ResumeModel copyWith({
    String? id,
    String? userId,
    String? fileName,
    String? fileUrl,
    int? fileSize,
    String? fileType,
    String? extractedText,
    DateTime? uploadedAt,
    bool? isActive,
    int? version,
    double? atsScore,
    List<String>? skills,
    Map<String, dynamic>? atsBreakdown,
  }) {
    return ResumeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      fileSize: fileSize ?? this.fileSize,
      fileType: fileType ?? this.fileType,
      extractedText: extractedText ?? this.extractedText,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      isActive: isActive ?? this.isActive,
      version: version ?? this.version,
      atsScore: atsScore ?? this.atsScore,
      skills: skills ?? this.skills,
      atsBreakdown: atsBreakdown ?? this.atsBreakdown,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'fileSize': fileSize,
      'fileType': fileType,
      'extractedText': extractedText,
      'uploadedAt': uploadedAt != null ? Timestamp.fromDate(uploadedAt!) : null,
      'isActive': isActive,
      'version': version,
      'atsScore': atsScore,
      'skills': skills,
      'atsBreakdown': atsBreakdown,
    };
  }

  factory ResumeModel.fromMap(Map<String, dynamic> map) {
    return ResumeModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      fileName: map['fileName'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      fileSize: map['fileSize'] ?? 0,
      fileType: map['fileType'] ?? 'pdf',
      extractedText: map['extractedText'],
      uploadedAt: map['uploadedAt'] != null
          ? (map['uploadedAt'] as Timestamp).toDate()
          : null,
      isActive: map['isActive'] ?? true,
      version: map['version'] ?? 1,
      atsScore: (map['atsScore'] ?? 0.0).toDouble(),
      skills: List<String>.from(map['skills'] ?? []),
      atsBreakdown: Map<String, dynamic>.from(map['atsBreakdown'] ?? {}),
    );
  }

  factory ResumeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ResumeModel.fromMap({'id': doc.id, ...data});
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        fileName,
        fileUrl,
        fileSize,
        fileType,
        extractedText,
        uploadedAt,
        isActive,
        version,
        atsScore,
        skills,
        atsBreakdown,
      ];
}

// ─────────────────────────────────────────────────────────────────────────────
// ResumeAnalysisModel — the complete AI analysis result
// ─────────────────────────────────────────────────────────────────────────────
class ResumeAnalysisModel extends Equatable {
  final String id;
  final String userId;
  final String resumeId;

  // Core scores (0–100)
  final double atsScore;
  final double keywordMatch;
  final double formattingScore;
  final double contentScore;
  final double jobReadinessScore;
  final double careerCompetitivenessScore;
  final double interviewReadinessScore;
  final double marketDemandScore;
  final double resumeStrengthScore;

  // Skills
  final List<String> detectedSkills;
  final List<String> missingSkills;
  final List<String> recommendedSkills;

  // Keyword analysis
  final List<String> keywords;
  final List<String> missingKeywords;

  // Strengths & improvements
  final List<String> strengths;
  final List<String> improvements;

  // AI-generated detailed content
  final String? summary;
  final List<String> rewriteSuggestions;
  final List<String> careerAdvice;
  final List<String> interviewTips;

  // Section-level scores
  final Map<String, dynamic> sectionScores;

  // Project quality analysis
  final List<Map<String, dynamic>> projectAnalysis;

  // Experience relevance
  final String? experienceRelevance;

  // Education analysis
  final String? educationAnalysis;

  // Learning roadmap
  final List<RoadmapMonth> roadmap;

  // Context used for analysis
  final ResumeAnalysisContext? context;

  final DateTime? analyzedAt;
  final bool isComplete;

  const ResumeAnalysisModel({
    required this.id,
    required this.userId,
    required this.resumeId,
    this.atsScore = 0.0,
    this.keywordMatch = 0.0,
    this.formattingScore = 0.0,
    this.contentScore = 0.0,
    this.jobReadinessScore = 0.0,
    this.careerCompetitivenessScore = 0.0,
    this.interviewReadinessScore = 0.0,
    this.marketDemandScore = 0.0,
    this.resumeStrengthScore = 0.0,
    this.detectedSkills = const [],
    this.missingSkills = const [],
    this.recommendedSkills = const [],
    this.keywords = const [],
    this.missingKeywords = const [],
    this.strengths = const [],
    this.improvements = const [],
    this.summary,
    this.rewriteSuggestions = const [],
    this.careerAdvice = const [],
    this.interviewTips = const [],
    this.sectionScores = const {},
    this.projectAnalysis = const [],
    this.experienceRelevance,
    this.educationAnalysis,
    this.roadmap = const [],
    this.context,
    this.analyzedAt,
    this.isComplete = false,
  });

  double get overallScore =>
      (atsScore + keywordMatch + formattingScore + contentScore) / 4;

  ResumeAnalysisModel copyWith({
    String? id,
    String? userId,
    String? resumeId,
    double? atsScore,
    double? keywordMatch,
    double? formattingScore,
    double? contentScore,
    double? jobReadinessScore,
    double? careerCompetitivenessScore,
    double? interviewReadinessScore,
    double? marketDemandScore,
    double? resumeStrengthScore,
    List<String>? detectedSkills,
    List<String>? missingSkills,
    List<String>? recommendedSkills,
    List<String>? keywords,
    List<String>? missingKeywords,
    List<String>? strengths,
    List<String>? improvements,
    String? summary,
    List<String>? rewriteSuggestions,
    List<String>? careerAdvice,
    List<String>? interviewTips,
    Map<String, dynamic>? sectionScores,
    List<Map<String, dynamic>>? projectAnalysis,
    String? experienceRelevance,
    String? educationAnalysis,
    List<RoadmapMonth>? roadmap,
    ResumeAnalysisContext? context,
    DateTime? analyzedAt,
    bool? isComplete,
  }) {
    return ResumeAnalysisModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      resumeId: resumeId ?? this.resumeId,
      atsScore: atsScore ?? this.atsScore,
      keywordMatch: keywordMatch ?? this.keywordMatch,
      formattingScore: formattingScore ?? this.formattingScore,
      contentScore: contentScore ?? this.contentScore,
      jobReadinessScore: jobReadinessScore ?? this.jobReadinessScore,
      careerCompetitivenessScore:
          careerCompetitivenessScore ?? this.careerCompetitivenessScore,
      interviewReadinessScore:
          interviewReadinessScore ?? this.interviewReadinessScore,
      marketDemandScore: marketDemandScore ?? this.marketDemandScore,
      resumeStrengthScore: resumeStrengthScore ?? this.resumeStrengthScore,
      detectedSkills: detectedSkills ?? this.detectedSkills,
      missingSkills: missingSkills ?? this.missingSkills,
      recommendedSkills: recommendedSkills ?? this.recommendedSkills,
      keywords: keywords ?? this.keywords,
      missingKeywords: missingKeywords ?? this.missingKeywords,
      strengths: strengths ?? this.strengths,
      improvements: improvements ?? this.improvements,
      summary: summary ?? this.summary,
      rewriteSuggestions: rewriteSuggestions ?? this.rewriteSuggestions,
      careerAdvice: careerAdvice ?? this.careerAdvice,
      interviewTips: interviewTips ?? this.interviewTips,
      sectionScores: sectionScores ?? this.sectionScores,
      projectAnalysis: projectAnalysis ?? this.projectAnalysis,
      experienceRelevance: experienceRelevance ?? this.experienceRelevance,
      educationAnalysis: educationAnalysis ?? this.educationAnalysis,
      roadmap: roadmap ?? this.roadmap,
      context: context ?? this.context,
      analyzedAt: analyzedAt ?? this.analyzedAt,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'resumeId': resumeId,
      'atsScore': atsScore,
      'keywordMatch': keywordMatch,
      'formattingScore': formattingScore,
      'contentScore': contentScore,
      'jobReadinessScore': jobReadinessScore,
      'careerCompetitivenessScore': careerCompetitivenessScore,
      'interviewReadinessScore': interviewReadinessScore,
      'marketDemandScore': marketDemandScore,
      'resumeStrengthScore': resumeStrengthScore,
      'detectedSkills': detectedSkills,
      'missingSkills': missingSkills,
      'recommendedSkills': recommendedSkills,
      'keywords': keywords,
      'missingKeywords': missingKeywords,
      'strengths': strengths,
      'improvements': improvements,
      'summary': summary,
      'rewriteSuggestions': rewriteSuggestions,
      'careerAdvice': careerAdvice,
      'interviewTips': interviewTips,
      'sectionScores': sectionScores,
      'projectAnalysis': projectAnalysis,
      'experienceRelevance': experienceRelevance,
      'educationAnalysis': educationAnalysis,
      'roadmap': roadmap.map((r) => r.toMap()).toList(),
      'context': context?.toMap(),
      'analyzedAt': analyzedAt != null ? Timestamp.fromDate(analyzedAt!) : null,
      'isComplete': isComplete,
    };
  }

  factory ResumeAnalysisModel.fromMap(Map<String, dynamic> map) {
    return ResumeAnalysisModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      resumeId: map['resumeId'] ?? '',
      atsScore: (map['atsScore'] ?? 0.0).toDouble(),
      keywordMatch: (map['keywordMatch'] ?? 0.0).toDouble(),
      formattingScore: (map['formattingScore'] ?? 0.0).toDouble(),
      contentScore: (map['contentScore'] ?? 0.0).toDouble(),
      jobReadinessScore: (map['jobReadinessScore'] ?? 0.0).toDouble(),
      careerCompetitivenessScore:
          (map['careerCompetitivenessScore'] ?? 0.0).toDouble(),
      interviewReadinessScore:
          (map['interviewReadinessScore'] ?? 0.0).toDouble(),
      marketDemandScore: (map['marketDemandScore'] ?? 0.0).toDouble(),
      resumeStrengthScore: (map['resumeStrengthScore'] ?? 0.0).toDouble(),
      detectedSkills: List<String>.from(map['detectedSkills'] ?? []),
      missingSkills: List<String>.from(map['missingSkills'] ?? []),
      recommendedSkills: List<String>.from(map['recommendedSkills'] ?? []),
      keywords: List<String>.from(map['keywords'] ?? []),
      missingKeywords: List<String>.from(map['missingKeywords'] ?? []),
      strengths: List<String>.from(map['strengths'] ?? []),
      improvements: List<String>.from(map['improvements'] ?? []),
      summary: map['summary'],
      rewriteSuggestions: List<String>.from(map['rewriteSuggestions'] ?? []),
      careerAdvice: List<String>.from(map['careerAdvice'] ?? []),
      interviewTips: List<String>.from(map['interviewTips'] ?? []),
      sectionScores: Map<String, dynamic>.from(map['sectionScores'] ?? {}),
      projectAnalysis: (map['projectAnalysis'] as List<dynamic>?)
              ?.map((p) => Map<String, dynamic>.from(p))
              .toList() ??
          [],
      experienceRelevance: map['experienceRelevance'],
      educationAnalysis: map['educationAnalysis'],
      roadmap: (map['roadmap'] as List<dynamic>?)
              ?.map((r) => RoadmapMonth.fromMap(Map<String, dynamic>.from(r)))
              .toList() ??
          [],
      context: map['context'] != null
          ? ResumeAnalysisContext.fromMap(
              Map<String, dynamic>.from(map['context']))
          : null,
      analyzedAt: map['analyzedAt'] != null
          ? (map['analyzedAt'] as Timestamp).toDate()
          : null,
      isComplete: map['isComplete'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        resumeId,
        atsScore,
        keywordMatch,
        formattingScore,
        contentScore,
        jobReadinessScore,
        careerCompetitivenessScore,
        interviewReadinessScore,
        marketDemandScore,
        resumeStrengthScore,
        detectedSkills,
        missingSkills,
        recommendedSkills,
        keywords,
        missingKeywords,
        strengths,
        improvements,
        summary,
        rewriteSuggestions,
        careerAdvice,
        interviewTips,
        sectionScores,
        projectAnalysis,
        experienceRelevance,
        educationAnalysis,
        roadmap,
        context,
        analyzedAt,
        isComplete,
      ];
}

// ─────────────────────────────────────────────────────────────────────────────
// JobDescriptionMatchModel — resume vs JD analysis result
// ─────────────────────────────────────────────────────────────────────────────
class JobDescriptionMatchModel extends Equatable {
  final String id;
  final String userId;
  final String resumeId;
  final String jobDescription;
  final String? jobTitle;
  final double matchPercentage;
  final List<String> matchedKeywords;
  final List<String> missingKeywords;
  final List<String> matchedSkills;
  final List<String> missingSkills;
  final List<String> missingTechnologies;
  final List<String> resumeGaps;
  final List<String> optimizationTips;
  final DateTime? analyzedAt;

  const JobDescriptionMatchModel({
    required this.id,
    required this.userId,
    required this.resumeId,
    required this.jobDescription,
    this.jobTitle,
    this.matchPercentage = 0.0,
    this.matchedKeywords = const [],
    this.missingKeywords = const [],
    this.matchedSkills = const [],
    this.missingSkills = const [],
    this.missingTechnologies = const [],
    this.resumeGaps = const [],
    this.optimizationTips = const [],
    this.analyzedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        resumeId,
        jobDescription,
        jobTitle,
        matchPercentage,
        matchedKeywords,
        missingKeywords,
        matchedSkills,
        missingSkills,
        missingTechnologies,
        resumeGaps,
        optimizationTips,
        analyzedAt,
      ];
}
