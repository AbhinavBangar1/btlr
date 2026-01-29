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

abstract class UserScrapingPreference
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = UserScrapingPreferenceTable();

  static const db = UserScrapingPreferenceRepository._();

  @override
  int? id;

  int userId;

  String platform;

  String? customUrl;

  bool isActive;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static UserScrapingPreferenceInclude include() {
    return UserScrapingPreferenceInclude._();
  }

  static UserScrapingPreferenceIncludeList includeList({
    _i1.WhereExpressionBuilder<UserScrapingPreferenceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserScrapingPreferenceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserScrapingPreferenceTable>? orderByList,
    UserScrapingPreferenceInclude? include,
  }) {
    return UserScrapingPreferenceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserScrapingPreference.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserScrapingPreference.t),
      include: include,
    );
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

class UserScrapingPreferenceUpdateTable
    extends _i1.UpdateTable<UserScrapingPreferenceTable> {
  UserScrapingPreferenceUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> platform(String value) => _i1.ColumnValue(
    table.platform,
    value,
  );

  _i1.ColumnValue<String, String> customUrl(String? value) => _i1.ColumnValue(
    table.customUrl,
    value,
  );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class UserScrapingPreferenceTable extends _i1.Table<int?> {
  UserScrapingPreferenceTable({super.tableRelation})
    : super(tableName: 'user_scraping_preferences') {
    updateTable = UserScrapingPreferenceUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    platform = _i1.ColumnString(
      'platform',
      this,
    );
    customUrl = _i1.ColumnString(
      'customUrl',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final UserScrapingPreferenceUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString platform;

  late final _i1.ColumnString customUrl;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    platform,
    customUrl,
    isActive,
    createdAt,
  ];
}

class UserScrapingPreferenceInclude extends _i1.IncludeObject {
  UserScrapingPreferenceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserScrapingPreference.t;
}

class UserScrapingPreferenceIncludeList extends _i1.IncludeList {
  UserScrapingPreferenceIncludeList._({
    _i1.WhereExpressionBuilder<UserScrapingPreferenceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserScrapingPreference.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserScrapingPreference.t;
}

class UserScrapingPreferenceRepository {
  const UserScrapingPreferenceRepository._();

  /// Returns a list of [UserScrapingPreference]s matching the given query parameters.
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
  Future<List<UserScrapingPreference>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserScrapingPreferenceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserScrapingPreferenceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserScrapingPreferenceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserScrapingPreference>(
      where: where?.call(UserScrapingPreference.t),
      orderBy: orderBy?.call(UserScrapingPreference.t),
      orderByList: orderByList?.call(UserScrapingPreference.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserScrapingPreference] matching the given query parameters.
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
  Future<UserScrapingPreference?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserScrapingPreferenceTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserScrapingPreferenceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserScrapingPreferenceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserScrapingPreference>(
      where: where?.call(UserScrapingPreference.t),
      orderBy: orderBy?.call(UserScrapingPreference.t),
      orderByList: orderByList?.call(UserScrapingPreference.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserScrapingPreference] by its [id] or null if no such row exists.
  Future<UserScrapingPreference?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserScrapingPreference>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserScrapingPreference]s in the list and returns the inserted rows.
  ///
  /// The returned [UserScrapingPreference]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserScrapingPreference>> insert(
    _i1.Session session,
    List<UserScrapingPreference> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserScrapingPreference>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserScrapingPreference] and returns the inserted row.
  ///
  /// The returned [UserScrapingPreference] will have its `id` field set.
  Future<UserScrapingPreference> insertRow(
    _i1.Session session,
    UserScrapingPreference row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserScrapingPreference>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserScrapingPreference]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserScrapingPreference>> update(
    _i1.Session session,
    List<UserScrapingPreference> rows, {
    _i1.ColumnSelections<UserScrapingPreferenceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserScrapingPreference>(
      rows,
      columns: columns?.call(UserScrapingPreference.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserScrapingPreference]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserScrapingPreference> updateRow(
    _i1.Session session,
    UserScrapingPreference row, {
    _i1.ColumnSelections<UserScrapingPreferenceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserScrapingPreference>(
      row,
      columns: columns?.call(UserScrapingPreference.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserScrapingPreference] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserScrapingPreference?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UserScrapingPreferenceUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserScrapingPreference>(
      id,
      columnValues: columnValues(UserScrapingPreference.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserScrapingPreference]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserScrapingPreference>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserScrapingPreferenceUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<UserScrapingPreferenceTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserScrapingPreferenceTable>? orderBy,
    _i1.OrderByListBuilder<UserScrapingPreferenceTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserScrapingPreference>(
      columnValues: columnValues(UserScrapingPreference.t.updateTable),
      where: where(UserScrapingPreference.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserScrapingPreference.t),
      orderByList: orderByList?.call(UserScrapingPreference.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserScrapingPreference]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserScrapingPreference>> delete(
    _i1.Session session,
    List<UserScrapingPreference> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserScrapingPreference>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserScrapingPreference].
  Future<UserScrapingPreference> deleteRow(
    _i1.Session session,
    UserScrapingPreference row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserScrapingPreference>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserScrapingPreference>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserScrapingPreferenceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserScrapingPreference>(
      where: where(UserScrapingPreference.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserScrapingPreferenceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserScrapingPreference>(
      where: where?.call(UserScrapingPreference.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
