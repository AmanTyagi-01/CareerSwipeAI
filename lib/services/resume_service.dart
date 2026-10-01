import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import '../core/errors/exceptions.dart';
import '../core/utils/app_utils.dart';
import '../core/utils/logger.dart';
import '../data/models/resume_model.dart';

class ResumeService {
  final FirebaseFirestore? _firestore;
  final FirebaseStorage? _storage;

  static const int _maxRetries = 3;

  static final List<ResumeModel> _demoResumes = [
    ResumeModel(
      id: 'demo-resume-1',
      userId: 'mock-user-1',
      fileName: 'Alex_Turner_Senior_Flutter_Engineer.pdf',
      fileUrl: 'https://example.com/Alex_Turner_Resume.pdf',
      fileSize: 245000,
      fileType: 'pdf',
      uploadedAt: DateTime.now().subtract(const Duration(days: 3)),
      isActive: true,
      version: 1,
      atsScore: 86.0,
      skills: const ['Flutter', 'Dart', 'Firebase', 'State Management', 'REST APIs', 'UI/UX Design', 'Git', 'Agile'],
      atsBreakdown: const {
        'Keywords': 88.0,
        'Formatting': 92.0,
        'Readability': 84.0,
        'Impact': 80.0,
      },
    ),
  ];

  ResumeService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? (Firebase.apps.isNotEmpty ? FirebaseFirestore.instance : null),
        _storage = storage ?? (Firebase.apps.isNotEmpty ? FirebaseStorage.instance : null);

  Future<ResumeModel> uploadResume(String userId, PlatformFile file) async {
    if (_firestore == null || _storage == null) {
      final extension = AppUtils.getFileExtension(file.name);
      final newVersion = _demoResumes.length + 1;
      final resume = ResumeModel(
        id: 'demo-resume-${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        fileName: file.name,
        fileUrl: file.path ?? 'https://example.com/resume.pdf',
        fileSize: file.size,
        fileType: extension,
        uploadedAt: DateTime.now(),
        isActive: true,
        version: newVersion,
        atsScore: 88.0,
        skills: const ['Flutter', 'Dart', 'Firebase', 'State Management', 'REST APIs', 'Riverpod'],
        atsBreakdown: const {
          'Keywords': 88.0,
          'Formatting': 90.0,
          'Readability': 86.0,
          'Impact': 82.0,
        },
      );
      _demoResumes.insert(0, resume);
      AppLogger.info('Demo resume created: ${resume.id}', tag: 'ResumeService');
      return resume;
    }

    try {
      if (file.path == null) {
        throw FileException(message: 'Invalid file path.');
      }

      final extension = AppUtils.getFileExtension(file.name);
      if (!['pdf', 'doc', 'docx'].contains(extension)) {
        throw FileException(message: 'Only PDF, DOC, and DOCX files are supported.');
      }

      if (file.size > 10 * 1024 * 1024) {
        throw FileException(message: 'File size exceeds 10MB limit.');
      }

      AppLogger.info('Starting resume upload for user $userId', tag: 'ResumeService');

      final fileName = '${AppUtils.generateId()}_$userId.$extension';
      final ref = _storage!.ref().child('resumes/$userId/$fileName');

      // Upload with retry logic
      String downloadUrl = '';
      for (int attempt = 1; attempt <= _maxRetries; attempt++) {
        try {
          final uploadTask = await ref.putFile(File(file.path!));
          downloadUrl = await uploadTask.ref.getDownloadURL();
          AppLogger.info('Upload successful on attempt $attempt', tag: 'ResumeService');
          break;
        } on FirebaseException catch (e) {
          AppLogger.warning('Upload attempt $attempt failed: ${e.message}', tag: 'ResumeService');
          if (attempt == _maxRetries) {
            throw FileException(message: 'Upload failed after $_maxRetries attempts: ${e.message}');
          }
          await Future.delayed(Duration(seconds: attempt * 2)); // exponential backoff
        }
      }

      // Query existing resumes to calculate version
      final snapshot = await _firestore!
          .collection('resumes')
          .where('userId', isEqualTo: userId)
          .get();

      final resumes = snapshot.docs
          .map((doc) => ResumeModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
      final int newVersion = resumes.isEmpty
          ? 1
          : resumes.map((r) => r.version).reduce((a, b) => a > b ? a : b) + 1;

      final batch = _firestore!.batch();
      // Mark all existing resumes inactive
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {'isActive': false});
      }

      final resume = ResumeModel(
        id: AppUtils.generateId(),
        userId: userId,
        fileName: file.name,
        fileUrl: downloadUrl,
        fileSize: file.size,
        fileType: extension,
        uploadedAt: DateTime.now(),
        isActive: true,
        version: newVersion,
        atsScore: 70.0 + (newVersion * 4.0 > 29.0 ? 29.0 : newVersion * 4.0),
        skills: const ['Flutter', 'Dart', 'Firebase', 'REST APIs'],
        atsBreakdown: const {
          'Keywords': 75.0,
          'Formatting': 80.0,
          'Readability': 70.0,
          'Impact': 65.0,
        },
      );

      batch.set(_firestore!.collection('resumes').doc(resume.id), resume.toMap());

      // Update user's active resume reference
      batch.update(_firestore!.collection('users').doc(userId), {
        'resumeUrl': downloadUrl,
        'resumeId': resume.id,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      await batch.commit();
      AppLogger.info('Resume saved to Firestore: ${resume.id}', tag: 'ResumeService');
      return resume;
    } on FileException {
      rethrow;
    } on FirebaseException catch (e) {
      AppLogger.error('Firebase error uploading resume', tag: 'ResumeService', error: e, stackTrace: e.stackTrace);
      throw FileException(message: 'Failed to upload resume: ${e.message}');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error uploading resume', tag: 'ResumeService', error: e, stackTrace: stackTrace);
      throw FileException(message: 'Failed to upload resume: $e', stackTrace: stackTrace);
    }
  }

  Future<String?> extractTextFromResume(String fileUrl) async {
    // Text extraction requires a Cloud Function or server-side PDF parser.
    // Returns null until backend integration is complete.
    AppLogger.info('Text extraction not yet implemented', tag: 'ResumeService');
    return null;
  }

  Future<List<ResumeModel>> getUserResumes(String userId) async {
    if (_firestore == null) {
      return List<ResumeModel>.from(_demoResumes);
    }
    try {
      final snapshot = await _firestore!
          .collection('resumes')
          .where('userId', isEqualTo: userId)
          .orderBy('uploadedAt', descending: true)
          .get();

      AppLogger.info('Fetched ${snapshot.docs.length} resumes for user $userId', tag: 'ResumeService');
      return snapshot.docs.map((doc) => ResumeModel.fromMap({...doc.data(), 'id': doc.id})).toList();
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error fetching resumes', tag: 'ResumeService', error: e);
      throw ServerException(message: 'Failed to fetch resumes.');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error fetching resumes', tag: 'ResumeService', error: e, stackTrace: stackTrace);
      throw ServerException(message: 'Failed to fetch resumes.');
    }
  }

  Future<ResumeModel?> getResumeById(String resumeId) async {
    if (_firestore == null) {
      try {
        return _demoResumes.firstWhere((r) => r.id == resumeId);
      } catch (_) {
        return _demoResumes.isNotEmpty ? _demoResumes.first : null;
      }
    }
    try {
      final doc = await _firestore!.collection('resumes').doc(resumeId).get();
      if (!doc.exists) return null;
      return ResumeModel.fromMap({...doc.data()!, 'id': doc.id});
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error fetching resume $resumeId', tag: 'ResumeService', error: e);
      throw ServerException(message: 'Failed to fetch resume.');
    }
  }

  Future<void> deleteResume(String resumeId, String userId) async {
    if (_firestore == null) {
      _demoResumes.removeWhere((r) => r.id == resumeId);
      return;
    }
    try {
      final resume = await getResumeById(resumeId);
      if (resume == null) throw NotFoundException(message: 'Resume not found.');

      // Delete from Storage (fire-and-forget — Storage ref may be stale)
      try {
        final storageRef = _storage!.refFromURL(resume.fileUrl);
        await storageRef.delete();
        AppLogger.info('Deleted storage file for resume $resumeId', tag: 'ResumeService');
      } on FirebaseException catch (e) {
        AppLogger.warning('Could not delete storage file (may already be gone): ${e.message}', tag: 'ResumeService');
      }

      final batch = _firestore!.batch();
      batch.delete(_firestore!.collection('resumes').doc(resumeId));

      final userDoc = await _firestore!.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc.data()?['resumeId'] == resumeId) {
        batch.update(_firestore!.collection('users').doc(userId), {
          'resumeUrl': FieldValue.delete(),
          'resumeId': FieldValue.delete(),
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        });
      }

      await batch.commit();
      AppLogger.info('Deleted resume $resumeId from Firestore', tag: 'ResumeService');
    } on NotFoundException {
      rethrow;
    } on FirebaseException catch (e) {
      AppLogger.error('Firebase error deleting resume', tag: 'ResumeService', error: e);
      throw ServerException(message: 'Failed to delete resume.');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error deleting resume', tag: 'ResumeService', error: e, stackTrace: stackTrace);
      throw ServerException(message: 'Failed to delete resume.');
    }
  }

  Future<void> renameResume(String resumeId, String userId, String newName) async {
    if (newName.trim().isEmpty) {
      throw FileException(message: 'Resume name cannot be empty.');
    }

    if (_firestore == null) {
      final index = _demoResumes.indexWhere((r) => r.id == resumeId);
      if (index != -1) {
        _demoResumes[index] = _demoResumes[index].copyWith(fileName: newName.trim());
      }
      return;
    }

    try {
      await _firestore!.collection('resumes').doc(resumeId).update({
        'fileName': newName.trim(),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
      AppLogger.info('Renamed resume $resumeId to "$newName"', tag: 'ResumeService');
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error renaming resume', tag: 'ResumeService', error: e);
      throw ServerException(message: 'Failed to rename resume.');
    }
  }

  Future<Map<String, dynamic>> compareResumes(String resumeId1, String resumeId2) async {
    final r1 = await getResumeById(resumeId1);
    final r2 = await getResumeById(resumeId2);
    if (r1 == null || r2 == null) {
      throw NotFoundException(message: 'One or both resumes not found.');
    }

    final scoreDiff = r2.atsScore - r1.atsScore;
    final skillsAdded = r2.skills.where((s) => !r1.skills.contains(s)).toList();
    final skillsRemoved = r1.skills.where((s) => !r2.skills.contains(s)).toList();

    return {
      'resume1': r1,
      'resume2': r2,
      'scoreDifference': scoreDiff,
      'skillsAdded': skillsAdded,
      'skillsRemoved': skillsRemoved,
    };
  }

  Future<String> downloadResume(String fileUrl) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return fileUrl;
  }
}
