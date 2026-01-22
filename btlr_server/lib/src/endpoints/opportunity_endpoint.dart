import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for managing opportunities (internships, hackathons, scholarships)
class OpportunityEndpoint extends Endpoint {
  /// Create a new opportunity
  Future<Opportunity> createOpportunity(
    Session session,
    String title,
    String type,
    int? studentProfileId,
    String? description,
    String? organization,
    String? sourceUrl,
    DateTime? deadline,
    String? tags,
    int? prepTimeMinutes,
  ) async {
    // Validate student if provided
    if (studentProfileId != null) {
      final student = await StudentProfile.db.findById(session, studentProfileId);
      if (student == null) {
        throw Exception('Student profile not found');
      }
    }

    // Validate type
    if (!['internship', 'hackathon', 'scholarship', 'workshop', 'competition'].contains(type)) {
      throw Exception('Invalid type. Must be: internship, hackathon, scholarship, workshop, or competition');
    }

    final opportunity = Opportunity(
      studentProfileId: studentProfileId,
      title: title,
      type: type,
      description: description,
      organization: organization,
      sourceUrl: sourceUrl,
      deadline: deadline,
      tags: tags,
      relevanceScore: 0.0,
      status: 'discovered',
      prepTimeMinutes: prepTimeMinutes,
      discoveredAt: DateTime.now(),
    );

    final saved = await Opportunity.db.insertRow(session, opportunity);
    session.log('Created opportunity: ${saved.id}');
    return saved;
  }

  /// Get opportunity by ID
  Future<Opportunity?> getOpportunity(Session session, int id) async {
    return await Opportunity.db.findById(session, id);
  }

  /// Get all opportunities for a student
  Future<List<Opportunity>> getStudentOpportunities(
    Session session,
    int studentProfileId,
    {String? status, String? type}
  ) async {
    if (status != null && type != null) {
      return await Opportunity.db.find(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.status.equals(status) &
            t.type.equals(type),
        orderBy: (t) => t.relevanceScore,
        orderDescending: true,
      );
    } else if (status != null) {
      return await Opportunity.db.find(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.status.equals(status),
        orderBy: (t) => t.relevanceScore,
        orderDescending: true,
      );
    } else if (type != null) {
      return await Opportunity.db.find(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.type.equals(type),
        orderBy: (t) => t.relevanceScore,
        orderDescending: true,
      );
    }

    return await Opportunity.db.find(
      session,
      where: (t) => t.studentProfileId.equals(studentProfileId),
      orderBy: (t) => t.relevanceScore,
      orderDescending: true,
    );
  }

  /// Get unassigned opportunities (not yet matched to any student)
  Future<List<Opportunity>> getUnassignedOpportunities(
    Session session,
    {String? type}
  ) async {
    if (type != null) {
      return await Opportunity.db.find(
        session,
        where: (t) =>
            t.studentProfileId.equals(null) &
            t.type.equals(type),
        orderBy: (t) => t.discoveredAt,
        orderDescending: true,
      );
    }

    return await Opportunity.db.find(
      session,
      where: (t) => t.studentProfileId.equals(null),
      orderBy: (t) => t.discoveredAt,
      orderDescending: true,
    );
  }

  /// Get high-relevance opportunities (score > threshold)
  Future<List<Opportunity>> getRelevantOpportunities(
    Session session,
    int studentProfileId,
    {double minScore = 0.7}
  ) async {
    return await Opportunity.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          (t.relevanceScore>minScore) &
          t.status.notEquals('ignored'),
      orderBy: (t) => t.relevanceScore,
      orderDescending: true,
    );
  }

  /// Get opportunities by type
  Future<List<Opportunity>> getOpportunitiesByType(
    Session session,
    int studentProfileId,
    String type,
  ) async {
    return await Opportunity.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.type.equals(type),
      orderBy: (t) => t.relevanceScore,
      orderDescending: true,
    );
  }

  /// Get opportunities with upcoming deadlines
  Future<List<Opportunity>> getUpcomingDeadlines(
    Session session,
    int studentProfileId,
    {int daysAhead = 30}
  ) async {
    final now = DateTime.now();
    final future = now.add(Duration(days: daysAhead));

    return await Opportunity.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.deadline.between(now, future) &
          t.status.notEquals('ignored'),
      orderBy: (t) => t.deadline,
    );
  }

  /// Calculate and update relevance score for an opportunity
  Future<Opportunity> calculateRelevance(
    Session session,
    int opportunityId,
  ) async {
    final opportunity = await Opportunity.db.findById(session, opportunityId);
    if (opportunity == null) {
      throw Exception('Opportunity not found');
    }

    // Simple relevance calculation
    // You can enhance this based on student's goals
    double score = 0.5; // Base score
    
    if (opportunity.deadline != null) {
      final daysUntilDeadline = opportunity.deadline!.difference(DateTime.now()).inDays;
      if (daysUntilDeadline > 0 && daysUntilDeadline < 30) {
        score += 0.3; // Boost for upcoming deadline
      }
    }

    opportunity.relevanceScore = score;
    final updated = await Opportunity.db.updateRow(session, opportunity);
    
    session.log('Calculated relevance for opportunity: $opportunityId (score: ${updated.relevanceScore})');
    return updated;
  }

  /// Recalculate relevance for all opportunities
  Future<List<Opportunity>> recalculateAllRelevance(
    Session session,
    int studentProfileId,
  ) async {
    final opportunities = await Opportunity.db.find(
      session,
      where: (t) => t.studentProfileId.equals(studentProfileId),
    );

    final updated = <Opportunity>[];
    for (final opp in opportunities) {
      final recalculated = await calculateRelevance(session, opp.id!);
      updated.add(recalculated);
    }

    session.log('Recalculated relevance for ${updated.length} opportunities');
    return updated;
  }

  /// Get opportunities that can be auto-injected into schedule
  Future<List<Opportunity>> getInjectableOpportunities(
    Session session,
    int studentProfileId,
    DateTime targetDate,
  ) async {
    return await Opportunity.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          (t.relevanceScore>0.7) &
          t.status.equals('interested') &
          (t.deadline>targetDate),
      orderBy: (t) => t.relevanceScore,
      orderDescending: true,
      limit: 5,
    );
  }

  /// Update opportunity status
  Future<Opportunity> updateStatus(
    Session session,
    int id,
    String status,
  ) async {
    // Validate status
    if (!['discovered', 'interested', 'applied', 'rejected', 'accepted', 'ignored'].contains(status)) {
      throw Exception('Invalid status. Must be: discovered, interested, applied, rejected, accepted, or ignored');
    }

    final opportunity = await Opportunity.db.findById(session, id);
    if (opportunity == null) {
      throw Exception('Opportunity not found');
    }

    opportunity.status = status;
    
    // Set appliedAt if status is 'applied'
    if (status == 'applied' && opportunity.appliedAt == null) {
      opportunity.appliedAt = DateTime.now();
    }

    final updated = await Opportunity.db.updateRow(session, opportunity);
    session.log('Updated opportunity status: $id -> $status');
    return updated;
  }

  /// Assign opportunity to a student
  Future<Opportunity> assignToStudent(
    Session session,
    int opportunityId,
    int studentProfileId,
  ) async {
    // Validate student exists
    final student = await StudentProfile.db.findById(session, studentProfileId);
    if (student == null) {
      throw Exception('Student profile not found');
    }

    final opportunity = await Opportunity.db.findById(session, opportunityId);
    if (opportunity == null) {
      throw Exception('Opportunity not found');
    }

    opportunity.studentProfileId = studentProfileId;
    final updated = await Opportunity.db.updateRow(session, opportunity);
    
    session.log('Assigned opportunity $opportunityId to student $studentProfileId');
    return updated;
  }

  /// Update opportunity
  Future<Opportunity> updateOpportunity(
    Session session,
    int id,
    String? title,
    String? type,
    String? description,
    String? organization,
    String? sourceUrl,
    DateTime? deadline,
    String? tags,
    String? status,
    int? prepTimeMinutes,
    double? relevanceScore,
  ) async {
    final opportunity = await Opportunity.db.findById(session, id);
    if (opportunity == null) {
      throw Exception('Opportunity not found');
    }

    // Validate type if provided
    if (type != null && !['internship', 'hackathon', 'scholarship', 'workshop', 'competition'].contains(type)) {
      throw Exception('Invalid type');
    }

    // Validate status if provided
    if (status != null && !['discovered', 'interested', 'applied', 'rejected', 'accepted', 'ignored'].contains(status)) {
      throw Exception('Invalid status');
    }

    // Update fields
    if (title != null) opportunity.title = title;
    if (type != null) opportunity.type = type;
    if (description != null) opportunity.description = description;
    if (organization != null) opportunity.organization = organization;
    if (sourceUrl != null) opportunity.sourceUrl = sourceUrl;
    if (deadline != null) opportunity.deadline = deadline;
    if (tags != null) opportunity.tags = tags;
    if (status != null) {
      opportunity.status = status;
      if (status == 'applied' && opportunity.appliedAt == null) {
        opportunity.appliedAt = DateTime.now();
      }
    }
    if (prepTimeMinutes != null) opportunity.prepTimeMinutes = prepTimeMinutes;
    if (relevanceScore != null) opportunity.relevanceScore = relevanceScore;

    final updated = await Opportunity.db.updateRow(session, opportunity);
    session.log('Updated opportunity: $id');
    return updated;
  }

  /// Delete opportunity
  Future<bool> deleteOpportunity(Session session, int id) async {
    final opportunity = await Opportunity.db.findById(session, id);
    if (opportunity == null) {
      return false;
    }

    await Opportunity.db.deleteRow(session, opportunity);
    session.log('Deleted opportunity: $id');
    return true;
  }

  /// Search opportunities by tags
  Future<List<Opportunity>> searchByTags(
    Session session,
    int studentProfileId,
    List<String> searchTags,
  ) async {
    // Simple implementation - for production, use full-text search
    final allOpportunities = await Opportunity.db.find(
      session,
      where: (t) => t.studentProfileId.equals(studentProfileId),
    );

    final matching = allOpportunities.where((opp) {
      if (opp.tags == null) return false;
      // Assuming tags is JSON array stored as string
      return searchTags.any((tag) => opp.tags!.toLowerCase().contains(tag.toLowerCase()));
    }).toList();

    matching.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    return matching;
  }

  /// Get opportunities by status
  Future<List<Opportunity>> getOpportunitiesByStatus(
    Session session,
    int studentProfileId,
    String status,
  ) async {
    return await Opportunity.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.status.equals(status),
      orderBy: (t) => t.relevanceScore,
      orderDescending: true,
    );
  }

  /// Get opportunity statistics
  Future<Map<String, dynamic>> getOpportunityStats(
    Session session,
    int studentProfileId,
  ) async {
    final opportunities = await Opportunity.db.find(
      session,
      where: (t) => t.studentProfileId.equals(studentProfileId),
    );

    final byType = <String, int>{};
    final byStatus = <String, int>{};
    
    for (final opp in opportunities) {
      byType[opp.type] = (byType[opp.type] ?? 0) + 1;
      byStatus[opp.status] = (byStatus[opp.status] ?? 0) + 1;
    }

    final highRelevance = opportunities.where((o) => o.relevanceScore > 0.7).length;
    final withDeadlines = opportunities.where((o) => o.deadline != null).length;
    final upcoming = opportunities.where((o) {
      if (o.deadline == null) return false;
      return o.deadline!.isAfter(DateTime.now()) && 
             o.deadline!.isBefore(DateTime.now().add(const Duration(days: 30)));
    }).length;

    final avgRelevance = opportunities.isEmpty 
        ? 0.0 
        : opportunities.map((o) => o.relevanceScore).reduce((a, b) => a + b) / opportunities.length;

    return {
      'total': opportunities.length,
      'byType': byType,
      'byStatus': byStatus,
      'highRelevance': highRelevance,
      'withDeadlines': withDeadlines,
      'upcomingDeadlines': upcoming,
      'averageRelevanceScore': avgRelevance,
    };
  }

  /// Bulk import opportunities (for scraper)
  Future<List<Opportunity>> bulkImport(
    Session session,
    int? studentProfileId,
    List<Map<String, dynamic>> opportunitiesData,
  ) async {
    // Validate student if provided
    if (studentProfileId != null) {
      final student = await StudentProfile.db.findById(session, studentProfileId);
      if (student == null) {
        throw Exception('Student profile not found');
      }
    }

    final imported = <Opportunity>[];

    for (final data in opportunitiesData) {
      try {
        final opportunity = Opportunity(
          studentProfileId: studentProfileId,
          title: data['title'] as String,
          type: data['type'] as String,
          description: data['description'] as String?,
          organization: data['organization'] as String?,
          sourceUrl: data['sourceUrl'] as String?,
          deadline: data['deadline'] != null 
              ? DateTime.parse(data['deadline'] as String) 
              : null,
          tags: data['tags'] as String?,
          relevanceScore: 0.0,
          status: 'discovered',
          prepTimeMinutes: data['prepTimeMinutes'] as int?,
          discoveredAt: DateTime.now(),
        );

        final saved = await Opportunity.db.insertRow(session, opportunity);
        imported.add(saved);
      } catch (e) {
        session.log('Failed to import opportunity: $e', level: LogLevel.warning);
      }
    }

    session.log('Bulk imported ${imported.length}/${opportunitiesData.length} opportunities');
    return imported;
  }
}