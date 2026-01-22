import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/adaptation_service.dart';

/// Endpoint for logging and analyzing behavior patterns
class BehaviorEndpoint extends Endpoint {
  /// Log completion of a time block
  Future<BehaviorLog> logCompletion(
    Session session,
    int studentProfileId,
    int timeBlockId,
    int? actualDuration,
    int? energyLevel,
    String? notes,
  ) async {
    // Validate student exists
    final student = await StudentProfile.db.findById(session, studentProfileId);
    if (student == null) {
      throw Exception('Student profile not found');
    }

    // Validate time block exists
    final block = await TimeBlock.db.findById(session, timeBlockId);
    if (block == null) {
      throw Exception('Time block not found');
    }

    final log = BehaviorLog(
      studentProfileId: studentProfileId,
      timeBlockId: timeBlockId,
      action: 'completed',
      timestamp: DateTime.now(),
      actualDuration: actualDuration,
      energyLevel: energyLevel,
      notes: notes,
    );

    final saved = await BehaviorLog.db.insertRow(session, log);
    
    // Update the time block
    block.isCompleted = true;
    block.completionStatus = 'completed';
    if (actualDuration != null) block.actualDurationMinutes = actualDuration;
    if (energyLevel != null) block.energyLevel = energyLevel;
    await TimeBlock.db.updateRow(session, block);
    
    session.log('Logged completion for block: $timeBlockId');
    return saved;
  }

  /// Log missed time block
  Future<BehaviorLog> logMiss(
    Session session,
    int studentProfileId,
    int timeBlockId,
    String reason,
    String? notes,
  ) async {
    // Validate student exists
    final student = await StudentProfile.db.findById(session, studentProfileId);
    if (student == null) {
      throw Exception('Student profile not found');
    }

    // Validate time block exists
    final block = await TimeBlock.db.findById(session, timeBlockId);
    if (block == null) {
      throw Exception('Time block not found');
    }

    final log = BehaviorLog(
      studentProfileId: studentProfileId,
      timeBlockId: timeBlockId,
      action: 'missed',
      timestamp: DateTime.now(),
      reason: reason,
      notes: notes,
    );

    final saved = await BehaviorLog.db.insertRow(session, log);
    
    // Update the time block
    block.completionStatus = 'missed';
    block.missReason = reason;
    await TimeBlock.db.updateRow(session, block);
    
    session.log('Logged miss for block: $timeBlockId with reason: $reason');
    return saved;
  }

  /// Log postponed time block
  Future<BehaviorLog> logPostpone(
    Session session,
    int studentProfileId,
    int timeBlockId,
    String reason,
    String? notes,
  ) async {
    // Validate student exists
    final student = await StudentProfile.db.findById(session, studentProfileId);
    if (student == null) {
      throw Exception('Student profile not found');
    }

    // Validate time block exists
    final block = await TimeBlock.db.findById(session, timeBlockId);
    if (block == null) {
      throw Exception('Time block not found');
    }

    final log = BehaviorLog(
      studentProfileId: studentProfileId,
      timeBlockId: timeBlockId,
      action: 'postponed',
      timestamp: DateTime.now(),
      reason: reason,
      notes: notes,
    );

    final saved = await BehaviorLog.db.insertRow(session, log);
    
    // Update the time block
    block.completionStatus = 'postponed';
    await TimeBlock.db.updateRow(session, block);
    
    session.log('Logged postpone for block: $timeBlockId');
    return saved;
  }

  /// Log starting a time block
  Future<BehaviorLog> logStart(
    Session session,
    int studentProfileId,
    int timeBlockId,
    String? notes,
  ) async {
    // Validate student exists
    final student = await StudentProfile.db.findById(session, studentProfileId);
    if (student == null) {
      throw Exception('Student profile not found');
    }

    // Validate time block exists
    final block = await TimeBlock.db.findById(session, timeBlockId);
    if (block == null) {
      throw Exception('Time block not found');
    }

    final log = BehaviorLog(
      studentProfileId: studentProfileId,
      timeBlockId: timeBlockId,
      action: 'started',
      timestamp: DateTime.now(),
      notes: notes,
    );

    final saved = await BehaviorLog.db.insertRow(session, log);
    session.log('Logged start for block: $timeBlockId');
    return saved;
  }

  /// Get behavior log by ID
  Future<BehaviorLog?> getLog(Session session, int id) async {
    return await BehaviorLog.db.findById(session, id);
  }

  /// Get all logs for a time block
  Future<List<BehaviorLog>> getBlockLogs(
    Session session,
    int timeBlockId,
  ) async {
    return await BehaviorLog.db.find(
      session,
      where: (t) => t.timeBlockId.equals(timeBlockId),
      orderBy: (t) => t.timestamp,
    );
  }

  /// Get all logs for a student
  Future<List<BehaviorLog>> getStudentLogs(
    Session session,
    int studentProfileId,
    {int limit = 100}
  ) async {
    return await BehaviorLog.db.find(
      session,
      where: (t) => t.studentProfileId.equals(studentProfileId),
      orderBy: (t) => t.timestamp,
      orderDescending: true,
      limit: limit,
    );
  }

  /// Get logs in date range
  Future<List<BehaviorLog>> getLogsInRange(
    Session session,
    int studentProfileId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await BehaviorLog.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.timestamp.between(startDate, endDate),
      orderBy: (t) => t.timestamp,
    );
  }

  /// Get logs by action type
  Future<List<BehaviorLog>> getLogsByAction(
    Session session,
    int studentProfileId,
    String action,
  ) async {
    return await BehaviorLog.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.action.equals(action),
      orderBy: (t) => t.timestamp,
      orderDescending: true,
    );
  }

  /// Get completion statistics
  Future<Map<String, dynamic>> getCompletionStats(
    Session session,
    int studentProfileId,
    {int days = 30}
  ) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));

    final completedLogs = await BehaviorLog.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.action.equals('completed') &
          t.timestamp.between(startDate, endDate),
    );

    final missedLogs = await BehaviorLog.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.action.equals('missed') &
          t.timestamp.between(startDate, endDate),
    );

    final totalLogs = completedLogs.length + missedLogs.length;
    final completionRate = totalLogs > 0 ? completedLogs.length / totalLogs : 0.0;

    return {
      'totalCompleted': completedLogs.length,
      'totalMissed': missedLogs.length,
      'totalLogs': totalLogs,
      'completionRate': completionRate,
      'days': days,
    };
  }

  /// Get daily completion rates
  Future<List<Map<String, dynamic>>> getDailyCompletionRates(
    Session session,
    int studentProfileId,
    int days,
  ) async {
    final rates = <Map<String, dynamic>>[];
    final today = DateTime.now();

    for (int i = 0; i < days; i++) {
      final date = today.subtract(Duration(days: i));
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final completed = await BehaviorLog.db.find(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.action.equals('completed') &
            t.timestamp.between(startOfDay, endOfDay),
      );

      final missed = await BehaviorLog.db.find(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.action.equals('missed') &
            t.timestamp.between(startOfDay, endOfDay),
      );

      final total = completed.length + missed.length;
      final rate = total > 0 ? completed.length / total : 0.0;

      rates.add({
        'date': startOfDay.toIso8601String(),
        'completed': completed.length,
        'missed': missed.length,
        'total': total,
        'rate': rate,
      });
    }

    return rates;
  }

  /// Analyze recent behavior patterns
  Future<Map<String, dynamic>> analyzeRecentBehavior(
    Session session,
    int studentProfileId,
    {int days = 14}
  ) async {
    try {
      final patterns = await AdaptationService.analyzeRecentBehavior(
        session,
        studentProfileId,
        days: days,
      );
      return patterns;
    } catch (e) {
      session.log('Failed to analyze behavior: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Get optimal block length suggestion
  Future<int> getOptimalBlockLength(
    Session session,
    int studentProfileId,
  ) async {
    // Get recent completed logs with actual duration
    final recentLogs = await BehaviorLog.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.action.equals('completed') &
          t.actualDuration.notEquals(null),
      orderBy: (t) => t.timestamp,
      orderDescending: true,
      limit: 20,
    );

    if (recentLogs.isEmpty) {
      // Default to profile preference
      final profile = await StudentProfile.db.findById(session, studentProfileId);
      return profile?.preferredStudyBlockMinutes ?? 50;
    }

    // Calculate average actual duration
    final totalDuration = recentLogs
        .map((l) => l.actualDuration!)
        .fold<int>(0, (sum, duration) => sum + duration);
    
    final avgDuration = totalDuration ~/ recentLogs.length;
    
    // Round to nearest 5 minutes
    return ((avgDuration / 5).round() * 5).clamp(25, 90);
  }

  /// Get miss reasons breakdown
  Future<Map<String, dynamic>> getMissReasonsBreakdown(
    Session session,
    int studentProfileId,
    int days,
  ) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));

    final logs = await BehaviorLog.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.action.equals('missed') &
          t.timestamp.between(startDate, endDate),
    );

    final reasonCounts = <String, int>{};
    for (final log in logs) {
      if (log.reason != null) {
        reasonCounts[log.reason!] = (reasonCounts[log.reason!] ?? 0) + 1;
      }
    }

    String? mostCommonReason;
    if (reasonCounts.isNotEmpty) {
      mostCommonReason = reasonCounts.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
    }

    return {
      'totalMisses': logs.length,
      'reasonCounts': reasonCounts,
      'mostCommonReason': mostCommonReason,
    };
  }

  /// Get time-of-day performance analysis
  Future<Map<String, dynamic>> getTimeOfDayPerformance(
    Session session,
    int studentProfileId,
    int days,
  ) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));

    final logs = await BehaviorLog.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.timestamp.between(startDate, endDate),
    );

    final hourlyStats = <int, Map<String, int>>{};
    
    for (final log in logs) {
      final hour = log.timestamp.hour;
      hourlyStats[hour] ??= {'completed': 0, 'missed': 0, 'postponed': 0, 'started': 0};
      hourlyStats[hour]![log.action] = (hourlyStats[hour]![log.action] ?? 0) + 1;
    }

    // Calculate completion rate per hour
    final hourlyRates = <String, double>{};
    hourlyStats.forEach((hour, stats) {
      final total = stats.values.reduce((a, b) => a + b);
      final completed = stats['completed'] ?? 0;
      hourlyRates['${hour.toString().padLeft(2, '0')}:00'] = 
          total > 0 ? completed / total : 0.0;
    });

    final sortedByRate = hourlyRates.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return {
      'hourlyStats': hourlyStats,
      'hourlyCompletionRates': hourlyRates,
      'bestHours': sortedByRate.take(3).map((e) => e.key).toList(),
      'worstHours': sortedByRate.reversed.take(3).map((e) => e.key).toList(),
    };
  }

  /// Get streak information
  Future<Map<String, dynamic>> getStreakInfo(
    Session session,
    int studentProfileId,
  ) async {
    final logs = await BehaviorLog.db.find(
      session,
      where: (t) => 
          t.studentProfileId.equals(studentProfileId) &
          t.action.equals('completed'),
      orderBy: (t) => t.timestamp,
      orderDescending: true,
      limit: 100,
    );

    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 0;
    DateTime? lastDate;

    for (final log in logs.reversed) {
      final logDate = DateTime(
        log.timestamp.year,
        log.timestamp.month,
        log.timestamp.day,
      );

      if (lastDate == null || logDate.difference(lastDate).inDays == 1) {
        tempStreak++;
        longestStreak = tempStreak > longestStreak ? tempStreak : longestStreak;
      } else if (logDate.difference(lastDate).inDays > 1) {
        tempStreak = 1;
      }
      lastDate = logDate;
    }

    // Check if streak is current
    if (lastDate != null) {
      final today = DateTime.now();
      final normalizedToday = DateTime(today.year, today.month, today.day);
      if (lastDate == normalizedToday || lastDate == normalizedToday.subtract(const Duration(days: 1))) {
        currentStreak = tempStreak;
      }
    }

    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastCompletionDate': lastDate?.toIso8601String(),
    };
  }

  /// Get energy level trends
  Future<Map<String, dynamic>> getEnergyTrends(
    Session session,
    int studentProfileId,
    int days,
  ) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));

    final logs = await BehaviorLog.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.timestamp.between(startDate, endDate) &
          t.energyLevel.notEquals(null),
    );

    if (logs.isEmpty) {
      return {
        'averageEnergy': 0.0,
        'logsWithEnergy': 0,
        'energyDistribution': <int, int>{},
      };
    }

    final energyLevels = logs.map((l) => l.energyLevel!).toList();
    final avgEnergy = energyLevels.reduce((a, b) => a + b) / energyLevels.length;

    final distribution = <int, int>{};
    for (final level in energyLevels) {
      distribution[level] = (distribution[level] ?? 0) + 1;
    }

    return {
      'averageEnergy': avgEnergy,
      'logsWithEnergy': logs.length,
      'energyDistribution': distribution,
    };
  }

  /// Update behavior log (for corrections)
  Future<BehaviorLog> updateLog(
    Session session,
    int id,
    String? action,
    int? actualDuration,
    int? energyLevel,
    String? reason,
    String? notes,
    String? context,
  ) async {
    final log = await BehaviorLog.db.findById(session, id);
    if (log == null) {
      throw Exception('Behavior log not found');
    }

    // Validate action if provided
    if (action != null && !['completed', 'missed', 'postponed', 'started'].contains(action)) {
      throw Exception('Invalid action. Must be: completed, missed, postponed, or started');
    }

    // Validate energyLevel if provided
    if (energyLevel != null && (energyLevel < 1 || energyLevel > 5)) {
      throw Exception('Energy level must be between 1 and 5');
    }

    if (action != null) log.action = action;
    if (actualDuration != null) log.actualDuration = actualDuration;
    if (energyLevel != null) log.energyLevel = energyLevel;
    if (reason != null) log.reason = reason;
    if (notes != null) log.notes = notes;
    if (context != null) log.context = context;

    final updated = await BehaviorLog.db.updateRow(session, log);
    session.log('Updated behavior log: $id');
    return updated;
  }

  /// Delete behavior log
  Future<bool> deleteLog(Session session, int id) async {
    final log = await BehaviorLog.db.findById(session, id);
    if (log == null) {
      return false;
    }

    await BehaviorLog.db.deleteRow(session, log);
    session.log('Deleted behavior log: $id');
    return true;
  }
}