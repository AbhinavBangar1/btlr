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

abstract class AcademicSchedule implements _i1.SerializableModel {
  AcademicSchedule._({
    this.id,
    required this.studentProfileId,
    required this.title,
    required this.type,
    this.location,
    this.rrule,
    required this.startTime,
    required this.endTime,
    bool? isRecurring,
    this.deletedAt,
    DateTime? createdAt,
  }) : isRecurring = isRecurring ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory AcademicSchedule({
    int? id,
    required int studentProfileId,
    required String title,
    required String type,
    String? location,
    String? rrule,
    required DateTime startTime,
    required DateTime endTime,
    bool? isRecurring,
    DateTime? deletedAt,
    DateTime? createdAt,
  }) = _AcademicScheduleImpl;

  factory AcademicSchedule.fromJson(Map<String, dynamic> jsonSerialization) {
    return AcademicSchedule(
      id: jsonSerialization['id'] as int?,
      studentProfileId: jsonSerialization['studentProfileId'] as int,
      title: jsonSerialization['title'] as String,
      type: jsonSerialization['type'] as String,
      location: jsonSerialization['location'] as String?,
      rrule: jsonSerialization['rrule'] as String?,
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      endTime: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      isRecurring: jsonSerialization['isRecurring'] as bool?,
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int studentProfileId;

  String title;

  String type;

  String? location;

  String? rrule;

  DateTime startTime;

  DateTime endTime;

  bool isRecurring;

  DateTime? deletedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [AcademicSchedule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AcademicSchedule copyWith({
    int? id,
    int? studentProfileId,
    String? title,
    String? type,
    String? location,
    String? rrule,
    DateTime? startTime,
    DateTime? endTime,
    bool? isRecurring,
    DateTime? deletedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AcademicSchedule',
      if (id != null) 'id': id,
      'studentProfileId': studentProfileId,
      'title': title,
      'type': type,
      if (location != null) 'location': location,
      if (rrule != null) 'rrule': rrule,
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      'isRecurring': isRecurring,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AcademicScheduleImpl extends AcademicSchedule {
  _AcademicScheduleImpl({
    int? id,
    required int studentProfileId,
    required String title,
    required String type,
    String? location,
    String? rrule,
    required DateTime startTime,
    required DateTime endTime,
    bool? isRecurring,
    DateTime? deletedAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         studentProfileId: studentProfileId,
         title: title,
         type: type,
         location: location,
         rrule: rrule,
         startTime: startTime,
         endTime: endTime,
         isRecurring: isRecurring,
         deletedAt: deletedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AcademicSchedule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AcademicSchedule copyWith({
    Object? id = _Undefined,
    int? studentProfileId,
    String? title,
    String? type,
    Object? location = _Undefined,
    Object? rrule = _Undefined,
    DateTime? startTime,
    DateTime? endTime,
    bool? isRecurring,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return AcademicSchedule(
      id: id is int? ? id : this.id,
      studentProfileId: studentProfileId ?? this.studentProfileId,
      title: title ?? this.title,
      type: type ?? this.type,
      location: location is String? ? location : this.location,
      rrule: rrule is String? ? rrule : this.rrule,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isRecurring: isRecurring ?? this.isRecurring,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
