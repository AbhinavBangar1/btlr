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

abstract class BehaviorLog
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  BehaviorLog._({
    this.id,
    required this.studentProfileId,
    required this.timeBlockId,
    required this.action,
    DateTime? timestamp,
    this.actualDuration,
    this.energyLevel,
    this.notes,
    this.reason,
    this.context,
  }) : timestamp = timestamp ?? DateTime.now();

  factory BehaviorLog({
    int? id,
    required int studentProfileId,
    required int timeBlockId,
    required String action,
    DateTime? timestamp,
    int? actualDuration,
    int? energyLevel,
    String? notes,
    String? reason,
    String? context,
  }) = _BehaviorLogImpl;

  factory BehaviorLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return BehaviorLog(
      id: jsonSerialization['id'] as int?,
      studentProfileId: jsonSerialization['studentProfileId'] as int,
      timeBlockId: jsonSerialization['timeBlockId'] as int,
      action: jsonSerialization['action'] as String,
      timestamp: jsonSerialization['timestamp'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
      actualDuration: jsonSerialization['actualDuration'] as int?,
      energyLevel: jsonSerialization['energyLevel'] as int?,
      notes: jsonSerialization['notes'] as String?,
      reason: jsonSerialization['reason'] as String?,
      context: jsonSerialization['context'] as String?,
    );
  }

  static final t = BehaviorLogTable();

  static const db = BehaviorLogRepository._();

  @override
  int? id;

  int studentProfileId;

  int timeBlockId;

  String action;

  DateTime timestamp;

  int? actualDuration;

  int? energyLevel;

  String? notes;

  String? reason;

  String? context;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [BehaviorLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BehaviorLog copyWith({
    int? id,
    int? studentProfileId,
    int? timeBlockId,
    String? action,
    DateTime? timestamp,
    int? actualDuration,
    int? energyLevel,
    String? notes,
    String? reason,
    String? context,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BehaviorLog',
      if (id != null) 'id': id,
      'studentProfileId': studentProfileId,
      'timeBlockId': timeBlockId,
      'action': action,
      'timestamp': timestamp.toJson(),
      if (actualDuration != null) 'actualDuration': actualDuration,
      if (energyLevel != null) 'energyLevel': energyLevel,
      if (notes != null) 'notes': notes,
      if (reason != null) 'reason': reason,
      if (context != null) 'context': context,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BehaviorLog',
      if (id != null) 'id': id,
      'studentProfileId': studentProfileId,
      'timeBlockId': timeBlockId,
      'action': action,
      'timestamp': timestamp.toJson(),
      if (actualDuration != null) 'actualDuration': actualDuration,
      if (energyLevel != null) 'energyLevel': energyLevel,
      if (notes != null) 'notes': notes,
      if (reason != null) 'reason': reason,
      if (context != null) 'context': context,
    };
  }

  static BehaviorLogInclude include() {
    return BehaviorLogInclude._();
  }

  static BehaviorLogIncludeList includeList({
    _i1.WhereExpressionBuilder<BehaviorLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BehaviorLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BehaviorLogTable>? orderByList,
    BehaviorLogInclude? include,
  }) {
    return BehaviorLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BehaviorLog.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BehaviorLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BehaviorLogImpl extends BehaviorLog {
  _BehaviorLogImpl({
    int? id,
    required int studentProfileId,
    required int timeBlockId,
    required String action,
    DateTime? timestamp,
    int? actualDuration,
    int? energyLevel,
    String? notes,
    String? reason,
    String? context,
  }) : super._(
         id: id,
         studentProfileId: studentProfileId,
         timeBlockId: timeBlockId,
         action: action,
         timestamp: timestamp,
         actualDuration: actualDuration,
         energyLevel: energyLevel,
         notes: notes,
         reason: reason,
         context: context,
       );

  /// Returns a shallow copy of this [BehaviorLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BehaviorLog copyWith({
    Object? id = _Undefined,
    int? studentProfileId,
    int? timeBlockId,
    String? action,
    DateTime? timestamp,
    Object? actualDuration = _Undefined,
    Object? energyLevel = _Undefined,
    Object? notes = _Undefined,
    Object? reason = _Undefined,
    Object? context = _Undefined,
  }) {
    return BehaviorLog(
      id: id is int? ? id : this.id,
      studentProfileId: studentProfileId ?? this.studentProfileId,
      timeBlockId: timeBlockId ?? this.timeBlockId,
      action: action ?? this.action,
      timestamp: timestamp ?? this.timestamp,
      actualDuration: actualDuration is int?
          ? actualDuration
          : this.actualDuration,
      energyLevel: energyLevel is int? ? energyLevel : this.energyLevel,
      notes: notes is String? ? notes : this.notes,
      reason: reason is String? ? reason : this.reason,
      context: context is String? ? context : this.context,
    );
  }
}

class BehaviorLogUpdateTable extends _i1.UpdateTable<BehaviorLogTable> {
  BehaviorLogUpdateTable(super.table);

  _i1.ColumnValue<int, int> studentProfileId(int value) => _i1.ColumnValue(
    table.studentProfileId,
    value,
  );

  _i1.ColumnValue<int, int> timeBlockId(int value) => _i1.ColumnValue(
    table.timeBlockId,
    value,
  );

  _i1.ColumnValue<String, String> action(String value) => _i1.ColumnValue(
    table.action,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> timestamp(DateTime value) =>
      _i1.ColumnValue(
        table.timestamp,
        value,
      );

  _i1.ColumnValue<int, int> actualDuration(int? value) => _i1.ColumnValue(
    table.actualDuration,
    value,
  );

  _i1.ColumnValue<int, int> energyLevel(int? value) => _i1.ColumnValue(
    table.energyLevel,
    value,
  );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
    value,
  );

  _i1.ColumnValue<String, String> reason(String? value) => _i1.ColumnValue(
    table.reason,
    value,
  );

  _i1.ColumnValue<String, String> context(String? value) => _i1.ColumnValue(
    table.context,
    value,
  );
}

class BehaviorLogTable extends _i1.Table<int?> {
  BehaviorLogTable({super.tableRelation}) : super(tableName: 'behavior_log') {
    updateTable = BehaviorLogUpdateTable(this);
    studentProfileId = _i1.ColumnInt(
      'studentProfileId',
      this,
    );
    timeBlockId = _i1.ColumnInt(
      'timeBlockId',
      this,
    );
    action = _i1.ColumnString(
      'action',
      this,
    );
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      this,
      hasDefault: true,
    );
    actualDuration = _i1.ColumnInt(
      'actualDuration',
      this,
    );
    energyLevel = _i1.ColumnInt(
      'energyLevel',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
      this,
    );
    reason = _i1.ColumnString(
      'reason',
      this,
    );
    context = _i1.ColumnString(
      'context',
      this,
    );
  }

  late final BehaviorLogUpdateTable updateTable;

  late final _i1.ColumnInt studentProfileId;

  late final _i1.ColumnInt timeBlockId;

  late final _i1.ColumnString action;

  late final _i1.ColumnDateTime timestamp;

  late final _i1.ColumnInt actualDuration;

  late final _i1.ColumnInt energyLevel;

  late final _i1.ColumnString notes;

  late final _i1.ColumnString reason;

  late final _i1.ColumnString context;

  @override
  List<_i1.Column> get columns => [
    id,
    studentProfileId,
    timeBlockId,
    action,
    timestamp,
    actualDuration,
    energyLevel,
    notes,
    reason,
    context,
  ];
}

class BehaviorLogInclude extends _i1.IncludeObject {
  BehaviorLogInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => BehaviorLog.t;
}

class BehaviorLogIncludeList extends _i1.IncludeList {
  BehaviorLogIncludeList._({
    _i1.WhereExpressionBuilder<BehaviorLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BehaviorLog.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BehaviorLog.t;
}

class BehaviorLogRepository {
  const BehaviorLogRepository._();

  /// Returns a list of [BehaviorLog]s matching the given query parameters.
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
  Future<List<BehaviorLog>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BehaviorLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BehaviorLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BehaviorLogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BehaviorLog>(
      where: where?.call(BehaviorLog.t),
      orderBy: orderBy?.call(BehaviorLog.t),
      orderByList: orderByList?.call(BehaviorLog.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BehaviorLog] matching the given query parameters.
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
  Future<BehaviorLog?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BehaviorLogTable>? where,
    int? offset,
    _i1.OrderByBuilder<BehaviorLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BehaviorLogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BehaviorLog>(
      where: where?.call(BehaviorLog.t),
      orderBy: orderBy?.call(BehaviorLog.t),
      orderByList: orderByList?.call(BehaviorLog.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BehaviorLog] by its [id] or null if no such row exists.
  Future<BehaviorLog?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BehaviorLog>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BehaviorLog]s in the list and returns the inserted rows.
  ///
  /// The returned [BehaviorLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BehaviorLog>> insert(
    _i1.Session session,
    List<BehaviorLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BehaviorLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BehaviorLog] and returns the inserted row.
  ///
  /// The returned [BehaviorLog] will have its `id` field set.
  Future<BehaviorLog> insertRow(
    _i1.Session session,
    BehaviorLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BehaviorLog>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BehaviorLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BehaviorLog>> update(
    _i1.Session session,
    List<BehaviorLog> rows, {
    _i1.ColumnSelections<BehaviorLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BehaviorLog>(
      rows,
      columns: columns?.call(BehaviorLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BehaviorLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BehaviorLog> updateRow(
    _i1.Session session,
    BehaviorLog row, {
    _i1.ColumnSelections<BehaviorLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BehaviorLog>(
      row,
      columns: columns?.call(BehaviorLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BehaviorLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BehaviorLog?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<BehaviorLogUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<BehaviorLog>(
      id,
      columnValues: columnValues(BehaviorLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BehaviorLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<BehaviorLog>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<BehaviorLogUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<BehaviorLogTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BehaviorLogTable>? orderBy,
    _i1.OrderByListBuilder<BehaviorLogTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<BehaviorLog>(
      columnValues: columnValues(BehaviorLog.t.updateTable),
      where: where(BehaviorLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BehaviorLog.t),
      orderByList: orderByList?.call(BehaviorLog.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [BehaviorLog]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BehaviorLog>> delete(
    _i1.Session session,
    List<BehaviorLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BehaviorLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BehaviorLog].
  Future<BehaviorLog> deleteRow(
    _i1.Session session,
    BehaviorLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BehaviorLog>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BehaviorLog>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BehaviorLogTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BehaviorLog>(
      where: where(BehaviorLog.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BehaviorLogTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BehaviorLog>(
      where: where?.call(BehaviorLog.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
