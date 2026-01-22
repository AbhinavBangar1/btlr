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

abstract class BehaviorLog implements _i1.SerializableModel {
  BehaviorLog._({
    this.id,
    required this.studentProfileId,
    required this.timeBlockId,
    required this.action,
    DateTime? timestamp,
    this.actualDuration,
    this.energyLevel,
    this.notes,
    this.reason,
    this.context,
  }) : timestamp = timestamp ?? DateTime.now();

  factory BehaviorLog({
    int? id,
    required int studentProfileId,
    required int timeBlockId,
    required String action,
    DateTime? timestamp,
    int? actualDuration,
    int? energyLevel,
    String? notes,
    String? reason,
    String? context,
  }) = _BehaviorLogImpl;

  factory BehaviorLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return BehaviorLog(
      id: jsonSerialization['id'] as int?,
      studentProfileId: jsonSerialization['studentProfileId'] as int,
      timeBlockId: jsonSerialization['timeBlockId'] as int,
      action: jsonSerialization['action'] as String,
      timestamp: jsonSerialization['timestamp'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
      actualDuration: jsonSerialization['actualDuration'] as int?,
      energyLevel: jsonSerialization['energyLevel'] as int?,
      notes: jsonSerialization['notes'] as String?,
      reason: jsonSerialization['reason'] as String?,
      context: jsonSerialization['context'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int studentProfileId;

  int timeBlockId;

  String action;

  DateTime timestamp;

  int? actualDuration;

  int? energyLevel;

  String? notes;

  String? reason;

  String? context;

  /// Returns a shallow copy of this [BehaviorLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BehaviorLog copyWith({
    int? id,
    int? studentProfileId,
    int? timeBlockId,
    String? action,
    DateTime? timestamp,
    int? actualDuration,
    int? energyLevel,
    String? notes,
    String? reason,
    String? context,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BehaviorLog',
      if (id != null) 'id': id,
      'studentProfileId': studentProfileId,
      'timeBlockId': timeBlockId,
      'action': action,
      'timestamp': timestamp.toJson(),
      if (actualDuration != null) 'actualDuration': actualDuration,
      if (energyLevel != null) 'energyLevel': energyLevel,
      if (notes != null) 'notes': notes,
      if (reason != null) 'reason': reason,
      if (context != null) 'context': context,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BehaviorLogImpl extends BehaviorLog {
  _BehaviorLogImpl({
    int? id,
    required int studentProfileId,
    required int timeBlockId,
    required String action,
    DateTime? timestamp,
    int? actualDuration,
    int? energyLevel,
    String? notes,
    String? reason,
    String? context,
  }) : super._(
         id: id,
         studentProfileId: studentProfileId,
         timeBlockId: timeBlockId,
         action: action,
         timestamp: timestamp,
         actualDuration: actualDuration,
         energyLevel: energyLevel,
         notes: notes,
         reason: reason,
         context: context,
       );

  /// Returns a shallow copy of this [BehaviorLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BehaviorLog copyWith({
    Object? id = _Undefined,
    int? studentProfileId,
    int? timeBlockId,
    String? action,
    DateTime? timestamp,
    Object? actualDuration = _Undefined,
    Object? energyLevel = _Undefined,
    Object? notes = _Undefined,
    Object? reason = _Undefined,
    Object? context = _Undefined,
  }) {
    return BehaviorLog(
      id: id is int? ? id : this.id,
      studentProfileId: studentProfileId ?? this.studentProfileId,
      timeBlockId: timeBlockId ?? this.timeBlockId,
      action: action ?? this.action,
      timestamp: timestamp ?? this.timestamp,
      actualDuration: actualDuration is int?
          ? actualDuration
          : this.actualDuration,
      energyLevel: energyLevel is int? ? energyLevel : this.energyLevel,
      notes: notes is String? ? notes : this.notes,
      reason: reason is String? ? reason : this.reason,
      context: context is String? ? context : this.context,
    );
  }
}
