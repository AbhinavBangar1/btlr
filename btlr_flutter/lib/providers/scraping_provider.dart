// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:btlr_client/btlr_client.dart';
// import 'api_client_provider.dart';

// /// Scraped content provider
// final scrapedContentProvider = StateNotifierProvider<ScrapedContentNotifier, AsyncValue<List<ScrapedContent>>>((ref) {
//   final notifier = ScrapedContentNotifier(ref);
//   // Auto-initialize when provider is created
//   Future.microtask(() => notifier.init());
//   return notifier;
// });

// /// Scraped content notifier
// class ScrapedContentNotifier extends StateNotifier<AsyncValue<List<ScrapedContent>>> {
//   final Ref ref;

//   ScrapedContentNotifier(this.ref) : super(const AsyncValue.loading());

//   /// Initialize scraping
//   Future<void> init() async {
//     await loadScrapedContent();
//     // Only scrape if no content exists
//     final currentContent = state.value ?? [];
//     if (currentContent.isEmpty) {
//       await scrapeAll();
//     }
//   }

//   /// Load scraped content for current student
//   Future<void> loadScrapedContent() async {
//     final studentId = ref.read(currentStudentIdProvider);
//     if (studentId == null) {
//       state = const AsyncValue.data([]);
//       return;
//     }

//     state = const AsyncValue.loading();
//     try {
//       final endpoint = ref.read(scrapingEndpointProvider);
//       final content = await endpoint.getScrapedContent(
//         studentId,
//         null, // platform
//         false, // isRead
//         50, // limit
//       );
//       state = AsyncValue.data(content);
//     } catch (e, stack) {
//       state = AsyncValue.error(e, stack);
//     }
//   }

//   /// Scrape all platforms
//   Future<void> scrapeAll() async {
//     final studentId = ref.read(currentStudentIdProvider);
//     if (studentId == null) return;

//     try {
//       final endpoint = ref.read(scrapingEndpointProvider);
      
//       // AUTO-CREATE DEFAULT SCRAPING PREFERENCES
//       await endpoint.addCustomScrapingUrl(studentId, 'devpost', null);
//       await endpoint.addCustomScrapingUrl(studentId, 'internshala', null);
      
//       // Now scrape
//       await endpoint.scrapeAllPlatforms(studentId);
//       await loadScrapedContent();
//     } catch (e, st) {
//       print('Scraping error: $e');
//     }
//   }

//   /// Scrape specific platform
//   Future<void> scrapePlatform(String platform) async {
//     final studentId = ref.read(currentStudentIdProvider);
//     if (studentId == null) return;

//     try {
//       final endpoint = ref.read(scrapingEndpointProvider);
//       await endpoint.scrapePlatform(studentId, platform);
//       await loadScrapedContent();
//     } catch (e) {
//       // Handle error
//     }
//   }

//   /// Mark content as read
//   Future<void> markAsRead(int contentId) async {
//     try {
//       final endpoint = ref.read(scrapingEndpointProvider);
//       await endpoint.markAsRead(contentId);
//       await loadScrapedContent();
//     } catch (e) {
//       // Handle error
//     }
//   }

//   /// Add custom scraping URL
//   Future<bool> addCustomUrl(String platform, String? customUrl) async {
//     final studentId = ref.read(currentStudentIdProvider);
//     if (studentId == null) return false;

//     try {
//       final endpoint = ref.read(scrapingEndpointProvider);
//       final success = await endpoint.addCustomScrapingUrl(
//         studentId,
//         platform,
//         customUrl ?? '',
//       );
//       if (success) {
//         await loadScrapedContent();
//       }
//       return success;
//     } catch (e) {
//       return false;
//     }
//   }
// }

// /// Scraped content by platform
// final scrapedContentByPlatformProvider = Provider.family<List<ScrapedContent>, String>((ref, platform) {
//   final contentAsync = ref.watch(scrapedContentProvider);
//   return contentAsync.when(
//     data: (content) => content.where((c) => c.platform == platform).toList(),
//     loading: () => [],
//     error: (_, __) => [],
//   );
// });

// /// Unread scraped content count
// final unreadScrapedContentCountProvider = Provider<int>((ref) {
//   final contentAsync = ref.watch(scrapedContentProvider);
//   return contentAsync.when(
//     data: (content) => content.where((c) => !c.isRead).length,
//     loading: () => 0,
//     error: (_, __) => 0,
//   );
// });












import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btlr_client/btlr_client.dart';
import 'api_client_provider.dart';
import 'student_provider.dart';

/// Scraped content provider
final scrapedContentProvider = StateNotifierProvider<ScrapedContentNotifier, AsyncValue<List<ScrapedContent>>>((ref) {
  final notifier = ScrapedContentNotifier(ref);
  // Auto-initialize when provider is created
  Future.microtask(() => notifier.init());
  return notifier;
});

/// Scraped content notifier
class ScrapedContentNotifier extends StateNotifier<AsyncValue<List<ScrapedContent>>> {
  final Ref ref;

  ScrapedContentNotifier(this.ref) : super(const AsyncValue.loading());

  /// Initialize scraping
  Future<void> init() async {
    // SAFETY CHECK: Verify user has coding platform usernames configured
    final profileAsync = ref.read(studentProfileProvider);
    final profile = profileAsync.value;
    
    if (profile == null) {
      state = const AsyncValue.data([]);
      return;
    }
    
    // Check if at least one username is configured
    if (profile.githubUsername == null && 
        profile.leetcodeUsername == null && 
        profile.codeforcesUsername == null) {
      print('⚠️ No usernames configured - skipping scraping');
      state = const AsyncValue.data([]);
      return;
    }
    
    await loadScrapedContent();
    // Only scrape if no content exists
    final currentContent = state.value ?? [];
    if (currentContent.isEmpty) {
      await scrapeAll();
    }
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
      
      // AUTO-CREATE DEFAULT SCRAPING PREFERENCES
      await endpoint.addCustomScrapingUrl(studentId, 'devpost', null);
      await endpoint.addCustomScrapingUrl(studentId, 'internshala', null);
      
      // Now scrape
      await endpoint.scrapeAllPlatforms(studentId);
      await loadScrapedContent();
    } catch (e, st) {
      print('Scraping error: $e');
    }
  }

  /// Scrape specific platform
  Future<void> scrapePlatform(String platform) async {
    final studentId = ref.read(currentStudentIdProvider);
    if (studentId == null) return;

    try {
      final endpoint = ref.read(scrapingEndpointProvider);
      await endpoint.scrapePlatform(studentId, platform);
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
final scrapedContentByPlatformProvider = Provider.family<List<ScrapedContent>, String>((ref, platform) {
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
