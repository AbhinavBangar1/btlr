// import 'package:serverpod/serverpod.dart';
// import '../generated/protocol.dart';
// import 'adaptation_service.dart';

// /// Service for generating daily and weekly plans
// /// Updated to support both weekly and daily views
// class PlanningService {
//   /// Maximum study time per day (in minutes)
//   static const int maxDailyStudyMinutes = 480; // 8 hours
  
//   /// Maximum study blocks per time gap
//   static const int maxBlocksPerGap = 6;

//   /// Generates a daily plan for a specific date
//   /// This creates tasks ONLY for the specified day
//   static Future<DailyPlan> generateDailyPlan(
//     Session session,
//     int studentProfileId,
//     DateTime date, {
//     int? customStudyBlockMinutes,
//     int? customBreakMinutes,
//   }) async {
//     // Normalize date to start of day
//     final normalizedDate = DateTime(date.year, date.month, date.day);

//     // Get student profile
//     final profile = await StudentProfile.db.findById(session, studentProfileId);
//     if (profile == null) {
//       throw Exception('Student profile not found');
//     }

//     // Use custom durations if provided, otherwise use profile preferences
//     final studyBlockMinutes = customStudyBlockMinutes ?? profile.preferredStudyBlockMinutes;
//     final breakMinutes = customBreakMinutes ?? profile.preferredBreakMinutes;

//     // Get all active learning goals with deadlines
//     final goals = await LearningGoal.db.find(
//       session,
//       where: (t) =>
//           t.studentProfileId.equals(studentProfileId) &
//           (t.status.equals('in_progress') | t.status.equals('not_started')),
//       orderBy: (t) => t.priority,
//     );

//     // Filter goals relevant for this specific day
//     final relevantGoals = _filterGoalsForDate(goals, normalizedDate);

//     // Get academic schedule for this date
//     final academicEvents = await _getAcademicEventsForDate(
//       session,
//       studentProfileId,
//       normalizedDate,
//     );

//     // Get behavioral patterns from last 14 days
//     final patterns = await AdaptationService.analyzeRecentBehavior(
//       session,
//       studentProfileId,
//       days: 14,
//     );

//     // Check if plan already exists - DELETE IT FIRST if it does
//     final existingPlan = await DailyPlan.db.findFirstRow(
//       session,
//       where: (t) =>
//           t.studentProfileId.equals(studentProfileId) &
//           t.planDate.equals(normalizedDate),
//     );

//     final planVersion = (existingPlan?.version ?? 0) + 1;

//     // Delete existing plan and its blocks if regenerating
//     if (existingPlan != null) {
//       session.log('Found existing plan ${existingPlan.id}, deleting it first');

//       // Delete time blocks first (foreign key constraint)
//       await TimeBlock.db.deleteWhere(
//         session,
//         where: (t) => t.dailyPlanId.equals(existingPlan.id!),
//       );

//       // Delete the plan
//       await DailyPlan.db.deleteWhere(
//         session,
//         where: (t) => t.id.equals(existingPlan.id!),
//       );

//       session.log('Deleted old plan and blocks');
//     }

//     // Create new plan
//     final plan = DailyPlan(
//       studentProfileId: studentProfileId,
//       planDate: normalizedDate,
//       version: planVersion,
//       reasoning: _generateReasoning(profile, patterns, relevantGoals, studyBlockMinutes, breakMinutes),
//       generatedAt: DateTime.now(),
//       adaptationNotes: patterns['adaptationNotes'] as String?,
//     );

//     final savedPlan = await DailyPlan.db.insertRow(session, plan);
//     session.log('Created new plan ${savedPlan.id} version $planVersion for date $normalizedDate');

//     // Generate time blocks with custom durations
//     final timeBlocks = await _generateTimeBlocks(
//       session,
//       savedPlan.id!,
//       profile,
//       relevantGoals,
//       academicEvents,
//       patterns,
//       normalizedDate,
//       studyBlockMinutes: studyBlockMinutes,
//       breakMinutes: breakMinutes,
//     );

//     // Calculate total planned minutes
//     final totalMinutes = timeBlocks.fold<int>(
//       0,
//       (sum, block) => sum + block.durationMinutes,
//     );

//     savedPlan.totalPlannedMinutes = totalMinutes;
//     await DailyPlan.db.updateRow(session, savedPlan);

//     session.log('Generated daily plan for $normalizedDate with ${timeBlocks.length} blocks (${totalMinutes}min total)');

//     return savedPlan;
//   }

//   /// Filter goals that are relevant for a specific date based on deadline
//   static List<LearningGoal> _filterGoalsForDate(List<LearningGoal> goals, DateTime date) {
//     return goals.where((goal) {
//       // Include goals without deadlines
//       if (goal.deadline == null) return true;
      
//       // Include goals where deadline is today or in the future
//       final deadline = DateTime(goal.deadline!.year, goal.deadline!.month, goal.deadline!.day);
//       final today = DateTime(date.year, date.month, date.day);
      
//       return deadline.isAfter(today) || deadline.isAtSameMomentAs(today);
//     }).toList();
//   }

//   /// Generates weekly plan (Monday to Sunday)
//   /// Returns a map of date -> DailyPlan
//   static Future<Map<DateTime, DailyPlan>> generateWeeklyPlan(
//     Session session,
//     int studentProfileId,
//     DateTime weekStartDate, {
//     int? customStudyBlockMinutes,
//     int? customBreakMinutes,
//   }) async {
//     final weeklyPlans = <DateTime, DailyPlan>{};
    
//     // Normalize to Monday of the week
//     DateTime monday = weekStartDate;
//     while (monday.weekday != DateTime.monday) {
//       monday = monday.subtract(const Duration(days: 1));
//     }

//     session.log('Generating weekly plan starting from Monday: $monday');

//     // Generate plans for Monday through Sunday
//     for (int i = 0; i < 7; i++) {
//       final currentDate = monday.add(Duration(days: i));
      
//       try {
//         final dailyPlan = await generateDailyPlan(
//           session,
//           studentProfileId,
//           currentDate,
//           customStudyBlockMinutes: customStudyBlockMinutes,
//           customBreakMinutes: customBreakMinutes,
//         );
        
//         weeklyPlans[currentDate] = dailyPlan;
//         session.log('Generated plan for ${_getDayName(currentDate.weekday)}, ${currentDate.toString().split(' ')[0]}');
//       } catch (e) {
//         session.log('Failed to generate plan for ${currentDate}: $e', level: LogLevel.error);
//       }
//     }

//     return weeklyPlans;
//   }

//   /// Get day name from weekday number
//   static String _getDayName(int weekday) {
//     switch (weekday) {
//       case DateTime.monday: return 'Monday';
//       case DateTime.tuesday: return 'Tuesday';
//       case DateTime.wednesday: return 'Wednesday';
//       case DateTime.thursday: return 'Thursday';
//       case DateTime.friday: return 'Friday';
//       case DateTime.saturday: return 'Saturday';
//       case DateTime.sunday: return 'Sunday';
//       default: return 'Unknown';
//     }
//   }

//   /// Add a custom time block at a specific time slot
//   static Future<TimeBlock> addCustomTimeBlock(
//     Session session,
//     int dailyPlanId,
//     DateTime startTime,
//     int durationMinutes,
//     String title,
//     String description,
//     String blockType, {
//     int? learningGoalId,
//   }) async {
//     // Validate the time block doesn't overlap with existing blocks
//     final existingBlocks = await TimeBlock.db.find(
//       session,
//       where: (t) => t.dailyPlanId.equals(dailyPlanId),
//       orderBy: (t) => t.startTime,
//     );

//     final endTime = startTime.add(Duration(minutes: durationMinutes));

//     // Check for overlaps
//     for (final block in existingBlocks) {
//       if (_isOverlapping(startTime, endTime, block.startTime, block.endTime)) {
//         throw Exception('Time slot conflicts with existing block: ${block.title}');
//       }
//     }

//     // Create the custom block
//     final customBlock = TimeBlock(
//       dailyPlanId: dailyPlanId,
//       learningGoalId: learningGoalId,
//       title: title,
//       description: description,
//       blockType: blockType,
//       startTime: startTime,
//       endTime: endTime,
//       durationMinutes: durationMinutes,
//     );

//     final savedBlock = await TimeBlock.db.insertRow(session, customBlock);
//     session.log('Added custom time block: $title at $startTime');

//     // Update total planned minutes in daily plan
//     final plan = await DailyPlan.db.findById(session, dailyPlanId);
//     if (plan != null) {
//       plan.totalPlannedMinutes = (plan.totalPlannedMinutes ?? 0) + durationMinutes;
//       await DailyPlan.db.updateRow(session, plan);
//     }

//     return savedBlock;
//   }

//   /// Check if two time ranges overlap
//   static bool _isOverlapping(
//     DateTime start1,
//     DateTime end1,
//     DateTime start2,
//     DateTime end2,
//   ) {
//     return start1.isBefore(end2) && end1.isAfter(start2);
//   }

//   /// Get academic events for a specific date (handles recurring events)
//   static Future<List<AcademicSchedule>> _getAcademicEventsForDate(
//     Session session,
//     int studentProfileId,
//     DateTime date,
//   ) async {
//     final startOfDay = DateTime(date.year, date.month, date.day);
//     final endOfDay = startOfDay.add(const Duration(days: 1));

//     // Get non-recurring events
//     final nonRecurring = await AcademicSchedule.db.find(
//       session,
//       where: (t) => t.studentProfileId.equals(studentProfileId) &
//           t.isRecurring.equals(false) &
//           t.startTime.between(startOfDay, endOfDay) &
//           t.deletedAt.equals(null),
//     );

//     // Get recurring events and check if they occur on this date
//     final recurring = await AcademicSchedule.db.find(
//       session,
//       where: (t) =>
//           t.studentProfileId.equals(studentProfileId) &
//           t.isRecurring.equals(true) &
//           t.deletedAt.equals(null),
//     );

//     final allEvents = <AcademicSchedule>[...nonRecurring];

//     // Process recurring events
//     for (final event in recurring) {
//       if (event.rrule != null && _eventOccursOnDate(event, date)) {
//         // Create a copy with adjusted dates for this occurrence
//         final adjustedEvent = AcademicSchedule(
//           id: event.id,
//           studentProfileId: event.studentProfileId,
//           title: event.title,
//           type: event.type,
//           location: event.location,
//           rrule: event.rrule,
//           startTime: DateTime(
//             date.year,
//             date.month,
//             date.day,
//             event.startTime.hour,
//             event.startTime.minute,
//           ),
//           endTime: DateTime(
//             date.year,
//             date.month,
//             date.day,
//             event.endTime.hour,
//             event.endTime.minute,
//           ),
//           isRecurring: event.isRecurring,
//           createdAt: event.createdAt,
//         );
//         allEvents.add(adjustedEvent);
//       }
//     }

//     return allEvents;
//   }

//   /// Simple RRULE parser - checks if event occurs on given date
//   static bool _eventOccursOnDate(AcademicSchedule event, DateTime date) {
//     if (event.rrule == null) return false;

//     final rrule = event.rrule!;
    
//     // Parse RRULE components
//     if (rrule.contains('FREQ=WEEKLY')) {
//       // Check if BYDAY matches
//       if (rrule.contains('BYDAY=')) {
//         final dayMap = {
//           'MO': DateTime.monday,
//           'TU': DateTime.tuesday,
//           'WE': DateTime.wednesday,
//           'TH': DateTime.thursday,
//           'FR': DateTime.friday,
//           'SA': DateTime.saturday,
//           'SU': DateTime.sunday,
//         };

//         for (final entry in dayMap.entries) {
//           if (rrule.contains(entry.key) && date.weekday == entry.value) {
//             return true;
//           }
//         }
//       }
//     } else if (rrule.contains('FREQ=DAILY')) {
//       return true;
//     }

//     return false;
//   }

//   /// Generate time blocks based on available time slots
//   /// NOW PROPERLY USES studyBlockMinutes and breakMinutes parameters
//   static Future<List<TimeBlock>> _generateTimeBlocks(
//     Session session,
//     int dailyPlanId,
//     StudentProfile profile,
//     List<LearningGoal> goals,
//     List<AcademicSchedule> academicEvents,
//     Map<String, dynamic> patterns,
//     DateTime date, {
//     required int studyBlockMinutes,
//     required int breakMinutes,
//   }) async {
//     final blocks = <TimeBlock>[];

//     // Parse wake and sleep times
//     final wakeTime = _parseTime(profile.wakeTime);
//     final sleepTime = _parseTime(profile.sleepTime);

//     var currentTime = DateTime(
//       date.year,
//       date.month,
//       date.day,
//       wakeTime.hour,
//       wakeTime.minute,
//     );

//     final endTime = DateTime(
//       date.year,
//       date.month,
//       date.day,
//       sleepTime.hour,
//       sleepTime.minute,
//     );

//     // First, add all academic events as fixed blocks
//     for (final event in academicEvents) {
//       final block = TimeBlock(
//         dailyPlanId: dailyPlanId,
//         academicScheduleId: event.id,
//         title: event.title,
//         description: event.location,
//         blockType: 'class',
//         startTime: event.startTime,
//         endTime: event.endTime,
//         durationMinutes: event.endTime.difference(event.startTime).inMinutes,
//       );
//       blocks.add(block);
//     }

//     // Sort academic blocks by start time
//     blocks.sort((a, b) => a.startTime.compareTo(b.startTime));

//     // Track total study minutes to enforce daily limit
//     int totalStudyMinutes = 0;

//     // Find gaps between fixed blocks and fill with study sessions
//     final studyBlocks = <TimeBlock>[];
    
//     for (int i = 0; i <= blocks.length; i++) {
//       // Check if we've hit daily study limit
//       if (totalStudyMinutes >= maxDailyStudyMinutes) {
//         session.log('Reached maximum daily study time ($maxDailyStudyMinutes min)');
//         break;
//       }

//       final gapStart = i == 0 ? currentTime : blocks[i - 1].endTime;
//       final gapEnd = i < blocks.length ? blocks[i].startTime : endTime;
      
//       final gapMinutes = gapEnd.difference(gapStart).inMinutes;

//       // If gap is large enough, add study blocks
//       if (gapMinutes >= studyBlockMinutes + breakMinutes) {
//         final remainingStudyMinutes = maxDailyStudyMinutes - totalStudyMinutes;
        
//         final newBlocks = _fillGapWithStudyBlocks(
//           dailyPlanId,
//           gapStart,
//           gapEnd,
//           goals,
//           studyBlockMinutes: studyBlockMinutes,
//           breakMinutes: breakMinutes,
//           maxRemainingMinutes: remainingStudyMinutes,
//         );
        
//         // Calculate study time from new blocks
//         final studyTime = newBlocks
//             .where((b) => b.blockType == 'study')
//             .fold(0, (sum, b) => sum + b.durationMinutes);
        
//         totalStudyMinutes += studyTime;
//         studyBlocks.addAll(newBlocks);
//       }
//     }

//     // Insert all blocks
//     blocks.addAll(studyBlocks);
    
//     for (final block in blocks) {
//       await TimeBlock.db.insertRow(session, block);
//     }

//     session.log('Total study time scheduled: $totalStudyMinutes minutes (using ${studyBlockMinutes}min blocks, ${breakMinutes}min breaks)');

//     return blocks;
//   }

//   /// Fill a time gap with study blocks and breaks
//   /// NOW USES the provided studyBlockMinutes and breakMinutes parameters
//   static List<TimeBlock> _fillGapWithStudyBlocks(
//     int dailyPlanId,
//     DateTime gapStart,
//     DateTime gapEnd,
//     List<LearningGoal> goals, {
//     required int studyBlockMinutes,
//     required int breakMinutes,
//     int? maxRemainingMinutes,
//   }) {
//     final blocks = <TimeBlock>[];
//     var currentTime = gapStart;

//     int goalIndex = 0;
//     int blockCount = 0;

//     // Calculate effective max remaining time
//     final effectiveMaxMinutes = maxRemainingMinutes ?? maxDailyStudyMinutes;

//     while (currentTime.isBefore(gapEnd) && blockCount < maxBlocksPerGap) {
//       final remainingMinutes = gapEnd.difference(currentTime).inMinutes;
      
//       // Check if we have enough time for a study block
//       if (remainingMinutes < studyBlockMinutes) break;
      
//       // Check if we've hit the daily study limit
//       final totalStudyInBlocks = blocks
//           .where((b) => b.blockType == 'study')
//           .fold(0, (sum, b) => sum + b.durationMinutes);
      
//       if (totalStudyInBlocks >= effectiveMaxMinutes) break;

//       if (goals.isEmpty) break;
      
//       // Prioritize goals by deadline and hours needed
//       final sortedGoals = _prioritizeGoalsByDeadlineAndHours(goals);
      
//       if (sortedGoals.isEmpty) break;
      
//       final goal = sortedGoals[goalIndex % sortedGoals.length];
      
//       // Check if goal still needs time allocation
//       final remainingHours = goal.estimatedHours ?? 0;
//       if (remainingHours <= 0) {
//         goalIndex++;
//         continue;
//       }
      
//       // Create study block
//       final studyBlock = TimeBlock(
//         dailyPlanId: dailyPlanId,
//         learningGoalId: goal.id,
//         title: goal.title,
//         description: 'Focused study session - ${goal.description ?? ""}',
//         blockType: 'study',
//         startTime: currentTime,
//         endTime: currentTime.add(Duration(minutes: studyBlockMinutes)),
//         durationMinutes: studyBlockMinutes,
//       );
//       blocks.add(studyBlock);
//       blockCount++;

//       currentTime = currentTime.add(Duration(minutes: studyBlockMinutes));

//       // Add break if there's room and not at the end
//       final remainingAfterBreak = gapEnd.difference(currentTime.add(Duration(minutes: breakMinutes))).inMinutes;
//       if (remainingAfterBreak >= studyBlockMinutes) {
//         final breakBlock = TimeBlock(
//           dailyPlanId: dailyPlanId,
//           title: 'Break',
//           description: 'Take a short break',
//           blockType: 'break',
//           startTime: currentTime,
//           endTime: currentTime.add(Duration(minutes: breakMinutes)),
//           durationMinutes: breakMinutes,
//         );
//         blocks.add(breakBlock);
//         currentTime = currentTime.add(Duration(minutes: breakMinutes));
//       }

//       goalIndex++;
//     }

//     return blocks;
//   }

//   /// Prioritize goals by deadline (urgent first) and hours needed
//   static List<LearningGoal> _prioritizeGoalsByDeadlineAndHours(List<LearningGoal> goals) {
//     final now = DateTime.now();
    
//     // Sort by: 1) deadline urgency, 2) priority, 3) hours needed
//     final sortedGoals = List<LearningGoal>.from(goals);
//     sortedGoals.sort((a, b) {
//       // First, sort by deadline (closest deadline first)
//       if (a.deadline != null && b.deadline != null) {
//         final aUrgency = a.deadline!.difference(now).inDays;
//         final bUrgency = b.deadline!.difference(now).inDays;
//         if (aUrgency != bUrgency) return aUrgency.compareTo(bUrgency);
//       } else if (a.deadline != null) {
//         return -1; // a has deadline, b doesn't - prioritize a
//       } else if (b.deadline != null) {
//         return 1; // b has deadline, a doesn't - prioritize b
//       }
      
//       // Second, sort by priority
//       final priorityMap = {'high': 0, 'medium': 1, 'low': 2};
//       final aPriority = priorityMap[a.priority] ?? 3;
//       final bPriority = priorityMap[b.priority] ?? 3;
//       if (aPriority != bPriority) return aPriority.compareTo(bPriority);
      
//       // Third, sort by hours needed (more hours = higher priority)
//       final aHours = a.estimatedHours ?? 0;
//       final bHours = b.estimatedHours ?? 0;
//       return bHours.compareTo(aHours);
//     });
    
//     return sortedGoals;
//   }

//   /// Parse time string "HH:mm" to DateTime
//   static DateTime _parseTime(String timeStr) {
//     try {
//       final parts = timeStr.split(':');
//       return DateTime(0, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
//     } catch (e) {
//       // Default to 7 AM if parsing fails
//       return DateTime(0, 1, 1, 7, 0);
//     }
//   }

//   /// Generate reasoning for why this plan was created
//   static String _generateReasoning(
//     StudentProfile profile,
//     Map<String, dynamic> patterns,
//     List<LearningGoal> goals,
//     int studyBlockMinutes,
//     int breakMinutes,
//   ) {
//     final reasoning = StringBuffer();
//     reasoning.writeln('Plan generated based on:');
//     reasoning.writeln('- ${goals.length} active learning goals for this day');
//     reasoning.writeln('- Study blocks: ${studyBlockMinutes}min, Breaks: ${breakMinutes}min');
//     reasoning.writeln('- Daily study limit: $maxDailyStudyMinutes minutes (${(maxDailyStudyMinutes / 60).toStringAsFixed(1)} hours)');
    
//     if (patterns.containsKey('completionRate')) {
//       final rate = ((patterns['completionRate'] as double) * 100).toStringAsFixed(0);
//       reasoning.writeln('- Recent completion rate: $rate%');
//     }
    
//     if (patterns.containsKey('optimalBlockMinutes')) {
//       reasoning.writeln('- Adapted block length suggested: ${patterns['optimalBlockMinutes']}min');
//     }

//     // Add deadline information
//     final upcomingDeadlines = goals.where((g) => g.deadline != null).toList();
//     if (upcomingDeadlines.isNotEmpty) {
//       reasoning.writeln('- ${upcomingDeadlines.length} goals with upcoming deadlines');
//     }

//     return reasoning.toString();
//   }

//   /// Generate plans for multiple days
//   static Future<List<DailyPlan>> generateMultiplePlans(
//     Session session,
//     int studentProfileId,
//     int daysAhead, {
//     int? customStudyBlockMinutes,
//     int? customBreakMinutes,
//   }) async {
//     final plans = <DailyPlan>[];
//     final today = DateTime.now();

//     for (int i = 0; i < daysAhead; i++) {
//       final date = today.add(Duration(days: i));
//       try {
//         final plan = await generateDailyPlan(
//           session,
//           studentProfileId,
//           date,
//           customStudyBlockMinutes: customStudyBlockMinutes,
//           customBreakMinutes: customBreakMinutes,
//         );
//         plans.add(plan);
//       } catch (e) {
//         session.log('Failed to generate plan for day $i: $e');
//       }
//     }

//     return plans;
//   }

//   /// Get the current day's plan
//   static Future<DailyPlan?> getTodayPlan(
//     Session session,
//     int studentProfileId,
//   ) async {
//     final today = DateTime.now();
//     final normalizedDate = DateTime(today.year, today.month, today.day);
    
//     return await DailyPlan.db.findFirstRow(
//       session,
//       where: (t) =>
//           t.studentProfileId.equals(studentProfileId) &
//           t.planDate.equals(normalizedDate),
//     );
//   }

//   /// Get a week's worth of plans
//   static Future<List<DailyPlan>> getWeekPlans(
//     Session session,
//     int studentProfileId,
//     DateTime weekStart,
//   ) async {
//     // Normalize to Monday
//     DateTime monday = weekStart;
//     while (monday.weekday != DateTime.monday) {
//       monday = monday.subtract(const Duration(days: 1));
//     }
    
//     final sunday = monday.add(const Duration(days: 6));
    
//     return await DailyPlan.db.find(
//       session,
//       where: (t) =>
//           t.studentProfileId.equals(studentProfileId) &
//           t.planDate.between(monday, sunday),
//       orderBy: (t) => t.planDate,
//     );
//   }
// }











import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'adaptation_service.dart';

/// Service for generating daily and weekly plans
class PlanningService {
  /// Maximum study time per day (in minutes)
  static const int maxDailyStudyMinutes = 480; // 8 hours
  
  /// Maximum study blocks per time gap
  static const int maxBlocksPerGap = 6;

  /// Generates a daily plan for a specific date
  static Future<DailyPlan> generateDailyPlan(
    Session session,
    int studentProfileId,
    DateTime date, {
    int? customStudyBlockMinutes,
    int? customBreakMinutes,
  }) async {
    // Normalize date to start of day
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Get student profile
    final profile = await StudentProfile.db.findById(session, studentProfileId);
    if (profile == null) {
      throw Exception('Student profile not found');
    }

    // Use custom durations if provided, otherwise use profile preferences
    final studyBlockMinutes = customStudyBlockMinutes ?? profile.preferredStudyBlockMinutes;
    final breakMinutes = customBreakMinutes ?? profile.preferredBreakMinutes;

    // Get all active learning goals with deadlines
    final goals = await LearningGoal.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          (t.status.equals('in_progress') | t.status.equals('not_started')),
      orderBy: (t) => t.priority,
    );

    // Filter goals relevant for this specific day
    final relevantGoals = _filterGoalsForDate(goals, normalizedDate);

    // Get academic schedule for this date
    final academicEvents = await _getAcademicEventsForDate(
      session,
      studentProfileId,
      normalizedDate,
    );

    // Get behavioral patterns from last 14 days
    final patterns = await AdaptationService.analyzeRecentBehavior(
      session,
      studentProfileId,
      days: 14,
    );

    // Check if plan already exists - DELETE IT FIRST if it does
    final existingPlan = await DailyPlan.db.findFirstRow(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.planDate.equals(normalizedDate),
    );

    final planVersion = (existingPlan?.version ?? 0) + 1;

    // Delete existing plan and its blocks if regenerating
    if (existingPlan != null) {
      session.log('Found existing plan ${existingPlan.id}, deleting it first');

      // Delete time blocks first (foreign key constraint)
      await TimeBlock.db.deleteWhere(
        session,
        where: (t) => t.dailyPlanId.equals(existingPlan.id!),
      );

      // Delete the plan
      await DailyPlan.db.deleteWhere(
        session,
        where: (t) => t.id.equals(existingPlan.id!),
      );

      session.log('Deleted old plan and blocks');
    }

    // Create new plan
    final plan = DailyPlan(
      studentProfileId: studentProfileId,
      planDate: normalizedDate,
      version: planVersion,
      reasoning: _generateReasoning(profile, patterns, relevantGoals, studyBlockMinutes, breakMinutes),
      generatedAt: DateTime.now(),
      adaptationNotes: patterns['adaptationNotes'] as String?,
    );

    final savedPlan = await DailyPlan.db.insertRow(session, plan);
    session.log('Created new plan ${savedPlan.id} version $planVersion for date $normalizedDate');

    // Generate time blocks with custom durations
    final timeBlocks = await _generateTimeBlocks(
      session,
      savedPlan.id!,
      profile,
      relevantGoals,
      academicEvents,
      patterns,
      normalizedDate,
      studyBlockMinutes: studyBlockMinutes,
      breakMinutes: breakMinutes,
    );

    // Calculate total planned minutes
    final totalMinutes = timeBlocks.fold<int>(
      0,
      (sum, block) => sum + block.durationMinutes,
    );

    savedPlan.totalPlannedMinutes = totalMinutes;
    await DailyPlan.db.updateRow(session, savedPlan);

    session.log('Generated daily plan for $normalizedDate with ${timeBlocks.length} blocks (${totalMinutes}min total)');

    return savedPlan;
  }

  /// Filter goals that are relevant for a specific date based on deadline
  static List<LearningGoal> _filterGoalsForDate(List<LearningGoal> goals, DateTime date) {
    return goals.where((goal) {
      // Include goals without deadlines
      if (goal.deadline == null) return true;
      
      // Include goals where deadline is today or in the future
      final deadline = DateTime(goal.deadline!.year, goal.deadline!.month, goal.deadline!.day);
      final today = DateTime(date.year, date.month, date.day);
      
      return deadline.isAfter(today) || deadline.isAtSameMomentAs(today);
    }).toList();
  }

  /// Generates weekly plan (Monday to Sunday)
  static Future<Map<DateTime, DailyPlan>> generateWeeklyPlan(
    Session session,
    int studentProfileId,
    DateTime weekStartDate, {
    int? customStudyBlockMinutes,
    int? customBreakMinutes,
  }) async {
    final weeklyPlans = <DateTime, DailyPlan>{};
    
    // Normalize to Monday of the week
    DateTime monday = weekStartDate;
    while (monday.weekday != DateTime.monday) {
      monday = monday.subtract(const Duration(days: 1));
    }

    session.log('Generating weekly plan starting from Monday: $monday');

    // Generate plans for Monday through Sunday
    for (int i = 0; i < 7; i++) {
      final currentDate = monday.add(Duration(days: i));
      
      try {
        final dailyPlan = await generateDailyPlan(
          session,
          studentProfileId,
          currentDate,
          customStudyBlockMinutes: customStudyBlockMinutes,
          customBreakMinutes: customBreakMinutes,
        );
        
        weeklyPlans[currentDate] = dailyPlan;
        session.log('Generated plan for ${_getDayName(currentDate.weekday)}, ${currentDate.toString().split(' ')[0]}');
      } catch (e) {
        session.log('Failed to generate plan for ${currentDate}: $e', level: LogLevel.error);
      }
    }

    return weeklyPlans;
  }

  /// Get day name from weekday number
  static String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday: return 'Monday';
      case DateTime.tuesday: return 'Tuesday';
      case DateTime.wednesday: return 'Wednesday';
      case DateTime.thursday: return 'Thursday';
      case DateTime.friday: return 'Friday';
      case DateTime.saturday: return 'Saturday';
      case DateTime.sunday: return 'Sunday';
      default: return 'Unknown';
    }
  }

  /// Add a custom time block at a specific time slot
  static Future<TimeBlock> addCustomTimeBlock(
    Session session,
    int dailyPlanId,
    DateTime startTime,
    int durationMinutes,
    String title,
    String description,
    String blockType, {
    int? learningGoalId,
  }) async {
    // Validate the time block doesn't overlap with existing blocks
    final existingBlocks = await TimeBlock.db.find(
      session,
      where: (t) => t.dailyPlanId.equals(dailyPlanId),
      orderBy: (t) => t.startTime,
    );

    final endTime = startTime.add(Duration(minutes: durationMinutes));

    // Check for overlaps
    for (final block in existingBlocks) {
      if (_isOverlapping(startTime, endTime, block.startTime, block.endTime)) {
        throw Exception('Time slot conflicts with existing block: ${block.title}');
      }
    }

    // Create the custom block
    final customBlock = TimeBlock(
      dailyPlanId: dailyPlanId,
      learningGoalId: learningGoalId,
      title: title,
      description: description,
      blockType: blockType,
      startTime: startTime,
      endTime: endTime,
      durationMinutes: durationMinutes,
    );

    final savedBlock = await TimeBlock.db.insertRow(session, customBlock);
    session.log('Added custom time block: $title at $startTime');

    // Update total planned minutes in daily plan
    final plan = await DailyPlan.db.findById(session, dailyPlanId);
    if (plan != null) {
      plan.totalPlannedMinutes = (plan.totalPlannedMinutes ?? 0) + durationMinutes;
      await DailyPlan.db.updateRow(session, plan);
    }

    return savedBlock;
  }

  /// Check if two time ranges overlap
  static bool _isOverlapping(
    DateTime start1,
    DateTime end1,
    DateTime start2,
    DateTime end2,
  ) {
    return start1.isBefore(end2) && end1.isAfter(start2);
  }

  /// Get academic events for a specific date (handles recurring events)
  static Future<List<AcademicSchedule>> _getAcademicEventsForDate(
    Session session,
    int studentProfileId,
    DateTime date,
  ) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // Get non-recurring events
    final nonRecurring = await AcademicSchedule.db.find(
      session,
      where: (t) => t.studentProfileId.equals(studentProfileId) &
          t.isRecurring.equals(false) &
          t.startTime.between(startOfDay, endOfDay) &
          t.deletedAt.equals(null),
    );

    // Get recurring events and check if they occur on this date
    final recurring = await AcademicSchedule.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.isRecurring.equals(true) &
          t.deletedAt.equals(null),
    );

    final allEvents = <AcademicSchedule>[...nonRecurring];

    // Process recurring events
    for (final event in recurring) {
      if (event.rrule != null && _eventOccursOnDate(event, date)) {
        // Create a copy with adjusted dates for this occurrence
        final adjustedEvent = AcademicSchedule(
          id: event.id,
          studentProfileId: event.studentProfileId,
          title: event.title,
          type: event.type,
          location: event.location,
          rrule: event.rrule,
          startTime: DateTime(
            date.year,
            date.month,
            date.day,
            event.startTime.hour,
            event.startTime.minute,
          ),
          endTime: DateTime(
            date.year,
            date.month,
            date.day,
            event.endTime.hour,
            event.endTime.minute,
          ),
          isRecurring: event.isRecurring,
          createdAt: event.createdAt,
        );
        allEvents.add(adjustedEvent);
      }
    }

    return allEvents;
  }

  /// Simple RRULE parser - checks if event occurs on given date
  static bool _eventOccursOnDate(AcademicSchedule event, DateTime date) {
    if (event.rrule == null) return false;

    final rrule = event.rrule!;
    
    // Parse RRULE components
    if (rrule.contains('FREQ=WEEKLY')) {
      // Check if BYDAY matches
      if (rrule.contains('BYDAY=')) {
        final dayMap = {
          'MO': DateTime.monday,
          'TU': DateTime.tuesday,
          'WE': DateTime.wednesday,
          'TH': DateTime.thursday,
          'FR': DateTime.friday,
          'SA': DateTime.saturday,
          'SU': DateTime.sunday,
        };

        for (final entry in dayMap.entries) {
          if (rrule.contains(entry.key) && date.weekday == entry.value) {
            return true;
          }
        }
      }
    } else if (rrule.contains('FREQ=DAILY')) {
      return true;
    }

    return false;
  }

  /// Generate time blocks based on available time slots
  /// FIXED: Properly parses wake and sleep times
  static Future<List<TimeBlock>> _generateTimeBlocks(
    Session session,
    int dailyPlanId,
    StudentProfile profile,
    List<LearningGoal> goals,
    List<AcademicSchedule> academicEvents,
    Map<String, dynamic> patterns,
    DateTime date, {
    required int studyBlockMinutes,
    required int breakMinutes,
  }) async {
    final blocks = <TimeBlock>[];

    // FIXED: Parse wake and sleep times correctly
    final wakeTimeParts = profile.wakeTime.split(':');
    final sleepTimeParts = profile.sleepTime.split(':');

    final wakeHour = int.parse(wakeTimeParts[0]);
    final wakeMinute = int.parse(wakeTimeParts[1]);
    final sleepHour = int.parse(sleepTimeParts[0]);
    final sleepMinute = int.parse(sleepTimeParts[1]);

    var currentTime = DateTime(
      date.year,
      date.month,
      date.day,
      wakeHour,
      wakeMinute,
    );

    var endTime = DateTime(
      date.year,
      date.month,
      date.day,
      sleepHour,
      sleepMinute,
    );

    // Handle sleep time past midnight
    if (endTime.isBefore(currentTime) || endTime.isAtSameMomentAs(currentTime)) {
      endTime = endTime.add(const Duration(days: 1));
    }

    session.log('Day boundaries: ${currentTime} to ${endTime}');

    // First, add all academic events as fixed blocks
    for (final event in academicEvents) {
      final block = TimeBlock(
        dailyPlanId: dailyPlanId,
        academicScheduleId: event.id,
        title: event.title,
        description: event.location,
        blockType: 'class',
        startTime: event.startTime,
        endTime: event.endTime,
        durationMinutes: event.endTime.difference(event.startTime).inMinutes,
      );
      blocks.add(block);
    }

    // Sort academic blocks by start time
    blocks.sort((a, b) => a.startTime.compareTo(b.startTime));

    // Track total study minutes to enforce daily limit
    int totalStudyMinutes = 0;

    // Find gaps between fixed blocks and fill with study sessions
    final studyBlocks = <TimeBlock>[];
    
    for (int i = 0; i <= blocks.length; i++) {
      // Check if we've hit daily study limit
      if (totalStudyMinutes >= maxDailyStudyMinutes) {
        session.log('Reached maximum daily study time ($maxDailyStudyMinutes min)');
        break;
      }

      final gapStart = i == 0 ? currentTime : blocks[i - 1].endTime;
      final gapEnd = i < blocks.length ? blocks[i].startTime : endTime;
      
      final gapMinutes = gapEnd.difference(gapStart).inMinutes;

      session.log('Gap ${i}: ${gapStart} to ${gapEnd} = ${gapMinutes}min');

      // If gap is large enough, add study blocks
      if (gapMinutes >= studyBlockMinutes + breakMinutes) {
        final remainingStudyMinutes = maxDailyStudyMinutes - totalStudyMinutes;
        
        final newBlocks = _fillGapWithStudyBlocks(
          dailyPlanId,
          gapStart,
          gapEnd,
          goals,
          studyBlockMinutes: studyBlockMinutes,
          breakMinutes: breakMinutes,
          maxRemainingMinutes: remainingStudyMinutes,
        );
        
        // Calculate study time from new blocks
        final studyTime = newBlocks
            .where((b) => b.blockType == 'study')
            .fold(0, (sum, b) => sum + b.durationMinutes);
        
        totalStudyMinutes += studyTime;
        studyBlocks.addAll(newBlocks);
      }
    }

    // Insert all blocks
    blocks.addAll(studyBlocks);
    
    for (final block in blocks) {
      await TimeBlock.db.insertRow(session, block);
    }

    session.log('Total study time scheduled: $totalStudyMinutes minutes (using ${studyBlockMinutes}min blocks, ${breakMinutes}min breaks)');

    return blocks;
  }

  /// Fill a time gap with study blocks and breaks
  static List<TimeBlock> _fillGapWithStudyBlocks(
    int dailyPlanId,
    DateTime gapStart,
    DateTime gapEnd,
    List<LearningGoal> goals, {
    required int studyBlockMinutes,
    required int breakMinutes,
    int? maxRemainingMinutes,
  }) {
    final blocks = <TimeBlock>[];
    var currentTime = gapStart;

    int goalIndex = 0;
    int blockCount = 0;

    // Calculate effective max remaining time
    final effectiveMaxMinutes = maxRemainingMinutes ?? maxDailyStudyMinutes;

    while (currentTime.isBefore(gapEnd) && blockCount < maxBlocksPerGap) {
      final remainingMinutes = gapEnd.difference(currentTime).inMinutes;
      
      // Check if we have enough time for a study block
      if (remainingMinutes < studyBlockMinutes) break;
      
      // Check if we've hit the daily study limit
      final totalStudyInBlocks = blocks
          .where((b) => b.blockType == 'study')
          .fold(0, (sum, b) => sum + b.durationMinutes);
      
      if (totalStudyInBlocks >= effectiveMaxMinutes) break;

      if (goals.isEmpty) break;
      
      // Prioritize goals by deadline and hours needed
      final sortedGoals = _prioritizeGoalsByDeadlineAndHours(goals);
      
      if (sortedGoals.isEmpty) break;
      
      final goal = sortedGoals[goalIndex % sortedGoals.length];
      
      // Create study block
      final studyBlock = TimeBlock(
        dailyPlanId: dailyPlanId,
        learningGoalId: goal.id,
        title: goal.title,
        description: 'Focused study session - ${goal.description ?? ""}',
        blockType: 'study',
        startTime: currentTime,
        endTime: currentTime.add(Duration(minutes: studyBlockMinutes)),
        durationMinutes: studyBlockMinutes,
      );
      blocks.add(studyBlock);
      blockCount++;

      currentTime = currentTime.add(Duration(minutes: studyBlockMinutes));

      // Add break if there's room and not at the end
      final remainingAfterBreak = gapEnd.difference(currentTime.add(Duration(minutes: breakMinutes))).inMinutes;
      if (remainingAfterBreak >= studyBlockMinutes) {
        final breakBlock = TimeBlock(
          dailyPlanId: dailyPlanId,
          title: 'Break',
          description: 'Take a short break',
          blockType: 'break',
          startTime: currentTime,
          endTime: currentTime.add(Duration(minutes: breakMinutes)),
          durationMinutes: breakMinutes,
        );
        blocks.add(breakBlock);
        currentTime = currentTime.add(Duration(minutes: breakMinutes));
      }

      goalIndex++;
    }

    return blocks;
  }

  /// Prioritize goals by deadline (urgent first) and hours needed
  static List<LearningGoal> _prioritizeGoalsByDeadlineAndHours(List<LearningGoal> goals) {
    final now = DateTime.now();
    
    // Sort by: 1) deadline urgency, 2) priority, 3) hours needed
    final sortedGoals = List<LearningGoal>.from(goals);
    sortedGoals.sort((a, b) {
      // First, sort by deadline (closest deadline first)
      if (a.deadline != null && b.deadline != null) {
        final aUrgency = a.deadline!.difference(now).inDays;
        final bUrgency = b.deadline!.difference(now).inDays;
        if (aUrgency != bUrgency) return aUrgency.compareTo(bUrgency);
      } else if (a.deadline != null) {
        return -1; // a has deadline, b doesn't - prioritize a
      } else if (b.deadline != null) {
        return 1; // b has deadline, a doesn't - prioritize b
      }
      
      // Second, sort by priority
      final priorityMap = {'high': 0, 'medium': 1, 'low': 2};
      final aPriority = priorityMap[a.priority] ?? 3;
      final bPriority = priorityMap[b.priority] ?? 3;
      if (aPriority != bPriority) return aPriority.compareTo(bPriority);
      
      // Third, sort by hours needed (more hours = higher priority)
      final aHours = a.estimatedHours ?? 0;
      final bHours = b.estimatedHours ?? 0;
      return bHours.compareTo(aHours);
    });
    
    return sortedGoals;
  }

  /// Generate reasoning for why this plan was created
  static String _generateReasoning(
    StudentProfile profile,
    Map<String, dynamic> patterns,
    List<LearningGoal> goals,
    int studyBlockMinutes,
    int breakMinutes,
  ) {
    final reasoning = StringBuffer();
    reasoning.writeln('Plan generated based on:');
    reasoning.writeln('- ${goals.length} active learning goals for this day');
    reasoning.writeln('- Wake time: ${profile.wakeTime}, Sleep time: ${profile.sleepTime}');
    reasoning.writeln('- Study blocks: ${studyBlockMinutes}min, Breaks: ${breakMinutes}min');
    reasoning.writeln('- Daily study limit: $maxDailyStudyMinutes minutes (${(maxDailyStudyMinutes / 60).toStringAsFixed(1)} hours)');
    
    if (patterns.containsKey('completionRate')) {
      final rate = ((patterns['completionRate'] as double) * 100).toStringAsFixed(0);
      reasoning.writeln('- Recent completion rate: $rate%');
    }

    // Add deadline information
    final upcomingDeadlines = goals.where((g) => g.deadline != null).toList();
    if (upcomingDeadlines.isNotEmpty) {
      reasoning.writeln('- ${upcomingDeadlines.length} goals with upcoming deadlines');
    }

    return reasoning.toString();
  }

  /// Generate plans for multiple days
  static Future<List<DailyPlan>> generateMultiplePlans(
    Session session,
    int studentProfileId,
    int daysAhead, {
    int? customStudyBlockMinutes,
    int? customBreakMinutes,
  }) async {
    final plans = <DailyPlan>[];
    final today = DateTime.now();

    for (int i = 0; i < daysAhead; i++) {
      final date = today.add(Duration(days: i));
      try {
        final plan = await generateDailyPlan(
          session,
          studentProfileId,
          date,
          customStudyBlockMinutes: customStudyBlockMinutes,
          customBreakMinutes: customBreakMinutes,
        );
        plans.add(plan);
      } catch (e) {
        session.log('Failed to generate plan for day $i: $e');
      }
    }

    return plans;
  }

  /// Get the current day's plan
  static Future<DailyPlan?> getTodayPlan(
    Session session,
    int studentProfileId,
  ) async {
    final today = DateTime.now();
    final normalizedDate = DateTime(today.year, today.month, today.day);
    
    return await DailyPlan.db.findFirstRow(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.planDate.equals(normalizedDate),
    );
  }

  /// Get a week's worth of plans
  static Future<List<DailyPlan>> getWeekPlans(
    Session session,
    int studentProfileId,
    DateTime weekStart,
  ) async {
    // Normalize to Monday
    DateTime monday = weekStart;
    while (monday.weekday != DateTime.monday) {
      monday = monday.subtract(const Duration(days: 1));
    }
    
    final sunday = monday.add(const Duration(days: 6));
    
    return await DailyPlan.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.planDate.between(monday, sunday),
      orderBy: (t) => t.planDate,
    );
  }
}