import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/plan_provider.dart';
import '../providers/ui_state_provider.dart';

class WeeklyCalendarView extends ConsumerStatefulWidget {
  const WeeklyCalendarView({super.key});

  @override
  ConsumerState<WeeklyCalendarView> createState() => _WeeklyCalendarViewState();
}

class _WeeklyCalendarViewState extends ConsumerState<WeeklyCalendarView> {
  late ScrollController _horizontalScrollController;
  late ScrollController _verticalScrollController;
  DateTime _weekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
    _verticalScrollController = ScrollController();

    // Auto-scroll to current time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentHour = DateTime.now().hour;
      if (currentHour >= 8) {
        _verticalScrollController.animateTo(
          (currentHour - 8) * 80.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  List<DateTime> _getWeekDays() {
    return List.generate(7, (index) => _weekStart.add(Duration(days: index)));
  }

  void _previousWeek() {
    setState(() {
      _weekStart = _weekStart.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _weekStart = _weekStart.add(const Duration(days: 7));
    });
  }

  void _goToToday() {
    setState(() {
      _weekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = _getWeekDays();
    final weeklyBlocksAsync = ref.watch(weeklyBlocksProvider);
    final isCalendarView = ref.watch(viewModeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Weekly Blueprint',
          style: TextStyle(
            color: kPrimaryBlue,
            fontWeight: FontWeight.w800,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          // View Toggle Button
          IconButton(
            icon: Icon(
              isCalendarView ? Icons.view_list_rounded : Icons.calendar_view_week_rounded,
              color: kPrimaryBlue,
            ),
            onPressed: () {
              ref.read(viewModeProvider.notifier).update((state) => !state);
            },
            tooltip: 'List View',
          ),
          IconButton(
            icon: const Icon(Icons.today_rounded, color: kPrimaryBlue),
            onPressed: _goToToday,
            tooltip: 'Today',
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: kPrimaryBlue),
            onPressed: () => ref.read(todaysPlanProvider.notifier).reload(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Week Navigation
          _buildWeekNavigation(weekDays),

          // Calendar Grid
          Expanded(
            child: weeklyBlocksAsync.when(
              data: (blocks) => _buildCalendarGrid(weekDays, blocks),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekNavigation(List<DateTime> weekDays) {
    final now = DateTime.now();
    final isCurrentWeek = weekDays.any((day) =>
    day.year == now.year && day.month == now.month && day.day == now.day
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: kAccentBlue.withOpacity(0.3),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded, color: kPrimaryBlue),
            onPressed: _previousWeek,
          ),
          Column(
            children: [
              Text(
                '${_formatMonthYear(weekDays.first)} - ${_formatMonthYear(weekDays.last)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: kPrimaryBlue,
                ),
              ),
              if (isCurrentWeek)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: kPrimaryBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Current Week',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded, color: kPrimaryBlue),
            onPressed: _nextWeek,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(List<DateTime> weekDays, List<dynamic> blocks) {
    return Row(
      children: [
        // Time labels column
        _buildTimeColumn(),

        // Calendar grid
        Expanded(
          child: SingleChildScrollView(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: weekDays.length * 140.0,
              child: Column(
                children: [
                  // Day headers
                  _buildDayHeaders(weekDays),

                  // Time grid
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _verticalScrollController,
                      child: _buildTimeGrid(weekDays, blocks),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeColumn() {
    return Container(
      width: 70,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          // Header spacer
          Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: const Center(
              child: Text(
                'Time',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: kPrimaryBlue,
                ),
              ),
            ),
          ),

          // Time labels
          ...List.generate(15, (index) {
            final hour = index + 8; // Start from 8 AM
            return Container(
              height: 80,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Center(
                child: Text(
                  _formatHour(hour),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDayHeaders(List<DateTime> weekDays) {
    final now = DateTime.now();

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: weekDays.map((day) {
          final isToday = day.year == now.year &&
              day.month == now.month &&
              day.day == now.day;

          return Container(
            width: 140,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isToday ? kAccentBlue : Colors.transparent,
              border: Border(
                right: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getDayName(day.weekday),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isToday ? kPrimaryBlue : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isToday ? kPrimaryBlue : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isToday ? Colors.white : kPrimaryBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimeGrid(List<DateTime> weekDays, List<dynamic> blocks) {
    return Stack(
      children: [
        // Grid lines
        Column(
          children: List.generate(15, (index) {
            return Container(
              height: 80,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: weekDays.map((day) {
                  return Container(
                    width: 140,
                    decoration: BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.grey.shade100)),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ),

        // Current time indicator
        _buildCurrentTimeIndicator(weekDays),

        // Time blocks
        ...blocks.map((block) => _buildTimeBlock(block, weekDays)),
      ],
    );
  }

  Widget _buildCurrentTimeIndicator(List<DateTime> weekDays) {
    final now = DateTime.now();
    final todayIndex = weekDays.indexWhere((day) =>
    day.year == now.year && day.month == now.month && day.day == now.day
    );

    if (todayIndex == -1) return const SizedBox.shrink();

    final currentHour = now.hour;
    final currentMinute = now.minute;

    if (currentHour < 8 || currentHour >= 23) return const SizedBox.shrink();

    final topPosition = ((currentHour - 8) * 80.0) + (currentMinute / 60 * 80);

    return Positioned(
      top: topPosition,
      left: todayIndex * 140.0,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 132,
            height: 2,
            color: Colors.red.withOpacity(0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBlock(dynamic block, List<DateTime> weekDays) {
    final blockDate = block.startTime;
    final dayIndex = weekDays.indexWhere((day) =>
    day.year == blockDate.year &&
        day.month == blockDate.month &&
        day.day == blockDate.day
    );

    if (dayIndex == -1) return const SizedBox.shrink();

    final startHour = block.startTime.hour;
    final startMinute = block.startTime.minute;
    final durationMinutes = block.durationMinutes;

    if (startHour < 8 || startHour >= 23) return const SizedBox.shrink();

    final topPosition = ((startHour - 8) * 80.0) + (startMinute / 60 * 80);
    final height = (durationMinutes / 60 * 80).clamp(20.0, 500.0);

    Color blockColor = _getBlockColor(block.blockType);
    final now = DateTime.now();
    final isCurrent = now.isAfter(block.startTime) && now.isBefore(block.endTime);

    return Positioned(
      top: topPosition,
      left: dayIndex * 140.0 + 4,
      child: GestureDetector(
        onTap: () => _showBlockDetails(block),
        child: Container(
          width: 132,
          height: height,
          margin: const EdgeInsets.symmetric(vertical: 1),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: block.completionStatus == 'completed'
                ? Colors.green.withOpacity(0.2)
                : block.completionStatus == 'missed'
                ? Colors.red.withOpacity(0.2)
                : blockColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: block.completionStatus == 'completed'
                  ? Colors.green
                  : block.completionStatus == 'missed'
                  ? Colors.red
                  : blockColor,
              width: isCurrent ? 2.5 : 1.5,
            ),
            boxShadow: isCurrent ? [
              BoxShadow(
                color: blockColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ] : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                block.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: blockColor,
                  decoration: block.completionStatus == 'completed'
                      ? TextDecoration.lineThrough
                      : null,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '${_formatTime(block.startTime)} - ${_formatTime(block.endTime)}',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (height > 50 && block.description != null) ...[
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    block.description,
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showBlockDetails(dynamic block) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    block.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: kPrimaryBlue,
                    ),
                  ),
                ),
                _BlockTypeBadge(type: block.blockType),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.access_time_filled_rounded, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${_formatTime(block.startTime)} - ${_formatTime(block.endTime)}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.timer_rounded, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${block.durationMinutes} minutes',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            if (block.description != null) ...[
              const SizedBox(height: 16),
              Text(
                block.description,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
              ),
            ],
            if (block.completionStatus != 'completed') ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        await ref.read(timeBlockActionsProvider).completeBlock(block.id);
                        if (context.mounted) Navigator.pop(context);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: kPrimaryBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Complete', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        await ref.read(timeBlockActionsProvider).missBlock(block.id, 'Missed');
                        if (context.mounted) Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Miss', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getBlockColor(String type) {
    switch (type) {
      case 'study': return Colors.indigo;
      case 'class': return Colors.deepPurple;
      case 'break': return Colors.teal;
      case 'exam_prep': return Colors.orange.shade800;
      case 'project_work': return Colors.blueGrey;
      case 'opportunity_prep': return Colors.pink.shade700;
      default: return kPrimaryBlue;
    }
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12:00 AM';
    if (hour < 12) return '$hour:00 AM';
    if (hour == 12) return '12:00 PM';
    return '${hour - 12}:00 PM';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatMonthYear(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }
}

class _BlockTypeBadge extends StatelessWidget {
  final String type;
  const _BlockTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    Color color = kPrimaryBlue;
    switch (type) {
      case 'study': color = Colors.indigo; break;
      case 'class': color = Colors.deepPurple; break;
      case 'break': color = Colors.teal; break;
      case 'exam_prep': color = Colors.orange.shade800; break;
      case 'project_work': color = Colors.blueGrey; break;
      case 'opportunity_prep': color = Colors.pink.shade700; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        type.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}