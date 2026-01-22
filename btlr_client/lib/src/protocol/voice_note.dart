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

abstract class VoiceNote implements _i1.SerializableModel {
  VoiceNote._({
    this.id,
    required this.studentProfileId,
    this.learningGoalId,
    required this.transcription,
    this.originalAudioUrl,
    DateTime? recordedAt,
    this.duration,
    this.tags,
    this.sentiment,
    this.category,
    this.searchableContent,
  }) : recordedAt = recordedAt ?? DateTime.now();

  factory VoiceNote({
    int? id,
    required int studentProfileId,
    int? learningGoalId,
    required String transcription,
    String? originalAudioUrl,
    DateTime? recordedAt,
    int? duration,
    String? tags,
    String? sentiment,
    String? category,
    String? searchableContent,
  }) = _VoiceNoteImpl;

  factory VoiceNote.fromJson(Map<String, dynamic> jsonSerialization) {
    return VoiceNote(
      id: jsonSerialization['id'] as int?,
      studentProfileId: jsonSerialization['studentProfileId'] as int,
      learningGoalId: jsonSerialization['learningGoalId'] as int?,
      transcription: jsonSerialization['transcription'] as String,
      originalAudioUrl: jsonSerialization['originalAudioUrl'] as String?,
      recordedAt: jsonSerialization['recordedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['recordedAt']),
      duration: jsonSerialization['duration'] as int?,
      tags: jsonSerialization['tags'] as String?,
      sentiment: jsonSerialization['sentiment'] as String?,
      category: jsonSerialization['category'] as String?,
      searchableContent: jsonSerialization['searchableContent'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int studentProfileId;

  int? learningGoalId;

  String transcription;

  String? originalAudioUrl;

  DateTime recordedAt;

  int? duration;

  String? tags;

  String? sentiment;

  String? category;

  String? searchableContent;

  /// Returns a shallow copy of this [VoiceNote]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VoiceNote copyWith({
    int? id,
    int? studentProfileId,
    int? learningGoalId,
    String? transcription,
    String? originalAudioUrl,
    DateTime? recordedAt,
    int? duration,
    String? tags,
    String? sentiment,
    String? category,
    String? searchableContent,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VoiceNote',
      if (id != null) 'id': id,
      'studentProfileId': studentProfileId,
      if (learningGoalId != null) 'learningGoalId': learningGoalId,
      'transcription': transcription,
      if (originalAudioUrl != null) 'originalAudioUrl': originalAudioUrl,
      'recordedAt': recordedAt.toJson(),
      if (duration != null) 'duration': duration,
      if (tags != null) 'tags': tags,
      if (sentiment != null) 'sentiment': sentiment,
      if (category != null) 'category': category,
      if (searchableContent != null) 'searchableContent': searchableContent,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VoiceNoteImpl extends VoiceNote {
  _VoiceNoteImpl({
    int? id,
    required int studentProfileId,
    int? learningGoalId,
    required String transcription,
    String? originalAudioUrl,
    DateTime? recordedAt,
    int? duration,
    String? tags,
    String? sentiment,
    String? category,
    String? searchableContent,
  }) : super._(
         id: id,
         studentProfileId: studentProfileId,
         learningGoalId: learningGoalId,
         transcription: transcription,
         originalAudioUrl: originalAudioUrl,
         recordedAt: recordedAt,
         duration: duration,
         tags: tags,
         sentiment: sentiment,
         category: category,
         searchableContent: searchableContent,
       );

  /// Returns a shallow copy of this [VoiceNote]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VoiceNote copyWith({
    Object? id = _Undefined,
    int? studentProfileId,
    Object? learningGoalId = _Undefined,
    String? transcription,
    Object? originalAudioUrl = _Undefined,
    DateTime? recordedAt,
    Object? duration = _Undefined,
    Object? tags = _Undefined,
    Object? sentiment = _Undefined,
    Object? category = _Undefined,
    Object? searchableContent = _Undefined,
  }) {
    return VoiceNote(
      id: id is int? ? id : this.id,
      studentProfileId: studentProfileId ?? this.studentProfileId,
      learningGoalId: learningGoalId is int?
          ? learningGoalId
          : this.learningGoalId,
      transcription: transcription ?? this.transcription,
      originalAudioUrl: originalAudioUrl is String?
          ? originalAudioUrl
          : this.originalAudioUrl,
      recordedAt: recordedAt ?? this.recordedAt,
      duration: duration is int? ? duration : this.duration,
      tags: tags is String? ? tags : this.tags,
      sentiment: sentiment is String? ? sentiment : this.sentiment,
      category: category is String? ? category : this.category,
      searchableContent: searchableContent is String?
          ? searchableContent
          : this.searchableContent,
    );
  }
}
