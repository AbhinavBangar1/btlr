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
    try {
      session.log('Expanding recurring events from $startDate to $endDate');
      
      final recurringEvents = await AcademicSchedule.db.find(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.isRecurring.equals(true) &
            t.deletedAt.equals(null),
      );

      session.log('Found ${recurringEvents.length} recurring events');
      final expandedEvents = <Map<String, dynamic>>[];

      for (final event in recurringEvents) {
        if (event.rrule == null || event.rrule!.isEmpty) {
          session.log('Skipping event ${event.id}: no RRULE', level: LogLevel.warning);
          continue;
        }

        try {
          final occurrences = _parseRRuleSimple(
            event.rrule!,
            event.startTime,
            event.endTime,
            startDate,
            endDate,
          );

          session.log('Event ${event.id} generated ${occurrences.length} occurrences');

          for (final occurrence in occurrences) {
            expandedEvents.add({
              'event': event,
              'startTime': occurrence['start'],
              'endTime': occurrence['end'],
            });
          }
        } catch (e) {
          session.log('Error parsing RRULE for event ${event.id}: $e', level: LogLevel.error);
          // Continue with other events instead of failing completely
        }
      }

      return expandedEvents;
    } catch (e, stack) {
      session.log('Error in expandRecurringEvents: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      rethrow;
    }
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

    try {
      // Parse RRULE components
      final parts = rrule.split(';');
      String? freq;
      List<String>? byDay;
      int interval = 1;
      DateTime? until;
      int? count;

      for (final part in parts) {
        final trimmedPart = part.trim();
        if (trimmedPart.isEmpty) continue;

        if (trimmedPart.startsWith('FREQ=')) {
          freq = trimmedPart.substring(5);
        } else if (trimmedPart.startsWith('BYDAY=')) {
          byDay = trimmedPart.substring(6).split(',').map((d) => d.trim()).toList();
        } else if (trimmedPart.startsWith('INTERVAL=')) {
          try {
            interval = int.parse(trimmedPart.substring(9));
            if (interval < 1) interval = 1;
          } catch (e) {
            interval = 1;
          }
        } else if (trimmedPart.startsWith('UNTIL=')) {
          final untilStr = trimmedPart.substring(6);
          try {
            // Try parsing ISO format first
            until = DateTime.parse(untilStr);
          } catch (e) {
            // Try parsing RRULE format: YYYYMMDDTHHMMSSZ
            try {
              if (untilStr.length >= 8) {
                final year = int.parse(untilStr.substring(0, 4));
                final month = int.parse(untilStr.substring(4, 6));
                final day = int.parse(untilStr.substring(6, 8));
                until = DateTime(year, month, day);
              }
            } catch (_) {
              // Ignore parse errors
            }
          }
        } else if (trimmedPart.startsWith('COUNT=')) {
          try {
            count = int.parse(trimmedPart.substring(6));
            if (count < 1) count = null;
          } catch (e) {
            count = null;
          }
        }
      }

      if (freq == null) return occurrences;

      // Limit maximum occurrences to prevent infinite loops
      const maxOccurrences = 1000;
      int totalGenerated = 0;

      // Handle WEEKLY frequency
      if (freq == 'WEEKLY') {
        if (byDay == null || byDay.isEmpty) return occurrences;

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

        final targetDays = <int>{};
        for (final day in byDay) {
          final weekday = dayMap[day.toUpperCase()];
          if (weekday != null) {
            targetDays.add(weekday);
          }
        }

        if (targetDays.isEmpty) return occurrences;

        // Start from the earlier of rangeStart or originalStart
        var currentDate = rangeStart.isBefore(originalStart) ? originalStart : rangeStart;
        int occurrenceCount = 0;

        while (currentDate.isBefore(rangeEnd) && totalGenerated < maxOccurrences) {
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

            // Only add if within range
            if (occurrenceStart.isBefore(rangeEnd) && occurrenceEnd.isAfter(rangeStart)) {
              occurrences.add({
                'start': occurrenceStart,
                'end': occurrenceEnd,
              });
              occurrenceCount++;
              totalGenerated++;
            }
          }

          currentDate = currentDate.add(const Duration(days: 1));
        }
      }

      // Handle DAILY frequency
      else if (freq == 'DAILY') {
        var currentDate = rangeStart.isBefore(originalStart) ? originalStart : rangeStart;
        int occurrenceCount = 0;

        while (currentDate.isBefore(rangeEnd) && totalGenerated < maxOccurrences) {
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

          if (occurrenceStart.isBefore(rangeEnd)) {
            occurrences.add({
              'start': occurrenceStart,
              'end': occurrenceEnd,
            });
            occurrenceCount++;
            totalGenerated++;
          }

          currentDate = currentDate.add(Duration(days: interval));
        }
      }

      // Handle MONTHLY frequency
      else if (freq == 'MONTHLY') {
        var currentDate = rangeStart.isBefore(originalStart) ? originalStart : rangeStart;
        int occurrenceCount = 0;

        while (currentDate.isBefore(rangeEnd) && totalGenerated < maxOccurrences) {
          if (until != null && currentDate.isAfter(until)) break;
          if (count != null && occurrenceCount >= count) break;

          try {
            final occurrenceStart = DateTime(
              currentDate.year,
              currentDate.month,
              originalStart.day,
              originalStart.hour,
              originalStart.minute,
            );

            // Check if date is valid (e.g., Feb 30 doesn't exist)
            if (occurrenceStart.month == currentDate.month && occurrenceStart.isBefore(rangeEnd)) {
              final duration = originalEnd.difference(originalStart);
              final occurrenceEnd = occurrenceStart.add(duration);

              occurrences.add({
                'start': occurrenceStart,
                'end': occurrenceEnd,
              });
              occurrenceCount++;
              totalGenerated++;
            }
          } catch (e) {
            // Skip invalid dates
          }

          // Move to next month
          try {
            currentDate = DateTime(
              currentDate.year,
              currentDate.month + interval,
              1, // Use day 1 to avoid issues
            );
          } catch (e) {
            break; // Exit if we can't calculate next month
          }
        }
      }

      return occurrences;
    } catch (e) {
      // Return empty list instead of throwing
      return occurrences;
    }
  }

  /// Detect conflicts between time blocks and academic events
  static Future<List<Map<String, dynamic>>> detectConflicts(
    Session session,
    int studentProfileId,
    DateTime date,
  ) async {
    try {
      session.log('Detecting conflicts for $date');
      final conflicts = <Map<String, dynamic>>[];
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // Get all time blocks for this date
      final dailyPlan = await DailyPlan.db.findFirstRow(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.planDate.equals(normalizedDate),
      );

      if (dailyPlan == null) {
        session.log('No daily plan found for $date');
        return conflicts;
      }

      final timeBlocks = await TimeBlock.db.find(
        session,
        where: (t) => t.dailyPlanId.equals(dailyPlan.id!),
        orderBy: (t) => t.startTime,
      );

      session.log('Found ${timeBlocks.length} time blocks');

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

      session.log('Found ${academicEvents.length} academic events');

      // Check for overlaps with academic events
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

          if (block.endTime.isAtSameMomentAs(otherBlock.startTime)) {
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

      session.log('Detected ${conflicts.length} conflicts');
      return conflicts;
    } catch (e, stack) {
      session.log('Error in detectConflicts: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      return [];
    }
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
    try {
      // Validate type
      final validTypes = ['class', 'exam', 'lab', 'workshop'];
      if (!validTypes.contains(type)) {
        throw Exception('Invalid type. Must be one of: ${validTypes.join(", ")}');
      }

      // Validate times
      if (endTime.isBefore(startTime) || endTime.isAtSameMomentAs(startTime)) {
        throw Exception('End time must be after start time');
      }

      // Validate RRULE if provided
      if (isRecurring && (rrule == null || rrule.isEmpty)) {
        throw Exception('RRULE is required for recurring events');
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

      return await AcademicSchedule.db.insertRow(session, schedule);
    } catch (e, stack) {
      session.log('Error creating schedule item: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      rethrow;
    }
  }

  /// Soft delete an academic schedule item
  static Future<AcademicSchedule> deleteScheduleItem(
    Session session,
    int scheduleId,
  ) async {
    try {
      final schedule = await AcademicSchedule.db.findById(session, scheduleId);
      if (schedule == null) {
        throw Exception('Schedule item not found');
      }

      schedule.deletedAt = DateTime.now();
      return await AcademicSchedule.db.updateRow(session, schedule);
    } catch (e, stack) {
      session.log('Error deleting schedule item: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      rethrow;
    }
  }

  /// Get all academic events for a week
  static Future<List<AcademicSchedule>> getWeekSchedule(
    Session session,
    int studentProfileId,
    DateTime weekStart,
  ) async {
    try {
      final weekEnd = weekStart.add(const Duration(days: 7));

      session.log('Getting week schedule from $weekStart to $weekEnd');

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

      session.log('Found ${nonRecurring.length} non-recurring events');

      // Get recurring events and expand them
      final recurringEvents = await expandRecurringEvents(
        session,
        studentProfileId,
        weekStart,
        weekEnd,
      );

      session.log('Expanded ${recurringEvents.length} recurring event occurrences');

      // Combine non-recurring and expanded recurring events
      final allEvents = <AcademicSchedule>[...nonRecurring];

      for (final expanded in recurringEvents) {
        try {
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
        } catch (e) {
          session.log('Error processing expanded event: $e', level: LogLevel.warning);
        }
      }

      // Sort by start time
      allEvents.sort((a, b) => a.startTime.compareTo(b.startTime));

      session.log('Returning ${allEvents.length} total events');
      return allEvents;
    } catch (e, stack) {
      session.log('Error in getWeekSchedule: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      rethrow;
    }
  }

  /// Generate RRULE string from parameters
  static String generateRRule({
    required String frequency,
    List<String>? byDay,
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
      final untilStr = '${until.toUtc().toIso8601String()
          .replaceAll('-', '')
          .replaceAll(':', '')
          .split('.')[0]}Z';
      parts.add('UNTIL=$untilStr');
    }

    if (count != null && count > 0) {
      parts.add('COUNT=$count');
    }

    return parts.join(';');
  }

  /// Parse RRULE string into components (for display/editing)
  static Map<String, dynamic> parseRRule(String rrule) {
    final result = <String, dynamic>{};
    final parts = rrule.split(';');

    for (final part in parts) {
      final trimmedPart = part.trim();
      if (trimmedPart.isEmpty) continue;

      if (trimmedPart.startsWith('FREQ=')) {
        result['frequency'] = trimmedPart.substring(5);
      } else if (trimmedPart.startsWith('BYDAY=')) {
        result['byDay'] = trimmedPart.substring(6).split(',');
      } else if (trimmedPart.startsWith('INTERVAL=')) {
        try {
          result['interval'] = int.parse(trimmedPart.substring(9));
        } catch (e) {
          result['interval'] = 1;
        }
      } else if (trimmedPart.startsWith('UNTIL=')) {
        result['until'] = trimmedPart.substring(6);
      } else if (trimmedPart.startsWith('COUNT=')) {
        try {
          result['count'] = int.parse(trimmedPart.substring(6));
        } catch (e) {
          result['count'] = null;
        }
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
    try {
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
    } catch (e, stack) {
      session.log('Error getting upcoming exams: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      return [];
    }
  }

  /// Find free time slots in a day
  static Future<List<Map<String, DateTime>>> findFreeSlots(
    Session session,
    int studentProfileId,
    DateTime date, {
    int minDurationMinutes = 30,
  }) async {
    try {
      session.log('Finding free slots for $date');
      final normalizedDate = DateTime(date.year, date.month, date.day);
      final freeSlots = <Map<String, DateTime>>[];

      // Get student profile for wake/sleep times
      final profile = await StudentProfile.db.findById(session, studentProfileId);
      if (profile == null) {
        session.log('Student profile not found: $studentProfileId', level: LogLevel.error);
        return freeSlots;
      }

      // Parse wake and sleep times with validation
      final wakeParts = profile.wakeTime.split(':');
      final sleepParts = profile.sleepTime.split(':');

      if (wakeParts.length < 2 || sleepParts.length < 2) {
        session.log('Invalid wake/sleep time format', level: LogLevel.error);
        return freeSlots;
      }

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

      // Handle sleep time being past midnight
      final actualDayEnd = dayEnd.isBefore(dayStart) 
          ? dayEnd.add(const Duration(days: 1)) 
          : dayEnd;

      // Get all scheduled events
      final academicEvents = await AcademicSchedule.db.find(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.startTime.between(dayStart, actualDayEnd) &
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
              where: (t) => t.dailyPlanId.equals(dailyPlan.id!),
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
        final busyStart = busy['start']!;
        final busyEnd = busy['end']!;

        // Skip if busy time is before current time
        if (busyEnd.isBefore(currentTime) || busyEnd.isAtSameMomentAs(currentTime)) {
          continue;
        }

        final gapStart = currentTime.isBefore(busyStart) ? currentTime : busyStart;
        final gapDuration = busyStart.difference(gapStart).inMinutes;

        if (gapDuration >= minDurationMinutes && gapStart.isBefore(busyStart)) {
          freeSlots.add({
            'start': gapStart,
            'end': busyStart,
          });
        }

        currentTime = busyEnd.isAfter(currentTime) ? busyEnd : currentTime;
      }

      // Check time after last event
      if (currentTime.isBefore(actualDayEnd)) {
        final finalGapDuration = actualDayEnd.difference(currentTime).inMinutes;
        if (finalGapDuration >= minDurationMinutes) {
          freeSlots.add({
            'start': currentTime,
            'end': actualDayEnd,
          });
        }
      }

      session.log('Found ${freeSlots.length} free slots');
      return freeSlots;
    } catch (e, stack) {
      session.log('Error finding free slots: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      return [];
    }
  }
}