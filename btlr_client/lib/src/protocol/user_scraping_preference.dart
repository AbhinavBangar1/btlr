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

abstract class UserScrapingPreference implements _i1.SerializableModel {
  UserScrapingPreference._({
    this.id,
    required this.userId,
    required this.platform,
    this.customUrl,
    bool? isActive,
    DateTime? createdAt,
  }) : isActive = isActive ?? true,
       createdAt = createdAt ?? DateTime.now();

  factory UserScrapingPreference({
    int? id,
    required int userId,
    required String platform,
    String? customUrl,
    bool? isActive,
    DateTime? createdAt,
  }) = _UserScrapingPreferenceImpl;

  factory UserScrapingPreference.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UserScrapingPreference(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      platform: jsonSerialization['platform'] as String,
      customUrl: jsonSerialization['customUrl'] as String?,
      isActive: jsonSerialization['isActive'] as bool?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  String platform;

  String? customUrl;

  bool isActive;

  DateTime createdAt;

  /// Returns a shallow copy of this [UserScrapingPreference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserScrapingPreference copyWith({
    int? id,
    int? userId,
    String? platform,
    String? customUrl,
    bool? isActive,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserScrapingPreference',
      if (id != null) 'id': id,
      'userId': userId,
      'platform': platform,
      if (customUrl != null) 'customUrl': customUrl,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserScrapingPreferenceImpl extends UserScrapingPreference {
  _UserScrapingPreferenceImpl({
    int? id,
    required int userId,
    required String platform,
    String? customUrl,
    bool? isActive,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         platform: platform,
         customUrl: customUrl,
         isActive: isActive,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [UserScrapingPreference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserScrapingPreference copyWith({
    Object? id = _Undefined,
    int? userId,
    String? platform,
    Object? customUrl = _Undefined,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return UserScrapingPreference(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      platform: platform ?? this.platform,
      customUrl: customUrl is String? ? customUrl : this.customUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
