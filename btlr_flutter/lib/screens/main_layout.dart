// lib/screens/main_layout.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart'; // To access signOut
import '../providers/navigation_provider.dart';
import 'dashboard_screen.dart';
import 'goals_screen.dart';
import 'schedule_screen.dart';
import 'discover_screen.dart';
import 'settings_screen.dart';

const Color kPrimaryBlue = Color(0xFF274B7F);

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _isVisible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(sidebarTabProvider);

    final Map<SidebarTab, Widget> _screens = {
      SidebarTab.home: const DashboardScreen(),
      SidebarTab.goals: const GoalsScreen(),
      SidebarTab.schedule: const ScheduleScreen(),
      SidebarTab.opportunities: const DiscoverScreen(),
      SidebarTab.settings: const SettingsScreen(),
    };

    return Scaffold(
      body: Row(
        children: [
          // --- SIDEBAR ---
          Container(
            width: 280,
            color: kPrimaryBlue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(32, 60, 32, 40),
                  child: Text("BTLR", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -2)),
                ),
                _SidebarItem(
                  label: "DASHBOARD",
                  icon: Icons.dashboard_rounded,
                  isActive: selectedTab == SidebarTab.home,
                  onTap: () => ref.read(sidebarTabProvider.notifier).state = SidebarTab.home,
                ),
                _SidebarItem(
                  label: "GOALS",
                  icon: Icons.flag_rounded,
                  isActive: selectedTab == SidebarTab.goals,
                  onTap: () => ref.read(sidebarTabProvider.notifier).state = SidebarTab.goals,
                ),
                _SidebarItem(
                  label: "SCHEDULE",
                  icon: Icons.calendar_month_rounded,
                  isActive: selectedTab == SidebarTab.schedule,
                  onTap: () => ref.read(sidebarTabProvider.notifier).state = SidebarTab.schedule,
                ),
                _SidebarItem(
                  label: "EXPLORE",
                  icon: Icons.explore_rounded,
                  isActive: selectedTab == SidebarTab.opportunities,
                  onTap: () => ref.read(sidebarTabProvider.notifier).state = SidebarTab.opportunities,
                ),
                const Spacer(),
                // --- SETTINGS ---
                _SidebarItem(
                  label: "SETTINGS",
                  icon: Icons.settings_rounded,
                  isActive: selectedTab == SidebarTab.settings,
                  onTap: () => ref.read(sidebarTabProvider.notifier).state = SidebarTab.settings,
                ),
                // --- LOGOUT BUTTON ---
                _SidebarItem(
                  label: "LOG OUT",
                  icon: Icons.logout_rounded,
                  isActive: false,
                  textColor: Colors.redAccent.shade100,
                  onTap: () async {
                    // This calls your existing auth logic
                    await ref.read(authStateProvider.notifier).signOut();
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          // --- CONTENT AREA ---
          Expanded(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 1000),
              opacity: _isVisible ? 1.0 : 0.0,
              curve: Curves.easeOutCubic,
              child: _screens[selectedTab] ?? const DashboardScreen(),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable item with optional text color for Logout
class _SidebarItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final Color? textColor;

  const _SidebarItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? (isActive ? Colors.white : Colors.white54);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                letterSpacing: 1.5,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}