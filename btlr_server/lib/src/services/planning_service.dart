// import 'package:serverpod/serverpod.dart';
// import '../generated/protocol.dart';

// /// Intelligent planning service with multi-week scheduling
// class PlanningService {
//   /// Generate daily plan for a specific date
//   static Future<DailyPlan> generateDailyPlan(
//     Session session,
//     int studentProfileId,
//     DateTime date,
//   ) async {
//     session.log('=== Starting generatePlan ===');
//     session.log('Student ID: $studentProfileId');
//     session.log('Date: ${date.toIso8601String()}');

//     final normalizedDate = DateTime(date.year, date.month, date.day);

//     // Get student profile and schedule
//     final profile = await StudentProfile.db.findById(session, studentProfileId);
//     if (profile == null) {
//       throw Exception('Student profile not found');
//     }

// // Get existing plan to increment version
// final existingPlan = await DailyPlan.db.findFirstRow(
//   session,
//   where: (t) =>
//       t.studentProfileId.equals(studentProfileId) &
//       t.planDate.equals(normalizedDate),
//   orderBy: (t) => t.version,
//   orderDescending: true,
// );

// // DELETE existing plans for this date first (to avoid duplicate key error)
// if (existingPlan != null) {
//   await DailyPlan.db.deleteWhere(
//     session,
//     where: (t) =>
//         t.studentProfileId.equals(studentProfileId) &
//         t.planDate.equals(normalizedDate),
//   );
// }

// final version = (existingPlan?.version ?? 0) + 1;


//     // Create new plan
//     final plan = DailyPlan(
//       studentProfileId: studentProfileId,
//       planDate: normalizedDate,
//       version: version,
//       totalPlannedMinutes: 0,
//       generatedAt: DateTime.now(),
//       reasoning: 'Intelligent allocation with deadline awareness',
//     );

//     final createdPlan = await DailyPlan.db.insertRow(session, plan);
//     session.log('Created new plan ${createdPlan.id} version $version for date $normalizedDate');

//     // Calculate available time slots for this day
//     final freeSlots = await _calculateFreeSlots(
//       session,
//       studentProfileId,
//       normalizedDate,
//     );

//     if (freeSlots.isEmpty) {
//       session.log('No free slots available for $normalizedDate');
//       return createdPlan;
//     }

//     // Get prioritized goals that need work
//     final goalsToSchedule = await _getPrioritizedGoals(
//       session,
//       studentProfileId,
//       normalizedDate,
//     );

//     // Allocate study blocks intelligently
//     int totalMinutes = 0;
//     for (final goalInfo in goalsToSchedule) {
//       final allocated = await _allocateGoalToSlots(
//         session,
//         createdPlan.id!,
//         goalInfo,
//         freeSlots,
//         normalizedDate,
//       );
//       totalMinutes += allocated;
//     }

//     // Update plan with total minutes
//     createdPlan.totalPlannedMinutes = totalMinutes;
//     await DailyPlan.db.updateRow(session, createdPlan);

//     session.log('Generated daily plan for $normalizedDate with $totalMinutes minutes');
//     session.log('=== End generatePlan ===');
//     return createdPlan;
//   }

//   /// Generate plans for multiple days (for calendar view)
//   static Future<List<DailyPlan>> generateMultiplePlans(
//     Session session,
//     int studentProfileId,
//     int daysAhead,
//   ) async {
//     final plans = <DailyPlan>[];
//     final today = DateTime.now();

//     for (int i = 0; i < daysAhead; i++) {
//       final targetDate = today.add(Duration(days: i));
//       try {
//         final plan = await generateDailyPlan(session, studentProfileId, targetDate);
//         plans.add(plan);
//       } catch (e) {
//         session.log('Error generating plan for day $i: $e', level: LogLevel.warning);
//       }
//     }

//     return plans;
//   }

//   /// Calculate free time slots for a day (avoiding classes/fixed commitments)
//   static Future<List<Map<String, DateTime>>> _calculateFreeSlots(
//     Session session,
//     int studentProfileId,
//     DateTime date,
//   ) async {
//     final profile = await StudentProfile.db.findById(session, studentProfileId);
//     if (profile == null) return [];

//     // Get student's academic schedule for this day
//     final scheduleItems = await AcademicSchedule.db.find(
//       session,
//       where: (t) => t.studentProfileId.equals(studentProfileId),
//     );

//     // Expand recurring schedules for this specific date
//     final busySlots = <Map<String, DateTime>>[];
//     for (final item in scheduleItems) {
//       final occurrences = _expandRecurringSchedule(
//         item,
//         date,
//         date.add(const Duration(days: 1)),
//       );
//       busySlots.addAll(occurrences);
//     }

//     // Define study day boundaries (default: 7 AM to 11 PM)
//     final dayStart = DateTime(date.year, date.month, date.day, 7, 0);
//     final dayEnd = DateTime(date.year, date.month, date.day, 23, 0);

//     session.log('Day boundaries: $dayStart to $dayEnd');

//     // Sort busy slots
//     busySlots.sort((a, b) => a['start']!.compareTo(b['start']!));

//     // Find gaps between busy slots
//     final freeSlots = <Map<String, DateTime>>[];
//     var currentTime = dayStart;

//     for (final busy in busySlots) {
//       if (currentTime.isBefore(busy['start']!)) {
//         final gapMinutes = busy['start']!.difference(currentTime).inMinutes;
//         if (gapMinutes >= 25) { // Minimum 25-minute slot
//           freeSlots.add({'start': currentTime, 'end': busy['start']!});
//           session.log('Gap ${freeSlots.length - 1}: $currentTime to ${busy['start']!} = ${gapMinutes}min');
//         }
//       }
//       currentTime = busy['end']!.isAfter(currentTime) ? busy['end']! : currentTime;
//     }

//     // Add final gap till day end
//     if (currentTime.isBefore(dayEnd)) {
//       final gapMinutes = dayEnd.difference(currentTime).inMinutes;
//       if (gapMinutes >= 25) {
//         freeSlots.add({'start': currentTime, 'end': dayEnd});
//         session.log('Gap ${freeSlots.length - 1}: $currentTime to $dayEnd = ${gapMinutes}min');
//       }
//     }

//     session.log('Found ${freeSlots.length} free slots');
//     return freeSlots;
//   }

//   /// Get goals prioritized by urgency and importance
//   static Future<List<Map<String, dynamic>>> _getPrioritizedGoals(
//     Session session,
//     int studentProfileId,
//     DateTime targetDate,
//   ) async {
//     final goals = await LearningGoal.db.find(
//       session,
//       where: (t) =>
//           t.studentProfileId.equals(studentProfileId) &
//           (t.status.equals('not_started') | t.status.equals('in_progress')),
//     );

//     final goalInfoList = <Map<String, dynamic>>[];

//     for (final goal in goals) {
//       // Handle null estimatedHours
//       final estimatedHours = goal.estimatedHours ?? 0.0;
//       if (estimatedHours <= 0) continue; // Skip goals without time estimate

//       // Calculate remaining work
//       final estimatedMinutes = estimatedHours * 60;
//       final completedMinutes = (goal.actualHours ?? 0.0) * 60;
//       final remainingMinutes = estimatedMinutes - completedMinutes;

//       if (remainingMinutes <= 0) continue; // Goal already complete

//       // Calculate urgency score
//       final daysUntilDeadline = goal.deadline?.difference(targetDate).inDays ?? 9999;
//       final urgencyScore = remainingMinutes / (daysUntilDeadline + 1); // Higher = more urgent

//       goalInfoList.add({
//         'goal': goal,
//         'remainingMinutes': remainingMinutes,
//         'daysUntilDeadline': daysUntilDeadline,
//         'urgencyScore': urgencyScore,
//         'priority': goal.priority ?? 'medium',
//       });
//     }

//     // Sort by urgency score (highest first)
//     goalInfoList.sort((a, b) => (b['urgencyScore'] as double).compareTo(a['urgencyScore'] as double));

//     session.log('Prioritized ${goalInfoList.length} goals for scheduling');
//     return goalInfoList;
//   }

//   /// Allocate a goal to available time slots using Pomodoro technique
//   static Future<int> _allocateGoalToSlots(
//     Session session,
//     int dailyPlanId,
//     Map<String, dynamic> goalInfo,
//     List<Map<String, DateTime>> freeSlots,
//     DateTime date,
//   ) async {
//     final goal = goalInfo['goal'] as LearningGoal;
//     final remainingMinutes = (goalInfo['remainingMinutes'] as double).toInt();
    
//     // Don't over-allocate - max 2 hours per goal per day
//     final maxDailyMinutes = remainingMinutes > 120 ? 120 : remainingMinutes;
    
//     int allocated = 0;
//     const sessionDuration = 50; // Pomodoro session
//     const breakDuration = 10;   // Short break

//     for (final slot in freeSlots) {
//       if (allocated >= maxDailyMinutes) break;

//       final slotDuration = slot['end']!.difference(slot['start']!).inMinutes;
//       if (slotDuration < sessionDuration) continue; // Slot too small

//       // How many sessions can fit in this slot?
//       final sessionsInSlot = (slotDuration / (sessionDuration + breakDuration)).floor();
//       if (sessionsInSlot == 0) continue;

//       var currentTime = slot['start']!;

//       for (int i = 0; i < sessionsInSlot && allocated < maxDailyMinutes; i++) {
//         // Create study block
//         final studyBlock = TimeBlock(
//           dailyPlanId: dailyPlanId,
//           learningGoalId: goal.id,
//           title: goal.title,
//           description: 'Study session ${i + 1} for ${goal.title}',
//           blockType: 'study',
//           startTime: currentTime,
//           endTime: currentTime.add(Duration(minutes: sessionDuration)),
//           durationMinutes: sessionDuration,
//           completionStatus: 'pending',
//           isCompleted: false,
//         );

//         await TimeBlock.db.insertRow(session, studyBlock);
//         allocated += sessionDuration;
//         currentTime = currentTime.add(Duration(minutes: sessionDuration));

//         // Add break if not last session in slot
//         if (i < sessionsInSlot - 1 && currentTime.add(Duration(minutes: breakDuration)).isBefore(slot['end']!)) {
//           final breakBlock = TimeBlock(
//             dailyPlanId: dailyPlanId,
//             title: 'Break',
//             description: 'Short break after study session',
//             blockType: 'break',
//             startTime: currentTime,
//             endTime: currentTime.add(Duration(minutes: breakDuration)),
//             durationMinutes: breakDuration,
//             completionStatus: 'pending',
//             isCompleted: false,
//           );

//           await TimeBlock.db.insertRow(session, breakBlock);
//           currentTime = currentTime.add(Duration(minutes: breakDuration));
//         }
//       }
//     }

//     session.log('Allocated ${allocated}min for goal "${goal.title}" (needs $remainingMinutes total)');
//     return allocated;
//   }

//   /// Expand recurring schedule to specific date range
//   static List<Map<String, DateTime>> _expandRecurringSchedule(
//     AcademicSchedule schedule,
//     DateTime rangeStart,
//     DateTime rangeEnd,
//   ) {
//     final occurrences = <Map<String, DateTime>>[];
    
//     // Check if it's a single event (no recurrence)
//     // Since recurrenceRule doesn't exist, we'll just add the event if within range
//     if (schedule.startTime.isBefore(rangeEnd) && schedule.endTime.isAfter(rangeStart)) {
//       occurrences.add({'start': schedule.startTime, 'end': schedule.endTime});
//     }

//     return occurrences;
//   }
// }



























import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Intelligent planning service with multi-week scheduling
class PlanningService {
  /// Generate daily plan for a specific date
  static Future<DailyPlan> generateDailyPlan(
    Session session,
    int studentProfileId,
    DateTime date,
  ) async {
    session.log('=== Starting generatePlan ===');
    session.log('Student ID: $studentProfileId');
    session.log('Date: ${date.toIso8601String()}');

    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Get student profile and schedule
    final profile = await StudentProfile.db.findById(session, studentProfileId);
    if (profile == null) {
      throw Exception('Student profile not found');
    }

    // Get existing plan to increment version
    final existingPlan = await DailyPlan.db.findFirstRow(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.planDate.equals(normalizedDate),
      orderBy: (t) => t.version,
      orderDescending: true,
    );

    // DELETE existing plans for this date first (to avoid duplicate key error)
    if (existingPlan != null) {
      await DailyPlan.db.deleteWhere(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.planDate.equals(normalizedDate),
      );
    }

    final version = (existingPlan?.version ?? 0) + 1;

    // Create new plan
    final plan = DailyPlan(
      studentProfileId: studentProfileId,
      planDate: normalizedDate,
      version: version,
      totalPlannedMinutes: 0,
      generatedAt: DateTime.now(),
      reasoning: 'Intelligent allocation with deadline awareness',
    );

    final createdPlan = await DailyPlan.db.insertRow(session, plan);
    session.log('Created new plan ${createdPlan.id} version $version for date $normalizedDate');

    // Calculate available time slots for this day
    final freeSlots = await _calculateFreeSlots(
      session,
      studentProfileId,
      normalizedDate,
    );

    if (freeSlots.isEmpty) {
      session.log('No free slots available for $normalizedDate');
      return createdPlan;
    }

    // Get prioritized goals that need work
    final goalsToSchedule = await _getPrioritizedGoals(
      session,
      studentProfileId,
      normalizedDate,
    );

    // Allocate study blocks intelligently with overlap prevention
    int totalMinutes = 0;
    final consumedSlots = <Map<String, dynamic>>[]; // Track consumed portions

    for (final goalInfo in goalsToSchedule) {
      final allocated = await _allocateGoalToSlots(
        session,
        createdPlan.id!,
        goalInfo,
        freeSlots,
        consumedSlots,
        normalizedDate,
      );
      totalMinutes += allocated;
    }

    // Update plan with total minutes
    createdPlan.totalPlannedMinutes = totalMinutes;
    await DailyPlan.db.updateRow(session, createdPlan);

    session.log('Generated daily plan for $normalizedDate with $totalMinutes minutes');
    session.log('=== End generatePlan ===');
    return createdPlan;
  }

  /// Generate plans for multiple days (for calendar view)
  static Future<List<DailyPlan>> generateMultiplePlans(
    Session session,
    int studentProfileId,
    int daysAhead,
  ) async {
    final plans = <DailyPlan>[];
    final today = DateTime.now();

    for (int i = 0; i < daysAhead; i++) {
      final targetDate = today.add(Duration(days: i));
      try {
        final plan = await generateDailyPlan(session, studentProfileId, targetDate);
        plans.add(plan);
      } catch (e) {
        session.log('Error generating plan for day $i: $e', level: LogLevel.warning);
      }
    }

    return plans;
  }

  /// Calculate free time slots for a day (avoiding classes/fixed commitments)
  static Future<List<Map<String, DateTime>>> _calculateFreeSlots(
    Session session,
    int studentProfileId,
    DateTime date,
  ) async {
    final profile = await StudentProfile.db.findById(session, studentProfileId);
    if (profile == null) return [];

    // Get student's academic schedule for this day
    final scheduleItems = await AcademicSchedule.db.find(
      session,
      where: (t) => t.studentProfileId.equals(studentProfileId),
    );

    // Expand recurring schedules for this specific date
    final busySlots = <Map<String, DateTime>>[];
    for (final item in scheduleItems) {
      final occurrences = _expandRecurringSchedule(
        item,
        date,
        date.add(const Duration(days: 1)),
      );
      busySlots.addAll(occurrences);
    }

    // Define study day boundaries (default: 7 AM to 11 PM)
    final dayStart = DateTime(date.year, date.month, date.day, 7, 0);
    final dayEnd = DateTime(date.year, date.month, date.day, 23, 0);

    session.log('Day boundaries: $dayStart to $dayEnd');

    // Sort busy slots
    busySlots.sort((a, b) => a['start']!.compareTo(b['start']!));

    // Find gaps between busy slots
    final freeSlots = <Map<String, DateTime>>[];
    var currentTime = dayStart;

    for (final busy in busySlots) {
      if (currentTime.isBefore(busy['start']!)) {
        final gapMinutes = busy['start']!.difference(currentTime).inMinutes;
        if (gapMinutes >= 25) { // Minimum 25-minute slot
          freeSlots.add({'start': currentTime, 'end': busy['start']!});
          session.log('Gap ${freeSlots.length - 1}: $currentTime to ${busy['start']!} = ${gapMinutes}min');
        }
      }
      currentTime = busy['end']!.isAfter(currentTime) ? busy['end']! : currentTime;
    }

    // Add final gap till day end
    if (currentTime.isBefore(dayEnd)) {
      final gapMinutes = dayEnd.difference(currentTime).inMinutes;
      if (gapMinutes >= 25) {
        freeSlots.add({'start': currentTime, 'end': dayEnd});
        session.log('Gap ${freeSlots.length - 1}: $currentTime to $dayEnd = ${gapMinutes}min');
      }
    }

    session.log('Found ${freeSlots.length} free slots');
    return freeSlots;
  }

  /// Get goals prioritized by urgency and importance
  static Future<List<Map<String, dynamic>>> _getPrioritizedGoals(
    Session session,
    int studentProfileId,
    DateTime targetDate,
  ) async {
    final goals = await LearningGoal.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          (t.status.equals('not_started') | t.status.equals('in_progress')),
    );

    final goalInfoList = <Map<String, dynamic>>[];

    for (final goal in goals) {
      // Handle null estimatedHours
      final estimatedHours = goal.estimatedHours ?? 0.0;
      if (estimatedHours <= 0) continue; // Skip goals without time estimate

      // Calculate remaining work
      final estimatedMinutes = estimatedHours * 60;
      final completedMinutes = (goal.actualHours ?? 0.0) * 60;
      final remainingMinutes = estimatedMinutes - completedMinutes;

      if (remainingMinutes <= 0) continue; // Goal already complete

      // Calculate urgency score
      final daysUntilDeadline = goal.deadline?.difference(targetDate).inDays ?? 9999;
      final urgencyScore = remainingMinutes / (daysUntilDeadline + 1); // Higher = more urgent

      goalInfoList.add({
        'goal': goal,
        'remainingMinutes': remainingMinutes,
        'daysUntilDeadline': daysUntilDeadline,
        'urgencyScore': urgencyScore,
        'priority': goal.priority ?? 'medium',
      });
    }

    // Sort by urgency score (highest first)
    goalInfoList.sort((a, b) => (b['urgencyScore'] as double).compareTo(a['urgencyScore'] as double));

    session.log('Prioritized ${goalInfoList.length} goals for scheduling');
    return goalInfoList;
  }

  /// Allocate a goal to available time slots using Pomodoro technique (FIXED - NO OVERLAPS)
  static Future<int> _allocateGoalToSlots(
    Session session,
    int dailyPlanId,
    Map<String, dynamic> goalInfo,
    List<Map<String, DateTime>> freeSlots,
    List<Map<String, dynamic>> consumedSlots, // NEW PARAMETER
    DateTime date,
  ) async {
    final goal = goalInfo['goal'] as LearningGoal;
    final remainingMinutes = (goalInfo['remainingMinutes'] as double).toInt();
    
    // Don't over-allocate - max 2 hours per goal per day
    final maxDailyMinutes = remainingMinutes > 120 ? 120 : remainingMinutes;
    
    int allocated = 0;
    const sessionDuration = 50; // Pomodoro session
    const breakDuration = 10;   // Short break

    for (int slotIndex = 0; slotIndex < freeSlots.length; slotIndex++) {
      if (allocated >= maxDailyMinutes) break;

      final slot = freeSlots[slotIndex];
      var availableStart = slot['start']!;
      final slotEnd = slot['end']!;

      // Skip portions already consumed by other goals
      for (final consumed in consumedSlots) {
        if (consumed['slotIndex'] == slotIndex) {
          // Update availableStart to after consumed portion
          final consumedEnd = consumed['end'] as DateTime;
          if (consumedEnd.isAfter(availableStart) && consumedEnd.isBefore(slotEnd)) {
            availableStart = consumedEnd;
          }
        }
      }

      final availableDuration = slotEnd.difference(availableStart).inMinutes;
      if (availableDuration < sessionDuration) continue; // Not enough time left

      // How many sessions can fit in remaining available time?
      final sessionsInSlot = (availableDuration / (sessionDuration + breakDuration)).floor();
      if (sessionsInSlot == 0) continue;

      var currentTime = availableStart;
      final sessionStartTime = currentTime; // Track start for consumed slot

      for (int i = 0; i < sessionsInSlot && allocated < maxDailyMinutes; i++) {
        // Create study block
        final studyBlock = TimeBlock(
          dailyPlanId: dailyPlanId,
          learningGoalId: goal.id,
          title: goal.title,
          description: 'Study session ${i + 1} for ${goal.title}',
          blockType: 'study',
          startTime: currentTime,
          endTime: currentTime.add(Duration(minutes: sessionDuration)),
          durationMinutes: sessionDuration,
          completionStatus: 'pending',
          isCompleted: false,
        );

        await TimeBlock.db.insertRow(session, studyBlock);
        allocated += sessionDuration;
        currentTime = currentTime.add(Duration(minutes: sessionDuration));

        // Add break if not last session
        if (i < sessionsInSlot - 1 && currentTime.add(Duration(minutes: breakDuration)).isBefore(slotEnd)) {
          final breakBlock = TimeBlock(
            dailyPlanId: dailyPlanId,
            title: 'Break',
            description: 'Short break after study session',
            blockType: 'break',
            startTime: currentTime,
            endTime: currentTime.add(Duration(minutes: breakDuration)),
            durationMinutes: breakDuration,
            completionStatus: 'pending',
            isCompleted: false,
          );

          await TimeBlock.db.insertRow(session, breakBlock);
          currentTime = currentTime.add(Duration(minutes: breakDuration));
        }
      }

      // Mark this portion of the slot as consumed
      if (allocated > 0) {
        consumedSlots.add({
          'slotIndex': slotIndex,
          'start': sessionStartTime,
          'end': currentTime,
        });
      }
    }

    session.log('Allocated ${allocated}min for goal "${goal.title}" (needs $remainingMinutes total)');
    return allocated;
  }

  /// Expand recurring schedule to specific date range
  static List<Map<String, DateTime>> _expandRecurringSchedule(
    AcademicSchedule schedule,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final occurrences = <Map<String, DateTime>>[];
    
    // Check if it's a single event (no recurrence)
    if (schedule.startTime.isBefore(rangeEnd) && schedule.endTime.isAfter(rangeStart)) {
      occurrences.add({'start': schedule.startTime, 'end': schedule.endTime});
    }

    return occurrences;
  }
}
