import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btlr_client/btlr_client.dart';
import '../providers/opportunities_provider.dart';

/// Reusable Opportunity Card widget
class OpportunityCard extends ConsumerWidget {
  final Opportunity opportunity;
  final VoidCallback? onTap;
  final bool showActions;

  const OpportunityCard({
    super.key,
    required this.opportunity,
    this.onTap,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap ?? () => _showOpportunityDetails(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opportunity.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (opportunity.organization != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.business, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  opportunity.organization!,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  _RelevanceIndicator(score: opportunity.relevanceScore),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _TypeChip(type: opportunity.type),
                  const SizedBox(width: 8),
                  _StatusChip(status: opportunity.status),
                ],
              ),
              if (opportunity.description != null) ...[
                const SizedBox(height: 12),
                Text(
                  opportunity.description!,
                  style: TextStyle(color: Colors.grey[700]),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (opportunity.deadline != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getDeadlineColor(opportunity.deadline!).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: _getDeadlineColor(opportunity.deadline!),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Deadline: ${_formatDate(opportunity.deadline!)}',
                        style: TextStyle(
                          color: _getDeadlineColor(opportunity.deadline!),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getDeadlineText(opportunity.deadline!),
                        style: TextStyle(
                          color: _getDeadlineColor(opportunity.deadline!),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (opportunity.prepTimeMinutes != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Prep time: ${opportunity.prepTimeMinutes} min',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showOpportunityDetails(BuildContext context, WidgetRef ref) {
    if (!showActions) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      opportunity.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  _RelevanceIndicator(score: opportunity.relevanceScore),
                ],
              ),
              if (opportunity.organization != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.business, size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      opportunity.organization!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  _TypeChip(type: opportunity.type),
                  const SizedBox(width: 8),
                  _StatusChip(status: opportunity.status),
                ],
              ),
              if (opportunity.description != null) ...[
                const SizedBox(height: 16),
                Text(
                  opportunity.description!,
                  style: const TextStyle(height: 1.5),
                ),
              ],
              const SizedBox(height: 16),
              if (opportunity.deadline != null)
                _InfoRow(
                  icon: Icons.calendar_today,
                  label: 'Deadline',
                  value: '${_formatDate(opportunity.deadline!)} (${_getDeadlineText(opportunity.deadline!)})',
                  color: _getDeadlineColor(opportunity.deadline!),
                ),
              if (opportunity.prepTimeMinutes != null)
                _InfoRow(
                  icon: Icons.timer,
                  label: 'Prep Time',
                  value: '${opportunity.prepTimeMinutes} minutes',
                ),
              if (opportunity.sourceUrl != null)
                _InfoRow(
                  icon: Icons.link,
                  label: 'Source',
                  value: opportunity.sourceUrl!,
                  isUrl: true,
                ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (opportunity.status == 'discovered')
                    FilledButton.icon(
                      onPressed: () async {
                        await ref.read(opportunitiesProvider.notifier)
                            .updateStatus(opportunity.id!, 'interested');
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Marked as interested')),
                          );
                        }
                      },
                      icon: const Icon(Icons.favorite),
                      label: const Text('Mark as Interested'),
                    ),
                  if (opportunity.status == 'interested') ...[
                    FilledButton.icon(
                      onPressed: () async {
                        await ref.read(opportunitiesProvider.notifier)
                            .updateStatus(opportunity.id!, 'applied');
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Marked as applied! 🎉')),
                          );
                        }
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Mark as Applied'),
                    ),
                    const SizedBox(height: 8),
                  ],
                  OutlinedButton.icon(
                    onPressed: () async {
                      await ref.read(opportunitiesProvider.notifier)
                          .updateStatus(opportunity.id!, 'ignored');
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opportunity ignored')),
                        );
                      }
                    },
                    icon: const Icon(Icons.block),
                    label: const Text('Ignore'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDeadlineColor(DateTime deadline) {
    final daysUntil = deadline.difference(DateTime.now()).inDays;
    if (daysUntil < 0) return Colors.red;
    if (daysUntil < 7) return Colors.orange;
    if (daysUntil < 30) return Colors.blue;
    return Colors.green;
  }

  String _getDeadlineText(DateTime deadline) {
    final daysUntil = deadline.difference(DateTime.now()).inDays;
    if (daysUntil < 0) return 'overdue';
    if (daysUntil == 0) return 'today';
    if (daysUntil == 1) return 'tomorrow';
    if (daysUntil < 7) return 'in $daysUntil days';
    return 'in ${(daysUntil / 7).ceil()} weeks';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _TypeChip extends StatelessWidget {
  final String type;

  const _TypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (type) {
      case 'hackathon':
        icon = Icons.code;
        color = Colors.purple;
        break;
      case 'internship':
        icon = Icons.work;
        color = Colors.blue;
        break;
      case 'scholarship':
        icon = Icons.school;
        color = Colors.green;
        break;
      case 'workshop':
        icon = Icons.group;
        color = Colors.orange;
        break;
      case 'competition':
        icon = Icons.emoji_events;
        color = Colors.amber;
        break;
      default:
        icon = Icons.circle;
        color = Colors.grey;
    }

    return Chip(
      avatar: Icon(icon, size: 14, color: color),
      label: Text(type, style: const TextStyle(fontSize: 10)),
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
      case 'discovered':
        color = Colors.blue;
        label = 'New';
        break;
      case 'interested':
        color = Colors.orange;
        label = 'Interested';
        break;
      case 'applied':
        color = Colors.green;
        label = 'Applied';
        break;
      case 'accepted':
        color = Colors.teal;
        label = 'Accepted';
        break;
      case 'rejected':
        color = Colors.red;
        label = 'Rejected';
        break;
      default:
        color = Colors.grey;
        label = status;
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

class _RelevanceIndicator extends StatelessWidget {
  final double score;

  const _RelevanceIndicator({required this.score});

  @override
  Widget build(BuildContext context) {
    final percentage = (score * 100).toInt();
    Color color;

    if (score >= 0.7) {
      color = Colors.green;
    } else if (score >= 0.4) {
      color = Colors.orange;
    } else {
      color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '$percentage%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;
  final bool isUrl;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
    this.isUrl = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color ?? Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: color ?? Colors.grey[900],
                    decoration: isUrl ? TextDecoration.underline : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}