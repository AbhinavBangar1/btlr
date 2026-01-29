import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btlr_client/btlr_client.dart';
import 'api_client_provider.dart';

/// Student profile state provider
final studentProfileProvider = StateNotifierProvider<StudentProfileNotifier, AsyncValue<StudentProfile?>>((ref) {
  return StudentProfileNotifier(ref);
});

/// Student profile notifier
class StudentProfileNotifier extends StateNotifier<AsyncValue<StudentProfile?>> {
  final Ref ref;

  StudentProfileNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadProfile();
  }

  /// Load current student profile
  Future<void> _loadProfile() async {
    final studentId = ref.read(currentStudentIdProvider);
    
    if (studentId == null) {
      state = const AsyncValue.data(null);
      return;
    }

    state = const AsyncValue.loading();
    
    try {
      final endpoint = ref.read(studentEndpointProvider);
      final profile = await endpoint.getProfile(studentId);
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Create new student profile
  Future<StudentProfile?> createProfile({
    required String name,
    required String email,
    required String timezone,
    required String wakeTime,
    required String sleepTime,
    required int preferredStudyBlockMinutes,
    required int preferredBreakMinutes,
    String? preferredStudyTimes,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final endpoint = ref.read(studentEndpointProvider);
      final profile = await endpoint.createProfile(
        name,
        email,
        timezone,
        wakeTime,
        sleepTime,
        preferredStudyBlockMinutes,
        preferredBreakMinutes,
        preferredStudyTimes,
      );
      
      // Set as current student
      ref.read(currentStudentIdProvider.notifier).state = profile.id;
      
      state = AsyncValue.data(profile);
      return profile;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

/// Update student profile
Future<StudentProfile?> updateProfile({
  String? name,
  String? timezone,
  String? wakeTime,
  String? sleepTime,
  int? preferredStudyBlockMinutes,
  int? preferredBreakMinutes,
  String? preferredStudyTimes,
  // ADD THESE NEW PARAMETERS
  String? githubUsername,
  String? leetcodeUsername,
  String? codeforcesUsername,
  String? linkedinUrl,
  String? portfolioUrl,
}) async {
  final currentProfile = state.value;
  if (currentProfile == null) return null;

  state = const AsyncValue.loading();
  
  try {
    final endpoint = ref.read(studentEndpointProvider);
    final updated = await endpoint.updateProfile(
      currentProfile.id!,
      name,
      timezone,
      wakeTime,
      sleepTime,
      preferredStudyBlockMinutes,
      preferredBreakMinutes,
      preferredStudyTimes,
      // ADD THESE NEW ARGUMENTS
      githubUsername,
      leetcodeUsername,
      codeforcesUsername,
      linkedinUrl,
      portfolioUrl,
    );
    
    state = AsyncValue.data(updated);
    return updated;
  } catch (e, stack) {
    state = AsyncValue.error(e, stack);
    return null;
  }
}


  /// Reload profile
  Future<void> reload() async {
    await _loadProfile();
  }

  /// Get profile by email
  Future<StudentProfile?> getProfileByEmail(String email) async {
    try {
      final endpoint = ref.read(studentEndpointProvider);
      final profile = await endpoint.getProfileByEmail(email);
      
      if (profile != null) {
        // Set as current student
        ref.read(currentStudentIdProvider.notifier).state = profile.id;
        state = AsyncValue.data(profile);
      }
      
      return profile;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// Delete profile
  Future<bool> deleteProfile() async {
    final currentProfile = state.value;
    if (currentProfile == null) return false;

    try {
      final endpoint = ref.read(studentEndpointProvider);
      final deleted = await endpoint.deleteProfile(currentProfile.id!);
      
      if (deleted) {
        ref.read(currentStudentIdProvider.notifier).state = null;
        state = const AsyncValue.data(null);
      }
      
      return deleted;
    } catch (e) {
      return false;
    }
  }
}

/// Convenience provider to get current student ID
final currentStudentProvider = Provider<int?>((ref) {
  return ref.watch(currentStudentIdProvider);
});

/// Provider to check if user has a profile
final hasProfileProvider = Provider<bool>((ref) {
  final profile = ref.watch(studentProfileProvider);
  return profile.value != null;
});