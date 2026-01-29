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

abstract class ScrapedContent implements _i1.SerializableModel {
  ScrapedContent._({
    this.id,
    required this.userId,
    required this.platform,
    required this.title,
    required this.summary,
    required this.sourceUrl,
    DateTime? scrapedAt,
    bool? isRead,
    this.metadata,
  }) : scrapedAt = scrapedAt ?? DateTime.now(),
       isRead = isRead ?? false;

  factory ScrapedContent({
    int? id,
    required int userId,
    required String platform,
    required String title,
    required String summary,
    required String sourceUrl,
    DateTime? scrapedAt,
    bool? isRead,
    String? metadata,
  }) = _ScrapedContentImpl;

  factory ScrapedContent.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScrapedContent(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      platform: jsonSerialization['platform'] as String,
      title: jsonSerialization['title'] as String,
      summary: jsonSerialization['summary'] as String,
      sourceUrl: jsonSerialization['sourceUrl'] as String,
      scrapedAt: jsonSerialization['scrapedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['scrapedAt']),
      isRead: jsonSerialization['isRead'] as bool?,
      metadata: jsonSerialization['metadata'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  String platform;

  String title;

  String summary;

  String sourceUrl;

  DateTime scrapedAt;

  bool isRead;

  String? metadata;

  /// Returns a shallow copy of this [ScrapedContent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScrapedContent copyWith({
    int? id,
    int? userId,
    String? platform,
    String? title,
    String? summary,
    String? sourceUrl,
    DateTime? scrapedAt,
    bool? isRead,
    String? metadata,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScrapedContent',
      if (id != null) 'id': id,
      'userId': userId,
      'platform': platform,
      'title': title,
      'summary': summary,
      'sourceUrl': sourceUrl,
      'scrapedAt': scrapedAt.toJson(),
      'isRead': isRead,
      if (metadata != null) 'metadata': metadata,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScrapedContentImpl extends ScrapedContent {
  _ScrapedContentImpl({
    int? id,
    required int userId,
    required String platform,
    required String title,
    required String summary,
    required String sourceUrl,
    DateTime? scrapedAt,
    bool? isRead,
    String? metadata,
  }) : super._(
         id: id,
         userId: userId,
         platform: platform,
         title: title,
         summary: summary,
         sourceUrl: sourceUrl,
         scrapedAt: scrapedAt,
         isRead: isRead,
         metadata: metadata,
       );

  /// Returns a shallow copy of this [ScrapedContent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScrapedContent copyWith({
    Object? id = _Undefined,
    int? userId,
    String? platform,
    String? title,
    String? summary,
    String? sourceUrl,
    DateTime? scrapedAt,
    bool? isRead,
    Object? metadata = _Undefined,
  }) {
    return ScrapedContent(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      platform: platform ?? this.platform,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      scrapedAt: scrapedAt ?? this.scrapedAt,
      isRead: isRead ?? this.isRead,
      metadata: metadata is String? ? metadata : this.metadata,
    );
  }
}
