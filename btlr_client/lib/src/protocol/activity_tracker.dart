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

abstract class ActivityTracker implements _i1.SerializableModel {
  ActivityTracker._({
    this.id,
    required this.userId,
    required this.platform,
    required this.username,
    this.lastSynced,
    required this.activityData,
    bool? isActive,
  }) : isActive = isActive ?? true;

  factory ActivityTracker({
    int? id,
    required int userId,
    required String platform,
    required String username,
    DateTime? lastSynced,
    required String activityData,
    bool? isActive,
  }) = _ActivityTrackerImpl;

  factory ActivityTracker.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActivityTracker(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      platform: jsonSerialization['platform'] as String,
      username: jsonSerialization['username'] as String,
      lastSynced: jsonSerialization['lastSynced'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastSynced']),
      activityData: jsonSerialization['activityData'] as String,
      isActive: jsonSerialization['isActive'] as bool?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  String platform;

  String username;

  DateTime? lastSynced;

  String activityData;

  bool isActive;

  /// Returns a shallow copy of this [ActivityTracker]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ActivityTracker copyWith({
    int? id,
    int? userId,
    String? platform,
    String? username,
    DateTime? lastSynced,
    String? activityData,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ActivityTracker',
      if (id != null) 'id': id,
      'userId': userId,
      'platform': platform,
      'username': username,
      if (lastSynced != null) 'lastSynced': lastSynced?.toJson(),
      'activityData': activityData,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActivityTrackerImpl extends ActivityTracker {
  _ActivityTrackerImpl({
    int? id,
    required int userId,
    required String platform,
    required String username,
    DateTime? lastSynced,
    required String activityData,
    bool? isActive,
  }) : super._(
         id: id,
         userId: userId,
         platform: platform,
         username: username,
         lastSynced: lastSynced,
         activityData: activityData,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [ActivityTracker]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ActivityTracker copyWith({
    Object? id = _Undefined,
    int? userId,
    String? platform,
    String? username,
    Object? lastSynced = _Undefined,
    String? activityData,
    bool? isActive,
  }) {
    return ActivityTracker(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      platform: platform ?? this.platform,
      username: username ?? this.username,
      lastSynced: lastSynced is DateTime? ? lastSynced : this.lastSynced,
      activityData: activityData ?? this.activityData,
      isActive: isActive ?? this.isActive,
    );
  }
}
