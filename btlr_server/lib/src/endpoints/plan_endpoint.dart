// import 'package:serverpod/serverpod.dart';
// import '../generated/protocol.dart';
// import '../services/planning_service.dart';

// /// Endpoint for managing daily plans and time blocks
// class PlanEndpoint extends Endpoint {
//   /// Generate a daily plan for a specific date
//   Future<DailyPlan> generatePlan(
//     Session session,
//     int studentProfileId,
//     DateTime date,
//   ) async {
//     try {
//       final plan = await PlanningService.generateDailyPlan(
//         session,
//         studentProfileId,
//         date,
//       );
//       session.log('Generated plan for ${date.toIso8601String()}');
//       return plan;
//     } catch (e) {
//       session.log('Failed to generate plan: $e', level: LogLevel.error);
//       rethrow;
//     }
//   }

//   /// Generate plans for multiple days ahead
//   Future<List<DailyPlan>> generateMultiplePlans(
//     Session session,
//     int studentProfileId,
//     int daysAhead,
//   ) async {
//     try {
//       final plans = await PlanningService.generateMultiplePlans(
//         session,
//         studentProfileId,
//         daysAhead,
//       );
//       session.log('Generated $daysAhead plans');
//       return plans;
//     } catch (e) {
//       session.log('Failed to generate multiple plans: $e', level: LogLevel.error);
//       rethrow;
//     }
//   }

//   /// Get daily plan by ID
//   Future<DailyPlan?> getPlan(Session session, int id) async {
//     return await DailyPlan.db.findById(session, id);
//   }

//   /// Get plan for a specific date
//   Future<DailyPlan?> getPlanByDate(
//     Session session,
//     int studentProfileId,
//     DateTime date,
//   ) async {
//     final normalizedDate = DateTime(date.year, date.month, date.day);
//     return await DailyPlan.db.findFirstRow(
//       session,
//       where: (t) =>
//           t.studentProfileId.equals(studentProfileId) &
//           t.planDate.equals(normalizedDate),
//       orderBy: (t) => t.version,
//       orderDescending: true,
//     );
//   }

//   /// Get all plans for a student
//   Future<List<DailyPlan>> getStudentPlans(
//     Session session,
//     int studentProfileId,
//     {int limit = 30}
//   ) async {
//     return await DailyPlan.db.find(
//       session,
//       where: (t) => t.studentProfileId.equals(studentProfileId),
//       orderBy: (t) => t.planDate,
//       orderDescending: true,
//       limit: limit,
//     );
//   }

//   /// Get plans in date range
//   Future<List<DailyPlan>> getPlansInRange(
//     Session session,
//     int studentProfileId,
//     DateTime startDate,
//     DateTime endDate,
//   ) async {
//     final normalizedStart = DateTime(startDate.year, startDate.month, startDate.day);
//     final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day);

//     return await DailyPlan.db.find(
//       session,
//       where: (t) =>
//           t.studentProfileId.equals(studentProfileId) &
//           t.planDate.between(normalizedStart, normalizedEnd),
//       orderBy: (t) => t.planDate,
//     );
//   }

//   /// Get time blocks for a plan
//   Future<List<TimeBlock>> getPlanBlocks(
//     Session session,
//     int dailyPlanId,
//   ) async {
//     return await TimeBlock.db.find(
//       session,
//       where: (t) => t.dailyPlanId.equals(dailyPlanId),
//       orderBy: (t) => t.startTime,
//     );
//   }

//   /// Get a specific time block
//   Future<TimeBlock?> getBlock(Session session, int id) async {
//     return await TimeBlock.db.findById(session, id);
//   }

//   /// Get time blocks for a date range
//   Future<List<TimeBlock>> getBlocksInRange(
//     Session session,
//     int studentProfileId,
//     DateTime startDate,
//     DateTime endDate,
//   ) async {
//     // Get all plans in range
//     final plans = await getPlansInRange(
//       session,
//       studentProfileId,
//       startDate,
//       endDate,
//     );

//     if (plans.isEmpty) return [];

//     // Get all blocks for these plans
//     final planIds = plans.map((p) => p.id!).toList();
    
//     final blocks = <TimeBlock>[];
//     for (final planId in planIds) {
//       final planBlocks = await TimeBlock.db.find(
//         session,
//         where: (t) => t.dailyPlanId.equals(planId),
//       );
//       blocks.addAll(planBlocks);
//     }

//     // Sort by start time
//     blocks.sort((a, b) => a.startTime.compareTo(b.startTime));
//     return blocks;
//   }

//   /// Update a time block
//   Future<TimeBlock> updateBlock(
//     Session session,
//     int id,
//     String? title,
//     String? description,
//     DateTime? startTime,
//     DateTime? endTime,
//     int? durationMinutes,
//     bool? isCompleted,
//     String? completionStatus,
//     int? actualDurationMinutes,
//     int? energyLevel,
//     String? notes,
//     String? missReason,
//   ) async {
//     final block = await TimeBlock.db.findById(session, id);
//     if (block == null) {
//       throw Exception('Time block not found');
//     }

//     // Validate completionStatus if provided
//     if (completionStatus != null && !['pending', 'completed', 'missed', 'postponed'].contains(completionStatus)) {
//       throw Exception('Invalid completionStatus. Must be: pending, completed, missed, or postponed');
//     }

//     // Validate energyLevel if provided
//     if (energyLevel != null && (energyLevel < 1 || energyLevel > 5)) {
//       throw Exception('Energy level must be between 1 and 5');
//     }

//     // Update fields
//     if (title != null) block.title = title;
//     if (description != null) block.description = description;
//     if (startTime != null) block.startTime = startTime;
//     if (endTime != null) block.endTime = endTime;
//     if (durationMinutes != null) block.durationMinutes = durationMinutes;
//     if (isCompleted != null) block.isCompleted = isCompleted;
//     if (completionStatus != null) block.completionStatus = completionStatus;
//     if (actualDurationMinutes != null) block.actualDurationMinutes = actualDurationMinutes;
//     if (energyLevel != null) block.energyLevel = energyLevel;
//     if (notes != null) block.notes = notes;
//     if (missReason != null) block.missReason = missReason;

//     // Recalculate duration if times changed
//     if (startTime != null || endTime != null) {
//       block.durationMinutes = block.endTime.difference(block.startTime).inMinutes;
//     }

//     final updated = await TimeBlock.db.updateRow(session, block);
//     session.log('Updated time block: $id');
//     return updated;
//   }

//   /// Mark time block as completed
//   Future<TimeBlock> completeBlock(
//     Session session,
//     int id,
//     int? actualDurationMinutes,
//     int? energyLevel,
//     String? notes,
//   ) async {
//     final block = await TimeBlock.db.findById(session, id);
//     if (block == null) {
//       throw Exception('Time block not found');
//     }

//     block.isCompleted = true;
//     block.completionStatus = 'completed';
//     if (actualDurationMinutes != null) block.actualDurationMinutes = actualDurationMinutes;
//     if (energyLevel != null) block.energyLevel = energyLevel;
//     if (notes != null) block.notes = notes;

//     final updated = await TimeBlock.db.updateRow(session, block);
//     session.log('Completed time block: $id');
//     return updated;
//   }

//   /// Mark time block as missed
//   Future<TimeBlock> missBlock(
//     Session session,
//     int id,
//     String missReason,
//     String? notes,
//   ) async {
//     final block = await TimeBlock.db.findById(session, id);
//     if (block == null) {
//       throw Exception('Time block not found');
//     }

//     block.completionStatus = 'missed';
//     block.missReason = missReason;
//     if (notes != null) block.notes = notes;

//     final updated = await TimeBlock.db.updateRow(session, block);
//     session.log('Marked time block as missed: $id');
//     return updated;
//   }

//   /// Delete a time block
//   Future<bool> deleteBlock(Session session, int id) async {
//     final block = await TimeBlock.db.findById(session, id);
//     if (block == null) {
//       return false;
//     }

//     await TimeBlock.db.deleteRow(session, block);
//     session.log('Deleted time block: $id');
//     return true;
//   }

//   /// Regenerate a plan (creates new version)
//   Future<DailyPlan> regeneratePlan(
//     Session session,
//     int dailyPlanId,
//   ) async {
//     final oldPlan = await DailyPlan.db.findById(session, dailyPlanId);
//     if (oldPlan == null) {
//       throw Exception('Plan not found');
//     }

//     // Generate new plan for same date
//     final newPlan = await PlanningService.generateDailyPlan(
//       session,
//       oldPlan.studentProfileId,
//       oldPlan.planDate,
//     );

//     session.log('Regenerated plan: ${oldPlan.id} -> ${newPlan.id} (v${newPlan.version})');
//     return newPlan;
//   }

//   /// Get today's plan (convenience method)
//   Future<DailyPlan?> getTodaysPlan(
//     Session session,
//     int studentProfileId,
//   ) async {
//     final today = DateTime.now();
//     return await getPlanByDate(session, studentProfileId, today);
//   }

//   /// Get or generate today's plan
//   Future<DailyPlan> getOrGenerateTodaysPlan(
//     Session session,
//     int studentProfileId,
//   ) async {
//     final today = DateTime.now();
    
//     // Try to get existing plan
//     final existingPlan = await getPlanByDate(session, studentProfileId, today);
//     if (existingPlan != null) {
//       return existingPlan;
//     }

//     // Generate new plan
//     return await generatePlan(session, studentProfileId, today);
//   }

//   /// Get upcoming time blocks (next 24 hours)
//   Future<List<TimeBlock>> getUpcomingBlocks(
//     Session session,
//     int studentProfileId,
//   ) async {
//     final now = DateTime.now();
//     final tomorrow = now.add(const Duration(hours: 24));

//     return await getBlocksInRange(
//       session,
//       studentProfileId,
//       now,
//       tomorrow,
//     );
//   }

//   /// Get current time block (what should be happening now)
//   Future<TimeBlock?> getCurrentBlock(
//     Session session,
//     int studentProfileId,
//   ) async {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);

//     // Get today's plan
//     final plan = await getPlanByDate(session, studentProfileId, today);
//     if (plan == null) return null;

//     // Find block that contains current time
//     final blocks = await TimeBlock.db.find(
//       session,
//       where: (t) =>
//           t.dailyPlanId.equals(plan.id!) &
//           (t.startTime<now) &
//           (t.endTime > now),
//     );

//     return blocks.isNotEmpty ? blocks.first : null;
//   }

//   /// Get blocks by completion status
//   Future<List<TimeBlock>> getBlocksByStatus(
//     Session session,
//     int dailyPlanId,
//     String completionStatus,
//   ) async {
//     return await TimeBlock.db.find(
//       session,
//       where: (t) =>
//           t.dailyPlanId.equals(dailyPlanId) &
//           t.completionStatus.equals(completionStatus),
//       orderBy: (t) => t.startTime,
//     );
//   }

//   /// Get plan statistics
//   Future<Map<String, dynamic>> getPlanStats(
//     Session session,
//     int studentProfileId,
//   ) async {
//     final plans = await DailyPlan.db.find(
//       session,
//       where: (t) => t.studentProfileId.equals(studentProfileId),
//     );

//     final totalPlans = plans.length;
//     final totalPlannedMinutes = plans
//         .map((p) => p.totalPlannedMinutes)
//         .fold<int>(0, (sum, mins) => sum + mins);

//     return {
//       'totalPlans': totalPlans,
//       'totalPlannedMinutes': totalPlannedMinutes,
//       'averagePlannedMinutesPerDay': totalPlans > 0 ? totalPlannedMinutes / totalPlans : 0,
//     };
//   }
// }











import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/planning_service.dart';

/// Endpoint for managing daily plans and time blocks
class PlanEndpoint extends Endpoint {
  /// Generate a daily plan for a specific date
  Future<DailyPlan> generatePlan(
    Session session,
    int studentProfileId,
    DateTime date,
  ) async {
    try {
      session.log('=== Starting generatePlan ===');
      session.log('Student ID: $studentProfileId');
      session.log('Date: ${date.toIso8601String()}');

      // Validate student profile exists
      final profile = await StudentProfile.db.findById(session, studentProfileId);
      if (profile == null) {
        session.log('Student profile not found: $studentProfileId', level: LogLevel.error);
        throw Exception('Student profile not found');
      }

      session.log('Student profile found: ${profile.name}');

      final plan = await PlanningService.generateDailyPlan(
        session,
        studentProfileId,
        date,
      );
      
      session.log('Plan generated successfully: ID ${plan.id}');
      session.log('=== End generatePlan ===');
      return plan;
    } catch (e, stack) {
      session.log('=== ERROR in generatePlan ===', level: LogLevel.error);
      session.log('Error: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      session.log('Student ID: $studentProfileId', level: LogLevel.error);
      session.log('Date: ${date.toIso8601String()}', level: LogLevel.error);
      rethrow;
    }
  }

  /// Generate plans for multiple days ahead
  Future<List<DailyPlan>> generateMultiplePlans(
    Session session,
    int studentProfileId,
    int daysAhead,
  ) async {
    try {
      session.log('=== Starting generateMultiplePlans ===');
      session.log('Student ID: $studentProfileId, Days: $daysAhead');

      // Validate inputs
      if (daysAhead < 1 || daysAhead > 30) {
        throw Exception('daysAhead must be between 1 and 30');
      }

      final profile = await StudentProfile.db.findById(session, studentProfileId);
      if (profile == null) {
        throw Exception('Student profile not found');
      }

      final plans = await PlanningService.generateMultiplePlans(
        session,
        studentProfileId,
        daysAhead,
      );
      
      session.log('Generated ${plans.length} plans successfully');
      session.log('=== End generateMultiplePlans ===');
      return plans;
    } catch (e, stack) {
      session.log('=== ERROR in generateMultiplePlans ===', level: LogLevel.error);
      session.log('Error: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      rethrow;
    }
  }

  /// Get daily plan by ID
  Future<DailyPlan?> getPlan(Session session, int id) async {
    try {
      return await DailyPlan.db.findById(session, id);
    } catch (e, stack) {
      session.log('Error getting plan $id: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      return null;
    }
  }

  /// Get plan for a specific date
  Future<DailyPlan?> getPlanByDate(
    Session session,
    int studentProfileId,
    DateTime date,
  ) async {
    try {
      final normalizedDate = DateTime(date.year, date.month, date.day);
      session.log('Getting plan for date: $normalizedDate, student: $studentProfileId');
      
      return await DailyPlan.db.findFirstRow(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.planDate.equals(normalizedDate),
        orderBy: (t) => t.version,
        orderDescending: true,
      );
    } catch (e, stack) {
      session.log('Error in getPlanByDate: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      return null;
    }
  }

  /// Get all plans for a student
  Future<List<DailyPlan>> getStudentPlans(
    Session session,
    int studentProfileId,
    {int limit = 30}
  ) async {
    try {
      if (limit < 1 || limit > 100) {
        limit = 30;
      }

      return await DailyPlan.db.find(
        session,
        where: (t) => t.studentProfileId.equals(studentProfileId),
        orderBy: (t) => t.planDate,
        orderDescending: true,
        limit: limit,
      );
    } catch (e, stack) {
      session.log('Error getting student plans: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      return [];
    }
  }

  /// Get plans in date range
  Future<List<DailyPlan>> getPlansInRange(
    Session session,
    int studentProfileId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final normalizedStart = DateTime(startDate.year, startDate.month, startDate.day);
      final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day);

      if (normalizedEnd.isBefore(normalizedStart)) {
        throw Exception('End date must be after start date');
      }

      return await DailyPlan.db.find(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.planDate.between(normalizedStart, normalizedEnd),
        orderBy: (t) => t.planDate,
      );
    } catch (e, stack) {
      session.log('Error getting plans in range: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      return [];
    }
  }

  /// Get time blocks for a plan
  Future<List<TimeBlock>> getPlanBlocks(
    Session session,
    int dailyPlanId,
  ) async {
    try {
      return await TimeBlock.db.find(
        session,
        where: (t) => t.dailyPlanId.equals(dailyPlanId),
        orderBy: (t) => t.startTime,
      );
    } catch (e, stack) {
      session.log('Error getting plan blocks: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      return [];
    }
  }

  /// Get a specific time block
  Future<TimeBlock?> getBlock(Session session, int id) async {
    try {
      return await TimeBlock.db.findById(session, id);
    } catch (e) {
      session.log('Error getting block $id: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Get time blocks for a date range
  Future<List<TimeBlock>> getBlocksInRange(
    Session session,
    int studentProfileId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      // Get all plans in range
      final plans = await getPlansInRange(
        session,
        studentProfileId,
        startDate,
        endDate,
      );

      if (plans.isEmpty) return [];

      // Get all blocks for these plans
      final blocks = <TimeBlock>[];
      for (final plan in plans) {
        if (plan.id == null) continue;
        
        try {
          final planBlocks = await TimeBlock.db.find(
            session,
            where: (t) => t.dailyPlanId.equals(plan.id!),
          );
          blocks.addAll(planBlocks);
        } catch (e) {
          session.log('Error getting blocks for plan ${plan.id}: $e', level: LogLevel.warning);
        }
      }

      // Sort by start time
      blocks.sort((a, b) => a.startTime.compareTo(b.startTime));
      return blocks;
    } catch (e, stack) {
      session.log('Error getting blocks in range: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      return [];
    }
  }

  /// Update a time block
  Future<TimeBlock> updateBlock(
    Session session,
    int id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    bool? isCompleted,
    String? completionStatus,
    int? actualDurationMinutes,
    int? energyLevel,
    String? notes,
    String? missReason,
  ) async {
    try {
      final block = await TimeBlock.db.findById(session, id);
      if (block == null) {
        throw Exception('Time block not found');
      }

      // Validate completionStatus if provided
      if (completionStatus != null && 
          !['pending', 'completed', 'missed', 'postponed'].contains(completionStatus)) {
        throw Exception('Invalid completionStatus. Must be: pending, completed, missed, or postponed');
      }

      // Validate energyLevel if provided
      if (energyLevel != null && (energyLevel < 1 || energyLevel > 5)) {
        throw Exception('Energy level must be between 1 and 5');
      }

      // Validate time range if both provided
      if (startTime != null && endTime != null) {
        if (endTime.isBefore(startTime) || endTime.isAtSameMomentAs(startTime)) {
          throw Exception('End time must be after start time');
        }
      }

      // Update fields
      if (title != null) block.title = title;
      if (description != null) block.description = description;
      if (startTime != null) block.startTime = startTime;
      if (endTime != null) block.endTime = endTime;
      if (durationMinutes != null && durationMinutes > 0) block.durationMinutes = durationMinutes;
      if (isCompleted != null) block.isCompleted = isCompleted;
      if (completionStatus != null) block.completionStatus = completionStatus;
      if (actualDurationMinutes != null && actualDurationMinutes > 0) {
        block.actualDurationMinutes = actualDurationMinutes;
      }
      if (energyLevel != null) block.energyLevel = energyLevel;
      if (notes != null) block.notes = notes;
      if (missReason != null) block.missReason = missReason;

      // Recalculate duration if times changed
      if (startTime != null || endTime != null) {
        final duration = block.endTime.difference(block.startTime).inMinutes;
        if (duration > 0) {
          block.durationMinutes = duration;
        }
      }

      final updated = await TimeBlock.db.updateRow(session, block);
      session.log('Updated time block: $id');
      return updated;
    } catch (e, stack) {
      session.log('Error updating block $id: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      rethrow;
    }
  }

  /// Mark time block as completed
  Future<TimeBlock> completeBlock(
    Session session,
    int id,
    int? actualDurationMinutes,
    int? energyLevel,
    String? notes,
  ) async {
    try {
      final block = await TimeBlock.db.findById(session, id);
      if (block == null) {
        throw Exception('Time block not found');
      }

      if (energyLevel != null && (energyLevel < 1 || energyLevel > 5)) {
        throw Exception('Energy level must be between 1 and 5');
      }

      block.isCompleted = true;
      block.completionStatus = 'completed';
      if (actualDurationMinutes != null && actualDurationMinutes > 0) {
        block.actualDurationMinutes = actualDurationMinutes;
      }
      if (energyLevel != null) block.energyLevel = energyLevel;
      if (notes != null) block.notes = notes;

      final updated = await TimeBlock.db.updateRow(session, block);
      session.log('Completed time block: $id');
      return updated;
    } catch (e, stack) {
      session.log('Error completing block $id: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      rethrow;
    }
  }

  /// Mark time block as missed
  Future<TimeBlock> missBlock(
    Session session,
    int id,
    String missReason,
    String? notes,
  ) async {
    try {
      final block = await TimeBlock.db.findById(session, id);
      if (block == null) {
        throw Exception('Time block not found');
      }

      if (missReason.trim().isEmpty) {
        throw Exception('Miss reason is required');
      }

      block.completionStatus = 'missed';
      block.missReason = missReason;
      if (notes != null) block.notes = notes;

      final updated = await TimeBlock.db.updateRow(session, block);
      session.log('Marked time block as missed: $id');
      return updated;
    } catch (e, stack) {
      session.log('Error marking block as missed $id: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      rethrow;
    }
  }

  /// Delete a time block
  Future<bool> deleteBlock(Session session, int id) async {
    try {
      final block = await TimeBlock.db.findById(session, id);
      if (block == null) {
        return false;
      }

      await TimeBlock.db.deleteRow(session, block);
      session.log('Deleted time block: $id');
      return true;
    } catch (e, stack) {
      session.log('Error deleting block $id: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      return false;
    }
  }

  /// Regenerate a plan (creates new version)
  Future<DailyPlan> regeneratePlan(
    Session session,
    int dailyPlanId,
  ) async {
    try {
      session.log('=== Starting regeneratePlan ===');
      session.log('Plan ID: $dailyPlanId');

      final oldPlan = await DailyPlan.db.findById(session, dailyPlanId);
      if (oldPlan == null) {
        throw Exception('Plan not found');
      }

      session.log('Regenerating plan for date: ${oldPlan.planDate}');

      // Generate new plan for same date
      final newPlan = await PlanningService.generateDailyPlan(
        session,
        oldPlan.studentProfileId,
        oldPlan.planDate,
      );

      session.log('Regenerated plan: ${oldPlan.id} -> ${newPlan.id} (v${newPlan.version})');
      session.log('=== End regeneratePlan ===');
      return newPlan;
    } catch (e, stack) {
      session.log('=== ERROR in regeneratePlan ===', level: LogLevel.error);
      session.log('Error: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      rethrow;
    }
  }

  /// Get today's plan (convenience method)
  Future<DailyPlan?> getTodaysPlan(
    Session session,
    int studentProfileId,
  ) async {
    try {
      final today = DateTime.now();
      session.log('Getting today\'s plan for student: $studentProfileId');
      return await getPlanByDate(session, studentProfileId, today);
    } catch (e, stack) {
      session.log('Error getting today\'s plan: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      return null;
    }
  }

  /// Get or generate today's plan
  Future<DailyPlan> getOrGenerateTodaysPlan(
    Session session,
    int studentProfileId,
  ) async {
    try {
      session.log('=== Starting getOrGenerateTodaysPlan ===');
      session.log('Student ID: $studentProfileId');

      final today = DateTime.now();
      
      // Validate student profile exists
      final profile = await StudentProfile.db.findById(session, studentProfileId);
      if (profile == null) {
        session.log('Student profile not found: $studentProfileId', level: LogLevel.error);
        throw Exception('Student profile not found');
      }

      // Try to get existing plan
      final existingPlan = await getPlanByDate(session, studentProfileId, today);
      if (existingPlan != null) {
        session.log('Found existing plan: ID ${existingPlan.id}');
        session.log('=== End getOrGenerateTodaysPlan (existing) ===');
        return existingPlan;
      }

      // Generate new plan
      session.log('No existing plan found, generating new plan');
      final newPlan = await generatePlan(session, studentProfileId, today);
      session.log('=== End getOrGenerateTodaysPlan (new) ===');
      return newPlan;
    } catch (e, stack) {
      session.log('=== ERROR in getOrGenerateTodaysPlan ===', level: LogLevel.error);
      session.log('Error: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      rethrow;
    }
  }

  /// Get upcoming time blocks (next 24 hours)
  Future<List<TimeBlock>> getUpcomingBlocks(
    Session session,
    int studentProfileId,
  ) async {
    try {
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(hours: 24));

      return await getBlocksInRange(
        session,
        studentProfileId,
        now,
        tomorrow,
      );
    } catch (e, stack) {
      session.log('Error getting upcoming blocks: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      return [];
    }
  }

  /// Get current time block (what should be happening now)
  Future<TimeBlock?> getCurrentBlock(
    Session session,
    int studentProfileId,
  ) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Get today's plan
      final plan = await getPlanByDate(session, studentProfileId, today);
      if (plan == null || plan.id == null) return null;

      // Find block that contains current time
      final blocks = await TimeBlock.db.find(
        session,
        where: (t) =>
            t.dailyPlanId.equals(plan.id!) &
            (t.startTime < now) &
            (t.endTime > now),
      );

      return blocks.isNotEmpty ? blocks.first : null;
    } catch (e, stack) {
      session.log('Error getting current block: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      return null;
    }
  }

  /// Get blocks by completion status
  Future<List<TimeBlock>> getBlocksByStatus(
    Session session,
    int dailyPlanId,
    String completionStatus,
  ) async {
    try {
      if (!['pending', 'completed', 'missed', 'postponed'].contains(completionStatus)) {
        throw Exception('Invalid completion status');
      }

      return await TimeBlock.db.find(
        session,
        where: (t) =>
            t.dailyPlanId.equals(dailyPlanId) &
            t.completionStatus.equals(completionStatus),
        orderBy: (t) => t.startTime,
      );
    } catch (e, stack) {
      session.log('Error getting blocks by status: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      return [];
    }
  }

  /// Get plan statistics
  Future<Map<String, dynamic>> getPlanStats(
    Session session,
    int studentProfileId,
  ) async {
    try {
      final plans = await DailyPlan.db.find(
        session,
        where: (t) => t.studentProfileId.equals(studentProfileId),
      );

      final totalPlans = plans.length;
      final totalPlannedMinutes = plans
          .map((p) => p.totalPlannedMinutes)
          .fold<int>(0, (sum, mins) => sum + mins);

      return {
        'totalPlans': totalPlans,
        'totalPlannedMinutes': totalPlannedMinutes,
        'averagePlannedMinutesPerDay': totalPlans > 0 
            ? (totalPlannedMinutes / totalPlans).round() 
            : 0,
      };
    } catch (e, stack) {
      session.log('Error getting plan stats: $e', level: LogLevel.error);
      session.log('Stack trace: $stack', level: LogLevel.error);
      return {
        'totalPlans': 0,
        'totalPlannedMinutes': 0,
        'averagePlannedMinutesPerDay': 0,
      };
    }
  }
}