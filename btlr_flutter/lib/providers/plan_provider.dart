import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btlr_client/btlr_client.dart';
import 'api_client_provider.dart';

/// Today's daily plan provider
final todaysPlanProvider = StateNotifierProvider<TodaysPlanNotifier, AsyncValue<DailyPlan?>>((ref) {
  return TodaysPlanNotifier(ref);
});

/// Today's plan notifier
class TodaysPlanNotifier extends StateNotifier<AsyncValue<DailyPlan?>> {
  final Ref ref;

  TodaysPlanNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadTodaysPlan();
  }

  /// Load or generate today's plan
  Future<void> loadTodaysPlan() async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) {
      state = const AsyncValue.data(null);
      return;
    }

    state = const AsyncValue.loading();
    
    try {
      final endpoint = ref.read(planEndpointProvider);
      final plan = await endpoint.getOrGenerateTodaysPlan(studentId);
      state = AsyncValue.data(plan);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Generate new plan for today
  Future<DailyPlan?> generatePlan() async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) return null;

    state = const AsyncValue.loading();
    
    try {
      final endpoint = ref.read(planEndpointProvider);
      final plan = await endpoint.generatePlan(studentId, DateTime.now());
      state = AsyncValue.data(plan);
      return plan;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// Regenerate today's plan (new version)
  Future<DailyPlan?> regeneratePlan() async {
    final currentPlan = state.value;
    if (currentPlan == null) return null;

    state = const AsyncValue.loading();
    
    try {
      final endpoint = ref.read(planEndpointProvider);
      final plan = await endpoint.regeneratePlan(currentPlan.id!);
      state = AsyncValue.data(plan);
      return plan;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// Reload plan
  Future<void> reload() async {
    await loadTodaysPlan();
  }
}

/// Time blocks for today's plan
final todaysBlocksProvider = FutureProvider<List<TimeBlock>>((ref) async {
  final planAsync = ref.watch(todaysPlanProvider);
  
  return planAsync.when(
    data: (plan) async {
      if (plan == null) return [];
      
      final endpoint = ref.read(planEndpointProvider);
      return await endpoint.getPlanBlocks(plan.id!);
    },
    loading: () => [],
    error: (_, _) => [],
  );
});

// ✅ ADD THIS NEW PROVIDER:
final weeklyBlocksProvider = FutureProvider.family<List<TimeBlock>, ({DateTime startDate, DateTime endDate})>((
  ref,
  params,
) async {
  final studentId = ref.watch(currentStudentIdProvider);
  if (studentId == null) return [];

  final endpoint = ref.read(planEndpointProvider);
  
  return await endpoint.getBlocksInRange(
    studentId,
    params.startDate,
    params.endDate,
  );
});


/// Current time block (what should be happening now)
final currentBlockProvider = FutureProvider<TimeBlock?>((ref) async {
  final studentId = ref.watch(currentStudentIdProvider);
  if (studentId == null) return null;

  final endpoint = ref.read(planEndpointProvider);
  return await endpoint.getCurrentBlock(studentId);
});

/// Upcoming blocks (next 24 hours)
final upcomingBlocksProvider = FutureProvider<List<TimeBlock>>((ref) async {
  final studentId = ref.watch(currentStudentIdProvider);
  if (studentId == null) return [];

  final endpoint = ref.read(planEndpointProvider);
  return await endpoint.getUpcomingBlocks(studentId);
});

/// Time block actions notifier
final timeBlockActionsProvider = Provider<TimeBlockActions>((ref) {
  return TimeBlockActions(ref);
});

/// Time block actions
class TimeBlockActions {
  final Ref ref;

  TimeBlockActions(this.ref);

  /// Complete a time block
  Future<bool> completeBlock(
    int blockId, {
    int? actualDurationMinutes,
    int? energyLevel,
    String? notes,
  }) async {
    try {
      final endpoint = ref.read(planEndpointProvider);
      await endpoint.completeBlock(
        blockId,
        actualDurationMinutes,
        energyLevel,
        notes,
      );
      
      // Reload today's plan
      ref.read(todaysPlanProvider.notifier).reload();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Mark block as missed
  Future<bool> missBlock(
    int blockId,
    String missReason, {
    String? notes,
  }) async {
    try {
      final endpoint = ref.read(planEndpointProvider);
      await endpoint.missBlock(blockId, missReason, notes);
      
      // Reload today's plan
      ref.read(todaysPlanProvider.notifier).reload();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update time block
  Future<bool> updateBlock(
    int blockId, {
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    try {
      final endpoint = ref.read(planEndpointProvider);
      await endpoint.updateBlock(
        blockId,
        title,
        description,
        startTime,
        endTime,
        null, // durationMinutes
        null, // isCompleted
        null, // completionStatus
        null, // actualDurationMinutes
        null, // energyLevel
        null, // notes
        null, // missReason
      );
      
      // Reload today's plan
      ref.read(todaysPlanProvider.notifier).reload();
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Plan statistics provider
final planStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final studentId = ref.watch(currentStudentIdProvider);
  if (studentId == null) {
    return {
      'totalPlans': 0,
      'totalPlannedMinutes': 0,
      'averagePlannedMinutesPerDay': 0,
    };
  }

  final endpoint = ref.read(planEndpointProvider);
  return await endpoint.getPlanStats(studentId);
});