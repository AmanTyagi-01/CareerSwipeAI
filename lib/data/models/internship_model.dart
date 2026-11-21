import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class InternshipModel extends Equatable {
  final String id;
  final String title;
  final String company;
  final String? companyLogo;
  final String description;
  final String? shortDescription;
  final List<String> skills;
  final String? duration; // e.g., '3 months', '6 months'
  final bool isPaid;
  final double? stipend;
  final String? currency;
  final String? location;
  final bool isRemote;
  final String? industry;
  final String? eligibility; // e.g., '3rd year CS students'
  final int? openings;
  final DateTime? applyBy;
  final DateTime? startDate;
  final DateTime? postedAt;
  final bool isActive;
  final String? applyUrl;
  final String? recruiterId;

  const InternshipModel({
    required this.id,
    required this.title,
    required this.company,
    this.companyLogo,
    required this.description,
    this.shortDescription,
    this.skills = const [],
    this.duration,
    this.isPaid = false,
    this.stipend,
    this.currency = 'INR',
    this.location,
    this.isRemote = false,
    this.industry,
    this.eligibility,
    this.openings,
    this.applyBy,
    this.startDate,
    this.postedAt,
    this.isActive = true,
    this.applyUrl,
    this.recruiterId,
  });

  String get stipendDisplay {
    if (!isPaid) return 'Unpaid';
    if (stipend == null) return 'Stipend Provided';
    return '${currency ?? '₹'}${stipend!.toStringAsFixed(0)}/month';
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'company': company,
        'companyLogo': companyLogo,
        'description': description,
        'shortDescription': shortDescription,
        'skills': skills,
        'duration': duration,
        'isPaid': isPaid,
        'stipend': stipend,
        'currency': currency,
        'location': location,
        'isRemote': isRemote,
        'industry': industry,
        'eligibility': eligibility,
        'openings': openings,
        'applyBy': applyBy != null ? Timestamp.fromDate(applyBy!) : null,
        'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
        'postedAt': postedAt != null ? Timestamp.fromDate(postedAt!) : null,
        'isActive': isActive,
        'applyUrl': applyUrl,
        'recruiterId': recruiterId,
      };

  factory InternshipModel.fromMap(Map<String, dynamic> map) => InternshipModel(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        company: map['company'] ?? '',
        companyLogo: map['companyLogo'],
        description: map['description'] ?? '',
        shortDescription: map['shortDescription'],
        skills: List<String>.from(map['skills'] ?? []),
        duration: map['duration'],
        isPaid: map['isPaid'] ?? false,
        stipend: (map['stipend'] as num?)?.toDouble(),
        currency: map['currency'] ?? 'INR',
        location: map['location'],
        isRemote: map['isRemote'] ?? false,
        industry: map['industry'],
        eligibility: map['eligibility'],
        openings: map['openings'],
        applyBy: map['applyBy'] != null
            ? (map['applyBy'] as Timestamp).toDate()
            : null,
        startDate: map['startDate'] != null
            ? (map['startDate'] as Timestamp).toDate()
            : null,
        postedAt: map['postedAt'] != null
            ? (map['postedAt'] as Timestamp).toDate()
            : null,
        isActive: map['isActive'] ?? true,
        applyUrl: map['applyUrl'],
        recruiterId: map['recruiterId'],
      );

  @override
  List<Object?> get props => [
        id,
        title,
        company,
        companyLogo,
        description,
        shortDescription,
        skills,
        duration,
        isPaid,
        stipend,
        currency,
        location,
        isRemote,
        industry,
        eligibility,
        openings,
        applyBy,
        startDate,
        postedAt,
        isActive,
        applyUrl,
        recruiterId,
      ];
}
