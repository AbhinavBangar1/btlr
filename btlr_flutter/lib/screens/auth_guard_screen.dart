import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/onboarding_provider.dart';
import '../providers/api_client_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'schedule_onboarding_screen.dart';

class AuthGuardScreen extends ConsumerWidget {
  const AuthGuardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final onboardingCompleted = ref.watch(onboardingProvider);
    final currentStudentId = ref.watch(currentStudentIdProvider);

    return authState.when(
      data: (email) {
        // Not logged in - show login
        if (email == null) {
          return const LoginScreen();
        }
        // Logged in but onboarding not done - show onboarding
        if (onboardingCompleted == OnboardingState.notStarted) {
          return ScheduleOnboardingScreen(
            studentProfileId: currentStudentId ?? 0,
            onComplete: () {
              ref.read(onboardingProvider.notifier).markCompleted();
            },
          );
        }


        // Logged in AND onboarding done - show home
        return const HomeScreen();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF274B7F),
          ),
        ),
      ),
      error: (error, stack) => const LoginScreen(),
    );
  }
}
