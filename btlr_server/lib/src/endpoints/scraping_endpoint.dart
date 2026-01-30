// import 'package:serverpod/serverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:html/parser.dart' as html_parser;
// // Import your generated protocol files
// import '../generated/protocol.dart';

// class ScrapingEndpoint extends Endpoint {
  
//   // Add a custom scraping URL for a user
//   Future<bool> addCustomScrapingUrl(
//     Session session,
//     int userId,
//     String platform,
//     String customUrl,
//   ) async {
//     try {
//       // Check if preference already exists
//       var existing = await UserScrapingPreference.db.findFirstRow(
//         session,
//         where: (t) => (t.userId.equals(userId)) & (t.platform.equals(platform)),
//       );

//       if (existing != null) {
//         // Update existing
//         existing.customUrl = customUrl;
//         existing.isActive = true;
//         await UserScrapingPreference.db.updateRow(session, existing);
//       } else {
//         // Create new
//         var preference = UserScrapingPreference(
//           userId: userId,
//           platform: platform,
//           customUrl: customUrl,
//           isActive: true,
//         );
//         await UserScrapingPreference.db.insertRow(session, preference);
//       }
//       return true;
//     } catch (e) {
//       session.log('Error adding custom scraping URL: $e');
//       return false;
//     }
//   }

//   // Get all scraping preferences for a user
//   Future<List<UserScrapingPreference>> getUserScrapingPreferences(
//     Session session,
//     int userId,
//   ) async {
//     return await UserScrapingPreference.db.find(
//       session,
//       where: (t) => t.userId.equals(userId),
//     );
//   }

//   // Scrape content from all active platforms for a user
//   Future<List<ScrapedContent>> scrapeAllPlatforms(
//     Session session,
//     int userId,
//   ) async {
//     var preferences = await getUserScrapingPreferences(
//       session,
//       userId,
//     );

//     List<ScrapedContent> allContent = [];

//     for (var pref in preferences) {
//       if (!pref.isActive) continue;

//       var content = await _scrapePlatform(
//         session,
//         userId,
//         pref.platform,
//         pref.customUrl,
//       );
      
//       allContent.addAll(content);
//     }

//     return allContent;
//   }

//   // Scrape a specific platform
//   Future<List<ScrapedContent>> scrapePlatform(
//     Session session,
//     int userId,
//     String platform,
//   ) async {
//     return await _scrapePlatform(
//       session,
//       userId,
//       platform,
//       null,
//     );
//   }

//   // Get scraped content for user with filters
//   Future<List<ScrapedContent>> getScrapedContent(
//     Session session,
//     int userId,
//     String? platform,
//     bool? isRead,
//     int limit,
//   ) async {
//     var query = ScrapedContent.db.find(
//       session,
//       where: (t) {
//         var condition = t.userId.equals(userId);
//         if (platform != null) {
//           condition = condition & t.platform.equals(platform);
//         }
//         if (isRead != null) {
//           condition = condition & t.isRead.equals(isRead);
//         }
//         return condition;
//       },
//       orderBy: (t) => t.scrapedAt,
//       orderDescending: true,
//       limit: limit,
//     );

//     return await query;
//   }

//   // Mark content as read
//   Future<bool> markAsRead(
//     Session session,
//     int contentId,
//   ) async {
//     try {
//       var content = await ScrapedContent.db.findById(session, contentId);
//       if (content == null) return false;

//       content.isRead = true;
//       await ScrapedContent.db.updateRow(session, content);
//       return true;
//     } catch (e) {
//       session.log('Error marking content as read: $e');
//       return false;
//     }
//   }

//   // Private method to handle platform-specific scraping
//   Future<List<ScrapedContent>> _scrapePlatform(
//     Session session,
//     int userId,
//     String platform,
//     String? customUrl,
//   ) async {
//     try {
//       switch (platform.toLowerCase()) {
//         case 'devpost':
//           return await _scrapeDevpost(session, userId, customUrl);
//         case 'internshala':
//           return await _scrapeInternshala(session, userId, customUrl);
//         case 'linkedin':
//           return await _scrapeLinkedIn(session, userId, customUrl);
//         case 'angellist':
//           return await _scrapeAngelList(session, userId, customUrl);
//         default:
//           if (customUrl != null) {
//             return await _scrapeGeneric(session, userId, platform, customUrl);
//           }
//           return [];
//       }
//     } catch (e) {
//       session.log('Error scraping $platform: $e');
//       return [];
//     }
//   }

//   // Devpost scraper
//   Future<List<ScrapedContent>> _scrapeDevpost(
//     Session session,
//     int userId,
//     String? customUrl,
//   ) async {
//     var url = customUrl ?? 'https://devpost.com/hackathons?status=open';
//     var response = await http.get(Uri.parse(url));
    
//     if (response.statusCode != 200) {
//       throw Exception('Failed to load Devpost');
//     }

//     var document = html_parser.parse(response.body);
//     List<ScrapedContent> contents = [];

//     // Scrape hackathon listings
//     var hackathons = document.querySelectorAll('.challenge-listing');
    
//     for (var hackathon in hackathons.take(10)) {
//       try {
//         var titleElement = hackathon.querySelector('.challenge-title');
//         var linkElement = hackathon.querySelector('a');
//         var descElement = hackathon.querySelector('.challenge-description');

//         if (titleElement != null && linkElement != null) {
//           var content = ScrapedContent(
//             userId: userId,
//             platform: 'devpost',
//             title: titleElement.text.trim(),
//             summary: descElement?.text.trim() ?? 'No description available',
//             sourceUrl: 'https://devpost.com${linkElement.attributes['href']}',
//             isRead: false,
//           );

//           await ScrapedContent.db.insertRow(session, content);
//           contents.add(content);
//         }
//       } catch (e) {
//         session.log('Error parsing Devpost item: $e');
//         continue;
//       }
//     }

//     return contents;
//   }

//   // Internshala scraper
//   Future<List<ScrapedContent>> _scrapeInternshala(
//     Session session,
//     int userId,
//     String? customUrl,
//   ) async {
//     var url = customUrl ?? 'https://internshala.com/internships';
//     var response = await http.get(Uri.parse(url));
    
//     if (response.statusCode != 200) {
//       throw Exception('Failed to load Internshala');
//     }

//     var document = html_parser.parse(response.body);
//     List<ScrapedContent> contents = [];

//     // Scrape internship listings
//     var internships = document.querySelectorAll('.internship_meta');
    
//     for (var internship in internships.take(10)) {
//       try {
//         var titleElement = internship.querySelector('.job-internship-name');
//         var companyElement = internship.querySelector('.company-name');
//         var linkElement = internship.querySelector('a');

//         if (titleElement != null && linkElement != null) {
//           var summary = companyElement?.text.trim() ?? 'Company information not available';
          
//           var content = ScrapedContent(
//             userId: userId,
//             platform: 'internshala',
//             title: titleElement.text.trim(),
//             summary: summary,
//             sourceUrl: 'https://internshala.com${linkElement.attributes['href']}',
//             isRead: false,
//           );

//           await ScrapedContent.db.insertRow(session, content);
//           contents.add(content);
//         }
//       } catch (e) {
//         session.log('Error parsing Internshala item: $e');
//         continue;
//       }
//     }

//     return contents;
//   }

//   // LinkedIn scraper (limited without auth)
//   Future<List<ScrapedContent>> _scrapeLinkedIn(
//     Session session,
//     int userId,
//     String? customUrl,
//   ) async {
//     // LinkedIn requires authentication for most content
//     // This is a placeholder - you'll need LinkedIn API or scraping with auth
//     session.log('LinkedIn scraping requires API access or authentication');
    
//     // For now, return a message about setting up LinkedIn integration
//     var content = ScrapedContent(
//       userId: userId,
//       platform: 'linkedin',
//       title: 'LinkedIn Integration Required',
//       summary: 'LinkedIn requires API access or authentication. Please set up LinkedIn Developer credentials.',
//       sourceUrl: 'https://www.linkedin.com/developers/',
//       isRead: false,
//     );
    
//     await ScrapedContent.db.insertRow(session, content);
//     return [content];
//   }

//   // AngelList scraper
//   Future<List<ScrapedContent>> _scrapeAngelList(
//     Session session,
//     int userId,
//     String? customUrl,
//   ) async {
//     var url = customUrl ?? 'https://angel.co/jobs';
//     var response = await http.get(Uri.parse(url));
    
//     if (response.statusCode != 200) {
//       throw Exception('Failed to load AngelList');
//     }

//     var document = html_parser.parse(response.body);
//     List<ScrapedContent> contents = [];

//     // AngelList structure varies, this is a generic approach
//     var jobs = document.querySelectorAll('[data-test="JobSearchResult"]');
    
//     for (var job in jobs.take(10)) {
//       try {
//         var titleElement = job.querySelector('h2');
//         var companyElement = job.querySelector('[data-test="JobCompanyName"]');
//         var linkElement = job.querySelector('a');

//         if (titleElement != null && linkElement != null) {
//           var content = ScrapedContent(
//             userId: userId,
//             platform: 'angellist',
//             title: titleElement.text.trim(),
//             summary: companyElement?.text.trim() ?? 'No company info',
//             sourceUrl: linkElement.attributes['href'] ?? url,
//             isRead: false,
//           );

//           await ScrapedContent.db.insertRow(session, content);
//           contents.add(content);
//         }
//       } catch (e) {
//         session.log('Error parsing AngelList item: $e');
//         continue;
//       }
//     }

//     return contents;
//   }

//   // Generic scraper for custom URLs
//   Future<List<ScrapedContent>> _scrapeGeneric(
//     Session session,
//     int userId,
//     String platform,
//     String url,
//   ) async {
//     var response = await http.get(Uri.parse(url));
    
//     if (response.statusCode != 200) {
//       throw Exception('Failed to load $url');
//     }

//     var document = html_parser.parse(response.body);
//     List<ScrapedContent> contents = [];

//     // Generic scraping - look for common patterns
//     var articles = document.querySelectorAll('article, .post, .item, .card');
    
//     for (var article in articles.take(5)) {
//       try {
//         // Try to find title
//         var titleElement = article.querySelector('h1, h2, h3, .title');
//         // Try to find description
//         var descElement = article.querySelector('p, .description, .summary');
//         // Try to find link
//         var linkElement = article.querySelector('a');

//         if (titleElement != null) {
//           var content = ScrapedContent(
//             userId: userId,
//             platform: platform,
//             title: titleElement.text.trim(),
//             summary: descElement?.text.trim() ?? 'No description available',
//             sourceUrl: linkElement?.attributes['href'] ?? url,
//             isRead: false,
//           );

//           await ScrapedContent.db.insertRow(session, content);
//           contents.add(content);
//         }
//       } catch (e) {
//         session.log('Error parsing generic content: $e');
//         continue;
//       }
//     }

//     return contents;
//   }

//   // Delete old scraped content (cleanup)
//   Future<int> deleteOldContent(
//     Session session,
//     int userId,
//     int daysOld,
//   ) async {
//     var cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
    
//     var oldContent = await ScrapedContent.db.find(
//       session,
//       where: (t) => (t.userId.equals(userId)) & (t.scrapedAt > cutoffDate),
//     );

//     for (var content in oldContent) {
//       await ScrapedContent.db.deleteRow(session, content);
//     }

//     return oldContent.length;
//   }
// }










import 'dart:async';
import 'package:serverpod/serverpod.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import '../generated/protocol.dart';
import 'dart:convert';


class ScrapingEndpoint extends Endpoint {
  static final http.Client _client = http.Client();

  static const Map<String, String> _defaultHeaders = {
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
        '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept-Language': 'en-US,en;q=0.9',
    'Accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
    'Connection': 'keep-alive',
  };

  Future<http.Response> _safeGet(String url) async {
    try {
      return await _client
          .get(Uri.parse(url), headers: _defaultHeaders)
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw Exception('Timeout while fetching $url');
    }
  }

  Future<bool> _insertIfNotExists(
      Session session, ScrapedContent content) async {
    var existing = await ScrapedContent.db.findFirstRow(
      session,
      where: (t) =>
          (t.userId.equals(content.userId)) &
          (t.sourceUrl.equals(content.sourceUrl)),
    );

    if (existing == null) {
      await ScrapedContent.db.insertRow(session, content);
      return true;
    }
    return false;
  }

Future<bool> addCustomScrapingUrl(
  Session session,
  int userId,
  String platform,
  String? customUrl, // Make this nullable
) async {
  try {
    var existing = await UserScrapingPreference.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.platform.equals(platform),
    );

    if (existing != null) {
      existing.customUrl = customUrl ?? ''; // Handle null
      existing.isActive = true;
      await UserScrapingPreference.db.updateRow(session, existing);
    } else {
      var preference = UserScrapingPreference(
        userId: userId,
        platform: platform,
        customUrl: customUrl ?? '', // Handle null
        isActive: true,
      );
      await UserScrapingPreference.db.insertRow(session, preference);
    }
    return true;
  } catch (e, st) {
    session.log('Error adding custom scraping URL: $e');
    return false;
  }
}


  Future<List<UserScrapingPreference>> getUserScrapingPreferences(
      Session session, int userId) async {
    return await UserScrapingPreference.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );
  }

// Future<List<ScrapedContent>> scrapeAllPlatforms(
//     Session session,
//     int userId,
//   ) async {
//     var preferences = await getUserScrapingPreferences(session, userId);
//     session.log('Preferences found: ${preferences.length}');

//     List<ScrapedContent> allContent = [];

//     for (var pref in preferences) {
//       if (!pref.isActive) continue;

//       try {
//         // FIX: Pass null if customUrl is empty
//         String? effectiveUrl = (pref.customUrl == null || pref.customUrl!.isEmpty) ? null : pref.customUrl;
//         var content = await _scrapePlatform(
//           session,
//           userId,
//           pref.platform,
//           effectiveUrl, // Use the effective URL
//         );
//         allContent.addAll(content);
//       } catch (e, st) {
//         session.log('Platform scrape failed (${pref.platform}): $e');
//       }
//     }

//     return allContent;
//   }


 // Scrape ONLY opportunity platforms (Devpost, Internshala, etc.)
Future<List<ScrapedContent>> scrapeAllPlatforms(
  Session session,
  int userId,
) async {
  var preferences = await getUserScrapingPreferences(session, userId);
  session.log('Preferences found: ${preferences.length}');

  List<ScrapedContent> allContent = [];
  
  // ✅ ONLY scrape platform preferences (opportunities)
  for (var pref in preferences) {
    if (!pref.isActive) continue;

    try {
      String? effectiveUrl = (pref.customUrl?.isEmpty ?? true) ? null : pref.customUrl;
      
      var content = await _scrapePlatform(
        session,
        userId,
        pref.platform,
        effectiveUrl,
      );
      allContent.addAll(content);
    } catch (e, st) {
      session.log('Platform scrape failed (${pref.platform}): $e');
    }
  }

  return allContent;
}

// ✅ NEW: Separate method for profile scraping
Future<List<ScrapedContent>> scrapeUserProfiles(
  Session session,
  int userId,
) async {
  List<ScrapedContent> profileContent = [];
  
  try {
    var student = await StudentProfile.db.findById(session, userId);
    if (student == null) return [];

    if (student.githubUsername != null && student.githubUsername!.isNotEmpty) {
      var githubContent = await _scrapeGitHub(session, userId, student.githubUsername!);
      profileContent.addAll(githubContent);
    }
    
    if (student.leetcodeUsername != null && student.leetcodeUsername!.isNotEmpty) {
      var leetcodeContent = await _scrapeLeetCode(session, userId, student.leetcodeUsername!);
      profileContent.addAll(leetcodeContent);
    }
    
    if (student.codeforcesUsername != null && student.codeforcesUsername!.isNotEmpty) {
      var cfContent = await _scrapeCodeforces(session, userId, student.codeforcesUsername!);
      profileContent.addAll(cfContent);
    }
  } catch (e) {
    session.log('Profile scraping error: $e');
  }

  return profileContent;
}




  Future<List<ScrapedContent>> scrapePlatform(
      Session session, int userId, String platform) async {
    return await _scrapePlatform(session, userId, platform, null);
  }

  Future<List<ScrapedContent>> getScrapedContent(Session session, int userId,
      String? platform, bool? isRead, int limit) async {
    return await ScrapedContent.db.find(
      session,
      where: (t) {
        var condition = t.userId.equals(userId);
        if (platform != null) {
          condition = condition & t.platform.equals(platform);
        }
        if (isRead != null) {
          condition = condition & t.isRead.equals(isRead);
        }
        return condition;
      },
      orderBy: (t) => t.scrapedAt,
      orderDescending: true,
      limit: limit,
    );
  }

  Future<bool> markAsRead(Session session, int contentId) async {
    try {
      var content = await ScrapedContent.db.findById(session, contentId);
      if (content == null) return false;

      content.isRead = true;
      await ScrapedContent.db.updateRow(session, content);
      return true;
    } catch (e, st) {
      session.log('Error marking content as read: $e\n$st');
      return false;
    }
  }

Future<List<ScrapedContent>> _scrapePlatform(
    Session session,
    int userId,
    String platform,
    String? customUrl,
  ) async {
    // FIX: Use default URL if customUrl is null or empty
    String? effectiveUrl = (customUrl == null || customUrl.isEmpty)
        ? null
        : customUrl;

    switch (platform.toLowerCase()) {
      case 'devpost':
        return await _scrapeDevpost(session, userId, effectiveUrl);
      case 'internshala':
        return await _scrapeInternshala(session, userId, effectiveUrl);
      case 'linkedin':
        return await _scrapeLinkedIn(session, userId, effectiveUrl);
      case 'angellist':
        return await _scrapeAngelList(session, userId, effectiveUrl);
      default:
        if (effectiveUrl != null) {
          return await _scrapeGeneric(session, userId, platform, effectiveUrl);
        }
        return [];
    }
  }


Future<List<ScrapedContent>> _scrapeDevpost(Session session, int userId, String? customUrl) async {
  session.log('🔍 Scraping DevPost using API...');
  
  try {
    // DevPost's API endpoint - returns JSON
    var response = await _safeGet('https://devpost.com/api/hackathons?status[]=upcoming&status[]=open');
    session.log('✅ DevPost API response: ${response.statusCode}');
    
    if (response.statusCode != 200) {
      session.log('❌ Bad status: ${response.statusCode}');
      return [];
    }
    
    List<ScrapedContent> contents = [];
    
    // Parse JSON response
    var jsonData = jsonDecode(response.body);
    var hackathons = jsonData['hackathons'] as List? ?? [];
    
    session.log('🎯 Found ${hackathons.length} hackathons from API');
    
    for (var hack in hackathons.take(10)) {
      try {
        var content = ScrapedContent(
          userId: userId,
          platform: 'devpost',
          title: hack['title'] ?? 'Untitled',
          summary: hack['tagline'] ?? 'No description',
          sourceUrl: hack['url'] ?? 'https://devpost.com',
          isRead: false,
        );
        
        if (await _insertIfNotExists(session, content)) {
          contents.add(content);
          session.log('  ✅ ${content.title}');
        }
      } catch (e) {
        session.log('  ❌ Parse error: $e');
      }
    }
    
    session.log('✅ DevPost: Scraped ${contents.length} hackathons');
    return contents;
    
  } catch (e, st) {
    session.log('❌ DevPost API failed: $e');
    return [];
  }
}



// Replace the scrapeInternshala method
Future<List<ScrapedContent>> _scrapeInternshala(Session session, int userId, String? customUrl) async {
  var url = customUrl ?? 'https://internshala.com/internships';
  var response = await _safeGet(url);
  var document = html_parser.parse(response.body);
  
  List<ScrapedContent> contents = [];
  
  // UPDATED SELECTORS - Internshala uses .individual_internship now
  var internships = document.querySelectorAll('.individual_internship, .internship_meta, .internship-card');
  
  for (var internship in internships.take(10)) {
    try {
      var titleElement = internship.querySelector('.job-internship-name, h3, h4, .profile');
      var companyElement = internship.querySelector('.company-name, .company, .company_name');
      var linkElement = internship.querySelector('a[href*="/internship/"], a');
      
      if (titleElement != null && linkElement != null) {
        var href = linkElement.attributes['href'] ?? '';
        var fullUrl = href.startsWith('http') ? href : 'https://internshala.com$href';
        
        var content = ScrapedContent(
          userId: userId,
          platform: 'internshala',
          title: titleElement.text.trim(),
          summary: companyElement?.text.trim() ?? 'Company not available',
          sourceUrl: fullUrl,
          isRead: false,
        );
        
        if (await _insertIfNotExists(session, content)) {
          contents.add(content);
        }
      }
    } catch (e, st) {
      session.log('Internshala parsing error: $e');
    }
  }
  
  return contents;
}

/// Scrape GitHub user activity
Future<List<ScrapedContent>> _scrapeGitHub(Session session, int userId, String username) async {
  session.log('🔍 Scraping GitHub for: $username');
  
  try {
    // Get user info
    var userResponse = await _safeGet('https://api.github.com/users/$username');
    
    if (userResponse.statusCode != 200) {
      session.log('❌ GitHub API error: ${userResponse.statusCode}');
      return [];
    }
    
    var userData = jsonDecode(userResponse.body);
    var publicRepos = userData['public_repos'] ?? 0;
    
    // Get contribution count (from events - approximate)
    var eventsResponse = await _safeGet('https://api.github.com/users/$username/events/public?per_page=100');
    var events = jsonDecode(eventsResponse.body) as List? ?? [];
    
    // Count commits from PushEvents
    var commitCount = 0;
    for (var event in events) {
      if (event['type'] == 'PushEvent') {
        var commits = event['payload']?['commits'] as List? ?? [];
        commitCount += commits.length;
      }
    }
    
    var content = ScrapedContent(
      userId: userId,
      platform: 'github',
      title: 'GitHub: $username',
      summary: 'Repos: $publicRepos | Recent Contributions: $commitCount',
      sourceUrl: 'https://github.com/$username',
      isRead: false,
      metadata: jsonEncode({
        'repos': publicRepos,
        'contributions': commitCount,
        'username': username,
      }),
    );
    
    await _insertIfNotExists(session, content);
    
    session.log('✅ GitHub: $publicRepos repos, $commitCount contributions');
    return [content];
    
  } catch (e, st) {
    session.log('❌ GitHub scraping failed: $e');
    return [];
  }
}


// /// Scrape LeetCode submissions
// Future<List<ScrapedContent>> _scrapeLeetCode(Session session, int userId, String username) async {
//   session.log('🔍 Scraping LeetCode for: $username');
  
//   try {
//     // LeetCode GraphQL API
//     var response = await _client.post(
//       Uri.parse('https://leetcode.com/graphql'),
//       headers: {
//         ..._defaultHeaders,
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'query': '''
// query getUserProfile(\$username: String!) {
//   matchedUser(username: \$username) {
//     username
//     submitStats {
//       acSubmissionNum {
//         difficulty
//         count
//       }
//     }
//     profile {
//       ranking
//     }
//   }
// }
// ''',
//         'variables': {'username': username},
//       }),
//     ).timeout(const Duration(seconds: 15));
    
//     if (response.statusCode != 200) {
//       session.log('❌ LeetCode API error: ${response.statusCode}');
//       return [];
//     }
    
//     var data = jsonDecode(response.body);
//     var user = data['data']?['matchedUser'];
    
//     if (user == null) {
//       session.log('❌ User not found');
//       return [];
//     }
    
//     var ranking = user['profile']?['ranking'] ?? 'N/A';
//     var submissions = user['submitStats']?['acSubmissionNum'] as List? ?? [];
    
//     var content = ScrapedContent(
//       userId: userId,
//       platform: 'leetcode',
//       title: 'LeetCode Profile: $username',
//       summary: 'Ranking: $ranking, ${submissions.length} submission categories',
//       sourceUrl: 'https://leetcode.com/$username',
//       isRead: false,
//     );
    
//     await _insertIfNotExists(session, content);
    
//     session.log('✅ LeetCode: Profile scraped');
//     return [content];
    
//   } catch (e, st) {
//     session.log('❌ LeetCode scraping failed: $e');
//     return [];
//   }
// }



/// Scrape LeetCode submissions
Future<List<ScrapedContent>> _scrapeLeetCode(Session session, int userId, String username) async {
  session.log('🔍 Scraping LeetCode for: $username');
  
  try {
    var response = await _client.post(
      Uri.parse('https://leetcode.com/graphql'),
      headers: {
        ..._defaultHeaders,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'query': '''
query getUserProfile(\$username: String!) {
  matchedUser(username: \$username) {
    username
    submitStats {
      acSubmissionNum {
        difficulty
        count
      }
    }
    profile {
      ranking
    }
  }
  upcomingContests {
    title
    startTime
  }
}
''',
        'variables': {'username': username},
      }),
    ).timeout(const Duration(seconds: 15));
    
    if (response.statusCode != 200) {
      session.log('❌ LeetCode API error: ${response.statusCode}');
      return [];
    }
    
    var data = jsonDecode(response.body);
    var user = data['data']?['matchedUser'];
    
    if (user == null) {
      session.log('❌ User not found');
      return [];
    }
    
    var ranking = user['profile']?['ranking'] ?? 0;
    var submissions = user['submitStats']?['acSubmissionNum'] as List? ?? [];
    
    // Parse problem counts
    var easy = 0, medium = 0, hard = 0, total = 0;
    for (var sub in submissions) {
      var difficulty = sub['difficulty'] as String;
      var count = sub['count'] as int;
      total += count;
      if (difficulty == 'Easy') easy = count;
      if (difficulty == 'Medium') medium = count;
      if (difficulty == 'Hard') hard = count;
    }
    
    // Get next contest
    var contests = data['data']?['upcomingContests'] as List? ?? [];
    var nextContest = contests.isNotEmpty ? contests.first['title'] : 'No upcoming contest';
    var contestTime = contests.isNotEmpty ? contests.first['startTime'] : null;
    
    var content = ScrapedContent(
      userId: userId,
      platform: 'leetcode',
      title: 'LeetCode: $username',
      summary: 'Solved: $total (E:$easy M:$medium H:$hard) | Rank: $ranking',
      sourceUrl: 'https://leetcode.com/$username',
      isRead: false,
      metadata: jsonEncode({
        'username': username,
        'total': total,
        'easy': easy,
        'medium': medium,
        'hard': hard,
        'ranking': ranking,
        'nextContest': nextContest,
        'contestTime': contestTime,
      }),
    );
    
    await _insertIfNotExists(session, content);
    
    session.log('✅ LeetCode: $total problems, rank $ranking');
    return [content];
    
  } catch (e, st) {
    session.log('❌ LeetCode scraping failed: $e');
    return [];
  }
}


/// Scrape Codeforces user info
Future<List<ScrapedContent>> _scrapeCodeforces(Session session, int userId, String username) async {
  session.log('🔍 Scraping Codeforces for: $username');
  
  try {
    // Get user info
    var userResponse = await _safeGet('https://codeforces.com/api/user.info?handles=$username');
    
    if (userResponse.statusCode != 200) {
      session.log('❌ Codeforces API error: ${userResponse.statusCode}');
      return [];
    }
    
    var userData = jsonDecode(userResponse.body);
    
    if (userData['status'] != 'OK') {
      session.log('❌ Codeforces error: ${userData['comment']}');
      return [];
    }
    
    var user = (userData['result'] as List).first;
    var rating = user['rating'] ?? 0;
    var rank = user['rank'] ?? 'Unrated';
    var maxRating = user['maxRating'] ?? rating;
    
    // Get upcoming contests
    var contestResponse = await _safeGet('https://codeforces.com/api/contest.list');
    var contestData = jsonDecode(contestResponse.body);
    
    var nextContest = 'No upcoming contest';
    var contestTime = '';
    
    if (contestData['status'] == 'OK') {
      var contests = contestData['result'] as List;
      var upcoming = contests.where((c) => c['phase'] == 'BEFORE').toList();
      
      if (upcoming.isNotEmpty) {
        upcoming.sort((a, b) => (a['startTimeSeconds'] as int).compareTo(b['startTimeSeconds'] as int));
        nextContest = upcoming.first['name'];
        var timestamp = upcoming.first['startTimeSeconds'] as int;
        contestTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toString();
      }
    }
    
    var content = ScrapedContent(
      userId: userId,
      platform: 'codeforces',
      title: 'Codeforces: $username',
      summary: 'Rank: $rank | Rating: $rating | Max: $maxRating',
      sourceUrl: 'https://codeforces.com/profile/$username',
      isRead: false,
      metadata: jsonEncode({
        'username': username,
        'rating': rating,
        'rank': rank,
        'maxRating': maxRating,
        'nextContest': nextContest,
        'contestTime': contestTime,
      }),
    );
    
    await _insertIfNotExists(session, content);
    
    session.log('✅ Codeforces: $rank, rating $rating');
    return [content];
    
  } catch (e, st) {
    session.log('❌ Codeforces scraping failed: $e');
    return [];
  }
}



  Future<List<ScrapedContent>> _scrapeLinkedIn(
      Session session, int userId, String? customUrl) async {
    var content = ScrapedContent(
      userId: userId,
      platform: 'linkedin',
      title: 'LinkedIn Integration Required',
      summary:
          'LinkedIn requires official API or authenticated scraping using headless browsers.',
      sourceUrl: 'https://www.linkedin.com/developers/',
      isRead: false,
    );

    if (await _insertIfNotExists(session, content)) {
      return [content];
    }
    return [];
  }

  Future<List<ScrapedContent>> _scrapeAngelList(
      Session session, int userId, String? customUrl) async {
    var url = customUrl ?? 'https://wellfound.com/jobs';
    var response = await _safeGet(url);

    var document = html_parser.parse(response.body);
    List<ScrapedContent> contents = [];

    var jobs = document.querySelectorAll('[data-test="StartupResult"]');

    for (var job in jobs.take(10)) {
      try {
        var titleElement = job.querySelector('h2');
        var companyElement =
            job.querySelector('[data-test="CompanyName"]');
        var linkElement = job.querySelector('a');

        if (titleElement != null && linkElement != null) {
          var content = ScrapedContent(
            userId: userId,
            platform: 'angellist',
            title: titleElement.text.trim(),
            summary:
                companyElement?.text.trim() ?? 'No company info',
            sourceUrl: linkElement.attributes['href'] ?? url,
            isRead: false,
          );

          if (await _insertIfNotExists(session, content)) {
            contents.add(content);
          }
        }
      } catch (e, st) {
        session.log('AngelList parsing error: $e\n$st');
      }
    }

    return contents;
  }

  Future<List<ScrapedContent>> _scrapeGeneric(Session session, int userId,
      String platform, String url) async {
    var response = await _safeGet(url);

    var document = html_parser.parse(response.body);
    List<ScrapedContent> contents = [];

    var articles =
        document.querySelectorAll('article, .post, .item, .card');

    for (var article in articles.take(5)) {
      try {
        var titleElement =
            article.querySelector('h1, h2, h3, .title');
        var descElement =
            article.querySelector('p, .description, .summary');
        var linkElement = article.querySelector('a');

        if (titleElement != null) {
          var content = ScrapedContent(
            userId: userId,
            platform: platform,
            title: titleElement.text.trim(),
            summary:
                descElement?.text.trim() ?? 'No description available',
            sourceUrl:
                linkElement?.attributes['href'] ?? url,
            isRead: false,
          );

          if (await _insertIfNotExists(session, content)) {
            contents.add(content);
          }
        }
      } catch (e, st) {
        session.log('Generic parsing error: $e\n$st');
      }
    }

    return contents;
  }

  Future<int> deleteOldContent(
      Session session, int userId, int daysOld) async {
    var cutoffDate =
        DateTime.now().subtract(Duration(days: daysOld));

    var oldContent = await ScrapedContent.db.find(
      session,
      where: (t) =>
          (t.userId.equals(userId)) &
          (t.scrapedAt < cutoffDate),
    );

    for (var content in oldContent) {
      await ScrapedContent.db.deleteRow(session, content);
    }

    return oldContent.length;
  }
}
