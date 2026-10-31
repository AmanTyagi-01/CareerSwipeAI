import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/constants.dart';
import '../../../data/models/user_model.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  int _themeSelection = 0; // 0: Dark, 1: Light, 2: System Default
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _jobAlerts = true;
  bool _marketingEmails = false;
  bool _biometricAuth = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E17),
        elevation: 0,
        foregroundColor: const Color(0xFFF1F5F9),
        title: const Text('Settings & Security', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Theme & Appearance'),
              _buildThemeSelector(),
              const SizedBox(height: 24),
              _buildSectionTitle('Notification Preferences'),
              _buildNotificationSettings(),
              const SizedBox(height: 24),
              _buildSectionTitle('Privacy & Security'),
              _buildSecuritySettings(),
              const SizedBox(height: 24),
              _buildSectionTitle('Account & Workspace'),
              _buildAccountSettings(),
              const SizedBox(height: 24),
              _buildSectionTitle('About CareerSwipe AI'),
              _buildAboutSettings(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF232A3B)),
      ),
      child: Column(
        children: [
          _buildThemeTile(0, 'Dark Theme', 'Cinematic obsidian dark (Recommended)', Icons.dark_mode_rounded),
          const Divider(color: Color(0xFF232A3B), height: 16),
          _buildThemeTile(1, 'Light Theme', 'Clean bright theme for daylight use', Icons.light_mode_rounded),
          const Divider(color: Color(0xFF232A3B), height: 16),
          _buildThemeTile(2, 'System Default', 'Match operating system appearance', Icons.settings_brightness_rounded),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildThemeTile(int index, String title, String subtitle, IconData icon) {
    final isSelected = _themeSelection == index;
    return InkWell(
      onTap: () => setState(() => _themeSelection = index),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF8B5CF6).withValues(alpha: 0.2)
                    : const Color(0xFF1E2638),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF94A3B8),
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFFF1F5F9) : const Color(0xFFCBD5E1),
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF475569),
                  width: 2,
                ),
                color: isSelected ? const Color(0xFF8B5CF6) : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF232A3B)),
      ),
      child: Column(
        children: [
          _buildSwitchRow(
            icon: Icons.notifications_active_outlined,
            title: 'Push Notifications',
            subtitle: 'Immediate alerts for interviews and offers',
            value: _pushNotifications,
            onChanged: (val) => setState(() => _pushNotifications = val),
            color: const Color(0xFF38BDF8),
          ),
          const Divider(color: Color(0xFF232A3B), height: 1),
          _buildSwitchRow(
            icon: Icons.mark_email_unread_outlined,
            title: 'Email Notifications',
            subtitle: 'Weekly summary and job digest',
            value: _emailNotifications,
            onChanged: (val) => setState(() => _emailNotifications = val),
            color: const Color(0xFF8B5CF6),
          ),
          const Divider(color: Color(0xFF232A3B), height: 1),
          _buildSwitchRow(
            icon: Icons.auto_awesome_outlined,
            title: 'AI Job Match Alerts',
            subtitle: 'Notify when high-fit (85%+) jobs open',
            value: _jobAlerts,
            onChanged: (val) => setState(() => _jobAlerts = val),
            color: const Color(0xFF10B981),
          ),
          const Divider(color: Color(0xFF232A3B), height: 1),
          _buildSwitchRow(
            icon: Icons.campaign_outlined,
            title: 'Product & Career News',
            subtitle: 'Skill insights, salary guides and updates',
            value: _marketingEmails,
            onChanged: (val) => setState(() => _marketingEmails = val),
            color: const Color(0xFFF59E0B),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildSecuritySettings() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF232A3B)),
      ),
      child: Column(
        children: [
          _buildSwitchRow(
            icon: Icons.fingerprint_rounded,
            title: 'Biometric Authentication',
            subtitle: 'Unlock with Face ID or fingerprint',
            value: _biometricAuth,
            onChanged: (val) => setState(() => _biometricAuth = val),
            color: const Color(0xFF38BDF8),
          ),
          const Divider(color: Color(0xFF232A3B), height: 1),
          _buildNavRow(
            icon: Icons.lock_outline_rounded,
            title: 'Change Password',
            subtitle: 'Last updated 3 months ago',
            color: const Color(0xFF8B5CF6),
            onTap: () {},
          ),
          const Divider(color: Color(0xFF232A3B), height: 1),
          _buildNavRow(
            icon: Icons.delete_forever_outlined,
            title: 'Delete Account',
            subtitle: 'Permanently remove your account and data',
            color: const Color(0xFFEF4444),
            onTap: () => _showDeleteAccountDialog(context),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildAccountSettings() {
    final user = ref.watch(currentUserProvider).value;
    final isRecruiter = user?.userType == UserType.recruiter;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF232A3B)),
      ),
      child: Column(
        children: [
          _buildNavRow(
            icon: Icons.switch_account_rounded,
            title: 'Switch Workspace Role',
            subtitle: isRecruiter ? 'Currently: Recruiter Mode' : 'Currently: Candidate Mode',
            color: const Color(0xFF8B5CF6),
            onTap: () {
              final newRole = isRecruiter ? UserType.talent : UserType.recruiter;
              ref.read(authNotifierProvider.notifier).updateRole(newRole);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Switched to ${newRole == UserType.recruiter ? "Recruiter" : "Candidate"} Mode'),
                  backgroundColor: const Color(0xFF8B5CF6),
                ),
              );
            },
          ),
          const Divider(color: Color(0xFF232A3B), height: 1),
          _buildNavRow(
            icon: Icons.file_download_outlined,
            title: 'Export My Data',
            subtitle: 'Download complete profile, ATS history, and applications',
            color: const Color(0xFF38BDF8),
            onTap: () {},
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildAboutSettings() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF232A3B)),
      ),
      child: Column(
        children: [
          _buildNavRow(
            icon: Icons.info_outline_rounded,
            title: 'App Version',
            subtitle: '${AppConstants.appVersion} (Production Build)',
            color: const Color(0xFF8B5CF6),
            onTap: null,
          ),
          const Divider(color: Color(0xFF232A3B), height: 1),
          _buildNavRow(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy & Terms',
            subtitle: 'User privacy, ATS explainability and ethics',
            color: const Color(0xFF10B981),
            onTap: () {},
          ),
          const Divider(color: Color(0xFF232A3B), height: 1),
          _buildNavRow(
            icon: Icons.help_outline_rounded,
            title: 'Help Center & AI Support',
            subtitle: 'FAQs, contact team, and issue reports',
            color: const Color(0xFFF59E0B),
            onTap: () {},
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Color(0xFFF1F5F9), fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF8B5CF6).withValues(alpha: 0.5),
            activeThumbColor: const Color(0xFF8B5CF6),
            inactiveTrackColor: const Color(0xFF1E2638),
            inactiveThumbColor: const Color(0xFF64748B),
          ),
        ],
      ),
    );
  }

  Widget _buildNavRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Color(0xFFF1F5F9), fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF64748B), size: 20),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF121622),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF232A3B)),
        ),
        title: const Text('Delete Account', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
        content: const Text(
          'Are you sure you want to delete your account? All your resumes, ATS analyses, and applications will be permanently erased.',
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete Forever'),
          ),
        ],
      ),
    );
  }
}
