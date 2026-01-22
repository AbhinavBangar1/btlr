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
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/jwt_refresh_endpoint.dart' as _i3;
import '../endpoints/academic_endpoint.dart' as _i4;
import '../endpoints/behavior_endpoint.dart' as _i5;
import '../endpoints/goal_endpoint.dart' as _i6;
import '../endpoints/opportunity_endpoint.dart' as _i7;
import '../endpoints/plan_endpoint.dart' as _i8;
import '../endpoints/student_endpoint.dart' as _i9;
import '../endpoints/voice_endpoint.dart' as _i10;
import '../greetings/greeting_endpoint.dart' as _i11;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i12;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i13;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i3.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'academic': _i4.AcademicEndpoint()
        ..initialize(
          server,
          'academic',
          null,
        ),
      'behavior': _i5.BehaviorEndpoint()
        ..initialize(
          server,
          'behavior',
          null,
        ),
      'goal': _i6.GoalEndpoint()
        ..initialize(
          server,
          'goal',
          null,
        ),
      'opportunity': _i7.OpportunityEndpoint()
        ..initialize(
          server,
          'opportunity',
          null,
        ),
      'plan': _i8.PlanEndpoint()
        ..initialize(
          server,
          'plan',
          null,
        ),
      'student': _i9.StudentEndpoint()
        ..initialize(
          server,
          'student',
          null,
        ),
      'voice': _i10.VoiceEndpoint()
        ..initialize(
          server,
          'voice',
          null,
        ),
      'greeting': _i11.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i3.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['academic'] = _i1.EndpointConnector(
      name: 'academic',
      endpoint: endpoints['academic']!,
      methodConnectors: {
        'createSchedule': _i1.MethodConnector(
          name: 'createSchedule',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'startTime': _i1.ParameterDescription(
              name: 'startTime',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'endTime': _i1.ParameterDescription(
              name: 'endTime',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'location': _i1.ParameterDescription(
              name: 'location',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'isRecurring': _i1.ParameterDescription(
              name: 'isRecurring',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'rrule': _i1.ParameterDescription(
              name: 'rrule',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['academic'] as _i4.AcademicEndpoint)
                  .createSchedule(
                    session,
                    params['studentProfileId'],
                    params['title'],
                    params['type'],
                    params['startTime'],
                    params['endTime'],
                    params['location'],
                    params['isRecurring'],
                    params['rrule'],
                  ),
        ),
        'getSchedule': _i1.MethodConnector(
          name: 'getSchedule',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['academic'] as _i4.AcademicEndpoint).getSchedule(
                    session,
                    params['id'],
                  ),
        ),
        'getStudentSchedules': _i1.MethodConnector(
          name: 'getStudentSchedules',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'includeDeleted': _i1.ParameterDescription(
              name: 'includeDeleted',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['academic'] as _i4.AcademicEndpoint)
                  .getStudentSchedules(
                    session,
                    params['studentProfileId'],
                    includeDeleted: params['includeDeleted'],
                  ),
        ),
        'getSchedulesInRange': _i1.MethodConnector(
          name: 'getSchedulesInRange',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['academic'] as _i4.AcademicEndpoint)
                  .getSchedulesInRange(
                    session,
                    params['studentProfileId'],
                    params['startDate'],
                    params['endDate'],
                  ),
        ),
        'updateSchedule': _i1.MethodConnector(
          name: 'updateSchedule',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'startTime': _i1.ParameterDescription(
              name: 'startTime',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'endTime': _i1.ParameterDescription(
              name: 'endTime',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'location': _i1.ParameterDescription(
              name: 'location',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'isRecurring': _i1.ParameterDescription(
              name: 'isRecurring',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'rrule': _i1.ParameterDescription(
              name: 'rrule',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['academic'] as _i4.AcademicEndpoint)
                  .updateSchedule(
                    session,
                    params['id'],
                    params['title'],
                    params['type'],
                    params['startTime'],
                    params['endTime'],
                    params['location'],
                    params['isRecurring'],
                    params['rrule'],
                  ),
        ),
        'deleteSchedule': _i1.MethodConnector(
          name: 'deleteSchedule',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['academic'] as _i4.AcademicEndpoint)
                  .deleteSchedule(
                    session,
                    params['id'],
                  ),
        ),
        'checkConflicts': _i1.MethodConnector(
          name: 'checkConflicts',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'startTime': _i1.ParameterDescription(
              name: 'startTime',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'endTime': _i1.ParameterDescription(
              name: 'endTime',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'excludeId': _i1.ParameterDescription(
              name: 'excludeId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['academic'] as _i4.AcademicEndpoint)
                  .checkConflicts(
                    session,
                    params['studentProfileId'],
                    params['startTime'],
                    params['endTime'],
                    params['excludeId'],
                  ),
        ),
        'getSchedulesByType': _i1.MethodConnector(
          name: 'getSchedulesByType',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['academic'] as _i4.AcademicEndpoint)
                  .getSchedulesByType(
                    session,
                    params['studentProfileId'],
                    params['type'],
                  ),
        ),
        'restoreSchedule': _i1.MethodConnector(
          name: 'restoreSchedule',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['academic'] as _i4.AcademicEndpoint)
                  .restoreSchedule(
                    session,
                    params['id'],
                  ),
        ),
        'getUpcomingClasses': _i1.MethodConnector(
          name: 'getUpcomingClasses',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['academic'] as _i4.AcademicEndpoint)
                  .getUpcomingClasses(
                    session,
                    params['studentProfileId'],
                  ),
        ),
        'getTodaysSchedule': _i1.MethodConnector(
          name: 'getTodaysSchedule',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['academic'] as _i4.AcademicEndpoint)
                  .getTodaysSchedule(
                    session,
                    params['studentProfileId'],
                  ),
        ),
      },
    );
    connectors['behavior'] = _i1.EndpointConnector(
      name: 'behavior',
      endpoint: endpoints['behavior']!,
      methodConnectors: {
        'logCompletion': _i1.MethodConnector(
          name: 'logCompletion',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'timeBlockId': _i1.ParameterDescription(
              name: 'timeBlockId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'actualDuration': _i1.ParameterDescription(
              name: 'actualDuration',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'energyLevel': _i1.ParameterDescription(
              name: 'energyLevel',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['behavior'] as _i5.BehaviorEndpoint).logCompletion(
                    session,
                    params['studentProfileId'],
                    params['timeBlockId'],
                    params['actualDuration'],
                    params['energyLevel'],
                    params['notes'],
                  ),
        ),
        'logMiss': _i1.MethodConnector(
          name: 'logMiss',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'timeBlockId': _i1.ParameterDescription(
              name: 'timeBlockId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'reason': _i1.ParameterDescription(
              name: 'reason',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['behavior'] as _i5.BehaviorEndpoint).logMiss(
                    session,
                    params['studentProfileId'],
                    params['timeBlockId'],
                    params['reason'],
                    params['notes'],
                  ),
        ),
        'logPostpone': _i1.MethodConnector(
          name: 'logPostpone',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'timeBlockId': _i1.ParameterDescription(
              name: 'timeBlockId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'reason': _i1.ParameterDescription(
              name: 'reason',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['behavior'] as _i5.BehaviorEndpoint).logPostpone(
                    session,
                    params['studentProfileId'],
                    params['timeBlockId'],
                    params['reason'],
                    params['notes'],
                  ),
        ),
        'logStart': _i1.MethodConnector(
          name: 'logStart',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'timeBlockId': _i1.ParameterDescription(
              name: 'timeBlockId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['behavior'] as _i5.BehaviorEndpoint).logStart(
                    session,
                    params['studentProfileId'],
                    params['timeBlockId'],
                    params['notes'],
                  ),
        ),
        'getLog': _i1.MethodConnector(
          name: 'getLog',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['behavior'] as _i5.BehaviorEndpoint).getLog(
                session,
                params['id'],
              ),
        ),
        'getBlockLogs': _i1.MethodConnector(
          name: 'getBlockLogs',
          params: {
            'timeBlockId': _i1.ParameterDescription(
              name: 'timeBlockId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['behavior'] as _i5.BehaviorEndpoint).getBlockLogs(
                    session,
                    params['timeBlockId'],
                  ),
        ),
        'getStudentLogs': _i1.MethodConnector(
          name: 'getStudentLogs',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['behavior'] as _i5.BehaviorEndpoint)
                  .getStudentLogs(
                    session,
                    params['studentProfileId'],
                    limit: params['limit'],
                  ),
        ),
        'getLogsInRange': _i1.MethodConnector(
          name: 'getLogsInRange',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['behavior'] as _i5.BehaviorEndpoint)
                  .getLogsInRange(
                    session,
                    params['studentProfileId'],
                    params['startDate'],
                    params['endDate'],
                  ),
        ),
        'getLogsByAction': _i1.MethodConnector(
          name: 'getLogsByAction',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'action': _i1.ParameterDescription(
              name: 'action',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['behavior'] as _i5.BehaviorEndpoint)
                  .getLogsByAction(
                    session,
                    params['studentProfileId'],
                    params['action'],
                  ),
        ),
        'getCompletionStats': _i1.MethodConnector(
          name: 'getCompletionStats',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'days': _i1.ParameterDescription(
              name: 'days',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['behavior'] as _i5.BehaviorEndpoint)
                  .getCompletionStats(
                    session,
                    params['studentProfileId'],
                    days: params['days'],
                  ),
        ),
        'getDailyCompletionRates': _i1.MethodConnector(
          name: 'getDailyCompletionRates',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'days': _i1.ParameterDescription(
              name: 'days',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['behavior'] as _i5.BehaviorEndpoint)
                  .getDailyCompletionRates(
                    session,
                    params['studentProfileId'],
                    params['days'],
                  ),
        ),
        'analyzeRecentBehavior': _i1.MethodConnector(
          name: 'analyzeRecentBehavior',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'days': _i1.ParameterDescription(
              name: 'days',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['behavior'] as _i5.BehaviorEndpoint)
                  .analyzeRecentBehavior(
                    session,
                    params['studentProfileId'],
                    days: params['days'],
                  ),
        ),
        'getOptimalBlockLength': _i1.MethodConnector(
          name: 'getOptimalBlockLength',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['behavior'] as _i5.BehaviorEndpoint)
                  .getOptimalBlockLength(
                    session,
                    params['studentProfileId'],
                  ),
        ),
        'getMissReasonsBreakdown': _i1.MethodConnector(
          name: 'getMissReasonsBreakdown',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'days': _i1.ParameterDescription(
              name: 'days',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['behavior'] as _i5.BehaviorEndpoint)
                  .getMissReasonsBreakdown(
                    session,
                    params['studentProfileId'],
                    params['days'],
                  ),
        ),
        'getTimeOfDayPerformance': _i1.MethodConnector(
          name: 'getTimeOfDayPerformance',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'days': _i1.ParameterDescription(
              name: 'days',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['behavior'] as _i5.BehaviorEndpoint)
                  .getTimeOfDayPerformance(
                    session,
                    params['studentProfileId'],
                    params['days'],
                  ),
        ),
        'getStreakInfo': _i1.MethodConnector(
          name: 'getStreakInfo',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['behavior'] as _i5.BehaviorEndpoint).getStreakInfo(
                    session,
                    params['studentProfileId'],
                  ),
        ),
        'getEnergyTrends': _i1.MethodConnector(
          name: 'getEnergyTrends',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'days': _i1.ParameterDescription(
              name: 'days',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['behavior'] as _i5.BehaviorEndpoint)
                  .getEnergyTrends(
                    session,
                    params['studentProfileId'],
                    params['days'],
                  ),
        ),
        'updateLog': _i1.MethodConnector(
          name: 'updateLog',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'action': _i1.ParameterDescription(
              name: 'action',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'actualDuration': _i1.ParameterDescription(
              name: 'actualDuration',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'energyLevel': _i1.ParameterDescription(
              name: 'energyLevel',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'reason': _i1.ParameterDescription(
              name: 'reason',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'context': _i1.ParameterDescription(
              name: 'context',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['behavior'] as _i5.BehaviorEndpoint).updateLog(
                    session,
                    params['id'],
                    params['action'],
                    params['actualDuration'],
                    params['energyLevel'],
                    params['reason'],
                    params['notes'],
                    params['context'],
                  ),
        ),
        'deleteLog': _i1.MethodConnector(
          name: 'deleteLog',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['behavior'] as _i5.BehaviorEndpoint).deleteLog(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['goal'] = _i1.EndpointConnector(
      name: 'goal',
      endpoint: endpoints['goal']!,
      methodConnectors: {
        'createGoal': _i1.MethodConnector(
          name: 'createGoal',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'priority': _i1.ParameterDescription(
              name: 'priority',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'estimatedHours': _i1.ParameterDescription(
              name: 'estimatedHours',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'deadline': _i1.ParameterDescription(
              name: 'deadline',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'tags': _i1.ParameterDescription(
              name: 'tags',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['goal'] as _i6.GoalEndpoint).createGoal(
                session,
                params['studentProfileId'],
                params['title'],
                params['category'],
                params['priority'],
                params['description'],
                params['estimatedHours'],
                params['deadline'],
                params['tags'],
              ),
        ),
        'getGoal': _i1.MethodConnector(
          name: 'getGoal',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['goal'] as _i6.GoalEndpoint).getGoal(
                session,
                params['id'],
              ),
        ),
        'getStudentGoals': _i1.MethodConnector(
          name: 'getStudentGoals',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'priority': _i1.ParameterDescription(
              name: 'priority',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['goal'] as _i6.GoalEndpoint).getStudentGoals(
                    session,
                    params['studentProfileId'],
                    status: params['status'],
                    priority: params['priority'],
                    category: params['category'],
                  ),
        ),
        'getActiveGoals': _i1.MethodConnector(
          name: 'getActiveGoals',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['goal'] as _i6.GoalEndpoint).getActiveGoals(
                session,
                params['studentProfileId'],
              ),
        ),
        'getGoalsByCategory': _i1.MethodConnector(
          name: 'getGoalsByCategory',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['goal'] as _i6.GoalEndpoint).getGoalsByCategory(
                    session,
                    params['studentProfileId'],
                    params['category'],
                  ),
        ),
        'updateGoal': _i1.MethodConnector(
          name: 'updateGoal',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'priority': _i1.ParameterDescription(
              name: 'priority',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'estimatedHours': _i1.ParameterDescription(
              name: 'estimatedHours',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'actualHours': _i1.ParameterDescription(
              name: 'actualHours',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'deadline': _i1.ParameterDescription(
              name: 'deadline',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'tags': _i1.ParameterDescription(
              name: 'tags',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['goal'] as _i6.GoalEndpoint).updateGoal(
                session,
                params['id'],
                params['title'],
                params['description'],
                params['category'],
                params['status'],
                params['priority'],
                params['estimatedHours'],
                params['actualHours'],
                params['deadline'],
                params['tags'],
              ),
        ),
        'completeGoal': _i1.MethodConnector(
          name: 'completeGoal',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['goal'] as _i6.GoalEndpoint).completeGoal(
                session,
                params['id'],
              ),
        ),
        'addHours': _i1.MethodConnector(
          name: 'addHours',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'hours': _i1.ParameterDescription(
              name: 'hours',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['goal'] as _i6.GoalEndpoint).addHours(
                session,
                params['id'],
                params['hours'],
              ),
        ),
        'deleteGoal': _i1.MethodConnector(
          name: 'deleteGoal',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['goal'] as _i6.GoalEndpoint).deleteGoal(
                session,
                params['id'],
              ),
        ),
        'getOverdueGoals': _i1.MethodConnector(
          name: 'getOverdueGoals',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['goal'] as _i6.GoalEndpoint).getOverdueGoals(
                    session,
                    params['studentProfileId'],
                  ),
        ),
        'getGoalStats': _i1.MethodConnector(
          name: 'getGoalStats',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['goal'] as _i6.GoalEndpoint).getGoalStats(
                session,
                params['studentProfileId'],
              ),
        ),
        'getGoalsByPriority': _i1.MethodConnector(
          name: 'getGoalsByPriority',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'priority': _i1.ParameterDescription(
              name: 'priority',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['goal'] as _i6.GoalEndpoint).getGoalsByPriority(
                    session,
                    params['studentProfileId'],
                    params['priority'],
                  ),
        ),
      },
    );
    connectors['opportunity'] = _i1.EndpointConnector(
      name: 'opportunity',
      endpoint: endpoints['opportunity']!,
      methodConnectors: {
        'createOpportunity': _i1.MethodConnector(
          name: 'createOpportunity',
          params: {
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'organization': _i1.ParameterDescription(
              name: 'organization',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'sourceUrl': _i1.ParameterDescription(
              name: 'sourceUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'deadline': _i1.ParameterDescription(
              name: 'deadline',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'tags': _i1.ParameterDescription(
              name: 'tags',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'prepTimeMinutes': _i1.ParameterDescription(
              name: 'prepTimeMinutes',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .createOpportunity(
                    session,
                    params['title'],
                    params['type'],
                    params['studentProfileId'],
                    params['description'],
                    params['organization'],
                    params['sourceUrl'],
                    params['deadline'],
                    params['tags'],
                    params['prepTimeMinutes'],
                  ),
        ),
        'getOpportunity': _i1.MethodConnector(
          name: 'getOpportunity',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .getOpportunity(
                    session,
                    params['id'],
                  ),
        ),
        'getStudentOpportunities': _i1.MethodConnector(
          name: 'getStudentOpportunities',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .getStudentOpportunities(
                    session,
                    params['studentProfileId'],
                    status: params['status'],
                    type: params['type'],
                  ),
        ),
        'getUnassignedOpportunities': _i1.MethodConnector(
          name: 'getUnassignedOpportunities',
          params: {
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .getUnassignedOpportunities(
                    session,
                    type: params['type'],
                  ),
        ),
        'getRelevantOpportunities': _i1.MethodConnector(
          name: 'getRelevantOpportunities',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'minScore': _i1.ParameterDescription(
              name: 'minScore',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .getRelevantOpportunities(
                    session,
                    params['studentProfileId'],
                    minScore: params['minScore'],
                  ),
        ),
        'getOpportunitiesByType': _i1.MethodConnector(
          name: 'getOpportunitiesByType',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .getOpportunitiesByType(
                    session,
                    params['studentProfileId'],
                    params['type'],
                  ),
        ),
        'getUpcomingDeadlines': _i1.MethodConnector(
          name: 'getUpcomingDeadlines',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'daysAhead': _i1.ParameterDescription(
              name: 'daysAhead',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .getUpcomingDeadlines(
                    session,
                    params['studentProfileId'],
                    daysAhead: params['daysAhead'],
                  ),
        ),
        'calculateRelevance': _i1.MethodConnector(
          name: 'calculateRelevance',
          params: {
            'opportunityId': _i1.ParameterDescription(
              name: 'opportunityId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .calculateRelevance(
                    session,
                    params['opportunityId'],
                  ),
        ),
        'recalculateAllRelevance': _i1.MethodConnector(
          name: 'recalculateAllRelevance',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .recalculateAllRelevance(
                    session,
                    params['studentProfileId'],
                  ),
        ),
        'getInjectableOpportunities': _i1.MethodConnector(
          name: 'getInjectableOpportunities',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'targetDate': _i1.ParameterDescription(
              name: 'targetDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .getInjectableOpportunities(
                    session,
                    params['studentProfileId'],
                    params['targetDate'],
                  ),
        ),
        'updateStatus': _i1.MethodConnector(
          name: 'updateStatus',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .updateStatus(
                    session,
                    params['id'],
                    params['status'],
                  ),
        ),
        'assignToStudent': _i1.MethodConnector(
          name: 'assignToStudent',
          params: {
            'opportunityId': _i1.ParameterDescription(
              name: 'opportunityId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .assignToStudent(
                    session,
                    params['opportunityId'],
                    params['studentProfileId'],
                  ),
        ),
        'updateOpportunity': _i1.MethodConnector(
          name: 'updateOpportunity',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'organization': _i1.ParameterDescription(
              name: 'organization',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'sourceUrl': _i1.ParameterDescription(
              name: 'sourceUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'deadline': _i1.ParameterDescription(
              name: 'deadline',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'tags': _i1.ParameterDescription(
              name: 'tags',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'prepTimeMinutes': _i1.ParameterDescription(
              name: 'prepTimeMinutes',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'relevanceScore': _i1.ParameterDescription(
              name: 'relevanceScore',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .updateOpportunity(
                    session,
                    params['id'],
                    params['title'],
                    params['type'],
                    params['description'],
                    params['organization'],
                    params['sourceUrl'],
                    params['deadline'],
                    params['tags'],
                    params['status'],
                    params['prepTimeMinutes'],
                    params['relevanceScore'],
                  ),
        ),
        'deleteOpportunity': _i1.MethodConnector(
          name: 'deleteOpportunity',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .deleteOpportunity(
                    session,
                    params['id'],
                  ),
        ),
        'searchByTags': _i1.MethodConnector(
          name: 'searchByTags',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'searchTags': _i1.ParameterDescription(
              name: 'searchTags',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .searchByTags(
                    session,
                    params['studentProfileId'],
                    params['searchTags'],
                  ),
        ),
        'getOpportunitiesByStatus': _i1.MethodConnector(
          name: 'getOpportunitiesByStatus',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .getOpportunitiesByStatus(
                    session,
                    params['studentProfileId'],
                    params['status'],
                  ),
        ),
        'getOpportunityStats': _i1.MethodConnector(
          name: 'getOpportunityStats',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .getOpportunityStats(
                    session,
                    params['studentProfileId'],
                  ),
        ),
        'bulkImport': _i1.MethodConnector(
          name: 'bulkImport',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'opportunitiesData': _i1.ParameterDescription(
              name: 'opportunitiesData',
              type: _i1.getType<List<Map<String, dynamic>>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['opportunity'] as _i7.OpportunityEndpoint)
                  .bulkImport(
                    session,
                    params['studentProfileId'],
                    params['opportunitiesData'],
                  ),
        ),
      },
    );
    connectors['plan'] = _i1.EndpointConnector(
      name: 'plan',
      endpoint: endpoints['plan']!,
      methodConnectors: {
        'generatePlan': _i1.MethodConnector(
          name: 'generatePlan',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['plan'] as _i8.PlanEndpoint).generatePlan(
                session,
                params['studentProfileId'],
                params['date'],
              ),
        ),
        'generateMultiplePlans': _i1.MethodConnector(
          name: 'generateMultiplePlans',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'daysAhead': _i1.ParameterDescription(
              name: 'daysAhead',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['plan'] as _i8.PlanEndpoint).generateMultiplePlans(
                    session,
                    params['studentProfileId'],
                    params['daysAhead'],
                  ),
        ),
        'getPlan': _i1.MethodConnector(
          name: 'getPlan',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['plan'] as _i8.PlanEndpoint).getPlan(
                session,
                params['id'],
              ),
        ),
        'getPlanByDate': _i1.MethodConnector(
          name: 'getPlanByDate',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['plan'] as _i8.PlanEndpoint).getPlanByDate(
                session,
                params['studentProfileId'],
                params['date'],
              ),
        ),
        'getStudentPlans': _i1.MethodConnector(
          name: 'getStudentPlans',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['plan'] as _i8.PlanEndpoint).getStudentPlans(
                    session,
                    params['studentProfileId'],
                    limit: params['limit'],
                  ),
        ),
        'getPlansInRange': _i1.MethodConnector(
          name: 'getPlansInRange',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['plan'] as _i8.PlanEndpoint).getPlansInRange(
                    session,
                    params['studentProfileId'],
                    params['startDate'],
                    params['endDate'],
                  ),
        ),
        'getPlanBlocks': _i1.MethodConnector(
          name: 'getPlanBlocks',
          params: {
            'dailyPlanId': _i1.ParameterDescription(
              name: 'dailyPlanId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['plan'] as _i8.PlanEndpoint).getPlanBlocks(
                session,
                params['dailyPlanId'],
              ),
        ),
        'getBlock': _i1.MethodConnector(
          name: 'getBlock',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['plan'] as _i8.PlanEndpoint).getBlock(
                session,
                params['id'],
              ),
        ),
        'getBlocksInRange': _i1.MethodConnector(
          name: 'getBlocksInRange',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['plan'] as _i8.PlanEndpoint).getBlocksInRange(
                    session,
                    params['studentProfileId'],
                    params['startDate'],
                    params['endDate'],
                  ),
        ),
        'updateBlock': _i1.MethodConnector(
          name: 'updateBlock',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'startTime': _i1.ParameterDescription(
              name: 'startTime',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'endTime': _i1.ParameterDescription(
              name: 'endTime',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'durationMinutes': _i1.ParameterDescription(
              name: 'durationMinutes',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'isCompleted': _i1.ParameterDescription(
              name: 'isCompleted',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'completionStatus': _i1.ParameterDescription(
              name: 'completionStatus',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'actualDurationMinutes': _i1.ParameterDescription(
              name: 'actualDurationMinutes',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'energyLevel': _i1.ParameterDescription(
              name: 'energyLevel',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'missReason': _i1.ParameterDescription(
              name: 'missReason',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['plan'] as _i8.PlanEndpoint).updateBlock(
                session,
                params['id'],
                params['title'],
                params['description'],
                params['startTime'],
                params['endTime'],
                params['durationMinutes'],
                params['isCompleted'],
                params['completionStatus'],
                params['actualDurationMinutes'],
                params['energyLevel'],
                params['notes'],
                params['missReason'],
              ),
        ),
        'completeBlock': _i1.MethodConnector(
          name: 'completeBlock',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'actualDurationMinutes': _i1.ParameterDescription(
              name: 'actualDurationMinutes',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'energyLevel': _i1.ParameterDescription(
              name: 'energyLevel',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['plan'] as _i8.PlanEndpoint).completeBlock(
                session,
                params['id'],
                params['actualDurationMinutes'],
                params['energyLevel'],
                params['notes'],
              ),
        ),
        'missBlock': _i1.MethodConnector(
          name: 'missBlock',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'missReason': _i1.ParameterDescription(
              name: 'missReason',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['plan'] as _i8.PlanEndpoint).missBlock(
                session,
                params['id'],
                params['missReason'],
                params['notes'],
              ),
        ),
        'deleteBlock': _i1.MethodConnector(
          name: 'deleteBlock',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['plan'] as _i8.PlanEndpoint).deleteBlock(
                session,
                params['id'],
              ),
        ),
        'regeneratePlan': _i1.MethodConnector(
          name: 'regeneratePlan',
          params: {
            'dailyPlanId': _i1.ParameterDescription(
              name: 'dailyPlanId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['plan'] as _i8.PlanEndpoint).regeneratePlan(
                session,
                params['dailyPlanId'],
              ),
        ),
        'getTodaysPlan': _i1.MethodConnector(
          name: 'getTodaysPlan',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['plan'] as _i8.PlanEndpoint).getTodaysPlan(
                session,
                params['studentProfileId'],
              ),
        ),
        'getOrGenerateTodaysPlan': _i1.MethodConnector(
          name: 'getOrGenerateTodaysPlan',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['plan'] as _i8.PlanEndpoint)
                  .getOrGenerateTodaysPlan(
                    session,
                    params['studentProfileId'],
                  ),
        ),
        'getUpcomingBlocks': _i1.MethodConnector(
          name: 'getUpcomingBlocks',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['plan'] as _i8.PlanEndpoint).getUpcomingBlocks(
                    session,
                    params['studentProfileId'],
                  ),
        ),
        'getCurrentBlock': _i1.MethodConnector(
          name: 'getCurrentBlock',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['plan'] as _i8.PlanEndpoint).getCurrentBlock(
                    session,
                    params['studentProfileId'],
                  ),
        ),
        'getBlocksByStatus': _i1.MethodConnector(
          name: 'getBlocksByStatus',
          params: {
            'dailyPlanId': _i1.ParameterDescription(
              name: 'dailyPlanId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'completionStatus': _i1.ParameterDescription(
              name: 'completionStatus',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['plan'] as _i8.PlanEndpoint).getBlocksByStatus(
                    session,
                    params['dailyPlanId'],
                    params['completionStatus'],
                  ),
        ),
        'getPlanStats': _i1.MethodConnector(
          name: 'getPlanStats',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['plan'] as _i8.PlanEndpoint).getPlanStats(
                session,
                params['studentProfileId'],
              ),
        ),
      },
    );
    connectors['student'] = _i1.EndpointConnector(
      name: 'student',
      endpoint: endpoints['student']!,
      methodConnectors: {
        'createProfile': _i1.MethodConnector(
          name: 'createProfile',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'timezone': _i1.ParameterDescription(
              name: 'timezone',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'wakeTime': _i1.ParameterDescription(
              name: 'wakeTime',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'sleepTime': _i1.ParameterDescription(
              name: 'sleepTime',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'preferredStudyBlockMinutes': _i1.ParameterDescription(
              name: 'preferredStudyBlockMinutes',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'preferredBreakMinutes': _i1.ParameterDescription(
              name: 'preferredBreakMinutes',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'preferredStudyTimes': _i1.ParameterDescription(
              name: 'preferredStudyTimes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['student'] as _i9.StudentEndpoint).createProfile(
                    session,
                    params['name'],
                    params['email'],
                    params['timezone'],
                    params['wakeTime'],
                    params['sleepTime'],
                    params['preferredStudyBlockMinutes'],
                    params['preferredBreakMinutes'],
                    params['preferredStudyTimes'],
                  ),
        ),
        'getProfile': _i1.MethodConnector(
          name: 'getProfile',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['student'] as _i9.StudentEndpoint).getProfile(
                    session,
                    params['id'],
                  ),
        ),
        'getProfileByEmail': _i1.MethodConnector(
          name: 'getProfileByEmail',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['student'] as _i9.StudentEndpoint)
                  .getProfileByEmail(
                    session,
                    params['email'],
                  ),
        ),
        'updateProfile': _i1.MethodConnector(
          name: 'updateProfile',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'timezone': _i1.ParameterDescription(
              name: 'timezone',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'wakeTime': _i1.ParameterDescription(
              name: 'wakeTime',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'sleepTime': _i1.ParameterDescription(
              name: 'sleepTime',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'preferredStudyBlockMinutes': _i1.ParameterDescription(
              name: 'preferredStudyBlockMinutes',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'preferredBreakMinutes': _i1.ParameterDescription(
              name: 'preferredBreakMinutes',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'preferredStudyTimes': _i1.ParameterDescription(
              name: 'preferredStudyTimes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['student'] as _i9.StudentEndpoint).updateProfile(
                    session,
                    params['id'],
                    params['name'],
                    params['timezone'],
                    params['wakeTime'],
                    params['sleepTime'],
                    params['preferredStudyBlockMinutes'],
                    params['preferredBreakMinutes'],
                    params['preferredStudyTimes'],
                  ),
        ),
        'deleteProfile': _i1.MethodConnector(
          name: 'deleteProfile',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['student'] as _i9.StudentEndpoint).deleteProfile(
                    session,
                    params['id'],
                  ),
        ),
        'listProfiles': _i1.MethodConnector(
          name: 'listProfiles',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['student'] as _i9.StudentEndpoint).listProfiles(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
      },
    );
    connectors['voice'] = _i1.EndpointConnector(
      name: 'voice',
      endpoint: endpoints['voice']!,
      methodConnectors: {
        'processCommand': _i1.MethodConnector(
          name: 'processCommand',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'transcription': _i1.ParameterDescription(
              name: 'transcription',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['voice'] as _i10.VoiceEndpoint).processCommand(
                    session,
                    params['studentProfileId'],
                    params['transcription'],
                  ),
        ),
        'createNote': _i1.MethodConnector(
          name: 'createNote',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'transcription': _i1.ParameterDescription(
              name: 'transcription',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'learningGoalId': _i1.ParameterDescription(
              name: 'learningGoalId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'originalAudioUrl': _i1.ParameterDescription(
              name: 'originalAudioUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'duration': _i1.ParameterDescription(
              name: 'duration',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'tags': _i1.ParameterDescription(
              name: 'tags',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'sentiment': _i1.ParameterDescription(
              name: 'sentiment',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'searchableContent': _i1.ParameterDescription(
              name: 'searchableContent',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['voice'] as _i10.VoiceEndpoint).createNote(
                session,
                params['studentProfileId'],
                params['transcription'],
                params['learningGoalId'],
                params['originalAudioUrl'],
                params['duration'],
                params['tags'],
                params['sentiment'],
                params['category'],
                params['searchableContent'],
              ),
        ),
        'getNote': _i1.MethodConnector(
          name: 'getNote',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['voice'] as _i10.VoiceEndpoint).getNote(
                session,
                params['id'],
              ),
        ),
        'getStudentNotes': _i1.MethodConnector(
          name: 'getStudentNotes',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['voice'] as _i10.VoiceEndpoint).getStudentNotes(
                    session,
                    params['studentProfileId'],
                    category: params['category'],
                    limit: params['limit'],
                  ),
        ),
        'getGoalNotes': _i1.MethodConnector(
          name: 'getGoalNotes',
          params: {
            'goalId': _i1.ParameterDescription(
              name: 'goalId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['voice'] as _i10.VoiceEndpoint).getGoalNotes(
                    session,
                    params['goalId'],
                  ),
        ),
        'getNotesBySentiment': _i1.MethodConnector(
          name: 'getNotesBySentiment',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'sentiment': _i1.ParameterDescription(
              name: 'sentiment',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['voice'] as _i10.VoiceEndpoint)
                  .getNotesBySentiment(
                    session,
                    params['studentProfileId'],
                    params['sentiment'],
                  ),
        ),
        'getNotesByCategory': _i1.MethodConnector(
          name: 'getNotesByCategory',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['voice'] as _i10.VoiceEndpoint).getNotesByCategory(
                    session,
                    params['studentProfileId'],
                    params['category'],
                  ),
        ),
        'searchNotes': _i1.MethodConnector(
          name: 'searchNotes',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'searchQuery': _i1.ParameterDescription(
              name: 'searchQuery',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['voice'] as _i10.VoiceEndpoint).searchNotes(
                session,
                params['studentProfileId'],
                params['searchQuery'],
              ),
        ),
        'updateNote': _i1.MethodConnector(
          name: 'updateNote',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'transcription': _i1.ParameterDescription(
              name: 'transcription',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'learningGoalId': _i1.ParameterDescription(
              name: 'learningGoalId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'tags': _i1.ParameterDescription(
              name: 'tags',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'sentiment': _i1.ParameterDescription(
              name: 'sentiment',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'searchableContent': _i1.ParameterDescription(
              name: 'searchableContent',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['voice'] as _i10.VoiceEndpoint).updateNote(
                session,
                params['id'],
                params['transcription'],
                params['learningGoalId'],
                params['tags'],
                params['sentiment'],
                params['category'],
                params['searchableContent'],
              ),
        ),
        'deleteNote': _i1.MethodConnector(
          name: 'deleteNote',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['voice'] as _i10.VoiceEndpoint).deleteNote(
                session,
                params['id'],
              ),
        ),
        'getNoteStats': _i1.MethodConnector(
          name: 'getNoteStats',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['voice'] as _i10.VoiceEndpoint).getNoteStats(
                    session,
                    params['studentProfileId'],
                  ),
        ),
        'getRecentCommands': _i1.MethodConnector(
          name: 'getRecentCommands',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['voice'] as _i10.VoiceEndpoint).getRecentCommands(
                    session,
                    params['studentProfileId'],
                    limit: params['limit'],
                  ),
        ),
        'parseCommand': _i1.MethodConnector(
          name: 'parseCommand',
          params: {
            'transcription': _i1.ParameterDescription(
              name: 'transcription',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['voice'] as _i10.VoiceEndpoint).parseCommand(
                    session,
                    params['transcription'],
                  ),
        ),
        'getSuggestedCommands': _i1.MethodConnector(
          name: 'getSuggestedCommands',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['voice'] as _i10.VoiceEndpoint)
                  .getSuggestedCommands(
                    session,
                    params['studentProfileId'],
                  ),
        ),
        'bulkDeleteNotes': _i1.MethodConnector(
          name: 'bulkDeleteNotes',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'noteIds': _i1.ParameterDescription(
              name: 'noteIds',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['voice'] as _i10.VoiceEndpoint).bulkDeleteNotes(
                    session,
                    params['studentProfileId'],
                    params['noteIds'],
                  ),
        ),
        'exportNotes': _i1.MethodConnector(
          name: 'exportNotes',
          params: {
            'studentProfileId': _i1.ParameterDescription(
              name: 'studentProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['voice'] as _i10.VoiceEndpoint).exportNotes(
                session,
                params['studentProfileId'],
              ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i11.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i12.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i13.Endpoints()
      ..initializeEndpoints(server);
  }
}
