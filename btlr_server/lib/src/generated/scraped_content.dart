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

abstract class ScrapedContent
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ScrapedContent._({
    this.id,
    required this.userId,
    required this.platform,
    required this.title,
    required this.summary,
    required this.sourceUrl,
    DateTime? scrapedAt,
    bool? isRead,
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
    );
  }

  static final t = ScrapedContentTable();

  static const db = ScrapedContentRepository._();

  @override
  int? id;

  int userId;

  String platform;

  String title;

  String summary;

  String sourceUrl;

  DateTime scrapedAt;

  bool isRead;

  @override
  _i1.Table<int?> get table => t;

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
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
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
    };
  }

  static ScrapedContentInclude include() {
    return ScrapedContentInclude._();
  }

  static ScrapedContentIncludeList includeList({
    _i1.WhereExpressionBuilder<ScrapedContentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrapedContentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrapedContentTable>? orderByList,
    ScrapedContentInclude? include,
  }) {
    return ScrapedContentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScrapedContent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ScrapedContent.t),
      include: include,
    );
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
  }) : super._(
         id: id,
         userId: userId,
         platform: platform,
         title: title,
         summary: summary,
         sourceUrl: sourceUrl,
         scrapedAt: scrapedAt,
         isRead: isRead,
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
    );
  }
}

class ScrapedContentUpdateTable extends _i1.UpdateTable<ScrapedContentTable> {
  ScrapedContentUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> platform(String value) => _i1.ColumnValue(
    table.platform,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> summary(String value) => _i1.ColumnValue(
    table.summary,
    value,
  );

  _i1.ColumnValue<String, String> sourceUrl(String value) => _i1.ColumnValue(
    table.sourceUrl,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> scrapedAt(DateTime value) =>
      _i1.ColumnValue(
        table.scrapedAt,
        value,
      );

  _i1.ColumnValue<bool, bool> isRead(bool value) => _i1.ColumnValue(
    table.isRead,
    value,
  );
}

class ScrapedContentTable extends _i1.Table<int?> {
  ScrapedContentTable({super.tableRelation})
    : super(tableName: 'scraped_contents') {
    updateTable = ScrapedContentUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    platform = _i1.ColumnString(
      'platform',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    summary = _i1.ColumnString(
      'summary',
      this,
    );
    sourceUrl = _i1.ColumnString(
      'sourceUrl',
      this,
    );
    scrapedAt = _i1.ColumnDateTime(
      'scrapedAt',
      this,
      hasDefault: true,
    );
    isRead = _i1.ColumnBool(
      'isRead',
      this,
      hasDefault: true,
    );
  }

  late final ScrapedContentUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString platform;

  late final _i1.ColumnString title;

  late final _i1.ColumnString summary;

  late final _i1.ColumnString sourceUrl;

  late final _i1.ColumnDateTime scrapedAt;

  late final _i1.ColumnBool isRead;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    platform,
    title,
    summary,
    sourceUrl,
    scrapedAt,
    isRead,
  ];
}

class ScrapedContentInclude extends _i1.IncludeObject {
  ScrapedContentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ScrapedContent.t;
}

class ScrapedContentIncludeList extends _i1.IncludeList {
  ScrapedContentIncludeList._({
    _i1.WhereExpressionBuilder<ScrapedContentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ScrapedContent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ScrapedContent.t;
}

class ScrapedContentRepository {
  const ScrapedContentRepository._();

  /// Returns a list of [ScrapedContent]s matching the given query parameters.
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
  Future<List<ScrapedContent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrapedContentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrapedContentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrapedContentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ScrapedContent>(
      where: where?.call(ScrapedContent.t),
      orderBy: orderBy?.call(ScrapedContent.t),
      orderByList: orderByList?.call(ScrapedContent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ScrapedContent] matching the given query parameters.
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
  Future<ScrapedContent?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrapedContentTable>? where,
    int? offset,
    _i1.OrderByBuilder<ScrapedContentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrapedContentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ScrapedContent>(
      where: where?.call(ScrapedContent.t),
      orderBy: orderBy?.call(ScrapedContent.t),
      orderByList: orderByList?.call(ScrapedContent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ScrapedContent] by its [id] or null if no such row exists.
  Future<ScrapedContent?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ScrapedContent>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ScrapedContent]s in the list and returns the inserted rows.
  ///
  /// The returned [ScrapedContent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ScrapedContent>> insert(
    _i1.Session session,
    List<ScrapedContent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ScrapedContent>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ScrapedContent] and returns the inserted row.
  ///
  /// The returned [ScrapedContent] will have its `id` field set.
  Future<ScrapedContent> insertRow(
    _i1.Session session,
    ScrapedContent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ScrapedContent>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ScrapedContent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ScrapedContent>> update(
    _i1.Session session,
    List<ScrapedContent> rows, {
    _i1.ColumnSelections<ScrapedContentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ScrapedContent>(
      rows,
      columns: columns?.call(ScrapedContent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScrapedContent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ScrapedContent> updateRow(
    _i1.Session session,
    ScrapedContent row, {
    _i1.ColumnSelections<ScrapedContentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ScrapedContent>(
      row,
      columns: columns?.call(ScrapedContent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScrapedContent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ScrapedContent?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ScrapedContentUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ScrapedContent>(
      id,
      columnValues: columnValues(ScrapedContent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ScrapedContent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ScrapedContent>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ScrapedContentUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ScrapedContentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrapedContentTable>? orderBy,
    _i1.OrderByListBuilder<ScrapedContentTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ScrapedContent>(
      columnValues: columnValues(ScrapedContent.t.updateTable),
      where: where(ScrapedContent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScrapedContent.t),
      orderByList: orderByList?.call(ScrapedContent.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ScrapedContent]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ScrapedContent>> delete(
    _i1.Session session,
    List<ScrapedContent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ScrapedContent>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ScrapedContent].
  Future<ScrapedContent> deleteRow(
    _i1.Session session,
    ScrapedContent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ScrapedContent>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ScrapedContent>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ScrapedContentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ScrapedContent>(
      where: where(ScrapedContent.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrapedContentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ScrapedContent>(
      where: where?.call(ScrapedContent.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
