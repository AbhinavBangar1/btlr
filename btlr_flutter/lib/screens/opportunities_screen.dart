import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/opportunities_provider.dart';

// --- BRAND CONSTANTS ---
const Color kPrimaryBlue = Color(0xFF274B7F); // BTLR Sapphire
const Color kBackgroundWhite = Color(0xFFFFFFFF);
const Color kSapphireTintFill = Color(0xFFF1F5F9); // Premium light blue tint
const double kBorderRadius = 24.0;

class OpportunitiesScreen extends ConsumerStatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  ConsumerState<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends ConsumerState<OpportunitiesScreen> {
  String _selectedType = 'all';
  String _selectedStatus = 'all';

  @override
  Widget build(BuildContext context) {
    final opportunitiesAsync = ref.watch(opportunitiesProvider);
    final opportunityStatsAsync = ref.watch(opportunityStatsProvider);

    return Scaffold(
      backgroundColor: kBackgroundWhite,
      // 1. ELEGANT BRANDING HEADER
      appBar: AppBar(
        backgroundColor: kBackgroundWhite,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 90,
        title: Column(
          children: [
            const Text(
              "BTLR",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: kPrimaryBlue,
                letterSpacing: -2,
              ),
            ),
            Text(
              "GLOBAL OPPORTUNITIES",
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 3,
                color: kPrimaryBlue.withOpacity(0.5),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: kPrimaryBlue),
            onPressed: () => ref.read(opportunitiesProvider.notifier).loadOpportunities(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 2. STATS BANNER
          _StaggeredEntrance(
            delayIndex: 0,
            child: opportunityStatsAsync.when(
              data: (stats) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kSapphireTintFill,
                  borderRadius: BorderRadius.circular(kBorderRadius),
                  border: Border.all(color: kPrimaryBlue.withOpacity(0.05)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(label: 'TOTAL', value: '${stats['total']}'),
                    _StatItem(label: 'RELEVANT', value: '${stats['highRelevance']}'),
                    _StatItem(label: 'APPLIED', value: '${(stats['byStatus'] as Map)['applied'] ?? 0}'),
                    _StatItem(label: 'URGENT', value: '${stats['upcomingDeadlines']}'),
                  ],
                ),
              ),
              loading: () => const LinearProgressIndicator(color: kPrimaryBlue),
              error: (_, __) => const SizedBox(),
            ),
          ),

          // 3. FILTER SECTION
          _StaggeredEntrance(
            delayIndex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel(title: 'TYPE'),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _FilterChip(label: 'ALL', isSelected: _selectedType == 'all', onTap: () => setState(() => _selectedType = 'all')),
                        const SizedBox(width: 8),
                        _FilterChip(label: 'HACKATHONS', isSelected: _selectedType == 'hackathon', onTap: () => setState(() => _selectedType = 'hackathon')),
                        const SizedBox(width: 8),
                        _FilterChip(label: 'INTERNSHIPS', isSelected: _selectedType == 'internship', onTap: () => setState(() => _selectedType = 'internship')),
                        const SizedBox(width: 8),
                        _FilterChip(label: 'SCHOLARSHIPS', isSelected: _selectedType == 'scholarship', onTap: () => setState(() => _selectedType = 'scholarship')),
                        const SizedBox(width: 8),
                        _FilterChip(label: 'WORKSHOPS', isSelected: _selectedType == 'workshop', onTap: () => setState(() => _selectedType = 'workshop')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _SectionLabel(title: 'STATUS'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _FilterChip(label: 'ALL', isSelected: _selectedStatus == 'all', onTap: () => setState(() => _selectedStatus = 'all')),
                      const SizedBox(width: 8),
                      _FilterChip(label: 'NEW', isSelected: _selectedStatus == 'discovered', onTap: () => setState(() => _selectedStatus = 'discovered')),
                      const SizedBox(width: 8),
                      _FilterChip(label: 'INTERESTED', isSelected: _selectedStatus == 'interested', onTap: () => setState(() => _selectedStatus = 'interested')),
                      const SizedBox(width: 8),
                      _FilterChip(label: 'APPLIED', isSelected: _selectedStatus == 'applied', onTap: () => setState(() => _selectedStatus = 'applied')),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 4. OPPORTUNITIES LIST
          Expanded(
            child: opportunitiesAsync.when(
              data: (opportunities) {
                final filtered = _filterOpportunities(opportunities);
                if (filtered.isEmpty) return const _EmptyOpportunitiesState();

                return RefreshIndicator(
                  color: kPrimaryBlue,
                  onRefresh: () => ref.read(opportunitiesProvider.notifier).loadOpportunities(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _StaggeredEntrance(
                        delayIndex: index + 2,
                        child: _OpportunityCard(opportunity: filtered[index]),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryBlue)),
              error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: kPrimaryBlue))),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryBlue,
        onPressed: () => _showAddOpportunityDialog(context),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('ADD OPPORTUNITY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
      ),
    );
  }

  // --- LOGIC METHODS ---
  List<dynamic> _filterOpportunities(List<dynamic> opportunities) {
    var filtered = opportunities;
    if (_selectedType != 'all') filtered = filtered.where((o) => o.type == _selectedType).toList();
    if (_selectedStatus != 'all') filtered = filtered.where((o) => o.status == _selectedStatus).toList();
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('NEW OPPORTUNITY', style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.w900, letterSpacing: 1)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'TITLE')),
                const SizedBox(height: 16),
                TextField(controller: organizationController, decoration: const InputDecoration(labelText: 'ORGANIZATION')),
                const SizedBox(height: 16),
                TextField(controller: urlController, decoration: const InputDecoration(labelText: 'URL')),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'TYPE'),
                  items: const [
                    DropdownMenuItem(value: 'hackathon', child: Text('Hackathon')),
                    DropdownMenuItem(value: 'internship', child: Text('Internship')),
                    DropdownMenuItem(value: 'scholarship', child: Text('Scholarship')),
                    DropdownMenuItem(value: 'workshop', child: Text('Workshop')),
                    DropdownMenuItem(value: 'competition', child: Text('Competition')),
                  ],
                  onChanged: (v) => setState(() => type = v!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: kPrimaryBlue),
              onPressed: () async {
                if (titleController.text.isEmpty) return;
                await ref.read(opportunitiesProvider.notifier).createOpportunity(
                  title: titleController.text,
                  type: type,
                  organization: organizationController.text.isEmpty ? null : organizationController.text,
                  sourceUrl: urlController.text.isEmpty ? null : urlController.text,
                );
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('ADD'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- OPPORTUNITY CARD (With Shimmer logic) ---
class _OpportunityCard extends ConsumerWidget {
  final dynamic opportunity;
  const _OpportunityCard({required this.opportunity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isHighlyRelevant = opportunity.relevanceScore >= 0.9;

    Widget cardContent = Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kSapphireTintFill,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: kPrimaryBlue.withOpacity(0.05)),
      ),
      child: InkWell(
        onTap: () => _showOpportunityDetails(context, ref, opportunity),
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(opportunity.title.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue, fontSize: 16, letterSpacing: -0.2)),
                        if (opportunity.organization != null)
                          Text(opportunity.organization!.toUpperCase(),
                              style: TextStyle(color: kPrimaryBlue.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      ],
                    ),
                  ),
                  _ExecutiveRelevanceIndicator(score: opportunity.relevanceScore),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _StatusChip(status: opportunity.status),
                  const SizedBox(width: 8),
                  _TypeBadge(type: opportunity.type),
                ],
              ),
              if (opportunity.deadline != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 14, color: kPrimaryBlue.withOpacity(0.5)),
                    const SizedBox(width: 6),
                    Text('DEADLINE: ${_formatDate(opportunity.deadline)}',
                        style: TextStyle(color: kPrimaryBlue.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.w800)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );

    return isHighlyRelevant ? _RelevanceShimmer(child: cardContent) : cardContent;
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

// --- ALL HELPER COMPONENTS ---

class _StatItem extends StatelessWidget {
  final String label, value;
  const _StatItem({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: kPrimaryBlue)),
    Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: kPrimaryBlue.withOpacity(0.4), letterSpacing: 1)),
  ]);
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: isSelected ? kPrimaryBlue : kSapphireTintFill, borderRadius: BorderRadius.circular(30)),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.white : kPrimaryBlue, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1)),
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});
  @override
  Widget build(BuildContext context) => Text(title, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: kPrimaryBlue.withOpacity(0.5), letterSpacing: 2.5));
}

class _TypeBadge extends StatelessWidget {
  final String type;
  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (type.toLowerCase()) {
      case 'hackathon': icon = Icons.code_rounded; color = Colors.purple; break;
      case 'internship': icon = Icons.work_outline_rounded; color = Colors.blue; break;
      case 'scholarship': icon = Icons.school_rounded; color = Colors.green; break;
      case 'workshop': icon = Icons.group_rounded; color = Colors.orange; break;
      case 'competition': icon = Icons.emoji_events_rounded; color = Colors.amber; break;
      default: icon = Icons.circle_rounded; color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(type.toUpperCase(), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900)),
        ],
      ),
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

    switch (status.toLowerCase()) {
      case 'discovered': color = Colors.blue; label = 'NEW'; break;
      case 'interested': color = Colors.orange; label = 'INTERESTED'; break;
      case 'applied': color = Colors.green; label = 'APPLIED'; break;
      case 'accepted': color = Colors.teal; label = 'ACCEPTED'; break;
      case 'rejected': color = Colors.red; label = 'REJECTED'; break;
      default: color = Colors.grey; label = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900)),
    );
  }
}

class _ExecutiveRelevanceIndicator extends StatelessWidget {
  final double score;
  const _ExecutiveRelevanceIndicator({required this.score});

  @override
  Widget build(BuildContext context) {
    final percentage = (score * 100).toInt();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: kPrimaryBlue, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text('$percentage%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10)),
        ],
      ),
    );
  }
}

// --- SHIMMER & ANIMATION WRAPPERS ---

class _RelevanceShimmer extends StatefulWidget {
  final Widget child;
  const _RelevanceShimmer({required this.child});
  @override
  State<_RelevanceShimmer> createState() => _RelevanceShimmerState();
}

class _RelevanceShimmerState extends State<_RelevanceShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Colors.transparent, Colors.white.withOpacity(0.4), Colors.transparent],
            stops: [0.0, _controller.value, 1.0],
          ).createShader(bounds),
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

class _StaggeredEntrance extends StatefulWidget {
  final Widget child;
  final int delayIndex;
  const _StaggeredEntrance({required this.child, required this.delayIndex});
  @override
  State<_StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<_StaggeredEntrance> {
  bool _visible = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 150 * widget.delayIndex), () { if (mounted) setState(() => _visible = true); });
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 1000),
      opacity: _visible ? 1.0 : 0.0,
      curve: Curves.easeOutQuart,
      child: AnimatedPadding(duration: const Duration(milliseconds: 1000), curve: Curves.easeOutQuart, padding: EdgeInsets.only(top: _visible ? 0 : 25), child: widget.child),
    );
  }
}

class _EmptyOpportunitiesState extends StatelessWidget {
  const _EmptyOpportunitiesState();
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.search_off_rounded, size: 64, color: kPrimaryBlue), const SizedBox(height: 16), const Text("NO MATCHING OPPORTUNITIES", style: TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue, letterSpacing: 1))]));
}

// --- DETAILS MODAL ---
void _showOpportunityDetails(BuildContext context, WidgetRef ref, dynamic opportunity) {
  showModalBottomSheet(
    context: context,
    backgroundColor: kBackgroundWhite,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(opportunity.title.toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: kPrimaryBlue)),
            const SizedBox(height: 8),
            if (opportunity.organization != null)
              Text(opportunity.organization!.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            const SizedBox(height: 24),
            Row(
              children: [
                _StatusChip(status: opportunity.status),
                const Spacer(),
                _ExecutiveRelevanceIndicator(score: opportunity.relevanceScore),
              ],
            ),
            const SizedBox(height: 24),
            if (opportunity.description != null)
              Text(opportunity.description!, style: TextStyle(color: kPrimaryBlue.withOpacity(0.7), fontSize: 16)),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (opportunity.status == 'discovered')
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: kPrimaryBlue, padding: const EdgeInsets.symmetric(vertical: 18)),
                    onPressed: () async {
                      await ref.read(opportunitiesProvider.notifier).updateStatus(opportunity.id, 'interested');
                      if (context.mounted) Navigator.pop(context);
                    },
                    icon: const Icon(Icons.favorite_rounded),
                    label: const Text('MARK AS INTERESTED'),
                  ),
                if (opportunity.status == 'interested')
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 18)),
                    onPressed: () async {
                      await ref.read(opportunitiesProvider.notifier).updateStatus(opportunity.id, 'applied');
                      if (context.mounted) Navigator.pop(context);
                    },
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('MARK AS APPLIED'),
                  ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(foregroundColor: kPrimaryBlue, padding: const EdgeInsets.symmetric(vertical: 18)),
                  onPressed: () async {
                    await ref.read(opportunitiesProvider.notifier).updateStatus(opportunity.id, 'ignored');
                    if (context.mounted) Navigator.pop(context);
                  },
                  icon: const Icon(Icons.block_rounded),
                  label: const Text('IGNORE'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}