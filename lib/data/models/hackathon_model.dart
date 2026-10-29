import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class HackathonModel extends Equatable {
  final String id;
  final String title;
  final String organizer;
  final String? organizerLogo;
  final String description;
  final String? shortDescription;
  final List<String> themes; // e.g., ['AI', 'Web3', 'Healthcare']
  final List<String> requiredSkills;
  final String mode; // online | offline | hybrid
  final String? location;
  final int? minTeamSize;
  final int? maxTeamSize;
  final String? prizePool;
  final List<Map<String, String>> prizes; // [{position: '1st', amount: '₹1L'}]
  final DateTime? registrationDeadline;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? postedAt;
  final bool isActive;
  final String? registrationUrl;
  final String? websiteUrl;
  final String? organizerId;
  final int? participantCount;
  final List<String> eligibility; // e.g., ['College students', 'Open to all']
  final String? difficulty; // beginner | intermediate | advanced

  const HackathonModel({
    required this.id,
    required this.title,
    required this.organizer,
    this.organizerLogo,
    required this.description,
    this.shortDescription,
    this.themes = const [],
    this.requiredSkills = const [],
    this.mode = 'online',
    this.location,
    this.minTeamSize,
    this.maxTeamSize,
    this.prizePool,
    this.prizes = const [],
    this.registrationDeadline,
    this.startDate,
    this.endDate,
    this.postedAt,
    this.isActive = true,
    this.registrationUrl,
    this.websiteUrl,
    this.organizerId,
    this.participantCount,
    this.eligibility = const [],
    this.difficulty,
  });

  bool get isRegistrationOpen {
    if (registrationDeadline == null) return true;
    return DateTime.now().isBefore(registrationDeadline!);
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'organizer': organizer,
        'organizerLogo': organizerLogo,
        'description': description,
        'shortDescription': shortDescription,
        'themes': themes,
        'requiredSkills': requiredSkills,
        'mode': mode,
        'location': location,
        'minTeamSize': minTeamSize,
        'maxTeamSize': maxTeamSize,
        'prizePool': prizePool,
        'prizes': prizes,
        'registrationDeadline': registrationDeadline != null ? Timestamp.fromDate(registrationDeadline!) : null,
        'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
        'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
        'postedAt': postedAt != null ? Timestamp.fromDate(postedAt!) : null,
        'isActive': isActive,
        'registrationUrl': registrationUrl,
        'websiteUrl': websiteUrl,
        'organizerId': organizerId,
        'participantCount': participantCount,
        'eligibility': eligibility,
        'difficulty': difficulty,
      };

  factory HackathonModel.fromMap(Map<String, dynamic> map) => HackathonModel(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        organizer: map['organizer'] ?? '',
        organizerLogo: map['organizerLogo'],
        description: map['description'] ?? '',
        shortDescription: map['shortDescription'],
        themes: List<String>.from(map['themes'] ?? []),
        requiredSkills: List<String>.from(map['requiredSkills'] ?? []),
        mode: map['mode'] ?? 'online',
        location: map['location'],
        minTeamSize: map['minTeamSize'],
        maxTeamSize: map['maxTeamSize'],
        prizePool: map['prizePool'],
        prizes: (map['prizes'] as List<dynamic>?)
                ?.map((p) => Map<String, String>.from(p))
                .toList() ??
            [],
        registrationDeadline: map['registrationDeadline'] != null
            ? (map['registrationDeadline'] as Timestamp).toDate()
            : null,
        startDate: map['startDate'] != null ? (map['startDate'] as Timestamp).toDate() : null,
        endDate: map['endDate'] != null ? (map['endDate'] as Timestamp).toDate() : null,
        postedAt: map['postedAt'] != null ? (map['postedAt'] as Timestamp).toDate() : null,
        isActive: map['isActive'] ?? true,
        registrationUrl: map['registrationUrl'],
        websiteUrl: map['websiteUrl'],
        organizerId: map['organizerId'],
        participantCount: map['participantCount'],
        eligibility: List<String>.from(map['eligibility'] ?? []),
        difficulty: map['difficulty'],
      );

  @override
  List<Object?> get props => [
        id, title, organizer, organizerLogo, description, shortDescription,
        themes, requiredSkills, mode, location, minTeamSize, maxTeamSize,
        prizePool, prizes, registrationDeadline, startDate, endDate, postedAt,
        isActive, registrationUrl, websiteUrl, organizerId, participantCount,
        eligibility, difficulty,
      ];
}
