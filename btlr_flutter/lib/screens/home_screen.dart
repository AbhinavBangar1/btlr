import 'package:btlr_flutter/screens/week_schedule_screen.dart';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'goals_screen.dart';
import 'schedule_screen.dart';
// import 'opportunities_screen.dart';
import 'settings_screen.dart';
import 'discover_screen.dart';

// --- BRAND CONSTANTS ---
const Color kPrimaryBlue = Color(0xFF274B7F); // BTLR Sapphire Blue
const Color kBackgroundWhite = Color(0xFFFFFFFF);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isVisible = false;

  static const List<Widget> _screens = [
    DashboardScreen(),
    GoalsScreen(),
    ScheduleScreen(),
    DiscoverScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Trigger the entrance animation after a tiny delay for web smoothness
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _isVisible = true);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundWhite,
      // SMOOTH TRANSITION: The content fades and slides up slightly
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 1000),
        opacity: _isVisible ? 1.0 : 0.0,
        curve: Curves.easeOutCubic,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.only(top: _isVisible ? 0 : 30),
          child: _screens[_selectedIndex],
        ),
      ),

      // THEMED NAVIGATION BAR
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 1200),
        curve: Curves.fastOutSlowIn,
        transform: Matrix4.translationValues(0, _isVisible ? 0 : 100, 0),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: kPrimaryBlue.withOpacity(0.1),
            backgroundColor: kBackgroundWhite,
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(
                    color: kPrimaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.2
                );
              }
              return TextStyle(color: kPrimaryBlue.withOpacity(0.5), fontSize: 12);
            }),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(color: kPrimaryBlue, size: 28);
              }
              return IconThemeData(color: kPrimaryBlue.withOpacity(0.5), size: 24);
            }),
          ),
          child: NavigationBar(
            elevation: 10,
            shadowColor: kPrimaryBlue.withOpacity(0.2),
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'DASHBOARD',
              ),
              NavigationDestination(
                icon: Icon(Icons.flag_outlined),
                selectedIcon: Icon(Icons.flag),
                label: 'GOALS',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_today_outlined),
                selectedIcon: Icon(Icons.calendar_today),
                label: 'SCHEDULE',
              ),
              NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore),
                label: 'EXPLORE',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'SETTINGS',
              ),
            ],
          ),
        ),
      ),
    );
  }
}