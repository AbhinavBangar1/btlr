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

abstract class StudentProfile
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  StudentProfile._({
    this.id,
    required this.name,
    required this.email,
    String? timezone,
    required this.wakeTime,
    required this.sleepTime,
    int? preferredStudyBlockMinutes,
    int? preferredBreakMinutes,
    this.preferredStudyTimes,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.githubUsername,
    this.leetcodeUsername,
    this.codeforcesUsername,
    this.linkedinUrl,
    this.portfolioUrl,
  }) : timezone = timezone ?? 'UTC',
       preferredStudyBlockMinutes = preferredStudyBlockMinutes ?? 50,
       preferredBreakMinutes = preferredBreakMinutes ?? 10,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory StudentProfile({
    int? id,
    required String name,
    required String email,
    String? timezone,
    required String wakeTime,
    required String sleepTime,
    int? preferredStudyBlockMinutes,
    int? preferredBreakMinutes,
    String? preferredStudyTimes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? githubUsername,
    String? leetcodeUsername,
    String? codeforcesUsername,
    String? linkedinUrl,
    String? portfolioUrl,
  }) = _StudentProfileImpl;

  factory StudentProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudentProfile(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String,
      timezone: jsonSerialization['timezone'] as String?,
      wakeTime: jsonSerialization['wakeTime'] as String,
      sleepTime: jsonSerialization['sleepTime'] as String,
      preferredStudyBlockMinutes:
          jsonSerialization['preferredStudyBlockMinutes'] as int?,
      preferredBreakMinutes: jsonSerialization['preferredBreakMinutes'] as int?,
      preferredStudyTimes: jsonSerialization['preferredStudyTimes'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      githubUsername: jsonSerialization['githubUsername'] as String?,
      leetcodeUsername: jsonSerialization['leetcodeUsername'] as String?,
      codeforcesUsername: jsonSerialization['codeforcesUsername'] as String?,
      linkedinUrl: jsonSerialization['linkedinUrl'] as String?,
      portfolioUrl: jsonSerialization['portfolioUrl'] as String?,
    );
  }

  static final t = StudentProfileTable();

  static const db = StudentProfileRepository._();

  @override
  int? id;

  String name;

  String email;

  String timezone;

  String wakeTime;

  String sleepTime;

  int preferredStudyBlockMinutes;

  int preferredBreakMinutes;

  String? preferredStudyTimes;

  DateTime createdAt;

  DateTime updatedAt;

  String? githubUsername;

  String? leetcodeUsername;

  String? codeforcesUsername;

  String? linkedinUrl;

  String? portfolioUrl;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [StudentProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StudentProfile copyWith({
    int? id,
    String? name,
    String? email,
    String? timezone,
    String? wakeTime,
    String? sleepTime,
    int? preferredStudyBlockMinutes,
    int? preferredBreakMinutes,
    String? preferredStudyTimes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? githubUsername,
    String? leetcodeUsername,
    String? codeforcesUsername,
    String? linkedinUrl,
    String? portfolioUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudentProfile',
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'timezone': timezone,
      'wakeTime': wakeTime,
      'sleepTime': sleepTime,
      'preferredStudyBlockMinutes': preferredStudyBlockMinutes,
      'preferredBreakMinutes': preferredBreakMinutes,
      if (preferredStudyTimes != null)
        'preferredStudyTimes': preferredStudyTimes,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (githubUsername != null) 'githubUsername': githubUsername,
      if (leetcodeUsername != null) 'leetcodeUsername': leetcodeUsername,
      if (codeforcesUsername != null) 'codeforcesUsername': codeforcesUsername,
      if (linkedinUrl != null) 'linkedinUrl': linkedinUrl,
      if (portfolioUrl != null) 'portfolioUrl': portfolioUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudentProfile',
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'timezone': timezone,
      'wakeTime': wakeTime,
      'sleepTime': sleepTime,
      'preferredStudyBlockMinutes': preferredStudyBlockMinutes,
      'preferredBreakMinutes': preferredBreakMinutes,
      if (preferredStudyTimes != null)
        'preferredStudyTimes': preferredStudyTimes,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (githubUsername != null) 'githubUsername': githubUsername,
      if (leetcodeUsername != null) 'leetcodeUsername': leetcodeUsername,
      if (codeforcesUsername != null) 'codeforcesUsername': codeforcesUsername,
      if (linkedinUrl != null) 'linkedinUrl': linkedinUrl,
      if (portfolioUrl != null) 'portfolioUrl': portfolioUrl,
    };
  }

  static StudentProfileInclude include() {
    return StudentProfileInclude._();
  }

  static StudentProfileIncludeList includeList({
    _i1.WhereExpressionBuilder<StudentProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StudentProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentProfileTable>? orderByList,
    StudentProfileInclude? include,
  }) {
    return StudentProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StudentProfile.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(StudentProfile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentProfileImpl extends StudentProfile {
  _StudentProfileImpl({
    int? id,
    required String name,
    required String email,
    String? timezone,
    required String wakeTime,
    required String sleepTime,
    int? preferredStudyBlockMinutes,
    int? preferredBreakMinutes,
    String? preferredStudyTimes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? githubUsername,
    String? leetcodeUsername,
    String? codeforcesUsername,
    String? linkedinUrl,
    String? portfolioUrl,
  }) : super._(
         id: id,
         name: name,
         email: email,
         timezone: timezone,
         wakeTime: wakeTime,
         sleepTime: sleepTime,
         preferredStudyBlockMinutes: preferredStudyBlockMinutes,
         preferredBreakMinutes: preferredBreakMinutes,
         preferredStudyTimes: preferredStudyTimes,
         createdAt: createdAt,
         updatedAt: updatedAt,
         githubUsername: githubUsername,
         leetcodeUsername: leetcodeUsername,
         codeforcesUsername: codeforcesUsername,
         linkedinUrl: linkedinUrl,
         portfolioUrl: portfolioUrl,
       );

  /// Returns a shallow copy of this [StudentProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StudentProfile copyWith({
    Object? id = _Undefined,
    String? name,
    String? email,
    String? timezone,
    String? wakeTime,
    String? sleepTime,
    int? preferredStudyBlockMinutes,
    int? preferredBreakMinutes,
    Object? preferredStudyTimes = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? githubUsername = _Undefined,
    Object? leetcodeUsername = _Undefined,
    Object? codeforcesUsername = _Undefined,
    Object? linkedinUrl = _Undefined,
    Object? portfolioUrl = _Undefined,
  }) {
    return StudentProfile(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      timezone: timezone ?? this.timezone,
      wakeTime: wakeTime ?? this.wakeTime,
      sleepTime: sleepTime ?? this.sleepTime,
      preferredStudyBlockMinutes:
          preferredStudyBlockMinutes ?? this.preferredStudyBlockMinutes,
      preferredBreakMinutes:
          preferredBreakMinutes ?? this.preferredBreakMinutes,
      preferredStudyTimes: preferredStudyTimes is String?
          ? preferredStudyTimes
          : this.preferredStudyTimes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      githubUsername: githubUsername is String?
          ? githubUsername
          : this.githubUsername,
      leetcodeUsername: leetcodeUsername is String?
          ? leetcodeUsername
          : this.leetcodeUsername,
      codeforcesUsername: codeforcesUsername is String?
          ? codeforcesUsername
          : this.codeforcesUsername,
      linkedinUrl: linkedinUrl is String? ? linkedinUrl : this.linkedinUrl,
      portfolioUrl: portfolioUrl is String? ? portfolioUrl : this.portfolioUrl,
    );
  }
}

class StudentProfileUpdateTable extends _i1.UpdateTable<StudentProfileTable> {
  StudentProfileUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> email(String value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> timezone(String value) => _i1.ColumnValue(
    table.timezone,
    value,
  );

  _i1.ColumnValue<String, String> wakeTime(String value) => _i1.ColumnValue(
    table.wakeTime,
    value,
  );

  _i1.ColumnValue<String, String> sleepTime(String value) => _i1.ColumnValue(
    table.sleepTime,
    value,
  );

  _i1.ColumnValue<int, int> preferredStudyBlockMinutes(int value) =>
      _i1.ColumnValue(
        table.preferredStudyBlockMinutes,
        value,
      );

  _i1.ColumnValue<int, int> preferredBreakMinutes(int value) => _i1.ColumnValue(
    table.preferredBreakMinutes,
    value,
  );

  _i1.ColumnValue<String, String> preferredStudyTimes(String? value) =>
      _i1.ColumnValue(
        table.preferredStudyTimes,
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

  _i1.ColumnValue<String, String> githubUsername(String? value) =>
      _i1.ColumnValue(
        table.githubUsername,
        value,
      );

  _i1.ColumnValue<String, String> leetcodeUsername(String? value) =>
      _i1.ColumnValue(
        table.leetcodeUsername,
        value,
      );

  _i1.ColumnValue<String, String> codeforcesUsername(String? value) =>
      _i1.ColumnValue(
        table.codeforcesUsername,
        value,
      );

  _i1.ColumnValue<String, String> linkedinUrl(String? value) => _i1.ColumnValue(
    table.linkedinUrl,
    value,
  );

  _i1.ColumnValue<String, String> portfolioUrl(String? value) =>
      _i1.ColumnValue(
        table.portfolioUrl,
        value,
      );
}

class StudentProfileTable extends _i1.Table<int?> {
  StudentProfileTable({super.tableRelation})
    : super(tableName: 'student_profile') {
    updateTable = StudentProfileUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    timezone = _i1.ColumnString(
      'timezone',
      this,
      hasDefault: true,
    );
    wakeTime = _i1.ColumnString(
      'wakeTime',
      this,
    );
    sleepTime = _i1.ColumnString(
      'sleepTime',
      this,
    );
    preferredStudyBlockMinutes = _i1.ColumnInt(
      'preferredStudyBlockMinutes',
      this,
      hasDefault: true,
    );
    preferredBreakMinutes = _i1.ColumnInt(
      'preferredBreakMinutes',
      this,
      hasDefault: true,
    );
    preferredStudyTimes = _i1.ColumnString(
      'preferredStudyTimes',
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
    githubUsername = _i1.ColumnString(
      'githubUsername',
      this,
    );
    leetcodeUsername = _i1.ColumnString(
      'leetcodeUsername',
      this,
    );
    codeforcesUsername = _i1.ColumnString(
      'codeforcesUsername',
      this,
    );
    linkedinUrl = _i1.ColumnString(
      'linkedinUrl',
      this,
    );
    portfolioUrl = _i1.ColumnString(
      'portfolioUrl',
      this,
    );
  }

  late final StudentProfileUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString email;

  late final _i1.ColumnString timezone;

  late final _i1.ColumnString wakeTime;

  late final _i1.ColumnString sleepTime;

  late final _i1.ColumnInt preferredStudyBlockMinutes;

  late final _i1.ColumnInt preferredBreakMinutes;

  late final _i1.ColumnString preferredStudyTimes;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnString githubUsername;

  late final _i1.ColumnString leetcodeUsername;

  late final _i1.ColumnString codeforcesUsername;

  late final _i1.ColumnString linkedinUrl;

  late final _i1.ColumnString portfolioUrl;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    email,
    timezone,
    wakeTime,
    sleepTime,
    preferredStudyBlockMinutes,
    preferredBreakMinutes,
    preferredStudyTimes,
    createdAt,
    updatedAt,
    githubUsername,
    leetcodeUsername,
    codeforcesUsername,
    linkedinUrl,
    portfolioUrl,
  ];
}

class StudentProfileInclude extends _i1.IncludeObject {
  StudentProfileInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => StudentProfile.t;
}

class StudentProfileIncludeList extends _i1.IncludeList {
  StudentProfileIncludeList._({
    _i1.WhereExpressionBuilder<StudentProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StudentProfile.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => StudentProfile.t;
}

class StudentProfileRepository {
  const StudentProfileRepository._();

  /// Returns a list of [StudentProfile]s matching the given query parameters.
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
  Future<List<StudentProfile>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StudentProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentProfileTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<StudentProfile>(
      where: where?.call(StudentProfile.t),
      orderBy: orderBy?.call(StudentProfile.t),
      orderByList: orderByList?.call(StudentProfile.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [StudentProfile] matching the given query parameters.
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
  Future<StudentProfile?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentProfileTable>? where,
    int? offset,
    _i1.OrderByBuilder<StudentProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentProfileTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<StudentProfile>(
      where: where?.call(StudentProfile.t),
      orderBy: orderBy?.call(StudentProfile.t),
      orderByList: orderByList?.call(StudentProfile.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [StudentProfile] by its [id] or null if no such row exists.
  Future<StudentProfile?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<StudentProfile>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [StudentProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [StudentProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<StudentProfile>> insert(
    _i1.Session session,
    List<StudentProfile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<StudentProfile>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [StudentProfile] and returns the inserted row.
  ///
  /// The returned [StudentProfile] will have its `id` field set.
  Future<StudentProfile> insertRow(
    _i1.Session session,
    StudentProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<StudentProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [StudentProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<StudentProfile>> update(
    _i1.Session session,
    List<StudentProfile> rows, {
    _i1.ColumnSelections<StudentProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<StudentProfile>(
      rows,
      columns: columns?.call(StudentProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StudentProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StudentProfile> updateRow(
    _i1.Session session,
    StudentProfile row, {
    _i1.ColumnSelections<StudentProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<StudentProfile>(
      row,
      columns: columns?.call(StudentProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StudentProfile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StudentProfile?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<StudentProfileUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<StudentProfile>(
      id,
      columnValues: columnValues(StudentProfile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StudentProfile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<StudentProfile>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<StudentProfileUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<StudentProfileTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StudentProfileTable>? orderBy,
    _i1.OrderByListBuilder<StudentProfileTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<StudentProfile>(
      columnValues: columnValues(StudentProfile.t.updateTable),
      where: where(StudentProfile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StudentProfile.t),
      orderByList: orderByList?.call(StudentProfile.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [StudentProfile]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<StudentProfile>> delete(
    _i1.Session session,
    List<StudentProfile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<StudentProfile>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [StudentProfile].
  Future<StudentProfile> deleteRow(
    _i1.Session session,
    StudentProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StudentProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<StudentProfile>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<StudentProfileTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<StudentProfile>(
      where: where(StudentProfile.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentProfileTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<StudentProfile>(
      where: where?.call(StudentProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
