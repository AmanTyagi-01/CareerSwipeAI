import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';
import '../../../data/models/job_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';
import '../../widgets/common/animated_background.dart';
import '../../widgets/common/glass_card.dart';

class CreateJobScreen extends ConsumerStatefulWidget {
  const CreateJobScreen({super.key});

  @override
  ConsumerState<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends ConsumerState<CreateJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _minSalaryController = TextEditingController();
  final _maxSalaryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _skillInputController = TextEditingController();

  String _selectedJobType = 'Full-time';
  bool _isRemote = true;
  final List<String> _skills = ['Flutter', 'Dart'];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider).value;
    _companyController.text = user?.industry?.isNotEmpty == true ? user!.industry! : 'Aman Traders Tech';
    _locationController.text = 'Bengaluru, India';
    _minSalaryController.text = '12';
    _maxSalaryController.text = '25';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _minSalaryController.dispose();
    _maxSalaryController.dispose();
    _descriptionController.dispose();
    _skillInputController.dispose();
    super.dispose();
  }

  void _addSkill() {
    final skill = _skillInputController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillInputController.clear();
      });
    }
  }

  Future<void> _submitJob() async {
    if (!_formKey.currentState!.validate()) return;
    if (_skills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one required skill')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final user = ref.read(currentUserProvider).value;

    final newJob = JobModel(
      id: 'job-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      company: _companyController.text.trim(),
      location: _locationController.text.trim(),
      isRemote: _isRemote,
      jobType: _selectedJobType,
      minSalary: double.tryParse(_minSalaryController.text) ?? 100000,
      maxSalary: double.tryParse(_maxSalaryController.text) ?? 200000,
      description: _descriptionController.text.trim(),
      skills: _skills,
      recruiterId: user?.id,
      postedAt: DateTime.now(),
      isActive: true,
      tags: [_selectedJobType, if (_isRemote) 'Remote', ..._skills],
    );

    try {
      await ref.read(jobNotifierProvider.notifier).createJob(newJob);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Job listing published successfully!'),
          backgroundColor: AppColors.darkSuccess,
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to publish job: $e'), backgroundColor: AppColors.darkError),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a New Job', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AnimatedBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Job Title *',
                          hintText: 'e.g. Senior Flutter Developer',
                          prefixIcon: Icon(Icons.title_rounded),
                        ),
                        validator: (v) => v?.trim().isEmpty == true ? 'Please enter job title' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _companyController,
                        decoration: const InputDecoration(
                          labelText: 'Company Name *',
                          prefixIcon: Icon(Icons.business_rounded),
                        ),
                        validator: (v) => v?.trim().isEmpty == true ? 'Please enter company name' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedJobType,
                        decoration: const InputDecoration(
                          labelText: 'Job Type',
                          prefixIcon: Icon(Icons.work_outline_rounded),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Full-time', child: Text('Full-time')),
                          DropdownMenuItem(value: 'Part-time', child: Text('Part-time')),
                          DropdownMenuItem(value: 'Internship', child: Text('Internship')),
                          DropdownMenuItem(value: 'Contract', child: Text('Contract')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedJobType = val);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _locationController,
                              decoration: const InputDecoration(
                                labelText: 'Location',
                                prefixIcon: Icon(Icons.location_on_outlined),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Row(
                            children: [
                              const Text('Remote'),
                              Switch(
                                value: _isRemote,
                                activeThumbColor: AppColors.darkPrimary,
                                onChanged: (v) => setState(() => _isRemote = v),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _minSalaryController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Min Salary (LPA / k)',
                                prefixText: '₹ ',
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: TextFormField(
                              controller: _maxSalaryController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Max Salary (LPA / k)',
                                prefixText: '₹ ',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Required Skills *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _skills.map((skill) {
                          return Chip(
                            label: Text(skill),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              setState(() => _skills.remove(skill));
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _skillInputController,
                              decoration: const InputDecoration(
                                hintText: 'Add skill (e.g. Firebase, Riverpod)',
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              onSubmitted: (_) => _addSkill(),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          IconButton.filled(
                            onPressed: _addSkill,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Job Description *',
                          hintText: 'Describe responsibilities, required qualifications, and perks...',
                        ),
                        validator: (v) => v?.trim().isEmpty == true ? 'Please enter a description' : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitJob,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Post Job', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

