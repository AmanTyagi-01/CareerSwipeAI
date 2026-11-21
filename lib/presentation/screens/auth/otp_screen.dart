import 'package:flutter/material.dart';
import 'email_verification_screen.dart';

/// Legacy adapter wrapping the Editorial Utility [EmailVerificationScreen].
class OtpScreen extends StatelessWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return EmailVerificationScreen(email: email);
  }
}
