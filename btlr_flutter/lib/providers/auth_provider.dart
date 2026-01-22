import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client_provider.dart';

/// Simple authentication state (email-based)
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AsyncValue<String?>>((ref) {
  return AuthStateNotifier(ref);
});

/// Auth state notifier (simple implementation)
class AuthStateNotifier extends StateNotifier<AsyncValue<String?>> {
  final Ref ref;

  AuthStateNotifier(this.ref) : super(const AsyncValue.loading()) {
    _initAuth();
  }

  /// Initialize authentication (check if user exists)
  Future<void> _initAuth() async {
    state = const AsyncValue.loading();
    
    try {
      // For now, no persistent session - user must log in each time
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      // Create student profile (this acts as account creation)
      final endpoint = ref.read(studentEndpointProvider);
      
      // Check if email already exists
      final existing = await endpoint.getProfileByEmail(email);
      if (existing != null) {
        return false; // Email already exists
      }
      
      // Create new profile
      final profile = await endpoint.createProfile(
        userName,
        email,
        'UTC',
        '07:00',
        '23:00',
        50,
        10,
        null,
      );

      if (profile.id != null) {
        // Set as current user
        ref.read(currentStudentIdProvider.notifier).state = profile.id;
        state = AsyncValue.data(email);
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Sign in with email (simplified - no password check for now)
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final endpoint = ref.read(studentEndpointProvider);
      
      // Try to find profile by email
      final profile = await endpoint.getProfileByEmail(email);
      
      if (profile != null) {
        // Set as current user
        ref.read(currentStudentIdProvider.notifier).state = profile.id;
        state = AsyncValue.data(email);
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      ref.read(currentStudentIdProvider.notifier).state = null;
      state = const AsyncValue.data(null);
    } catch (e) {
      // Ignore errors during sign out
    }
  }

  /// Check if user is signed in
  bool get isSignedIn {
    return state.value != null;
  }

  /// Get current user email
  String? get currentUserEmail {
    return state.value;
  }
}

/// Provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (email) => email != null,
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Provider to get current user email
final currentUserEmailProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (email) => email,
    loading: () => null,
    error: (_, __) => null,
  );
});