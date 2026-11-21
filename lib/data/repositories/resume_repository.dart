import 'package:file_picker/file_picker.dart';
import '../models/resume_model.dart';
import '../../services/resume_service.dart';

abstract class ResumeRepository {
  Future<ResumeModel> uploadResume(String userId, PlatformFile file);
  Future<String?> extractTextFromResume(String fileUrl);
  Future<List<ResumeModel>> getUserResumes(String userId);
  Future<ResumeModel?> getResumeById(String resumeId);
  Future<void> deleteResume(String resumeId, String userId);
  Future<void> renameResume(String resumeId, String userId, String newName);
  Future<Map<String, dynamic>> compareResumes(
      String resumeId1, String resumeId2);
  Future<String> downloadResume(String fileUrl);
}

class ResumeRepositoryImpl implements ResumeRepository {
  final ResumeService _resumeService;

  ResumeRepositoryImpl(this._resumeService);

  @override
  Future<ResumeModel> uploadResume(String userId, PlatformFile file) =>
      _resumeService.uploadResume(userId, file);

  @override
  Future<String?> extractTextFromResume(String fileUrl) =>
      _resumeService.extractTextFromResume(fileUrl);

  @override
  Future<List<ResumeModel>> getUserResumes(String userId) =>
      _resumeService.getUserResumes(userId);

  @override
  Future<ResumeModel?> getResumeById(String resumeId) =>
      _resumeService.getResumeById(resumeId);

  @override
  Future<void> deleteResume(String resumeId, String userId) =>
      _resumeService.deleteResume(resumeId, userId);

  @override
  Future<void> renameResume(String resumeId, String userId, String newName) =>
      _resumeService.renameResume(resumeId, userId, newName);

  @override
  Future<Map<String, dynamic>> compareResumes(
          String resumeId1, String resumeId2) =>
      _resumeService.compareResumes(resumeId1, resumeId2);

  @override
  Future<String> downloadResume(String fileUrl) =>
      _resumeService.downloadResume(fileUrl);
}
