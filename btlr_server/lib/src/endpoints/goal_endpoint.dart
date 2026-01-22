import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for managing learning goals
class GoalEndpoint extends Endpoint {
  /// Create a new learning goal
  Future<LearningGoal> createGoal(
    Session session,
    int studentProfileId,
    String title,
    String category,
    String priority,
    String? description,
    double? estimatedHours,
    DateTime? deadline,
    String? tags,
  ) async {
    // Validate student exists
    final student = await StudentProfile.db.findById(session, studentProfileId);
    if (student == null) {
      throw Exception('Student profile not found');
    }

    // Validate category
    if (!['technical_skill', 'project', 'certification', 'soft_skill'].contains(category)) {
      throw Exception('Invalid category. Must be: technical_skill, project, certification, or soft_skill');
    }

    // Validate priority
    if (!['low', 'medium', 'high'].contains(priority)) {
      throw Exception('Invalid priority. Must be: low, medium, or high');
    }

    final goal = LearningGoal(
      studentProfileId: studentProfileId,
      title: title,
      description: description,
      category: category,
      status: 'not_started',
      priority: priority,
      estimatedHours: estimatedHours,
      actualHours: 0.0,
      deadline: deadline,
      tags: tags,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final saved = await LearningGoal.db.insertRow(session, goal);
    session.log('Created learning goal: ${saved.id}');
    return saved;
  }

  /// Get learning goal by ID
  Future<LearningGoal?> getGoal(Session session, int id) async {
    return await LearningGoal.db.findById(session, id);
  }

  /// Get all goals for a student
  Future<List<LearningGoal>> getStudentGoals(
    Session session,
    int studentProfileId,
    {String? status, String? priority, String? category}
  ) async {
    if (status != null && priority != null && category != null) {
      return await LearningGoal.db.find(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.status.equals(status) &
            t.priority.equals(priority) &
            t.category.equals(category),
        orderBy: (t) => t.priority,
      );
    } else if (status != null && priority != null) {
      return await LearningGoal.db.find(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.status.equals(status) &
            t.priority.equals(priority),
        orderBy: (t) => t.priority,
      );
    } else if (status != null && category != null) {
      return await LearningGoal.db.find(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.status.equals(status) &
            t.category.equals(category),
        orderBy: (t) => t.priority,
      );
    } else if (priority != null && category != null) {
      return await LearningGoal.db.find(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.priority.equals(priority) &
            t.category.equals(category),
        orderBy: (t) => t.priority,
      );
    } else if (status != null) {
      return await LearningGoal.db.find(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.status.equals(status),
        orderBy: (t) => t.priority,
      );
    } else if (priority != null) {
      return await LearningGoal.db.find(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.priority.equals(priority),
        orderBy: (t) => t.priority,
      );
    } else if (category != null) {
      return await LearningGoal.db.find(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.category.equals(category),
        orderBy: (t) => t.priority,
      );
    }

    return await LearningGoal.db.find(
      session,
      where: (t) => t.studentProfileId.equals(studentProfileId),
      orderBy: (t) => t.priority,
    );
  }

  /// Get active goals (in_progress or not_started)
  Future<List<LearningGoal>> getActiveGoals(
    Session session,
    int studentProfileId,
  ) async {
    return await LearningGoal.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          (t.status.equals('in_progress') | t.status.equals('not_started')),
      orderBy: (t) => t.priority,
    );
  }

  /// Get goals by category
  Future<List<LearningGoal>> getGoalsByCategory(
    Session session,
    int studentProfileId,
    String category,
  ) async {
    return await LearningGoal.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.category.equals(category),
      orderBy: (t) => t.priority,
    );
  }

  /// Update learning goal
  Future<LearningGoal> updateGoal(
    Session session,
    int id,
    String? title,
    String? description,
    String? category,
    String? status,
    String? priority,
    double? estimatedHours,
    double? actualHours,
    DateTime? deadline,
    String? tags,
  ) async {
    final goal = await LearningGoal.db.findById(session, id);
    if (goal == null) {
      throw Exception('Goal not found');
    }

    // Validate category if provided
    if (category != null && !['technical_skill', 'project', 'certification', 'soft_skill'].contains(category)) {
      throw Exception('Invalid category');
    }

    // Validate status if provided
    if (status != null && !['not_started', 'in_progress', 'completed', 'paused'].contains(status)) {
      throw Exception('Invalid status. Must be: not_started, in_progress, completed, or paused');
    }

    // Validate priority if provided
    if (priority != null && !['low', 'medium', 'high'].contains(priority)) {
      throw Exception('Invalid priority');
    }

    // Update fields
    if (title != null) goal.title = title;
    if (description != null) goal.description = description;
    if (category != null) goal.category = category;
    if (status != null) goal.status = status;
    if (priority != null) goal.priority = priority;
    if (estimatedHours != null) goal.estimatedHours = estimatedHours;
    if (actualHours != null) goal.actualHours = actualHours;
    if (deadline != null) goal.deadline = deadline;
    if (tags != null) goal.tags = tags;

    goal.updatedAt = DateTime.now();

    final updated = await LearningGoal.db.updateRow(session, goal);
    session.log('Updated learning goal: $id');
    return updated;
  }

  /// Mark goal as completed
  Future<LearningGoal> completeGoal(Session session, int id) async {
    final goal = await LearningGoal.db.findById(session, id);
    if (goal == null) {
      throw Exception('Goal not found');
    }

    goal.status = 'completed';
    goal.updatedAt = DateTime.now();

    final updated = await LearningGoal.db.updateRow(session, goal);
    session.log('Completed learning goal: $id');
    return updated;
  }

  /// Increment actual hours spent on goal
  Future<LearningGoal> addHours(
    Session session,
    int id,
    double hours,
  ) async {
    final goal = await LearningGoal.db.findById(session, id);
    if (goal == null) {
      throw Exception('Goal not found');
    }

    goal.actualHours = goal.actualHours + hours;
    goal.updatedAt = DateTime.now();

    final updated = await LearningGoal.db.updateRow(session, goal);
    session.log('Added $hours hours to goal: $id (total: ${goal.actualHours})');
    return updated;
  }

  /// Delete learning goal
  Future<bool> deleteGoal(Session session, int id) async {
    final goal = await LearningGoal.db.findById(session, id);
    if (goal == null) {
      return false;
    }

    await LearningGoal.db.deleteRow(session, goal);
    session.log('Deleted learning goal: $id');
    return true;
  }

  /// Get overdue goals
  Future<List<LearningGoal>> getOverdueGoals(
    Session session,
    int studentProfileId,
  ) async {
    final now = DateTime.now();
    return await LearningGoal.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          (t.status.equals('in_progress') | t.status.equals('not_started')) &
          (t.deadline < now),
      orderBy: (t) => t.deadline,
    );
  }

  /// Get goal progress statistics
  Future<Map<String, dynamic>> getGoalStats(
    Session session,
    int studentProfileId,
  ) async {
    final allGoals = await LearningGoal.db.find(
      session,
      where: (t) => t.studentProfileId.equals(studentProfileId),
    );

    final totalGoals = allGoals.length;
    final completed = allGoals.where((g) => g.status == 'completed').length;
    final inProgress = allGoals.where((g) => g.status == 'in_progress').length;
    final notStarted = allGoals.where((g) => g.status == 'not_started').length;
    final paused = allGoals.where((g) => g.status == 'paused').length;

    final totalEstimatedHours = allGoals
        .map((g) => g.estimatedHours ?? 0.0)
        .fold<double>(0.0, (sum, hours) => sum + hours);

    final totalActualHours = allGoals
        .map((g) => g.actualHours)
        .fold<double>(0.0, (sum, hours) => sum + hours);

    final byCategory = <String, int>{};
    for (final goal in allGoals) {
      byCategory[goal.category] = (byCategory[goal.category] ?? 0) + 1;
    }

    return {
      'totalGoals': totalGoals,
      'completed': completed,
      'inProgress': inProgress,
      'notStarted': notStarted,
      'paused': paused,
      'completionRate': totalGoals > 0 ? completed / totalGoals : 0.0,
      'totalEstimatedHours': totalEstimatedHours,
      'totalActualHours': totalActualHours,
      'byCategory': byCategory,
    };
  }

  /// Get goals by priority
  Future<List<LearningGoal>> getGoalsByPriority(
    Session session,
    int studentProfileId,
    String priority,
  ) async {
    return await LearningGoal.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.priority.equals(priority),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }
}