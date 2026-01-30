import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/goals_provider.dart';
import 'package:intl/intl.dart';

// --- BRAND CONSTANTS ---
const Color kPrimaryBlue = Color(0xFF274B7F);
const Color kBackgroundWhite = Color(0xFFFFFFFF);
const Color kSapphireTintFill = Color(0xFFF1F5F9);
const double kBorderRadius = 24.0;

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final goalsAsync = ref.watch(goalsProvider);
    final goalStatsAsync = ref.watch(goalStatsProvider);

    return Scaffold(
      backgroundColor: kBackgroundWhite,
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
              "LEARNING GOALS",
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
            onPressed: () => ref.read(goalsProvider.notifier).loadGoals(),
          ),
        ],
      ),
      body: Column(
        children: [
          _StaggeredEntrance(
            delayIndex: 0,
            child: goalStatsAsync.when(
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
                    _StatItem(label: 'TOTAL', value: '${stats['totalGoals']}'),
                    _StatItem(label: 'ACTIVE', value: '${stats['inProgress']}'),
                    _StatItem(label: 'DONE', value: '${stats['completed']}'),
                    _StatItem(
                        label: 'RATE',
                        value: '${((stats['completionRate'] as double) * 100).toStringAsFixed(0)}%'
                    ),
                  ],
                ),
              ),
              loading: () => const LinearProgressIndicator(color: kPrimaryBlue),
              error: (_, __) => const SizedBox(),
            ),
          ),

          _StaggeredEntrance(
            delayIndex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'ALL',
                    isSelected: _selectedFilter == 'all',
                    onTap: () => setState(() => _selectedFilter = 'all'),
                  ),
                  const SizedBox(width: 12),
                  _FilterChip(
                    label: 'ACTIVE',
                    isSelected: _selectedFilter == 'active',
                    onTap: () => setState(() => _selectedFilter = 'active'),
                  ),
                  const SizedBox(width: 12),
                  _FilterChip(
                    label: 'COMPLETED',
                    isSelected: _selectedFilter == 'completed',
                    onTap: () => setState(() => _selectedFilter = 'completed'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: goalsAsync.when(
              data: (goals) {
                final filteredGoals = _filterGoals(goals);
                if (filteredGoals.isEmpty) return _EmptyGoalsState();

                return RefreshIndicator(
                  color: kPrimaryBlue,
                  onRefresh: () => ref.read(goalsProvider.notifier).loadGoals(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: filteredGoals.length,
                    itemBuilder: (context, index) {
                      return _StaggeredEntrance(
                        delayIndex: index + 2,
                        child: _GoalCard(goal: filteredGoals[index]),
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
        onPressed: () => _showAddGoalDialog(context),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
            'ADD GOAL',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5)
        ),
      ),
    );
  }

  List<dynamic> _filterGoals(List<dynamic> goals) {
    switch (_selectedFilter) {
      case 'active':
        return goals.where((g) => g.status == 'in_progress' || g.status == 'not_started').toList();
      case 'completed':
        return goals.where((g) => g.status == 'completed').toList();
      default:
        return goals;
    }
  }

  void _showAddGoalDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final estimatedHoursController = TextEditingController();
    
    String category = 'technical_skill';
    String priority = 'medium';
    DateTime? selectedDeadline;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: kBackgroundWhite,
          title: const Text(
              'NEW LEARNING GOAL',
              style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.w900, letterSpacing: 1)
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  cursorColor: kPrimaryBlue,
                  decoration: InputDecoration(
                    labelText: 'TITLE*',
                    labelStyle: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
                    hintText: 'e.g., Mastering Flutter',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: kPrimaryBlue.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                TextField(
                  controller: descriptionController,
                  cursorColor: kPrimaryBlue,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'DESCRIPTION',
                    labelStyle: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
                    hintText: 'What do you want to achieve?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: kPrimaryBlue.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: InputDecoration(
                    labelText: 'CATEGORY',
                    labelStyle: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: kPrimaryBlue.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'technical_skill', child: Text('Technical Skill')),
                    DropdownMenuItem(value: 'project', child: Text('Project')),
                    DropdownMenuItem(value: 'certification', child: Text('Certification')),
                    DropdownMenuItem(value: 'soft_skill', child: Text('Soft Skill')),
                  ],
                  onChanged: (v) => setState(() => category = v!),
                ),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<String>(
                  value: priority,
                  decoration: InputDecoration(
                    labelText: 'PRIORITY',
                    labelStyle: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: kPrimaryBlue.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'high', child: Text('High')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                  ],
                  onChanged: (v) => setState(() => priority = v!),
                ),
                const SizedBox(height: 16),
                
                TextField(
                  controller: estimatedHoursController,
                  cursorColor: kPrimaryBlue,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'ESTIMATED HOURS',
                    labelStyle: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
                    hintText: 'e.g., 10',
                    suffixIcon: const Icon(Icons.access_time_rounded, color: kPrimaryBlue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: kPrimaryBlue.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDeadline ?? DateTime.now().add(const Duration(days: 7)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: kPrimaryBlue,
                              onPrimary: Colors.white,
                              onSurface: kPrimaryBlue,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() => selectedDeadline = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimaryBlue.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, color: kPrimaryBlue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DEADLINE',
                                style: TextStyle(
                                  color: kPrimaryBlue.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                selectedDeadline != null
                                    ? DateFormat('MMM dd, yyyy').format(selectedDeadline!)
                                    : 'No deadline set',
                                style: TextStyle(
                                  color: selectedDeadline != null ? kPrimaryBlue : kPrimaryBlue.withOpacity(0.4),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (selectedDeadline != null)
                          IconButton(
                            icon: Icon(Icons.clear_rounded, color: kPrimaryBlue.withOpacity(0.5)),
                            onPressed: () => setState(() => selectedDeadline = null),
                          ),
                      ],
                    ),
                  ),
                ),
                
                if (selectedDeadline != null) ...[
                  const SizedBox(height: 8),
                  _DeadlineUrgencyIndicator(deadline: selectedDeadline!),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL', style: TextStyle(color: kPrimaryBlue)),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: kPrimaryBlue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () async {
                if (titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a goal title'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                double? estimatedHours;
                if (estimatedHoursController.text.isNotEmpty) {
                  estimatedHours = double.tryParse(estimatedHoursController.text);
                  if (estimatedHours == null || estimatedHours <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid number for estimated hours'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                }

                await ref.read(goalsProvider.notifier).createGoal(
                  title: titleController.text,
                  category: category,
                  priority: priority,
                  description: descriptionController.text.isEmpty ? null : descriptionController.text,
                  estimatedHours: estimatedHours,
                  deadline: selectedDeadline,
                );
                
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('ADD GOAL', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditGoalDialog(BuildContext context, dynamic goal) {
    final titleController = TextEditingController(text: goal.title);
    final descriptionController = TextEditingController(text: goal.description ?? '');
    final estimatedHoursController = TextEditingController(
      text: goal.estimatedHours != null ? goal.estimatedHours.toString() : '',
    );
    
    String category = goal.category;
    String priority = goal.priority;
    DateTime? selectedDeadline = goal.deadline;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: kBackgroundWhite,
          title: const Text(
              'EDIT GOAL',
              style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.w900, letterSpacing: 1)
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  cursorColor: kPrimaryBlue,
                  decoration: InputDecoration(
                    labelText: 'TITLE*',
                    labelStyle: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: kPrimaryBlue.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                TextField(
                  controller: descriptionController,
                  cursorColor: kPrimaryBlue,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'DESCRIPTION',
                    labelStyle: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: kPrimaryBlue.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<String>(
                  value: priority,
                  decoration: InputDecoration(
                    labelText: 'PRIORITY',
                    labelStyle: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: kPrimaryBlue.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'high', child: Text('High')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                  ],
                  onChanged: (v) => setState(() => priority = v!),
                ),
                const SizedBox(height: 16),
                
                TextField(
                  controller: estimatedHoursController,
                  cursorColor: kPrimaryBlue,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'ESTIMATED HOURS',
                    labelStyle: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
                    suffixIcon: const Icon(Icons.access_time_rounded, color: kPrimaryBlue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: kPrimaryBlue.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDeadline ?? DateTime.now().add(const Duration(days: 7)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: kPrimaryBlue,
                              onPrimary: Colors.white,
                              onSurface: kPrimaryBlue,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() => selectedDeadline = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimaryBlue.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, color: kPrimaryBlue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DEADLINE',
                                style: TextStyle(
                                  color: kPrimaryBlue.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                selectedDeadline != null
                                    ? DateFormat('MMM dd, yyyy').format(selectedDeadline!)
                                    : 'No deadline set',
                                style: TextStyle(
                                  color: selectedDeadline != null ? kPrimaryBlue : kPrimaryBlue.withOpacity(0.4),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (selectedDeadline != null)
                          IconButton(
                            icon: Icon(Icons.clear_rounded, color: kPrimaryBlue.withOpacity(0.5)),
                            onPressed: () => setState(() => selectedDeadline = null),
                          ),
                      ],
                    ),
                  ),
                ),
                
                if (selectedDeadline != null) ...[
                  const SizedBox(height: 8),
                  _DeadlineUrgencyIndicator(deadline: selectedDeadline!),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL', style: TextStyle(color: kPrimaryBlue)),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: kPrimaryBlue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () async {
                if (titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a goal title'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                double? estimatedHours;
                if (estimatedHoursController.text.isNotEmpty) {
                  estimatedHours = double.tryParse(estimatedHoursController.text);
                  if (estimatedHours == null || estimatedHours <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid number for estimated hours'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                }

                await ref.read(goalsProvider.notifier).updateGoal(
                  goal.id,
                  title: titleController.text,
                  description: descriptionController.text.isEmpty ? null : descriptionController.text,
                  priority: priority,
                  estimatedHours: estimatedHours,
                  deadline: selectedDeadline,
                );
                
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('SAVE CHANGES', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeadlineUrgencyIndicator extends StatelessWidget {
  final DateTime deadline;
  const _DeadlineUrgencyIndicator({required this.deadline});

  @override
  Widget build(BuildContext context) {
    final daysUntil = deadline.difference(DateTime.now()).inDays;
    
    String urgencyText;
    Color urgencyColor;
    IconData urgencyIcon;
    
    if (daysUntil < 0) {
      urgencyText = 'OVERDUE';
      urgencyColor = Colors.red;
      urgencyIcon = Icons.warning_rounded;
    } else if (daysUntil == 0) {
      urgencyText = 'DUE TODAY';
      urgencyColor = Colors.orange;
      urgencyIcon = Icons.error_outline_rounded;
    } else if (daysUntil <= 3) {
      urgencyText = '$daysUntil DAYS LEFT';
      urgencyColor = Colors.orange;
      urgencyIcon = Icons.access_time_rounded;
    } else if (daysUntil <= 7) {
      urgencyText = '$daysUntil DAYS LEFT';
      urgencyColor = Colors.blue;
      urgencyIcon = Icons.schedule_rounded;
    } else {
      urgencyText = '$daysUntil DAYS LEFT';
      urgencyColor = Colors.green;
      urgencyIcon = Icons.check_circle_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: urgencyColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: urgencyColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(urgencyIcon, size: 16, color: urgencyColor),
          const SizedBox(width: 8),
          Text(
            urgencyText,
            style: TextStyle(
              color: urgencyColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: kPrimaryBlue)),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: kPrimaryBlue.withOpacity(0.4), letterSpacing: 1)),
      ],
    );
  }
}

class _GoalCard extends ConsumerWidget {
  final dynamic goal;
  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = goal.estimatedHours != null && goal.estimatedHours > 0
        ? (goal.actualHours / goal.estimatedHours).clamp(0.0, 1.0)
        : 0.0;

    int? daysUntilDeadline;
    if (goal.deadline != null) {
      daysUntilDeadline = goal.deadline.difference(DateTime.now()).inDays;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kSapphireTintFill,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: kPrimaryBlue.withOpacity(0.05)),
      ),
      child: InkWell(
        onTap: () => _showGoalDetails(context, ref, goal),
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _PriorityDot(priority: goal.priority),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            goal.title.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue, fontSize: 16)
                        ),
                        Text(
                            _getCategoryLabel(goal.category).toUpperCase(),
                            style: TextStyle(color: kPrimaryBlue.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)
                        ),
                      ],
                    ),
                  ),
                  _StatusChip(status: goal.status),
                ],
              ),
              
              if (daysUntilDeadline != null && goal.status != 'completed') ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: _getDeadlineColor(daysUntilDeadline),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getDeadlineText(daysUntilDeadline),
                      style: TextStyle(
                        color: _getDeadlineColor(daysUntilDeadline),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
              
              if (goal.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  goal.description,
                  style: TextStyle(color: kPrimaryBlue.withOpacity(0.6), fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              if (goal.estimatedHours != null) ...[
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: kPrimaryBlue.withOpacity(0.1),
                      color: kPrimaryBlue,
                      minHeight: 6
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                    '${goal.actualHours.toStringAsFixed(1)} / ${goal.estimatedHours.toStringAsFixed(1)} HOURS',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: kPrimaryBlue)
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getDeadlineColor(int daysUntil) {
    if (daysUntil < 0) return Colors.red;
    if (daysUntil == 0) return Colors.orange;
    if (daysUntil <= 3) return Colors.orange;
    if (daysUntil <= 7) return Colors.blue;
    return Colors.green;
  }

  String _getDeadlineText(int daysUntil) {
    if (daysUntil < 0) return 'OVERDUE BY ${-daysUntil} DAYS';
    if (daysUntil == 0) return 'DUE TODAY';
    if (daysUntil == 1) return 'DUE TOMORROW';
    return 'DUE IN $daysUntil DAYS';
  }

  void _showGoalDetails(BuildContext context, WidgetRef ref, dynamic goal) {
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
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(goal.title.toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: kPrimaryBlue)),
                const SizedBox(height: 12),
                _StatusChip(status: goal.status),
                const SizedBox(height: 20),
                
                if (goal.description != null) ...[
                  Text(goal.description, style: TextStyle(color: kPrimaryBlue.withOpacity(0.7), fontSize: 16)),
                  const SizedBox(height: 20),
                ],
                
                if (goal.deadline != null) ...[
                  _DetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Deadline',
                    value: DateFormat('MMM dd, yyyy').format(goal.deadline),
                  ),
                  const SizedBox(height: 12),
                ],
                
                if (goal.estimatedHours != null) ...[
                  _DetailRow(
                    icon: Icons.access_time_rounded,
                    label: 'Estimated Hours',
                    value: '${goal.estimatedHours.toStringAsFixed(1)} hours',
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.timer_rounded,
                    label: 'Actual Hours',
                    value: '${goal.actualHours.toStringAsFixed(1)} hours',
                  ),
                  const SizedBox(height: 12),
                ],
                
                _DetailRow(
                  icon: Icons.flag_rounded,
                  label: 'Priority',
                  value: goal.priority.toUpperCase(),
                ),
                
                const SizedBox(height: 30),
                
                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kPrimaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ref.read(_GoalsScreenState as StateProvider)._showEditGoalDialog(context, goal);
                        },
                        icon: const Icon(Icons.edit_rounded),
                        label: const Text('EDIT'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (goal.status != 'completed')
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: kPrimaryBlue,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          onPressed: () async {
                            await ref.read(goalsProvider.notifier).completeGoal(goal.id);
                            if (context.mounted) Navigator.pop(context);
                          },
                          icon: const Icon(Icons.check_rounded),
                          label: const Text('COMPLETE'),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Goal?'),
                          content: const Text('This action cannot be undone.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('CANCEL'),
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(backgroundColor: Colors.red),
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('DELETE'),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirm == true) {
                        await ref.read(goalsProvider.notifier).deleteGoal(goal.id);
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: const Text('DELETE'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCategoryLabel(String category) => category.replaceAll('_', ' ');
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: kPrimaryBlue.withOpacity(0.7)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryBlue.withOpacity(0.5),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryBlue : kSapphireTintFill,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
            label,
            style: TextStyle(
                color: isSelected ? Colors.white : kPrimaryBlue,
                fontWeight: FontWeight.w900,
                fontSize: 11,
                letterSpacing: 1
            )
        ),
      ),
    );
  }
}

class _PriorityDot extends StatelessWidget {
  final String priority;
  const _PriorityDot({required this.priority});
  @override
  Widget build(BuildContext context) {
    Color c = priority == 'high' ? Colors.redAccent : (priority == 'medium' ? Colors.orangeAccent : Colors.greenAccent);
    return Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle));
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: kPrimaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(
          status.toUpperCase().replaceAll('_', ' '),
          style: const TextStyle(color: kPrimaryBlue, fontSize: 9, fontWeight: FontWeight.w900)
      ),
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
    Future.delayed(Duration(milliseconds: 150 * widget.delayIndex), () {
      if (mounted) setState(() => _visible = true);
    });
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 1000),
      opacity: _visible ? 1.0 : 0.0,
      curve: Curves.easeOutQuart,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOutQuart,
        padding: EdgeInsets.only(top: _visible ? 0 : 25),
        child: widget.child,
      ),
    );
  }
}

class _EmptyGoalsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flag_rounded, size: 64, color: kPrimaryBlue),
            const SizedBox(height: 16),
            const Text("NO GOALS SET YET", style: TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue, letterSpacing: 1))
          ]
      )
  );
}