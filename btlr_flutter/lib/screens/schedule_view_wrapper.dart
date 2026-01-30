import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ui_state_provider.dart';
import 'schedule_screen.dart';
import 'weekly_calendar_view.dart';

class ScheduleViewWrapper extends ConsumerWidget {
  const ScheduleViewWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCalendarView = ref.watch(viewModeProvider);

    return isCalendarView 
        ? const WeeklyCalendarView() 
        : const ScheduleScreen();
  }
}
