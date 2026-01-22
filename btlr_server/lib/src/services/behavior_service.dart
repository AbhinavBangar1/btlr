import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Service for logging and tracking student behavior
/// Handles completion, miss, and postpone events
class BehaviorService {
  /// Log completion of a time block
  static Future<BehaviorLog> logCompletion(
    Session session,
    int timeBlockId,
    int studentProfileId, {
    int? actualDuration,
    int? energyLevel,
    String? notes,
  }) async {
    // Update time block
    final timeBlock = await TimeBlock.db.findById(session, timeBlockId);
    if (timeBlock == null) {
      throw Exception('Time block not found');
    }

    timeBlock.isCompleted = true;
    timeBlock.completionStatus = 'completed';
    timeBlock.actualDurationMinutes = actualDuration;
    timeBlock.energyLevel = energyLevel;
    timeBlock.notes = notes;
    await TimeBlock.db.updateRow(session, timeBlock);

    // Update learning goal progress if linked
    if (timeBlock.learningGoalId != null) {
      await _updateGoalProgress(
        session,
        timeBlock.learningGoalId!,
        actualDuration ?? timeBlock.durationMinutes,
      );
    }

    // Create behavior log
    final log = BehaviorLog(
      studentProfileId: studentProfileId,
      timeBlockId: timeBlockId,
      action: 'completed',
      timestamp: DateTime.now(),
      actualDuration: actualDuration,
      energyLevel: energyLevel,
      notes: notes,
      context: _generateContext(),
    );

    final savedLog = await BehaviorLog.db.insertRow(session, log);
    
    session.log('Logged completion for time block $timeBlockId');
    
    return savedLog;
  }

  /// Log missed time block
  static Future<BehaviorLog> logMissed(
    Session session,
    int timeBlockId,
    int studentProfileId, {
    required String reason,
    String? notes,
  }) async {
    // Update time block
    final timeBlock = await TimeBlock.db.findById(session, timeBlockId);
    if (timeBlock == null) {
      throw Exception('Time block not found');
    }

    timeBlock.completionStatus = 'missed';
    timeBlock.missReason = reason;
    timeBlock.notes = notes;
    await TimeBlock.db.updateRow(session, timeBlock);

    // Create behavior log
    final log = BehaviorLog(
      studentProfileId: studentProfileId,
      timeBlockId: timeBlockId,
      action: 'missed',
      timestamp: DateTime.now(),
      reason: reason,
      notes: notes,
      context: _generateContext(),
    );

    final savedLog = await BehaviorLog.db.insertRow(session, log);
    
    session.log('Logged miss for time block $timeBlockId: $reason');
    
    return savedLog;
  }

  /// Log postponed time block
  static Future<BehaviorLog> logPostponed(
    Session session,
    int timeBlockId,
    int studentProfileId, {
    required String reason,
    String? notes,
  }) async {
    final timeBlock = await TimeBlock.db.findById(session, timeBlockId);
    if (timeBlock == null) {
      throw Exception('Time block not found');
    }

    timeBlock.completionStatus = 'postponed';
    timeBlock.missReason = reason;
    timeBlock.notes = notes;
    await TimeBlock.db.updateRow(session, timeBlock);

    final log = BehaviorLog(
      studentProfileId: studentProfileId,
      timeBlockId: timeBlockId,
      action: 'postponed',
      timestamp: DateTime.now(),
      reason: reason,
      notes: notes,
      context: _generateContext(),
    );

    final savedLog = await BehaviorLog.db.insertRow(session, log);
    
    session.log('Logged postpone for time block $timeBlockId: $reason');
    
    return savedLog;
  }

  /// Log start of a time block
  static Future<BehaviorLog> logStarted(
    Session session,
    int timeBlockId,
    int studentProfileId, {
    String? notes,
  }) async {
    final timeBlock = await TimeBlock.db.findById(session, timeBlockId);
    if (timeBlock == null) {
      throw Exception('Time block not found');
    }

    final log = BehaviorLog(
      studentProfileId: studentProfileId,
      timeBlockId: timeBlockId,
      action: 'started',
      timestamp: DateTime.now(),
      notes: notes,
      context: _generateContext(),
    );

    final savedLog = await BehaviorLog.db.insertRow(session, log);
    
    session.log('Logged start for time block $timeBlockId');
    
    return savedLog;
  }

  /// Update learning goal actual hours
  static Future<void> _updateGoalProgress(
    Session session,
    int goalId,
    int minutesSpent,
  ) async {
    final goal = await LearningGoal.db.findById(session, goalId);
    if (goal == null) return;

    goal.actualHours += minutesSpent / 60.0;
    
    // Auto-update status based on progress
    if (goal.status == 'not_started' && goal.actualHours > 0) {
      goal.status = 'in_progress';
    }

    // Auto-complete if reached estimated hours
    if (goal.estimatedHours != null &&
        goal.actualHours >= goal.estimatedHours! &&
        goal.status != 'completed') {
      goal.status = 'completed';
    }

    goal.updatedAt = DateTime.now();
    await LearningGoal.db.updateRow(session, goal);
  }

  /// Generate context information (time of day, day of week, etc.)
  static String _generateContext() {
    final now = DateTime.now();
    final dayOfWeek = _getDayOfWeek(now.weekday);
    final timeOfDay = _getTimeOfDay(now.hour);
    
    return '{"dayOfWeek":"$dayOfWeek","timeOfDay":"$timeOfDay","hour":${now.hour},"minute":${now.minute}}';
  }

  /// Get day of week name
  static String _getDayOfWeek(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }

  /// Get time of day label
  static String _getTimeOfDay(int hour) {
    if (hour >= 5 && hour < 12) return 'morning';
    if (hour >= 12 && hour < 17) return 'afternoon';
    if (hour >= 17 && hour < 21) return 'evening';
    return 'night';
  }

  /// Get completion statistics for a date range
  static Future<Map<String, dynamic>> getCompletionStats(
    Session session,
    int studentProfileId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final logs = await BehaviorLog.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.timestamp.between(startDate, endDate),
    );

    final completed = logs.where((l) => l.action == 'completed').length;
    final missed = logs.where((l) => l.action == 'missed').length;
    final postponed = logs.where((l) => l.action == 'postponed').length;
    final started = logs.where((l) => l.action == 'started').length;
    final total = logs.length;

    // Calculate total time spent
    final totalMinutes = logs
        .where((l) => l.actualDuration != null)
        .fold<int>(0, (sum, log) => sum + log.actualDuration!);

    // Calculate average energy level
    final energyLogs = logs.where((l) => l.energyLevel != null).toList();
    final avgEnergy = energyLogs.isNotEmpty
        ? energyLogs.fold<int>(0, (sum, log) => sum + log.energyLevel!) / energyLogs.length
        : 0.0;

    return {
      'completed': completed,
      'missed': missed,
      'postponed': postponed,
      'started': started,
      'total': total,
      'completionRate': total > 0 ? completed / total : 0.0,
      'totalMinutesSpent': totalMinutes,
      'totalHoursSpent': totalMinutes / 60,
      'avgEnergyLevel': avgEnergy,
    };
  }

  /// Get most common miss reasons
  static Future<Map<String, int>> getMissReasons(
    Session session,
    int studentProfileId, {
    int daysBack = 30,
  }) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysBack));

    final missedLogs = await BehaviorLog.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.action.equals('missed') &
          (t.timestamp > cutoffDate),
    );

    final reasonCounts = <String, int>{};

    for (final log in missedLogs) {
      final reason = log.reason ?? 'Unknown';
      reasonCounts[reason] = (reasonCounts[reason] ?? 0) + 1;
    }

    // Sort by count
    final sortedReasons = Map.fromEntries(
      reasonCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value)),
    );

    return sortedReasons;
  }

  /// Get energy patterns by time of day
  static Future<Map<String, double>> getEnergyPatterns(
    Session session,
    int studentProfileId, {
    int daysBack = 30,
  }) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysBack));

    final logs = await BehaviorLog.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          (t.timestamp > cutoffDate) &
          t.energyLevel.notEquals(null),
    );

    // Group by hour of day
    final energyByHour = <int, List<int>>{};

    for (final log in logs) {
      final hour = log.timestamp.hour;
      if (!energyByHour.containsKey(hour)) {
        energyByHour[hour] = [];
      }
      if (log.energyLevel != null) {
        energyByHour[hour]!.add(log.energyLevel!);
      }
    }

    // Calculate averages
    final patterns = <String, double>{};
    energyByHour.forEach((hour, levels) {
      if (levels.isNotEmpty) {
        final avg = levels.reduce((a, b) => a + b) / levels.length;
        patterns['${hour.toString().padLeft(2, '0')}:00'] = avg;
      }
    });

    return patterns;
  }

  /// Get completion streak (consecutive days with tasks completed)
  static Future<int> getCompletionStreak(
    Session session,
    int studentProfileId,
  ) async {
    int streak = 0;
    final today = DateTime.now();

    for (int i = 0; i < 365; i++) {
      final date = today.subtract(Duration(days: i));
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final stats = await getCompletionStats(
        session,
        studentProfileId,
        startOfDay,
        endOfDay,
      );

      if (stats['total'] == 0) continue; // Skip days with no tasks

      final completionRate = stats['completionRate'] as double;
      
      if (completionRate >= 0.5) {
        streak++;
      } else {
        break; // Streak broken
      }
    }

    return streak;
  }

  /// Get daily completion data for chart/calendar
  static Future<Map<DateTime, double>> getDailyCompletionData(
    Session session,
    int studentProfileId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final dailyData = <DateTime, double>{};
    
    var currentDate = startDate;
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      final startOfDay = DateTime(currentDate.year, currentDate.month, currentDate.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      final stats = await getCompletionStats(
        session,
        studentProfileId,
        startOfDay,
        endOfDay,
      );
      
      dailyData[startOfDay] = stats['completionRate'] as double;
      
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    return dailyData;
  }

  /// Bulk log completions (for batch updates)
  static Future<List<BehaviorLog>> bulkLogCompletions(
    Session session,
    int studentProfileId,
    List<int> timeBlockIds, {
    String? notes,
  }) async {
    final logs = <BehaviorLog>[];

    for (final timeBlockId in timeBlockIds) {
      try {
        final log = await logCompletion(
          session,
          timeBlockId,
          studentProfileId,
          notes: notes,
        );
        logs.add(log);
      } catch (e) {
        session.log('Failed to log completion for block $timeBlockId: $e');
      }
    }

    return logs;
  }
}