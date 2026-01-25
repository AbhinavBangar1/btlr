import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return // Inside your MaterialApp/ProviderScope
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BTLR',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF274B7F)),
          useMaterial3: true,
        ),
        home: SplashScreen(), // Change this from LoginScreen to SplashScreen
      );
  }
}