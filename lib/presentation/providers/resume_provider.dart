import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/models/resume_model.dart';
import '../../data/repositories/resume_repository.dart';
import '../../services/resume_service.dart';
import '../../services/ai_service.dart';
import '../../core/utils/logger.dart';

final resumeServiceProvider = Provider<ResumeService>((ref) => ResumeService());
final aiServiceProvider = Provider<AIService>((ref) => AIService());

final resumeRepositoryProvider = Provider<ResumeRepository>((ref) {
  return ResumeRepositoryImpl(ref.watch(resumeServiceProvider));
});

/// FutureProvider — fetches resumes once and caches until invalidated.
/// Use ref.invalidate(userResumesProvider(userId)) to force refresh.
final userResumesProvider =
    FutureProvider.family<List<ResumeModel>, String>((ref, userId) async {
  final repo = ref.watch(resumeRepositoryProvider);
  return repo.getUserResumes(userId);
});

final activeAnalysisStateProvider =
    StateProvider<ResumeAnalysisModel?>((ref) => null);

final resumeAnalysisProvider =
    FutureProvider.family<ResumeAnalysisModel?, String>((ref, resumeId) async {
  AppLogger.info('Loading analysis for resume $resumeId',
      tag: 'ResumeProvider');
  final repo = ref.watch(resumeRepositoryProvider);
  final aiService = ref.watch(aiServiceProvider);
  final resume = await repo.getResumeById(resumeId);
  if (resume == null) return null;

  final analysis = await aiService.analyzeResume(resume,
      extractedText: resume.extractedText);
  return analysis;
});

class ResumeNotifier extends StateNotifier<AsyncValue<ResumeModel?>> {
  final ResumeRepository _resumeRepository;
  final AIService _aiService;

  ResumeNotifier(this._resumeRepository, this._aiService)
      : super(const AsyncValue.data(null));

  Future<ResumeModel> uploadResume(String userId, PlatformFile file) async {
    state = const AsyncValue.loading();
    try {
      final resume = await _resumeRepository.uploadResume(userId, file);
      state = AsyncValue.data(resume);
      AppLogger.info('Resume uploaded: ${resume.id}', tag: 'ResumeNotifier');
      return resume;
    } catch (e, stackTrace) {
      AppLogger.error('Resume upload failed',
          tag: 'ResumeNotifier', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  Future<ResumeAnalysisModel> analyzeResume(ResumeModel resume) async {
    try {
      final analysis = await _aiService.analyzeResume(resume);
      AppLogger.info('Analysis complete for resume ${resume.id}',
          tag: 'ResumeNotifier');
      return analysis;
    } catch (e, stackTrace) {
      AppLogger.error('Resume analysis failed',
          tag: 'ResumeNotifier', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> deleteResume(String resumeId, String userId) async {
    try {
      await _resumeRepository.deleteResume(resumeId, userId);
      state = const AsyncValue.data(null);
      AppLogger.info('Deleted resume $resumeId', tag: 'ResumeNotifier');
    } catch (e, stackTrace) {
      AppLogger.error('Delete resume failed',
          tag: 'ResumeNotifier', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> renameResume(
      String resumeId, String userId, String newName) async {
    try {
      await _resumeRepository.renameResume(resumeId, userId, newName);
      final current = state.value;
      if (current != null && current.id == resumeId) {
        state = AsyncValue.data(current.copyWith(fileName: newName));
      }
    } catch (e, stackTrace) {
      AppLogger.error('Rename resume failed',
          tag: 'ResumeNotifier', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> compareResumes(
      String resumeId1, String resumeId2) async {
    try {
      return await _resumeRepository.compareResumes(resumeId1, resumeId2);
    } catch (e, stackTrace) {
      AppLogger.error('Compare resumes failed',
          tag: 'ResumeNotifier', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<String> downloadResume(String fileUrl) async {
    try {
      return await _resumeRepository.downloadResume(fileUrl);
    } catch (e, stackTrace) {
      AppLogger.error('Download resume failed',
          tag: 'ResumeNotifier', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

final resumeNotifierProvider =
    StateNotifierProvider<ResumeNotifier, AsyncValue<ResumeModel?>>((ref) {
  return ResumeNotifier(
    ref.watch(resumeRepositoryProvider),
    ref.watch(aiServiceProvider),
  );
});
