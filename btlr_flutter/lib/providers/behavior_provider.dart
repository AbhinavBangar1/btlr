import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btlr_client/btlr_client.dart';
import 'api_client_provider.dart';

/// Behavior logs provider
final behaviorLogsProvider = StateNotifierProvider<BehaviorLogsNotifier, AsyncValue<List<BehaviorLog>>>((ref) {
  return BehaviorLogsNotifier(ref);
});

/// Behavior logs notifier
class BehaviorLogsNotifier extends StateNotifier<AsyncValue<List<BehaviorLog>>> {
  final Ref ref;

  BehaviorLogsNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadLogs();
  }

  /// Load recent behavior logs
  Future<void> loadLogs({int limit = 100}) async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    
    try {
      final endpoint = ref.read(behaviorEndpointProvider);
      final logs = await endpoint.getStudentLogs(studentId, limit: limit);
      state = AsyncValue.data(logs);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Log completion
  Future<bool> logCompletion(
    int timeBlockId, {
    int? actualDuration,
    int? energyLevel,
    String? notes,
  }) async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) return false;

    try {
      final endpoint = ref.read(behaviorEndpointProvider);
      await endpoint.logCompletion(
        studentId,
        timeBlockId,
        actualDuration,
        energyLevel,
        notes,
      );
      
      // Reload logs
      await loadLogs();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Log miss
  Future<bool> logMiss(
    int timeBlockId,
    String reason, {
    String? notes,
  }) async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) return false;

    try {
      final endpoint = ref.read(behaviorEndpointProvider);
      await endpoint.logMiss(
        studentId,
        timeBlockId,
        reason,
        notes,
      );
      
      // Reload logs
      await loadLogs();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Log postpone
  Future<bool> logPostpone(
    int timeBlockId,
    String reason, {
    String? notes,
  }) async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) return false;

    try {
      final endpoint = ref.read(behaviorEndpointProvider);
      await endpoint.logPostpone(
        studentId,
        timeBlockId,
        reason,
        notes,
      );
      
      // Reload logs
      await loadLogs();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Log start
  Future<bool> logStart(
    int timeBlockId, {
    String? notes,
  }) async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) return false;

    try {
      final endpoint = ref.read(behaviorEndpointProvider);
      await endpoint.logStart(
        studentId,
        timeBlockId,
        notes,
      );
      
      // Reload logs
      await loadLogs();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Reload logs
  Future<void> reload() async {
    await loadLogs();
  }
}

/// Completion statistics provider
final completionStatsProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, days) async {
  final studentId = ref.watch(currentStudentIdProvider);
  if (studentId == null) {
    return {
      'totalCompleted': 0,
      'totalMissed': 0,
      'totalLogs': 0,
      'completionRate': 0.0,
      'days': days,
    };
  }

  final endpoint = ref.read(behaviorEndpointProvider);
  return await endpoint.getCompletionStats(studentId, days: days);
});

/// Default 30-day completion stats
final defaultCompletionStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.watch(completionStatsProvider(30).future);
});

/// Daily completion rates provider
final dailyCompletionRatesProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, days) async {
  final studentId = ref.watch(currentStudentIdProvider);
  if (studentId == null) return [];

  final endpoint = ref.read(behaviorEndpointProvider);
  return await endpoint.getDailyCompletionRates(studentId, days);
});

/// Optimal block length provider
final optimalBlockLengthProvider = FutureProvider<int>((ref) async {
  final studentId = ref.watch(currentStudentIdProvider);
  if (studentId == null) return 50; // Default

  final endpoint = ref.read(behaviorEndpointProvider);
  return await endpoint.getOptimalBlockLength(studentId);
});

/// Miss reasons breakdown provider
final missReasonsProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, days) async {
  final studentId = ref.watch(currentStudentIdProvider);
  if (studentId == null) {
    return {
      'totalMisses': 0,
      'reasonCounts': <String, int>{},
      'mostCommonReason': null,
    };
  }

  final endpoint = ref.read(behaviorEndpointProvider);
  return await endpoint.getMissReasonsBreakdown(studentId, days);
});

/// Time of day performance provider
final timeOfDayPerformanceProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, days) async {
  final studentId = ref.watch(currentStudentIdProvider);
  if (studentId == null) {
    return {
      'hourlyStats': <int, Map<String, int>>{},
      'hourlyCompletionRates': <String, double>{},
      'bestHours': <String>[],
      'worstHours': <String>[],
    };
  }

  final endpoint = ref.read(behaviorEndpointProvider);
  return await endpoint.getTimeOfDayPerformance(studentId, days);
});

/// Streak information provider
final streakInfoProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final studentId = ref.watch(currentStudentIdProvider);
  if (studentId == null) {
    return {
      'currentStreak': 0,
      'longestStreak': 0,
      'lastCompletionDate': null,
    };
  }

  final endpoint = ref.read(behaviorEndpointProvider);
  return await endpoint.getStreakInfo(studentId);
});

/// Energy trends provider
final energyTrendsProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, days) async {
  final studentId = ref.watch(currentStudentIdProvider);
  if (studentId == null) {
    return {
      'averageEnergy': 0.0,
      'logsWithEnergy': 0,
      'energyDistribution': <int, int>{},
    };
  }

  final endpoint = ref.read(behaviorEndpointProvider);
  return await endpoint.getEnergyTrends(studentId, days);
});