import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'behavior_service.dart';

/// Service for handling voice notes, transcription, and voice commands
/// This is a KEY DIFFERENTIATOR - voice-first interaction
class VoiceService {
  /// Process a voice command and return structured response
  static Future<Map<String, dynamic>> processVoiceCommand(
    Session session,
    int studentProfileId,
    String command,
  ) async {
    final lowerCommand = command.toLowerCase().trim();

    // Pattern matching for different commands
    if (lowerCommand.contains('finished') || lowerCommand.contains('completed')) {
      return await _handleCompletion(session, studentProfileId, command);
    } else if (lowerCommand.contains('too tired') || lowerCommand.contains('skip')) {
      return await _handleSkip(session, studentProfileId, command);
    } else if (lowerCommand.contains('add goal')) {
      return await _handleAddGoal(session, studentProfileId, command);
    } else if (lowerCommand.contains('what should i') || lowerCommand.contains('next task')) {
      return await _handleNextTask(session, studentProfileId);
    } else if (lowerCommand.contains('how') && lowerCommand.contains('week')) {
      return await _handleWeekSummary(session, studentProfileId);
    } else if (lowerCommand.contains('why') && lowerCommand.contains('plan change')) {
      return await _handlePlanExplanation(session, studentProfileId);
    } else {
      // Default: save as voice note
      return await _saveVoiceNote(session, studentProfileId, command);
    }
  }

  /// Handle completion command
  static Future<Map<String, dynamic>> _handleCompletion(
    Session session,
    int studentProfileId,
    String command,
  ) async {
    // Extract what was completed
    final completedItem = _extractItemFromCommand(command, ['finished', 'completed']);

    // Find the most recent pending time block
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    final dailyPlan = await DailyPlan.db.findFirstRow(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.planDate.equals(startOfDay),
    );

    if (dailyPlan == null) {
      return {
        'success': false,
        'message': 'No plan found for today',
      };
    }

    // Find matching time block
    final timeBlocks = await TimeBlock.db.find(
      session,
      where: (t) =>
          t.dailyPlanId.equals(dailyPlan.id) &
          t.completionStatus.equals('pending'),
      orderBy: (t) => t.startTime,
    );

    TimeBlock? targetBlock;
    
    if (completedItem.isNotEmpty && timeBlocks.isNotEmpty) {
      // Try to find block matching the item
      try {
        targetBlock = timeBlocks.firstWhere(
          (b) => b.title.toLowerCase().contains(completedItem.toLowerCase()),
        );
      } catch (e) {
        targetBlock = timeBlocks.first;
      }
    } else if (timeBlocks.isNotEmpty) {
      // Use most recent block
      targetBlock = timeBlocks.first;
    }

    if (targetBlock == null) {
      return {
        'success': false,
        'message': 'No pending tasks found',
      };
    }

    // Log completion
    await BehaviorService.logCompletion(
      session,
      targetBlock.id!,
      studentProfileId,
      notes: 'Logged via voice command',
    );

    return {
      'success': true,
      'message': 'Great job! Marked "${targetBlock.title}" as completed.',
      'blockId': targetBlock.id,
      'blockTitle': targetBlock.title,
    };
  }

  /// Handle skip/tired command
  static Future<Map<String, dynamic>> _handleSkip(
    Session session,
    int studentProfileId,
    String command,
  ) async {
    final reason = _extractReason(command);

    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    final dailyPlan = await DailyPlan.db.findFirstRow(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.planDate.equals(startOfDay),
    );

    if (dailyPlan == null) {
      return {
        'success': false,
        'message': 'No plan found for today',
      };
    }

    final timeBlocks = await TimeBlock.db.find(
      session,
      where: (t) =>
          t.dailyPlanId.equals(dailyPlan.id) &
          t.completionStatus.equals('pending') &
          (t.startTime < DateTime.now()),
      orderBy: (t) => t.startTime,
      orderDescending: true,
      limit: 1,
    );

    if (timeBlocks.isEmpty) {
      return {
        'success': false,
        'message': 'No current task to skip',
      };
    }

    final targetBlock = timeBlocks.first;

    await BehaviorService.logMissed(
      session,
      targetBlock.id!,
      studentProfileId,
      reason: reason,
      notes: 'Logged via voice command',
    );

    return {
      'success': true,
      'message': 'No worries, I\'ve noted that you skipped "${targetBlock.title}". Rest is important!',
      'blockId': targetBlock.id,
      'blockTitle': targetBlock.title,
    };
  }

  /// Handle add goal command
  static Future<Map<String, dynamic>> _handleAddGoal(
    Session session,
    int studentProfileId,
    String command,
  ) async {
    // Extract goal title from command
    final goalTitle = _extractGoalTitle(command);

    if (goalTitle.isEmpty) {
      return {
        'success': false,
        'message': 'Could not understand the goal. Please try again.',
      };
    }

    // Create new learning goal
    final goal = LearningGoal(
      studentProfileId: studentProfileId,
      title: goalTitle,
      category: 'technical_skill', // Default
      priority: 'medium',
      status: 'not_started',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final savedGoal = await LearningGoal.db.insertRow(session, goal);

    return {
      'success': true,
      'message': 'Added new goal: "$goalTitle"',
      'goalId': savedGoal.id,
      'goalTitle': savedGoal.title,
    };
  }

  /// Handle next task query
  static Future<Map<String, dynamic>> _handleNextTask(
    Session session,
    int studentProfileId,
  ) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    final dailyPlan = await DailyPlan.db.findFirstRow(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.planDate.equals(startOfDay),
    );

    if (dailyPlan == null) {
      return {
        'success': false,
        'message': 'No plan for today yet. Let me generate one!',
      };
    }

    final nextBlocks = await TimeBlock.db.find(
      session,
      where: (t) =>
          t.dailyPlanId.equals(dailyPlan.id) &
          t.completionStatus.equals('pending') &
          (t.startTime > now),
      orderBy: (t) => t.startTime,
      limit: 1,
    );

    if (nextBlocks.isEmpty) {
      return {
        'success': true,
        'message': 'You\'re all done for today! Great work!',
      };
    }

    final nextBlock = nextBlocks.first;
    final timeUntil = nextBlock.startTime.difference(now);
    final minutesUntil = timeUntil.inMinutes;

    return {
      'success': true,
      'message': 'Next up: "${nextBlock.title}" in $minutesUntil minutes',
      'blockId': nextBlock.id,
      'blockTitle': nextBlock.title,
      'startTime': nextBlock.startTime.toIso8601String(),
      'minutesUntil': minutesUntil,
    };
  }

  /// Handle week summary query
  static Future<Map<String, dynamic>> _handleWeekSummary(
    Session session,
    int studentProfileId,
  ) async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: 7));

    final stats = await BehaviorService.getCompletionStats(
      session,
      studentProfileId,
      weekStart,
      now,
    );

    final completionRate = ((stats['completionRate'] as double) * 100).toStringAsFixed(0);

    return {
      'success': true,
      'message': 'This week: ${stats['completed']} tasks completed, $completionRate% completion rate',
      'stats': stats,
    };
  }

  /// Handle plan explanation query
  static Future<Map<String, dynamic>> _handlePlanExplanation(
    Session session,
    int studentProfileId,
  ) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    final plan = await DailyPlan.db.findFirstRow(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.planDate.equals(startOfDay),
    );

    if (plan == null) {
      return {
        'success': false,
        'message': 'No plan found for today',
      };
    }

    return {
      'success': true,
      'message': plan.adaptationNotes ?? plan.reasoning ?? 'Plan generated based on your goals',
      'planVersion': plan.version,
    };
  }

  /// Save voice note
  static Future<Map<String, dynamic>> _saveVoiceNote(
    Session session,
    int studentProfileId,
    String transcription,
  ) async {
    final sentiment = analyzeSentiment(transcription);

    final note = VoiceNote(
      studentProfileId: studentProfileId,
      transcription: transcription,
      recordedAt: DateTime.now(),
      sentiment: sentiment,
      searchableContent: transcription.toLowerCase(),
    );

    final savedNote = await VoiceNote.db.insertRow(session, note);

    // Try to link to goal
    await linkNoteToGoal(session, savedNote.id!);

    return {
      'success': true,
      'message': 'Voice note saved',
      'noteId': savedNote.id,
    };
  }

  /// Extract item name from completion command
  static String _extractItemFromCommand(String command, List<String> keywords) {
    for (final keyword in keywords) {
      final index = command.toLowerCase().indexOf(keyword);
      if (index != -1) {
        final remaining = command.substring(index + keyword.length).trim();
        // Remove common filler words
        return remaining
            .replaceFirst(RegExp(r'^(the|a|an|my)\s+', caseSensitive: false), '')
            .trim();
      }
    }
    return '';
  }

  /// Extract reason from skip command
  static String _extractReason(String command) {
    if (command.toLowerCase().contains('too tired')) {
      return 'Too tired';
    } else if (command.toLowerCase().contains('not feeling')) {
      return 'Not feeling well';
    } else if (command.toLowerCase().contains('busy')) {
      return 'Too busy';
    } else if (command.toLowerCase().contains('emergency')) {
      return 'Emergency';
    }
    return 'Skipped via voice';
  }

  /// Extract goal title from add goal command
  static String _extractGoalTitle(String command) {
    final patterns = ['add goal:', 'add goal', 'learn', 'study'];
    
    for (final pattern in patterns) {
      final index = command.toLowerCase().indexOf(pattern);
      if (index != -1) {
        return command.substring(index + pattern.length).trim();
      }
    }
    
    return command.trim();
  }

  /// Link voice note to learning goal based on keywords
  static Future<void> linkNoteToGoal(
    Session session,
    int voiceNoteId,
  ) async {
    final note = await VoiceNote.db.findById(session, voiceNoteId);
    if (note == null) return;

    final goals = await LearningGoal.db.find(
      session,
      where: (t) => t.studentProfileId.equals(note.studentProfileId),
    );

    // Simple keyword matching
    for (final goal in goals) {
      if (note.transcription.toLowerCase().contains(goal.title.toLowerCase())) {
        note.learningGoalId = goal.id;
        await VoiceNote.db.updateRow(session, note);
        break;
      }
    }
  }

  /// Analyze sentiment from voice note (simple implementation)
  static String analyzeSentiment(String transcription) {
    final text = transcription.toLowerCase();

    // Very simple sentiment analysis
    final positiveWords = [
      'great', 'good', 'awesome', 'love', 'excellent', 
      'happy', 'amazing', 'wonderful', 'fantastic', 'enjoy'
    ];
    
    final negativeWords = [
      'hard', 'difficult', 'stuck', 'frustrated', 'tired', 
      'confused', 'struggling', 'hate', 'boring', 'annoying'
    ];

    int positiveCount = 0;
    int negativeCount = 0;

    for (final word in positiveWords) {
      if (text.contains(word)) positiveCount++;
    }

    for (final word in negativeWords) {
      if (text.contains(word)) negativeCount++;
    }

    if (positiveCount > negativeCount) return 'positive';
    if (negativeCount > positiveCount) return 'negative';
    if (negativeCount > 0 || positiveCount > 0) return 'neutral';
    
    return 'neutral';
  }

  /// Get suggested voice commands based on context
  static Future<List<String>> getSuggestedCommands(
    Session session,
    int studentProfileId,
  ) async {
    final suggestions = <String>[];

    // Get current time block
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    final plan = await DailyPlan.db.findFirstRow(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.planDate.equals(startOfDay),
    );

    if (plan != null) {
      final currentBlocks = await TimeBlock.db.find(
        session,
        where: (t) =>
            t.dailyPlanId.equals(plan.id) &
            (t.startTime < now) &
            (t.endTime > now),
        limit: 1,
      );

      if (currentBlocks.isNotEmpty) {
        final block = currentBlocks.first;
        suggestions.add('Butler, I finished ${block.title}');
        suggestions.add('Butler, I\'m too tired for ${block.title}');
      }

      // Get upcoming blocks
      final upcomingBlocks = await TimeBlock.db.find(
        session,
        where: (t) =>
            t.dailyPlanId.equals(plan.id) &
            (t.startTime > now),
        orderBy: (t) => t.startTime,
        limit: 1,
      );

      if (upcomingBlocks.isNotEmpty) {
        suggestions.add('Butler, what should I work on next?');
      }
    }

    // Add general suggestions
    suggestions.add('Butler, add goal: Learn [skill]');
    suggestions.add('Butler, how\'s my week looking?');
    suggestions.add('Butler, why did my plan change?');

    return suggestions;
  }

  /// Categorize voice note content
  static String categorizeNote(String transcription) {
    final text = transcription.toLowerCase();

    if (text.contains('idea') || text.contains('thought') || text.contains('maybe')) {
      return 'idea';
    } else if (text.contains('question') || text.contains('how') || text.contains('why')) {
      return 'question';
    } else if (text.contains('completed') || text.contains('finished') || text.contains('done')) {
      return 'progress';
    } else if (text.contains('think') || text.contains('feel') || text.contains('realize')) {
      return 'reflection';
    }

    return 'general';
  }

  /// Search voice notes by content
  static Future<List<VoiceNote>> searchVoiceNotes(
    Session session,
    int studentProfileId,
    String query,
  ) async {
    final lowerQuery = query.toLowerCase();

    final allNotes = await VoiceNote.db.find(
      session,
      where: (t) => t.studentProfileId.equals(studentProfileId),
      orderBy: (t) => t.recordedAt,
      orderDescending: true,
    );

    // Filter by searchable content
    return allNotes
        .where((note) =>
            note.searchableContent?.contains(lowerQuery) ?? false)
        .toList();
  }

  /// Get voice notes summary statistics
  static Future<Map<String, dynamic>> getVoiceNoteStats(
    Session session,
    int studentProfileId,
  ) async {
    final allNotes = await VoiceNote.db.find(
      session,
      where: (t) => t.studentProfileId.equals(studentProfileId),
    );

    final positive = allNotes.where((n) => n.sentiment == 'positive').length;
    final neutral = allNotes.where((n) => n.sentiment == 'neutral').length;
    final negative = allNotes.where((n) => n.sentiment == 'negative').length;

    final totalDuration = allNotes
        .where((n) => n.duration != null)
        .fold<int>(0, (sum, n) => sum + n.duration!);

    return {
      'total': allNotes.length,
      'positive': positive,
      'neutral': neutral,
      'negative': negative,
      'totalDurationSeconds': totalDuration,
      'totalDurationMinutes': totalDuration / 60,
      'avgDurationSeconds': allNotes.isNotEmpty ? totalDuration / allNotes.length : 0,
    };
  }

  /// Extract action items from voice notes
  static Future<List<Map<String, dynamic>>> extractActionItems(
    Session session,
    int studentProfileId,
  ) async {
    final recentNotes = await VoiceNote.db.find(
      session,
      where: (t) => t.studentProfileId.equals(studentProfileId),
      orderBy: (t) => t.recordedAt,
      orderDescending: true,
      limit: 20,
    );

    final actionItems = <Map<String, dynamic>>[];

    for (final note in recentNotes) {
      final text = note.transcription.toLowerCase();
      
      // Look for action indicators
      if (text.contains('need to') || 
          text.contains('should') || 
          text.contains('must') ||
          text.contains('todo') ||
          text.contains('remind')) {
        actionItems.add({
          'noteId': note.id,
          'transcription': note.transcription,
          'recordedAt': note.recordedAt,
        });
      }
    }

    return actionItems;
  }
}