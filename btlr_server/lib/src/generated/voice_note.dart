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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class VoiceNote
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = VoiceNoteTable();

  static const db = VoiceNoteRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static VoiceNoteInclude include() {
    return VoiceNoteInclude._();
  }

  static VoiceNoteIncludeList includeList({
    _i1.WhereExpressionBuilder<VoiceNoteTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VoiceNoteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VoiceNoteTable>? orderByList,
    VoiceNoteInclude? include,
  }) {
    return VoiceNoteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VoiceNote.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(VoiceNote.t),
      include: include,
    );
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

class VoiceNoteUpdateTable extends _i1.UpdateTable<VoiceNoteTable> {
  VoiceNoteUpdateTable(super.table);

  _i1.ColumnValue<int, int> studentProfileId(int value) => _i1.ColumnValue(
    table.studentProfileId,
    value,
  );

  _i1.ColumnValue<int, int> learningGoalId(int? value) => _i1.ColumnValue(
    table.learningGoalId,
    value,
  );

  _i1.ColumnValue<String, String> transcription(String value) =>
      _i1.ColumnValue(
        table.transcription,
        value,
      );

  _i1.ColumnValue<String, String> originalAudioUrl(String? value) =>
      _i1.ColumnValue(
        table.originalAudioUrl,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> recordedAt(DateTime value) =>
      _i1.ColumnValue(
        table.recordedAt,
        value,
      );

  _i1.ColumnValue<int, int> duration(int? value) => _i1.ColumnValue(
    table.duration,
    value,
  );

  _i1.ColumnValue<String, String> tags(String? value) => _i1.ColumnValue(
    table.tags,
    value,
  );

  _i1.ColumnValue<String, String> sentiment(String? value) => _i1.ColumnValue(
    table.sentiment,
    value,
  );

  _i1.ColumnValue<String, String> category(String? value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<String, String> searchableContent(String? value) =>
      _i1.ColumnValue(
        table.searchableContent,
        value,
      );
}

class VoiceNoteTable extends _i1.Table<int?> {
  VoiceNoteTable({super.tableRelation}) : super(tableName: 'voice_note') {
    updateTable = VoiceNoteUpdateTable(this);
    studentProfileId = _i1.ColumnInt(
      'studentProfileId',
      this,
    );
    learningGoalId = _i1.ColumnInt(
      'learningGoalId',
      this,
    );
    transcription = _i1.ColumnString(
      'transcription',
      this,
    );
    originalAudioUrl = _i1.ColumnString(
      'originalAudioUrl',
      this,
    );
    recordedAt = _i1.ColumnDateTime(
      'recordedAt',
      this,
      hasDefault: true,
    );
    duration = _i1.ColumnInt(
      'duration',
      this,
    );
    tags = _i1.ColumnString(
      'tags',
      this,
    );
    sentiment = _i1.ColumnString(
      'sentiment',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    searchableContent = _i1.ColumnString(
      'searchableContent',
      this,
    );
  }

  late final VoiceNoteUpdateTable updateTable;

  late final _i1.ColumnInt studentProfileId;

  late final _i1.ColumnInt learningGoalId;

  late final _i1.ColumnString transcription;

  late final _i1.ColumnString originalAudioUrl;

  late final _i1.ColumnDateTime recordedAt;

  late final _i1.ColumnInt duration;

  late final _i1.ColumnString tags;

  late final _i1.ColumnString sentiment;

  late final _i1.ColumnString category;

  late final _i1.ColumnString searchableContent;

  @override
  List<_i1.Column> get columns => [
    id,
    studentProfileId,
    learningGoalId,
    transcription,
    originalAudioUrl,
    recordedAt,
    duration,
    tags,
    sentiment,
    category,
    searchableContent,
  ];
}

class VoiceNoteInclude extends _i1.IncludeObject {
  VoiceNoteInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => VoiceNote.t;
}

class VoiceNoteIncludeList extends _i1.IncludeList {
  VoiceNoteIncludeList._({
    _i1.WhereExpressionBuilder<VoiceNoteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(VoiceNote.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => VoiceNote.t;
}

class VoiceNoteRepository {
  const VoiceNoteRepository._();

  /// Returns a list of [VoiceNote]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<VoiceNote>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<VoiceNoteTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VoiceNoteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VoiceNoteTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<VoiceNote>(
      where: where?.call(VoiceNote.t),
      orderBy: orderBy?.call(VoiceNote.t),
      orderByList: orderByList?.call(VoiceNote.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [VoiceNote] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<VoiceNote?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<VoiceNoteTable>? where,
    int? offset,
    _i1.OrderByBuilder<VoiceNoteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VoiceNoteTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<VoiceNote>(
      where: where?.call(VoiceNote.t),
      orderBy: orderBy?.call(VoiceNote.t),
      orderByList: orderByList?.call(VoiceNote.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [VoiceNote] by its [id] or null if no such row exists.
  Future<VoiceNote?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<VoiceNote>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [VoiceNote]s in the list and returns the inserted rows.
  ///
  /// The returned [VoiceNote]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<VoiceNote>> insert(
    _i1.Session session,
    List<VoiceNote> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<VoiceNote>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [VoiceNote] and returns the inserted row.
  ///
  /// The returned [VoiceNote] will have its `id` field set.
  Future<VoiceNote> insertRow(
    _i1.Session session,
    VoiceNote row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<VoiceNote>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [VoiceNote]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<VoiceNote>> update(
    _i1.Session session,
    List<VoiceNote> rows, {
    _i1.ColumnSelections<VoiceNoteTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<VoiceNote>(
      rows,
      columns: columns?.call(VoiceNote.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VoiceNote]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<VoiceNote> updateRow(
    _i1.Session session,
    VoiceNote row, {
    _i1.ColumnSelections<VoiceNoteTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<VoiceNote>(
      row,
      columns: columns?.call(VoiceNote.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VoiceNote] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<VoiceNote?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<VoiceNoteUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<VoiceNote>(
      id,
      columnValues: columnValues(VoiceNote.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [VoiceNote]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<VoiceNote>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<VoiceNoteUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<VoiceNoteTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VoiceNoteTable>? orderBy,
    _i1.OrderByListBuilder<VoiceNoteTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<VoiceNote>(
      columnValues: columnValues(VoiceNote.t.updateTable),
      where: where(VoiceNote.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VoiceNote.t),
      orderByList: orderByList?.call(VoiceNote.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [VoiceNote]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<VoiceNote>> delete(
    _i1.Session session,
    List<VoiceNote> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<VoiceNote>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [VoiceNote].
  Future<VoiceNote> deleteRow(
    _i1.Session session,
    VoiceNote row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<VoiceNote>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<VoiceNote>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<VoiceNoteTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<VoiceNote>(
      where: where(VoiceNote.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<VoiceNoteTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<VoiceNote>(
      where: where?.call(VoiceNote.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
