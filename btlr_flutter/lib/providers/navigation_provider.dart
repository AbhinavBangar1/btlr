import 'package:flutter_riverpod/flutter_riverpod.dart';

// This enum maps to your sidebar buttons
enum SidebarTab { home, schedule, goals, opportunities, settings }

final sidebarTabProvider = StateProvider<SidebarTab>((ref) => SidebarTab.home);