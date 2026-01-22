import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/plan_provider.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysPlanAsync = ref.watch(todaysPlanProvider);
    final todaysBlocksAsync = ref.watch(todaysBlocksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(todaysPlanProvider.notifier).reload();
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'regenerate') {
                await ref.read(todaysPlanProvider.notifier).regeneratePlan();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Plan regenerated!')),
                  );
                }
              } else if (value == 'generate') {
                await ref.read(todaysPlanProvider.notifier).generatePlan();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('New plan generated!')),
                  );
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'generate',
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome),
                    SizedBox(width: 8),
                    Text('Generate Plan'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'regenerate',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('Regenerate'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(todaysPlanProvider.notifier).reload(),
        child: todaysPlanAsync.when(
          data: (plan) {
            if (plan == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No plan for today',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Generate a plan to get started',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () async {
                        await ref.read(todaysPlanProvider.notifier).generatePlan();
                      },
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Generate Plan'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Plan Info Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Plan v${plan.version}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${plan.totalPlannedMinutes} min planned',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      if (plan.reasoning != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          plan.reasoning!,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (plan.adaptationNotes != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Adapted: ${plan.adaptationNotes}',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Time Blocks List
                Expanded(
                  child: todaysBlocksAsync.when(
                    data: (blocks) {
                      if (blocks.isEmpty) {
                        return const Center(
                          child: Text('No time blocks scheduled'),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: blocks.length,
                        itemBuilder: (context, index) {
                          final block = blocks[index];
                          final isFirst = index == 0;
                          final isLast = index == blocks.length - 1;
                          
                          return _TimeBlockCard(
                            block: block,
                            isFirst: isFirst,
                            isLast: isLast,
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(child: Text('Error: $error')),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeBlockCard extends ConsumerWidget {
  final dynamic block;
  final bool isFirst;
  final bool isLast;

  const _TimeBlockCard({
    required this.block,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final isCurrentBlock = now.isAfter(block.startTime) && now.isBefore(block.endTime);
    final isPast = now.isAfter(block.endTime);
    Color borderColor;
    IconData icon;
    Color iconColor;

    if (block.completionStatus == 'completed') {
      borderColor = Colors.green;
      icon = Icons.check_circle;
      iconColor = Colors.green;
    } else if (block.completionStatus == 'missed') {
      borderColor = Colors.red;
      icon = Icons.cancel;
      iconColor = Colors.red;
    } else if (block.completionStatus == 'postponed') {
      borderColor = Colors.orange;
      icon = Icons.schedule;
      iconColor = Colors.orange;
    } else if (isCurrentBlock) {
      borderColor = Colors.blue;
      icon = Icons.play_circle;
      iconColor = Colors.blue;
    } else if (isPast) {
      borderColor = Colors.grey;
      icon = Icons.circle_outlined;
      iconColor = Colors.grey;
    } else {
      borderColor = Colors.grey.shade300;
      icon = Icons.circle_outlined;
      iconColor = Colors.grey;
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : 12,
        left: 24,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Timeline
            Column(
              children: [
                Icon(icon, color: iconColor, size: 24),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: borderColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Card
            Expanded(
              child: Card(
                margin: EdgeInsets.zero,
                color: isCurrentBlock 
                    ? Theme.of(context).colorScheme.primaryContainer 
                    : null,
                child: InkWell(
                  onTap: () => _showBlockActions(context, ref),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                block.title,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      decoration: block.completionStatus == 'completed'
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                              ),
                            ),
                            _BlockTypeChip(type: block.blockType),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${_formatTime(block.startTime)} - ${_formatTime(block.endTime)}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${block.durationMinutes} min',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        if (block.description != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            block.description,
                            style: TextStyle(color: Colors.grey[700]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (block.actualDurationMinutes != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                'Actual: ${block.actualDurationMinutes} min',
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                        if (block.energyLevel != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              ...List.generate(5, (i) => Icon(
                                i < block.energyLevel 
                                    ? Icons.battery_full 
                                    : Icons.battery_0_bar,
                                size: 16,
                                color: Colors.grey[600],
                              )),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockActions(BuildContext context, WidgetRef ref) {
    if (block.completionStatus == 'completed') return;

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              block.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () async {
                final actions = ref.read(timeBlockActionsProvider);
                await actions.completeBlock(block.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Block completed! 🎉')),
                  );
                }
              },
              icon: const Icon(Icons.check),
              label: const Text('Mark as Completed'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                final actions = ref.read(timeBlockActionsProvider);
                await actions.missBlock(block.id, 'User marked as missed');
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Block marked as missed')),
                  );
                }
              },
              icon: const Icon(Icons.close),
              label: const Text('Mark as Missed'),
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

class _BlockTypeChip extends StatelessWidget {
  final String type;

  const _BlockTypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (type) {
      case 'study':
        color = Colors.blue;
        icon = Icons.book;
        break;
      case 'class':
        color = Colors.purple;
        icon = Icons.school;
        break;
      case 'break':
        color = Colors.green;
        icon = Icons.coffee;
        break;
      case 'exam_prep':
        color = Colors.orange;
        icon = Icons.quiz;
        break;
      case 'project_work':
        color = Colors.teal;
        icon = Icons.code;
        break;
      case 'opportunity_prep':
        color = Colors.pink;
        icon = Icons.star;
        break;
      default:
        color = Colors.grey;
        icon = Icons.circle;
    }

    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(type.replaceAll('_', ' '), style: const TextStyle(fontSize: 11)),
      backgroundColor: color.withValues(alpha: 0.2),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}