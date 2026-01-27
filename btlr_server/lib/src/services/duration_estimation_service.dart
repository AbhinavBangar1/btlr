import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Service for estimating task durations without using LLMs
/// Uses historical data and smart heuristics
class DurationEstimationService {
  /// Estimate task duration based on historical data
  static Future<int> estimateTaskDuration(
    Session session,
    LearningGoal goal,
    StudentProfile profile,
  ) async {
    // 1. If user provided estimate, use it (convert hours to minutes)
    if (goal.estimatedHours != null && goal.estimatedHours! > 0) {
      return (goal.estimatedHours! * 60).round();
    }

    // 2. Check historical data for similar tasks
    final historicalData = await _getHistoricalTaskDuration(
      session,
      goal.studentProfileId,
      goal.category,
    );

    if (historicalData != null) {
      session.log('Using historical average: $historicalData min for category ${goal.category}');
      return historicalData;
    }

    // 3. Use category-based defaults
    final defaultDuration = _getDefaultDurationByCategory(goal.category, profile);
    session.log('Using default duration: $defaultDuration min for category ${goal.category}');
    
    return defaultDuration;
  }

  /// Get average duration from completed goals with same category
  static Future<int?> _getHistoricalTaskDuration(
    Session session,
    int studentProfileId,
    String category,
  ) async {
    // Get completed goals with same category
    final completedGoals = await LearningGoal.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.category.equals(category) &
          t.status.equals('completed') ,
      limit: 10, // Last 10 similar tasks
      orderBy: (t) => t.updatedAt,
      orderDescending: true,
    );

    if (completedGoals.isEmpty) return null;

    // Calculate average in minutes
    final totalHours = completedGoals.fold<double>(
      0.0,
      (sum, goal) => sum + goal.actualHours,
    );

    final avgHours = totalHours / completedGoals.length;
    return (avgHours * 60).round();
  }

  /// Get default duration based on category and profile preferences
  static int _getDefaultDurationByCategory(String category, StudentProfile profile) {
    // Sensible defaults based on category type (in minutes)
    final defaults = {
      'technical_skill': 60,      // Programming, tools, etc.
      'project': 90,              // Larger work items
      'certification': 75,        // Study for certs
      'soft_skill': 45,          // Communication, leadership, etc.
    };

    return defaults[category] ?? profile.preferredStudyBlockMinutes;
  }

  /// Update actual duration when task is completed
  static Future<void> updateActualDuration(
    Session session,
    int learningGoalId,
    int actualMinutes,
  ) async {
    final goal = await LearningGoal.db.findById(session, learningGoalId);
    if (goal == null) return;

    // Convert minutes to hours
    final additionalHours = actualMinutes / 60;
    goal.actualHours += additionalHours;
    
    await LearningGoal.db.updateRow(session, goal);
    
    session.log('Updated goal ${goal.id} actual hours: ${goal.actualHours}');
  }

  /// Get estimated completion percentage based on time spent
  static double getCompletionPercentage(LearningGoal goal) {
    if (goal.estimatedHours == null || goal.estimatedHours! == 0) {
      return 0.0;
    }

    final percentage = (goal.actualHours / goal.estimatedHours!) * 100;
    return percentage.clamp(0.0, 100.0);
  }

  /// Predict if goal will be completed by deadline
  static Future<Map<String, dynamic>> predictCompletion(
    Session session,
    LearningGoal goal,
    StudentProfile profile,
  ) async {
    if (goal.deadline == null || goal.estimatedHours == null) {
      return {
        'canComplete': true,
        'confidence': 'unknown',
        'message': 'No deadline or estimate set',
      };
    }

    final now = DateTime.now();
    final daysUntilDeadline = goal.deadline!.difference(now).inDays;
    
    if (daysUntilDeadline < 0) {
      return {
        'canComplete': false,
        'confidence': 'high',
        'message': 'Deadline has passed',
        'daysOverdue': daysUntilDeadline.abs(),
      };
    }

    // Calculate remaining hours
    final remainingHours = goal.estimatedHours! - goal.actualHours;
    
    if (remainingHours <= 0) {
      return {
        'canComplete': true,
        'confidence': 'high',
        'message': 'Goal already completed!',
      };
    }

    // Get student's average daily study time from recent behavior
    final avgDailyMinutes = await _getAverageDailyStudyTime(session, profile.id!);
    final avgDailyHours = avgDailyMinutes / 60;

    // Calculate if there's enough time
    final hoursAvailable = avgDailyHours * daysUntilDeadline;
    final canComplete = hoursAvailable >= remainingHours;

    // Calculate confidence based on buffer
    final buffer = hoursAvailable / remainingHours;
    String confidence;
    if (buffer >= 1.5) {
      confidence = 'high';
    } else if (buffer >= 1.0) {
      confidence = 'medium';
    } else {
      confidence = 'low';
    }

    return {
      'canComplete': canComplete,
      'confidence': confidence,
      'daysRemaining': daysUntilDeadline,
      'hoursRemaining': remainingHours.toStringAsFixed(1),
      'hoursAvailable': hoursAvailable.toStringAsFixed(1),
      'message': canComplete 
          ? 'On track to complete by deadline'
          : 'Need ${(remainingHours - hoursAvailable).toStringAsFixed(1)} more hours',
    };
  }

  /// Get average daily study time from behavior logs
  static Future<int> _getAverageDailyStudyTime(
    Session session,
    int studentProfileId,
  ) async {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 14));

    // Get completed time blocks from last 2 weeks
    final completedBlocks = await TimeBlock.db.find(
      session,
      where: (t) =>
          t.completionStatus.equals('completed') &
          t.blockType.equals('study') &
          (t.startTime > cutoffDate),
    );

    if (completedBlocks.isEmpty) {
      return 120; // Default: 2 hours per day
    }

    // Group by date and calculate average
    final minutesByDate = <DateTime, int>{};
    
    for (final block in completedBlocks) {
      final date = DateTime(
        block.startTime.year,
        block.startTime.month,
        block.startTime.day,
      );
      
      minutesByDate[date] = (minutesByDate[date] ?? 0) + 
          (block.actualDurationMinutes ?? block.durationMinutes);
    }

    if (minutesByDate.isEmpty) return 120;

    final totalMinutes = minutesByDate.values.reduce((a, b) => a + b);
    final avgMinutes = totalMinutes / minutesByDate.length;

    return avgMinutes.round();
  }

  /// Suggest optimal session length for a goal
  static Future<int> suggestOptimalSessionLength(
    Session session,
    LearningGoal goal,
    StudentProfile profile,
  ) async {
    // Get historical completion data
    final completedBlocks = await TimeBlock.db.find(
      session,
      where: (t) =>
          t.learningGoalId.equals(goal.id!) &
          t.completionStatus.equals('completed') &
          t.actualDurationMinutes.notEquals(null),
      limit: 20,
    );

    if (completedBlocks.isEmpty) {
      // Use category-based default
      return _getDefaultDurationByCategory(goal.category, profile);
    }

    // Calculate average actual duration
    final totalMinutes = completedBlocks.fold<int>(
      0,
      (sum, block) => sum + block.actualDurationMinutes!,
    );

    final avgMinutes = totalMinutes / completedBlocks.length;

    // Round to nearest 5 minutes
    final rounded = ((avgMinutes / 5).round() * 5).toInt();

    // Clamp between 25 and 90 minutes
    return rounded.clamp(25, 90);
  }
}