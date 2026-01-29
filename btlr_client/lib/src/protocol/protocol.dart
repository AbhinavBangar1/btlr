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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'academic_schedule.dart' as _i2;
import 'activity_tracker.dart' as _i3;
import 'behaviour_log.dart' as _i4;
import 'daily_plan.dart' as _i5;
import 'greetings/greeting.dart' as _i6;
import 'learning_goal.dart' as _i7;
import 'opportunity.dart' as _i8;
import 'scraped_content.dart' as _i9;
import 'student_profile.dart' as _i10;
import 'time_block.dart' as _i11;
import 'user_scraping_preference.dart' as _i12;
import 'voice_note.dart' as _i13;
import 'package:btlr_client/src/protocol/academic_schedule.dart' as _i14;
import 'package:btlr_client/src/protocol/activity_tracker.dart' as _i15;
import 'package:btlr_client/src/protocol/behaviour_log.dart' as _i16;
import 'package:btlr_client/src/protocol/learning_goal.dart' as _i17;
import 'package:btlr_client/src/protocol/opportunity.dart' as _i18;
import 'package:btlr_client/src/protocol/daily_plan.dart' as _i19;
import 'package:btlr_client/src/protocol/time_block.dart' as _i20;
import 'package:btlr_client/src/protocol/user_scraping_preference.dart' as _i21;
import 'package:btlr_client/src/protocol/scraped_content.dart' as _i22;
import 'package:btlr_client/src/protocol/student_profile.dart' as _i23;
import 'package:btlr_client/src/protocol/voice_note.dart' as _i24;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i25;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i26;
export 'academic_schedule.dart';
export 'activity_tracker.dart';
export 'behaviour_log.dart';
export 'daily_plan.dart';
export 'greetings/greeting.dart';
export 'learning_goal.dart';
export 'opportunity.dart';
export 'scraped_content.dart';
export 'student_profile.dart';
export 'time_block.dart';
export 'user_scraping_preference.dart';
export 'voice_note.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.AcademicSchedule) {
      return _i2.AcademicSchedule.fromJson(data) as T;
    }
    if (t == _i3.ActivityTracker) {
      return _i3.ActivityTracker.fromJson(data) as T;
    }
    if (t == _i4.BehaviorLog) {
      return _i4.BehaviorLog.fromJson(data) as T;
    }
    if (t == _i5.DailyPlan) {
      return _i5.DailyPlan.fromJson(data) as T;
    }
    if (t == _i6.Greeting) {
      return _i6.Greeting.fromJson(data) as T;
    }
    if (t == _i7.LearningGoal) {
      return _i7.LearningGoal.fromJson(data) as T;
    }
    if (t == _i8.Opportunity) {
      return _i8.Opportunity.fromJson(data) as T;
    }
    if (t == _i9.ScrapedContent) {
      return _i9.ScrapedContent.fromJson(data) as T;
    }
    if (t == _i10.StudentProfile) {
      return _i10.StudentProfile.fromJson(data) as T;
    }
    if (t == _i11.TimeBlock) {
      return _i11.TimeBlock.fromJson(data) as T;
    }
    if (t == _i12.UserScrapingPreference) {
      return _i12.UserScrapingPreference.fromJson(data) as T;
    }
    if (t == _i13.VoiceNote) {
      return _i13.VoiceNote.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AcademicSchedule?>()) {
      return (data != null ? _i2.AcademicSchedule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.ActivityTracker?>()) {
      return (data != null ? _i3.ActivityTracker.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.BehaviorLog?>()) {
      return (data != null ? _i4.BehaviorLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.DailyPlan?>()) {
      return (data != null ? _i5.DailyPlan.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Greeting?>()) {
      return (data != null ? _i6.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.LearningGoal?>()) {
      return (data != null ? _i7.LearningGoal.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Opportunity?>()) {
      return (data != null ? _i8.Opportunity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.ScrapedContent?>()) {
      return (data != null ? _i9.ScrapedContent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.StudentProfile?>()) {
      return (data != null ? _i10.StudentProfile.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.TimeBlock?>()) {
      return (data != null ? _i11.TimeBlock.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.UserScrapingPreference?>()) {
      return (data != null ? _i12.UserScrapingPreference.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.VoiceNote?>()) {
      return (data != null ? _i13.VoiceNote.fromJson(data) : null) as T;
    }
    if (t == List<_i14.AcademicSchedule>) {
      return (data as List)
              .map((e) => deserialize<_i14.AcademicSchedule>(e))
              .toList()
          as T;
    }
    if (t == List<_i15.ActivityTracker>) {
      return (data as List)
              .map((e) => deserialize<_i15.ActivityTracker>(e))
              .toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, dynamic>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
                )
              : null)
          as T;
    }
    if (t == List<_i16.BehaviorLog>) {
      return (data as List)
              .map((e) => deserialize<_i16.BehaviorLog>(e))
              .toList()
          as T;
    }
    if (t == List<Map<String, dynamic>>) {
      return (data as List)
              .map((e) => deserialize<Map<String, dynamic>>(e))
              .toList()
          as T;
    }
    if (t == List<_i17.LearningGoal>) {
      return (data as List)
              .map((e) => deserialize<_i17.LearningGoal>(e))
              .toList()
          as T;
    }
    if (t == List<_i18.Opportunity>) {
      return (data as List)
              .map((e) => deserialize<_i18.Opportunity>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i19.DailyPlan>) {
      return (data as List).map((e) => deserialize<_i19.DailyPlan>(e)).toList()
          as T;
    }
    if (t == List<_i20.TimeBlock>) {
      return (data as List).map((e) => deserialize<_i20.TimeBlock>(e)).toList()
          as T;
    }
    if (t == List<_i21.UserScrapingPreference>) {
      return (data as List)
              .map((e) => deserialize<_i21.UserScrapingPreference>(e))
              .toList()
          as T;
    }
    if (t == List<_i22.ScrapedContent>) {
      return (data as List)
              .map((e) => deserialize<_i22.ScrapedContent>(e))
              .toList()
          as T;
    }
    if (t == List<_i23.StudentProfile>) {
      return (data as List)
              .map((e) => deserialize<_i23.StudentProfile>(e))
              .toList()
          as T;
    }
    if (t == List<_i24.VoiceNote>) {
      return (data as List).map((e) => deserialize<_i24.VoiceNote>(e)).toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    try {
      return _i25.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i26.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AcademicSchedule => 'AcademicSchedule',
      _i3.ActivityTracker => 'ActivityTracker',
      _i4.BehaviorLog => 'BehaviorLog',
      _i5.DailyPlan => 'DailyPlan',
      _i6.Greeting => 'Greeting',
      _i7.LearningGoal => 'LearningGoal',
      _i8.Opportunity => 'Opportunity',
      _i9.ScrapedContent => 'ScrapedContent',
      _i10.StudentProfile => 'StudentProfile',
      _i11.TimeBlock => 'TimeBlock',
      _i12.UserScrapingPreference => 'UserScrapingPreference',
      _i13.VoiceNote => 'VoiceNote',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('btlr.', '');
    }

    switch (data) {
      case _i2.AcademicSchedule():
        return 'AcademicSchedule';
      case _i3.ActivityTracker():
        return 'ActivityTracker';
      case _i4.BehaviorLog():
        return 'BehaviorLog';
      case _i5.DailyPlan():
        return 'DailyPlan';
      case _i6.Greeting():
        return 'Greeting';
      case _i7.LearningGoal():
        return 'LearningGoal';
      case _i8.Opportunity():
        return 'Opportunity';
      case _i9.ScrapedContent():
        return 'ScrapedContent';
      case _i10.StudentProfile():
        return 'StudentProfile';
      case _i11.TimeBlock():
        return 'TimeBlock';
      case _i12.UserScrapingPreference():
        return 'UserScrapingPreference';
      case _i13.VoiceNote():
        return 'VoiceNote';
    }
    className = _i25.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i26.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AcademicSchedule') {
      return deserialize<_i2.AcademicSchedule>(data['data']);
    }
    if (dataClassName == 'ActivityTracker') {
      return deserialize<_i3.ActivityTracker>(data['data']);
    }
    if (dataClassName == 'BehaviorLog') {
      return deserialize<_i4.BehaviorLog>(data['data']);
    }
    if (dataClassName == 'DailyPlan') {
      return deserialize<_i5.DailyPlan>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i6.Greeting>(data['data']);
    }
    if (dataClassName == 'LearningGoal') {
      return deserialize<_i7.LearningGoal>(data['data']);
    }
    if (dataClassName == 'Opportunity') {
      return deserialize<_i8.Opportunity>(data['data']);
    }
    if (dataClassName == 'ScrapedContent') {
      return deserialize<_i9.ScrapedContent>(data['data']);
    }
    if (dataClassName == 'StudentProfile') {
      return deserialize<_i10.StudentProfile>(data['data']);
    }
    if (dataClassName == 'TimeBlock') {
      return deserialize<_i11.TimeBlock>(data['data']);
    }
    if (dataClassName == 'UserScrapingPreference') {
      return deserialize<_i12.UserScrapingPreference>(data['data']);
    }
    if (dataClassName == 'VoiceNote') {
      return deserialize<_i13.VoiceNote>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i25.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i26.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i25.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i26.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
