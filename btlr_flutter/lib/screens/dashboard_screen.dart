import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_provider.dart';
import '../providers/plan_provider.dart';
import '../providers/behavior_provider.dart';
import '../providers/goals_provider.dart';

// --- BRAND CONSTANTS ---
const Color kPrimaryBlue = Color(0xFF274B7F); // BTLR Sapphire Blue
const Color kBackgroundWhite = Color(0xFFFFFFFF);
const Color kSapphireTintFill = Color(0xFFF1F5F9); // Light bluish tint
const double kBorderRadius = 24.0;

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Corrected naming to ensure consistency with backend logic
    final studentAsync = ref.watch(studentProfileProvider);
    final todaysPlanAsync = ref.watch(todaysPlanProvider);
    final currentBlockAsync = ref.watch(currentBlockProvider);
    final completionStatsAsync = ref.watch(defaultCompletionStatsProvider);
    final streakAsync = ref.watch(streakInfoProvider);
    final activeGoals = ref.watch(activeGoalsProvider);

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
              "EXECUTIVE DASHBOARD",
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
            onPressed: () {
              ref.read(todaysPlanProvider.notifier).reload();
              ref.invalidate(currentBlockProvider);
              ref.invalidate(defaultCompletionStatsProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: kPrimaryBlue,
        onRefresh: () async {
          ref.read(todaysPlanProvider.notifier).reload();
          ref.invalidate(currentBlockProvider);
          ref.invalidate(defaultCompletionStatsProvider);
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. WELCOME SECTION
              _StaggeredEntrance(
                delayIndex: 0,
                child: studentAsync.when(
                  data: (student) => Text(
                    'WELCOME BACK, ${student?.name.toUpperCase() ?? "USER"}! 👋',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: kPrimaryBlue,
                      letterSpacing: -0.5,
                    ),
                  ),
                  loading: () => const LinearProgressIndicator(color: kPrimaryBlue),
                  error: (_, __) => const SizedBox(),
                ),
              ),
              const SizedBox(height: 32),

              // 2. HERO CURRENT BLOCK (Premium Gradient)
              _StaggeredEntrance(
                delayIndex: 1,
                child: currentBlockAsync.when(
                  data: (block) => block != null
                      ? _CurrentBlockHero(block: block)
                      : _EmptyStateHero(),
                  loading: () => const _LoadingCard(),
                  error: (_, __) => const SizedBox(),
                ),
              ),
              const SizedBox(height: 32),

              // 3. PERFORMANCE GRID (Staggered Entrance)
              _StaggeredEntrance(
                delayIndex: 2,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: completionStatsAsync.when(
                            data: (stats) => _StatCard(
                              title: 'COMPLETION',
                              value: '${((stats['completionRate'] as double) * 100).toStringAsFixed(0)}%',
                              icon: Icons.donut_large_rounded,
                              iconColor: Colors.blueAccent,
                            ),
                            loading: () => const _StatCardLoading(),
                            error: (_, __) => const _StatCard(title: 'COMPLETION', value: '--', icon: Icons.error, iconColor: Colors.blueAccent),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: streakAsync.when(
                            data: (streak) => _StatCard(
                              title: 'STREAK',
                              value: '${streak['currentStreak']} DAYS',
                              icon: Icons.bolt_rounded,
                              iconColor: Colors.orangeAccent,
                            ),
                            loading: () => const _StatCardLoading(),
                            error: (_, __) => const _StatCard(title: 'STREAK', value: '--', icon: Icons.bolt, iconColor: Colors.orangeAccent),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'ACTIVE GOALS',
                            value: '${activeGoals.length}',
                            icon: Icons.flag_rounded,
                            iconColor: Colors.greenAccent[700]!,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: todaysPlanAsync.when(
                            data: (plan) => _StatCard(
                              title: 'PLAN',
                              value: plan != null ? '${plan.totalPlannedMinutes}M' : '--',
                              icon: Icons.hourglass_bottom_rounded,
                              iconColor: Colors.purpleAccent,
                            ),
                            loading: () => const _StatCardLoading(),
                            error: (_, __) => const _StatCard(title: 'PLAN', value: '--', icon: Icons.history, iconColor: Colors.purpleAccent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 4. QUICK ACTIONS
              _StaggeredEntrance(
                delayIndex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'QUICK ACTIONS',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: kPrimaryBlue, letterSpacing: 2),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _QuickActionButton(
                          label: 'GENERATE PLAN',
                          icon: Icons.auto_awesome_rounded,
                          onPressed: () => ref.read(todaysPlanProvider.notifier).generatePlan(),
                        ),
                        _QuickActionButton(label: 'ADD GOAL', icon: Icons.add_rounded, onPressed: () {}),
                        _QuickActionButton(label: 'VIEW SCHEDULE', icon: Icons.calendar_view_day_rounded, onPressed: () {}),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- SUB-WIDGETS ---

class _CurrentBlockHero extends ConsumerWidget {
  final dynamic block;
  const _CurrentBlockHero({required this.block});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final progress = (now.difference(block.startTime).inMinutes / block.durationMinutes).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: kPrimaryBlue,
        borderRadius: BorderRadius.circular(kBorderRadius),
        boxShadow: [
          BoxShadow(color: kPrimaryBlue.withOpacity(0.25), blurRadius: 25, offset: const Offset(0, 10)),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kPrimaryBlue, Color(0xFF3B64A0)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.play_circle_filled_rounded, color: Colors.white, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ACTIVE NOW', style: TextStyle(color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.5)),
                    Text(block.title.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(value: progress, backgroundColor: Colors.white.withOpacity(0.15), color: Colors.white, minHeight: 8),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${block.startTime.hour}:${block.startTime.minute.toString().padLeft(2, '0')} - ${block.endTime.hour}:${block.endTime.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
              Text('${block.durationMinutes} MIN', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final actions = ref.read(timeBlockActionsProvider);
                    await actions.completeBlock(block.id);
                  },
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('COMPLETE', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: kPrimaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final actions = ref.read(timeBlockActionsProvider);
                    await actions.missBlock(block.id, 'User marked as missed');
                  },
                  icon: const Icon(Icons.close_rounded, size: 18),
                  label: const Text('MISS', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white70, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color iconColor;
  const _StatCard({required this.title, required this.value, required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kSapphireTintFill,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: kPrimaryBlue.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: kPrimaryBlue)),
          Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kPrimaryBlue.withOpacity(0.4), letterSpacing: 1)),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const _QuickActionButton({required this.label, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: kSapphireTintFill,
          border: Border.all(color: kPrimaryBlue.withOpacity(0.1), width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: kPrimaryBlue, size: 18),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }
}

// --- ENTRANCE ANIMATION ---

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

// Skeletons & Placeholders
class _StatCardLoading extends StatelessWidget {
  const _StatCardLoading();
  @override
  Widget build(BuildContext context) => Container(height: 100, decoration: BoxDecoration(color: kSapphireTintFill, borderRadius: BorderRadius.circular(kBorderRadius)));
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();
  @override
  Widget build(BuildContext context) => Container(height: 200, decoration: BoxDecoration(color: kSapphireTintFill, borderRadius: BorderRadius.circular(kBorderRadius)));
}

class _EmptyStateHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(color: kSapphireTintFill, borderRadius: BorderRadius.circular(kBorderRadius)),
    child: Row(children: [const Icon(Icons.check_circle_rounded, color: Colors.green, size: 32), const SizedBox(width: 16), const Text("YOU'RE ALL CAUGHT UP!", style: TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue, letterSpacing: 1))]),
  );
}