// import 'package:serverpod/serverpod.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// // Import your generated protocol files
// import '../generated/protocol.dart';

// class ActivityEndpoint extends Endpoint {
  
//   // Add or update activity tracker for a platform
//   Future<bool> setupActivityTracker({
//     required Session session,
//     required int userId,
//     required String platform, // 'leetcode' or 'github'
//     required String username,
//   }) async {
//     try {
//       // Check if tracker already exists
//       var existing = await ActivityTracker.db.findFirstRow(
//         session,
//         where: (t) => (t.userId.equals(userId)) & (t.platform.equals(platform)),
//       );

//       if (existing != null) {
//         // Update existing
//         existing.username = username;
//         existing.isActive = true;
//         await ActivityTracker.db.updateRow(session , existing);
//       } else {
//         // Create new
//         var tracker = ActivityTracker(
//           userId: userId,
//           platform: platform,
//           username: username,
//           isActive: true,
//           activityData: '{}',
//         );
//         await ActivityTracker.db.insertRow(session , tracker);
//       }
      
//       // Immediately fetch activity
//       await _syncActivity(session, userId, platform, username);
      
//       return true;
//     } catch (e) {
//       session.log('Error setting up activity tracker: $e');
//       return false;
//     }
//   }

//   // Get all activity trackers for a user
//   Future<List<ActivityTracker>> getUserActivityTrackers({
//     required Session session,
//     required int userId,
//   }) async {
//     return await ActivityTracker.db.find(
//       session,
//       where: (t) => t.userId.equals(userId),
//     );
//   }

//   // Sync activity for all platforms
//   Future<bool> syncAllActivities({
//     required Session session,
//     required int userId,
//   }) async {
//     try {
//       var trackers = await getUserActivityTrackers(
//         session: session,
//         userId: userId,
//       );

//       for (var tracker in trackers) {
//         if (!tracker.isActive) continue;
//         await _syncActivity(
//           session,
//           userId,
//           tracker.platform,
//           tracker.username,
//         );
//       }

//       return true;
//     } catch (e) {
//       session.log('Error syncing all activities: $e');
//       return false;
//     }
//   }

//   // Sync activity for a specific platform
//   Future<Map<String, dynamic>?> syncPlatformActivity({
//     required Session session,
//     required int userId,
//     required String platform,
//   }) async {
//     try {
//       var tracker = await ActivityTracker.db.findFirstRow(
//         session,
//         where: (t) => (t.userId.equals(userId)) & (t.platform.equals(platform)),
//       );

//       if (tracker == null || !tracker.isActive) {
//         return null;
//       }

//       return await _syncActivity(
//         session,
//         userId,
//         platform,
//         tracker.username,
//       );
//     } catch (e) {
//       session.log('Error syncing platform activity: $e');
//       return null;
//     }
//   }

//   // Get activity data for a platform
//   Future<Map<String, dynamic>?> getActivityData({
//     required Session session,
//     required int userId,
//     required String platform,
//   }) async {
//     try {
//       var tracker = await ActivityTracker.db.findFirstRow(
//         session,
//         where: (t) => (t.userId.equals(userId)) & (t.platform.equals(platform)),
//       );

//       if (tracker == null) return null;

//       return json.decode(tracker.activityData) as Map<String, dynamic>;
//     } catch (e) {
//       session.log('Error getting activity data: $e');
//       return null;
//     }
//   }

//   // Delete activity tracker
//   Future<bool> deleteActivityTracker({
//     required Session session,
//     required int userId,
//     required String platform,
//   }) async {
//     try {
//       var tracker = await ActivityTracker.db.findFirstRow(
//         session,
//         where: (t) => (t.userId.equals(userId)) & (t.platform.equals(platform)),
//       );

//       if (tracker == null) return false;

//       await ActivityTracker.db.deleteRow(session , tracker);
//       return true;
//     } catch (e) {
//       session.log('Error deleting activity tracker: $e');
//       return false;
//     }
//   }

//   // Private method to sync activity based on platform
//   Future<Map<String, dynamic>?> _syncActivity(
//     Session session,
//     int userId,
//     String platform,
//     String username,
//   ) async {
//     Map<String, dynamic>? activityData;

//     switch (platform.toLowerCase()) {
//       case 'leetcode':
//         activityData = await _fetchLeetCodeActivity(session, username);
//         break;
//       case 'github':
//         activityData = await _fetchGitHubActivity(session, username);
//         break;
//       default:
//         session.log('Unknown platform: $platform');
//         return null;
//     }

//     if (activityData != null) {
//       // Update tracker with new data
//       var tracker = await ActivityTracker.db.findFirstRow(
//         session ,
//         where: (t) => (t.userId.equals(userId)) & (t.platform.equals(platform)),
//       );

//       if (tracker != null) {
//         tracker.activityData = json.encode(activityData);
//         tracker.lastSynced = DateTime.now();
//         await ActivityTracker.db.updateRow(session , tracker);
//       }
//     }

//     return activityData;
//   }

//   // Fetch LeetCode activity using GraphQL API
//   Future<Map<String, dynamic>?> _fetchLeetCodeActivity(
//     Session session,
//     String username,
//   ) async {
//     try {
//       // LeetCode GraphQL endpoint
//       var url = Uri.parse('https://leetcode.com/graphql');
      
//       // GraphQL query to get user stats
//       var query = '''
//       query getUserProfile(\$username: String!) {
//         matchedUser(username: \$username) {
//           username
//           submitStats: submitStatsGlobal {
//             acSubmissionNum {
//               difficulty
//               count
//               submissions
//             }
//           }
//           profile {
//             ranking
//             reputation
//             starRating
//           }
//           userContestRanking {
//             rating
//             globalRanking
//             topPercentage
//             totalParticipants
//             attendedContestsCount
//           }
//         }
//         recentSubmissionList(username: \$username, limit: 10) {
//           title
//           titleSlug
//           timestamp
//           statusDisplay
//           lang
//         }
//       }
//       ''';

//       var response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Referer': 'https://leetcode.com',
//         },
//         body: json.encode({
//           'query': query,
//           'variables': {'username': username},
//         }),
//       );

//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);
        
//         if (data['data'] == null || data['data']['matchedUser'] == null) {
//           session.log('LeetCode user not found: $username');
//           return null;
//         }

//         var userData = data['data']['matchedUser'];
//         var recentSubmissions = data['data']['recentSubmissionList'] ?? [];

//         // Parse submission stats
//         var submitStats = userData['submitStats']['acSubmissionNum'] as List;
//         Map<String, int> problemsSolved = {
//           'easy': 0,
//           'medium': 0,
//           'hard': 0,
//           'total': 0,
//         };

//         for (var stat in submitStats) {
//           var difficulty = stat['difficulty'].toString().toLowerCase();
//           var count = stat['count'] as int;
          
//           if (difficulty == 'easy' || difficulty == 'medium' || difficulty == 'hard') {
//             problemsSolved[difficulty] = count;
//             problemsSolved['total'] = problemsSolved['total']! + count;
//           } else if (difficulty == 'all') {
//             problemsSolved['total'] = count;
//           }
//         }

//         // Parse recent submissions
//         List<Map<String, dynamic>> recentActivity = [];
//         for (var submission in recentSubmissions) {
//           recentActivity.add({
//             'title': submission['title'],
//             'titleSlug': submission['titleSlug'],
//             'timestamp': submission['timestamp'],
//             'status': submission['statusDisplay'],
//             'language': submission['lang'],
//             'url': 'https://leetcode.com/problems/${submission['titleSlug']}/',
//           });
//         }

//         // Calculate streak (simplified - based on recent submissions)
//         int currentStreak = _calculateStreak(recentActivity);

//         var activityData = {
//           'username': username,
//           'platform': 'leetcode',
//           'problemsSolved': problemsSolved,
//           'ranking': userData['profile']?['ranking'],
//           'reputation': userData['profile']?['reputation'],
//           'contestRating': userData['userContestRanking']?['rating'],
//           'contestRanking': userData['userContestRanking']?['globalRanking'],
//           'contestsAttended': userData['userContestRanking']?['attendedContestsCount'],
//           'currentStreak': currentStreak,
//           'recentSubmissions': recentActivity,
//           'lastUpdated': DateTime.now().toIso8601String(),
//         };

//         return activityData;
//       } else {
//         session.log('Failed to fetch LeetCode data: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       session.log('Error fetching LeetCode activity: $e');
//       return null;
//     }
//   }

//   // Fetch GitHub activity using REST API
//   Future<Map<String, dynamic>?> _fetchGitHubActivity(
//     Session session,
//     String username,
//   ) async {
//     try {
//       // GitHub API endpoints
//       var userUrl = Uri.parse('https://api.github.com/users/$username');
//       var eventsUrl = Uri.parse('https://api.github.com/users/$username/events/public');
//       var reposUrl = Uri.parse('https://api.github.com/users/$username/repos?sort=updated&per_page=10');

//       // Fetch user profile
//       var userResponse = await http.get(userUrl, headers: {
//         'Accept': 'application/vnd.github.v3+json',
//         'User-Agent': 'StudentDayOptimizer',
//       });

//       if (userResponse.statusCode != 200) {
//         session.log('Failed to fetch GitHub user: ${userResponse.statusCode}');
//         return null;
//       }

//       var userData = json.decode(userResponse.body);

//       // Fetch recent events
//       var eventsResponse = await http.get(eventsUrl, headers: {
//         'Accept': 'application/vnd.github.v3+json',
//         'User-Agent': 'StudentDayOptimizer',
//       });

//       List recentEvents = [];
//       if (eventsResponse.statusCode == 200) {
//         recentEvents = json.decode(eventsResponse.body);
//       }

//       // Fetch recent repositories
//       var reposResponse = await http.get(reposUrl, headers: {
//         'Accept': 'application/vnd.github.v3+json',
//         'User-Agent': 'StudentDayOptimizer',
//       });

//       List recentRepos = [];
//       if (reposResponse.statusCode == 200) {
//         recentRepos = json.decode(reposResponse.body);
//       }

//       // Parse activity data
//       List<Map<String, dynamic>> activityTimeline = [];
//       Map<String, int> activitySummary = {
//         'commits': 0,
//         'pullRequests': 0,
//         'issues': 0,
//         'reviews': 0,
//       };

//       for (var event in recentEvents.take(30)) {
//         var eventType = event['type'] as String;
//         var createdAt = DateTime.parse(event['created_at']);
        
//         Map<String, dynamic> activity = {
//           'type': eventType,
//           'repo': event['repo']['name'],
//           'timestamp': createdAt.toIso8601String(),
//           'url': 'https://github.com/${event['repo']['name']}',
//         };

//         switch (eventType) {
//           case 'PushEvent':
//             final int commits = event['payload']['commits']?.length ?? 1;
//             activitySummary['commits'] = activitySummary['commits']! + commits.toInt();
//             activity['description'] = 'Pushed $commits commit(s)';
//             break;
//           case 'PullRequestEvent':
//             activitySummary['pullRequests'] = activitySummary['pullRequests']! + 1;
//             activity['description'] = 'Pull request ${event['payload']['action']}';
//             break;
//           case 'IssuesEvent':
//             activitySummary['issues'] = activitySummary['issues']! + 1;
//             activity['description'] = 'Issue ${event['payload']['action']}';
//             break;
//           case 'PullRequestReviewEvent':
//             activitySummary['reviews'] = activitySummary['reviews']! + 1;
//             activity['description'] = 'Reviewed pull request';
//             break;
//           default:
//             activity['description'] = eventType.replaceAll('Event', '');
//         }

//         activityTimeline.add(activity);
//       }

//       // Parse repository data
//       List<Map<String, dynamic>> projects = [];
//       for (var repo in recentRepos) {
//         projects.add({
//           'name': repo['name'],
//           'description': repo['description'] ?? 'No description',
//           'language': repo['language'] ?? 'Unknown',
//           'stars': repo['stargazers_count'],
//           'forks': repo['forks_count'],
//           'updatedAt': repo['updated_at'],
//           'url': repo['html_url'],
//           'isPrivate': repo['private'],
//         });
//       }

//       // Calculate contribution streak
//       int currentStreak = _calculateGitHubStreak(recentEvents);

//       var activityData = {
//         'username': username,
//         'platform': 'github',
//         'profileUrl': userData['html_url'],
//         'avatarUrl': userData['avatar_url'],
//         'name': userData['name'],
//         'bio': userData['bio'],
//         'publicRepos': userData['public_repos'],
//         'followers': userData['followers'],
//         'following': userData['following'],
//         'currentStreak': currentStreak,
//         'activitySummary': activitySummary,
//         'recentActivity': activityTimeline,
//         'recentProjects': projects,
//         'lastUpdated': DateTime.now().toIso8601String(),
//       };

//       return activityData;
//     } catch (e) {
//       session.log('Error fetching GitHub activity: $e');
//       return null;
//     }
//   }

//   // Calculate streak from recent submissions (simplified)
//   int _calculateStreak(List<Map<String, dynamic>> submissions) {
//     if (submissions.isEmpty) return 0;

//     // Group submissions by date
//     Map<String, int> submissionsByDate = {};
    
//     for (var submission in submissions) {
//       var timestamp = int.parse(submission['timestamp'].toString());
//       var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
//       var dateKey = '${date.year}-${date.month}-${date.day}';
//       submissionsByDate[dateKey] = 1;
//     }

//     // Calculate consecutive days
//     var today = DateTime.now();
//     int streak = 0;
    
//     for (int i = 0; i < 365; i++) {
//       var checkDate = today.subtract(Duration(days: i));
//       var dateKey = '${checkDate.year}-${checkDate.month}-${checkDate.day}';
      
//       if (submissionsByDate.containsKey(dateKey)) {
//         streak++;
//       } else {
//         break;
//       }
//     }

//     return streak;
//   }

//   // Calculate GitHub contribution streak
//   int _calculateGitHubStreak(List events) {
//     if (events.isEmpty) return 0;

//     // Group events by date
//     Map<String, int> eventsByDate = {};
    
//     for (var event in events) {
//       var date = DateTime.parse(event['created_at']);
//       var dateKey = '${date.year}-${date.month}-${date.day}';
//       eventsByDate[dateKey] = 1;
//     }

//     // Calculate consecutive days
//     var today = DateTime.now();
//     int streak = 0;
    
//     for (int i = 0; i < 30; i++) {
//       var checkDate = today.subtract(Duration(days: i));
//       var dateKey = '${checkDate.year}-${checkDate.month}-${checkDate.day}';
      
//       if (eventsByDate.containsKey(dateKey)) {
//         streak++;
//       } else {
//         break;
//       }
//     }

//     return streak;
//   }

//   // Get comprehensive dashboard data
//   Future<Map<String, dynamic>> getDashboard({
//     required Session session,
//     required int userId,
//   }) async {
//     var trackers = await getUserActivityTrackers(
//       session: session,
//       userId: userId,
//     );

//     Map<String, dynamic> dashboard = {
//       'leetcode': null,
//       'github': null,
//       'summary': {
//         'totalProblems': 0,
//         'totalCommits': 0,
//         'currentStreak': 0,
//         'lastActivity': null,
//       },
//     };

//     for (var tracker in trackers) {
//       if (!tracker.isActive) continue;

//       try {
//         var activityData = json.decode(tracker.activityData);
        
//         if (tracker.platform == 'leetcode') {
//           dashboard['leetcode'] = activityData;
//           dashboard['summary']['totalProblems'] = 
//             activityData['problemsSolved']?['total'] ?? 0;
//         } else if (tracker.platform == 'github') {
//           dashboard['github'] = activityData;
//           dashboard['summary']['totalCommits'] = 
//             activityData['activitySummary']?['commits'] ?? 0;
//         }

//         // Update streak (take max)
//         var streak = activityData['currentStreak'] ?? 0;
//         if (streak > dashboard['summary']['currentStreak']) {
//           dashboard['summary']['currentStreak'] = streak;
//         }

//         // Update last activity
//         var lastUpdated = activityData['lastUpdated'];
//         if (lastUpdated != null) {
//           if (dashboard['summary']['lastActivity'] == null ||
//               DateTime.parse(lastUpdated).isAfter(
//                 DateTime.parse(dashboard['summary']['lastActivity'])
//               )) {
//             dashboard['summary']['lastActivity'] = lastUpdated;
//           }
//         }
//       } catch (e) {
//         session.log('Error processing tracker data: $e');
//       }
//     }

//     return dashboard;
//   }
// }
















import 'package:serverpod/serverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// Import your generated protocol files
import '../generated/protocol.dart';

class ActivityEndpoint extends Endpoint {
  
  // Add or update activity tracker for a platform
  Future<bool> setupActivityTracker(
    Session session,
    int userId,
    String platform,
    String username,
  ) async {
    try {
      // Check if tracker already exists
      var existing = await ActivityTracker.db.findFirstRow(session, 
        where: (t) => (t.userId.equals(userId)) & (t.platform.equals(platform)),
      );

      if (existing != null) {
        // Update existing
        existing.username = username;
        existing.isActive = true;
        await ActivityTracker.db.updateRow(session, existing);
      } else {
        // Create new
        var tracker = ActivityTracker(
          userId: userId,
          platform: platform,
          username: username,
          isActive: true,
          activityData: '{}',
        );
        await ActivityTracker.db.insertRow(session, tracker);
      }
      
      // Immediately fetch activity
      await _syncActivity(session, userId, platform, username);
      
      return true;
    } catch (e) {
      session.log('Error setting up activity tracker: $e');
      return false;
    }
  }

  // Get all activity trackers for a user
  Future<List<ActivityTracker>> getUserActivityTrackers(
    Session session,
    int userId,
  ) async {
    return await ActivityTracker.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );
  }

  // Sync activity for all platforms
  Future<bool> syncAllActivities(
    Session session,
    int userId,
  ) async {
    try {
      var trackers = await getUserActivityTrackers(
        session,
        userId,
      );

      for (var tracker in trackers) {
        if (!tracker.isActive) continue;
        await _syncActivity(
          session,
          userId,
          tracker.platform,
          tracker.username,
        );
      }

      return true;
    } catch (e) {
      session.log('Error syncing all activities: $e');
      return false;
    }
  }

  // Sync activity for a specific platform
  Future<Map<String, dynamic>?> syncPlatformActivity(
    Session session,
    int userId,
    String platform,
  ) async {
    try {
      var tracker = await ActivityTracker.db.findFirstRow(
        session,
        where: (t) => (t.userId.equals(userId)) & (t.platform.equals(platform)),
      );

      if (tracker == null || !tracker.isActive) {
        return null;
      }

      return await _syncActivity(
        session,
        userId,
        platform,
        tracker.username,
      );
    } catch (e) {
      session.log('Error syncing platform activity: $e');
      return null;
    }
  }

  // Get activity data for a platform
  Future<Map<String, dynamic>?> getActivityData(
    Session session,
    int userId,
    String platform,
  ) async {
    try {
      var tracker = await ActivityTracker.db.findFirstRow(
        session,
        where: (t) => (t.userId.equals(userId)) & (t.platform.equals(platform)),
      );

      if (tracker == null) return null;

      return json.decode(tracker.activityData) as Map<String, dynamic>;
    } catch (e) {
      session.log('Error getting activity data: $e');
      return null;
    }
  }

  // Delete activity tracker
  Future<bool> deleteActivityTracker(
    Session session,
    int userId,
    String platform,
  ) async {
    try {
      var tracker = await ActivityTracker.db.findFirstRow(
        session,
        where: (t) => (t.userId.equals(userId)) & (t.platform.equals(platform)),
      );

      if (tracker == null) return false;

      await ActivityTracker.db.deleteRow(session, tracker);
      return true;
    } catch (e) {
      session.log('Error deleting activity tracker: $e');
      return false;
    }
  }

  // Private method to sync activity based on platform
  Future<Map<String, dynamic>?> _syncActivity(
    Session session,
    int userId,
    String platform,
    String username,
  ) async {
    Map<String, dynamic>? activityData;

    switch (platform.toLowerCase()) {
      case 'leetcode':
        activityData = await _fetchLeetCodeActivity(session, username);
        break;
      case 'github':
        activityData = await _fetchGitHubActivity(session, username);
        break;
      default:
        session.log('Unknown platform: $platform');
        return null;
    }

    if (activityData != null) {
      // Update tracker with new data
      var tracker = await ActivityTracker.db.findFirstRow(
        session,
        where: (t) => (t.userId.equals(userId)) & (t.platform.equals(platform)),
      );

      if (tracker != null) {
        tracker.activityData = json.encode(activityData);
        tracker.lastSynced = DateTime.now();
        await ActivityTracker.db.updateRow(session, tracker);
      }
    }

    return activityData;
  }

  // Fetch LeetCode activity using GraphQL API
  Future<Map<String, dynamic>?> _fetchLeetCodeActivity(
    Session session,
    String username,
  ) async {
    try {
      // LeetCode GraphQL endpoint
      var url = Uri.parse('https://leetcode.com/graphql');
      
      // GraphQL query to get user stats
      var query = '''
      query getUserProfile(\$username: String!) {
        matchedUser(username: \$username) {
          username
          submitStats: submitStatsGlobal {
            acSubmissionNum {
              difficulty
              count
              submissions
            }
          }
          profile {
            ranking
            reputation
            starRating
          }
          userContestRanking {
            rating
            globalRanking
            topPercentage
            totalParticipants
            attendedContestsCount
          }
        }
        recentSubmissionList(username: \$username, limit: 10) {
          title
          titleSlug
          timestamp
          statusDisplay
          lang
        }
      }
      ''';

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Referer': 'https://leetcode.com',
        },
        body: json.encode({
          'query': query,
          'variables': {'username': username},
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        
        if (data['data'] == null || data['data']['matchedUser'] == null) {
          session.log('LeetCode user not found: $username');
          return null;
        }

        var userData = data['data']['matchedUser'];
        var recentSubmissions = data['data']['recentSubmissionList'] ?? [];

        // Parse submission stats
        var submitStats = userData['submitStats']['acSubmissionNum'] as List;
        Map<String, int> problemsSolved = {
          'easy': 0,
          'medium': 0,
          'hard': 0,
          'total': 0,
        };

        for (var stat in submitStats) {
          var difficulty = stat['difficulty'].toString().toLowerCase();
          var count = stat['count'] as int;
          
          if (difficulty == 'easy' || difficulty == 'medium' || difficulty == 'hard') {
            problemsSolved[difficulty] = count;
            problemsSolved['total'] = problemsSolved['total']! + count;
          } else if (difficulty == 'all') {
            problemsSolved['total'] = count;
          }
        }

        // Parse recent submissions
        List<Map<String, dynamic>> recentActivity = [];
        for (var submission in recentSubmissions) {
          recentActivity.add({
            'title': submission['title'],
            'titleSlug': submission['titleSlug'],
            'timestamp': submission['timestamp'],
            'status': submission['statusDisplay'],
            'language': submission['lang'],
            'url': 'https://leetcode.com/problems/${submission['titleSlug']}/',
          });
        }

        // Calculate streak (simplified - based on recent submissions)
        int currentStreak = _calculateStreak(recentActivity);

        var activityData = {
          'username': username,
          'platform': 'leetcode',
          'problemsSolved': problemsSolved,
          'ranking': userData['profile']?['ranking'],
          'reputation': userData['profile']?['reputation'],
          'contestRating': userData['userContestRanking']?['rating'],
          'contestRanking': userData['userContestRanking']?['globalRanking'],
          'contestsAttended': userData['userContestRanking']?['attendedContestsCount'],
          'currentStreak': currentStreak,
          'recentSubmissions': recentActivity,
          'lastUpdated': DateTime.now().toIso8601String(),
        };

        return activityData;
      } else {
        session.log('Failed to fetch LeetCode data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      session.log('Error fetching LeetCode activity: $e');
      return null;
    }
  }

  // Fetch GitHub activity using REST API
  Future<Map<String, dynamic>?> _fetchGitHubActivity(
    Session session,
    String username,
  ) async {
    try {
      // GitHub API endpoints
      var userUrl = Uri.parse('https://api.github.com/users/$username');
      var eventsUrl = Uri.parse('https://api.github.com/users/$username/events/public');
      var reposUrl = Uri.parse('https://api.github.com/users/$username/repos?sort=updated&per_page=10');

      // Fetch user profile
      var userResponse = await http.get(userUrl, headers: {
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'StudentDayOptimizer',
      });

      if (userResponse.statusCode != 200) {
        session.log('Failed to fetch GitHub user: ${userResponse.statusCode}');
        return null;
      }

      var userData = json.decode(userResponse.body);

      // Fetch recent events
      var eventsResponse = await http.get(eventsUrl, headers: {
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'StudentDayOptimizer',
      });

      List recentEvents = [];
      if (eventsResponse.statusCode == 200) {
        recentEvents = json.decode(eventsResponse.body);
      }

      // Fetch recent repositories
      var reposResponse = await http.get(reposUrl, headers: {
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'StudentDayOptimizer',
      });

      List recentRepos = [];
      if (reposResponse.statusCode == 200) {
        recentRepos = json.decode(reposResponse.body);
      }

      // Parse activity data
      List<Map<String, dynamic>> activityTimeline = [];
      Map<String, int> activitySummary = {
        'commits': 0,
        'pullRequests': 0,
        'issues': 0,
        'reviews': 0,
      };

      for (var event in recentEvents.take(30)) {
        var eventType = event['type'] as String;
        var createdAt = DateTime.parse(event['created_at']);
        
        Map<String, dynamic> activity = {
          'type': eventType,
          'repo': event['repo']['name'],
          'timestamp': createdAt.toIso8601String(),
          'url': 'https://github.com/${event['repo']['name']}',
        };

        switch (eventType) {
          case 'PushEvent':
            final int commits = event['payload']['commits']?.length ?? 1;
            activitySummary['commits'] = activitySummary['commits']! + commits;
            activity['description'] = 'Pushed $commits commit(s)';
            break;
          case 'PullRequestEvent':
            activitySummary['pullRequests'] = activitySummary['pullRequests']! + 1;
            activity['description'] = 'Pull request ${event['payload']['action']}';
            break;
          case 'IssuesEvent':
            activitySummary['issues'] = activitySummary['issues']! + 1;
            activity['description'] = 'Issue ${event['payload']['action']}';
            break;
          case 'PullRequestReviewEvent':
            activitySummary['reviews'] = activitySummary['reviews']! + 1;
            activity['description'] = 'Reviewed pull request';
            break;
          default:
            activity['description'] = eventType.replaceAll('Event', '');
        }

        activityTimeline.add(activity);
      }

      // Parse repository data
      List<Map<String, dynamic>> projects = [];
      for (var repo in recentRepos) {
        projects.add({
          'name': repo['name'],
          'description': repo['description'] ?? 'No description',
          'language': repo['language'] ?? 'Unknown',
          'stars': repo['stargazers_count'],
          'forks': repo['forks_count'],
          'updatedAt': repo['updated_at'],
          'url': repo['html_url'],
          'isPrivate': repo['private'],
        });
      }

      // Calculate contribution streak
      int currentStreak = _calculateGitHubStreak(recentEvents);

      var activityData = {
        'username': username,
        'platform': 'github',
        'profileUrl': userData['html_url'],
        'avatarUrl': userData['avatar_url'],
        'name': userData['name'],
        'bio': userData['bio'],
        'publicRepos': userData['public_repos'],
        'followers': userData['followers'],
        'following': userData['following'],
        'currentStreak': currentStreak,
        'activitySummary': activitySummary,
        'recentActivity': activityTimeline,
        'recentProjects': projects,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      return activityData;
    } catch (e) {
      session.log('Error fetching GitHub activity: $e');
      return null;
    }
  }

  // Calculate streak from recent submissions (simplified)
  int _calculateStreak(List<Map<String, dynamic>> submissions) {
    if (submissions.isEmpty) return 0;

    // Group submissions by date
    Map<String, int> submissionsByDate = {};
    
    for (var submission in submissions) {
      var timestamp = int.parse(submission['timestamp'].toString());
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      var dateKey = '${date.year}-${date.month}-${date.day}';
      submissionsByDate[dateKey] = 1;
    }

    // Calculate consecutive days
    var today = DateTime.now();
    int streak = 0;
    
    for (int i = 0; i < 365; i++) {
      var checkDate = today.subtract(Duration(days: i));
      var dateKey = '${checkDate.year}-${checkDate.month}-${checkDate.day}';
      
      if (submissionsByDate.containsKey(dateKey)) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  // Calculate GitHub contribution streak
  int _calculateGitHubStreak(List events) {
    if (events.isEmpty) return 0;

    // Group events by date
    Map<String, int> eventsByDate = {};
    
    for (var event in events) {
      var date = DateTime.parse(event['created_at']);
      var dateKey = '${date.year}-${date.month}-${date.day}';
      eventsByDate[dateKey] = 1;
    }

    // Calculate consecutive days
    var today = DateTime.now();
    int streak = 0;
    
    for (int i = 0; i < 30; i++) {
      var checkDate = today.subtract(Duration(days: i));
      var dateKey = '${checkDate.year}-${checkDate.month}-${checkDate.day}';
      
      if (eventsByDate.containsKey(dateKey)) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  // Get comprehensive dashboard data
  Future<Map<String, dynamic>> getDashboard(
    Session session,
    int userId,
  ) async {
    var trackers = await getUserActivityTrackers(
      session,
      userId,
    );

    Map<String, dynamic> dashboard = {
      'leetcode': null,
      'github': null,
      'summary': {
        'totalProblems': 0,
        'totalCommits': 0,
        'currentStreak': 0,
        'lastActivity': null,
      },
    };

    for (var tracker in trackers) {
      if (!tracker.isActive) continue;

      try {
        var activityData = json.decode(tracker.activityData);
        
        if (tracker.platform == 'leetcode') {
          dashboard['leetcode'] = activityData;
          dashboard['summary']['totalProblems'] = 
            activityData['problemsSolved']?['total'] ?? 0;
        } else if (tracker.platform == 'github') {
          dashboard['github'] = activityData;
          dashboard['summary']['totalCommits'] = 
            activityData['activitySummary']?['commits'] ?? 0;
        }

        // Update streak (take max)
        var streak = activityData['currentStreak'] ?? 0;
        if (streak > dashboard['summary']['currentStreak']) {
          dashboard['summary']['currentStreak'] = streak;
        }

        // Update last activity
        var lastUpdated = activityData['lastUpdated'];
        if (lastUpdated != null) {
          if (dashboard['summary']['lastActivity'] == null ||
              DateTime.parse(lastUpdated).isAfter(
                DateTime.parse(dashboard['summary']['lastActivity'])
              )) {
            dashboard['summary']['lastActivity'] = lastUpdated;
          }
        }
      } catch (e) {
        session.log('Error processing tracker data: $e');
      }
    }

    return dashboard;
  }
}