import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/models/user_model.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../widgets/common/app_brand_logo.dart';

/// Login & Authentication screen matching Poster 1 Screen 3 & Poster 2 Screen 1:
/// - Candidate vs Recruiter segmented toggle on top of the card
/// - Email / Company Email field & password with visibility toggle
/// - "Forgot Password?"
/// - "Sign In" gradient button
/// - "Or continue with" divider
/// - Google, Apple, and LinkedIn social buttons
/// - "Create an account" / "Create a recruiter account" link
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final authNotifier = ref.read(authNotifierProvider.notifier);
    await authNotifier.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  Future<void> _loginWithGoogle() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    await authNotifier.signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final selectedRole = ref.watch(selectedUserTypeProvider);

    ref.listen(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            context.go('/home');
          }
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: AppTheme.errorColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      body: Stack(
        children: [
          // Ambient lighting
          Positioned(
            top: -120,
            left: 40,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7C3AED).withValues(alpha: 0.18),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    children: [
                      // Glowing Brand Emblem
                      const AppBrandLogo(size: 64, showGlow: true)
                          .animate()
                          .scale(duration: 500.ms, curve: Curves.easeOutBack),

                      const SizedBox(height: 20),

                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      )
                          .animate()
                          .fadeIn()
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 6),

                      const Text(
                        'Sign in to continue your journey',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF94A3B8),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 150.ms),

                      const SizedBox(height: 28),

                      // Card with Role Toggle and Input Fields
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF121622),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFF232A3B),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 28,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Segmented Role Switch
                              Container(
                                width: double.infinity,
                                height: 46,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A0E17),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFF1E2436)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _buildRoleTab(
                                        title: 'Candidate',
                                        isSelected: selectedRole == UserType.talent,
                                        onTap: () {
                                          ref.read(selectedUserTypeProvider.notifier).state =
                                              UserType.talent;
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildRoleTab(
                                        title: 'Recruiter',
                                        isSelected: selectedRole == UserType.recruiter,
                                        onTap: () {
                                          ref.read(selectedUserTypeProvider.notifier).state =
                                              UserType.recruiter;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Email Label
                              Text(
                                selectedRole == UserType.recruiter ? 'Company Email' : 'Email',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFCBD5E1),
                                ),
                              ),
                              const SizedBox(height: 8),

                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: selectedRole == UserType.recruiter
                                      ? 'recruiter@company.com'
                                      : 'Enter your email',
                                  hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                                  filled: true,
                                  fillColor: const Color(0xFF0A0E17),
                                  prefixIcon: const Icon(Icons.mail_outline_rounded,
                                      color: Color(0xFF8B5CF6), size: 20),
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: Color(0xFF1E2436)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: Color(0xFF1E2436)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5),
                                  ),
                                ),
                                validator: AppUtils.validateEmail,
                              ),

                              const SizedBox(height: 18),

                              // Password Label
                              const Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFCBD5E1),
                                ),
                              ),
                              const SizedBox(height: 8),

                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _login(),
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: 'Enter password',
                                  hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                                  filled: true,
                                  fillColor: const Color(0xFF0A0E17),
                                  prefixIcon: const Icon(Icons.lock_outline_rounded,
                                      color: Color(0xFF8B5CF6), size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: const Color(0xFF64748B),
                                      size: 20,
                                    ),
                                    onPressed: () =>
                                        setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: Color(0xFF1E2436)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: Color(0xFF1E2436)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Password is required';
                                  if (value.length < 6) return 'Password must be at least 6 characters';
                                  return null;
                                },
                              ),

                              const SizedBox(height: 8),

                              // Forgot password link
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => context.push('/auth/forgot-password'),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 32),
                                  ),
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF8B5CF6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              // "Sign In" gradient button
                              Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                                      blurRadius: 18,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(14),
                                    onTap: authState.isLoading ? null : _login,
                                    child: Center(
                                      child: authState.isLoading
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : const Text(
                                              'Sign In',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                letterSpacing: 0.2,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // "Or continue with" divider
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(height: 1, color: const Color(0xFF1E2436))),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 14),
                                    child: Text(
                                      'Or continue with',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(height: 1, color: const Color(0xFF1E2436))),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Social Icon Row (Google, Apple, LinkedIn)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildSocialCircle(
                                    iconWidget: const Text(
                                      'G',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFFEA4335),
                                      ),
                                    ),
                                    onTap: _loginWithGoogle,
                                  ),
                                  const SizedBox(width: 18),
                                  _buildSocialCircle(
                                    iconWidget: const Icon(
                                      Icons.apple,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    onTap: _loginWithGoogle,
                                  ),
                                  const SizedBox(width: 18),
                                  _buildSocialCircle(
                                    iconWidget: const Text(
                                      'in',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0A66C2),
                                      ),
                                    ),
                                    onTap: _loginWithGoogle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 200.ms)
                          .slideY(begin: 0.15, end: 0),

                      const SizedBox(height: 24),

                      // Bottom link: Create an account
                      GestureDetector(
                        onTap: () => context.push('/auth/signup'),
                        child: Text(
                          selectedRole == UserType.recruiter
                              ? 'Create a recruiter account'
                              : 'Create an account',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7C3AED) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialCircle({
    required Widget iconWidget,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF121622),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF232A3B)),
        ),
        child: Center(child: iconWidget),
      ),
    );
  }
}
