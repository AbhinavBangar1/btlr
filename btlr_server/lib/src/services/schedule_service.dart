import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Service for handling academic schedules, RRULE parsing, and conflict detection
class ScheduleService {
  /// Expand recurring events for a date range
  /// Parses RRULE and generates individual occurrences
  static Future<List<Map<String, dynamic>>> expandRecurringEvents(
    Session session,
    int studentProfileId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final recurringEvents = await AcademicSchedule.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.isRecurring.equals(true) &
          t.deletedAt.equals(null),
    );

    final expandedEvents = <Map<String, dynamic>>[];

    for (final event in recurringEvents) {
      if (event.rrule == null) continue;

      final occurrences = _parseRRuleSimple(
        event.rrule!,
        event.startTime,
        event.endTime,
        startDate,
        endDate,
      );

      for (final occurrence in occurrences) {
        expandedEvents.add({
          'event': event,
          'startTime': occurrence['start'],
          'endTime': occurrence['end'],
        });
      }
    }

    return expandedEvents;
  }

  /// Simple RRULE parser (supports basic weekly and daily recurrence)
  /// For production, use a proper RRULE library
  static List<Map<String, DateTime>> _parseRRuleSimple(
    String rrule,
    DateTime originalStart,
    DateTime originalEnd,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final occurrences = <Map<String, DateTime>>[];

    // Parse RRULE components
    final parts = rrule.split(';');
    String? freq;
    List<String>? byDay;
    int interval = 1;
    DateTime? until;
    int? count;

    for (final part in parts) {
      if (part.startsWith('FREQ=')) {
        freq = part.substring(5);
      } else if (part.startsWith('BYDAY=')) {
        byDay = part.substring(6).split(',');
      } else if (part.startsWith('INTERVAL=')) {
        interval = int.parse(part.substring(9));
      } else if (part.startsWith('UNTIL=')) {
        // Parse UNTIL date (basic implementation)
        final untilStr = part.substring(6);
        try {
          until = DateTime.parse(untilStr);
        } catch (e) {
          // Ignore parse errors
        }
      } else if (part.startsWith('COUNT=')) {
        count = int.parse(part.substring(6));
      }
    }

    if (freq == null) return occurrences;

    // Handle WEEKLY frequency
    if (freq == 'WEEKLY') {
      if (byDay == null) return occurrences;

      // Map day abbreviations to weekday numbers
      final dayMap = {
        'MO': DateTime.monday,
        'TU': DateTime.tuesday,
        'WE': DateTime.wednesday,
        'TH': DateTime.thursday,
        'FR': DateTime.friday,
        'SA': DateTime.saturday,
        'SU': DateTime.sunday,
      };

      final targetDays = byDay.map((d) => dayMap[d]!).toSet();

      // Start from rangeStart
      var currentDate = rangeStart;
      int occurrenceCount = 0;

      while (currentDate.isBefore(rangeEnd)) {
        if (until != null && currentDate.isAfter(until)) break;
        if (count != null && occurrenceCount >= count) break;

        if (targetDays.contains(currentDate.weekday)) {
          // Calculate start and end times for this occurrence
          final occurrenceStart = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            originalStart.hour,
            originalStart.minute,
          );

          final duration = originalEnd.difference(originalStart);
          final occurrenceEnd = occurrenceStart.add(duration);

          occurrences.add({
            'start': occurrenceStart,
            'end': occurrenceEnd,
          });

          occurrenceCount++;
        }

        currentDate = currentDate.add(Duration(days: 1));
      }
    }

    // Handle DAILY frequency
    else if (freq == 'DAILY') {
      var currentDate = rangeStart;
      int occurrenceCount = 0;

      while (currentDate.isBefore(rangeEnd)) {
        if (until != null && currentDate.isAfter(until)) break;
        if (count != null && occurrenceCount >= count) break;

        final occurrenceStart = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          originalStart.hour,
          originalStart.minute,
        );

        final duration = originalEnd.difference(originalStart);
        final occurrenceEnd = occurrenceStart.add(duration);

        occurrences.add({
          'start': occurrenceStart,
          'end': occurrenceEnd,
        });

        occurrenceCount++;
        currentDate = currentDate.add(Duration(days: interval));
      }
    }

    // Handle MONTHLY frequency (basic)
    else if (freq == 'MONTHLY') {
      var currentDate = rangeStart;
      int occurrenceCount = 0;

      while (currentDate.isBefore(rangeEnd)) {
        if (until != null && currentDate.isAfter(until)) break;
        if (count != null && occurrenceCount >= count) break;

        final occurrenceStart = DateTime(
          currentDate.year,
          currentDate.month,
          originalStart.day,
          originalStart.hour,
          originalStart.minute,
        );

        // Check if date is valid (e.g., Feb 30 doesn't exist)
        if (occurrenceStart.month == currentDate.month) {
          final duration = originalEnd.difference(originalStart);
          final occurrenceEnd = occurrenceStart.add(duration);

          occurrences.add({
            'start': occurrenceStart,
            'end': occurrenceEnd,
          });

          occurrenceCount++;
        }

        // Move to next month
        currentDate = DateTime(
          currentDate.year,
          currentDate.month + interval,
          currentDate.day,
        );
      }
    }

    return occurrences;
  }

  /// Detect conflicts between time blocks and academic events
  static Future<List<Map<String, dynamic>>> detectConflicts(
    Session session,
    int studentProfileId,
    DateTime date,
  ) async {
    final conflicts = <Map<String, dynamic>>[];
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Get all time blocks for this date
    final dailyPlan = await DailyPlan.db.findFirstRow(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.planDate.equals(normalizedDate),
    );

    if (dailyPlan == null) return conflicts;

    final timeBlocks = await TimeBlock.db.find(
      session,
      where: (t) => t.dailyPlanId.equals(dailyPlan.id),
      orderBy: (t) => t.startTime,
    );

    // Get academic events for this date
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final academicEvents = await AcademicSchedule.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.startTime.between(startOfDay, endOfDay) &
          t.deletedAt.equals(null),
    );

    // Check for overlaps
    for (final block in timeBlocks) {
      for (final event in academicEvents) {
        if (_isOverlapping(
          block.startTime,
          block.endTime,
          event.startTime,
          event.endTime,
        )) {
          conflicts.add({
            'timeBlock': block,
            'academicEvent': event,
            'type': 'overlap',
            'severity': 'high',
          });
        }
      }

      // Check for back-to-back conflicts (no break time)
      for (final otherBlock in timeBlocks) {
        if (block.id == otherBlock.id) continue;

        if (block.endTime == otherBlock.startTime) {
          conflicts.add({
            'timeBlock': block,
            'nextBlock': otherBlock,
            'type': 'no_break',
            'severity': 'low',
          });
        }
      }
    }

    // Check for too many tasks in one day
    if (timeBlocks.length > 10) {
      conflicts.add({
        'type': 'overload',
        'severity': 'medium',
        'message': 'Too many tasks scheduled (${timeBlocks.length} blocks)',
      });
    }

    return conflicts;
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

  /// Create a new academic schedule item
  static Future<AcademicSchedule> createScheduleItem(
    Session session, {
    required int studentProfileId,
    required String title,
    required String type,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    bool isRecurring = false,
    String? rrule,
  }) async {
    // Validate type
    final validTypes = ['class', 'exam', 'lab', 'workshop'];
    if (!validTypes.contains(type)) {
      throw Exception('Invalid type. Must be one of: ${validTypes.join(", ")}');
    }

    // Validate times
    if (endTime.isBefore(startTime) || endTime.isAtSameMomentAs(startTime)) {
      throw Exception('End time must be after start time');
    }

    final schedule = AcademicSchedule(
      studentProfileId: studentProfileId,
      title: title,
      type: type,
      location: location,
      rrule: rrule,
      startTime: startTime,
      endTime: endTime,
      isRecurring: isRecurring,
      createdAt: DateTime.now(),
    );

    return await AcademicSchedule.db.insertRow(session,schedule);
  }

  /// Soft delete an academic schedule item
  static Future<AcademicSchedule> deleteScheduleItem(
    Session session,
    int scheduleId,
  ) async {
    final schedule = await AcademicSchedule.db.findById(session,scheduleId);
    if (schedule == null) {
      throw Exception('Schedule item not found');
    }

    schedule.deletedAt = DateTime.now();
    return await AcademicSchedule.db.updateRow(session,schedule);
  }

  /// Get all academic events for a week
  static Future<List<AcademicSchedule>> getWeekSchedule(
    Session session,
    int studentProfileId,
    DateTime weekStart,
  ) async {
    final weekEnd = weekStart.add(const Duration(days: 7));

    // Get non-recurring events
    final nonRecurring = await AcademicSchedule.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.isRecurring.equals(false) &
          t.startTime.between(weekStart, weekEnd) &
          t.deletedAt.equals(null),
      orderBy: (t) => t.startTime,
    );

    // Get recurring events and expand them
    final recurringEvents = await expandRecurringEvents(
      session,
      studentProfileId,
      weekStart,
      weekEnd,
    );

    // Combine non-recurring and expanded recurring events
    final allEvents = <AcademicSchedule>[...nonRecurring];

    for (final expanded in recurringEvents) {
      final event = expanded['event'] as AcademicSchedule;
      final start = expanded['startTime'] as DateTime;
      final end = expanded['endTime'] as DateTime;

      // Create a copy with adjusted dates
      final adjustedEvent = AcademicSchedule(
        id: event.id,
        studentProfileId: event.studentProfileId,
        title: event.title,
        type: event.type,
        location: event.location,
        rrule: event.rrule,
        startTime: start,
        endTime: end,
        isRecurring: event.isRecurring,
        createdAt: event.createdAt,
      );
      allEvents.add(adjustedEvent);
    }

    // Sort by start time
    allEvents.sort((a, b) => a.startTime.compareTo(b.startTime));

    return allEvents;
  }

  /// Generate RRULE string from parameters
  static String generateRRule({
    required String frequency, // DAILY, WEEKLY, MONTHLY
    List<String>? byDay, // ['MO', 'WE', 'FR']
    int interval = 1,
    DateTime? until,
    int? count,
  }) {
    final parts = <String>['FREQ=$frequency'];

    if (interval > 1) {
      parts.add('INTERVAL=$interval');
    }

    if (byDay != null && byDay.isNotEmpty) {
      parts.add('BYDAY=${byDay.join(',')}');
    }

    if (until != null) {
      // Format: YYYYMMDDTHHMMSSZ
      final untilStr = until.toUtc().toIso8601String()
          .replaceAll('-', '')
          .replaceAll(':', '')
          .split('.')[0] + 'Z';
      parts.add('UNTIL=$untilStr');
    }

    if (count != null) {
      parts.add('COUNT=$count');
    }

    return parts.join(';');
  }

  /// Parse RRULE string into components (for display/editing)
  static Map<String, dynamic> parseRRule(String rrule) {
    final result = <String, dynamic>{};
    final parts = rrule.split(';');

    for (final part in parts) {
      if (part.startsWith('FREQ=')) {
        result['frequency'] = part.substring(5);
      } else if (part.startsWith('BYDAY=')) {
        result['byDay'] = part.substring(6).split(',');
      } else if (part.startsWith('INTERVAL=')) {
        result['interval'] = int.parse(part.substring(9));
      } else if (part.startsWith('UNTIL=')) {
        result['until'] = part.substring(6);
      } else if (part.startsWith('COUNT=')) {
        result['count'] = int.parse(part.substring(6));
      }
    }

    return result;
  }

  /// Get upcoming exams (next N days)
  static Future<List<AcademicSchedule>> getUpcomingExams(
    Session session,
    int studentProfileId, {
    int daysAhead = 30,
  }) async {
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: daysAhead));

    return await AcademicSchedule.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.type.equals('exam') &
          t.startTime.between(now, futureDate) &
          t.deletedAt.equals(null),
      orderBy: (t) => t.startTime,
    );
  }

  /// Find free time slots in a day
  static Future<List<Map<String, DateTime>>> findFreeSlots(
    Session session,
    int studentProfileId,
    DateTime date, {
    int minDurationMinutes = 30,
  }) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final freeSlots = <Map<String, DateTime>>[];

    // Get student profile for wake/sleep times
    final profile = await StudentProfile.db.findById(session,studentProfileId);
    if (profile == null) return freeSlots;

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

    // Get all scheduled events
    final academicEvents = await AcademicSchedule.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.startTime.between(dayStart, dayEnd) &
          t.deletedAt.equals(null),
      orderBy: (t) => t.startTime,
    );

    // Get time blocks
    final dailyPlan = await DailyPlan.db.findFirstRow(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.planDate.equals(normalizedDate),
    );

    final timeBlocks = dailyPlan != null
        ? await TimeBlock.db.find(
          session,
            where: (t) => t.dailyPlanId.equals(dailyPlan.id),
            orderBy: (t) => t.startTime,
          )
        : <TimeBlock>[];

    // Combine all busy times
    final busyTimes = <Map<String, DateTime>>[];

    for (final event in academicEvents) {
      busyTimes.add({'start': event.startTime, 'end': event.endTime});
    }

    for (final block in timeBlocks) {
      busyTimes.add({'start': block.startTime, 'end': block.endTime});
    }

    // Sort by start time
    busyTimes.sort((a, b) => a['start']!.compareTo(b['start']!));

    // Find gaps
    var currentTime = dayStart;

    for (final busy in busyTimes) {
      final gapDuration = busy['start']!.difference(currentTime).inMinutes;

      if (gapDuration >= minDurationMinutes) {
        freeSlots.add({
          'start': currentTime,
          'end': busy['start']!,
        });
      }

      currentTime = busy['end']!;
    }

    // Check time after last event
    final finalGapDuration = dayEnd.difference(currentTime).inMinutes;
    if (finalGapDuration >= minDurationMinutes) {
      freeSlots.add({
        'start': currentTime,
        'end': dayEnd,
      });
    }

    return freeSlots;
  }
}