import 'package:flutter/material.dart';
import 'welcome_screen.dart';

/// Legacy adapter routing `/onboarding` to the Editorial Utility [WelcomeScreen].
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const WelcomeScreen();
  }
}
