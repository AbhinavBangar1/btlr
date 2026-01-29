import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client_provider.dart';

/// Activity dashboard provider
final activityDashboardProvider = StateNotifierProvider<ActivityDashboardNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  return ActivityDashboardNotifier(ref);
});

/// Activity dashboard notifier
class ActivityDashboardNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final Ref ref;

  ActivityDashboardNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadDashboard();
  }

  /// Load activity dashboard
  Future<void> loadDashboard() async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) {
      state = AsyncValue.data({
        'leetcode': null,
        'github': null,
        'summary': {
          'totalProblems': 0,
          'totalCommits': 0,
          'currentStreak': 0,
          'lastActivity': null,
        }
      });
      return;
    }

    state = const AsyncValue.loading();
    
    try {
      final endpoint = ref.read(activityEndpointProvider);
      final dashboard = await endpoint.getDashboard(studentId);
      state = AsyncValue.data(dashboard);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Setup activity tracker
  Future<bool> setupTracker(String platform, String username) async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) return false;

    try {
      final endpoint = ref.read(activityEndpointProvider);
      final success = await endpoint.setupActivityTracker(
        studentId,
        platform,
        username,
      );
      if (success) {
        await loadDashboard();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  /// Sync all activities
  Future<void> syncAll() async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) return;

    try {
      final endpoint = ref.read(activityEndpointProvider);
      await endpoint.syncAllActivities(studentId);
      await loadDashboard();
    } catch (e) {
      // Handle error
    }
  }

  /// Sync specific platform
  Future<void> syncPlatform(String platform) async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) return;

    try {
      final endpoint = ref.read(activityEndpointProvider);
      await endpoint.syncPlatformActivity(
        studentId,
        platform,
      );
      await loadDashboard();
    } catch (e) {
      // Handle error
    }
  }

  /// Delete activity tracker
  Future<bool> deleteTracker(String platform) async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) return false;

    try {
      final endpoint = ref.read(activityEndpointProvider);
      final success = await endpoint.deleteActivityTracker(
        studentId,
        platform,
      );
      if (success) {
        await loadDashboard();
      }
      return success;
    } catch (e) {
      return false;
    }
  }
}

/// LeetCode data provider
final leetcodeDataProvider = Provider<Map<String, dynamic>?>((ref) {
  final dashboardAsync = ref.watch(activityDashboardProvider);
  return dashboardAsync.when(
    data: (dashboard) => dashboard['leetcode'] as Map<String, dynamic>?,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// GitHub data provider
final githubDataProvider = Provider<Map<String, dynamic>?>((ref) {
  final dashboardAsync = ref.watch(activityDashboardProvider);
  return dashboardAsync.when(
    data: (dashboard) => dashboard['github'] as Map<String, dynamic>?,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Activity summary provider
final activitySummaryProvider = Provider<Map<String, dynamic>>((ref) {
  final dashboardAsync = ref.watch(activityDashboardProvider);
  return dashboardAsync.when(
    data: (dashboard) => dashboard['summary'] as Map<String, dynamic>,
    loading: () => {
      'totalProblems': 0,
      'totalCommits': 0,
      'currentStreak': 0,
      'lastActivity': null,
    },
    error: (_, __) => {
      'totalProblems': 0,
      'totalCommits': 0,
      'currentStreak': 0,
      'lastActivity': null,
    },
  );
});

/// Current coding streak
final codingStreakProvider = Provider<int>((ref) {
  final summary = ref.watch(activitySummaryProvider);
  return summary['currentStreak'] as int? ?? 0;
});