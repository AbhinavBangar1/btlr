import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/voice_service.dart';

/// Endpoint for voice commands and voice notes
class VoiceEndpoint extends Endpoint {
  /// Process a voice command
  Future<Map<String, dynamic>> processCommand(
    Session session,
    int studentProfileId,
    String transcription,
  ) async {
    try {
      final result = await VoiceService.processVoiceCommand(
        session,
        studentProfileId,
        transcription,
      );
      session.log('Processed voice command for student: $studentProfileId');
      return result;
    } catch (e) {
      session.log('Failed to process voice command: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Create a voice note
  Future<VoiceNote> createNote(
    Session session,
    int studentProfileId,
    String transcription,
    int? learningGoalId,
    String? originalAudioUrl,
    int? duration,
    String? tags,
    String? sentiment,
    String? category,
    String? searchableContent,
  ) async {
    // Validate student exists
    final student = await StudentProfile.db.findById(session, studentProfileId);
    if (student == null) {
      throw Exception('Student profile not found');
    }

    // Validate related goal if provided
    if (learningGoalId != null) {
      final goal = await LearningGoal.db.findById(session, learningGoalId);
      if (goal == null) {
        throw Exception('Related goal not found');
      }
    }

    // Validate category if provided
    if (category != null && !['idea', 'reflection', 'question', 'progress'].contains(category)) {
      throw Exception('Invalid category. Must be: idea, reflection, question, or progress');
    }

    // Validate sentiment if provided
    if (sentiment != null && !['positive', 'neutral', 'negative', 'frustrated'].contains(sentiment)) {
      throw Exception('Invalid sentiment. Must be: positive, neutral, negative, or frustrated');
    }

    final note = VoiceNote(
      studentProfileId: studentProfileId,
      learningGoalId: learningGoalId,
      transcription: transcription,
      originalAudioUrl: originalAudioUrl,
      recordedAt: DateTime.now(),
      duration: duration,
      tags: tags,
      sentiment: sentiment,
      category: category,
      searchableContent: searchableContent ?? transcription,
    );

    final saved = await VoiceNote.db.insertRow(session, note);
    session.log('Created voice note: ${saved.id}');
    return saved;
  }

  /// Get voice note by ID
  Future<VoiceNote?> getNote(Session session, int id) async {
    return await VoiceNote.db.findById(session, id);
  }

  /// Get all voice notes for a student
  Future<List<VoiceNote>> getStudentNotes(
    Session session,
    int studentProfileId,
    {String? category, int limit = 50}
  ) async {
    if (category != null) {
      return await VoiceNote.db.find(
        session,
        where: (t) => 
            t.studentProfileId.equals(studentProfileId) & 
            t.category.equals(category),
        orderBy: (t) => t.recordedAt,
        orderDescending: true,
        limit: limit,
      );
    }
  
  return await VoiceNote.db.find(
    session,
    where: (t) => t.studentProfileId.equals(studentProfileId),
    orderBy: (t) => t.recordedAt,
    orderDescending: true,
    limit: limit,
  );
}

  /// Get voice notes related to a goal
  Future<List<VoiceNote>> getGoalNotes(
    Session session,
    int goalId,
  ) async {
    return await VoiceNote.db.find(
      session,
      where: (t) => t.learningGoalId.equals(goalId),
      orderBy: (t) => t.recordedAt,
      orderDescending: true,
    );
  }

  /// Get voice notes by sentiment
  Future<List<VoiceNote>> getNotesBySentiment(
    Session session,
    int studentProfileId,
    String sentiment,
  ) async {
    return await VoiceNote.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.sentiment.equals(sentiment),
      orderBy: (t) => t.recordedAt,
      orderDescending: true,
    );
  }

  /// Get voice notes by category
  Future<List<VoiceNote>> getNotesByCategory(
    Session session,
    int studentProfileId,
    String category,
  ) async {
    return await VoiceNote.db.find(
      session,
      where: (t) =>
          t.studentProfileId.equals(studentProfileId) &
          t.category.equals(category),
      orderBy: (t) => t.recordedAt,
      orderDescending: true,
    );
  }

  /// Search voice notes by transcription or searchable content
  Future<List<VoiceNote>> searchNotes(
    Session session,
    int studentProfileId,
    String searchQuery,
  ) async {
    // Simple implementation - for production, use full-text search
    final allNotes = await VoiceNote.db.find(
      session,
      where: (t) => t.studentProfileId.equals(studentProfileId),
      orderBy: (t) => t.recordedAt,
      orderDescending: true,
    );

    final matching = allNotes.where((note) {
      final transcriptionMatch = note.transcription.toLowerCase().contains(searchQuery.toLowerCase());
      final searchableMatch = note.searchableContent?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false;
      return transcriptionMatch || searchableMatch;
    }).toList();

    return matching;
  }

  /// Update voice note
  Future<VoiceNote> updateNote(
    Session session,
    int id,
    String? transcription,
    int? learningGoalId,
    String? tags,
    String? sentiment,
    String? category,
    String? searchableContent,
  ) async {
    final note = await VoiceNote.db.findById(session, id);
    if (note == null) {
      throw Exception('Voice note not found');
    }

    // Validate category if provided
    if (category != null && !['idea', 'reflection', 'question', 'progress'].contains(category)) {
      throw Exception('Invalid category');
    }

    // Validate sentiment if provided
    if (sentiment != null && !['positive', 'neutral', 'negative', 'frustrated'].contains(sentiment)) {
      throw Exception('Invalid sentiment');
    }

    // Update fields
    if (transcription != null) note.transcription = transcription;
    if (learningGoalId != null) note.learningGoalId = learningGoalId;
    if (tags != null) note.tags = tags;
    if (sentiment != null) note.sentiment = sentiment;
    if (category != null) note.category = category;
    if (searchableContent != null) note.searchableContent = searchableContent;

    final updated = await VoiceNote.db.updateRow(session, note);
    session.log('Updated voice note: $id');
    return updated;
  }

  /// Delete voice note
  Future<bool> deleteNote(Session session, int id) async {
    final note = await VoiceNote.db.findById(session, id);
    if (note == null) {
      return false;
    }

    await VoiceNote.db.deleteRow(session, note);
    session.log('Deleted voice note: $id');
    return true;
  }

  /// Get voice note statistics
  Future<Map<String, dynamic>> getNoteStats(
    Session session,
    int studentProfileId,
  ) async {
    final notes = await VoiceNote.db.find(
      session,
      where: (t) => t.studentProfileId.equals(studentProfileId),
    );

    final totalNotes = notes.length;
    final totalDuration = notes
        .map((n) => n.duration ?? 0)
        .fold<int>(0, (sum, duration) => sum + duration);

    final byCategory = <String, int>{};
    final bySentiment = <String, int>{};
    
    for (final note in notes) {
      if (note.category != null) {
        byCategory[note.category!] = (byCategory[note.category!] ?? 0) + 1;
      }
      if (note.sentiment != null) {
        bySentiment[note.sentiment!] = (bySentiment[note.sentiment!] ?? 0) + 1;
      }
    }

    final withGoalLink = notes.where((n) => n.learningGoalId != null).length;
    final withAudio = notes.where((n) => n.originalAudioUrl != null).length;

    return {
      'totalNotes': totalNotes,
      'totalDurationSeconds': totalDuration,
      'totalDurationMinutes': (totalDuration / 60).round(),
      'byCategory': byCategory,
      'bySentiment': bySentiment,
      'withGoalLink': withGoalLink,
      'withAudio': withAudio,
      'averageDurationSeconds': totalNotes > 0 ? totalDuration / totalNotes : 0,
    };
  }

  /// Get recent voice commands
  Future<List<Map<String, dynamic>>> getRecentCommands(
    Session session,
    int studentProfileId,
    {int limit = 20}
  ) async {
    // This would typically come from a command_history table
    // For now, return an empty list as placeholder
    session.log('getRecentCommands called - implementation pending');
    return [];
  }

  // Parse and validate voice command
  Future<Map<String, dynamic>> parseCommand(
    Session session,
    String transcription,
  ) async {
    try {
      // Basic parsing - extract intent from transcription
      final lowerTranscription = transcription.toLowerCase();

      String intent = 'unknown';
      Map<String, dynamic> params = {};

      if (lowerTranscription.contains('generate') && lowerTranscription.contains('plan')) {
        intent = 'generate_plan';
      } else if (lowerTranscription.contains('show') && lowerTranscription.contains('goal')) {
        intent = 'show_goals';
      } else if (lowerTranscription.contains('complete')) {
        intent = 'mark_complete';
      } else if (lowerTranscription.contains('missed')) {
        intent = 'mark_missed';
      }

      return {
        'intent': intent,
        'originalText': transcription,
        'params': params,
      };
    } catch (e) {
      session.log('Failed to parse command: $e', level: LogLevel.error);
      rethrow;
    }
  }
  

  /// Get suggested voice commands (help system)
  Future<List<Map<String, dynamic>>> getSuggestedCommands(
    Session session,
    int studentProfileId,
  ) async {
    // Return common voice commands with examples
    return [
      {
        'category': 'Plan Management',
        'commands': [
          {'text': 'Generate my plan for today', 'description': 'Creates daily schedule'},
          {'text': 'Show my schedule for tomorrow', 'description': 'Displays upcoming plan'},
          {'text': 'Regenerate today\'s plan', 'description': 'Creates new version'},
        ]
      },
      {
        'category': 'Goal Management',
        'commands': [
          {'text': 'Add new goal: Learn React', 'description': 'Creates learning goal'},
          {'text': 'Show my active goals', 'description': 'Lists current goals'},
          {'text': 'Mark goal as complete', 'description': 'Updates goal status'},
        ]
      },
      {
        'category': 'Behavior Tracking',
        'commands': [
          {'text': 'Mark current block as complete', 'description': 'Logs completion'},
          {'text': 'I missed my study session', 'description': 'Logs missed block'},
          {'text': 'Show my completion rate', 'description': 'Displays stats'},
        ]
      },
      {
        'category': 'Opportunities',
        'commands': [
          {'text': 'Show relevant opportunities', 'description': 'Lists high-relevance items'},
          {'text': 'What deadlines are coming up', 'description': 'Shows upcoming dates'},
          {'text': 'Find hackathons', 'description': 'Filters by type'},
        ]
      },
      {
        'category': 'Notes',
        'commands': [
          {'text': 'Create a note about...', 'description': 'Saves voice note'},
          {'text': 'Show my recent notes', 'description': 'Lists voice notes'},
          {'text': 'Search notes for React', 'description': 'Finds matching notes'},
        ]
      },
    ];
  }

  /// Bulk delete voice notes
  Future<int> bulkDeleteNotes(
    Session session,
    int studentProfileId,
    List<int> noteIds,
  ) async {
    int deleted = 0;
    
    for (final id in noteIds) {
      final note = await VoiceNote.db.findById(session, id);
      if (note != null && note.studentProfileId == studentProfileId) {
        await VoiceNote.db.deleteRow(session, note);
        deleted++;
      }
    }

    session.log('Bulk deleted $deleted voice notes');
    return deleted;
  }

  /// Export voice notes (returns data for backup)
  Future<List<Map<String, dynamic>>> exportNotes(
    Session session,
    int studentProfileId,
  ) async {
    final notes = await VoiceNote.db.find(
      session,
      where: (t) => t.studentProfileId.equals(studentProfileId),
      orderBy: (t) => t.recordedAt,
    );

    return notes.map((note) => {
      'id': note.id,
      'transcription': note.transcription,
      'learningGoalId': note.learningGoalId,
      'originalAudioUrl': note.originalAudioUrl,
      'recordedAt': note.recordedAt.toIso8601String(),
      'duration': note.duration,
      'tags': note.tags,
      'sentiment': note.sentiment,
      'category': note.category,
      'searchableContent': note.searchableContent,
    }).toList();
  }
}