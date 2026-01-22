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

abstract class DailyPlan implements _i1.SerializableModel {
  DailyPlan._({
    this.id,
    required this.studentProfileId,
    required this.planDate,
    int? version,
    this.reasoning,
    int? totalPlannedMinutes,
    DateTime? generatedAt,
    this.adaptationNotes,
  }) : version = version ?? 1,
       totalPlannedMinutes = totalPlannedMinutes ?? 0,
       generatedAt = generatedAt ?? DateTime.now();

  factory DailyPlan({
    int? id,
    required int studentProfileId,
    required DateTime planDate,
    int? version,
    String? reasoning,
    int? totalPlannedMinutes,
    DateTime? generatedAt,
    String? adaptationNotes,
  }) = _DailyPlanImpl;

  factory DailyPlan.fromJson(Map<String, dynamic> jsonSerialization) {
    return DailyPlan(
      id: jsonSerialization['id'] as int?,
      studentProfileId: jsonSerialization['studentProfileId'] as int,
      planDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['planDate'],
      ),
      version: jsonSerialization['version'] as int?,
      reasoning: jsonSerialization['reasoning'] as String?,
      totalPlannedMinutes: jsonSerialization['totalPlannedMinutes'] as int?,
      generatedAt: jsonSerialization['generatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['generatedAt'],
            ),
      adaptationNotes: jsonSerialization['adaptationNotes'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int studentProfileId;

  DateTime planDate;

  int version;

  String? reasoning;

  int totalPlannedMinutes;

  DateTime generatedAt;

  String? adaptationNotes;

  /// Returns a shallow copy of this [DailyPlan]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DailyPlan copyWith({
    int? id,
    int? studentProfileId,
    DateTime? planDate,
    int? version,
    String? reasoning,
    int? totalPlannedMinutes,
    DateTime? generatedAt,
    String? adaptationNotes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailyPlan',
      if (id != null) 'id': id,
      'studentProfileId': studentProfileId,
      'planDate': planDate.toJson(),
      'version': version,
      if (reasoning != null) 'reasoning': reasoning,
      'totalPlannedMinutes': totalPlannedMinutes,
      'generatedAt': generatedAt.toJson(),
      if (adaptationNotes != null) 'adaptationNotes': adaptationNotes,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DailyPlanImpl extends DailyPlan {
  _DailyPlanImpl({
    int? id,
    required int studentProfileId,
    required DateTime planDate,
    int? version,
    String? reasoning,
    int? totalPlannedMinutes,
    DateTime? generatedAt,
    String? adaptationNotes,
  }) : super._(
         id: id,
         studentProfileId: studentProfileId,
         planDate: planDate,
         version: version,
         reasoning: reasoning,
         totalPlannedMinutes: totalPlannedMinutes,
         generatedAt: generatedAt,
         adaptationNotes: adaptationNotes,
       );

  /// Returns a shallow copy of this [DailyPlan]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DailyPlan copyWith({
    Object? id = _Undefined,
    int? studentProfileId,
    DateTime? planDate,
    int? version,
    Object? reasoning = _Undefined,
    int? totalPlannedMinutes,
    DateTime? generatedAt,
    Object? adaptationNotes = _Undefined,
  }) {
    return DailyPlan(
      id: id is int? ? id : this.id,
      studentProfileId: studentProfileId ?? this.studentProfileId,
      planDate: planDate ?? this.planDate,
      version: version ?? this.version,
      reasoning: reasoning is String? ? reasoning : this.reasoning,
      totalPlannedMinutes: totalPlannedMinutes ?? this.totalPlannedMinutes,
      generatedAt: generatedAt ?? this.generatedAt,
      adaptationNotes: adaptationNotes is String?
          ? adaptationNotes
          : this.adaptationNotes,
    );
  }
}
