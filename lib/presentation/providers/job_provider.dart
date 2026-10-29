import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/job_model.dart';
import '../../services/job_service.dart';

final jobServiceProvider = Provider<JobService>((ref) => JobService());

final jobsProvider = FutureProvider.family<List<JobModel>, Map<String, dynamic>?>((ref, filters) async {
  final service = ref.watch(jobServiceProvider);
  return await service.getJobs(
    industry: filters?['industry'],
    experienceLevel: filters?['experienceLevel'],
    jobType: filters?['jobType'],
    location: filters?['location'],
    isRemote: filters?['isRemote'],
    searchQuery: filters?['searchQuery'],
  );
});

final jobDetailsProvider = FutureProvider.family<JobModel?, String>((ref, jobId) async {
  final service = ref.watch(jobServiceProvider);
  return await service.getJobById(jobId);
});

final savedJobsProvider = FutureProvider.family<List<JobModel>, String>((ref, userId) async {
  final service = ref.watch(jobServiceProvider);
  return await service.getSavedJobs(userId);
});

final appliedJobsProvider = FutureProvider.family<List<JobApplicationModel>, String>((ref, userId) async {
  final service = ref.watch(jobServiceProvider);
  return await service.getAppliedJobs(userId);
});

final recommendedJobsProvider = FutureProvider.family<List<JobModel>, String>((ref, userId) async {
  final service = ref.watch(jobServiceProvider);
  return await service.getRecommendedJobs(userId);
});

final recruiterJobsProvider = FutureProvider.family<List<JobModel>, String>((ref, recruiterId) async {
  final service = ref.watch(jobServiceProvider);
  return await service.getRecruiterJobs(recruiterId);
});

final jobApplicantsProvider = FutureProvider.family<List<JobApplicationModel>, String>((ref, jobId) async {
  final service = ref.watch(jobServiceProvider);
  return await service.getJobApplicants(jobId);
});

class JobNotifier extends StateNotifier<AsyncValue<void>> {
  final JobService _jobService;

  JobNotifier(this._jobService) : super(const AsyncValue.data(null));

  Future<void> recordSwipe(String userId, String jobId, String action, {double? matchScore}) async {
    try {
      await _jobService.recordSwipe(userId, jobId, action, matchScore: matchScore);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> applyForJob(String userId, String jobId, {String? coverLetter, String? resumeUrl}) async {
    state = const AsyncValue.loading();
    try {
      await _jobService.applyForJob(userId, jobId, coverLetter: coverLetter, resumeUrl: resumeUrl);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> saveJob(String userId, String jobId) async {
    try {
      await _jobService.saveJob(userId, jobId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unsaveJob(String userId, String jobId) async {
    try {
      await _jobService.unsaveJob(userId, jobId);
    } catch (e) {
      rethrow;
    }
  }

  Future<JobModel> createJob(JobModel job) async {
    state = const AsyncValue.loading();
    try {
      final created = await _jobService.createJob(job);
      state = const AsyncValue.data(null);
      return created;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateJobStatus(String jobId, bool isActive) async {
    try {
      await _jobService.updateJobStatus(jobId, isActive);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateApplicationStatus(String applicationId, String newStatus) async {
    try {
      await _jobService.updateApplicationStatus(applicationId, newStatus);
    } catch (e) {
      rethrow;
    }
  }
}

final jobNotifierProvider = StateNotifierProvider<JobNotifier, AsyncValue<void>>((ref) {
  return JobNotifier(ref.watch(jobServiceProvider));
});
