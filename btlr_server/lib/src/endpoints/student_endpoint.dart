import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for managing student profiles
class StudentEndpoint extends Endpoint {
  /// Create a new student profile
  Future<StudentProfile> createProfile(
    Session session,
    String name,
    String email,
    String timezone,
    String wakeTime,
    String sleepTime,
    int preferredStudyBlockMinutes,
    int preferredBreakMinutes,
    String? preferredStudyTimes,
  ) async {
    // Validate email format
    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    // Validate time format
    if (!_isValidTime(wakeTime) || !_isValidTime(sleepTime)) {
      throw Exception('Invalid time format. Use HH:mm (e.g., 07:00)');
    }

    // Check if email already exists
    final existing = await StudentProfile.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email),
    );

    if (existing != null) {
      throw Exception('Profile with email $email already exists');
    }

    final profile = StudentProfile(
      name: name,
      email: email,
      timezone: timezone,
      wakeTime: wakeTime,
      sleepTime: sleepTime,
      preferredStudyBlockMinutes: preferredStudyBlockMinutes,
      preferredBreakMinutes: preferredBreakMinutes,
      preferredStudyTimes: preferredStudyTimes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final saved = await StudentProfile.db.insertRow(session, profile);
    session.log('Created student profile: ${saved.id}');
    return saved;
  }

  /// Get student profile by ID
  Future<StudentProfile?> getProfile(Session session, int id) async {
    return await StudentProfile.db.findById(session, id);
  }

  /// Get student profile by email
  Future<StudentProfile?> getProfileByEmail(
    Session session,
    String email,
  ) async {
    return await StudentProfile.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email),
    );
  }

 /// Update student profile
Future<StudentProfile?> updateProfile(
  Session session,
  int studentId,
  String? name,
  String? timezone,
  String? wakeTime,
  String? sleepTime,
  int? preferredStudyBlockMinutes,
  int? preferredBreakMinutes,
  String? preferredStudyTimes,
  // ADD NEW PARAMETERS
  String? githubUsername,
  String? leetcodeUsername,
  String? codeforcesUsername,
  String? linkedinUrl,
  String? portfolioUrl,
) async {
  try {
    var profile = await StudentProfile.db.findById(session, studentId);
    if (profile == null) return null;

    // Update fields if provided
    if (name != null) profile.name = name;
    if (timezone != null) profile.timezone = timezone;
    if (wakeTime != null) profile.wakeTime = wakeTime;
    if (sleepTime != null) profile.sleepTime = sleepTime;
    if (preferredStudyBlockMinutes != null) profile.preferredStudyBlockMinutes = preferredStudyBlockMinutes;
    if (preferredBreakMinutes != null) profile.preferredBreakMinutes = preferredBreakMinutes;
    if (preferredStudyTimes != null) profile.preferredStudyTimes = preferredStudyTimes;
    
    // UPDATE NEW FIELDS
    if (githubUsername != null) profile.githubUsername = githubUsername;
    if (leetcodeUsername != null) profile.leetcodeUsername = leetcodeUsername;
    if (codeforcesUsername != null) profile.codeforcesUsername = codeforcesUsername;
    if (linkedinUrl != null) profile.linkedinUrl = linkedinUrl;
    if (portfolioUrl != null) profile.portfolioUrl = portfolioUrl;

    profile.updatedAt = DateTime.now();

    return await StudentProfile.db.updateRow(session, profile);
  } catch (e) {
    session.log('Error updating profile: $e');
    return null;
  }
}

  /// Delete student profile (soft delete by setting email to archived)
  Future<bool> deleteProfile(Session session, int id) async {
    final profile = await StudentProfile.db.findById(session, id);
    if (profile == null) {
      return false;
    }

    // Archive the email to allow future signups
    profile.email = 'archived_${profile.id}_${profile.email}';
    profile.updatedAt = DateTime.now();
    await StudentProfile.db.updateRow(session, profile);

    session.log('Archived student profile: $id');
    return true;
  }

  /// List all profiles (for admin purposes)
  Future<List<StudentProfile>> listProfiles(
    Session session, {
    int limit = 50,
    int offset = 0,
  }) async {
    return await StudentProfile.db.find(
      session,
      limit: limit,
      offset: offset,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Validate time format (HH:mm)
  bool _isValidTime(String time) {
    final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    return timeRegex.hasMatch(time);
  }

  /// Update student profile links
Future<StudentProfile?> updateProfileLinks(
  Session session,
  int studentId, {
  String? githubUsername,
  String? leetcodeUsername,
  String? codeforcesUsername,
  String? linkedinUrl,
  String? portfolioUrl,
}) async {
  try {
    var profile = await StudentProfile.db.findById(session, studentId);
    if (profile == null) return null;
    
    if (githubUsername != null) profile.githubUsername = githubUsername;
    if (leetcodeUsername != null) profile.leetcodeUsername = leetcodeUsername;
    if (codeforcesUsername != null) profile.codeforcesUsername = codeforcesUsername;
    if (linkedinUrl != null) profile.linkedinUrl = linkedinUrl;
    if (portfolioUrl != null) profile.portfolioUrl = portfolioUrl;
    
    return await StudentProfile.db.updateRow(session, profile);
  } catch (e) {
    session.log('Error updating profile links: $e');
    return null;
  }
}

}