import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// User account type / role
enum UserType { talent, recruiter, organizer }

/// Work mode preference
enum WorkMode { remote, hybrid, onsite, any }

/// Experience level
enum ExperienceLevel { student, fresher, intern, junior, midLevel, senior, lead, executive }

/// A single education entry
class EducationEntry extends Equatable {
  final String institution;
  final String degree;
  final String field;
  final String? grade;
  final int? startYear;
  final int? endYear;
  final bool isCurrent;

  const EducationEntry({
    required this.institution,
    required this.degree,
    required this.field,
    this.grade,
    this.startYear,
    this.endYear,
    this.isCurrent = false,
  });

  EducationEntry copyWith({
    String? institution,
    String? degree,
    String? field,
    String? grade,
    int? startYear,
    int? endYear,
    bool? isCurrent,
  }) =>
      EducationEntry(
        institution: institution ?? this.institution,
        degree: degree ?? this.degree,
        field: field ?? this.field,
        grade: grade ?? this.grade,
        startYear: startYear ?? this.startYear,
        endYear: endYear ?? this.endYear,
        isCurrent: isCurrent ?? this.isCurrent,
      );

  Map<String, dynamic> toMap() => {
        'institution': institution,
        'degree': degree,
        'field': field,
        'grade': grade,
        'startYear': startYear,
        'endYear': endYear,
        'isCurrent': isCurrent,
      };

  factory EducationEntry.fromMap(Map<String, dynamic> map) => EducationEntry(
        institution: map['institution'] ?? '',
        degree: map['degree'] ?? '',
        field: map['field'] ?? '',
        grade: map['grade'],
        startYear: map['startYear'],
        endYear: map['endYear'],
        isCurrent: map['isCurrent'] ?? false,
      );

  @override
  List<Object?> get props => [institution, degree, field, grade, startYear, endYear, isCurrent];
}

/// A single work experience entry
class ExperienceEntry extends Equatable {
  final String company;
  final String role;
  final String? description;
  final String? location;
  final bool isRemote;
  final int? startMonth;
  final int? startYear;
  final int? endMonth;
  final int? endYear;
  final bool isCurrent;
  final List<String> skills;

  const ExperienceEntry({
    required this.company,
    required this.role,
    this.description,
    this.location,
    this.isRemote = false,
    this.startMonth,
    this.startYear,
    this.endMonth,
    this.endYear,
    this.isCurrent = false,
    this.skills = const [],
  });

  ExperienceEntry copyWith({
    String? company,
    String? role,
    String? description,
    String? location,
    bool? isRemote,
    int? startMonth,
    int? startYear,
    int? endMonth,
    int? endYear,
    bool? isCurrent,
    List<String>? skills,
  }) =>
      ExperienceEntry(
        company: company ?? this.company,
        role: role ?? this.role,
        description: description ?? this.description,
        location: location ?? this.location,
        isRemote: isRemote ?? this.isRemote,
        startMonth: startMonth ?? this.startMonth,
        startYear: startYear ?? this.startYear,
        endMonth: endMonth ?? this.endMonth,
        endYear: endYear ?? this.endYear,
        isCurrent: isCurrent ?? this.isCurrent,
        skills: skills ?? this.skills,
      );

  Map<String, dynamic> toMap() => {
        'company': company,
        'role': role,
        'description': description,
        'location': location,
        'isRemote': isRemote,
        'startMonth': startMonth,
        'startYear': startYear,
        'endMonth': endMonth,
        'endYear': endYear,
        'isCurrent': isCurrent,
        'skills': skills,
      };

  factory ExperienceEntry.fromMap(Map<String, dynamic> map) => ExperienceEntry(
        company: map['company'] ?? '',
        role: map['role'] ?? '',
        description: map['description'],
        location: map['location'],
        isRemote: map['isRemote'] ?? false,
        startMonth: map['startMonth'],
        startYear: map['startYear'],
        endMonth: map['endMonth'],
        endYear: map['endYear'],
        isCurrent: map['isCurrent'] ?? false,
        skills: List<String>.from(map['skills'] ?? []),
      );

  @override
  List<Object?> get props => [company, role, description, location, isRemote, startMonth, startYear, endMonth, endYear, isCurrent, skills];
}

/// A certification entry
class CertificationEntry extends Equatable {
  final String name;
  final String issuer;
  final String? credentialId;
  final int? issuedYear;
  final int? expiryYear;
  final String? url;

  const CertificationEntry({
    required this.name,
    required this.issuer,
    this.credentialId,
    this.issuedYear,
    this.expiryYear,
    this.url,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'issuer': issuer,
        'credentialId': credentialId,
        'issuedYear': issuedYear,
        'expiryYear': expiryYear,
        'url': url,
      };

  factory CertificationEntry.fromMap(Map<String, dynamic> map) => CertificationEntry(
        name: map['name'] ?? '',
        issuer: map['issuer'] ?? '',
        credentialId: map['credentialId'],
        issuedYear: map['issuedYear'],
        expiryYear: map['expiryYear'],
        url: map['url'],
      );

  @override
  List<Object?> get props => [name, issuer, credentialId, issuedYear, expiryYear, url];
}

/// A project entry
class ProjectEntry extends Equatable {
  final String name;
  final String description;
  final List<String> skills;
  final String? url;
  final String? githubUrl;
  final int? year;

  const ProjectEntry({
    required this.name,
    required this.description,
    this.skills = const [],
    this.url,
    this.githubUrl,
    this.year,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'skills': skills,
        'url': url,
        'githubUrl': githubUrl,
        'year': year,
      };

  factory ProjectEntry.fromMap(Map<String, dynamic> map) => ProjectEntry(
        name: map['name'] ?? '',
        description: map['description'] ?? '',
        skills: List<String>.from(map['skills'] ?? []),
        url: map['url'],
        githubUrl: map['githubUrl'],
        year: map['year'],
      );

  @override
  List<Object?> get props => [name, description, skills, url, githubUrl, year];
}

/// Main UserModel — complete career profile
class UserModel extends Equatable {
  // --- Core Identity ---
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final String? bio;

  // --- Role ---
  final UserType userType;

  // --- Career Profile ---
  final List<String> skills;
  final String? experienceLevel;
  final String? industry;
  final String? location;
  final String? targetRole;
  final String? preferredIndustry;
  final WorkMode workMode;
  final String? careerGoal;

  // --- Education & Experience ---
  final List<EducationEntry> education;
  final List<ExperienceEntry> experience;
  final List<CertificationEntry> certifications;
  final List<ProjectEntry> projects;
  final List<String> achievements;
  final List<String> hackathonHistory;

  // --- Social Links ---
  final String? githubUrl;
  final String? linkedinUrl;
  final String? portfolioUrl;

  // --- Resume ---
  final String? resumeUrl;
  final String? resumeId;
  final double? lastAtsScore;

  // --- Account Metadata ---
  final bool isEmailVerified;
  final bool isProfileComplete;
  final bool isAdmin;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;
  final Map<String, dynamic> preferences;

  // --- Activity ---
  final List<String> savedJobIds;
  final List<String> appliedJobIds;
  final int dailySwipeCount;
  final DateTime? lastSwipeReset;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.bio,
    this.userType = UserType.talent,
    this.skills = const [],
    this.experienceLevel,
    this.industry,
    this.location,
    this.targetRole,
    this.preferredIndustry,
    this.workMode = WorkMode.any,
    this.careerGoal,
    this.education = const [],
    this.experience = const [],
    this.certifications = const [],
    this.projects = const [],
    this.achievements = const [],
    this.hackathonHistory = const [],
    this.githubUrl,
    this.linkedinUrl,
    this.portfolioUrl,
    this.resumeUrl,
    this.resumeId,
    this.lastAtsScore,
    this.isEmailVerified = false,
    this.isProfileComplete = false,
    this.isAdmin = false,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
    this.preferences = const {},
    this.savedJobIds = const [],
    this.appliedJobIds = const [],
    this.dailySwipeCount = 0,
    this.lastSwipeReset,
  });

  // ── Profile completion score out of 100 ──────────────────────────
  double get profileCompletionPercentage {
    int score = 0;
    const int total = 20;

    if (displayName != null && displayName!.trim().isNotEmpty) score++;
    if (photoUrl != null && photoUrl!.trim().isNotEmpty) score++;
    if (phoneNumber != null && phoneNumber!.trim().isNotEmpty) score++;
    if (bio != null && bio!.trim().isNotEmpty) score++;
    if (skills.isNotEmpty) score++;
    if (skills.length >= 5) score++; // bonus for 5+ skills
    if (experienceLevel != null && experienceLevel!.trim().isNotEmpty) score++;
    if (industry != null && industry!.trim().isNotEmpty) score++;
    if (location != null && location!.trim().isNotEmpty) score++;
    if (resumeUrl != null && resumeUrl!.trim().isNotEmpty) score++;
    if (education.isNotEmpty) score++;
    if (experience.isNotEmpty) score++;
    if (certifications.isNotEmpty) score++;
    if (projects.isNotEmpty) score++;
    if (githubUrl != null && githubUrl!.trim().isNotEmpty) score++;
    if (linkedinUrl != null && linkedinUrl!.trim().isNotEmpty) score++;
    if (careerGoal != null && careerGoal!.trim().isNotEmpty) score++;
    if (targetRole != null && targetRole!.trim().isNotEmpty) score++;
    if (achievements.isNotEmpty) score++;
    if (portfolioUrl != null && portfolioUrl!.trim().isNotEmpty) score++;

    return score / total;
  }

  /// Human-readable completion label
  String get completionLabel {
    final pct = profileCompletionPercentage;
    if (pct >= 0.9) return 'Excellent';
    if (pct >= 0.7) return 'Good';
    if (pct >= 0.5) return 'Moderate';
    return 'Needs Work';
  }

  // ── copyWith ──────────────────────────────────────────────────────
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? bio,
    UserType? userType,
    List<String>? skills,
    String? experienceLevel,
    String? industry,
    String? location,
    String? targetRole,
    String? preferredIndustry,
    WorkMode? workMode,
    String? careerGoal,
    List<EducationEntry>? education,
    List<ExperienceEntry>? experience,
    List<CertificationEntry>? certifications,
    List<ProjectEntry>? projects,
    List<String>? achievements,
    List<String>? hackathonHistory,
    String? githubUrl,
    String? linkedinUrl,
    String? portfolioUrl,
    String? resumeUrl,
    String? resumeId,
    double? lastAtsScore,
    bool? isEmailVerified,
    bool? isProfileComplete,
    bool? isAdmin,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? preferences,
    List<String>? savedJobIds,
    List<String>? appliedJobIds,
    int? dailySwipeCount,
    DateTime? lastSwipeReset,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      userType: userType ?? this.userType,
      skills: skills ?? this.skills,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      industry: industry ?? this.industry,
      location: location ?? this.location,
      targetRole: targetRole ?? this.targetRole,
      preferredIndustry: preferredIndustry ?? this.preferredIndustry,
      workMode: workMode ?? this.workMode,
      careerGoal: careerGoal ?? this.careerGoal,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      certifications: certifications ?? this.certifications,
      projects: projects ?? this.projects,
      achievements: achievements ?? this.achievements,
      hackathonHistory: hackathonHistory ?? this.hackathonHistory,
      githubUrl: githubUrl ?? this.githubUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      resumeId: resumeId ?? this.resumeId,
      lastAtsScore: lastAtsScore ?? this.lastAtsScore,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
      savedJobIds: savedJobIds ?? this.savedJobIds,
      appliedJobIds: appliedJobIds ?? this.appliedJobIds,
      dailySwipeCount: dailySwipeCount ?? this.dailySwipeCount,
      lastSwipeReset: lastSwipeReset ?? this.lastSwipeReset,
    );
  }

  // ── Serialization ─────────────────────────────────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'userType': userType.name,
      'skills': skills,
      'experienceLevel': experienceLevel,
      'industry': industry,
      'location': location,
      'targetRole': targetRole,
      'preferredIndustry': preferredIndustry,
      'workMode': workMode.name,
      'careerGoal': careerGoal,
      'education': education.map((e) => e.toMap()).toList(),
      'experience': experience.map((e) => e.toMap()).toList(),
      'certifications': certifications.map((e) => e.toMap()).toList(),
      'projects': projects.map((e) => e.toMap()).toList(),
      'achievements': achievements,
      'hackathonHistory': hackathonHistory,
      'githubUrl': githubUrl,
      'linkedinUrl': linkedinUrl,
      'portfolioUrl': portfolioUrl,
      'resumeUrl': resumeUrl,
      'resumeId': resumeId,
      'lastAtsScore': lastAtsScore,
      'isEmailVerified': isEmailVerified,
      'isProfileComplete': isProfileComplete,
      'isAdmin': isAdmin,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
      'preferences': preferences,
      'savedJobIds': savedJobIds,
      'appliedJobIds': appliedJobIds,
      'dailySwipeCount': dailySwipeCount,
      'lastSwipeReset': lastSwipeReset != null ? Timestamp.fromDate(lastSwipeReset!) : null,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      phoneNumber: map['phoneNumber'],
      bio: map['bio'],
      userType: _parseUserType(map['userType']),
      skills: List<String>.from(map['skills'] ?? []),
      experienceLevel: map['experienceLevel'],
      industry: map['industry'],
      location: map['location'],
      targetRole: map['targetRole'],
      preferredIndustry: map['preferredIndustry'],
      workMode: _parseWorkMode(map['workMode']),
      careerGoal: map['careerGoal'],
      education: (map['education'] as List<dynamic>?)
              ?.map((e) => EducationEntry.fromMap(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      experience: (map['experience'] as List<dynamic>?)
              ?.map((e) => ExperienceEntry.fromMap(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      certifications: (map['certifications'] as List<dynamic>?)
              ?.map((e) => CertificationEntry.fromMap(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      projects: (map['projects'] as List<dynamic>?)
              ?.map((e) => ProjectEntry.fromMap(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      achievements: List<String>.from(map['achievements'] ?? []),
      hackathonHistory: List<String>.from(map['hackathonHistory'] ?? []),
      githubUrl: map['githubUrl'],
      linkedinUrl: map['linkedinUrl'],
      portfolioUrl: map['portfolioUrl'],
      resumeUrl: map['resumeUrl'],
      resumeId: map['resumeId'],
      lastAtsScore: (map['lastAtsScore'] as num?)?.toDouble(),
      isEmailVerified: map['isEmailVerified'] ?? false,
      isProfileComplete: map['isProfileComplete'] ?? false,
      isAdmin: map['isAdmin'] ?? false,
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
      lastLoginAt: map['lastLoginAt'] != null ? (map['lastLoginAt'] as Timestamp).toDate() : null,
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
      savedJobIds: List<String>.from(map['savedJobIds'] ?? []),
      appliedJobIds: List<String>.from(map['appliedJobIds'] ?? []),
      dailySwipeCount: map['dailySwipeCount'] ?? 0,
      lastSwipeReset: map['lastSwipeReset'] != null ? (map['lastSwipeReset'] as Timestamp).toDate() : null,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap({...data, 'id': doc.id});
  }

  static UserType _parseUserType(dynamic v) {
    if (v == null) return UserType.talent;
    try {
      return UserType.values.firstWhere((e) => e.name == v);
    } catch (_) {
      return UserType.talent;
    }
  }

  static WorkMode _parseWorkMode(dynamic v) {
    if (v == null) return WorkMode.any;
    try {
      return WorkMode.values.firstWhere((e) => e.name == v);
    } catch (_) {
      return WorkMode.any;
    }
  }

  @override
  List<Object?> get props => [
        id, email, displayName, photoUrl, phoneNumber, bio, userType,
        skills, experienceLevel, industry, location, targetRole,
        preferredIndustry, workMode, careerGoal, education, experience,
        certifications, projects, achievements, hackathonHistory,
        githubUrl, linkedinUrl, portfolioUrl, resumeUrl, resumeId,
        lastAtsScore, isEmailVerified, isProfileComplete, isAdmin,
        createdAt, updatedAt, lastLoginAt, preferences, savedJobIds,
        appliedJobIds, dailySwipeCount, lastSwipeReset,
      ];
}
