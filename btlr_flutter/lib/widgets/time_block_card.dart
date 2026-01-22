import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btlr_client/btlr_client.dart';
import '../providers/plan_provider.dart';

/// Reusable Time Block Card widget
class TimeBlockCard extends ConsumerWidget {
  final TimeBlock block;
  final bool showActions;
  final VoidCallback? onTap;

  const TimeBlockCard({
    super.key,
    required this.block,
    this.showActions = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final isCurrentBlock = now.isAfter(block.startTime) && now.isBefore(block.endTime);
    final isPast = now.isAfter(block.endTime);
    final progress = isCurrentBlock
        ? (now.difference(block.startTime).inMinutes / block.durationMinutes).clamp(0.0, 1.0)
        : isPast ? 1.0 : 0.0;

    Color statusColor;
    IconData statusIcon;

    if (block.completionStatus == 'completed') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (block.completionStatus == 'missed') {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else if (block.completionStatus == 'postponed') {
      statusColor = Colors.orange;
      statusIcon = Icons.schedule;
    } else if (isCurrentBlock) {
      statusColor = Colors.blue;
      statusIcon = Icons.play_circle;
    } else {
      statusColor = Colors.grey;
      statusIcon = Icons.circle_outlined;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isCurrentBlock 
          ? Theme.of(context).colorScheme.primaryContainer 
          : null,
      child: InkWell(
        onTap: onTap ?? () => _showBlockActions(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          block.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                decoration: block.completionStatus == 'completed'
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                        ),
                        Text(
                          '${_formatTime(block.startTime)} - ${_formatTime(block.endTime)} • ${block.durationMinutes} min',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _BlockTypeChip(type: block.blockType),
                ],
              ),
              if (block.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  block.description!,
                  style: TextStyle(color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (isCurrentBlock || isPast) ...[
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  color: statusColor,
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
                    Text(
                      'Energy: ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    ...List.generate(5, (i) => Icon(
                      i < block.energyLevel! 
                          ? Icons.battery_full 
                          : Icons.battery_0_bar,
                      size: 16,
                      color: i < block.energyLevel! ? Colors.green : Colors.grey[400],
                    )),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showBlockActions(BuildContext context, WidgetRef ref) {
    if (!showActions || block.completionStatus == 'completed') return;

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
            const SizedBox(height: 8),
            Text(
              '${_formatTime(block.startTime)} - ${_formatTime(block.endTime)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () async {
                final actions = ref.read(timeBlockActionsProvider);
                await actions.completeBlock(block.id!);
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
                await actions.missBlock(block.id!, 'User marked as missed');
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
      avatar: Icon(icon, size: 14, color: color),
      label: Text(
        type.replaceAll('_', ' '),
        style: const TextStyle(fontSize: 10),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}