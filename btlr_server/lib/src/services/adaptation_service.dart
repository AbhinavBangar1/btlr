// import 'package:serverpod/serverpod.dart';
// import '../generated/protocol.dart';

// /// Service for analyzing behavior and adapting plans
// /// This is the KEY DIFFERENTIATOR - learns from what students actually do
// class AdaptationService {
//   /// Analyze recent behavior patterns (last N days)
//   /// Returns insights for plan generation
//   static Future<Map<String, dynamic>> analyzeRecentBehavior(
//     Session session,
//     int studentProfileId, {
//     int days = 14,
//   }) async {
//     final cutoffDate = DateTime.now().subtract(Duration(days: days));

//     // Get all behavior logs from last N days
//     final logs = await BehaviorLog.db.find(
//       session,
//       where: (t) =>
//           t.studentProfileId.equals(studentProfileId) &
//           (t.timestamp > cutoffDate),
//       orderBy: (t) => t.timestamp,
//     );

//     if (logs.isEmpty) {
//       return {
//         'completionRate': 0.0,
//         'optimalBlockMinutes': 50,
//         'adaptationNotes': 'No behavioral data yet. Using default settings.',
//         'missedTimeSlots': <String, int>{},
//         'avgActualDuration': 0.0,
//       };
//     }

//     // Calculate completion rate
//     final completed = logs.where((l) => l.action == 'completed').length;
//     final total = logs.length;
//     final completionRate = total > 0 ? completed / total : 0.0;

//     // Find frequently missed time slots
//     final missedLogs = logs.where((l) => l.action == 'missed').toList();
//     final missedTimeSlots = <String, int>{};

//     for (final log in missedLogs) {
//       final timeBlock = await TimeBlock.db.findById(session,log.timeBlockId);
//       if (timeBlock != null) {
//         final hour = timeBlock.startTime.hour;
//         final timeSlot = _getTimeSlotLabel(hour);
//         missedTimeSlots[timeSlot] = (missedTimeSlots[timeSlot] ?? 0) + 1;
//       }
//     }

//     // Calculate average actual duration for completed tasks
//     final completedLogs = logs.where((l) => 
//       l.action == 'completed' && l.actualDuration != null
//     ).toList();

//     double avgActualDuration = 0;
//     if (completedLogs.isNotEmpty) {
//       final totalDuration = completedLogs
//           .map((l) => l.actualDuration!)
//           .reduce((a, b) => a + b);
//       avgActualDuration = totalDuration / completedLogs.length;
//     }

//     // Determine optimal block length based on actual completion patterns
//     int optimalBlockMinutes = 50; // default
    
//     if (completedLogs.isNotEmpty && avgActualDuration > 0) {
//       // Round to nearest 5 minutes
//       optimalBlockMinutes = ((avgActualDuration / 5).round() * 5).toInt();
//       // Clamp between 25 and 90 minutes
//       optimalBlockMinutes = optimalBlockMinutes.clamp(25, 90);
//     } else if (completionRate < 0.5) {
//       // If low completion rate, try shorter blocks
//       optimalBlockMinutes = 40;
//     }

//     // Analyze energy patterns
//     final energyPatterns = await _analyzeEnergyPatterns(session, studentProfileId, logs);

//     // Generate adaptation notes
//     final notes = _generateAdaptationNotes(
//       days,
//       completionRate,
//       avgActualDuration,
//       optimalBlockMinutes,
//       missedTimeSlots,
//       energyPatterns,
//     );

//     return {
//       'completionRate': completionRate,
//       'optimalBlockMinutes': optimalBlockMinutes,
//       'missedTimeSlots': missedTimeSlots,
//       'avgActualDuration': avgActualDuration,
//       'energyPatterns': energyPatterns,
//       'adaptationNotes': notes,
//       'totalLogs': total,
//       'completedLogs': completed,
//     };
//   }

//   /// Analyze energy level patterns throughout the day
//   static Future<Map<String, double>> _analyzeEnergyPatterns(
//     Session session,
//     int studentProfileId,
//     List<BehaviorLog> logs,
//   ) async {
//     final energyByHour = <int, List<int>>{};

//     for (final log in logs) {
//       if (log.energyLevel != null) {
//         final hour = log.timestamp.hour;
//         if (!energyByHour.containsKey(hour)) {
//           energyByHour[hour] = [];
//         }
//         energyByHour[hour]!.add(log.energyLevel!);
//       }
//     }

//     // Calculate average energy for each hour
//     final patterns = <String, double>{};
//     energyByHour.forEach((hour, levels) {
//       if (levels.isNotEmpty) {
//         final avg = levels.reduce((a, b) => a + b) / levels.length;
//         patterns['${hour.toString().padLeft(2, '0')}:00'] = avg;
//       }
//     });

//     return patterns;
//   }

//   /// Generate human-readable adaptation notes
//   static String _generateAdaptationNotes(
//     int days,
//     double completionRate,
//     double avgActualDuration,
//     int optimalBlockMinutes,
//     Map<String, int> missedTimeSlots,
//     Map<String, double> energyPatterns,
//   ) {
//     final notes = StringBuffer();
//     notes.writeln('Behavioral Analysis (last $days days):');
//     notes.writeln('');

//     // Completion rate feedback
//     final completionPercent = (completionRate * 100).toStringAsFixed(1);
//     notes.writeln('📊 Completion rate: $completionPercent%');
    
//     if (completionRate >= 0.8) {
//       notes.writeln('   Great job! You\'re very consistent.');
//     } else if (completionRate >= 0.6) {
//       notes.writeln('   Good progress. Let\'s aim for 80%+');
//     } else if (completionRate >= 0.4) {
//       notes.writeln('   Room for improvement. Consider shorter blocks.');
//     } else {
//       notes.writeln('   Let\'s adjust your schedule to be more realistic.');
//     }
//     notes.writeln('');

//     // Block duration adjustment
//     if (avgActualDuration > 0) {
//       notes.writeln('⏱️  Average session: ${avgActualDuration.toStringAsFixed(0)} minutes');
//       notes.writeln('   Adjusted block length to $optimalBlockMinutes minutes');
//       notes.writeln('');
//     }

//     // Missed time slots
//     if (missedTimeSlots.isNotEmpty) {
//       final worstSlot = missedTimeSlots.entries
//           .reduce((a, b) => a.value > b.value ? a : b);
//       notes.writeln('⚠️  Frequently missed: ${worstSlot.key} (${worstSlot.value} times)');
//       notes.writeln('   I\'ll avoid scheduling during this time.');
//       notes.writeln('');
//     }

//     // Energy patterns
//     if (energyPatterns.isNotEmpty) {
//       final bestTime = energyPatterns.entries
//           .reduce((a, b) => a.value > b.value ? a : b);
//       notes.writeln('⚡ Peak energy: ${bestTime.key} (${bestTime.value.toStringAsFixed(1)}/5)');
//       notes.writeln('   Scheduling important tasks during this window.');
//       notes.writeln('');
//     }

//     return notes.toString().trim();
//   }

//   /// Get time slot label (morning, afternoon, evening, night)
//   static String _getTimeSlotLabel(int hour) {
//     if (hour >= 5 && hour < 12) return 'Morning ($hour:00)';
//     if (hour >= 12 && hour < 17) return 'Afternoon ($hour:00)';
//     if (hour >= 17 && hour < 21) return 'Evening ($hour:00)';
//     return 'Night ($hour:00)';
//   }

//   /// Check if student is at risk of burnout
//   static Future<bool> detectBurnoutRisk(
//     Session session,
//     int studentProfileId,
//   ) async {
//     final analysis = await analyzeRecentBehavior(
//       session,
//       studentProfileId,
//       days: 7,
//     );
    
//     final completionRate = analysis['completionRate'] as double;
    
//     // Burnout indicators:
//     // - Very low completion rate (< 30%)
//     // - Many missed sessions
//     // - Consistent low energy
    
//     if (completionRate < 0.3) {
//       return true;
//     }

//     // Check for consistent low energy
//     final energyPatterns = analysis['energyPatterns'] as Map<String, double>;
//     if (energyPatterns.isNotEmpty) {
//       final avgEnergy = energyPatterns.values.reduce((a, b) => a + b) / energyPatterns.length;
//       if (avgEnergy < 2.5) {
//         return true;
//       }
//     }

//     return false;
//   }

//   /// Get personalized recommendations based on behavior
//   static Future<List<String>> getRecommendations(
//     Session session,
//     int studentProfileId,
//   ) async {
//     final recommendations = <String>[];
    
//     final analysis = await analyzeRecentBehavior(session, studentProfileId);
//     final completionRate = analysis['completionRate'] as double;
//     final missedTimeSlots = analysis['missedTimeSlots'] as Map<String, int>;
//     final energyPatterns = analysis['energyPatterns'] as Map<String, double>;

//     // Low completion rate
//     if (completionRate < 0.5) {
//       recommendations.add('Try shorter study sessions (25-30 minutes)');
//       recommendations.add('Set more realistic daily goals');
//     }

//     // Frequently missed time slots
//     if (missedTimeSlots.isNotEmpty) {
//       final worstSlot = missedTimeSlots.entries
//           .reduce((a, b) => a.value > b.value ? a : b);
//       recommendations.add('Avoid scheduling tasks during ${worstSlot.key}');
//     }

//     // Energy patterns
//     if (energyPatterns.isNotEmpty) {
//       final bestTime = energyPatterns.entries
//           .reduce((a, b) => a.value > b.value ? a : b);
//       recommendations.add('Schedule difficult tasks around ${bestTime.key}');
      
//       final worstTime = energyPatterns.entries
//           .reduce((a, b) => a.value < b.value ? a : b);
//       if (worstTime.value < 3.0) {
//         recommendations.add('Take breaks or light tasks around ${worstTime.key}');
//       }
//     }

//     // Burnout check
//     final burnoutRisk = await detectBurnoutRisk(session, studentProfileId);
//     if (burnoutRisk) {
//       recommendations.add('⚠️ You may be overworking. Consider reducing your schedule.');
//       recommendations.add('Take more breaks and prioritize self-care');
//     }

//     // Good performance
//     if (completionRate >= 0.8) {
//       recommendations.add('🎉 Excellent consistency! You might be ready for more challenging goals.');
//     }

//     return recommendations;
//   }

//   /// Get best time slots for scheduling based on historical performance
//   static Future<List<String>> getBestTimeSlots(
//     Session session,
//     int studentProfileId,
//   ) async {
//     final analysis = await analyzeRecentBehavior(session, studentProfileId);
//     final energyPatterns = analysis['energyPatterns'] as Map<String, double>;
//     final missedTimeSlots = analysis['missedTimeSlots'] as Map<String, int>;

//     if (energyPatterns.isEmpty) {
//       // Default recommendations
//       return ['09:00', '10:00', '14:00', '15:00', '16:00'];
//     }

//     // Filter out frequently missed time slots
//     final goodSlots = energyPatterns.entries.where((entry) {
//       // Extract hour from "HH:00" format
//       final hour = int.parse(entry.key.split(':')[0]);
//       final slotLabel = _getTimeSlotLabel(hour);
      
//       // Check if this slot is frequently missed
//       final missCount = missedTimeSlots[slotLabel] ?? 0;
      
//       // Good energy (>3.5) and not frequently missed (<3 times)
//       return entry.value > 3.5 && missCount < 3;
//     }).toList();

//     // Sort by energy level
//     goodSlots.sort((a, b) => b.value.compareTo(a.value));

//     // Return top 5 time slots
//     return goodSlots.take(5).map((e) => e.key).toList();
//   }

//   /// Calculate productivity score (0-100)
//   static Future<int> calculateProductivityScore(
//     Session session,
//     int studentProfileId,
//   ) async {
//     final analysis = await analyzeRecentBehavior(session, studentProfileId, days: 7);
    
//     final completionRate = analysis['completionRate'] as double;
//     final energyPatterns = analysis['energyPatterns'] as Map<String, double>;
    
//     // Base score from completion rate (0-70 points)
//     int score = (completionRate * 70).round();
    
//     // Bonus for high energy levels (0-20 points)
//     if (energyPatterns.isNotEmpty) {
//       final avgEnergy = energyPatterns.values.reduce((a, b) => a + b) / energyPatterns.length;
//       score += (avgEnergy / 5 * 20).round();
//     }
    
//     // Bonus for consistency (0-10 points)
//     final totalLogs = analysis['totalLogs'] as int;
//     if (totalLogs >= 20) {
//       score += 10; // Consistent tracking
//     } else if (totalLogs >= 10) {
//       score += 5;
//     }
    
//     return score.clamp(0, 100);
//   }
// }











import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Service for analyzing behavior and adapting plans
/// This is the KEY DIFFERENTIATOR - learns from what students actually do
class AdaptationService {
  /// Analyze recent behavior patterns (last N days)
  /// Returns insights for plan generation
  static Future<Map<String, dynamic>> analyzeRecentBehavior(
    Session session,
    int studentProfileId, {
    int days = 14,
  }) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));

    // Get all behavior logs from last N days
    final logs = await BehaviorLog.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          (t.timestamp > cutoffDate),
      orderBy: (t) => t.timestamp,
    );

    if (logs.isEmpty) {
      return {
        'completionRate': 0.0,
        'optimalBlockMinutes': 50,
        'adaptationNotes': 'No behavioral data yet. Using default settings.',
        'missedTimeSlots': <String, int>{},
        'avgActualDuration': 0.0,
      };
    }

    // Calculate completion rate
    final completed = logs.where((l) => l.action == 'completed').length;
    final total = logs.length;
    final completionRate = total > 0 ? completed / total : 0.0;

    // Find frequently missed time slots
    final missedLogs = logs.where((l) => l.action == 'missed').toList();
    final missedTimeSlots = <String, int>{};

    for (final log in missedLogs) {
      final timeBlock = await TimeBlock.db.findById(session, log.timeBlockId);
      if (timeBlock != null) {
        final hour = timeBlock.startTime.hour;
        final timeSlot = _getTimeSlotLabel(hour);
        missedTimeSlots[timeSlot] = (missedTimeSlots[timeSlot] ?? 0) + 1;
      }
    }

    // Calculate average actual duration for completed tasks
    final completedLogs = logs.where((l) => 
      l.action == 'completed' && l.actualDuration != null
    ).toList();

    double avgActualDuration = 0;
    if (completedLogs.isNotEmpty) {
      final totalDuration = completedLogs
          .map((l) => l.actualDuration!)
          .reduce((a, b) => a + b);
      avgActualDuration = totalDuration / completedLogs.length;
    }

    // Determine optimal block length based on actual completion patterns
    int optimalBlockMinutes = 50; // default
    
    if (completedLogs.isNotEmpty && avgActualDuration > 0) {
      // Round to nearest 5 minutes
      optimalBlockMinutes = ((avgActualDuration / 5).round() * 5).toInt();
      // Clamp between 25 and 90 minutes
      optimalBlockMinutes = optimalBlockMinutes.clamp(25, 90);
    } else if (completionRate < 0.5) {
      // If low completion rate, try shorter blocks
      optimalBlockMinutes = 40;
    }

    // Analyze energy patterns
    final energyPatterns = await _analyzeEnergyPatterns(session, studentProfileId, logs);

    // Generate adaptation notes
    final notes = _generateAdaptationNotes(
      days,
      completionRate,
      avgActualDuration,
      optimalBlockMinutes,
      missedTimeSlots,
      energyPatterns,
    );

    return {
      'completionRate': completionRate,
      'optimalBlockMinutes': optimalBlockMinutes,
      'missedTimeSlots': missedTimeSlots,
      'avgActualDuration': avgActualDuration,
      'energyPatterns': energyPatterns,
      'adaptationNotes': notes,
      'totalLogs': total,
      'completedLogs': completed,
    };
  }

  /// Reschedule missed sessions to future time slots
  /// This is called when a session is marked as missed
  static Future<void> rescheduleMissedSession(
    Session session,
    int timeBlockId,
    int studentProfileId,
  ) async {
    try {
      // Get the missed time block
      final missedBlock = await TimeBlock.db.findById(session, timeBlockId);
      if (missedBlock == null) {
        session.log('Time block not found: $timeBlockId', level: LogLevel.error);
        return;
      }

      // Get the learning goal associated with this block
      if (missedBlock.learningGoalId == null) {
        session.log('No learning goal associated with missed block', level: LogLevel.warning);
        return;
      }

      final goal = await LearningGoal.db.findById(session, missedBlock.learningGoalId!);
      if (goal == null) {
        session.log('Learning goal not found', level: LogLevel.error);
        return;
      }

      session.log('Rescheduling missed session for goal: ${goal.title}');

      // Find the next available slot in the future (starting from tomorrow)
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final rescheduleDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
      
      // Try to reschedule in the next 7 days
      bool rescheduled = false;
      for (int i = 0; i < 7; i++) {
        final targetDate = rescheduleDate.add(Duration(days: i));
        
        // Get or create daily plan for this date
        DailyPlan? dailyPlan = await DailyPlan.db.findFirstRow(
          session,
          where: (t) =>
              t.studentProfileId.equals(studentProfileId) &
              t.planDate.equals(targetDate),
        );

        // If no plan exists, we'll create blocks in available slots
        if (dailyPlan == null) {
          session.log('No plan exists for $targetDate, will need to create one');
          continue;
        }

        // Find available time slots
        final availableSlots = await _findAvailableSlots(
          session,
          studentProfileId,
          dailyPlan.id!,
          targetDate,
          missedBlock.durationMinutes,
        );

        if (availableSlots.isNotEmpty) {
          // Use the first available slot
          final slot = availableSlots.first;
          
          // Create new time block for the rescheduled session
          final rescheduledBlock = TimeBlock(
            dailyPlanId: dailyPlan.id!,
            learningGoalId: goal.id,
            title: '${goal.title} (Rescheduled)',
            description: 'Rescheduled from ${missedBlock.startTime.toString().split(' ')[0]}',
            blockType: 'study',
            startTime: slot['start'] as DateTime,
            endTime: slot['end'] as DateTime,
            durationMinutes: missedBlock.durationMinutes,
          );

          await TimeBlock.db.insertRow(session, rescheduledBlock);
          
          // Update daily plan total minutes
          dailyPlan.totalPlannedMinutes = (dailyPlan.totalPlannedMinutes ?? 0) + missedBlock.durationMinutes;
          await DailyPlan.db.updateRow(session, dailyPlan);

          session.log('Successfully rescheduled to ${slot['start']}');
          rescheduled = true;
          break;
        }
      }

      if (!rescheduled) {
        session.log('Could not find available slot in next 7 days', level: LogLevel.warning);
        // Optionally: create a notification or suggestion for the user
      }

    } catch (e, stack) {
      session.log('Error rescheduling missed session: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
    }
  }

  /// Find available time slots in a day
  static Future<List<Map<String, DateTime>>> _findAvailableSlots(
    Session session,
    int studentProfileId,
    int dailyPlanId,
    DateTime date,
    int requiredDurationMinutes,
  ) async {
    final availableSlots = <Map<String, DateTime>>[];

    try {
      // Get student profile for wake/sleep times
      final profile = await StudentProfile.db.findById(session, studentProfileId);
      if (profile == null) return availableSlots;

      // Parse wake and sleep times
      final wakeParts = profile.wakeTime.split(':');
      final sleepParts = profile.sleepTime.split(':');

      final dayStart = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(wakeParts[0]),
        int.parse(wakeParts[1]),
      );

      final dayEnd = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(sleepParts[0]),
        int.parse(sleepParts[1]),
      );

      // Get all existing blocks for this day
      final existingBlocks = await TimeBlock.db.find(
        session,
        where: (t) => t.dailyPlanId.equals(dailyPlanId),
        orderBy: (t) => t.startTime,
      );

      // Find gaps between blocks
      var currentTime = dayStart;

      for (final block in existingBlocks) {
        final gapDuration = block.startTime.difference(currentTime).inMinutes;
        
        if (gapDuration >= requiredDurationMinutes) {
          availableSlots.add({
            'start': currentTime,
            'end': currentTime.add(Duration(minutes: requiredDurationMinutes)),
          });
        }

        currentTime = block.endTime;
      }

      // Check time after last block
      final finalGapDuration = dayEnd.difference(currentTime).inMinutes;
      if (finalGapDuration >= requiredDurationMinutes) {
        availableSlots.add({
          'start': currentTime,
          'end': currentTime.add(Duration(minutes: requiredDurationMinutes)),
        });
      }

    } catch (e) {
      session.log('Error finding available slots: $e', level: LogLevel.error);
    }

    return availableSlots;
  }

  /// Automatically reschedule the entire timetable when a session is missed
  /// This regenerates future plans taking into account the missed session
  static Future<void> rescheduleFullTimetable(
    Session session,
    int studentProfileId,
    int missedTimeBlockId,
  ) async {
    try {
      session.log('Starting full timetable reschedule for missed session: $missedTimeBlockId');

      // First, reschedule the specific missed session
      await rescheduleMissedSession(session, missedTimeBlockId, studentProfileId);

      // Get all future daily plans (from tomorrow onwards)
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final normalizedTomorrow = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
      
      final futurePlans = await DailyPlan.db.find(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.planDate.greaterOrEquals(normalizedTomorrow),
        orderBy: (t) => t.planDate,
      );

      session.log('Found ${futurePlans.length} future plans to potentially adjust');

      // Check if any adjustments are needed based on completion rates
      final recentBehavior = await analyzeRecentBehavior(session, studentProfileId, days: 7);
      final completionRate = recentBehavior['completionRate'] as double;

      // If completion rate is low, suggest regenerating plans with shorter blocks
      if (completionRate < 0.6 && futurePlans.length > 0) {
        session.log('Low completion rate detected ($completionRate). Suggesting plan adjustment.');
        
        // This could trigger a notification to the user suggesting they regenerate their plans
        // with adjusted settings
      }

    } catch (e, stack) {
      session.log('Error in full timetable reschedule: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
    }
  }

  /// Analyze energy level patterns throughout the day
  static Future<Map<String, double>> _analyzeEnergyPatterns(
    Session session,
    int studentProfileId,
    List<BehaviorLog> logs,
  ) async {
    final energyByHour = <int, List<int>>{};

    for (final log in logs) {
      if (log.energyLevel != null) {
        final hour = log.timestamp.hour;
        if (!energyByHour.containsKey(hour)) {
          energyByHour[hour] = [];
        }
        energyByHour[hour]!.add(log.energyLevel!);
      }
    }

    // Calculate average energy for each hour
    final patterns = <String, double>{};
    energyByHour.forEach((hour, levels) {
      if (levels.isNotEmpty) {
        final avg = levels.reduce((a, b) => a + b) / levels.length;
        patterns['${hour.toString().padLeft(2, '0')}:00'] = avg;
      }
    });

    return patterns;
  }

  /// Generate human-readable adaptation notes
  static String _generateAdaptationNotes(
    int days,
    double completionRate,
    double avgActualDuration,
    int optimalBlockMinutes,
    Map<String, int> missedTimeSlots,
    Map<String, double> energyPatterns,
  ) {
    final notes = StringBuffer();
    notes.writeln('Behavioral Analysis (last $days days):');
    notes.writeln('');

    // Completion rate feedback
    final completionPercent = (completionRate * 100).toStringAsFixed(1);
    notes.writeln('📊 Completion rate: $completionPercent%');
    
    if (completionRate >= 0.8) {
      notes.writeln('   Great job! You\'re very consistent.');
    } else if (completionRate >= 0.6) {
      notes.writeln('   Good progress. Let\'s aim for 80%+');
    } else if (completionRate >= 0.4) {
      notes.writeln('   Room for improvement. Consider shorter blocks.');
    } else {
      notes.writeln('   Let\'s adjust your schedule to be more realistic.');
    }
    notes.writeln('');

    // Block duration adjustment
    if (avgActualDuration > 0) {
      notes.writeln('⏱️  Average session: ${avgActualDuration.toStringAsFixed(0)} minutes');
      notes.writeln('   Adjusted block length to $optimalBlockMinutes minutes');
      notes.writeln('');
    }

    // Missed time slots
    if (missedTimeSlots.isNotEmpty) {
      final worstSlot = missedTimeSlots.entries
          .reduce((a, b) => a.value > b.value ? a : b);
      notes.writeln('⚠️  Frequently missed: ${worstSlot.key} (${worstSlot.value} times)');
      notes.writeln('   I\'ll avoid scheduling during this time.');
      notes.writeln('');
    }

    // Energy patterns
    if (energyPatterns.isNotEmpty) {
      final bestTime = energyPatterns.entries
          .reduce((a, b) => a.value > b.value ? a : b);
      notes.writeln('⚡ Peak energy: ${bestTime.key} (${bestTime.value.toStringAsFixed(1)}/5)');
      notes.writeln('   Scheduling important tasks during this window.');
      notes.writeln('');
    }

    return notes.toString().trim();
  }

  /// Get time slot label (morning, afternoon, evening, night)
  static String _getTimeSlotLabel(int hour) {
    if (hour >= 5 && hour < 12) return 'Morning ($hour:00)';
    if (hour >= 12 && hour < 17) return 'Afternoon ($hour:00)';
    if (hour >= 17 && hour < 21) return 'Evening ($hour:00)';
    return 'Night ($hour:00)';
  }

  /// Check if student is at risk of burnout
  static Future<bool> detectBurnoutRisk(
    Session session,
    int studentProfileId,
  ) async {
    final analysis = await analyzeRecentBehavior(
      session,
      studentProfileId,
      days: 7,
    );
    
    final completionRate = analysis['completionRate'] as double;
    
    // Burnout indicators:
    // - Very low completion rate (< 30%)
    // - Many missed sessions
    // - Consistent low energy
    
    if (completionRate < 0.3) {
      return true;
    }

    // Check for consistent low energy
    final energyPatterns = analysis['energyPatterns'] as Map<String, double>;
    if (energyPatterns.isNotEmpty) {
      final avgEnergy = energyPatterns.values.reduce((a, b) => a + b) / energyPatterns.length;
      if (avgEnergy < 2.5) {
        return true;
      }
    }

    return false;
  }

  /// Get personalized recommendations based on behavior
  static Future<List<String>> getRecommendations(
    Session session,
    int studentProfileId,
  ) async {
    final recommendations = <String>[];
    
    final analysis = await analyzeRecentBehavior(session, studentProfileId);
    final completionRate = analysis['completionRate'] as double;
    final missedTimeSlots = analysis['missedTimeSlots'] as Map<String, int>;
    final energyPatterns = analysis['energyPatterns'] as Map<String, double>;

    // Low completion rate
    if (completionRate < 0.5) {
      recommendations.add('Try shorter study sessions (25-30 minutes)');
      recommendations.add('Set more realistic daily goals');
    }

    // Frequently missed time slots
    if (missedTimeSlots.isNotEmpty) {
      final worstSlot = missedTimeSlots.entries
          .reduce((a, b) => a.value > b.value ? a : b);
      recommendations.add('Avoid scheduling tasks during ${worstSlot.key}');
    }

    // Energy patterns
    if (energyPatterns.isNotEmpty) {
      final bestTime = energyPatterns.entries
          .reduce((a, b) => a.value > b.value ? a : b);
      recommendations.add('Schedule difficult tasks around ${bestTime.key}');
      
      final worstTime = energyPatterns.entries
          .reduce((a, b) => a.value < b.value ? a : b);
      if (worstTime.value < 3.0) {
        recommendations.add('Take breaks or light tasks around ${worstTime.key}');
      }
    }

    // Burnout check
    final burnoutRisk = await detectBurnoutRisk(session, studentProfileId);
    if (burnoutRisk) {
      recommendations.add('⚠️ You may be overworking. Consider reducing your schedule.');
      recommendations.add('Take more breaks and prioritize self-care');
    }

    // Good performance
    if (completionRate >= 0.8) {
      recommendations.add('🎉 Excellent consistency! You might be ready for more challenging goals.');
    }

    return recommendations;
  }

  /// Get best time slots for scheduling based on historical performance
  static Future<List<String>> getBestTimeSlots(
    Session session,
    int studentProfileId,
  ) async {
    final analysis = await analyzeRecentBehavior(session, studentProfileId);
    final energyPatterns = analysis['energyPatterns'] as Map<String, double>;
    final missedTimeSlots = analysis['missedTimeSlots'] as Map<String, int>;

    if (energyPatterns.isEmpty) {
      // Default recommendations
      return ['09:00', '10:00', '14:00', '15:00', '16:00'];
    }

    // Filter out frequently missed time slots
    final goodSlots = energyPatterns.entries.where((entry) {
      // Extract hour from "HH:00" format
      final hour = int.parse(entry.key.split(':')[0]);
      final slotLabel = _getTimeSlotLabel(hour);
      
      // Check if this slot is frequently missed
      final missCount = missedTimeSlots[slotLabel] ?? 0;
      
      // Good energy (>3.5) and not frequently missed (<3 times)
      return entry.value > 3.5 && missCount < 3;
    }).toList();

    // Sort by energy level
    goodSlots.sort((a, b) => b.value.compareTo(a.value));

    // Return top 5 time slots
    return goodSlots.take(5).map((e) => e.key).toList();
  }

  /// Calculate productivity score (0-100)
  static Future<int> calculateProductivityScore(
    Session session,
    int studentProfileId,
  ) async {
    final analysis = await analyzeRecentBehavior(session, studentProfileId, days: 7);
    
    final completionRate = analysis['completionRate'] as double;
    final energyPatterns = analysis['energyPatterns'] as Map<String, double>;
    
    // Base score from completion rate (0-70 points)
    int score = (completionRate * 70).round();
    
    // Bonus for high energy levels (0-20 points)
    if (energyPatterns.isNotEmpty) {
      final avgEnergy = energyPatterns.values.reduce((a, b) => a + b) / energyPatterns.length;
      score += (avgEnergy / 5 * 20).round();
    }
    
    // Bonus for consistency (0-10 points)
    final totalLogs = analysis['totalLogs'] as int;
    if (totalLogs >= 20) {
      score += 10; // Consistent tracking
    } else if (totalLogs >= 10) {
      score += 5;
    }
    
    return score.clamp(0, 100);
  }
}