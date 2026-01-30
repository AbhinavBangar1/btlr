// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/auth_provider.dart';
// import '../providers/onboarding_provider.dart';
// import '../providers/api_client_provider.dart';
// import 'home_screen.dart';
// import 'login_screen.dart';
// import 'schedule_onboarding_screen.dart';

// class AuthGuardScreen extends ConsumerWidget {
//   const AuthGuardScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authStateProvider);
//     final onboardingCompleted = ref.watch(onboardingProvider);
//     final currentStudentId = ref.watch(currentStudentIdProvider);

//     return authState.when(
//       data: (email) {
//         // Not logged in - show login
//         if (email == null) {
//           return const LoginScreen();
//         }
//         // Logged in but onboarding not done - show onboarding
//         if (onboardingCompleted == OnboardingState.notStarted) {
//           return ScheduleOnboardingScreen(
//             studentProfileId: currentStudentId ?? 0,
//             onComplete: () {
//               ref.read(onboardingProvider.notifier).markCompleted();
//             },
//           );
//         }


//         // Logged in AND onboarding done - show home
//         return const HomeScreen();
//       },
//       loading: () => const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(
//             color: Color(0xFF274B7F),
//           ),
//         ),
//       ),
//       error: (error, stack) => const LoginScreen(),
//     );
//   }
// }










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
    // Watching the authentication state (returns AsyncValue<String?>)
    final authState = ref.watch(authStateProvider);

    // Watching onboarding status
    final onboardingStatus = ref.watch(onboardingProvider);

    // Watching current student profile ID
    final currentStudentId = ref.watch(currentStudentIdProvider);

    return authState.when(
      data: (email) {
        // --- 1. GUEST STATE ---
        // If no email is returned, the user is not authenticated.
        if (email == null) {
          return const LoginScreen();
        }

        // --- 2. ONBOARDING STATE ---
        // User is logged in, but we check if they've finished the setup.
        // We use the enum 'notStarted' to trigger the onboarding flow.
        if (onboardingStatus == OnboardingState.notStarted) {
          return ScheduleOnboardingScreen(
            studentProfileId: currentStudentId ?? 0,
            onComplete: () {
              ref.read(onboardingProvider.notifier).markCompleted();
            },
          );
        }

        // --- 3. AUTHENTICATED & READY ---
        // Both conditions met: User is logged in AND onboarding is done.
        return const HomeScreen();
      },

      // --- LOADING STATE ---
      // This prevents the white screen by showing a branded loader
      // while the server validates the session token.
      loading: () => const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF274B7F), // BTLR Sapphire Blue
          ),
        ),
      ),

      // --- ERROR STATE ---
      // If the auth check fails (e.g., network error), default to Login.
      error: (error, stack) => const LoginScreen(),
    );
  }
}