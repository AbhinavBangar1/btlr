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

abstract class Opportunity
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Opportunity._({
    this.id,
    this.studentProfileId,
    required this.title,
    required this.type,
    this.description,
    this.organization,
    this.sourceUrl,
    this.deadline,
    this.tags,
    double? relevanceScore,
    String? status,
    this.prepTimeMinutes,
    this.appliedAt,
    DateTime? discoveredAt,
  }) : relevanceScore = relevanceScore ?? 0.0,
       status = status ?? 'discovered',
       discoveredAt = discoveredAt ?? DateTime.now();

  factory Opportunity({
    int? id,
    int? studentProfileId,
    required String title,
    required String type,
    String? description,
    String? organization,
    String? sourceUrl,
    DateTime? deadline,
    String? tags,
    double? relevanceScore,
    String? status,
    int? prepTimeMinutes,
    DateTime? appliedAt,
    DateTime? discoveredAt,
  }) = _OpportunityImpl;

  factory Opportunity.fromJson(Map<String, dynamic> jsonSerialization) {
    return Opportunity(
      id: jsonSerialization['id'] as int?,
      studentProfileId: jsonSerialization['studentProfileId'] as int?,
      title: jsonSerialization['title'] as String,
      type: jsonSerialization['type'] as String,
      description: jsonSerialization['description'] as String?,
      organization: jsonSerialization['organization'] as String?,
      sourceUrl: jsonSerialization['sourceUrl'] as String?,
      deadline: jsonSerialization['deadline'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deadline']),
      tags: jsonSerialization['tags'] as String?,
      relevanceScore: (jsonSerialization['relevanceScore'] as num?)?.toDouble(),
      status: jsonSerialization['status'] as String?,
      prepTimeMinutes: jsonSerialization['prepTimeMinutes'] as int?,
      appliedAt: jsonSerialization['appliedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['appliedAt']),
      discoveredAt: jsonSerialization['discoveredAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['discoveredAt'],
            ),
    );
  }

  static final t = OpportunityTable();

  static const db = OpportunityRepository._();

  @override
  int? id;

  int? studentProfileId;

  String title;

  String type;

  String? description;

  String? organization;

  String? sourceUrl;

  DateTime? deadline;

  String? tags;

  double relevanceScore;

  String status;

  int? prepTimeMinutes;

  DateTime? appliedAt;

  DateTime discoveredAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Opportunity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Opportunity copyWith({
    int? id,
    int? studentProfileId,
    String? title,
    String? type,
    String? description,
    String? organization,
    String? sourceUrl,
    DateTime? deadline,
    String? tags,
    double? relevanceScore,
    String? status,
    int? prepTimeMinutes,
    DateTime? appliedAt,
    DateTime? discoveredAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Opportunity',
      if (id != null) 'id': id,
      if (studentProfileId != null) 'studentProfileId': studentProfileId,
      'title': title,
      'type': type,
      if (description != null) 'description': description,
      if (organization != null) 'organization': organization,
      if (sourceUrl != null) 'sourceUrl': sourceUrl,
      if (deadline != null) 'deadline': deadline?.toJson(),
      if (tags != null) 'tags': tags,
      'relevanceScore': relevanceScore,
      'status': status,
      if (prepTimeMinutes != null) 'prepTimeMinutes': prepTimeMinutes,
      if (appliedAt != null) 'appliedAt': appliedAt?.toJson(),
      'discoveredAt': discoveredAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Opportunity',
      if (id != null) 'id': id,
      if (studentProfileId != null) 'studentProfileId': studentProfileId,
      'title': title,
      'type': type,
      if (description != null) 'description': description,
      if (organization != null) 'organization': organization,
      if (sourceUrl != null) 'sourceUrl': sourceUrl,
      if (deadline != null) 'deadline': deadline?.toJson(),
      if (tags != null) 'tags': tags,
      'relevanceScore': relevanceScore,
      'status': status,
      if (prepTimeMinutes != null) 'prepTimeMinutes': prepTimeMinutes,
      if (appliedAt != null) 'appliedAt': appliedAt?.toJson(),
      'discoveredAt': discoveredAt.toJson(),
    };
  }

  static OpportunityInclude include() {
    return OpportunityInclude._();
  }

  static OpportunityIncludeList includeList({
    _i1.WhereExpressionBuilder<OpportunityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OpportunityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OpportunityTable>? orderByList,
    OpportunityInclude? include,
  }) {
    return OpportunityIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Opportunity.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Opportunity.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OpportunityImpl extends Opportunity {
  _OpportunityImpl({
    int? id,
    int? studentProfileId,
    required String title,
    required String type,
    String? description,
    String? organization,
    String? sourceUrl,
    DateTime? deadline,
    String? tags,
    double? relevanceScore,
    String? status,
    int? prepTimeMinutes,
    DateTime? appliedAt,
    DateTime? discoveredAt,
  }) : super._(
         id: id,
         studentProfileId: studentProfileId,
         title: title,
         type: type,
         description: description,
         organization: organization,
         sourceUrl: sourceUrl,
         deadline: deadline,
         tags: tags,
         relevanceScore: relevanceScore,
         status: status,
         prepTimeMinutes: prepTimeMinutes,
         appliedAt: appliedAt,
         discoveredAt: discoveredAt,
       );

  /// Returns a shallow copy of this [Opportunity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Opportunity copyWith({
    Object? id = _Undefined,
    Object? studentProfileId = _Undefined,
    String? title,
    String? type,
    Object? description = _Undefined,
    Object? organization = _Undefined,
    Object? sourceUrl = _Undefined,
    Object? deadline = _Undefined,
    Object? tags = _Undefined,
    double? relevanceScore,
    String? status,
    Object? prepTimeMinutes = _Undefined,
    Object? appliedAt = _Undefined,
    DateTime? discoveredAt,
  }) {
    return Opportunity(
      id: id is int? ? id : this.id,
      studentProfileId: studentProfileId is int?
          ? studentProfileId
          : this.studentProfileId,
      title: title ?? this.title,
      type: type ?? this.type,
      description: description is String? ? description : this.description,
      organization: organization is String? ? organization : this.organization,
      sourceUrl: sourceUrl is String? ? sourceUrl : this.sourceUrl,
      deadline: deadline is DateTime? ? deadline : this.deadline,
      tags: tags is String? ? tags : this.tags,
      relevanceScore: relevanceScore ?? this.relevanceScore,
      status: status ?? this.status,
      prepTimeMinutes: prepTimeMinutes is int?
          ? prepTimeMinutes
          : this.prepTimeMinutes,
      appliedAt: appliedAt is DateTime? ? appliedAt : this.appliedAt,
      discoveredAt: discoveredAt ?? this.discoveredAt,
    );
  }
}

class OpportunityUpdateTable extends _i1.UpdateTable<OpportunityTable> {
  OpportunityUpdateTable(super.table);

  _i1.ColumnValue<int, int> studentProfileId(int? value) => _i1.ColumnValue(
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

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> organization(String? value) =>
      _i1.ColumnValue(
        table.organization,
        value,
      );

  _i1.ColumnValue<String, String> sourceUrl(String? value) => _i1.ColumnValue(
    table.sourceUrl,
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

  _i1.ColumnValue<double, double> relevanceScore(double value) =>
      _i1.ColumnValue(
        table.relevanceScore,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<int, int> prepTimeMinutes(int? value) => _i1.ColumnValue(
    table.prepTimeMinutes,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> appliedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.appliedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> discoveredAt(DateTime value) =>
      _i1.ColumnValue(
        table.discoveredAt,
        value,
      );
}

class OpportunityTable extends _i1.Table<int?> {
  OpportunityTable({super.tableRelation}) : super(tableName: 'opportunity') {
    updateTable = OpportunityUpdateTable(this);
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
    description = _i1.ColumnString(
      'description',
      this,
    );
    organization = _i1.ColumnString(
      'organization',
      this,
    );
    sourceUrl = _i1.ColumnString(
      'sourceUrl',
      this,
    );
    deadline = _i1.ColumnDateTime(
      'deadline',
      this,
    );
    tags = _i1.ColumnString(
      'tags',
      this,
    );
    relevanceScore = _i1.ColumnDouble(
      'relevanceScore',
      this,
      hasDefault: true,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    prepTimeMinutes = _i1.ColumnInt(
      'prepTimeMinutes',
      this,
    );
    appliedAt = _i1.ColumnDateTime(
      'appliedAt',
      this,
    );
    discoveredAt = _i1.ColumnDateTime(
      'discoveredAt',
      this,
      hasDefault: true,
    );
  }

  late final OpportunityUpdateTable updateTable;

  late final _i1.ColumnInt studentProfileId;

  late final _i1.ColumnString title;

  late final _i1.ColumnString type;

  late final _i1.ColumnString description;

  late final _i1.ColumnString organization;

  late final _i1.ColumnString sourceUrl;

  late final _i1.ColumnDateTime deadline;

  late final _i1.ColumnString tags;

  late final _i1.ColumnDouble relevanceScore;

  late final _i1.ColumnString status;

  late final _i1.ColumnInt prepTimeMinutes;

  late final _i1.ColumnDateTime appliedAt;

  late final _i1.ColumnDateTime discoveredAt;

  @override
  List<_i1.Column> get columns => [
    id,
    studentProfileId,
    title,
    type,
    description,
    organization,
    sourceUrl,
    deadline,
    tags,
    relevanceScore,
    status,
    prepTimeMinutes,
    appliedAt,
    discoveredAt,
  ];
}

class OpportunityInclude extends _i1.IncludeObject {
  OpportunityInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Opportunity.t;
}

class OpportunityIncludeList extends _i1.IncludeList {
  OpportunityIncludeList._({
    _i1.WhereExpressionBuilder<OpportunityTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Opportunity.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Opportunity.t;
}

class OpportunityRepository {
  const OpportunityRepository._();

  /// Returns a list of [Opportunity]s matching the given query parameters.
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
  Future<List<Opportunity>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OpportunityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OpportunityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OpportunityTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Opportunity>(
      where: where?.call(Opportunity.t),
      orderBy: orderBy?.call(Opportunity.t),
      orderByList: orderByList?.call(Opportunity.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Opportunity] matching the given query parameters.
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
  Future<Opportunity?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OpportunityTable>? where,
    int? offset,
    _i1.OrderByBuilder<OpportunityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OpportunityTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Opportunity>(
      where: where?.call(Opportunity.t),
      orderBy: orderBy?.call(Opportunity.t),
      orderByList: orderByList?.call(Opportunity.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Opportunity] by its [id] or null if no such row exists.
  Future<Opportunity?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Opportunity>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Opportunity]s in the list and returns the inserted rows.
  ///
  /// The returned [Opportunity]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Opportunity>> insert(
    _i1.Session session,
    List<Opportunity> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Opportunity>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Opportunity] and returns the inserted row.
  ///
  /// The returned [Opportunity] will have its `id` field set.
  Future<Opportunity> insertRow(
    _i1.Session session,
    Opportunity row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Opportunity>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Opportunity]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Opportunity>> update(
    _i1.Session session,
    List<Opportunity> rows, {
    _i1.ColumnSelections<OpportunityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Opportunity>(
      rows,
      columns: columns?.call(Opportunity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Opportunity]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Opportunity> updateRow(
    _i1.Session session,
    Opportunity row, {
    _i1.ColumnSelections<OpportunityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Opportunity>(
      row,
      columns: columns?.call(Opportunity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Opportunity] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Opportunity?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<OpportunityUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Opportunity>(
      id,
      columnValues: columnValues(Opportunity.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Opportunity]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Opportunity>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<OpportunityUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<OpportunityTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OpportunityTable>? orderBy,
    _i1.OrderByListBuilder<OpportunityTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Opportunity>(
      columnValues: columnValues(Opportunity.t.updateTable),
      where: where(Opportunity.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Opportunity.t),
      orderByList: orderByList?.call(Opportunity.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Opportunity]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Opportunity>> delete(
    _i1.Session session,
    List<Opportunity> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Opportunity>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Opportunity].
  Future<Opportunity> deleteRow(
    _i1.Session session,
    Opportunity row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Opportunity>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Opportunity>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<OpportunityTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Opportunity>(
      where: where(Opportunity.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OpportunityTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Opportunity>(
      where: where?.call(Opportunity.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
