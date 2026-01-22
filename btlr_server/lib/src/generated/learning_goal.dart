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

abstract class LearningGoal
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  LearningGoal._({
    this.id,
    required this.studentProfileId,
    required this.title,
    this.description,
    required this.category,
    String? priority,
    String? status,
    this.estimatedHours,
    double? actualHours,
    this.deadline,
    this.tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : priority = priority ?? 'medium',
       status = status ?? 'not_started',
       actualHours = actualHours ?? 0.0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory LearningGoal({
    int? id,
    required int studentProfileId,
    required String title,
    String? description,
    required String category,
    String? priority,
    String? status,
    double? estimatedHours,
    double? actualHours,
    DateTime? deadline,
    String? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _LearningGoalImpl;

  factory LearningGoal.fromJson(Map<String, dynamic> jsonSerialization) {
    return LearningGoal(
      id: jsonSerialization['id'] as int?,
      studentProfileId: jsonSerialization['studentProfileId'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      category: jsonSerialization['category'] as String,
      priority: jsonSerialization['priority'] as String?,
      status: jsonSerialization['status'] as String?,
      estimatedHours: (jsonSerialization['estimatedHours'] as num?)?.toDouble(),
      actualHours: (jsonSerialization['actualHours'] as num?)?.toDouble(),
      deadline: jsonSerialization['deadline'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deadline']),
      tags: jsonSerialization['tags'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = LearningGoalTable();

  static const db = LearningGoalRepository._();

  @override
  int? id;

  int studentProfileId;

  String title;

  String? description;

  String category;

  String priority;

  String status;

  double? estimatedHours;

  double actualHours;

  DateTime? deadline;

  String? tags;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [LearningGoal]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LearningGoal copyWith({
    int? id,
    int? studentProfileId,
    String? title,
    String? description,
    String? category,
    String? priority,
    String? status,
    double? estimatedHours,
    double? actualHours,
    DateTime? deadline,
    String? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LearningGoal',
      if (id != null) 'id': id,
      'studentProfileId': studentProfileId,
      'title': title,
      if (description != null) 'description': description,
      'category': category,
      'priority': priority,
      'status': status,
      if (estimatedHours != null) 'estimatedHours': estimatedHours,
      'actualHours': actualHours,
      if (deadline != null) 'deadline': deadline?.toJson(),
      if (tags != null) 'tags': tags,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LearningGoal',
      if (id != null) 'id': id,
      'studentProfileId': studentProfileId,
      'title': title,
      if (description != null) 'description': description,
      'category': category,
      'priority': priority,
      'status': status,
      if (estimatedHours != null) 'estimatedHours': estimatedHours,
      'actualHours': actualHours,
      if (deadline != null) 'deadline': deadline?.toJson(),
      if (tags != null) 'tags': tags,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static LearningGoalInclude include() {
    return LearningGoalInclude._();
  }

  static LearningGoalIncludeList includeList({
    _i1.WhereExpressionBuilder<LearningGoalTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LearningGoalTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LearningGoalTable>? orderByList,
    LearningGoalInclude? include,
  }) {
    return LearningGoalIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LearningGoal.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LearningGoal.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LearningGoalImpl extends LearningGoal {
  _LearningGoalImpl({
    int? id,
    required int studentProfileId,
    required String title,
    String? description,
    required String category,
    String? priority,
    String? status,
    double? estimatedHours,
    double? actualHours,
    DateTime? deadline,
    String? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         studentProfileId: studentProfileId,
         title: title,
         description: description,
         category: category,
         priority: priority,
         status: status,
         estimatedHours: estimatedHours,
         actualHours: actualHours,
         deadline: deadline,
         tags: tags,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [LearningGoal]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LearningGoal copyWith({
    Object? id = _Undefined,
    int? studentProfileId,
    String? title,
    Object? description = _Undefined,
    String? category,
    String? priority,
    String? status,
    Object? estimatedHours = _Undefined,
    double? actualHours,
    Object? deadline = _Undefined,
    Object? tags = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LearningGoal(
      id: id is int? ? id : this.id,
      studentProfileId: studentProfileId ?? this.studentProfileId,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      estimatedHours: estimatedHours is double?
          ? estimatedHours
          : this.estimatedHours,
      actualHours: actualHours ?? this.actualHours,
      deadline: deadline is DateTime? ? deadline : this.deadline,
      tags: tags is String? ? tags : this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class LearningGoalUpdateTable extends _i1.UpdateTable<LearningGoalTable> {
  LearningGoalUpdateTable(super.table);

  _i1.ColumnValue<int, int> studentProfileId(int value) => _i1.ColumnValue(
    table.studentProfileId,
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

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<String, String> priority(String value) => _i1.ColumnValue(
    table.priority,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<double, double> estimatedHours(double? value) =>
      _i1.ColumnValue(
        table.estimatedHours,
        value,
      );

  _i1.ColumnValue<double, double> actualHours(double value) => _i1.ColumnValue(
    table.actualHours,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> deadline(DateTime? value) =>
      _i1.ColumnValue(
        table.deadline,
        value,
      );

  _i1.ColumnValue<String, String> tags(String? value) => _i1.ColumnValue(
    table.tags,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class LearningGoalTable extends _i1.Table<int?> {
  LearningGoalTable({super.tableRelation}) : super(tableName: 'learning_goal') {
    updateTable = LearningGoalUpdateTable(this);
    studentProfileId = _i1.ColumnInt(
      'studentProfileId',
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
    category = _i1.ColumnString(
      'category',
      this,
    );
    priority = _i1.ColumnString(
      'priority',
      this,
      hasDefault: true,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    estimatedHours = _i1.ColumnDouble(
      'estimatedHours',
      this,
    );
    actualHours = _i1.ColumnDouble(
      'actualHours',
      this,
      hasDefault: true,
    );
    deadline = _i1.ColumnDateTime(
      'deadline',
      this,
    );
    tags = _i1.ColumnString(
      'tags',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final LearningGoalUpdateTable updateTable;

  late final _i1.ColumnInt studentProfileId;

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnString category;

  late final _i1.ColumnString priority;

  late final _i1.ColumnString status;

  late final _i1.ColumnDouble estimatedHours;

  late final _i1.ColumnDouble actualHours;

  late final _i1.ColumnDateTime deadline;

  late final _i1.ColumnString tags;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    studentProfileId,
    title,
    description,
    category,
    priority,
    status,
    estimatedHours,
    actualHours,
    deadline,
    tags,
    createdAt,
    updatedAt,
  ];
}

class LearningGoalInclude extends _i1.IncludeObject {
  LearningGoalInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => LearningGoal.t;
}

class LearningGoalIncludeList extends _i1.IncludeList {
  LearningGoalIncludeList._({
    _i1.WhereExpressionBuilder<LearningGoalTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LearningGoal.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => LearningGoal.t;
}

class LearningGoalRepository {
  const LearningGoalRepository._();

  /// Returns a list of [LearningGoal]s matching the given query parameters.
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
  Future<List<LearningGoal>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LearningGoalTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LearningGoalTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LearningGoalTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<LearningGoal>(
      where: where?.call(LearningGoal.t),
      orderBy: orderBy?.call(LearningGoal.t),
      orderByList: orderByList?.call(LearningGoal.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [LearningGoal] matching the given query parameters.
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
  Future<LearningGoal?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LearningGoalTable>? where,
    int? offset,
    _i1.OrderByBuilder<LearningGoalTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LearningGoalTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<LearningGoal>(
      where: where?.call(LearningGoal.t),
      orderBy: orderBy?.call(LearningGoal.t),
      orderByList: orderByList?.call(LearningGoal.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [LearningGoal] by its [id] or null if no such row exists.
  Future<LearningGoal?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<LearningGoal>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [LearningGoal]s in the list and returns the inserted rows.
  ///
  /// The returned [LearningGoal]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<LearningGoal>> insert(
    _i1.Session session,
    List<LearningGoal> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<LearningGoal>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [LearningGoal] and returns the inserted row.
  ///
  /// The returned [LearningGoal] will have its `id` field set.
  Future<LearningGoal> insertRow(
    _i1.Session session,
    LearningGoal row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<LearningGoal>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [LearningGoal]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<LearningGoal>> update(
    _i1.Session session,
    List<LearningGoal> rows, {
    _i1.ColumnSelections<LearningGoalTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<LearningGoal>(
      rows,
      columns: columns?.call(LearningGoal.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LearningGoal]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LearningGoal> updateRow(
    _i1.Session session,
    LearningGoal row, {
    _i1.ColumnSelections<LearningGoalTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<LearningGoal>(
      row,
      columns: columns?.call(LearningGoal.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LearningGoal] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LearningGoal?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<LearningGoalUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<LearningGoal>(
      id,
      columnValues: columnValues(LearningGoal.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LearningGoal]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<LearningGoal>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<LearningGoalUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<LearningGoalTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LearningGoalTable>? orderBy,
    _i1.OrderByListBuilder<LearningGoalTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<LearningGoal>(
      columnValues: columnValues(LearningGoal.t.updateTable),
      where: where(LearningGoal.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LearningGoal.t),
      orderByList: orderByList?.call(LearningGoal.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [LearningGoal]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<LearningGoal>> delete(
    _i1.Session session,
    List<LearningGoal> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LearningGoal>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [LearningGoal].
  Future<LearningGoal> deleteRow(
    _i1.Session session,
    LearningGoal row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LearningGoal>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<LearningGoal>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LearningGoalTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<LearningGoal>(
      where: where(LearningGoal.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LearningGoalTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LearningGoal>(
      where: where?.call(LearningGoal.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
