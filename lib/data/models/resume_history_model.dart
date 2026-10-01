import 'package:equatable/equatable.dart';
import 'resume_model.dart';

class ResumeHistoryModel extends Equatable {
  final String userId;
  final List<ResumeModel> resumes;
  final DateTime updatedAt;

  const ResumeHistoryModel({
    required this.userId,
    required this.resumes,
    required this.updatedAt,
  });

  ResumeModel? get activeResume {
    try {
      return resumes.firstWhere((r) => r.isActive);
    } catch (_) {
      return resumes.isNotEmpty ? resumes.first : null;
    }
  }

  List<ResumeModel> get sortedResumes {
    final list = List<ResumeModel>.from(resumes);
    list.sort((a, b) => b.version.compareTo(a.version));
    return list;
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'resumes': resumes.map((r) => r.toMap()).toList(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ResumeHistoryModel.fromMap(Map<String, dynamic> map) {
    return ResumeHistoryModel(
      userId: map['userId'] ?? '',
      resumes: (map['resumes'] as List<dynamic>?)
              ?.map((r) => ResumeModel.fromMap(Map<String, dynamic>.from(r)))
              .toList() ??
          [],
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [userId, resumes, updatedAt];
}
