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

abstract class TimeBlock implements _i1.SerializableModel {
  TimeBlock._({
    this.id,
    required this.dailyPlanId,
    this.learningGoalId,
    this.academicScheduleId,
    required this.title,
    this.description,
    required this.blockType,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    bool? isCompleted,
    String? completionStatus,
    this.actualDurationMinutes,
    this.energyLevel,
    this.notes,
    this.missReason,
    DateTime? createdAt,
  }) : isCompleted = isCompleted ?? false,
       completionStatus = completionStatus ?? 'pending',
       createdAt = createdAt ?? DateTime.now();

  factory TimeBlock({
    int? id,
    required int dailyPlanId,
    int? learningGoalId,
    int? academicScheduleId,
    required String title,
    String? description,
    required String blockType,
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes,
    bool? isCompleted,
    String? completionStatus,
    int? actualDurationMinutes,
    int? energyLevel,
    String? notes,
    String? missReason,
    DateTime? createdAt,
  }) = _TimeBlockImpl;

  factory TimeBlock.fromJson(Map<String, dynamic> jsonSerialization) {
    return TimeBlock(
      id: jsonSerialization['id'] as int?,
      dailyPlanId: jsonSerialization['dailyPlanId'] as int,
      learningGoalId: jsonSerialization['learningGoalId'] as int?,
      academicScheduleId: jsonSerialization['academicScheduleId'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      blockType: jsonSerialization['blockType'] as String,
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      endTime: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      durationMinutes: jsonSerialization['durationMinutes'] as int,
      isCompleted: jsonSerialization['isCompleted'] as bool?,
      completionStatus: jsonSerialization['completionStatus'] as String?,
      actualDurationMinutes: jsonSerialization['actualDurationMinutes'] as int?,
      energyLevel: jsonSerialization['energyLevel'] as int?,
      notes: jsonSerialization['notes'] as String?,
      missReason: jsonSerialization['missReason'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int dailyPlanId;

  int? learningGoalId;

  int? academicScheduleId;

  String title;

  String? description;

  String blockType;

  DateTime startTime;

  DateTime endTime;

  int durationMinutes;

  bool isCompleted;

  String completionStatus;

  int? actualDurationMinutes;

  int? energyLevel;

  String? notes;

  String? missReason;

  DateTime createdAt;

  /// Returns a shallow copy of this [TimeBlock]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TimeBlock copyWith({
    int? id,
    int? dailyPlanId,
    int? learningGoalId,
    int? academicScheduleId,
    String? title,
    String? description,
    String? blockType,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    bool? isCompleted,
    String? completionStatus,
    int? actualDurationMinutes,
    int? energyLevel,
    String? notes,
    String? missReason,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TimeBlock',
      if (id != null) 'id': id,
      'dailyPlanId': dailyPlanId,
      if (learningGoalId != null) 'learningGoalId': learningGoalId,
      if (academicScheduleId != null) 'academicScheduleId': academicScheduleId,
      'title': title,
      if (description != null) 'description': description,
      'blockType': blockType,
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'completionStatus': completionStatus,
      if (actualDurationMinutes != null)
        'actualDurationMinutes': actualDurationMinutes,
      if (energyLevel != null) 'energyLevel': energyLevel,
      if (notes != null) 'notes': notes,
      if (missReason != null) 'missReason': missReason,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TimeBlockImpl extends TimeBlock {
  _TimeBlockImpl({
    int? id,
    required int dailyPlanId,
    int? learningGoalId,
    int? academicScheduleId,
    required String title,
    String? description,
    required String blockType,
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes,
    bool? isCompleted,
    String? completionStatus,
    int? actualDurationMinutes,
    int? energyLevel,
    String? notes,
    String? missReason,
    DateTime? createdAt,
  }) : super._(
         id: id,
         dailyPlanId: dailyPlanId,
         learningGoalId: learningGoalId,
         academicScheduleId: academicScheduleId,
         title: title,
         description: description,
         blockType: blockType,
         startTime: startTime,
         endTime: endTime,
         durationMinutes: durationMinutes,
         isCompleted: isCompleted,
         completionStatus: completionStatus,
         actualDurationMinutes: actualDurationMinutes,
         energyLevel: energyLevel,
         notes: notes,
         missReason: missReason,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TimeBlock]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TimeBlock copyWith({
    Object? id = _Undefined,
    int? dailyPlanId,
    Object? learningGoalId = _Undefined,
    Object? academicScheduleId = _Undefined,
    String? title,
    Object? description = _Undefined,
    String? blockType,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    bool? isCompleted,
    String? completionStatus,
    Object? actualDurationMinutes = _Undefined,
    Object? energyLevel = _Undefined,
    Object? notes = _Undefined,
    Object? missReason = _Undefined,
    DateTime? createdAt,
  }) {
    return TimeBlock(
      id: id is int? ? id : this.id,
      dailyPlanId: dailyPlanId ?? this.dailyPlanId,
      learningGoalId: learningGoalId is int?
          ? learningGoalId
          : this.learningGoalId,
      academicScheduleId: academicScheduleId is int?
          ? academicScheduleId
          : this.academicScheduleId,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      blockType: blockType ?? this.blockType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      completionStatus: completionStatus ?? this.completionStatus,
      actualDurationMinutes: actualDurationMinutes is int?
          ? actualDurationMinutes
          : this.actualDurationMinutes,
      energyLevel: energyLevel is int? ? energyLevel : this.energyLevel,
      notes: notes is String? ? notes : this.notes,
      missReason: missReason is String? ? missReason : this.missReason,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
