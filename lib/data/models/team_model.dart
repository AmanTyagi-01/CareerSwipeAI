import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TeamMember extends Equatable {
  final String userId;
  final String displayName;
  final String? photoUrl;
  final List<String> skills;
  final String role; // e.g., 'ML Engineer', 'Frontend Dev'
  final bool isLeader;

  const TeamMember({
    required this.userId,
    required this.displayName,
    this.photoUrl,
    this.skills = const [],
    this.role = 'Member',
    this.isLeader = false,
  });

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'skills': skills,
        'role': role,
        'isLeader': isLeader,
      };

  factory TeamMember.fromMap(Map<String, dynamic> map) => TeamMember(
        userId: map['userId'] ?? '',
        displayName: map['displayName'] ?? 'Anonymous',
        photoUrl: map['photoUrl'],
        skills: List<String>.from(map['skills'] ?? []),
        role: map['role'] ?? 'Member',
        isLeader: map['isLeader'] ?? false,
      );

  @override
  List<Object?> get props => [userId, displayName, photoUrl, skills, role, isLeader];
}

class TeamModel extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String leaderId;
  final List<TeamMember> members;
  final List<String> requiredSkills; // skills needed for open slots
  final List<String> tags; // e.g., ['AI', 'Web', 'Game Dev']
  final String? targetHackathon; // hackathon they're targeting
  final String? targetHackathonId;
  final int maxSize;
  final bool isOpen; // accepting new members
  final DateTime? createdAt;
  final String? projectIdea;

  const TeamModel({
    required this.id,
    required this.name,
    this.description,
    required this.leaderId,
    this.members = const [],
    this.requiredSkills = const [],
    this.tags = const [],
    this.targetHackathon,
    this.targetHackathonId,
    this.maxSize = 4,
    this.isOpen = true,
    this.createdAt,
    this.projectIdea,
  });

  int get openSlots => maxSize - members.length;
  bool get isFull => members.length >= maxSize;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'leaderId': leaderId,
        'members': members.map((m) => m.toMap()).toList(),
        'requiredSkills': requiredSkills,
        'tags': tags,
        'targetHackathon': targetHackathon,
        'targetHackathonId': targetHackathonId,
        'maxSize': maxSize,
        'isOpen': isOpen,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
        'projectIdea': projectIdea,
      };

  factory TeamModel.fromMap(Map<String, dynamic> map) => TeamModel(
        id: map['id'] ?? '',
        name: map['name'] ?? 'Unnamed Team',
        description: map['description'],
        leaderId: map['leaderId'] ?? '',
        members: (map['members'] as List<dynamic>?)
                ?.map((m) => TeamMember.fromMap(Map<String, dynamic>.from(m)))
                .toList() ??
            [],
        requiredSkills: List<String>.from(map['requiredSkills'] ?? []),
        tags: List<String>.from(map['tags'] ?? []),
        targetHackathon: map['targetHackathon'],
        targetHackathonId: map['targetHackathonId'],
        maxSize: map['maxSize'] ?? 4,
        isOpen: map['isOpen'] ?? true,
        createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
        projectIdea: map['projectIdea'],
      );

  @override
  List<Object?> get props => [
        id, name, description, leaderId, members, requiredSkills, tags,
        targetHackathon, targetHackathonId, maxSize, isOpen, createdAt, projectIdea,
      ];
}
