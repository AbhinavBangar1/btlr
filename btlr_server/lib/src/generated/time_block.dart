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

abstract class TimeBlock
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TimeBlock._({
    this.id,
    required this.dailyPlanId,
    this.learningGoalId,
    this.academicScheduleId,
    required this.title,
    this.description,
    required this.blockType,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    bool? isCompleted,
    String? completionStatus,
    this.actualDurationMinutes,
    this.energyLevel,
    this.notes,
    this.missReason,
    DateTime? createdAt,
  }) : isCompleted = isCompleted ?? false,
       completionStatus = completionStatus ?? 'pending',
       createdAt = createdAt ?? DateTime.now();

  factory TimeBlock({
    int? id,
    required int dailyPlanId,
    int? learningGoalId,
    int? academicScheduleId,
    required String title,
    String? description,
    required String blockType,
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes,
    bool? isCompleted,
    String? completionStatus,
    int? actualDurationMinutes,
    int? energyLevel,
    String? notes,
    String? missReason,
    DateTime? createdAt,
  }) = _TimeBlockImpl;

  factory TimeBlock.fromJson(Map<String, dynamic> jsonSerialization) {
    return TimeBlock(
      id: jsonSerialization['id'] as int?,
      dailyPlanId: jsonSerialization['dailyPlanId'] as int,
      learningGoalId: jsonSerialization['learningGoalId'] as int?,
      academicScheduleId: jsonSerialization['academicScheduleId'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      blockType: jsonSerialization['blockType'] as String,
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      endTime: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      durationMinutes: jsonSerialization['durationMinutes'] as int,
      isCompleted: jsonSerialization['isCompleted'] as bool?,
      completionStatus: jsonSerialization['completionStatus'] as String?,
      actualDurationMinutes: jsonSerialization['actualDurationMinutes'] as int?,
      energyLevel: jsonSerialization['energyLevel'] as int?,
      notes: jsonSerialization['notes'] as String?,
      missReason: jsonSerialization['missReason'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = TimeBlockTable();

  static const db = TimeBlockRepository._();

  @override
  int? id;

  int dailyPlanId;

  int? learningGoalId;

  int? academicScheduleId;

  String title;

  String? description;

  String blockType;

  DateTime startTime;

  DateTime endTime;

  int durationMinutes;

  bool isCompleted;

  String completionStatus;

  int? actualDurationMinutes;

  int? energyLevel;

  String? notes;

  String? missReason;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TimeBlock]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TimeBlock copyWith({
    int? id,
    int? dailyPlanId,
    int? learningGoalId,
    int? academicScheduleId,
    String? title,
    String? description,
    String? blockType,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    bool? isCompleted,
    String? completionStatus,
    int? actualDurationMinutes,
    int? energyLevel,
    String? notes,
    String? missReason,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TimeBlock',
      if (id != null) 'id': id,
      'dailyPlanId': dailyPlanId,
      if (learningGoalId != null) 'learningGoalId': learningGoalId,
      if (academicScheduleId != null) 'academicScheduleId': academicScheduleId,
      'title': title,
      if (description != null) 'description': description,
      'blockType': blockType,
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'completionStatus': completionStatus,
      if (actualDurationMinutes != null)
        'actualDurationMinutes': actualDurationMinutes,
      if (energyLevel != null) 'energyLevel': energyLevel,
      if (notes != null) 'notes': notes,
      if (missReason != null) 'missReason': missReason,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TimeBlock',
      if (id != null) 'id': id,
      'dailyPlanId': dailyPlanId,
      if (learningGoalId != null) 'learningGoalId': learningGoalId,
      if (academicScheduleId != null) 'academicScheduleId': academicScheduleId,
      'title': title,
      if (description != null) 'description': description,
      'blockType': blockType,
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'completionStatus': completionStatus,
      if (actualDurationMinutes != null)
        'actualDurationMinutes': actualDurationMinutes,
      if (energyLevel != null) 'energyLevel': energyLevel,
      if (notes != null) 'notes': notes,
      if (missReason != null) 'missReason': missReason,
      'createdAt': createdAt.toJson(),
    };
  }

  static TimeBlockInclude include() {
    return TimeBlockInclude._();
  }

  static TimeBlockIncludeList includeList({
    _i1.WhereExpressionBuilder<TimeBlockTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TimeBlockTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TimeBlockTable>? orderByList,
    TimeBlockInclude? include,
  }) {
    return TimeBlockIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TimeBlock.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TimeBlock.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TimeBlockImpl extends TimeBlock {
  _TimeBlockImpl({
    int? id,
    required int dailyPlanId,
    int? learningGoalId,
    int? academicScheduleId,
    required String title,
    String? description,
    required String blockType,
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes,
    bool? isCompleted,
    String? completionStatus,
    int? actualDurationMinutes,
    int? energyLevel,
    String? notes,
    String? missReason,
    DateTime? createdAt,
  }) : super._(
         id: id,
         dailyPlanId: dailyPlanId,
         learningGoalId: learningGoalId,
         academicScheduleId: academicScheduleId,
         title: title,
         description: description,
         blockType: blockType,
         startTime: startTime,
         endTime: endTime,
         durationMinutes: durationMinutes,
         isCompleted: isCompleted,
         completionStatus: completionStatus,
         actualDurationMinutes: actualDurationMinutes,
         energyLevel: energyLevel,
         notes: notes,
         missReason: missReason,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TimeBlock]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TimeBlock copyWith({
    Object? id = _Undefined,
    int? dailyPlanId,
    Object? learningGoalId = _Undefined,
    Object? academicScheduleId = _Undefined,
    String? title,
    Object? description = _Undefined,
    String? blockType,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    bool? isCompleted,
    String? completionStatus,
    Object? actualDurationMinutes = _Undefined,
    Object? energyLevel = _Undefined,
    Object? notes = _Undefined,
    Object? missReason = _Undefined,
    DateTime? createdAt,
  }) {
    return TimeBlock(
      id: id is int? ? id : this.id,
      dailyPlanId: dailyPlanId ?? this.dailyPlanId,
      learningGoalId: learningGoalId is int?
          ? learningGoalId
          : this.learningGoalId,
      academicScheduleId: academicScheduleId is int?
          ? academicScheduleId
          : this.academicScheduleId,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      blockType: blockType ?? this.blockType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      completionStatus: completionStatus ?? this.completionStatus,
      actualDurationMinutes: actualDurationMinutes is int?
          ? actualDurationMinutes
          : this.actualDurationMinutes,
      energyLevel: energyLevel is int? ? energyLevel : this.energyLevel,
      notes: notes is String? ? notes : this.notes,
      missReason: missReason is String? ? missReason : this.missReason,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TimeBlockUpdateTable extends _i1.UpdateTable<TimeBlockTable> {
  TimeBlockUpdateTable(super.table);

  _i1.ColumnValue<int, int> dailyPlanId(int value) => _i1.ColumnValue(
    table.dailyPlanId,
    value,
  );

  _i1.ColumnValue<int, int> learningGoalId(int? value) => _i1.ColumnValue(
    table.learningGoalId,
    value,
  );

  _i1.ColumnValue<int, int> academicScheduleId(int? value) => _i1.ColumnValue(
    table.academicScheduleId,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> blockType(String value) => _i1.ColumnValue(
    table.blockType,
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

  _i1.ColumnValue<int, int> durationMinutes(int value) => _i1.ColumnValue(
    table.durationMinutes,
    value,
  );

  _i1.ColumnValue<bool, bool> isCompleted(bool value) => _i1.ColumnValue(
    table.isCompleted,
    value,
  );

  _i1.ColumnValue<String, String> completionStatus(String value) =>
      _i1.ColumnValue(
        table.completionStatus,
        value,
      );

  _i1.ColumnValue<int, int> actualDurationMinutes(int? value) =>
      _i1.ColumnValue(
        table.actualDurationMinutes,
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

  _i1.ColumnValue<String, String> missReason(String? value) => _i1.ColumnValue(
    table.missReason,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class TimeBlockTable extends _i1.Table<int?> {
  TimeBlockTable({super.tableRelation}) : super(tableName: 'time_block') {
    updateTable = TimeBlockUpdateTable(this);
    dailyPlanId = _i1.ColumnInt(
      'dailyPlanId',
      this,
    );
    learningGoalId = _i1.ColumnInt(
      'learningGoalId',
      this,
    );
    academicScheduleId = _i1.ColumnInt(
      'academicScheduleId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    blockType = _i1.ColumnString(
      'blockType',
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
    durationMinutes = _i1.ColumnInt(
      'durationMinutes',
      this,
    );
    isCompleted = _i1.ColumnBool(
      'isCompleted',
      this,
      hasDefault: true,
    );
    completionStatus = _i1.ColumnString(
      'completionStatus',
      this,
      hasDefault: true,
    );
    actualDurationMinutes = _i1.ColumnInt(
      'actualDurationMinutes',
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
    missReason = _i1.ColumnString(
      'missReason',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final TimeBlockUpdateTable updateTable;

  late final _i1.ColumnInt dailyPlanId;

  late final _i1.ColumnInt learningGoalId;

  late final _i1.ColumnInt academicScheduleId;

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnString blockType;

  late final _i1.ColumnDateTime startTime;

  late final _i1.ColumnDateTime endTime;

  late final _i1.ColumnInt durationMinutes;

  late final _i1.ColumnBool isCompleted;

  late final _i1.ColumnString completionStatus;

  late final _i1.ColumnInt actualDurationMinutes;

  late final _i1.ColumnInt energyLevel;

  late final _i1.ColumnString notes;

  late final _i1.ColumnString missReason;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    dailyPlanId,
    learningGoalId,
    academicScheduleId,
    title,
    description,
    blockType,
    startTime,
    endTime,
    durationMinutes,
    isCompleted,
    completionStatus,
    actualDurationMinutes,
    energyLevel,
    notes,
    missReason,
    createdAt,
  ];
}

class TimeBlockInclude extends _i1.IncludeObject {
  TimeBlockInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TimeBlock.t;
}

class TimeBlockIncludeList extends _i1.IncludeList {
  TimeBlockIncludeList._({
    _i1.WhereExpressionBuilder<TimeBlockTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TimeBlock.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TimeBlock.t;
}

class TimeBlockRepository {
  const TimeBlockRepository._();

  /// Returns a list of [TimeBlock]s matching the given query parameters.
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
  Future<List<TimeBlock>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TimeBlockTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TimeBlockTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TimeBlockTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<TimeBlock>(
      where: where?.call(TimeBlock.t),
      orderBy: orderBy?.call(TimeBlock.t),
      orderByList: orderByList?.call(TimeBlock.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TimeBlock] matching the given query parameters.
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
  Future<TimeBlock?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TimeBlockTable>? where,
    int? offset,
    _i1.OrderByBuilder<TimeBlockTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TimeBlockTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TimeBlock>(
      where: where?.call(TimeBlock.t),
      orderBy: orderBy?.call(TimeBlock.t),
      orderByList: orderByList?.call(TimeBlock.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TimeBlock] by its [id] or null if no such row exists.
  Future<TimeBlock?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<TimeBlock>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TimeBlock]s in the list and returns the inserted rows.
  ///
  /// The returned [TimeBlock]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TimeBlock>> insert(
    _i1.Session session,
    List<TimeBlock> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TimeBlock>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TimeBlock] and returns the inserted row.
  ///
  /// The returned [TimeBlock] will have its `id` field set.
  Future<TimeBlock> insertRow(
    _i1.Session session,
    TimeBlock row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TimeBlock>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TimeBlock]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TimeBlock>> update(
    _i1.Session session,
    List<TimeBlock> rows, {
    _i1.ColumnSelections<TimeBlockTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TimeBlock>(
      rows,
      columns: columns?.call(TimeBlock.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TimeBlock]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TimeBlock> updateRow(
    _i1.Session session,
    TimeBlock row, {
    _i1.ColumnSelections<TimeBlockTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TimeBlock>(
      row,
      columns: columns?.call(TimeBlock.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TimeBlock] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TimeBlock?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TimeBlockUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TimeBlock>(
      id,
      columnValues: columnValues(TimeBlock.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TimeBlock]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TimeBlock>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TimeBlockUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TimeBlockTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TimeBlockTable>? orderBy,
    _i1.OrderByListBuilder<TimeBlockTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TimeBlock>(
      columnValues: columnValues(TimeBlock.t.updateTable),
      where: where(TimeBlock.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TimeBlock.t),
      orderByList: orderByList?.call(TimeBlock.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TimeBlock]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TimeBlock>> delete(
    _i1.Session session,
    List<TimeBlock> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TimeBlock>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TimeBlock].
  Future<TimeBlock> deleteRow(
    _i1.Session session,
    TimeBlock row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TimeBlock>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TimeBlock>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TimeBlockTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TimeBlock>(
      where: where(TimeBlock.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TimeBlockTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TimeBlock>(
      where: where?.call(TimeBlock.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
