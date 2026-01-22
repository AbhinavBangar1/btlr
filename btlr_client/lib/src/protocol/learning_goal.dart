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

abstract class LearningGoal implements _i1.SerializableModel {
  LearningGoal._({
    this.id,
    required this.studentProfileId,
    required this.title,
    this.description,
    required this.category,
    String? priority,
    String? status,
    this.estimatedHours,
    double? actualHours,
    this.deadline,
    this.tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : priority = priority ?? 'medium',
       status = status ?? 'not_started',
       actualHours = actualHours ?? 0.0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory LearningGoal({
    int? id,
    required int studentProfileId,
    required String title,
    String? description,
    required String category,
    String? priority,
    String? status,
    double? estimatedHours,
    double? actualHours,
    DateTime? deadline,
    String? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _LearningGoalImpl;

  factory LearningGoal.fromJson(Map<String, dynamic> jsonSerialization) {
    return LearningGoal(
      id: jsonSerialization['id'] as int?,
      studentProfileId: jsonSerialization['studentProfileId'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      category: jsonSerialization['category'] as String,
      priority: jsonSerialization['priority'] as String?,
      status: jsonSerialization['status'] as String?,
      estimatedHours: (jsonSerialization['estimatedHours'] as num?)?.toDouble(),
      actualHours: (jsonSerialization['actualHours'] as num?)?.toDouble(),
      deadline: jsonSerialization['deadline'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deadline']),
      tags: jsonSerialization['tags'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int studentProfileId;

  String title;

  String? description;

  String category;

  String priority;

  String status;

  double? estimatedHours;

  double actualHours;

  DateTime? deadline;

  String? tags;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [LearningGoal]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LearningGoal copyWith({
    int? id,
    int? studentProfileId,
    String? title,
    String? description,
    String? category,
    String? priority,
    String? status,
    double? estimatedHours,
    double? actualHours,
    DateTime? deadline,
    String? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LearningGoal',
      if (id != null) 'id': id,
      'studentProfileId': studentProfileId,
      'title': title,
      if (description != null) 'description': description,
      'category': category,
      'priority': priority,
      'status': status,
      if (estimatedHours != null) 'estimatedHours': estimatedHours,
      'actualHours': actualHours,
      if (deadline != null) 'deadline': deadline?.toJson(),
      if (tags != null) 'tags': tags,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LearningGoalImpl extends LearningGoal {
  _LearningGoalImpl({
    int? id,
    required int studentProfileId,
    required String title,
    String? description,
    required String category,
    String? priority,
    String? status,
    double? estimatedHours,
    double? actualHours,
    DateTime? deadline,
    String? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         studentProfileId: studentProfileId,
         title: title,
         description: description,
         category: category,
         priority: priority,
         status: status,
         estimatedHours: estimatedHours,
         actualHours: actualHours,
         deadline: deadline,
         tags: tags,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [LearningGoal]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LearningGoal copyWith({
    Object? id = _Undefined,
    int? studentProfileId,
    String? title,
    Object? description = _Undefined,
    String? category,
    String? priority,
    String? status,
    Object? estimatedHours = _Undefined,
    double? actualHours,
    Object? deadline = _Undefined,
    Object? tags = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LearningGoal(
      id: id is int? ? id : this.id,
      studentProfileId: studentProfileId ?? this.studentProfileId,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      estimatedHours: estimatedHours is double?
          ? estimatedHours
          : this.estimatedHours,
      actualHours: actualHours ?? this.actualHours,
      deadline: deadline is DateTime? ? deadline : this.deadline,
      tags: tags is String? ? tags : this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
