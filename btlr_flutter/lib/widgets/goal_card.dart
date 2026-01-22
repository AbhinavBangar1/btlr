import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btlr_client/btlr_client.dart';
import '../providers/goals_provider.dart';

/// Reusable Goal Card widget
class GoalCard extends ConsumerWidget {
  final LearningGoal goal;
  final VoidCallback? onTap;
  final bool showActions;

  const GoalCard({
    super.key,
    required this.goal,
    this.onTap,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = goal.estimatedHours != null && goal.estimatedHours! > 0
        ? (goal.actualHours / goal.estimatedHours!).clamp(0.0, 1.0)
        : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap ?? () => _showGoalDetails(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _PriorityIndicator(priority: goal.priority),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                decoration: goal.status == 'completed'
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            _CategoryChip(category: goal.category),
                            const SizedBox(width: 8),
                            _StatusChip(status: goal.status),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (goal.description != null) ...[
                const SizedBox(height: 12),
                Text(
                  goal.description!,
                  style: TextStyle(color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (goal.estimatedHours != null) ...[
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _getProgressColor(progress),
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: _getProgressColor(progress),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${goal.actualHours.toStringAsFixed(1)} / ${goal.estimatedHours!.toStringAsFixed(1)} hours',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
              if (goal.deadline != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: _getDeadlineColor(goal.deadline!),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Due: ${_formatDate(goal.deadline!)}',
                      style: TextStyle(
                        color: _getDeadlineColor(goal.deadline!),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getDeadlineText(goal.deadline!),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
              if (goal.tags != null) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: _parseTags(goal.tags!).map((tag) => Chip(
                    label: Text(tag, style: const TextStyle(fontSize: 10)),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    backgroundColor: Colors.grey[200],
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showGoalDetails(BuildContext context, WidgetRef ref) {
    if (!showActions) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                goal.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _CategoryChip(category: goal.category),
                  const SizedBox(width: 8),
                  _StatusChip(status: goal.status),
                ],
              ),
              const SizedBox(height: 16),
              if (goal.description != null) ...[
                Text(goal.description!),
                const SizedBox(height: 16),
              ],
              if (goal.estimatedHours != null) ...[
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${goal.actualHours.toStringAsFixed(1)} / ${goal.estimatedHours!.toStringAsFixed(1)} hours',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              if (goal.deadline != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: _getDeadlineColor(goal.deadline!),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Due: ${_formatDate(goal.deadline!)}',
                      style: TextStyle(color: _getDeadlineColor(goal.deadline!)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (goal.status != 'completed')
                    FilledButton.icon(
                      onPressed: () async {
                        await ref.read(goalsProvider.notifier).completeGoal(goal.id!);
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Goal completed! 🎉')),
                          );
                        }
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Mark as Completed'),
                    ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await ref.read(goalsProvider.notifier).deleteGoal(goal.id!);
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Goal deleted')),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete Goal'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) return Colors.green;
    if (progress >= 0.5) return Colors.blue;
    if (progress >= 0.3) return Colors.orange;
    return Colors.red;
  }

  Color _getDeadlineColor(DateTime deadline) {
    final daysUntil = deadline.difference(DateTime.now()).inDays;
    if (daysUntil < 0) return Colors.red;
    if (daysUntil < 7) return Colors.orange;
    if (daysUntil < 30) return Colors.blue;
    return Colors.grey;
  }

  String _getDeadlineText(DateTime deadline) {
    final daysUntil = deadline.difference(DateTime.now()).inDays;
    if (daysUntil < 0) return '${-daysUntil} days overdue';
    if (daysUntil == 0) return 'Due today';
    if (daysUntil == 1) return 'Due tomorrow';
    if (daysUntil < 7) return 'in $daysUntil days';
    if (daysUntil < 30) return 'in ${(daysUntil / 7).floor()} weeks';
    return 'in ${(daysUntil / 30).floor()} months';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<String> _parseTags(String tags) {
    try {
      // Assuming tags is a JSON array string
      return tags.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',').map((e) => e.trim()).toList();
    } catch (e) {
      return [];
    }
  }
}

class _PriorityIndicator extends StatelessWidget {
  final String priority;

  const _PriorityIndicator({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (priority) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      default:
        color = Colors.green;
    }

    return Container(
      width: 4,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String category;

  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (category) {
      case 'technical_skill':
        icon = Icons.code;
        color = Colors.blue;
        break;
      case 'soft_skill':
        icon = Icons.people;
        color = Colors.green;
        break;
      case 'project':
        icon = Icons.work;
        color = Colors.purple;
        break;
      case 'certification':
        icon = Icons.verified;
        color = Colors.orange;
        break;
      default:
        icon = Icons.circle;
        color = Colors.grey;
    }

    return Chip(
      avatar: Icon(icon, size: 14, color: color),
      label: Text(
        category.replaceAll('_', ' '),
        style: const TextStyle(fontSize: 10),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case 'completed':
        color = Colors.green;
        label = 'Completed';
        break;
      case 'in_progress':
        color = Colors.blue;
        label = 'In Progress';
        break;
      case 'paused':
        color = Colors.orange;
        label = 'Paused';
        break;
      default:
        color = Colors.grey;
        label = 'Not Started';
    }

    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 10)),
      backgroundColor: color.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}