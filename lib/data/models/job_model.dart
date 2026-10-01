import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class JobModel extends Equatable {
  final String id;
  final String title;
  final String company;
  final String? companyLogo;
  final String? companyWebsite;
  final String description;
  final String? shortDescription;
  final List<String> requirements;
  final List<String> responsibilities;
  final List<String> skills;
  final String? experienceLevel;
  final String? jobType;
  final String? location;
  final bool isRemote;
  final double? minSalary;
  final double? maxSalary;
  final String? currency;
  final String? industry;
  final String? department;
  final DateTime? postedAt;
  final DateTime? expiresAt;
  final bool isActive;
  final int viewCount;
  final int applyCount;
  final String? recruiterId;
  final Map<String, dynamic> metadata;
  final List<String> tags;

  const JobModel({
    required this.id,
    required this.title,
    required this.company,
    this.companyLogo,
    this.companyWebsite,
    required this.description,
    this.shortDescription,
    this.requirements = const [],
    this.responsibilities = const [],
    this.skills = const [],
    this.experienceLevel,
    this.jobType,
    this.location,
    this.isRemote = false,
    this.minSalary,
    this.maxSalary,
    this.currency = 'USD',
    this.industry,
    this.department,
    this.postedAt,
    this.expiresAt,
    this.isActive = true,
    this.viewCount = 0,
    this.applyCount = 0,
    this.recruiterId,
    this.metadata = const {},
    this.tags = const [],
  });

  JobModel copyWith({
    String? id,
    String? title,
    String? company,
    String? companyLogo,
    String? companyWebsite,
    String? description,
    String? shortDescription,
    List<String>? requirements,
    List<String>? responsibilities,
    List<String>? skills,
    String? experienceLevel,
    String? jobType,
    String? location,
    bool? isRemote,
    double? minSalary,
    double? maxSalary,
    String? currency,
    String? industry,
    String? department,
    DateTime? postedAt,
    DateTime? expiresAt,
    bool? isActive,
    int? viewCount,
    int? applyCount,
    String? recruiterId,
    Map<String, dynamic>? metadata,
    List<String>? tags,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      companyLogo: companyLogo ?? this.companyLogo,
      companyWebsite: companyWebsite ?? this.companyWebsite,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      requirements: requirements ?? this.requirements,
      responsibilities: responsibilities ?? this.responsibilities,
      skills: skills ?? this.skills,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      jobType: jobType ?? this.jobType,
      location: location ?? this.location,
      isRemote: isRemote ?? this.isRemote,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      currency: currency ?? this.currency,
      industry: industry ?? this.industry,
      department: department ?? this.department,
      postedAt: postedAt ?? this.postedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      viewCount: viewCount ?? this.viewCount,
      applyCount: applyCount ?? this.applyCount,
      recruiterId: recruiterId ?? this.recruiterId,
      metadata: metadata ?? this.metadata,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'companyLogo': companyLogo,
      'companyWebsite': companyWebsite,
      'description': description,
      'shortDescription': shortDescription,
      'requirements': requirements,
      'responsibilities': responsibilities,
      'skills': skills,
      'experienceLevel': experienceLevel,
      'jobType': jobType,
      'location': location,
      'isRemote': isRemote,
      'minSalary': minSalary,
      'maxSalary': maxSalary,
      'currency': currency,
      'industry': industry,
      'department': department,
      'postedAt': postedAt != null ? Timestamp.fromDate(postedAt!) : null,
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'isActive': isActive,
      'viewCount': viewCount,
      'applyCount': applyCount,
      'recruiterId': recruiterId,
      'metadata': metadata,
      'tags': tags,
    };
  }

  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      company: map['company'] ?? '',
      companyLogo: map['companyLogo'],
      companyWebsite: map['companyWebsite'],
      description: map['description'] ?? '',
      shortDescription: map['shortDescription'],
      requirements: List<String>.from(map['requirements'] ?? []),
      responsibilities: List<String>.from(map['responsibilities'] ?? []),
      skills: List<String>.from(map['skills'] ?? []),
      experienceLevel: map['experienceLevel'],
      jobType: map['jobType'],
      location: map['location'],
      isRemote: map['isRemote'] ?? false,
      minSalary: map['minSalary']?.toDouble(),
      maxSalary: map['maxSalary']?.toDouble(),
      currency: map['currency'] ?? 'USD',
      industry: map['industry'],
      department: map['department'],
      postedAt: map['postedAt'] != null ? (map['postedAt'] as Timestamp).toDate() : null,
      expiresAt: map['expiresAt'] != null ? (map['expiresAt'] as Timestamp).toDate() : null,
      isActive: map['isActive'] ?? true,
      viewCount: map['viewCount'] ?? 0,
      applyCount: map['applyCount'] ?? 0,
      recruiterId: map['recruiterId'],
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  @override
  List<Object?> get props => [
        id, title, company, companyLogo, companyWebsite, description,
        shortDescription, requirements, responsibilities, skills,
        experienceLevel, jobType, location, isRemote, minSalary, maxSalary,
        currency, industry, department, postedAt, expiresAt, isActive,
        viewCount, applyCount, recruiterId, metadata, tags,
      ];
}

class JobSwipeModel extends Equatable {
  final String id;
  final String userId;
  final String jobId;
  final String action; // 'like', 'dislike', 'save', 'superlike'
  final DateTime? swipedAt;
  final double? matchScore;

  const JobSwipeModel({
    required this.id,
    required this.userId,
    required this.jobId,
    required this.action,
    this.swipedAt,
    this.matchScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'jobId': jobId,
      'action': action,
      'swipedAt': swipedAt != null ? Timestamp.fromDate(swipedAt!) : null,
      'matchScore': matchScore,
    };
  }

  factory JobSwipeModel.fromMap(Map<String, dynamic> map) {
    return JobSwipeModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      jobId: map['jobId'] ?? '',
      action: map['action'] ?? 'dislike',
      swipedAt: map['swipedAt'] != null ? (map['swipedAt'] as Timestamp).toDate() : null,
      matchScore: map['matchScore']?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [id, userId, jobId, action, swipedAt, matchScore];
}

class JobApplicationModel extends Equatable {
  final String id;
  final String userId;
  final String jobId;
  final String status; // 'pending', 'reviewing', 'interview', 'offered', 'rejected', 'withdrawn'
  final String? coverLetter;
  final String? resumeUrl;
  final DateTime? appliedAt;
  final DateTime? updatedAt;
  final Map<String, dynamic> timeline;

  const JobApplicationModel({
    required this.id,
    required this.userId,
    required this.jobId,
    this.status = 'pending',
    this.coverLetter,
    this.resumeUrl,
    this.appliedAt,
    this.updatedAt,
    this.timeline = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'jobId': jobId,
      'status': status,
      'coverLetter': coverLetter,
      'resumeUrl': resumeUrl,
      'appliedAt': appliedAt != null ? Timestamp.fromDate(appliedAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'timeline': timeline,
    };
  }

  factory JobApplicationModel.fromMap(Map<String, dynamic> map) {
    return JobApplicationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      jobId: map['jobId'] ?? '',
      status: map['status'] ?? 'pending',
      coverLetter: map['coverLetter'],
      resumeUrl: map['resumeUrl'],
      appliedAt: map['appliedAt'] != null ? (map['appliedAt'] as Timestamp).toDate() : null,
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
      timeline: Map<String, dynamic>.from(map['timeline'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [id, userId, jobId, status, coverLetter, resumeUrl, appliedAt, updatedAt, timeline];
}
