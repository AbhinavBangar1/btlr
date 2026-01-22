import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btlr_client/btlr_client.dart';
import 'api_client_provider.dart';

/// Opportunities provider
final opportunitiesProvider = StateNotifierProvider<OpportunitiesNotifier, AsyncValue<List<Opportunity>>>((ref) {
  return OpportunitiesNotifier(ref);
});

/// Opportunities notifier
class OpportunitiesNotifier extends StateNotifier<AsyncValue<List<Opportunity>>> {
  final Ref ref;

  OpportunitiesNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadOpportunities();
  }

  /// Load all opportunities for current student
  Future<void> loadOpportunities() async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    
    try {
      final endpoint = ref.read(opportunityEndpointProvider);
      final opportunities = await endpoint.getStudentOpportunities(studentId);
      state = AsyncValue.data(opportunities);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Create new opportunity
  Future<Opportunity?> createOpportunity({
    required String title,
    required String type,
    String? description,
    String? organization,
    String? sourceUrl,
    DateTime? deadline,
    String? tags,
    int? prepTimeMinutes,
  }) async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) return null;

    try {
      final endpoint = ref.read(opportunityEndpointProvider);
      final opportunity = await endpoint.createOpportunity(
        title,
        type,
        studentId,
        description,
        organization,
        sourceUrl,
        deadline,
        tags,
        prepTimeMinutes,
      );
      
      // Reload opportunities
      await loadOpportunities();
      return opportunity;
    } catch (e) {
      return null;
    }
  }

  /// Update opportunity
  Future<Opportunity?> updateOpportunity(
    int opportunityId, {
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
  }) async {
    try {
      final endpoint = ref.read(opportunityEndpointProvider);
      final updated = await endpoint.updateOpportunity(
        opportunityId,
        title,
        type,
        description,
        organization,
        sourceUrl,
        deadline,
        tags,
        status,
        prepTimeMinutes,
        relevanceScore,
      );
      
      // Reload opportunities
      await loadOpportunities();
      return updated;
    } catch (e) {
      return null;
    }
  }

  /// Update opportunity status
  Future<bool> updateStatus(int opportunityId, String status) async {
    try {
      final endpoint = ref.read(opportunityEndpointProvider);
      await endpoint.updateStatus(opportunityId, status);
      await loadOpportunities();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Calculate relevance score
  Future<bool> calculateRelevance(int opportunityId) async {
    try {
      final endpoint = ref.read(opportunityEndpointProvider);
      await endpoint.calculateRelevance(opportunityId);
      await loadOpportunities();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Recalculate all relevance scores
  Future<bool> recalculateAllRelevance() async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) return false;

    try {
      final endpoint = ref.read(opportunityEndpointProvider);
      await endpoint.recalculateAllRelevance(studentId);
      await loadOpportunities();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Delete opportunity
  Future<bool> deleteOpportunity(int opportunityId) async {
    try {
      final endpoint = ref.read(opportunityEndpointProvider);
      final deleted = await endpoint.deleteOpportunity(opportunityId);
      if (deleted) {
        await loadOpportunities();
      }
      return deleted;
    } catch (e) {
      return false;
    }
  }

  /// Reload opportunities
  Future<void> reload() async {
    await loadOpportunities();
  }
}

/// Relevant opportunities (high relevance score)
final relevantOpportunitiesProvider = FutureProvider<List<Opportunity>>((ref) async {
  final studentId = ref.watch(currentStudentIdProvider);
  if (studentId == null) return [];

  final endpoint = ref.read(opportunityEndpointProvider);
  return await endpoint.getRelevantOpportunities(studentId, minScore: 0.7);
});

/// Upcoming deadlines
final upcomingDeadlinesProvider = FutureProvider.family<List<Opportunity>, int>((ref, daysAhead) async {
  final studentId = ref.watch(currentStudentIdProvider);
  if (studentId == null) return [];

  final endpoint = ref.read(opportunityEndpointProvider);
  return await endpoint.getUpcomingDeadlines(studentId, daysAhead: daysAhead);
});

/// Default 30-day upcoming deadlines
final defaultUpcomingDeadlinesProvider = FutureProvider<List<Opportunity>>((ref) async {
  return ref.watch(upcomingDeadlinesProvider(30).future);
});

/// Opportunities by type
final opportunitiesByTypeProvider = Provider.family<List<Opportunity>, String>((ref, type) {
  final opportunitiesAsync = ref.watch(opportunitiesProvider);
  return opportunitiesAsync.when(
    data: (opportunities) => opportunities.where((o) => o.type == type).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
});

/// Opportunities by status
final opportunitiesByStatusProvider = Provider.family<List<Opportunity>, String>((ref, status) {
  final opportunitiesAsync = ref.watch(opportunitiesProvider);
  return opportunitiesAsync.when(
    data: (opportunities) => opportunities.where((o) => o.status == status).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
});

/// Discovered opportunities (new)
final discoveredOpportunitiesProvider = Provider<List<Opportunity>>((ref) {
  return ref.watch(opportunitiesByStatusProvider('discovered'));
});

/// Interested opportunities
final interestedOpportunitiesProvider = Provider<List<Opportunity>>((ref) {
  return ref.watch(opportunitiesByStatusProvider('interested'));
});

/// Applied opportunities
final appliedOpportunitiesProvider = Provider<List<Opportunity>>((ref) {
  return ref.watch(opportunitiesByStatusProvider('applied'));
});

/// Hackathons
final hackathonsProvider = Provider<List<Opportunity>>((ref) {
  return ref.watch(opportunitiesByTypeProvider('hackathon'));
});

/// Internships
final internshipsProvider = Provider<List<Opportunity>>((ref) {
  return ref.watch(opportunitiesByTypeProvider('internship'));
});

/// Scholarships
final scholarshipsProvider = Provider<List<Opportunity>>((ref) {
  return ref.watch(opportunitiesByTypeProvider('scholarship'));
});

/// Injectable opportunities (for auto-scheduling)
final injectableOpportunitiesProvider = FutureProvider.family<List<Opportunity>, DateTime>((ref, targetDate) async {
  final studentId = ref.watch(currentStudentIdProvider);
  if (studentId == null) return [];

  final endpoint = ref.read(opportunityEndpointProvider);
  return await endpoint.getInjectableOpportunities(studentId, targetDate);
});

/// Opportunity statistics
final opportunityStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final studentId = ref.watch(currentStudentIdProvider);
  if (studentId == null) {
    return {
      'total': 0,
      'byType': <String, int>{},
      'byStatus': <String, int>{},
      'highRelevance': 0,
      'withDeadlines': 0,
      'upcomingDeadlines': 0,
      'averageRelevanceScore': 0.0,
    };
  }

  final endpoint = ref.read(opportunityEndpointProvider);
  return await endpoint.getOpportunityStats(studentId);
});

/// Unassigned opportunities (for scraper/admin)
final unassignedOpportunitiesProvider = FutureProvider<List<Opportunity>>((ref) async {
  final endpoint = ref.read(opportunityEndpointProvider);
  return await endpoint.getUnassignedOpportunities();
});