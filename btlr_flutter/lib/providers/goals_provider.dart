import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btlr_client/btlr_client.dart';
import 'api_client_provider.dart';

/// All goals for current student
final goalsProvider = StateNotifierProvider<GoalsNotifier, AsyncValue<List<LearningGoal>>>((ref) {
  return GoalsNotifier(ref);
});

/// Goals notifier
class GoalsNotifier extends StateNotifier<AsyncValue<List<LearningGoal>>> {
  final Ref ref;

  GoalsNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadGoals();
  }

  /// Load all goals for current student
  Future<void> loadGoals() async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    
    try {
      final endpoint = ref.read(goalEndpointProvider);
      final goals = await endpoint.getStudentGoals(studentId);
      state = AsyncValue.data(goals);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Create new goal
  Future<LearningGoal?> createGoal({
    required String title,
    required String category,
    required String priority,
    String? description,
    double? estimatedHours,
    DateTime? deadline,
    String? tags,
  }) async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) return null;

    try {
      final endpoint = ref.read(goalEndpointProvider);
      final goal = await endpoint.createGoal(
        studentId,
        title,
        category,
        priority,
        description,
        estimatedHours,
        deadline,
        tags,
      );
      
      // Reload goals
      await loadGoals();
      return goal;
    } catch (e) {
      return null;
    }
  }

  /// Update goal
  Future<LearningGoal?> updateGoal(
    int goalId, {
    String? title,
    String? description,
    String? category,
    String? status,
    String? priority,
    double? estimatedHours,
    double? actualHours,
    DateTime? deadline,
    String? tags,
  }) async {
    try {
      final endpoint = ref.read(goalEndpointProvider);
      final updated = await endpoint.updateGoal(
        goalId,
        title,
        description,
        category,
        status,
        priority,
        estimatedHours,
        actualHours,
        deadline,
        tags,
      );
      
      // Reload goals
      await loadGoals();
      return updated;
    } catch (e) {
      return null;
    }
  }

  /// Mark goal as completed
  Future<bool> completeGoal(int goalId) async {
    try {
      final endpoint = ref.read(goalEndpointProvider);
      await endpoint.completeGoal(goalId);
      await loadGoals();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Add hours to goal
  Future<bool> addHours(int goalId, double hours) async {
    try {
      final endpoint = ref.read(goalEndpointProvider);
      await endpoint.addHours(goalId, hours);
      await loadGoals();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Delete goal
  Future<bool> deleteGoal(int goalId) async {
    try {
      final endpoint = ref.read(goalEndpointProvider);
      final deleted = await endpoint.deleteGoal(goalId);
      if (deleted) {
        await loadGoals();
      }
      return deleted;
    } catch (e) {
      return false;
    }
  }
}

/// Active goals only (in_progress or not_started)
final activeGoalsProvider = Provider<List<LearningGoal>>((ref) {
  final goalsAsync = ref.watch(goalsProvider);
  return goalsAsync.when(
    data: (goals) => goals.where((g) => 
      g.status == 'in_progress' || g.status == 'not_started'
    ).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
});

/// High priority goals
final highPriorityGoalsProvider = Provider<List<LearningGoal>>((ref) {
  final goalsAsync = ref.watch(goalsProvider);
  return goalsAsync.when(
    data: (goals) => goals.where((g) => g.priority == 'high').toList(),
    loading: () => [],
    error: (_, _) => [],
  );
});

/// Goal statistics provider
final goalStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final studentId = ref.watch(currentStudentIdProvider);
  if (studentId == null) {
    return {
      'totalGoals': 0,
      'completed': 0,
      'inProgress': 0,
      'notStarted': 0,
      'paused': 0,
      'completionRate': 0.0,
    };
  }

  final endpoint = ref.read(goalEndpointProvider);
  return await endpoint.getGoalStats(studentId);
});