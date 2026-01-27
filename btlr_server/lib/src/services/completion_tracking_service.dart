import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'planning_service.dart';
import 'duration_estimation_service.dart';

/// Service for tracking task completion and auto-rescheduling
/// This eliminates the need for manual completion checking
class CompletionTrackingService {
  /// Check for incomplete tasks that should prompt the user
  /// Returns blocks that ended but weren't marked complete
  static Future<List<TimeBlock>> getIncompleteBlocksNeedingAttention(
    Session session,
    int studentProfileId,
  ) async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    // Get today's plan
    final plan = await DailyPlan.db.findFirstRow(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.planDate.equals(todayStart),
    );

    if (plan == null) return [];

    // Get blocks that should have been completed but aren't
    // (end time has passed, but status is still pending)
    final incompleteBlocks = await TimeBlock.db.find(
      session,
      where: (t) =>
          t.dailyPlanId.equals(plan.id!) &
          t.blockType.equals('study') &
          (t.endTime < now )& // Block ended
          t.completionStatus.equals('pending'), // Not marked
      orderBy: (t) => t.startTime,
    );

    return incompleteBlocks;
  }

  /// Get all incomplete study blocks from past days
  static Future<List<Map<String, dynamic>>> getOverdueBlocks(
    Session session,
    int studentProfileId, {
    int lookbackDays = 7,
  }) async {
    final now = DateTime.now();
    final cutoffDate = now.subtract(Duration(days: lookbackDays));

    // Get all plans from the lookback period
    final plans = await DailyPlan.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.planDate.between(cutoffDate, now),
    );

    final overdueInfo = <Map<String, dynamic>>[];

    for (final plan in plans) {
      final incompleteBlocks = await TimeBlock.db.find(
        session,
        where: (t) =>
            t.dailyPlanId.equals(plan.id!) &
            t.blockType.equals('study') &
            (t.completionStatus.equals('pending') | 
             t.completionStatus.equals('missed')),
      );

      for (final block in incompleteBlocks) {
        // Get the associated goal
        LearningGoal? goal;
        if (block.learningGoalId != null) {
          goal = await LearningGoal.db.findById(session, block.learningGoalId!);
        }

        overdueInfo.add({
          'block': block,
          'goal': goal,
          'planDate': plan.planDate,
          'daysOverdue': now.difference(block.endTime).inDays,
        });
      }
    }

    // Sort by days overdue (most overdue first)
    overdueInfo.sort((a, b) => 
      (b['daysOverdue'] as int).compareTo(a['daysOverdue'] as int)
    );

    return overdueInfo;
  }

  /// Mark a block as completed
  static Future<void> markBlockCompleted(
    Session session,
    int timeBlockId, {
    int? actualMinutes,
    int? energyLevel,
    String? notes,
  }) async {
    final block = await TimeBlock.db.findById(session, timeBlockId);
    if (block == null) {
      throw Exception('Time block not found');
    }

    block.completionStatus = 'completed';
    block.isCompleted = true;
    block.actualDurationMinutes = actualMinutes ?? block.durationMinutes;
    block.energyLevel = energyLevel;
    block.notes = notes;

    await TimeBlock.db.updateRow(session, block);

    // Update the learning goal's actual hours
    if (block.learningGoalId != null) {
      await DurationEstimationService.updateActualDuration(
        session,
        block.learningGoalId!,
        block.actualDurationMinutes ?? block.durationMinutes,
      );
    }

    // Create behavior log for adaptation
    await _createBehaviorLog(
      session,
      block,
      'completed',
      actualMinutes ?? block.durationMinutes,
      energyLevel,
    );

    session.log('Block ${block.id} marked as completed');
  }

  /// Mark a block as missed
  static Future<void> markBlockMissed(
    Session session,
    int timeBlockId, {
    String? reason,
  }) async {
    final block = await TimeBlock.db.findById(session, timeBlockId);
    if (block == null) {
      throw Exception('Time block not found');
    }

    block.completionStatus = 'missed';
    block.isCompleted = false;
    block.missReason = reason;

    await TimeBlock.db.updateRow(session, block);

    // Create behavior log
    await _createBehaviorLog(
      session,
      block,
      'missed',
      null,
      null,
    );

    session.log('Block ${block.id} marked as missed: ${reason ?? "no reason"}');
  }

  /// Auto-reschedule an incomplete task to the next available slot
  static Future<TimeBlock?> rescheduleIncompleteTask(
    Session session,
    int timeBlockId,
    DateTime? preferredDate,
  ) async {
    final block = await TimeBlock.db.findById(session, timeBlockId);
    if (block == null) {
      throw Exception('Time block not found');
    }

    // Mark original block as postponed
    block.completionStatus = 'postponed';
    await TimeBlock.db.updateRow(session, block);

    // Get the original plan to find student ID
    final originalPlan = await DailyPlan.db.findById(session, block.dailyPlanId);
    if (originalPlan == null) return null;

    // Determine target date (default to tomorrow if not specified)
    final targetDate = preferredDate ?? DateTime.now().add(const Duration(days: 1));
    final normalizedDate = DateTime(targetDate.year, targetDate.month, targetDate.day);

    // Get or create plan for target date
    var targetPlan = await DailyPlan.db.findFirstRow(
      session,
      where: (t) =>
          t.studentProfileId.equals(originalPlan.studentProfileId) &
          t.planDate.equals(normalizedDate),
    );

    if (targetPlan == null) {
      // Generate new plan for that date
      targetPlan = await PlanningService.generateDailyPlan(
        session,
        originalPlan.studentProfileId,
        normalizedDate,
      );
    } else {
      // Regenerate plan to include the rescheduled task
      targetPlan = await PlanningService.generateDailyPlan(
        session,
        originalPlan.studentProfileId,
        normalizedDate,
      );
    }

    session.log('Rescheduled block ${block.id} to ${normalizedDate.toIso8601String()}');
    
    // Return the newly created block (the regenerated plan will have picked up the goal)
    final newBlocks = await TimeBlock.db.find(
      session,
      where: (t) =>
          t.dailyPlanId.equals(targetPlan!.id!) &
          t.learningGoalId.equals(block.learningGoalId!),
      limit: 1,
    );

    return newBlocks.isNotEmpty ? newBlocks.first : null;
  }

  /// Auto-detect blocks that should be marked as missed
  /// Run this periodically (e.g., every hour)
  static Future<void> autoMarkMissedBlocks(
    Session session,
    int studentProfileId,
  ) async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    // Get recent plans
    final plans = await DailyPlan.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.planDate.between(yesterday, now),
    );

    for (final plan in plans) {
      // Find blocks that ended more than 1 hour ago but are still pending
      final threshold = now.subtract(const Duration(hours: 1));
      
      final stalePendingBlocks = await TimeBlock.db.find(
        session,
        where: (t) =>
            t.dailyPlanId.equals(plan.id!) &
            t.blockType.equals('study') &
            (t.endTime < threshold) &
            t.completionStatus.equals('pending'),
      );

      for (final block in stalePendingBlocks) {
        await markBlockMissed(
          session,
          block.id!,
          reason: 'Auto-marked: block ended >1 hour ago',
        );
      }
    }
  }

  /// Get completion summary for a date range
  static Future<Map<String, dynamic>> getCompletionSummary(
    Session session,
    int studentProfileId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final start = startDate ?? DateTime.now().subtract(const Duration(days: 7));
    final end = endDate ?? DateTime.now();

    final plans = await DailyPlan.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.planDate.between(start, end),
    );

    int totalBlocks = 0;
    int completedBlocks = 0;
    int missedBlocks = 0;
    int postponedBlocks = 0;
    int totalPlannedMinutes = 0;
    int totalActualMinutes = 0;

    for (final plan in plans) {
      final blocks = await TimeBlock.db.find(
        session,
        where: (t) =>
            t.dailyPlanId.equals(plan.id!) &
            t.blockType.equals('study'),
      );

      totalBlocks += blocks.length;
      completedBlocks += blocks.where((b) => b.completionStatus == 'completed').length;
      missedBlocks += blocks.where((b) => b.completionStatus == 'missed').length;
      postponedBlocks += blocks.where((b) => b.completionStatus == 'postponed').length;
      
      totalPlannedMinutes += blocks.fold(0, (sum, b) => sum + b.durationMinutes);
      totalActualMinutes += blocks.fold(0, (sum, b) => sum + (b.actualDurationMinutes ?? 0));
    }

    final completionRate = totalBlocks > 0 ? completedBlocks / totalBlocks : 0.0;

    return {
      'totalBlocks': totalBlocks,
      'completedBlocks': completedBlocks,
      'missedBlocks': missedBlocks,
      'postponedBlocks': postponedBlocks,
      'pendingBlocks': totalBlocks - completedBlocks - missedBlocks - postponedBlocks,
      'completionRate': completionRate,
      'totalPlannedMinutes': totalPlannedMinutes,
      'totalActualMinutes': totalActualMinutes,
      'totalPlannedHours': (totalPlannedMinutes / 60).toStringAsFixed(1),
      'totalActualHours': (totalActualMinutes / 60).toStringAsFixed(1),
    };
  }

  /// Create behavior log for learning/adaptation
  static Future<void> _createBehaviorLog(
    Session session,
    TimeBlock block,
    String action,
    int? actualDuration,
    int? energyLevel,
  ) async {
    // Get the plan to find student ID
    final plan = await DailyPlan.db.findById(session, block.dailyPlanId);
    if (plan == null) return;

    final log = BehaviorLog(
      studentProfileId: plan.studentProfileId,
      timeBlockId: block.id!,
      action: action, // 'completed', 'missed', 'postponed'
      timestamp: DateTime.now(),
      actualDuration: actualDuration,
      energyLevel: energyLevel,
    );

    await BehaviorLog.db.insertRow(session, log);
  }

  /// Get smart suggestions for what to do with incomplete tasks
  static Future<List<Map<String, dynamic>>> getSuggestions(
    Session session,
    int studentProfileId,
  ) async {
    final suggestions = <Map<String, dynamic>>[];
    
    // Check for blocks needing attention
    final incompleteBlocks = await getIncompleteBlocksNeedingAttention(
      session,
      studentProfileId,
    );

    if (incompleteBlocks.isNotEmpty) {
      suggestions.add({
        'type': 'incomplete_tasks',
        'priority': 'high',
        'count': incompleteBlocks.length,
        'message': 'You have ${incompleteBlocks.length} task(s) from today that need your attention',
        'action': 'review_and_mark',
        'blocks': incompleteBlocks,
      });
    }

    // Check for overdue tasks
    final overdueBlocks = await getOverdueBlocks(session, studentProfileId, lookbackDays: 3);
    
    if (overdueBlocks.isNotEmpty) {
      suggestions.add({
        'type': 'overdue_tasks',
        'priority': 'medium',
        'count': overdueBlocks.length,
        'message': 'You have ${overdueBlocks.length} overdue task(s) from the past 3 days',
        'action': 'reschedule_or_cancel',
        'blocks': overdueBlocks,
      });
    }

    // Check completion rate
    final summary = await getCompletionSummary(session, studentProfileId);
    final completionRate = summary['completionRate'] as double;

    if (completionRate < 0.5 && summary['totalBlocks'] as int > 5) {
      suggestions.add({
        'type': 'low_completion',
        'priority': 'medium',
        'completionRate': completionRate,
        'message': 'Your completion rate is ${(completionRate * 100).toStringAsFixed(0)}%. Consider adjusting your schedule.',
        'action': 'reduce_workload',
      });
    }

    return suggestions;
  }
}