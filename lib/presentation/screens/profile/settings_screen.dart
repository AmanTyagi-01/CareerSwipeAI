import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../presentation/widgets/common/animated_background.dart';
import '../../../presentation/widgets/common/glass_card.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isDarkMode = true;
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _jobAlerts = true;
  bool _marketingEmails = false;
  bool _biometricAuth = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: AnimatedBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(context, 'Appearance', isDark),
                _buildAppearanceSettings(context, isDark),
                const SizedBox(height: 24),
                _buildSection(context, 'Notifications', isDark),
                _buildNotificationSettings(context, isDark),
                const SizedBox(height: 24),
                _buildSection(context, 'Privacy & Security', isDark),
                _buildPrivacySettings(context, isDark),
                const SizedBox(height: 24),
                _buildSection(context, 'Account', isDark),
                _buildAccountSettings(context, isDark),
                const SizedBox(height: 24),
                _buildSection(context, 'About', isDark),
                _buildAboutSettings(context, isDark),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
        ),
      ),
    );
  }

  Widget _buildAppearanceSettings(BuildContext context, bool isDark) {
    return GlassCard(
      child: Column(
        children: [
          _buildSwitchTile(
            context,
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Use dark theme throughout the app',
            value: _isDarkMode,
            onChanged: (value) => setState(() => _isDarkMode = value),
            color: AppTheme.primaryColor,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn()
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildNotificationSettings(BuildContext context, bool isDark) {
    return GlassCard(
      child: Column(
        children: [
          _buildSwitchTile(
            context,
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Receive push notifications',
            value: _pushNotifications,
            onChanged: (value) => setState(() => _pushNotifications = value),
            color: AppTheme.accentColor,
          ),
          Divider(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          _buildSwitchTile(
            context,
            icon: Icons.email_outlined,
            title: 'Email Notifications',
            subtitle: 'Receive email updates',
            value: _emailNotifications,
            onChanged: (value) => setState(() => _emailNotifications = value),
            color: AppTheme.infoColor,
          ),
          Divider(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          _buildSwitchTile(
            context,
            icon: Icons.work_outline,
            title: 'Job Alerts',
            subtitle: 'Get notified about matching jobs',
            value: _jobAlerts,
            onChanged: (value) => setState(() => _jobAlerts = value),
            color: AppTheme.successColor,
          ),
          Divider(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          _buildSwitchTile(
            context,
            icon: Icons.campaign_outlined,
            title: 'Marketing Emails',
            subtitle: 'Receive promotional content',
            value: _marketingEmails,
            onChanged: (value) => setState(() => _marketingEmails = value),
            color: AppTheme.warningColor,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 100))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildPrivacySettings(BuildContext context, bool isDark) {
    return GlassCard(
      child: Column(
        children: [
          _buildSwitchTile(
            context,
            icon: Icons.fingerprint,
            title: 'Biometric Authentication',
            subtitle: 'Use fingerprint or face ID',
            value: _biometricAuth,
            onChanged: (value) => setState(() => _biometricAuth = value),
            color: AppTheme.primaryColor,
          ),
          Divider(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          _buildNavigationTile(
            context,
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your account password',
            color: AppTheme.warningColor,
            onTap: () {},
          ),
          Divider(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          _buildNavigationTile(
            context,
            icon: Icons.delete_outline,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            color: AppTheme.errorColor,
            onTap: () => _showDeleteAccountDialog(context),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 200))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildAccountSettings(BuildContext context, bool isDark) {
    return GlassCard(
      child: Column(
        children: [
          _buildNavigationTile(
            context,
            icon: Icons.download_outlined,
            title: 'Export Data',
            subtitle: 'Download your data as JSON',
            color: AppTheme.infoColor,
            onTap: () {},
          ),
          Divider(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          _buildNavigationTile(
            context,
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: 'English (US)',
            color: AppTheme.accentColor,
            onTap: () {},
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 300))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildAboutSettings(BuildContext context, bool isDark) {
    return GlassCard(
      child: Column(
        children: [
          _buildNavigationTile(
            context,
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: AppConstants.appVersion,
            color: AppTheme.primaryColor,
            onTap: null,
          ),
          Divider(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          _buildNavigationTile(
            context,
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            subtitle: 'Read our terms and conditions',
            color: AppTheme.accentColor,
            onTap: () {},
          ),
          Divider(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          _buildNavigationTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'How we handle your data',
            color: AppTheme.successColor,
            onTap: () {},
          ),
          Divider(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          _buildNavigationTile(
            context,
            icon: Icons.help_outline,
            title: 'Help Center',
            subtitle: 'Get support and FAQs',
            color: AppTheme.warningColor,
            onTap: () {},
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 400))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildNavigationTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
        ),
      ),
      trailing: onTap != null
          ? Icon(
              Icons.chevron_right,
              color: isDark ? AppTheme.darkTextTertiary : AppTheme.lightTextTertiary,
            )
          : null,
      onTap: onTap,
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle account deletion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
