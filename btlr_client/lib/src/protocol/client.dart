/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:btlr_client/src/protocol/academic_schedule.dart' as _i5;
import 'package:btlr_client/src/protocol/activity_tracker.dart' as _i6;
import 'package:btlr_client/src/protocol/behaviour_log.dart' as _i7;
import 'package:btlr_client/src/protocol/learning_goal.dart' as _i8;
import 'package:btlr_client/src/protocol/opportunity.dart' as _i9;
import 'package:btlr_client/src/protocol/daily_plan.dart' as _i10;
import 'package:btlr_client/src/protocol/time_block.dart' as _i11;
import 'package:btlr_client/src/protocol/user_scraping_preference.dart' as _i12;
import 'package:btlr_client/src/protocol/scraped_content.dart' as _i13;
import 'package:btlr_client/src/protocol/student_profile.dart' as _i14;
import 'package:btlr_client/src/protocol/voice_note.dart' as _i15;
import 'package:btlr_client/src/protocol/greetings/greeting.dart' as _i16;
import 'protocol.dart' as _i17;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i1.EndpointEmailIdpBase {
  EndpointEmailIdp(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i4.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i3.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// Endpoint for managing academic schedules
/// {@category Endpoint}
class EndpointAcademic extends _i2.EndpointRef {
  EndpointAcademic(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'academic';

  /// Create a new academic schedule entry
  _i3.Future<_i5.AcademicSchedule> createSchedule(
    int studentProfileId,
    String title,
    String type,
    DateTime startTime,
    DateTime endTime,
    String? location,
    bool isRecurring,
    String? rrule,
  ) => caller.callServerEndpoint<_i5.AcademicSchedule>(
    'academic',
    'createSchedule',
    {
      'studentProfileId': studentProfileId,
      'title': title,
      'type': type,
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'isRecurring': isRecurring,
      'rrule': rrule,
    },
  );

  /// Get academic schedule by ID
  _i3.Future<_i5.AcademicSchedule?> getSchedule(int id) =>
      caller.callServerEndpoint<_i5.AcademicSchedule?>(
        'academic',
        'getSchedule',
        {'id': id},
      );

  /// Get all schedules for a student
  _i3.Future<List<_i5.AcademicSchedule>> getStudentSchedules(
    int studentProfileId, {
    required bool includeDeleted,
  }) => caller.callServerEndpoint<List<_i5.AcademicSchedule>>(
    'academic',
    'getStudentSchedules',
    {
      'studentProfileId': studentProfileId,
      'includeDeleted': includeDeleted,
    },
  );

  /// Get schedules for a date range
  _i3.Future<List<_i5.AcademicSchedule>> getSchedulesInRange(
    int studentProfileId,
    DateTime startDate,
    DateTime endDate,
  ) => caller.callServerEndpoint<List<_i5.AcademicSchedule>>(
    'academic',
    'getSchedulesInRange',
    {
      'studentProfileId': studentProfileId,
      'startDate': startDate,
      'endDate': endDate,
    },
  );

  /// Update academic schedule
  _i3.Future<_i5.AcademicSchedule> updateSchedule(
    int id,
    String? title,
    String? type,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    bool? isRecurring,
    String? rrule,
  ) => caller.callServerEndpoint<_i5.AcademicSchedule>(
    'academic',
    'updateSchedule',
    {
      'id': id,
      'title': title,
      'type': type,
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'isRecurring': isRecurring,
      'rrule': rrule,
    },
  );

  /// Soft delete academic schedule
  _i3.Future<bool> deleteSchedule(int id) => caller.callServerEndpoint<bool>(
    'academic',
    'deleteSchedule',
    {'id': id},
  );

  /// Check for schedule conflicts
  _i3.Future<List<_i5.AcademicSchedule>> checkConflicts(
    int studentProfileId,
    DateTime startTime,
    DateTime endTime,
    int? excludeId,
  ) => caller.callServerEndpoint<List<_i5.AcademicSchedule>>(
    'academic',
    'checkConflicts',
    {
      'studentProfileId': studentProfileId,
      'startTime': startTime,
      'endTime': endTime,
      'excludeId': excludeId,
    },
  );

  /// Get schedules by type
  _i3.Future<List<_i5.AcademicSchedule>> getSchedulesByType(
    int studentProfileId,
    String type,
  ) => caller.callServerEndpoint<List<_i5.AcademicSchedule>>(
    'academic',
    'getSchedulesByType',
    {
      'studentProfileId': studentProfileId,
      'type': type,
    },
  );

  /// Restore soft-deleted schedule
  _i3.Future<_i5.AcademicSchedule> restoreSchedule(int id) =>
      caller.callServerEndpoint<_i5.AcademicSchedule>(
        'academic',
        'restoreSchedule',
        {'id': id},
      );

  /// Get upcoming classes (next 7 days)
  _i3.Future<List<_i5.AcademicSchedule>> getUpcomingClasses(
    int studentProfileId,
  ) => caller.callServerEndpoint<List<_i5.AcademicSchedule>>(
    'academic',
    'getUpcomingClasses',
    {'studentProfileId': studentProfileId},
  );

  /// Get today's schedule
  _i3.Future<List<_i5.AcademicSchedule>> getTodaysSchedule(
    int studentProfileId,
  ) => caller.callServerEndpoint<List<_i5.AcademicSchedule>>(
    'academic',
    'getTodaysSchedule',
    {'studentProfileId': studentProfileId},
  );
}

/// {@category Endpoint}
class EndpointActivity extends _i2.EndpointRef {
  EndpointActivity(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'activity';

  _i3.Future<bool> setupActivityTracker(
    int userId,
    String platform,
    String username,
  ) => caller.callServerEndpoint<bool>(
    'activity',
    'setupActivityTracker',
    {
      'userId': userId,
      'platform': platform,
      'username': username,
    },
  );

  _i3.Future<List<_i6.ActivityTracker>> getUserActivityTrackers(int userId) =>
      caller.callServerEndpoint<List<_i6.ActivityTracker>>(
        'activity',
        'getUserActivityTrackers',
        {'userId': userId},
      );

  _i3.Future<bool> syncAllActivities(int userId) =>
      caller.callServerEndpoint<bool>(
        'activity',
        'syncAllActivities',
        {'userId': userId},
      );

  _i3.Future<Map<String, dynamic>?> syncPlatformActivity(
    int userId,
    String platform,
  ) => caller.callServerEndpoint<Map<String, dynamic>?>(
    'activity',
    'syncPlatformActivity',
    {
      'userId': userId,
      'platform': platform,
    },
  );

  _i3.Future<Map<String, dynamic>?> getActivityData(
    int userId,
    String platform,
  ) => caller.callServerEndpoint<Map<String, dynamic>?>(
    'activity',
    'getActivityData',
    {
      'userId': userId,
      'platform': platform,
    },
  );

  _i3.Future<bool> deleteActivityTracker(
    int userId,
    String platform,
  ) => caller.callServerEndpoint<bool>(
    'activity',
    'deleteActivityTracker',
    {
      'userId': userId,
      'platform': platform,
    },
  );

  _i3.Future<Map<String, dynamic>> getDashboard(int userId) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'activity',
        'getDashboard',
        {'userId': userId},
      );
}

/// Endpoint for logging and analyzing behavior patterns
/// {@category Endpoint}
class EndpointBehavior extends _i2.EndpointRef {
  EndpointBehavior(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'behavior';

  /// Log completion of a time block
  _i3.Future<_i7.BehaviorLog> logCompletion(
    int studentProfileId,
    int timeBlockId,
    int? actualDuration,
    int? energyLevel,
    String? notes,
  ) => caller.callServerEndpoint<_i7.BehaviorLog>(
    'behavior',
    'logCompletion',
    {
      'studentProfileId': studentProfileId,
      'timeBlockId': timeBlockId,
      'actualDuration': actualDuration,
      'energyLevel': energyLevel,
      'notes': notes,
    },
  );

  /// Log missed time block
  _i3.Future<_i7.BehaviorLog> logMiss(
    int studentProfileId,
    int timeBlockId,
    String reason,
    String? notes,
  ) => caller.callServerEndpoint<_i7.BehaviorLog>(
    'behavior',
    'logMiss',
    {
      'studentProfileId': studentProfileId,
      'timeBlockId': timeBlockId,
      'reason': reason,
      'notes': notes,
    },
  );

  /// Log postponed time block
  _i3.Future<_i7.BehaviorLog> logPostpone(
    int studentProfileId,
    int timeBlockId,
    String reason,
    String? notes,
  ) => caller.callServerEndpoint<_i7.BehaviorLog>(
    'behavior',
    'logPostpone',
    {
      'studentProfileId': studentProfileId,
      'timeBlockId': timeBlockId,
      'reason': reason,
      'notes': notes,
    },
  );

  /// Log starting a time block
  _i3.Future<_i7.BehaviorLog> logStart(
    int studentProfileId,
    int timeBlockId,
    String? notes,
  ) => caller.callServerEndpoint<_i7.BehaviorLog>(
    'behavior',
    'logStart',
    {
      'studentProfileId': studentProfileId,
      'timeBlockId': timeBlockId,
      'notes': notes,
    },
  );

  /// Get behavior log by ID
  _i3.Future<_i7.BehaviorLog?> getLog(int id) =>
      caller.callServerEndpoint<_i7.BehaviorLog?>(
        'behavior',
        'getLog',
        {'id': id},
      );

  /// Get all logs for a time block
  _i3.Future<List<_i7.BehaviorLog>> getBlockLogs(int timeBlockId) =>
      caller.callServerEndpoint<List<_i7.BehaviorLog>>(
        'behavior',
        'getBlockLogs',
        {'timeBlockId': timeBlockId},
      );

  /// Get all logs for a student
  _i3.Future<List<_i7.BehaviorLog>> getStudentLogs(
    int studentProfileId, {
    required int limit,
  }) => caller.callServerEndpoint<List<_i7.BehaviorLog>>(
    'behavior',
    'getStudentLogs',
    {
      'studentProfileId': studentProfileId,
      'limit': limit,
    },
  );

  /// Get logs in date range
  _i3.Future<List<_i7.BehaviorLog>> getLogsInRange(
    int studentProfileId,
    DateTime startDate,
    DateTime endDate,
  ) => caller.callServerEndpoint<List<_i7.BehaviorLog>>(
    'behavior',
    'getLogsInRange',
    {
      'studentProfileId': studentProfileId,
      'startDate': startDate,
      'endDate': endDate,
    },
  );

  /// Get logs by action type
  _i3.Future<List<_i7.BehaviorLog>> getLogsByAction(
    int studentProfileId,
    String action,
  ) => caller.callServerEndpoint<List<_i7.BehaviorLog>>(
    'behavior',
    'getLogsByAction',
    {
      'studentProfileId': studentProfileId,
      'action': action,
    },
  );

  /// Get completion statistics
  _i3.Future<Map<String, dynamic>> getCompletionStats(
    int studentProfileId, {
    required int days,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'behavior',
    'getCompletionStats',
    {
      'studentProfileId': studentProfileId,
      'days': days,
    },
  );

  /// Get daily completion rates
  _i3.Future<List<Map<String, dynamic>>> getDailyCompletionRates(
    int studentProfileId,
    int days,
  ) => caller.callServerEndpoint<List<Map<String, dynamic>>>(
    'behavior',
    'getDailyCompletionRates',
    {
      'studentProfileId': studentProfileId,
      'days': days,
    },
  );

  /// Analyze recent behavior patterns
  _i3.Future<Map<String, dynamic>> analyzeRecentBehavior(
    int studentProfileId, {
    required int days,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'behavior',
    'analyzeRecentBehavior',
    {
      'studentProfileId': studentProfileId,
      'days': days,
    },
  );

  /// Get optimal block length suggestion
  _i3.Future<int> getOptimalBlockLength(int studentProfileId) =>
      caller.callServerEndpoint<int>(
        'behavior',
        'getOptimalBlockLength',
        {'studentProfileId': studentProfileId},
      );

  /// Get miss reasons breakdown
  _i3.Future<Map<String, dynamic>> getMissReasonsBreakdown(
    int studentProfileId,
    int days,
  ) => caller.callServerEndpoint<Map<String, dynamic>>(
    'behavior',
    'getMissReasonsBreakdown',
    {
      'studentProfileId': studentProfileId,
      'days': days,
    },
  );

  /// Get time-of-day performance analysis
  _i3.Future<Map<String, dynamic>> getTimeOfDayPerformance(
    int studentProfileId,
    int days,
  ) => caller.callServerEndpoint<Map<String, dynamic>>(
    'behavior',
    'getTimeOfDayPerformance',
    {
      'studentProfileId': studentProfileId,
      'days': days,
    },
  );

  /// Get streak information
  _i3.Future<Map<String, dynamic>> getStreakInfo(int studentProfileId) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'behavior',
        'getStreakInfo',
        {'studentProfileId': studentProfileId},
      );

  /// Get energy level trends
  _i3.Future<Map<String, dynamic>> getEnergyTrends(
    int studentProfileId,
    int days,
  ) => caller.callServerEndpoint<Map<String, dynamic>>(
    'behavior',
    'getEnergyTrends',
    {
      'studentProfileId': studentProfileId,
      'days': days,
    },
  );

  /// Update behavior log (for corrections)
  _i3.Future<_i7.BehaviorLog> updateLog(
    int id,
    String? action,
    int? actualDuration,
    int? energyLevel,
    String? reason,
    String? notes,
    String? context,
  ) => caller.callServerEndpoint<_i7.BehaviorLog>(
    'behavior',
    'updateLog',
    {
      'id': id,
      'action': action,
      'actualDuration': actualDuration,
      'energyLevel': energyLevel,
      'reason': reason,
      'notes': notes,
      'context': context,
    },
  );

  /// Delete behavior log
  _i3.Future<bool> deleteLog(int id) => caller.callServerEndpoint<bool>(
    'behavior',
    'deleteLog',
    {'id': id},
  );
}

/// Endpoint for managing learning goals
/// {@category Endpoint}
class EndpointGoal extends _i2.EndpointRef {
  EndpointGoal(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'goal';

  /// Create a new learning goal
  _i3.Future<_i8.LearningGoal> createGoal(
    int studentProfileId,
    String title,
    String category,
    String priority,
    String? description,
    double? estimatedHours,
    DateTime? deadline,
    String? tags,
  ) => caller.callServerEndpoint<_i8.LearningGoal>(
    'goal',
    'createGoal',
    {
      'studentProfileId': studentProfileId,
      'title': title,
      'category': category,
      'priority': priority,
      'description': description,
      'estimatedHours': estimatedHours,
      'deadline': deadline,
      'tags': tags,
    },
  );

  /// Get learning goal by ID
  _i3.Future<_i8.LearningGoal?> getGoal(int id) =>
      caller.callServerEndpoint<_i8.LearningGoal?>(
        'goal',
        'getGoal',
        {'id': id},
      );

  /// Get all goals for a student
  _i3.Future<List<_i8.LearningGoal>> getStudentGoals(
    int studentProfileId, {
    String? status,
    String? priority,
    String? category,
  }) => caller.callServerEndpoint<List<_i8.LearningGoal>>(
    'goal',
    'getStudentGoals',
    {
      'studentProfileId': studentProfileId,
      'status': status,
      'priority': priority,
      'category': category,
    },
  );

  /// Get active goals (in_progress or not_started)
  _i3.Future<List<_i8.LearningGoal>> getActiveGoals(int studentProfileId) =>
      caller.callServerEndpoint<List<_i8.LearningGoal>>(
        'goal',
        'getActiveGoals',
        {'studentProfileId': studentProfileId},
      );

  /// Get goals by category
  _i3.Future<List<_i8.LearningGoal>> getGoalsByCategory(
    int studentProfileId,
    String category,
  ) => caller.callServerEndpoint<List<_i8.LearningGoal>>(
    'goal',
    'getGoalsByCategory',
    {
      'studentProfileId': studentProfileId,
      'category': category,
    },
  );

  /// Update learning goal
  _i3.Future<_i8.LearningGoal> updateGoal(
    int id,
    String? title,
    String? description,
    String? category,
    String? status,
    String? priority,
    double? estimatedHours,
    double? actualHours,
    DateTime? deadline,
    String? tags,
  ) => caller.callServerEndpoint<_i8.LearningGoal>(
    'goal',
    'updateGoal',
    {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'priority': priority,
      'estimatedHours': estimatedHours,
      'actualHours': actualHours,
      'deadline': deadline,
      'tags': tags,
    },
  );

  /// Mark goal as completed
  _i3.Future<_i8.LearningGoal> completeGoal(int id) =>
      caller.callServerEndpoint<_i8.LearningGoal>(
        'goal',
        'completeGoal',
        {'id': id},
      );

  /// Increment actual hours spent on goal
  _i3.Future<_i8.LearningGoal> addHours(
    int id,
    double hours,
  ) => caller.callServerEndpoint<_i8.LearningGoal>(
    'goal',
    'addHours',
    {
      'id': id,
      'hours': hours,
    },
  );

  /// Delete learning goal
  _i3.Future<bool> deleteGoal(int id) => caller.callServerEndpoint<bool>(
    'goal',
    'deleteGoal',
    {'id': id},
  );

  /// Get overdue goals
  _i3.Future<List<_i8.LearningGoal>> getOverdueGoals(int studentProfileId) =>
      caller.callServerEndpoint<List<_i8.LearningGoal>>(
        'goal',
        'getOverdueGoals',
        {'studentProfileId': studentProfileId},
      );

  /// Get goal progress statistics
  _i3.Future<Map<String, dynamic>> getGoalStats(int studentProfileId) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'goal',
        'getGoalStats',
        {'studentProfileId': studentProfileId},
      );

  /// Get goals by priority
  _i3.Future<List<_i8.LearningGoal>> getGoalsByPriority(
    int studentProfileId,
    String priority,
  ) => caller.callServerEndpoint<List<_i8.LearningGoal>>(
    'goal',
    'getGoalsByPriority',
    {
      'studentProfileId': studentProfileId,
      'priority': priority,
    },
  );
}

/// Endpoint for managing opportunities (internships, hackathons, scholarships)
/// {@category Endpoint}
class EndpointOpportunity extends _i2.EndpointRef {
  EndpointOpportunity(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'opportunity';

  /// Create a new opportunity
  _i3.Future<_i9.Opportunity> createOpportunity(
    String title,
    String type,
    int? studentProfileId,
    String? description,
    String? organization,
    String? sourceUrl,
    DateTime? deadline,
    String? tags,
    int? prepTimeMinutes,
  ) => caller.callServerEndpoint<_i9.Opportunity>(
    'opportunity',
    'createOpportunity',
    {
      'title': title,
      'type': type,
      'studentProfileId': studentProfileId,
      'description': description,
      'organization': organization,
      'sourceUrl': sourceUrl,
      'deadline': deadline,
      'tags': tags,
      'prepTimeMinutes': prepTimeMinutes,
    },
  );

  /// Get opportunity by ID
  _i3.Future<_i9.Opportunity?> getOpportunity(int id) =>
      caller.callServerEndpoint<_i9.Opportunity?>(
        'opportunity',
        'getOpportunity',
        {'id': id},
      );

  /// Get all opportunities for a student
  _i3.Future<List<_i9.Opportunity>> getStudentOpportunities(
    int studentProfileId, {
    String? status,
    String? type,
  }) => caller.callServerEndpoint<List<_i9.Opportunity>>(
    'opportunity',
    'getStudentOpportunities',
    {
      'studentProfileId': studentProfileId,
      'status': status,
      'type': type,
    },
  );

  /// Get unassigned opportunities (not yet matched to any student)
  _i3.Future<List<_i9.Opportunity>> getUnassignedOpportunities({
    String? type,
  }) => caller.callServerEndpoint<List<_i9.Opportunity>>(
    'opportunity',
    'getUnassignedOpportunities',
    {'type': type},
  );

  /// Get high-relevance opportunities (score > threshold)
  _i3.Future<List<_i9.Opportunity>> getRelevantOpportunities(
    int studentProfileId, {
    required double minScore,
  }) => caller.callServerEndpoint<List<_i9.Opportunity>>(
    'opportunity',
    'getRelevantOpportunities',
    {
      'studentProfileId': studentProfileId,
      'minScore': minScore,
    },
  );

  /// Get opportunities by type
  _i3.Future<List<_i9.Opportunity>> getOpportunitiesByType(
    int studentProfileId,
    String type,
  ) => caller.callServerEndpoint<List<_i9.Opportunity>>(
    'opportunity',
    'getOpportunitiesByType',
    {
      'studentProfileId': studentProfileId,
      'type': type,
    },
  );

  /// Get opportunities with upcoming deadlines
  _i3.Future<List<_i9.Opportunity>> getUpcomingDeadlines(
    int studentProfileId, {
    required int daysAhead,
  }) => caller.callServerEndpoint<List<_i9.Opportunity>>(
    'opportunity',
    'getUpcomingDeadlines',
    {
      'studentProfileId': studentProfileId,
      'daysAhead': daysAhead,
    },
  );

  /// Calculate and update relevance score for an opportunity
  _i3.Future<_i9.Opportunity> calculateRelevance(int opportunityId) =>
      caller.callServerEndpoint<_i9.Opportunity>(
        'opportunity',
        'calculateRelevance',
        {'opportunityId': opportunityId},
      );

  /// Recalculate relevance for all opportunities
  _i3.Future<List<_i9.Opportunity>> recalculateAllRelevance(
    int studentProfileId,
  ) => caller.callServerEndpoint<List<_i9.Opportunity>>(
    'opportunity',
    'recalculateAllRelevance',
    {'studentProfileId': studentProfileId},
  );

  /// Get opportunities that can be auto-injected into schedule
  _i3.Future<List<_i9.Opportunity>> getInjectableOpportunities(
    int studentProfileId,
    DateTime targetDate,
  ) => caller.callServerEndpoint<List<_i9.Opportunity>>(
    'opportunity',
    'getInjectableOpportunities',
    {
      'studentProfileId': studentProfileId,
      'targetDate': targetDate,
    },
  );

  /// Update opportunity status
  _i3.Future<_i9.Opportunity> updateStatus(
    int id,
    String status,
  ) => caller.callServerEndpoint<_i9.Opportunity>(
    'opportunity',
    'updateStatus',
    {
      'id': id,
      'status': status,
    },
  );

  /// Assign opportunity to a student
  _i3.Future<_i9.Opportunity> assignToStudent(
    int opportunityId,
    int studentProfileId,
  ) => caller.callServerEndpoint<_i9.Opportunity>(
    'opportunity',
    'assignToStudent',
    {
      'opportunityId': opportunityId,
      'studentProfileId': studentProfileId,
    },
  );

  /// Update opportunity
  _i3.Future<_i9.Opportunity> updateOpportunity(
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
  ) => caller.callServerEndpoint<_i9.Opportunity>(
    'opportunity',
    'updateOpportunity',
    {
      'id': id,
      'title': title,
      'type': type,
      'description': description,
      'organization': organization,
      'sourceUrl': sourceUrl,
      'deadline': deadline,
      'tags': tags,
      'status': status,
      'prepTimeMinutes': prepTimeMinutes,
      'relevanceScore': relevanceScore,
    },
  );

  /// Delete opportunity
  _i3.Future<bool> deleteOpportunity(int id) => caller.callServerEndpoint<bool>(
    'opportunity',
    'deleteOpportunity',
    {'id': id},
  );

  /// Search opportunities by tags
  _i3.Future<List<_i9.Opportunity>> searchByTags(
    int studentProfileId,
    List<String> searchTags,
  ) => caller.callServerEndpoint<List<_i9.Opportunity>>(
    'opportunity',
    'searchByTags',
    {
      'studentProfileId': studentProfileId,
      'searchTags': searchTags,
    },
  );

  /// Get opportunities by status
  _i3.Future<List<_i9.Opportunity>> getOpportunitiesByStatus(
    int studentProfileId,
    String status,
  ) => caller.callServerEndpoint<List<_i9.Opportunity>>(
    'opportunity',
    'getOpportunitiesByStatus',
    {
      'studentProfileId': studentProfileId,
      'status': status,
    },
  );

  /// Get opportunity statistics
  _i3.Future<Map<String, dynamic>> getOpportunityStats(int studentProfileId) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'opportunity',
        'getOpportunityStats',
        {'studentProfileId': studentProfileId},
      );

  /// Bulk import opportunities (for scraper)
  _i3.Future<List<_i9.Opportunity>> bulkImport(
    int? studentProfileId,
    List<Map<String, dynamic>> opportunitiesData,
  ) => caller.callServerEndpoint<List<_i9.Opportunity>>(
    'opportunity',
    'bulkImport',
    {
      'studentProfileId': studentProfileId,
      'opportunitiesData': opportunitiesData,
    },
  );
}

/// Endpoint for managing daily plans and time blocks
/// {@category Endpoint}
class EndpointPlan extends _i2.EndpointRef {
  EndpointPlan(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'plan';

  /// Generate a daily plan for a specific date
  _i3.Future<_i10.DailyPlan> generatePlan(
    int studentProfileId,
    DateTime date,
  ) => caller.callServerEndpoint<_i10.DailyPlan>(
    'plan',
    'generatePlan',
    {
      'studentProfileId': studentProfileId,
      'date': date,
    },
  );

  /// Generate plans for multiple days ahead
  _i3.Future<List<_i10.DailyPlan>> generateMultiplePlans(
    int studentProfileId,
    int daysAhead,
  ) => caller.callServerEndpoint<List<_i10.DailyPlan>>(
    'plan',
    'generateMultiplePlans',
    {
      'studentProfileId': studentProfileId,
      'daysAhead': daysAhead,
    },
  );

  /// Get daily plan by ID
  _i3.Future<_i10.DailyPlan?> getPlan(int id) =>
      caller.callServerEndpoint<_i10.DailyPlan?>(
        'plan',
        'getPlan',
        {'id': id},
      );

  /// Get plan for a specific date
  _i3.Future<_i10.DailyPlan?> getPlanByDate(
    int studentProfileId,
    DateTime date,
  ) => caller.callServerEndpoint<_i10.DailyPlan?>(
    'plan',
    'getPlanByDate',
    {
      'studentProfileId': studentProfileId,
      'date': date,
    },
  );

  /// Get all plans for a student
  _i3.Future<List<_i10.DailyPlan>> getStudentPlans(
    int studentProfileId, {
    required int limit,
  }) => caller.callServerEndpoint<List<_i10.DailyPlan>>(
    'plan',
    'getStudentPlans',
    {
      'studentProfileId': studentProfileId,
      'limit': limit,
    },
  );

  /// Get plans in date range
  _i3.Future<List<_i10.DailyPlan>> getPlansInRange(
    int studentProfileId,
    DateTime startDate,
    DateTime endDate,
  ) => caller.callServerEndpoint<List<_i10.DailyPlan>>(
    'plan',
    'getPlansInRange',
    {
      'studentProfileId': studentProfileId,
      'startDate': startDate,
      'endDate': endDate,
    },
  );

  /// Get time blocks for a plan
  _i3.Future<List<_i11.TimeBlock>> getPlanBlocks(int dailyPlanId) =>
      caller.callServerEndpoint<List<_i11.TimeBlock>>(
        'plan',
        'getPlanBlocks',
        {'dailyPlanId': dailyPlanId},
      );

  /// Get a specific time block
  _i3.Future<_i11.TimeBlock?> getBlock(int id) =>
      caller.callServerEndpoint<_i11.TimeBlock?>(
        'plan',
        'getBlock',
        {'id': id},
      );

  /// Get time blocks for a date range
  _i3.Future<List<_i11.TimeBlock>> getBlocksInRange(
    int studentProfileId,
    DateTime startDate,
    DateTime endDate,
  ) => caller.callServerEndpoint<List<_i11.TimeBlock>>(
    'plan',
    'getBlocksInRange',
    {
      'studentProfileId': studentProfileId,
      'startDate': startDate,
      'endDate': endDate,
    },
  );

  /// Update a time block
  _i3.Future<_i11.TimeBlock> updateBlock(
    int id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    bool? isCompleted,
    String? completionStatus,
    int? actualDurationMinutes,
    int? energyLevel,
    String? notes,
    String? missReason,
  ) => caller.callServerEndpoint<_i11.TimeBlock>(
    'plan',
    'updateBlock',
    {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'completionStatus': completionStatus,
      'actualDurationMinutes': actualDurationMinutes,
      'energyLevel': energyLevel,
      'notes': notes,
      'missReason': missReason,
    },
  );

  /// Mark time block as completed
  _i3.Future<_i11.TimeBlock> completeBlock(
    int id,
    int? actualDurationMinutes,
    int? energyLevel,
    String? notes,
  ) => caller.callServerEndpoint<_i11.TimeBlock>(
    'plan',
    'completeBlock',
    {
      'id': id,
      'actualDurationMinutes': actualDurationMinutes,
      'energyLevel': energyLevel,
      'notes': notes,
    },
  );

  /// Mark time block as missed
  _i3.Future<_i11.TimeBlock> missBlock(
    int id,
    String missReason,
    String? notes,
  ) => caller.callServerEndpoint<_i11.TimeBlock>(
    'plan',
    'missBlock',
    {
      'id': id,
      'missReason': missReason,
      'notes': notes,
    },
  );

  /// Delete a time block
  _i3.Future<bool> deleteBlock(int id) => caller.callServerEndpoint<bool>(
    'plan',
    'deleteBlock',
    {'id': id},
  );

  /// Regenerate a plan (creates new version)
  _i3.Future<_i10.DailyPlan> regeneratePlan(int dailyPlanId) =>
      caller.callServerEndpoint<_i10.DailyPlan>(
        'plan',
        'regeneratePlan',
        {'dailyPlanId': dailyPlanId},
      );

  /// Get today's plan (convenience method)
  _i3.Future<_i10.DailyPlan?> getTodaysPlan(int studentProfileId) =>
      caller.callServerEndpoint<_i10.DailyPlan?>(
        'plan',
        'getTodaysPlan',
        {'studentProfileId': studentProfileId},
      );

  /// Get or generate today's plan
  _i3.Future<_i10.DailyPlan> getOrGenerateTodaysPlan(int studentProfileId) =>
      caller.callServerEndpoint<_i10.DailyPlan>(
        'plan',
        'getOrGenerateTodaysPlan',
        {'studentProfileId': studentProfileId},
      );

  /// Get upcoming time blocks (next 24 hours)
  _i3.Future<List<_i11.TimeBlock>> getUpcomingBlocks(int studentProfileId) =>
      caller.callServerEndpoint<List<_i11.TimeBlock>>(
        'plan',
        'getUpcomingBlocks',
        {'studentProfileId': studentProfileId},
      );

  /// Get current time block (what should be happening now)
  _i3.Future<_i11.TimeBlock?> getCurrentBlock(int studentProfileId) =>
      caller.callServerEndpoint<_i11.TimeBlock?>(
        'plan',
        'getCurrentBlock',
        {'studentProfileId': studentProfileId},
      );

  /// Get blocks by completion status
  _i3.Future<List<_i11.TimeBlock>> getBlocksByStatus(
    int dailyPlanId,
    String completionStatus,
  ) => caller.callServerEndpoint<List<_i11.TimeBlock>>(
    'plan',
    'getBlocksByStatus',
    {
      'dailyPlanId': dailyPlanId,
      'completionStatus': completionStatus,
    },
  );

  /// Get plan statistics
  _i3.Future<Map<String, dynamic>> getPlanStats(int studentProfileId) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'plan',
        'getPlanStats',
        {'studentProfileId': studentProfileId},
      );
}

/// {@category Endpoint}
class EndpointScraping extends _i2.EndpointRef {
  EndpointScraping(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'scraping';

  _i3.Future<bool> addCustomScrapingUrl(
    int userId,
    String platform,
    String customUrl,
  ) => caller.callServerEndpoint<bool>(
    'scraping',
    'addCustomScrapingUrl',
    {
      'userId': userId,
      'platform': platform,
      'customUrl': customUrl,
    },
  );

  _i3.Future<List<_i12.UserScrapingPreference>> getUserScrapingPreferences(
    int userId,
  ) => caller.callServerEndpoint<List<_i12.UserScrapingPreference>>(
    'scraping',
    'getUserScrapingPreferences',
    {'userId': userId},
  );

  _i3.Future<List<_i13.ScrapedContent>> scrapeAllPlatforms(int userId) =>
      caller.callServerEndpoint<List<_i13.ScrapedContent>>(
        'scraping',
        'scrapeAllPlatforms',
        {'userId': userId},
      );

  _i3.Future<List<_i13.ScrapedContent>> scrapePlatform(
    int userId,
    String platform,
  ) => caller.callServerEndpoint<List<_i13.ScrapedContent>>(
    'scraping',
    'scrapePlatform',
    {
      'userId': userId,
      'platform': platform,
    },
  );

  _i3.Future<List<_i13.ScrapedContent>> getScrapedContent(
    int userId,
    String? platform,
    bool? isRead,
    int limit,
  ) => caller.callServerEndpoint<List<_i13.ScrapedContent>>(
    'scraping',
    'getScrapedContent',
    {
      'userId': userId,
      'platform': platform,
      'isRead': isRead,
      'limit': limit,
    },
  );

  _i3.Future<bool> markAsRead(int contentId) => caller.callServerEndpoint<bool>(
    'scraping',
    'markAsRead',
    {'contentId': contentId},
  );

  _i3.Future<int> deleteOldContent(
    int userId,
    int daysOld,
  ) => caller.callServerEndpoint<int>(
    'scraping',
    'deleteOldContent',
    {
      'userId': userId,
      'daysOld': daysOld,
    },
  );
}

/// Endpoint for managing student profiles
/// {@category Endpoint}
class EndpointStudent extends _i2.EndpointRef {
  EndpointStudent(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'student';

  /// Create a new student profile
  _i3.Future<_i14.StudentProfile> createProfile(
    String name,
    String email,
    String timezone,
    String wakeTime,
    String sleepTime,
    int preferredStudyBlockMinutes,
    int preferredBreakMinutes,
    String? preferredStudyTimes,
  ) => caller.callServerEndpoint<_i14.StudentProfile>(
    'student',
    'createProfile',
    {
      'name': name,
      'email': email,
      'timezone': timezone,
      'wakeTime': wakeTime,
      'sleepTime': sleepTime,
      'preferredStudyBlockMinutes': preferredStudyBlockMinutes,
      'preferredBreakMinutes': preferredBreakMinutes,
      'preferredStudyTimes': preferredStudyTimes,
    },
  );

  /// Get student profile by ID
  _i3.Future<_i14.StudentProfile?> getProfile(int id) =>
      caller.callServerEndpoint<_i14.StudentProfile?>(
        'student',
        'getProfile',
        {'id': id},
      );

  /// Get student profile by email
  _i3.Future<_i14.StudentProfile?> getProfileByEmail(String email) =>
      caller.callServerEndpoint<_i14.StudentProfile?>(
        'student',
        'getProfileByEmail',
        {'email': email},
      );

  /// Update student profile
  _i3.Future<_i14.StudentProfile> updateProfile(
    int id,
    String? name,
    String? timezone,
    String? wakeTime,
    String? sleepTime,
    int? preferredStudyBlockMinutes,
    int? preferredBreakMinutes,
    String? preferredStudyTimes,
  ) => caller.callServerEndpoint<_i14.StudentProfile>(
    'student',
    'updateProfile',
    {
      'id': id,
      'name': name,
      'timezone': timezone,
      'wakeTime': wakeTime,
      'sleepTime': sleepTime,
      'preferredStudyBlockMinutes': preferredStudyBlockMinutes,
      'preferredBreakMinutes': preferredBreakMinutes,
      'preferredStudyTimes': preferredStudyTimes,
    },
  );

  /// Delete student profile (soft delete by setting email to archived)
  _i3.Future<bool> deleteProfile(int id) => caller.callServerEndpoint<bool>(
    'student',
    'deleteProfile',
    {'id': id},
  );

  /// List all profiles (for admin purposes)
  _i3.Future<List<_i14.StudentProfile>> listProfiles({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i14.StudentProfile>>(
    'student',
    'listProfiles',
    {
      'limit': limit,
      'offset': offset,
    },
  );
}

/// Endpoint for voice commands and voice notes
/// {@category Endpoint}
class EndpointVoice extends _i2.EndpointRef {
  EndpointVoice(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'voice';

  /// Process a voice command
  _i3.Future<Map<String, dynamic>> processCommand(
    int studentProfileId,
    String transcription,
  ) => caller.callServerEndpoint<Map<String, dynamic>>(
    'voice',
    'processCommand',
    {
      'studentProfileId': studentProfileId,
      'transcription': transcription,
    },
  );

  /// Create a voice note
  _i3.Future<_i15.VoiceNote> createNote(
    int studentProfileId,
    String transcription,
    int? learningGoalId,
    String? originalAudioUrl,
    int? duration,
    String? tags,
    String? sentiment,
    String? category,
    String? searchableContent,
  ) => caller.callServerEndpoint<_i15.VoiceNote>(
    'voice',
    'createNote',
    {
      'studentProfileId': studentProfileId,
      'transcription': transcription,
      'learningGoalId': learningGoalId,
      'originalAudioUrl': originalAudioUrl,
      'duration': duration,
      'tags': tags,
      'sentiment': sentiment,
      'category': category,
      'searchableContent': searchableContent,
    },
  );

  /// Get voice note by ID
  _i3.Future<_i15.VoiceNote?> getNote(int id) =>
      caller.callServerEndpoint<_i15.VoiceNote?>(
        'voice',
        'getNote',
        {'id': id},
      );

  /// Get all voice notes for a student
  _i3.Future<List<_i15.VoiceNote>> getStudentNotes(
    int studentProfileId, {
    String? category,
    required int limit,
  }) => caller.callServerEndpoint<List<_i15.VoiceNote>>(
    'voice',
    'getStudentNotes',
    {
      'studentProfileId': studentProfileId,
      'category': category,
      'limit': limit,
    },
  );

  /// Get voice notes related to a goal
  _i3.Future<List<_i15.VoiceNote>> getGoalNotes(int goalId) =>
      caller.callServerEndpoint<List<_i15.VoiceNote>>(
        'voice',
        'getGoalNotes',
        {'goalId': goalId},
      );

  /// Get voice notes by sentiment
  _i3.Future<List<_i15.VoiceNote>> getNotesBySentiment(
    int studentProfileId,
    String sentiment,
  ) => caller.callServerEndpoint<List<_i15.VoiceNote>>(
    'voice',
    'getNotesBySentiment',
    {
      'studentProfileId': studentProfileId,
      'sentiment': sentiment,
    },
  );

  /// Get voice notes by category
  _i3.Future<List<_i15.VoiceNote>> getNotesByCategory(
    int studentProfileId,
    String category,
  ) => caller.callServerEndpoint<List<_i15.VoiceNote>>(
    'voice',
    'getNotesByCategory',
    {
      'studentProfileId': studentProfileId,
      'category': category,
    },
  );

  /// Search voice notes by transcription or searchable content
  _i3.Future<List<_i15.VoiceNote>> searchNotes(
    int studentProfileId,
    String searchQuery,
  ) => caller.callServerEndpoint<List<_i15.VoiceNote>>(
    'voice',
    'searchNotes',
    {
      'studentProfileId': studentProfileId,
      'searchQuery': searchQuery,
    },
  );

  /// Update voice note
  _i3.Future<_i15.VoiceNote> updateNote(
    int id,
    String? transcription,
    int? learningGoalId,
    String? tags,
    String? sentiment,
    String? category,
    String? searchableContent,
  ) => caller.callServerEndpoint<_i15.VoiceNote>(
    'voice',
    'updateNote',
    {
      'id': id,
      'transcription': transcription,
      'learningGoalId': learningGoalId,
      'tags': tags,
      'sentiment': sentiment,
      'category': category,
      'searchableContent': searchableContent,
    },
  );

  /// Delete voice note
  _i3.Future<bool> deleteNote(int id) => caller.callServerEndpoint<bool>(
    'voice',
    'deleteNote',
    {'id': id},
  );

  /// Get voice note statistics
  _i3.Future<Map<String, dynamic>> getNoteStats(int studentProfileId) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'voice',
        'getNoteStats',
        {'studentProfileId': studentProfileId},
      );

  /// Get recent voice commands
  _i3.Future<List<Map<String, dynamic>>> getRecentCommands(
    int studentProfileId, {
    required int limit,
  }) => caller.callServerEndpoint<List<Map<String, dynamic>>>(
    'voice',
    'getRecentCommands',
    {
      'studentProfileId': studentProfileId,
      'limit': limit,
    },
  );

  _i3.Future<Map<String, dynamic>> parseCommand(String transcription) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'voice',
        'parseCommand',
        {'transcription': transcription},
      );

  /// Get suggested voice commands (help system)
  _i3.Future<List<Map<String, dynamic>>> getSuggestedCommands(
    int studentProfileId,
  ) => caller.callServerEndpoint<List<Map<String, dynamic>>>(
    'voice',
    'getSuggestedCommands',
    {'studentProfileId': studentProfileId},
  );

  /// Bulk delete voice notes
  _i3.Future<int> bulkDeleteNotes(
    int studentProfileId,
    List<int> noteIds,
  ) => caller.callServerEndpoint<int>(
    'voice',
    'bulkDeleteNotes',
    {
      'studentProfileId': studentProfileId,
      'noteIds': noteIds,
    },
  );

  /// Export voice notes (returns data for backup)
  _i3.Future<List<Map<String, dynamic>>> exportNotes(int studentProfileId) =>
      caller.callServerEndpoint<List<Map<String, dynamic>>>(
        'voice',
        'exportNotes',
        {'studentProfileId': studentProfileId},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i2.EndpointRef {
  EndpointGreeting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i3.Future<_i16.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i16.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i1.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i17.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    academic = EndpointAcademic(this);
    activity = EndpointActivity(this);
    behavior = EndpointBehavior(this);
    goal = EndpointGoal(this);
    opportunity = EndpointOpportunity(this);
    plan = EndpointPlan(this);
    scraping = EndpointScraping(this);
    student = EndpointStudent(this);
    voice = EndpointVoice(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAcademic academic;

  late final EndpointActivity activity;

  late final EndpointBehavior behavior;

  late final EndpointGoal goal;

  late final EndpointOpportunity opportunity;

  late final EndpointPlan plan;

  late final EndpointScraping scraping;

  late final EndpointStudent student;

  late final EndpointVoice voice;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'academic': academic,
    'activity': activity,
    'behavior': behavior,
    'goal': goal,
    'opportunity': opportunity,
    'plan': plan,
    'scraping': scraping,
    'student': student,
    'voice': voice,
    'greeting': greeting,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
