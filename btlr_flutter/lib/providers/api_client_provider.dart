import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btlr_client/btlr_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

/// Serverpod client provider
/// This connects Flutter app to the backend server
final clientProvider = Provider<Client>((ref) {
  // Connect to local server (change for production)
  const serverUrl = 'http://localhost:8082/';
  
  return Client(
    serverUrl,
  )..connectivityMonitor = FlutterConnectivityMonitor();
});

/// Current student profile ID provider
/// This should be set after login/profile creation
final currentStudentIdProvider = StateProvider<int?>((ref) => null);

/// Student endpoint provider
final studentEndpointProvider = Provider<EndpointStudent>((ref) {
  final client = ref.watch(clientProvider);
  return client.student;
});

/// Academic endpoint provider
final academicEndpointProvider = Provider<EndpointAcademic>((ref) {
  final client = ref.watch(clientProvider);
  return client.academic;
});

/// Goal endpoint provider
final goalEndpointProvider = Provider<EndpointGoal>((ref) {
  final client = ref.watch(clientProvider);
  return client.goal;
});

/// Plan endpoint provider
final planEndpointProvider = Provider<EndpointPlan>((ref) {
  final client = ref.watch(clientProvider);
  return client.plan;
});

/// Behavior endpoint provider
final behaviorEndpointProvider = Provider<EndpointBehavior>((ref) {
  final client = ref.watch(clientProvider);
  return client.behavior;
});

/// Opportunity endpoint provider
final opportunityEndpointProvider = Provider<EndpointOpportunity>((ref) {
  final client = ref.watch(clientProvider);
  return client.opportunity;
});

/// Voice endpoint provider
final voiceEndpointProvider = Provider<EndpointVoice>((ref) {
  final client = ref.watch(clientProvider);
  return client.voice;
});