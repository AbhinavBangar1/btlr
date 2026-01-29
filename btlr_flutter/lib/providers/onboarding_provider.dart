import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(),
);

enum OnboardingState { notStarted, completed, skipped }

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  static const _storageKey = 'schedule_onboarding_status';

  OnboardingNotifier() : super(OnboardingState.notStarted) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_storageKey);
    if (value == 'completed') {
      state = OnboardingState.completed;
    } else if (value == 'skipped') {
      state = OnboardingState.skipped;
    }
  }

  Future<void> markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, 'completed');
    state = OnboardingState.completed;
  }

  Future<void> markSkipped() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, 'skipped');
    state = OnboardingState.skipped;
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    state = OnboardingState.notStarted;
  }
}

