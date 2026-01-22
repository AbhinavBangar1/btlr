import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/opportunities_provider.dart';

class OpportunitiesScreen extends ConsumerStatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  ConsumerState<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends ConsumerState<OpportunitiesScreen> {
  String _selectedType = 'all'; // all, hackathon, internship, scholarship, workshop, competition
  String _selectedStatus = 'all'; // all, discovered, interested, applied

  @override
  Widget build(BuildContext context) {
    final opportunitiesAsync = ref.watch(opportunitiesProvider);
    final opportunityStatsAsync = ref.watch(opportunityStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(opportunitiesProvider.notifier).loadOpportunities();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Banner
          opportunityStatsAsync.when(
            data: (stats) => Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    label: 'Total',
                    value: '${stats['total']}',
                  ),
                  _StatItem(
                    label: 'High Relevance',
                    value: '${stats['highRelevance']}',
                  ),
                  _StatItem(
                    label: 'Applied',
                    value: '${(stats['byStatus'] as Map)['applied'] ?? 0}',
                  ),
                  _StatItem(
                    label: 'Upcoming',
                    value: '${stats['upcomingDeadlines']}',
                  ),
                ],
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const SizedBox(),
          ),

          // Filter Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Type',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: _selectedType == 'all',
                        onSelected: (selected) {
                          setState(() => _selectedType = 'all');
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Hackathons'),
                        selected: _selectedType == 'hackathon',
                        onSelected: (selected) {
                          setState(() => _selectedType = 'hackathon');
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Internships'),
                        selected: _selectedType == 'internship',
                        onSelected: (selected) {
                          setState(() => _selectedType = 'internship');
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Scholarships'),
                        selected: _selectedType == 'scholarship',
                        onSelected: (selected) {
                          setState(() => _selectedType = 'scholarship');
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Workshops'),
                        selected: _selectedType == 'workshop',
                        onSelected: (selected) {
                          setState(() => _selectedType = 'workshop');
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Competitions'),
                        selected: _selectedType == 'competition',
                        onSelected: (selected) {
                          setState(() => _selectedType = 'competition');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Status',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: _selectedStatus == 'all',
                      onSelected: (selected) {
                        setState(() => _selectedStatus = 'all');
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('New'),
                      selected: _selectedStatus == 'discovered',
                      onSelected: (selected) {
                        setState(() => _selectedStatus = 'discovered');
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Interested'),
                      selected: _selectedStatus == 'interested',
                      onSelected: (selected) {
                        setState(() => _selectedStatus = 'interested');
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Applied'),
                      selected: _selectedStatus == 'applied',
                      onSelected: (selected) {
                        setState(() => _selectedStatus = 'applied');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Opportunities List
          Expanded(
            child: opportunitiesAsync.when(
              data: (opportunities) {
                final filtered = _filterOpportunities(opportunities);
                
                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No opportunities found',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => ref.read(opportunitiesProvider.notifier).loadOpportunities(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final opportunity = filtered[index];
                      return _OpportunityCard(opportunity: opportunity);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddOpportunityDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Opportunity'),
      ),
    );
  }

  List<dynamic> _filterOpportunities(List<dynamic> opportunities) {
    var filtered = opportunities;

    if (_selectedType != 'all') {
      filtered = filtered.where((o) => o.type == _selectedType).toList();
    }

    if (_selectedStatus != 'all') {
      filtered = filtered.where((o) => o.status == _selectedStatus).toList();
    }

    // Sort by relevance score
    filtered.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

    return filtered;
  }

  void _showAddOpportunityDialog(BuildContext context) {
    final titleController = TextEditingController();
    final organizationController = TextEditingController();
    final urlController = TextEditingController();
    String type = 'hackathon';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Opportunity'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: organizationController,
                  decoration: const InputDecoration(labelText: 'Organization'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(labelText: 'URL'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: const [
                    DropdownMenuItem(value: 'hackathon', child: Text('Hackathon')),
                    DropdownMenuItem(value: 'internship', child: Text('Internship')),
                    DropdownMenuItem(value: 'scholarship', child: Text('Scholarship')),
                    DropdownMenuItem(value: 'workshop', child: Text('Workshop')),
                    DropdownMenuItem(value: 'competition', child: Text('Competition')),
                  ],
                  onChanged: (value) => setState(() => type = value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                if (titleController.text.isEmpty) return;

                await ref.read(opportunitiesProvider.notifier).createOpportunity(
                  title: titleController.text,
                  type: type,
                  organization: organizationController.text.isEmpty 
                      ? null 
                      : organizationController.text,
                  sourceUrl: urlController.text.isEmpty 
                      ? null 
                      : urlController.text,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opportunity added!')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _OpportunityCard extends ConsumerWidget {
  final dynamic opportunity;

  const _OpportunityCard({required this.opportunity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showOpportunityDetails(context, ref),
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
                        if (opportunity.organization != null)
                          Text(
                            opportunity.organization!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                      ],
                    ),
                  ),
                  _RelevanceIndicator(score: opportunity.relevanceScore),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _TypeChip(type: opportunity.type),
                  const SizedBox(width: 8),
                  _StatusChip(status: opportunity.status),
                ],
              ),
              if (opportunity.deadline != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Deadline: ${_formatDate(opportunity.deadline)}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
              if (opportunity.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  opportunity.description!,
                  style: TextStyle(color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showOpportunityDetails(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                opportunity.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (opportunity.organization != null) ...[
                const SizedBox(height: 4),
                Text(
                  opportunity.organization!,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  _TypeChip(type: opportunity.type),
                  const SizedBox(width: 8),
                  _StatusChip(status: opportunity.status),
                  const Spacer(),
                  _RelevanceIndicator(score: opportunity.relevanceScore),
                ],
              ),
              const SizedBox(height: 16),
              if (opportunity.description != null) ...[
                Text(opportunity.description!),
                const SizedBox(height: 16),
              ],
              if (opportunity.deadline != null) ...[
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 20),
                    const SizedBox(width: 8),
                    Text('Deadline: ${_formatDate(opportunity.deadline)}'),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (opportunity.status == 'discovered')
                    FilledButton.icon(
                      onPressed: () async {
                        await ref.read(opportunitiesProvider.notifier)
                            .updateStatus(opportunity.id, 'interested');
                        if (context.mounted) Navigator.pop(context);
                      },
                      icon: const Icon(Icons.favorite),
                      label: const Text('Mark as Interested'),
                    ),
                  if (opportunity.status == 'interested') ...[
                    FilledButton.icon(
                      onPressed: () async {
                        await ref.read(opportunitiesProvider.notifier)
                            .updateStatus(opportunity.id, 'applied');
                        if (context.mounted) Navigator.pop(context);
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Mark as Applied'),
                    ),
                    const SizedBox(height: 8),
                  ],
                  OutlinedButton.icon(
                    onPressed: () async {
                      await ref.read(opportunitiesProvider.notifier)
                          .updateStatus(opportunity.id, 'ignored');
                      if (context.mounted) Navigator.pop(context);
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
      avatar: Icon(icon, size: 16, color: color),
      label: Text(type, style: const TextStyle(fontSize: 12)),
      backgroundColor: color.withValues(alpha : 0.1),
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
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: color.withValues(alpha : 0.2),
      labelStyle: TextStyle(color: color),
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
        color: color.withValues(alpha : 0.2),
        borderRadius: BorderRadius.circular(12),
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