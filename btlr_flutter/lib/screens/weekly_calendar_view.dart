import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/plan_provider.dart';
import '../providers/ui_state_provider.dart';

const Color kPrimaryBlue = Color(0xFF274B7F);
const Color kAccentBlue = Color(0xFFE8F0FE);

// Refined dimensions for a desktop-with-sidebar layout
const _rowHeight = 100.0;      // Slightly shorter for better vertical context
const _colWidth = 180.0;       // Narrower so more days fit on screen
const _startHour = 0;          // 12 am
const _endHour = 23;           // 11 pm

class WeeklyCalendarView extends ConsumerStatefulWidget {
  const WeeklyCalendarView({super.key});

  @override
  ConsumerState<WeeklyCalendarView> createState() => _WeeklyCalendarViewState();
}

class _WeeklyCalendarViewState extends ConsumerState<WeeklyCalendarView> {
  late ScrollController _horizontalScrollController;
  late ScrollController _verticalScrollController;

  DateTime _weekStart = _normalizeDate(
    DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
  );

  static DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
    _verticalScrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentHour = DateTime.now().hour;
      if (currentHour >= _startHour && currentHour <= _endHour) {
        _verticalScrollController.jumpTo((currentHour - _startHour) * _rowHeight);
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
    ref.invalidate(weeklyBlocksProvider);
  }

  void _nextWeek() {
    setState(() {
      _weekStart = _weekStart.add(const Duration(days: 7));
    });
    ref.invalidate(weeklyBlocksProvider);
  }

  void _goToToday() {
    setState(() {
      _weekStart = _normalizeDate(
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      );
    });
    ref.invalidate(weeklyBlocksProvider);
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = _getWeekDays();
    final startDate = weekDays.first;
    final endDate = weekDays.last;

    final weeklyBlocksAsync = ref.watch(
      weeklyBlocksProvider((startDate: startDate, endDate: endDate)),
    );

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
            onPressed: () {
              ref.invalidate(weeklyBlocksProvider);
              ref.invalidate(todaysPlanProvider);
            },
          ),
          // ✅ GENERATE PLAN BUTTON
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: kPrimaryBlue),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (value) async {
              if (value == 'generate') {
                await ref.read(todaysPlanProvider.notifier).generatePlan();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Plan generated!')),
                  );
                }
              } else if (value == 'regenerate') {
                await ref.read(todaysPlanProvider.notifier).regeneratePlan();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Plan regenerated!')),
                  );
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'generate',
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 18, color: kPrimaryBlue),
                    SizedBox(width: 8),
                    Text('Generate Plan'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'regenerate',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 18, color: kPrimaryBlue),
                    SizedBox(width: 8),
                    Text('Optimize Plan'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildWeekNavigation(weekDays),
          Expanded(
            child: weeklyBlocksAsync.when(
              data: (blocks) => _buildCalendarGrid(weekDays, blocks),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) {
                print('❌ Weekly blocks error: $error');
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(weeklyBlocksProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekNavigation(List<DateTime> weekDays) {
    final now = DateTime.now();
    final isCurrentWeek = weekDays.any((day) =>
        day.year == now.year && day.month == now.month && day.day == now.day);

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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
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
  final totalHours = _endHour - _startHour + 1;

  return SingleChildScrollView(
    controller: _verticalScrollController,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Time column (scrolls with content)
        _buildTimeColumn(totalHours),

        // ✅ Scrollable grid (horizontal only)
        Expanded(
          child: SingleChildScrollView(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: weekDays.length * _colWidth,
              child: Column(
                children: [
                  _buildDayHeaders(weekDays),
                  _buildTimeGrid(weekDays, blocks, totalHours),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


Widget _buildTimeColumn(int totalHours) {
  return Container(
    width: 70,
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      border: Border(right: BorderSide(color: Colors.grey.shade300)),
    ),
    child: Column(
      children: [
        // ✅ Spacer matching day header height
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
        // ✅ Hour labels
        ...List.generate(totalHours, (index) {
          final hour = _startHour + index;
          return Container(
            height: _rowHeight,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 4),
                child: Text(
                  _formatHour(hour),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
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

  return SizedBox(
    width: weekDays.length * _colWidth,
    height: 60,
    child: Row(
      children: weekDays.map((day) {
        final isToday = day.year == now.year &&
            day.month == now.month &&
            day.day == now.day;

        return Container(
          width: _colWidth,
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: isToday ? kAccentBlue : Colors.white,
            border: Border(
              right: BorderSide(color: Colors.grey.shade200),
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getDayName(day.weekday),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: isToday ? kPrimaryBlue : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isToday ? kPrimaryBlue : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    day.day.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
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


  Widget _buildTimeGrid(List<DateTime> weekDays, List<dynamic> blocks, int totalHours) {
    return SizedBox(
      height: totalHours * _rowHeight,
      child: Stack(
        children: [
          // Grid lines
          Column(
            children: List.generate(totalHours, (index) {
              return Container(
                height: _rowHeight,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: weekDays.map((day) {
                    return Container(
                      width: _colWidth,
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
      ),
    );
  }

  Widget _buildCurrentTimeIndicator(List<DateTime> weekDays) {
    final now = DateTime.now();
    final todayIndex = weekDays.indexWhere((day) =>
        day.year == now.year && day.month == now.month && day.day == now.day);

    if (todayIndex == -1) return const SizedBox.shrink();

    final currentHour = now.hour;
    final currentMinute = now.minute;

    if (currentHour < _startHour || currentHour > _endHour) {
      return const SizedBox.shrink();
    }

    final topPosition = ((currentHour - _startHour) * _rowHeight) +
        (currentMinute / 60 * _rowHeight);

    return Positioned(
      top: topPosition,
      left: todayIndex * _colWidth,
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
            width: _colWidth - 8,
            height: 2,
            color: Colors.red.withOpacity(0.7),
          ),
        ],
      ),
    );
  }

  // Widget _buildTimeBlock(dynamic block, List<DateTime> weekDays) {
  //   final blockDate = block.startTime as DateTime;
  //   final dayIndex = weekDays.indexWhere((day) =>
  //       day.year == blockDate.year &&
  //       day.month == blockDate.month &&
  //       day.day == blockDate.day);

  //   if (dayIndex == -1) return const SizedBox.shrink();

  //   final startHour = blockDate.hour;
  //   final startMinute = blockDate.minute;
  //   final durationMinutes = block.durationMinutes as int;

  //   if (startHour < _startHour || startHour > _endHour) {
  //     return const SizedBox.shrink();
  //   }

  //   final topPosition = ((startHour - _startHour) * _rowHeight) +
  //       (startMinute / 60 * _rowHeight);
  //   final height = (durationMinutes / 60 * _rowHeight).clamp(20.0, _rowHeight * 5);

  //   final blockColor = _getBlockColor(block.blockType as String);
  //   final now = DateTime.now();
  //   final isCurrent = now.isAfter(blockDate) && now.isBefore(block.endTime as DateTime);

  //   return Positioned(
  //     top: topPosition,
  //     left: dayIndex * _colWidth + 4,
  //     child: GestureDetector(
  //       onTap: () => _showBlockDetails(block),
  //       child: Container(
  //         width: _colWidth - 8,
  //         height: height,
  //         margin: const EdgeInsets.symmetric(vertical: 1),
  //         padding: const EdgeInsets.all(8),
  //         decoration: BoxDecoration(
  //           color: block.completionStatus == 'completed'
  //               ? Colors.green.withOpacity(0.2)
  //               : block.completionStatus == 'missed'
  //                   ? Colors.red.withOpacity(0.2)
  //                   : blockColor.withOpacity(0.15),
  //           borderRadius: BorderRadius.circular(8),
  //           border: Border.all(
  //             color: block.completionStatus == 'completed'
  //                 ? Colors.green
  //                 : block.completionStatus == 'missed'
  //                     ? Colors.red
  //                     : blockColor,
  //             width: isCurrent ? 2.5 : 1.5,
  //           ),
  //           boxShadow: isCurrent
  //               ? [
  //                   BoxShadow(
  //                     color: blockColor.withOpacity(0.3),
  //                     blurRadius: 8,
  //                     offset: const Offset(0, 2),
  //                   )
  //                 ]
  //               : null,
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               block.title as String,
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 12,
  //                 color: blockColor,
  //                 decoration: block.completionStatus == 'completed'
  //                     ? TextDecoration.lineThrough
  //                     : null,
  //               ),
  //               maxLines: 2,
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //             const SizedBox(height: 2),
  //             Text(
  //               '${_formatTime(blockDate)} - ${_formatTime(block.endTime as DateTime)}',
  //               style: TextStyle(
  //                 fontSize: 10,
  //                 color: Colors.grey.shade700,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             if (height > 60 && block.description != null) ...[
  //               const SizedBox(height: 4),
  //               Expanded(
  //                 child: Text(
  //                   block.description as String,
  //                   style: TextStyle(
  //                     fontSize: 10,
  //                     color: Colors.grey.shade600,
  //                   ),
  //                   maxLines: 3,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ),
  //             ],
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTimeBlock(dynamic block, List<DateTime> weekDays) {
  final blockDate = block.startTime as DateTime;
  final dayIndex = weekDays.indexWhere((day) =>
      day.year == blockDate.year &&
      day.month == blockDate.month &&
      day.day == blockDate.day);

  if (dayIndex == -1) return const SizedBox.shrink();

  final startHour = blockDate.hour;
  final startMinute = blockDate.minute;
  final durationMinutes = block.durationMinutes as int;

  if (startHour < _startHour || startHour > _endHour) {
    return const SizedBox.shrink();
  }

  final topPosition = ((startHour - _startHour) * _rowHeight) +
      (startMinute / 60 * _rowHeight);
  final height = (durationMinutes / 60 * _rowHeight).clamp(30.0, _rowHeight * 6);

  final blockColor = _getBlockColor(block.blockType as String);
  final now = DateTime.now();
  final isCurrent = now.isAfter(blockDate) && now.isBefore(block.endTime as DateTime);

  return Positioned(
    top: topPosition,
    left: dayIndex * _colWidth + 4,
    child: GestureDetector(
      onTap: () => _showBlockDetails(block),
      child: Container(
        width: _colWidth - 8,
        height: height,
        margin: const EdgeInsets.symmetric(vertical: 1),
        padding: const EdgeInsets.all(10),
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
          boxShadow: isCurrent
              ? [
                  BoxShadow(
                    color: blockColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        // ✅ FIX: Use ClipRect to prevent overflow
        child: ClipRect(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  block.title as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: blockColor,
                    decoration: block.completionStatus == 'completed'
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatTime(blockDate)} - ${_formatTime(block.endTime as DateTime)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (height > 80 && block.description != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    block.description as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
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
                    block.title as String,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: kPrimaryBlue,
                    ),
                  ),
                ),
                _BlockTypeBadge(type: block.blockType as String),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.access_time_filled_rounded, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${_formatTime(block.startTime as DateTime)} - ${_formatTime(block.endTime as DateTime)}',
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
                block.description as String,
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
                        await ref.read(timeBlockActionsProvider).completeBlock(block.id as int);
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
                        await ref.read(timeBlockActionsProvider).missBlock(block.id as int, 'Missed');
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
      case 'study':
        return Colors.indigo;
      case 'class':
        return Colors.deepPurple;
      case 'break':
        return Colors.teal;
      case 'exam_prep':
        return Colors.orange.shade800;
      case 'project_work':
        return Colors.blueGrey;
      case 'opportunity_prep':
        return Colors.pink.shade700;
      default:
        return kPrimaryBlue;
    }
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
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
      case 'study':
        color = Colors.indigo;
        break;
      case 'class':
        color = Colors.deepPurple;
        break;
      case 'break':
        color = Colors.teal;
        break;
      case 'exam_prep':
        color = Colors.orange.shade800;
        break;
      case 'project_work':
        color = Colors.blueGrey;
        break;
      case 'opportunity_prep':
        color = Colors.pink.shade700;
        break;
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
