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

abstract class Opportunity implements _i1.SerializableModel {
  Opportunity._({
    this.id,
    this.studentProfileId,
    required this.title,
    required this.type,
    this.description,
    this.organization,
    this.sourceUrl,
    this.deadline,
    this.tags,
    double? relevanceScore,
    String? status,
    this.prepTimeMinutes,
    this.appliedAt,
    DateTime? discoveredAt,
  }) : relevanceScore = relevanceScore ?? 0.0,
       status = status ?? 'discovered',
       discoveredAt = discoveredAt ?? DateTime.now();

  factory Opportunity({
    int? id,
    int? studentProfileId,
    required String title,
    required String type,
    String? description,
    String? organization,
    String? sourceUrl,
    DateTime? deadline,
    String? tags,
    double? relevanceScore,
    String? status,
    int? prepTimeMinutes,
    DateTime? appliedAt,
    DateTime? discoveredAt,
  }) = _OpportunityImpl;

  factory Opportunity.fromJson(Map<String, dynamic> jsonSerialization) {
    return Opportunity(
      id: jsonSerialization['id'] as int?,
      studentProfileId: jsonSerialization['studentProfileId'] as int?,
      title: jsonSerialization['title'] as String,
      type: jsonSerialization['type'] as String,
      description: jsonSerialization['description'] as String?,
      organization: jsonSerialization['organization'] as String?,
      sourceUrl: jsonSerialization['sourceUrl'] as String?,
      deadline: jsonSerialization['deadline'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deadline']),
      tags: jsonSerialization['tags'] as String?,
      relevanceScore: (jsonSerialization['relevanceScore'] as num?)?.toDouble(),
      status: jsonSerialization['status'] as String?,
      prepTimeMinutes: jsonSerialization['prepTimeMinutes'] as int?,
      appliedAt: jsonSerialization['appliedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['appliedAt']),
      discoveredAt: jsonSerialization['discoveredAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['discoveredAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? studentProfileId;

  String title;

  String type;

  String? description;

  String? organization;

  String? sourceUrl;

  DateTime? deadline;

  String? tags;

  double relevanceScore;

  String status;

  int? prepTimeMinutes;

  DateTime? appliedAt;

  DateTime discoveredAt;

  /// Returns a shallow copy of this [Opportunity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Opportunity copyWith({
    int? id,
    int? studentProfileId,
    String? title,
    String? type,
    String? description,
    String? organization,
    String? sourceUrl,
    DateTime? deadline,
    String? tags,
    double? relevanceScore,
    String? status,
    int? prepTimeMinutes,
    DateTime? appliedAt,
    DateTime? discoveredAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Opportunity',
      if (id != null) 'id': id,
      if (studentProfileId != null) 'studentProfileId': studentProfileId,
      'title': title,
      'type': type,
      if (description != null) 'description': description,
      if (organization != null) 'organization': organization,
      if (sourceUrl != null) 'sourceUrl': sourceUrl,
      if (deadline != null) 'deadline': deadline?.toJson(),
      if (tags != null) 'tags': tags,
      'relevanceScore': relevanceScore,
      'status': status,
      if (prepTimeMinutes != null) 'prepTimeMinutes': prepTimeMinutes,
      if (appliedAt != null) 'appliedAt': appliedAt?.toJson(),
      'discoveredAt': discoveredAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OpportunityImpl extends Opportunity {
  _OpportunityImpl({
    int? id,
    int? studentProfileId,
    required String title,
    required String type,
    String? description,
    String? organization,
    String? sourceUrl,
    DateTime? deadline,
    String? tags,
    double? relevanceScore,
    String? status,
    int? prepTimeMinutes,
    DateTime? appliedAt,
    DateTime? discoveredAt,
  }) : super._(
         id: id,
         studentProfileId: studentProfileId,
         title: title,
         type: type,
         description: description,
         organization: organization,
         sourceUrl: sourceUrl,
         deadline: deadline,
         tags: tags,
         relevanceScore: relevanceScore,
         status: status,
         prepTimeMinutes: prepTimeMinutes,
         appliedAt: appliedAt,
         discoveredAt: discoveredAt,
       );

  /// Returns a shallow copy of this [Opportunity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Opportunity copyWith({
    Object? id = _Undefined,
    Object? studentProfileId = _Undefined,
    String? title,
    String? type,
    Object? description = _Undefined,
    Object? organization = _Undefined,
    Object? sourceUrl = _Undefined,
    Object? deadline = _Undefined,
    Object? tags = _Undefined,
    double? relevanceScore,
    String? status,
    Object? prepTimeMinutes = _Undefined,
    Object? appliedAt = _Undefined,
    DateTime? discoveredAt,
  }) {
    return Opportunity(
      id: id is int? ? id : this.id,
      studentProfileId: studentProfileId is int?
          ? studentProfileId
          : this.studentProfileId,
      title: title ?? this.title,
      type: type ?? this.type,
      description: description is String? ? description : this.description,
      organization: organization is String? ? organization : this.organization,
      sourceUrl: sourceUrl is String? ? sourceUrl : this.sourceUrl,
      deadline: deadline is DateTime? ? deadline : this.deadline,
      tags: tags is String? ? tags : this.tags,
      relevanceScore: relevanceScore ?? this.relevanceScore,
      status: status ?? this.status,
      prepTimeMinutes: prepTimeMinutes is int?
          ? prepTimeMinutes
          : this.prepTimeMinutes,
      appliedAt: appliedAt is DateTime? ? appliedAt : this.appliedAt,
      discoveredAt: discoveredAt ?? this.discoveredAt,
    );
  }
}
