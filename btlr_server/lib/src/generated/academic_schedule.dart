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

abstract class AcademicSchedule
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AcademicSchedule._({
    this.id,
    required this.studentProfileId,
    required this.title,
    required this.type,
    this.location,
    this.rrule,
    required this.startTime,
    required this.endTime,
    bool? isRecurring,
    this.deletedAt,
    DateTime? createdAt,
  }) : isRecurring = isRecurring ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory AcademicSchedule({
    int? id,
    required int studentProfileId,
    required String title,
    required String type,
    String? location,
    String? rrule,
    required DateTime startTime,
    required DateTime endTime,
    bool? isRecurring,
    DateTime? deletedAt,
    DateTime? createdAt,
  }) = _AcademicScheduleImpl;

  factory AcademicSchedule.fromJson(Map<String, dynamic> jsonSerialization) {
    return AcademicSchedule(
      id: jsonSerialization['id'] as int?,
      studentProfileId: jsonSerialization['studentProfileId'] as int,
      title: jsonSerialization['title'] as String,
      type: jsonSerialization['type'] as String,
      location: jsonSerialization['location'] as String?,
      rrule: jsonSerialization['rrule'] as String?,
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      endTime: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      isRecurring: jsonSerialization['isRecurring'] as bool?,
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = AcademicScheduleTable();

  static const db = AcademicScheduleRepository._();

  @override
  int? id;

  int studentProfileId;

  String title;

  String type;

  String? location;

  String? rrule;

  DateTime startTime;

  DateTime endTime;

  bool isRecurring;

  DateTime? deletedAt;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AcademicSchedule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AcademicSchedule copyWith({
    int? id,
    int? studentProfileId,
    String? title,
    String? type,
    String? location,
    String? rrule,
    DateTime? startTime,
    DateTime? endTime,
    bool? isRecurring,
    DateTime? deletedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AcademicSchedule',
      if (id != null) 'id': id,
      'studentProfileId': studentProfileId,
      'title': title,
      'type': type,
      if (location != null) 'location': location,
      if (rrule != null) 'rrule': rrule,
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      'isRecurring': isRecurring,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AcademicSchedule',
      if (id != null) 'id': id,
      'studentProfileId': studentProfileId,
      'title': title,
      'type': type,
      if (location != null) 'location': location,
      if (rrule != null) 'rrule': rrule,
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      'isRecurring': isRecurring,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static AcademicScheduleInclude include() {
    return AcademicScheduleInclude._();
  }

  static AcademicScheduleIncludeList includeList({
    _i1.WhereExpressionBuilder<AcademicScheduleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AcademicScheduleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AcademicScheduleTable>? orderByList,
    AcademicScheduleInclude? include,
  }) {
    return AcademicScheduleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AcademicSchedule.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AcademicSchedule.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AcademicScheduleImpl extends AcademicSchedule {
  _AcademicScheduleImpl({
    int? id,
    required int studentProfileId,
    required String title,
    required String type,
    String? location,
    String? rrule,
    required DateTime startTime,
    required DateTime endTime,
    bool? isRecurring,
    DateTime? deletedAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         studentProfileId: studentProfileId,
         title: title,
         type: type,
         location: location,
         rrule: rrule,
         startTime: startTime,
         endTime: endTime,
         isRecurring: isRecurring,
         deletedAt: deletedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AcademicSchedule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AcademicSchedule copyWith({
    Object? id = _Undefined,
    int? studentProfileId,
    String? title,
    String? type,
    Object? location = _Undefined,
    Object? rrule = _Undefined,
    DateTime? startTime,
    DateTime? endTime,
    bool? isRecurring,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return AcademicSchedule(
      id: id is int? ? id : this.id,
      studentProfileId: studentProfileId ?? this.studentProfileId,
      title: title ?? this.title,
      type: type ?? this.type,
      location: location is String? ? location : this.location,
      rrule: rrule is String? ? rrule : this.rrule,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isRecurring: isRecurring ?? this.isRecurring,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AcademicScheduleUpdateTable
    extends _i1.UpdateTable<AcademicScheduleTable> {
  AcademicScheduleUpdateTable(super.table);

  _i1.ColumnValue<int, int> studentProfileId(int value) => _i1.ColumnValue(
    table.studentProfileId,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> type(String value) => _i1.ColumnValue(
    table.type,
    value,
  );

  _i1.ColumnValue<String, String> location(String? value) => _i1.ColumnValue(
    table.location,
    value,
  );

  _i1.ColumnValue<String, String> rrule(String? value) => _i1.ColumnValue(
    table.rrule,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startTime(DateTime value) =>
      _i1.ColumnValue(
        table.startTime,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endTime(DateTime value) =>
      _i1.ColumnValue(
        table.endTime,
        value,
      );

  _i1.ColumnValue<bool, bool> isRecurring(bool value) => _i1.ColumnValue(
    table.isRecurring,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> deletedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.deletedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AcademicScheduleTable extends _i1.Table<int?> {
  AcademicScheduleTable({super.tableRelation})
    : super(tableName: 'academic_schedule') {
    updateTable = AcademicScheduleUpdateTable(this);
    studentProfileId = _i1.ColumnInt(
      'studentProfileId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
    );
    location = _i1.ColumnString(
      'location',
      this,
    );
    rrule = _i1.ColumnString(
      'rrule',
      this,
    );
    startTime = _i1.ColumnDateTime(
      'startTime',
      this,
    );
    endTime = _i1.ColumnDateTime(
      'endTime',
      this,
    );
    isRecurring = _i1.ColumnBool(
      'isRecurring',
      this,
      hasDefault: true,
    );
    deletedAt = _i1.ColumnDateTime(
      'deletedAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final AcademicScheduleUpdateTable updateTable;

  late final _i1.ColumnInt studentProfileId;

  late final _i1.ColumnString title;

  late final _i1.ColumnString type;

  late final _i1.ColumnString location;

  late final _i1.ColumnString rrule;

  late final _i1.ColumnDateTime startTime;

  late final _i1.ColumnDateTime endTime;

  late final _i1.ColumnBool isRecurring;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    studentProfileId,
    title,
    type,
    location,
    rrule,
    startTime,
    endTime,
    isRecurring,
    deletedAt,
    createdAt,
  ];
}

class AcademicScheduleInclude extends _i1.IncludeObject {
  AcademicScheduleInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AcademicSchedule.t;
}

class AcademicScheduleIncludeList extends _i1.IncludeList {
  AcademicScheduleIncludeList._({
    _i1.WhereExpressionBuilder<AcademicScheduleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AcademicSchedule.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AcademicSchedule.t;
}

class AcademicScheduleRepository {
  const AcademicScheduleRepository._();

  /// Returns a list of [AcademicSchedule]s matching the given query parameters.
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
  Future<List<AcademicSchedule>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AcademicScheduleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AcademicScheduleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AcademicScheduleTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AcademicSchedule>(
      where: where?.call(AcademicSchedule.t),
      orderBy: orderBy?.call(AcademicSchedule.t),
      orderByList: orderByList?.call(AcademicSchedule.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AcademicSchedule] matching the given query parameters.
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
  Future<AcademicSchedule?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AcademicScheduleTable>? where,
    int? offset,
    _i1.OrderByBuilder<AcademicScheduleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AcademicScheduleTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AcademicSchedule>(
      where: where?.call(AcademicSchedule.t),
      orderBy: orderBy?.call(AcademicSchedule.t),
      orderByList: orderByList?.call(AcademicSchedule.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AcademicSchedule] by its [id] or null if no such row exists.
  Future<AcademicSchedule?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AcademicSchedule>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AcademicSchedule]s in the list and returns the inserted rows.
  ///
  /// The returned [AcademicSchedule]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AcademicSchedule>> insert(
    _i1.Session session,
    List<AcademicSchedule> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AcademicSchedule>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AcademicSchedule] and returns the inserted row.
  ///
  /// The returned [AcademicSchedule] will have its `id` field set.
  Future<AcademicSchedule> insertRow(
    _i1.Session session,
    AcademicSchedule row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AcademicSchedule>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AcademicSchedule]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AcademicSchedule>> update(
    _i1.Session session,
    List<AcademicSchedule> rows, {
    _i1.ColumnSelections<AcademicScheduleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AcademicSchedule>(
      rows,
      columns: columns?.call(AcademicSchedule.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AcademicSchedule]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AcademicSchedule> updateRow(
    _i1.Session session,
    AcademicSchedule row, {
    _i1.ColumnSelections<AcademicScheduleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AcademicSchedule>(
      row,
      columns: columns?.call(AcademicSchedule.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AcademicSchedule] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AcademicSchedule?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AcademicScheduleUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AcademicSchedule>(
      id,
      columnValues: columnValues(AcademicSchedule.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AcademicSchedule]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AcademicSchedule>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AcademicScheduleUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AcademicScheduleTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AcademicScheduleTable>? orderBy,
    _i1.OrderByListBuilder<AcademicScheduleTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AcademicSchedule>(
      columnValues: columnValues(AcademicSchedule.t.updateTable),
      where: where(AcademicSchedule.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AcademicSchedule.t),
      orderByList: orderByList?.call(AcademicSchedule.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AcademicSchedule]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AcademicSchedule>> delete(
    _i1.Session session,
    List<AcademicSchedule> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AcademicSchedule>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AcademicSchedule].
  Future<AcademicSchedule> deleteRow(
    _i1.Session session,
    AcademicSchedule row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AcademicSchedule>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AcademicSchedule>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AcademicScheduleTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AcademicSchedule>(
      where: where(AcademicSchedule.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AcademicScheduleTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AcademicSchedule>(
      where: where?.call(AcademicSchedule.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
