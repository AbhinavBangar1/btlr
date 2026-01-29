import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Service for discovering and managing opportunities
/// Handles scraping, relevance scoring, and auto-injection into schedules
class OpportunityService {
  /// Calculate relevance score based on student's learning goals
  /// Returns a score between 0.0 and 1.0
  static Future<double> calculateRelevance(
    Session session,
    Opportunity opportunity,
    int studentProfileId,
  ) async {
    final goals = await LearningGoal.db.find(
      session,
      where: (t) => t.studentProfileId.equals(studentProfileId),
    );

    if (goals.isEmpty) return 0.0;

    // Extract keywords from opportunity
    final oppKeywords = _extractKeywords(opportunity);
    double totalScore = 0.0;

    // Match against each learning goal
    for (final goal in goals) {
      final goalKeywords = _extractKeywordsFromGoal(goal);
      final matchScore = _calculateKeywordMatch(oppKeywords, goalKeywords);
      
      // Weight by goal priority
      final weight = goal.priority == 'high' ? 1.5 : 
                     goal.priority == 'medium' ? 1.0 : 0.5;
      
      totalScore += matchScore * weight;
    }

    // Normalize score (0-1)
    final normalizedScore = (totalScore / goals.length).clamp(0.0, 1.0);
    
    return normalizedScore;
  }

  /// Extract keywords from opportunity title, description, and tags
  static Set<String> _extractKeywords(Opportunity opp) {
    final keywords = <String>{};
    
    // Add title keywords
    keywords.addAll(_tokenize(opp.title.toLowerCase()));
    
    // Add description keywords
    if (opp.description != null) {
      keywords.addAll(_tokenize(opp.description!.toLowerCase()));
    }
    
    // Add tags
    if (opp.tags != null) {
      try {
        final tagText = opp.tags!.toLowerCase()
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('"', '')
            .replaceAll("'", '');
        keywords.addAll(_tokenize(tagText));
      } catch (e) {
        keywords.addAll(_tokenize(opp.tags!.toLowerCase()));
      }
    }

    return keywords;
  }

  /// Extract keywords from learning goal
  static Set<String> _extractKeywordsFromGoal(LearningGoal goal) {
    final keywords = <String>{};
    
    keywords.addAll(_tokenize(goal.title.toLowerCase()));
    
    if (goal.description != null) {
      keywords.addAll(_tokenize(goal.description!.toLowerCase()));
    }
    
    if (goal.tags != null) {
      try {
        final tagText = goal.tags!.toLowerCase()
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('"', '')
            .replaceAll("'", '');
        keywords.addAll(_tokenize(tagText));
      } catch (e) {
        keywords.addAll(_tokenize(goal.tags!.toLowerCase()));
      }
    }

    return keywords;
  }

  /// Simple tokenizer - splits text into words
  static List<String> _tokenize(String text) {
    return text
        .replaceAll(RegExp(r'[^\w\s]'), ' ') // Remove punctuation
        .split(RegExp(r'\s+'))                // Split on whitespace
        .where((w) => w.length > 2)           // Filter short words
        .toList();
  }

  /// Calculate keyword match score using Jaccard similarity
  static double _calculateKeywordMatch(Set<String> set1, Set<String> set2) {
    if (set1.isEmpty || set2.isEmpty) return 0.0;
    
    final intersection = set1.intersection(set2);
    final union = set1.union(set2);
    
    // Jaccard similarity: |A ∩ B| / |A ∪ B|
    return intersection.length / union.length;
  }

  /// Auto-inject opportunity prep time into daily schedule
  /// Creates time blocks for application preparation
  static Future<void> injectPrepTimeIntoSchedule(
    Session session,
    int opportunityId,
    int studentProfileId,
  ) async {
    final opportunity = await Opportunity.db.findById(session, opportunityId);
    if (opportunity == null) {
      throw Exception('Opportunity not found');
    }

    if (opportunity.deadline == null || opportunity.prepTimeMinutes == null) {
      session.log('Cannot inject prep time: missing deadline or prep time');
      return;
    }

    // Calculate how many days before deadline to start prep
    final now = DateTime.now();
    final daysUntilDeadline = opportunity.deadline!.difference(now).inDays;
    
    if (daysUntilDeadline <= 0) {
      session.log('Opportunity deadline has passed');
      return;
    }

    // Distribute prep time over available days (max 7 days)
    final prepDays = daysUntilDeadline.clamp(1, 7);
    final minutesPerDay = (opportunity.prepTimeMinutes! / prepDays).ceil();

    // Get or create daily plans for prep days
    for (int i = 0; i < prepDays; i++) {
      final prepDate = now.add(Duration(days: i));
      final normalizedDate = DateTime(prepDate.year, prepDate.month, prepDate.day);
      
      // Get existing plan or create new one
      var plan = await DailyPlan.db.findFirstRow(
        session,
        where: (t) =>
            t.studentProfileId.equals(studentProfileId) &
            t.planDate.equals(normalizedDate),
      );

      if (plan == null) {
        // Create new plan if doesn't exist
        plan = DailyPlan(
          studentProfileId: studentProfileId,
          planDate: normalizedDate,
          version: 1,
          reasoning: 'Auto-generated for opportunity prep: ${opportunity.title}',
          generatedAt: DateTime.now(),
        );
        plan = await DailyPlan.db.insertRow(session, plan);
      }

      // Find suitable time slot and create prep block
      await _createPrepBlock(
        session,
        plan.id!,
        opportunity,
        minutesPerDay,
        prepDate,
      );
    }

    session.log('Injected ${opportunity.title} prep into schedule');
  }

  /// Create a prep time block in the daily plan
  static Future<void> _createPrepBlock(
    Session session,
    int dailyPlanId,
    Opportunity opportunity,
    int durationMinutes,
    DateTime date,
  ) async {
    // Get existing time blocks for this plan
    final existingBlocks = await TimeBlock.db.find(
      session,
      where: (t) => t.dailyPlanId.equals(dailyPlanId),
      orderBy: (t) => t.startTime,
    );

    // Find a suitable time slot (simple: add at end of last block or start at 2 PM)
    DateTime startTime;
    
    if (existingBlocks.isEmpty) {
      // No blocks yet, start at 2 PM
      startTime = DateTime(date.year, date.month, date.day, 14, 0);
    } else {
      // Add after last block
      final lastBlock = existingBlocks.last;
      startTime = lastBlock.endTime.add(const Duration(minutes: 15)); // 15 min buffer
    }

    final endTime = startTime.add(Duration(minutes: durationMinutes));

    // Create the prep block
    final prepBlock = TimeBlock(
      dailyPlanId: dailyPlanId,
      title: '${opportunity.type.toUpperCase()} Prep: ${opportunity.title}',
      description: 'Preparation time for ${opportunity.organization ?? "opportunity"}',
      blockType: 'opportunity_prep',
      startTime: startTime,
      endTime: endTime,
      durationMinutes: durationMinutes,
    );

    await TimeBlock.db.insertRow(session, prepBlock);
  }

  /// Get all relevant opportunities for a student
  /// Filters by relevance score threshold
  static Future<List<Opportunity>> getRelevantOpportunities(
    Session session,
    int studentProfileId, {
    double minRelevance = 0.3,
  }) async {
    // Get all opportunities not yet ignored/rejected
    final allOpportunities = await Opportunity.db.find(
      session,
      where: (t) =>
          (t.studentProfileId.equals(studentProfileId) |
           t.studentProfileId.equals(null)) &
          (t.status.equals('discovered') |
           t.status.equals('interested')),
      orderBy: (t) => t.deadline,
    );

    final relevantOpps = <Opportunity>[];

    for (final opp in allOpportunities) {
      final relevance = await calculateRelevance(session, opp, studentProfileId);
      
      if (relevance >= minRelevance) {
        opp.relevanceScore = relevance;
        await Opportunity.db.updateRow(session, opp);
        relevantOpps.add(opp);
      }
    }

    // Sort by relevance score (highest first)
    relevantOpps.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

    return relevantOpps;
  }

  /// Mark opportunity as applied
  static Future<Opportunity> markAsApplied(
    Session session,
    int opportunityId,
  ) async {
    final opp = await Opportunity.db.findById(session, opportunityId);
    if (opp == null) {
      throw Exception('Opportunity not found');
    }

    opp.status = 'applied';
    opp.appliedAt = DateTime.now();
    
    return await Opportunity.db.updateRow(session, opp);
  }

  /// Mark opportunity as ignored
  static Future<Opportunity> markAsIgnored(
    Session session,
    int opportunityId,
  ) async {
    final opp = await Opportunity.db.findById(session, opportunityId);
    if (opp == null) {
      throw Exception('Opportunity not found');
    }

    opp.status = 'ignored';
    
    return await Opportunity.db.updateRow(session, opp);
  }

  /// Create a new opportunity manually
  static Future<Opportunity> createOpportunity(
    Session session, {
    required String title,
    required String type,
    String? description,
    String? organization,
    String? sourceUrl,
    DateTime? deadline,
    List<String>? tags,
    int? prepTimeMinutes,
  }) async {
    final opportunity = Opportunity(
      title: title,
      type: type,
      description: description,
      organization: organization,
      sourceUrl: sourceUrl,
      deadline: deadline,
      tags: tags?.toString(),
      prepTimeMinutes: prepTimeMinutes,
      discoveredAt: DateTime.now(),
    );

    return await Opportunity.db.insertRow(session, opportunity);
  }

  /// Get opportunities expiring soon (within N days)
  static Future<List<Opportunity>> getExpiringOpportunities(
    Session session,
    int studentProfileId, {
    int daysAhead = 7,
  }) async {
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: daysAhead));

    return await Opportunity.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.deadline.between(now, futureDate) &
          (t.status.equals('discovered') |
           t.status.equals('interested')),
      orderBy: (t) => t.deadline,
    );
  }

  /// Scrape opportunities (placeholder for actual implementation)
  static Future<List<Opportunity>> scrapeOpportunities(
    Session session,
    List<String> sources,
  ) async {
    // TODO: Implement actual scraping logic
    session.log('Scraping opportunities from: ${sources.join(", ")}');
    
    // This would use HTTP client to:
    // 1. Hit Devfolio API
    // 2. Scrape Unstop
    // 3. Check LinkedIn
    // 4. Parse RSS feeds
    
    return [];
  }
}