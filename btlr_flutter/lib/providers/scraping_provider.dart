import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btlr_client/btlr_client.dart';
import 'api_client_provider.dart';

/// Scraped content provider
final scrapedContentProvider =
    StateNotifierProvider<ScrapedContentNotifier, AsyncValue<List<ScrapedContent>>>((ref) {
  return ScrapedContentNotifier(ref);
});

/// Scraped content notifier
class ScrapedContentNotifier extends StateNotifier<AsyncValue<List<ScrapedContent>>> {
  final Ref ref;

  ScrapedContentNotifier(this.ref) : super(const AsyncValue.loading()) {
    _init();
  }

  // 🔥 NEW: Auto initialize scraping
  Future<void> _init() async {
    await loadScrapedContent();
    await scrapeAll();
  }

  /// Load scraped content for current student
  Future<void> loadScrapedContent() async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final endpoint = ref.read(scrapingEndpointProvider);
      final content = await endpoint.getScrapedContent(
        studentId,
        null, // platform
        false, // isRead
        50, // limit
      );
      state = AsyncValue.data(content);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Scrape all platforms
  Future<void> scrapeAll() async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) return;

    try {
      final endpoint = ref.read(scrapingEndpointProvider);

      // 🔥 AUTO-CREATE DEFAULT SCRAPING PREFERENCES
      await endpoint.addCustomScrapingUrl(
        studentId,
        'devpost',
        'null',
      );

      await endpoint.addCustomScrapingUrl(
        studentId,
        'internshala',
        'null',
      );

      await endpoint.addCustomScrapingUrl(
        studentId,
        'angellist',
        'null',
      );

      // Now scrape
      await endpoint.scrapeAllPlatforms(studentId);

      await loadScrapedContent();
    } catch (e, st) {
      print('Scraping error: $e\n$st');
    }
  }

  /// Scrape specific platform
  Future<void> scrapePlatform(String platform) async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) return;

    try {
      final endpoint = ref.read(scrapingEndpointProvider);
      await endpoint.scrapePlatform(
        studentId,
        platform,
      );
      await loadScrapedContent();
    } catch (e) {
      // Handle error
    }
  }

  /// Mark content as read
  Future<void> markAsRead(int contentId) async {
    try {
      final endpoint = ref.read(scrapingEndpointProvider);
      await endpoint.markAsRead(contentId);
      await loadScrapedContent();
    } catch (e) {
      // Handle error
    }
  }

  /// Add custom scraping URL
  Future<bool> addCustomUrl(String platform, String? customUrl) async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) return false;

    try {
      final endpoint = ref.read(scrapingEndpointProvider);
      final success = await endpoint.addCustomScrapingUrl(
        studentId,
        platform,
        customUrl ?? '',
      );
      if (success) {
        await loadScrapedContent();
      }
      return success;
    } catch (e) {
      return false;
    }
  }
}

/// Scraped content by platform
final scrapedContentByPlatformProvider =
    Provider.family<List<ScrapedContent>, String>((ref, platform) {
  final contentAsync = ref.watch(scrapedContentProvider);
  return contentAsync.when(
    data: (content) => content.where((c) => c.platform == platform).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Unread scraped content count
final unreadScrapedContentCountProvider = Provider<int>((ref) {
  final contentAsync = ref.watch(scrapedContentProvider);
  return contentAsync.when(
    data: (content) => content.where((c) => !c.isRead).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});
