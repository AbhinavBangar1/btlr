import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_provider.dart';
import '../providers/plan_provider.dart';
import '../providers/behavior_provider.dart';
import '../providers/goals_provider.dart';
// import '../providers/opportunities_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentProfileProvider);
    final todaysPlanAsync = ref.watch(todaysPlanProvider);
    final currentBlockAsync = ref.watch(currentBlockProvider);
    final completionStatsAsync = ref.watch(defaultCompletionStatsProvider);
    final streakAsync = ref.watch(streakInfoProvider);
    final activeGoals = ref.watch(activeGoalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(todaysPlanProvider.notifier).reload();
              ref.invalidate(currentBlockProvider);
              ref.invalidate(defaultCompletionStatsProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(todaysPlanProvider.notifier).reload();
          ref.invalidate(currentBlockProvider);
          ref.invalidate(defaultCompletionStatsProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              studentAsync.when(
                data: (student) => student != null
                    ? Text(
                        'Welcome back, ${student.name}! 👋',
                        style: Theme.of(context).textTheme.headlineSmall,
                      )
                    : const SizedBox(),
                loading: () => const CircularProgressIndicator(),
                error: (_, _) => const SizedBox(),
              ),
              const SizedBox(height: 24),

              // Current Block Card
              currentBlockAsync.when(
                data: (block) => block != null
                    ? _CurrentBlockCard(block: block)
                    : Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green[400], size: 32),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Text(
                                  'No current block - You\'re all caught up!',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                loading: () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (_, _) => const SizedBox(),
              ),
              const SizedBox(height: 24),

              // Stats Row
              Row(
                children: [
                  // Completion Rate
                  Expanded(
                    child: completionStatsAsync.when(
                      data: (stats) => _StatCard(
                        title: 'Completion Rate',
                        value: '${((stats['completionRate'] as double) * 100).toStringAsFixed(0)}%',
                        icon: Icons.check_circle_outline,
                        color: Colors.blue,
                      ),
                      loading: () => const _StatCardLoading(),
                      error: (_, _) => const _StatCard(
                        title: 'Completion Rate',
                        value: '--',
                        icon: Icons.check_circle_outline,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Streak
                  Expanded(
                    child: streakAsync.when(
                      data: (streak) => _StatCard(
                        title: 'Current Streak',
                        value: '${streak['currentStreak']} days',
                        icon: Icons.local_fire_department,
                        color: Colors.orange,
                      ),
                      loading: () => const _StatCardLoading(),
                      error: (_, _) => const _StatCard(
                        title: 'Current Streak',
                        value: '--',
                        icon: Icons.local_fire_department,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  // Active Goals
                  Expanded(
                    child: _StatCard(
                      title: 'Active Goals',
                      value: '${activeGoals.length}',
                      icon: Icons.flag,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Today's Plan
                  Expanded(
                    child: todaysPlanAsync.when(
                      data: (plan) => _StatCard(
                        title: 'Planned Today',
                        value: plan != null ? '${plan.totalPlannedMinutes} min' : '--',
                        icon: Icons.today,
                        color: Colors.purple,
                      ),
                      loading: () => const _StatCardLoading(),
                      error: (_, _) => const _StatCard(
                        title: 'Planned Today',
                        value: '--',
                        icon: Icons.today,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _QuickActionButton(
                    label: 'Generate Plan',
                    icon: Icons.auto_awesome,
                    onPressed: () async {
                      await ref.read(todaysPlanProvider.notifier).generatePlan();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Plan generated!')),
                        );
                      }
                    },
                  ),
                  _QuickActionButton(
                    label: 'Add Goal',
                    icon: Icons.add_task,
                    onPressed: () {
                      // Navigate to goals screen
                    },
                  ),
                  _QuickActionButton(
                    label: 'View Schedule',
                    icon: Icons.calendar_today,
                    onPressed: () {
                      // Navigate to schedule screen
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrentBlockCard extends ConsumerWidget {
  final dynamic block;

  const _CurrentBlockCard({required this.block});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final progress = (now.difference(block.startTime).inMinutes / block.durationMinutes).clamp(0.0, 1.0);

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.play_circle_filled,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Block',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        block.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_formatTime(block.startTime)} - ${_formatTime(block.endTime)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${block.durationMinutes} min',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      final actions = ref.read(timeBlockActionsProvider);
                      await actions.completeBlock(block.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Block completed! 🎉')),
                        );
                      }
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Complete'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final actions = ref.read(timeBlockActionsProvider);
                      await actions.missBlock(block.id, 'User marked as missed');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Block marked as missed')),
                        );
                      }
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('Miss'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCardLoading extends StatelessWidget {
  const _StatCardLoading();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}