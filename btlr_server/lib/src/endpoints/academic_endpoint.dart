import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
// import '../services/schedule_service.dart';

/// Endpoint for managing academic schedules
class AcademicEndpoint extends Endpoint {
  /// Create a new academic schedule entry
  Future<AcademicSchedule> createSchedule(
    Session session,
    int studentProfileId,
    String title,
    String type,
    DateTime startTime,
    DateTime endTime,
    String? location,
    bool isRecurring,
    String? rrule,
  ) async {
    // Validate student exists
    final student = await StudentProfile.db.findById(session, studentProfileId);
    if (student == null) {
      throw Exception('Student profile not found');
    }

    // Validate type
    if (!['class', 'exam', 'lab', 'workshop'].contains(type)) {
      throw Exception('Invalid type. Must be: class, exam, lab, or workshop');
    }

    // Validate times
    if (endTime.isBefore(startTime)) {
      throw Exception('End time must be after start time');
    }

    // Validate RRULE if recurring
    if (isRecurring && (rrule == null || rrule.isEmpty)) {
      throw Exception('RRULE is required for recurring events');
    }

    // Check for conflicts - find overlapping schedules
    final existingSchedules = await AcademicSchedule.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.deletedAt.equals(null),
    );

    // Check for time overlaps
    for (final existing in existingSchedules) {
      final hasOverlap = startTime.isBefore(existing.endTime) && 
                        endTime.isAfter(existing.startTime);
      if (hasOverlap) {
        throw Exception('Schedule conflict detected with: ${existing.title}');
      }
    }

    final schedule = AcademicSchedule(
      studentProfileId: studentProfileId,
      title: title,
      type: type,
      startTime: startTime,
      endTime: endTime,
      location: location,
      isRecurring: isRecurring,
      rrule: rrule,
      createdAt: DateTime.now(),
    );

    final saved = await AcademicSchedule.db.insertRow(session, schedule);
    session.log('Created academic schedule: ${saved.id}');
    return saved;
  }

  /// Get academic schedule by ID
  Future<AcademicSchedule?> getSchedule(Session session, int id) async {
    return await AcademicSchedule.db.findById(session, id);
  }

  /// Get all schedules for a student
  Future<List<AcademicSchedule>> getStudentSchedules(
    Session session,
    int studentProfileId,
    {bool includeDeleted = false}
  ) async {
    if (includeDeleted) {
      return await AcademicSchedule.db.find(
        session,
        where: (t) => t.studentProfileId.equals(studentProfileId),
        orderBy: (t) => t.startTime,
      );
    }

    return await AcademicSchedule.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.deletedAt.equals(null),
      orderBy: (t) => t.startTime,
    );
  }

  /// Get schedules for a date range
  Future<List<AcademicSchedule>> getSchedulesInRange(
    Session session,
    int studentProfileId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Get non-recurring events in range
    final nonRecurring = await AcademicSchedule.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.isRecurring.equals(false) &
          t.startTime.between(startDate, endDate) &
          t.deletedAt.equals(null),
      orderBy: (t) => t.startTime,
    );

    // Get all recurring events and expand them
    final recurring = await AcademicSchedule.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.isRecurring.equals(true) &
          t.deletedAt.equals(null),
    );

    // Get all recurring events and expand them manually
    final allEvents = <AcademicSchedule>[...nonRecurring];
    
    for (final event in recurring) {
      if (event.rrule != null) {
        // Simple expansion - check if event occurs on each day in range
        var currentDate = startDate;
        while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
          if (_eventOccursOnDate(event, currentDate)) {
            // Create instance for this date
            final instance = AcademicSchedule(
              id: event.id,
              studentProfileId: event.studentProfileId,
              title: event.title,
              type: event.type,
              location: event.location,
              rrule: event.rrule,
              startTime: DateTime(
                currentDate.year,
                currentDate.month,
                currentDate.day,
                event.startTime.hour,
                event.startTime.minute,
              ),
              endTime: DateTime(
                currentDate.year,
                currentDate.month,
                currentDate.day,
                event.endTime.hour,
                event.endTime.minute,
              ),
              isRecurring: event.isRecurring,
              createdAt: event.createdAt,
            );
            allEvents.add(instance);
          }
          currentDate = currentDate.add(const Duration(days: 1));
        }
      }
    }

    // Sort by start time
    allEvents.sort((a, b) => a.startTime.compareTo(b.startTime));
    return allEvents;
  }

  /// Check if recurring event occurs on given date
  bool _eventOccursOnDate(AcademicSchedule event, DateTime date) {
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

  /// Update academic schedule
  Future<AcademicSchedule> updateSchedule(
    Session session,
    int id,
    String? title,
    String? type,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    bool? isRecurring,
    String? rrule,
  ) async {
    final schedule = await AcademicSchedule.db.findById(session, id);
    if (schedule == null) {
      throw Exception('Schedule not found');
    }

    // Validate type if provided
    if (type != null && !['class', 'exam', 'lab', 'workshop'].contains(type)) {
      throw Exception('Invalid type');
    }

    // Build updated times
    final newStartTime = startTime ?? schedule.startTime;
    final newEndTime = endTime ?? schedule.endTime;

    if (newEndTime.isBefore(newStartTime)) {
      throw Exception('End time must be after start time');
    }

    // Check for conflicts (excluding this event)
    final existingSchedules = await AcademicSchedule.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(schedule.studentProfileId) &
          t.deletedAt.equals(null),
    );

    // Check for time overlaps
    for (final existing in existingSchedules) {
      if (existing.id == id) continue; // Skip self
      
      final hasOverlap = newStartTime.isBefore(existing.endTime) && 
                        newEndTime.isAfter(existing.startTime);
      if (hasOverlap) {
        throw Exception('Schedule conflict detected with: ${existing.title}');
      }
    }

    // Update fields
    if (title != null) schedule.title = title;
    if (type != null) schedule.type = type;
    if (startTime != null) schedule.startTime = startTime;
    if (endTime != null) schedule.endTime = endTime;
    if (location != null) schedule.location = location;
    if (isRecurring != null) schedule.isRecurring = isRecurring;
    if (rrule != null) schedule.rrule = rrule;

    final updated = await AcademicSchedule.db.updateRow(session, schedule);
    session.log('Updated academic schedule: $id');
    return updated;
  }

  /// Soft delete academic schedule
  Future<bool> deleteSchedule(Session session, int id) async {
    final schedule = await AcademicSchedule.db.findById(session, id);
    if (schedule == null) {
      return false;
    }

    schedule.deletedAt = DateTime.now();
    await AcademicSchedule.db.updateRow(session, schedule);

    session.log('Soft deleted academic schedule: $id');
    return true;
  }

  /// Check for schedule conflicts
  Future<List<AcademicSchedule>> checkConflicts(
    Session session,
    int studentProfileId,
    DateTime startTime,
    DateTime endTime,
    int? excludeId,
  ) async {
    final existingSchedules = await AcademicSchedule.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.deletedAt.equals(null),
    );

    final conflicts = <AcademicSchedule>[];
    
    for (final existing in existingSchedules) {
      if (excludeId != null && existing.id == excludeId) continue;
      
      final hasOverlap = startTime.isBefore(existing.endTime) && 
                        endTime.isAfter(existing.startTime);
      if (hasOverlap) {
        conflicts.add(existing);
      }
    }

    return conflicts;
  }

  /// Get schedules by type
  Future<List<AcademicSchedule>> getSchedulesByType(
    Session session,
    int studentProfileId,
    String type,
  ) async {
    return await AcademicSchedule.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.type.equals(type) &
          t.deletedAt.equals(null),
      orderBy: (t) => t.startTime,
    );
  }

  /// Restore soft-deleted schedule
  Future<AcademicSchedule> restoreSchedule(Session session, int id) async {
    final schedule = await AcademicSchedule.db.findById(session, id);
    if (schedule == null) {
      throw Exception('Schedule not found');
    }

    schedule.deletedAt = null;
    final updated = await AcademicSchedule.db.updateRow(session, schedule);
    
    session.log('Restored academic schedule: $id');
    return updated;
  }

  /// Get upcoming classes (next 7 days)
  Future<List<AcademicSchedule>> getUpcomingClasses(
    Session session,
    int studentProfileId,
  ) async {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));

    return await getSchedulesInRange(
      session,
      studentProfileId,
      now,
      nextWeek,
    );
  }

  /// Get today's schedule
  Future<List<AcademicSchedule>> getTodaysSchedule(
    Session session,
    int studentProfileId,
  ) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return await getSchedulesInRange(
      session,
      studentProfileId,
      today,
      tomorrow,
    );
  }
}