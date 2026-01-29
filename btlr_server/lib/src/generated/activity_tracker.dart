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

abstract class ActivityTracker
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ActivityTracker._({
    this.id,
    required this.userId,
    required this.platform,
    required this.username,
    this.lastSynced,
    required this.activityData,
    bool? isActive,
  }) : isActive = isActive ?? true;

  factory ActivityTracker({
    int? id,
    required int userId,
    required String platform,
    required String username,
    DateTime? lastSynced,
    required String activityData,
    bool? isActive,
  }) = _ActivityTrackerImpl;

  factory ActivityTracker.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActivityTracker(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      platform: jsonSerialization['platform'] as String,
      username: jsonSerialization['username'] as String,
      lastSynced: jsonSerialization['lastSynced'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastSynced']),
      activityData: jsonSerialization['activityData'] as String,
      isActive: jsonSerialization['isActive'] as bool?,
    );
  }

  static final t = ActivityTrackerTable();

  static const db = ActivityTrackerRepository._();

  @override
  int? id;

  int userId;

  String platform;

  String username;

  DateTime? lastSynced;

  String activityData;

  bool isActive;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ActivityTracker]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ActivityTracker copyWith({
    int? id,
    int? userId,
    String? platform,
    String? username,
    DateTime? lastSynced,
    String? activityData,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ActivityTracker',
      if (id != null) 'id': id,
      'userId': userId,
      'platform': platform,
      'username': username,
      if (lastSynced != null) 'lastSynced': lastSynced?.toJson(),
      'activityData': activityData,
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ActivityTracker',
      if (id != null) 'id': id,
      'userId': userId,
      'platform': platform,
      'username': username,
      if (lastSynced != null) 'lastSynced': lastSynced?.toJson(),
      'activityData': activityData,
      'isActive': isActive,
    };
  }

  static ActivityTrackerInclude include() {
    return ActivityTrackerInclude._();
  }

  static ActivityTrackerIncludeList includeList({
    _i1.WhereExpressionBuilder<ActivityTrackerTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActivityTrackerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActivityTrackerTable>? orderByList,
    ActivityTrackerInclude? include,
  }) {
    return ActivityTrackerIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ActivityTracker.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ActivityTracker.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActivityTrackerImpl extends ActivityTracker {
  _ActivityTrackerImpl({
    int? id,
    required int userId,
    required String platform,
    required String username,
    DateTime? lastSynced,
    required String activityData,
    bool? isActive,
  }) : super._(
         id: id,
         userId: userId,
         platform: platform,
         username: username,
         lastSynced: lastSynced,
         activityData: activityData,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [ActivityTracker]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ActivityTracker copyWith({
    Object? id = _Undefined,
    int? userId,
    String? platform,
    String? username,
    Object? lastSynced = _Undefined,
    String? activityData,
    bool? isActive,
  }) {
    return ActivityTracker(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      platform: platform ?? this.platform,
      username: username ?? this.username,
      lastSynced: lastSynced is DateTime? ? lastSynced : this.lastSynced,
      activityData: activityData ?? this.activityData,
      isActive: isActive ?? this.isActive,
    );
  }
}

class ActivityTrackerUpdateTable extends _i1.UpdateTable<ActivityTrackerTable> {
  ActivityTrackerUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> platform(String value) => _i1.ColumnValue(
    table.platform,
    value,
  );

  _i1.ColumnValue<String, String> username(String value) => _i1.ColumnValue(
    table.username,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastSynced(DateTime? value) =>
      _i1.ColumnValue(
        table.lastSynced,
        value,
      );

  _i1.ColumnValue<String, String> activityData(String value) => _i1.ColumnValue(
    table.activityData,
    value,
  );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );
}

class ActivityTrackerTable extends _i1.Table<int?> {
  ActivityTrackerTable({super.tableRelation})
    : super(tableName: 'activity_trackers') {
    updateTable = ActivityTrackerUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    platform = _i1.ColumnString(
      'platform',
      this,
    );
    username = _i1.ColumnString(
      'username',
      this,
    );
    lastSynced = _i1.ColumnDateTime(
      'lastSynced',
      this,
    );
    activityData = _i1.ColumnString(
      'activityData',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
  }

  late final ActivityTrackerUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString platform;

  late final _i1.ColumnString username;

  late final _i1.ColumnDateTime lastSynced;

  late final _i1.ColumnString activityData;

  late final _i1.ColumnBool isActive;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    platform,
    username,
    lastSynced,
    activityData,
    isActive,
  ];
}

class ActivityTrackerInclude extends _i1.IncludeObject {
  ActivityTrackerInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ActivityTracker.t;
}

class ActivityTrackerIncludeList extends _i1.IncludeList {
  ActivityTrackerIncludeList._({
    _i1.WhereExpressionBuilder<ActivityTrackerTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ActivityTracker.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ActivityTracker.t;
}

class ActivityTrackerRepository {
  const ActivityTrackerRepository._();

  /// Returns a list of [ActivityTracker]s matching the given query parameters.
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
  Future<List<ActivityTracker>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActivityTrackerTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActivityTrackerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActivityTrackerTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ActivityTracker>(
      where: where?.call(ActivityTracker.t),
      orderBy: orderBy?.call(ActivityTracker.t),
      orderByList: orderByList?.call(ActivityTracker.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ActivityTracker] matching the given query parameters.
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
  Future<ActivityTracker?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActivityTrackerTable>? where,
    int? offset,
    _i1.OrderByBuilder<ActivityTrackerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActivityTrackerTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ActivityTracker>(
      where: where?.call(ActivityTracker.t),
      orderBy: orderBy?.call(ActivityTracker.t),
      orderByList: orderByList?.call(ActivityTracker.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ActivityTracker] by its [id] or null if no such row exists.
  Future<ActivityTracker?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ActivityTracker>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ActivityTracker]s in the list and returns the inserted rows.
  ///
  /// The returned [ActivityTracker]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ActivityTracker>> insert(
    _i1.Session session,
    List<ActivityTracker> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ActivityTracker>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ActivityTracker] and returns the inserted row.
  ///
  /// The returned [ActivityTracker] will have its `id` field set.
  Future<ActivityTracker> insertRow(
    _i1.Session session,
    ActivityTracker row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ActivityTracker>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ActivityTracker]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ActivityTracker>> update(
    _i1.Session session,
    List<ActivityTracker> rows, {
    _i1.ColumnSelections<ActivityTrackerTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ActivityTracker>(
      rows,
      columns: columns?.call(ActivityTracker.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ActivityTracker]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ActivityTracker> updateRow(
    _i1.Session session,
    ActivityTracker row, {
    _i1.ColumnSelections<ActivityTrackerTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ActivityTracker>(
      row,
      columns: columns?.call(ActivityTracker.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ActivityTracker] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ActivityTracker?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ActivityTrackerUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ActivityTracker>(
      id,
      columnValues: columnValues(ActivityTracker.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ActivityTracker]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ActivityTracker>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ActivityTrackerUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ActivityTrackerTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActivityTrackerTable>? orderBy,
    _i1.OrderByListBuilder<ActivityTrackerTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ActivityTracker>(
      columnValues: columnValues(ActivityTracker.t.updateTable),
      where: where(ActivityTracker.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ActivityTracker.t),
      orderByList: orderByList?.call(ActivityTracker.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ActivityTracker]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ActivityTracker>> delete(
    _i1.Session session,
    List<ActivityTracker> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ActivityTracker>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ActivityTracker].
  Future<ActivityTracker> deleteRow(
    _i1.Session session,
    ActivityTracker row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ActivityTracker>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ActivityTracker>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ActivityTrackerTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ActivityTracker>(
      where: where(ActivityTracker.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActivityTrackerTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ActivityTracker>(
      where: where?.call(ActivityTracker.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
