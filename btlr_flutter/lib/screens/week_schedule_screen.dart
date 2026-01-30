import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/plan_provider.dart';

const _rowHeight = 80.0;     // height per hour
const _colWidth = 120.0;      // width per day
const _startHour = 0;        // 12 am
const _endHour = 23;         // 11 pm

class WeekScheduleScreen extends ConsumerStatefulWidget {
  const WeekScheduleScreen({super.key});

  @override
  ConsumerState<WeekScheduleScreen> createState() => _WeekScheduleScreenState();
}

class _WeekScheduleScreenState extends ConsumerState<WeekScheduleScreen> {
  late final ScrollController _verticalController;
  late final ScrollController _horizontalController;

  DateTime _weekStart =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  @override
  void initState() {
    super.initState();
    _verticalController = ScrollController();
    _horizontalController = ScrollController();

    // Auto-scroll near current time.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hour = DateTime.now().hour;
      if (hour >= _startHour && hour <= _endHour) {
        _verticalController.jumpTo((hour - _startHour) * _rowHeight);
      }
    });
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  List<DateTime> _weekDays() => List.generate(
        7,
        (i) => DateTime(
          _weekStart.year,
          _weekStart.month,
          _weekStart.day + i,
        ),
      );

  void _previousWeek() =>
      setState(() => _weekStart = _weekStart.subtract(const Duration(days: 7)));

  void _nextWeek() =>
      setState(() => _weekStart = _weekStart.add(const Duration(days: 7)));

  void _goToToday() => setState(() {
        _weekStart =
            DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
      });

  @override
  Widget build(BuildContext context) {
    final days = _weekDays();
    final start = DateTime(days.first.year, days.first.month, days.first.day);
    final end =
        DateTime(days.last.year, days.last.month, days.last.day, 23, 59, 59);

    final blocksAsync =
        ref.watch(weeklyBlocksProvider((startDate: start, endDate: end)));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Text(
              _monthLabel(days.first),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 20, color: Colors.grey),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: _previousWeek,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: _nextWeek,
            ),
            IconButton(
              icon: const Icon(Icons.today_rounded),
              onPressed: _goToToday,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _WeekHeader(days: days),
          const Divider(height: 1),
          Expanded(
            child: blocksAsync.when(
              data: (blocks) => _WeekGrid(
                days: days,
                blocks: blocks,
                verticalController: _verticalController,
                horizontalController: _horizontalController,
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _monthLabel(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[date.month - 1];
  }
}

class _WeekHeader extends StatelessWidget {
  final List<DateTime> days;

  const _WeekHeader({required this.days});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.grey.shade50,
      child: Row(
        children: [
          const SizedBox(width: 56), // time column spacer
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                final isToday = day.year == today.year &&
                    day.month == today.month &&
                    day.day == today.day;

                return SizedBox(
                  width: _colWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _weekdayShort(day.weekday),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isToday ? Colors.blue : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color:
                              isToday ? Colors.blue : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isToday ? Colors.white : Colors.black87,
                          ),
                        ),
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

  String _weekdayShort(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }
}

class _WeekGrid extends StatelessWidget {
  final List<DateTime> days;
  final List<dynamic> blocks; // TimeBlock
  final ScrollController verticalController;
  final ScrollController horizontalController;

  const _WeekGrid({
    required this.days,
    required this.blocks,
    required this.verticalController,
    required this.horizontalController,
  });

  @override
  Widget build(BuildContext context) {
    final totalHours = _endHour - _startHour + 1;

    return Row(
      children: [
        // Time labels
        SizedBox(
          width: 56,
          child: ListView.builder(
            controller: verticalController,
            itemCount: totalHours,
            itemBuilder: (context, index) {
              final hour = _startHour + index;
              return SizedBox(
                height: _rowHeight,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4, top: 2),
                    child: Text(
                      _formatHour(hour),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Grid + blocks
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            controller: verticalController,
            child: SingleChildScrollView(
              controller: verticalController,
              child: SingleChildScrollView(
                controller: horizontalController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: days.length * _colWidth,
                  height: totalHours * _rowHeight,
                  child: Stack(
                    children: [
                      // Background grid
                      _buildGrid(days.length, totalHours),
                      // Blocks
                      ...blocks.map((b) => _buildBlock(b, days)),
                      // Current time indicator
                      _buildNowIndicator(days),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(int dayCount, int hourCount) {
    return CustomPaint(
      size: Size(dayCount * _colWidth, hourCount * _rowHeight),
      painter: _GridPainter(dayCount: dayCount, hourCount: hourCount),
    );
  }

  Widget _buildBlock(dynamic block, List<DateTime> days) {
    final start = block.startTime as DateTime;
    final end = block.endTime as DateTime;
    final durationMinutes = block.durationMinutes as int;

    final dayIndex = days.indexWhere((d) =>
        d.year == start.year && d.month == start.month && d.day == start.day);
    if (dayIndex == -1) return const SizedBox.shrink();

    final hour = start.hour;
    final minute = start.minute;

    if (hour < _startHour || hour > _endHour) {
      return const SizedBox.shrink();
    }

    final top = ((hour - _startHour) * _rowHeight) +
        (minute / 60.0 * _rowHeight);
    final height =
        (durationMinutes / 60.0 * _rowHeight).clamp(10.0, _rowHeight * 4);

    final left = dayIndex * _colWidth + 4;
    final isCompleted = block.completionStatus == 'completed';
    final isMissed = block.completionStatus == 'missed';

    final baseColor = _blockColor(block.blockType as String);

    return Positioned(
      top: top,
      left: left,
      width: _colWidth - 8,
      height: height,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isCompleted
              ? Colors.green.withOpacity(0.15)
              : isMissed
                  ? Colors.red.withOpacity(0.15)
                  : baseColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isCompleted
                ? Colors.green
                : isMissed
                    ? Colors.red
                    : baseColor,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // dot like in screenshot
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: baseColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                block.title as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: baseColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNowIndicator(List<DateTime> days) {
    final now = DateTime.now();
    final dayIndex = days.indexWhere((d) =>
        d.year == now.year && d.month == now.month && d.day == now.day);
    if (dayIndex == -1) return const SizedBox.shrink();

    final hour = now.hour;
    final minute = now.minute;
    if (hour < _startHour || hour > _endHour) {
      return const SizedBox.shrink();
    }

    final top = ((hour - _startHour) * _rowHeight) +
        (minute / 60.0 * _rowHeight);
    final left = dayIndex * _colWidth;

    return Positioned(
      top: top,
      left: left,
      child: Row(
        children: [
          Container(
            width: _colWidth,
            height: 2,
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }

  String _formatHour(int h) {
    final hour = h % 24;
    final suffix = hour < 12 ? 'am' : 'pm';
    final display = hour == 0
        ? 12
        : hour <= 12
            ? hour
            : hour - 12;
    return '$display $suffix';
  }

  Color _blockColor(String type) {
    switch (type) {
      case 'study':
        return Colors.indigo;
      case 'class':
        return Colors.deepPurple;
      case 'break':
        return Colors.teal;
      case 'exam_prep':
        return Colors.orange;
      case 'project_work':
        return Colors.blueGrey;
      case 'opportunity_prep':
        return Colors.pink;
      default:
        return Colors.blue;
    }
  }
}

class _GridPainter extends CustomPainter {
  final int dayCount;
  final int hourCount;

  _GridPainter({required this.dayCount, required this.hourCount});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 0.5;

    // Horizontal lines (hours)
    for (int i = 0; i <= hourCount; i++) {
      final y = i * _rowHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Vertical lines (days)
    for (int j = 0; j <= dayCount; j++) {
      final x = j * _colWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.dayCount != dayCount ||
        oldDelegate.hourCount != hourCount;
  }
}
