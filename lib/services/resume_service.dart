import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import '../core/errors/exceptions.dart';
import '../core/utils/app_utils.dart';
import '../core/utils/logger.dart';
import '../data/models/resume_model.dart';
import 'document_parser_service.dart';
import 'ai_service.dart';

class ResumeService {
  final FirebaseFirestore? _firestore;
  final FirebaseStorage? _storage;
  final DocumentParserService _documentParserService;
  final AIService _aiService;

  static const int _maxRetries = 3;

  // Local state starts completely empty for genuine clean fresh user state
  static final List<ResumeModel> _localResumes = [];

  ResumeService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    DocumentParserService? documentParserService,
    AIService? aiService,
  })  : _firestore = firestore ??
            (Firebase.apps.isNotEmpty ? FirebaseFirestore.instance : null),
        _storage = storage ??
            (Firebase.apps.isNotEmpty ? FirebaseStorage.instance : null),
        _documentParserService =
            documentParserService ?? DocumentParserService(),
        _aiService = aiService ?? AIService();

  Future<ResumeModel> uploadResume(String userId, PlatformFile file) async {
    final extension = AppUtils.getFileExtension(file.name);
    if (!['pdf', 'doc', 'docx'].contains(extension)) {
      throw FileException(
          message: 'Only PDF, DOC, and DOCX files are supported.');
    }

    if (file.size > 10 * 1024 * 1024) {
      throw FileException(message: 'File size exceeds 10MB limit.');
    }

    // Real document text extraction
    final extractedText = await _documentParserService.extractText(file);

    // Initial ATS evaluation from extracted text
    final preliminaryResume = ResumeModel(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      fileName: file.name,
      fileUrl: file.path ?? 'file://${file.name}',
      fileSize: file.size,
      fileType: extension,
      extractedText: extractedText,
      uploadedAt: DateTime.now(),
      isActive: true,
      skills: const [],
    );

    final initialAnalysis = await _aiService.analyzeResume(
      preliminaryResume,
      extractedText: extractedText,
    );

    if (_firestore == null || _storage == null) {
      final userResumes =
          _localResumes.where((r) => r.userId == userId).toList();
      final newVersion = userResumes.length + 1;

      final resume = preliminaryResume.copyWith(
        version: newVersion,
        atsScore: initialAnalysis.atsScore,
        skills: initialAnalysis.detectedSkills,
        atsBreakdown: initialAnalysis.sectionScores,
      );

      // Deactivate older resumes
      for (int i = 0; i < _localResumes.length; i++) {
        if (_localResumes[i].userId == userId) {
          _localResumes[i] = _localResumes[i].copyWith(isActive: false);
        }
      }

      _localResumes.insert(0, resume);
      AppLogger.info(
          'Resume stored locally with real extraction: ${resume.id} (${resume.skills.length} skills detected, ATS=${resume.atsScore})',
          tag: 'ResumeService');
      return resume;
    }

    try {
      if (file.path == null) {
        throw FileException(message: 'Invalid file path.');
      }

      AppLogger.info('Starting resume upload for user $userId',
          tag: 'ResumeService');

      final fileName = '${AppUtils.generateId()}_$userId.$extension';
      final ref = _storage.ref().child('resumes/$userId/$fileName');

      // Upload with retry logic
      String downloadUrl = '';
      for (int attempt = 1; attempt <= _maxRetries; attempt++) {
        try {
          final uploadTask = await ref.putFile(File(file.path!));
          downloadUrl = await uploadTask.ref.getDownloadURL();
          AppLogger.info('Upload successful on attempt $attempt',
              tag: 'ResumeService');
          break;
        } on FirebaseException catch (e) {
          AppLogger.warning('Upload attempt $attempt failed: ${e.message}',
              tag: 'ResumeService');
          if (attempt == _maxRetries) rethrow;
          await Future.delayed(Duration(seconds: attempt));
        }
      }

      // Query existing resumes to calculate version
      final existingResumes = await getUserResumes(userId);
      final newVersion = existingResumes.length + 1;

      // Deactivate all previous resumes in batch
      final batch = _firestore.batch();
      for (final existing in existingResumes) {
        if (existing.isActive) {
          batch.update(
            _firestore.collection('resumes').doc(existing.id),
            {
              'isActive': false,
              'updatedAt': Timestamp.fromDate(DateTime.now())
            },
          );
        }
      }

      final resume = ResumeModel(
        id: AppUtils.generateId(),
        userId: userId,
        fileName: file.name,
        fileUrl: downloadUrl,
        fileSize: file.size,
        fileType: extension,
        extractedText: extractedText,
        uploadedAt: DateTime.now(),
        isActive: true,
        version: newVersion,
        atsScore: initialAnalysis.atsScore,
        skills: initialAnalysis.detectedSkills,
        atsBreakdown: initialAnalysis.sectionScores,
      );

      batch.set(
          _firestore.collection('resumes').doc(resume.id), resume.toMap());

      // Update user's active resume reference
      batch.update(_firestore.collection('users').doc(userId), {
        'resumeUrl': downloadUrl,
        'resumeId': resume.id,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      await batch.commit();
      AppLogger.info('Resume saved to Firestore: ${resume.id}',
          tag: 'ResumeService');
      return resume;
    } on FileException {
      rethrow;
    } on FirebaseException catch (e) {
      AppLogger.error('Firebase error uploading resume',
          tag: 'ResumeService', error: e, stackTrace: e.stackTrace);
      throw FileException(message: 'Failed to upload resume: ${e.message}');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error uploading resume',
          tag: 'ResumeService', error: e, stackTrace: stackTrace);
      throw FileException(
          message: 'Failed to upload resume: $e', stackTrace: stackTrace);
    }
  }

  Future<List<ResumeModel>> getUserResumes(String userId) async {
    if (_firestore == null) {
      return _localResumes.where((r) => r.userId == userId).toList();
    }

    try {
      final snapshot = await _firestore
          .collection('resumes')
          .where('userId', isEqualTo: userId)
          .orderBy('uploadedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ResumeModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      AppLogger.warning('Failed to fetch resumes from Firestore: $e',
          tag: 'ResumeService');
      return _localResumes.where((r) => r.userId == userId).toList();
    }
  }

  Future<ResumeModel?> getActiveResume(String userId) async {
    final resumes = await getUserResumes(userId);
    try {
      return resumes.firstWhere((r) => r.isActive);
    } catch (_) {
      return resumes.isNotEmpty ? resumes.first : null;
    }
  }

  Future<ResumeModel?> getResumeById(String resumeId) async {
    if (_firestore == null) {
      try {
        return _localResumes.firstWhere((r) => r.id == resumeId);
      } catch (_) {
        return null;
      }
    }
    try {
      final doc = await _firestore.collection('resumes').doc(resumeId).get();
      if (!doc.exists) return null;
      return ResumeModel.fromFirestore(doc);
    } catch (e) {
      AppLogger.warning('Failed to fetch resume by id: $e',
          tag: 'ResumeService');
      try {
        return _localResumes.firstWhere((r) => r.id == resumeId);
      } catch (_) {
        return null;
      }
    }
  }

  Future<String?> extractTextFromResume(String fileUrl) async {
    for (final r in _localResumes) {
      if (r.fileUrl == fileUrl || r.id == fileUrl || r.fileName == fileUrl) {
        if (r.extractedText != null && r.extractedText!.isNotEmpty) {
          return r.extractedText;
        }
      }
    }
    return null;
  }

  Future<void> renameResume(
      String resumeId, String userId, String newName) async {
    if (_firestore == null) {
      final idx = _localResumes.indexWhere((r) => r.id == resumeId);
      if (idx != -1) {
        _localResumes[idx] = _localResumes[idx].copyWith(fileName: newName);
      }
      return;
    }
    try {
      await _firestore.collection('resumes').doc(resumeId).update({
        'fileName': newName,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      AppLogger.error('Failed to rename resume: $e', tag: 'ResumeService');
      throw FileException(message: 'Failed to rename resume: $e');
    }
  }

  Future<Map<String, dynamic>> compareResumes(
      String resumeId1, String resumeId2) async {
    final r1 = await getResumeById(resumeId1);
    final r2 = await getResumeById(resumeId2);
    return {
      'resume1': r1?.toMap(),
      'resume2': r2?.toMap(),
      'scoreDifference': ((r2?.atsScore ?? 0) - (r1?.atsScore ?? 0)).toDouble(),
    };
  }

  Future<String> downloadResume(String fileUrl) async {
    return fileUrl;
  }

  Future<void> deleteResume(String resumeId, String userId) async {
    if (_firestore == null) {
      _localResumes.removeWhere((r) => r.id == resumeId);
      return;
    }

    try {
      await _firestore.collection('resumes').doc(resumeId).delete();
      AppLogger.info('Resume deleted from Firestore: $resumeId',
          tag: 'ResumeService');
    } catch (e) {
      AppLogger.error('Failed to delete resume: $e', tag: 'ResumeService');
      throw FileException(message: 'Failed to delete resume: $e');
    }
  }
}
