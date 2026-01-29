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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class StudentProfile implements _i1.SerializableModel {
  StudentProfile._({
    this.id,
    required this.name,
    required this.email,
    String? timezone,
    required this.wakeTime,
    required this.sleepTime,
    int? preferredStudyBlockMinutes,
    int? preferredBreakMinutes,
    this.preferredStudyTimes,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.githubUsername,
    this.leetcodeUsername,
    this.codeforcesUsername,
    this.linkedinUrl,
    this.portfolioUrl,
  }) : timezone = timezone ?? 'UTC',
       preferredStudyBlockMinutes = preferredStudyBlockMinutes ?? 50,
       preferredBreakMinutes = preferredBreakMinutes ?? 10,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory StudentProfile({
    int? id,
    required String name,
    required String email,
    String? timezone,
    required String wakeTime,
    required String sleepTime,
    int? preferredStudyBlockMinutes,
    int? preferredBreakMinutes,
    String? preferredStudyTimes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? githubUsername,
    String? leetcodeUsername,
    String? codeforcesUsername,
    String? linkedinUrl,
    String? portfolioUrl,
  }) = _StudentProfileImpl;

  factory StudentProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudentProfile(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String,
      timezone: jsonSerialization['timezone'] as String?,
      wakeTime: jsonSerialization['wakeTime'] as String,
      sleepTime: jsonSerialization['sleepTime'] as String,
      preferredStudyBlockMinutes:
          jsonSerialization['preferredStudyBlockMinutes'] as int?,
      preferredBreakMinutes: jsonSerialization['preferredBreakMinutes'] as int?,
      preferredStudyTimes: jsonSerialization['preferredStudyTimes'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      githubUsername: jsonSerialization['githubUsername'] as String?,
      leetcodeUsername: jsonSerialization['leetcodeUsername'] as String?,
      codeforcesUsername: jsonSerialization['codeforcesUsername'] as String?,
      linkedinUrl: jsonSerialization['linkedinUrl'] as String?,
      portfolioUrl: jsonSerialization['portfolioUrl'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String email;

  String timezone;

  String wakeTime;

  String sleepTime;

  int preferredStudyBlockMinutes;

  int preferredBreakMinutes;

  String? preferredStudyTimes;

  DateTime createdAt;

  DateTime updatedAt;

  String? githubUsername;

  String? leetcodeUsername;

  String? codeforcesUsername;

  String? linkedinUrl;

  String? portfolioUrl;

  /// Returns a shallow copy of this [StudentProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StudentProfile copyWith({
    int? id,
    String? name,
    String? email,
    String? timezone,
    String? wakeTime,
    String? sleepTime,
    int? preferredStudyBlockMinutes,
    int? preferredBreakMinutes,
    String? preferredStudyTimes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? githubUsername,
    String? leetcodeUsername,
    String? codeforcesUsername,
    String? linkedinUrl,
    String? portfolioUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudentProfile',
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'timezone': timezone,
      'wakeTime': wakeTime,
      'sleepTime': sleepTime,
      'preferredStudyBlockMinutes': preferredStudyBlockMinutes,
      'preferredBreakMinutes': preferredBreakMinutes,
      if (preferredStudyTimes != null)
        'preferredStudyTimes': preferredStudyTimes,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (githubUsername != null) 'githubUsername': githubUsername,
      if (leetcodeUsername != null) 'leetcodeUsername': leetcodeUsername,
      if (codeforcesUsername != null) 'codeforcesUsername': codeforcesUsername,
      if (linkedinUrl != null) 'linkedinUrl': linkedinUrl,
      if (portfolioUrl != null) 'portfolioUrl': portfolioUrl,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentProfileImpl extends StudentProfile {
  _StudentProfileImpl({
    int? id,
    required String name,
    required String email,
    String? timezone,
    required String wakeTime,
    required String sleepTime,
    int? preferredStudyBlockMinutes,
    int? preferredBreakMinutes,
    String? preferredStudyTimes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? githubUsername,
    String? leetcodeUsername,
    String? codeforcesUsername,
    String? linkedinUrl,
    String? portfolioUrl,
  }) : super._(
         id: id,
         name: name,
         email: email,
         timezone: timezone,
         wakeTime: wakeTime,
         sleepTime: sleepTime,
         preferredStudyBlockMinutes: preferredStudyBlockMinutes,
         preferredBreakMinutes: preferredBreakMinutes,
         preferredStudyTimes: preferredStudyTimes,
         createdAt: createdAt,
         updatedAt: updatedAt,
         githubUsername: githubUsername,
         leetcodeUsername: leetcodeUsername,
         codeforcesUsername: codeforcesUsername,
         linkedinUrl: linkedinUrl,
         portfolioUrl: portfolioUrl,
       );

  /// Returns a shallow copy of this [StudentProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StudentProfile copyWith({
    Object? id = _Undefined,
    String? name,
    String? email,
    String? timezone,
    String? wakeTime,
    String? sleepTime,
    int? preferredStudyBlockMinutes,
    int? preferredBreakMinutes,
    Object? preferredStudyTimes = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? githubUsername = _Undefined,
    Object? leetcodeUsername = _Undefined,
    Object? codeforcesUsername = _Undefined,
    Object? linkedinUrl = _Undefined,
    Object? portfolioUrl = _Undefined,
  }) {
    return StudentProfile(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      timezone: timezone ?? this.timezone,
      wakeTime: wakeTime ?? this.wakeTime,
      sleepTime: sleepTime ?? this.sleepTime,
      preferredStudyBlockMinutes:
          preferredStudyBlockMinutes ?? this.preferredStudyBlockMinutes,
      preferredBreakMinutes:
          preferredBreakMinutes ?? this.preferredBreakMinutes,
      preferredStudyTimes: preferredStudyTimes is String?
          ? preferredStudyTimes
          : this.preferredStudyTimes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      githubUsername: githubUsername is String?
          ? githubUsername
          : this.githubUsername,
      leetcodeUsername: leetcodeUsername is String?
          ? leetcodeUsername
          : this.leetcodeUsername,
      codeforcesUsername: codeforcesUsername is String?
          ? codeforcesUsername
          : this.codeforcesUsername,
      linkedinUrl: linkedinUrl is String? ? linkedinUrl : this.linkedinUrl,
      portfolioUrl: portfolioUrl is String? ? portfolioUrl : this.portfolioUrl,
    );
  }
}
