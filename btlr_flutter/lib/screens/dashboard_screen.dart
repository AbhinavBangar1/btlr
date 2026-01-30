// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/student_provider.dart';
// import '../providers/plan_provider.dart';
// import '../providers/behavior_provider.dart';
// import '../providers/goals_provider.dart';

// // --- BRAND CONSTANTS ---
// const Color kPrimaryBlue = Color(0xFF274B7F); // BTLR Sapphire Blue
// const Color kBackgroundWhite = Color(0xFFFFFFFF);
// const Color kSapphireTintFill = Color(0xFFF1F5F9); // Light bluish tint
// const double kBorderRadius = 24.0;

// class DashboardScreen extends ConsumerWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Corrected naming to ensure consistency with backend logic
//     final studentAsync = ref.watch(studentProfileProvider);
//     final todaysPlanAsync = ref.watch(todaysPlanProvider);
//     final currentBlockAsync = ref.watch(currentBlockProvider);
//     final completionStatsAsync = ref.watch(defaultCompletionStatsProvider);
//     final streakAsync = ref.watch(streakInfoProvider);
//     final activeGoals = ref.watch(activeGoalsProvider);

//     return Scaffold(
//       backgroundColor: kBackgroundWhite,
//       appBar: AppBar(
//         backgroundColor: kBackgroundWhite,
//         elevation: 0,
//         centerTitle: true,
//         toolbarHeight: 90,
//         title: Column(
//           children: [
//             const Text(
//               "BTLR",
//               style: TextStyle(
//                 fontSize: 34,
//                 fontWeight: FontWeight.w900,
//                 color: kPrimaryBlue,
//                 letterSpacing: -2,
//               ),
//             ),
//             Text(
//               "EXECUTIVE DASHBOARD",
//               style: TextStyle(
//                 fontSize: 9,
//                 letterSpacing: 3,
//                 color: kPrimaryBlue.withOpacity(0.5),
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh_rounded, color: kPrimaryBlue),
//             onPressed: () {
//               ref.read(todaysPlanProvider.notifier).reload();
//               ref.invalidate(currentBlockProvider);
//               ref.invalidate(defaultCompletionStatsProvider);
//             },
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         color: kPrimaryBlue,
//         onRefresh: () async {
//           ref.read(todaysPlanProvider.notifier).reload();
//           ref.invalidate(currentBlockProvider);
//           ref.invalidate(defaultCompletionStatsProvider);
//         },
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 1. WELCOME SECTION
//               _StaggeredEntrance(
//                 delayIndex: 0,
//                 child: studentAsync.when(
//                   data: (student) => Text(
//                     'WELCOME BACK, ${student?.name.toUpperCase() ?? "USER"}! 👋',
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w800,
//                       color: kPrimaryBlue,
//                       letterSpacing: -0.5,
//                     ),
//                   ),
//                   loading: () => const LinearProgressIndicator(color: kPrimaryBlue),
//                   error: (_, __) => const SizedBox(),
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // 2. HERO CURRENT BLOCK (Premium Gradient)
//               _StaggeredEntrance(
//                 delayIndex: 1,
//                 child: currentBlockAsync.when(
//                   data: (block) => block != null
//                       ? _CurrentBlockHero(block: block)
//                       : _EmptyStateHero(),
//                   loading: () => const _LoadingCard(),
//                   error: (_, __) => const SizedBox(),
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // 3. PERFORMANCE GRID (Staggered Entrance)
//               _StaggeredEntrance(
//                 delayIndex: 2,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: completionStatsAsync.when(
//                             data: (stats) => _StatCard(
//                               title: 'COMPLETION',
//                               value: '${((stats['completionRate'] as double) * 100).toStringAsFixed(0)}%',
//                               icon: Icons.donut_large_rounded,
//                               iconColor: Colors.blueAccent,
//                             ),
//                             loading: () => const _StatCardLoading(),
//                             error: (_, __) => const _StatCard(title: 'COMPLETION', value: '--', icon: Icons.error, iconColor: Colors.blueAccent),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: streakAsync.when(
//                             data: (streak) => _StatCard(
//                               title: 'STREAK',
//                               value: '${streak['currentStreak']} DAYS',
//                               icon: Icons.bolt_rounded,
//                               iconColor: Colors.orangeAccent,
//                             ),
//                             loading: () => const _StatCardLoading(),
//                             error: (_, __) => const _StatCard(title: 'STREAK', value: '--', icon: Icons.bolt, iconColor: Colors.orangeAccent),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _StatCard(
//                             title: 'ACTIVE GOALS',
//                             value: '${activeGoals.length}',
//                             icon: Icons.flag_rounded,
//                             iconColor: Colors.greenAccent[700]!,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: todaysPlanAsync.when(
//                             data: (plan) => _StatCard(
//                               title: 'PLAN',
//                               value: plan != null ? '${plan.totalPlannedMinutes}M' : '--',
//                               icon: Icons.hourglass_bottom_rounded,
//                               iconColor: Colors.purpleAccent,
//                             ),
//                             loading: () => const _StatCardLoading(),
//                             error: (_, __) => const _StatCard(title: 'PLAN', value: '--', icon: Icons.history, iconColor: Colors.purpleAccent),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 40),

//               // 4. QUICK ACTIONS
//               _StaggeredEntrance(
//                 delayIndex: 3,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'QUICK ACTIONS',
//                       style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: kPrimaryBlue, letterSpacing: 2),
//                     ),
//                     const SizedBox(height: 16),
//                     Wrap(
//                       spacing: 12,
//                       runSpacing: 12,
//                       children: [
//                         _QuickActionButton(
//                           label: 'GENERATE PLAN',
//                           icon: Icons.auto_awesome_rounded,
//                           onPressed: () => ref.read(todaysPlanProvider.notifier).generatePlan(),
//                         ),
//                         _QuickActionButton(label: 'ADD GOAL', icon: Icons.add_rounded, onPressed: () {}),
//                         _QuickActionButton(label: 'VIEW SCHEDULE', icon: Icons.calendar_view_day_rounded, onPressed: () {}),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // --- SUB-WIDGETS ---

// class _CurrentBlockHero extends ConsumerWidget {
//   final dynamic block;
//   const _CurrentBlockHero({required this.block});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final now = DateTime.now();
//     final progress = (now.difference(block.startTime).inMinutes / block.durationMinutes).clamp(0.0, 1.0);

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(28),
//       decoration: BoxDecoration(
//         color: kPrimaryBlue,
//         borderRadius: BorderRadius.circular(kBorderRadius),
//         boxShadow: [
//           BoxShadow(color: kPrimaryBlue.withOpacity(0.25), blurRadius: 25, offset: const Offset(0, 10)),
//         ],
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [kPrimaryBlue, Color(0xFF3B64A0)],
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.play_circle_filled_rounded, color: Colors.white, size: 36),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('ACTIVE NOW', style: TextStyle(color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.5)),
//                     Text(block.title.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: LinearProgressIndicator(value: progress, backgroundColor: Colors.white.withOpacity(0.15), color: Colors.white, minHeight: 8),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('${block.startTime.hour}:${block.startTime.minute.toString().padLeft(2, '0')} - ${block.endTime.hour}:${block.endTime.minute.toString().padLeft(2, '0')}',
//                   style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
//               Text('${block.durationMinutes} MIN', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
//             ],
//           ),
//           const SizedBox(height: 24),
//           Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: () async {
//                     final actions = ref.read(timeBlockActionsProvider);
//                     await actions.completeBlock(block.id);
//                   },
//                   icon: const Icon(Icons.check_rounded, size: 18),
//                   label: const Text('COMPLETE', style: TextStyle(fontWeight: FontWeight.bold)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: kPrimaryBlue,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     elevation: 0,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: OutlinedButton.icon(
//                   onPressed: () async {
//                     final actions = ref.read(timeBlockActionsProvider);
//                     await actions.missBlock(block.id, 'User marked as missed');
//                   },
//                   icon: const Icon(Icons.close_rounded, size: 18),
//                   label: const Text('MISS', style: TextStyle(fontWeight: FontWeight.bold)),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                     side: const BorderSide(color: Colors.white70, width: 2),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _StatCard extends StatelessWidget {
//   final String title, value;
//   final IconData icon;
//   final Color iconColor;
//   const _StatCard({required this.title, required this.value, required this.icon, required this.iconColor});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: kSapphireTintFill,
//         borderRadius: BorderRadius.circular(kBorderRadius),
//         border: Border.all(color: kPrimaryBlue.withOpacity(0.05)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: iconColor, size: 30),
//           const SizedBox(height: 12),
//           Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: kPrimaryBlue)),
//           Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kPrimaryBlue.withOpacity(0.4), letterSpacing: 1)),
//         ],
//       ),
//     );
//   }
// }

// class _QuickActionButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback onPressed;
//   const _QuickActionButton({required this.label, required this.icon, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressed,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         decoration: BoxDecoration(
//           color: kSapphireTintFill,
//           border: Border.all(color: kPrimaryBlue.withOpacity(0.1), width: 1.5),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, color: kPrimaryBlue, size: 18),
//             const SizedBox(width: 10),
//             Text(label, style: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // --- ENTRANCE ANIMATION ---

// class _StaggeredEntrance extends StatefulWidget {
//   final Widget child;
//   final int delayIndex;
//   const _StaggeredEntrance({required this.child, required this.delayIndex});
//   @override
//   State<_StaggeredEntrance> createState() => _StaggeredEntranceState();
// }

// class _StaggeredEntranceState extends State<_StaggeredEntrance> {
//   bool _visible = false;
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(milliseconds: 150 * widget.delayIndex), () {
//       if (mounted) setState(() => _visible = true);
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedOpacity(
//       duration: const Duration(milliseconds: 1000),
//       opacity: _visible ? 1.0 : 0.0,
//       curve: Curves.easeOutQuart,
//       child: AnimatedPadding(
//         duration: const Duration(milliseconds: 1000),
//         curve: Curves.easeOutQuart,
//         padding: EdgeInsets.only(top: _visible ? 0 : 25),
//         child: widget.child,
//       ),
//     );
//   }
// }

// // Skeletons & Placeholders
// class _StatCardLoading extends StatelessWidget {
//   const _StatCardLoading();
//   @override
//   Widget build(BuildContext context) => Container(height: 100, decoration: BoxDecoration(color: kSapphireTintFill, borderRadius: BorderRadius.circular(kBorderRadius)));
// }

// class _LoadingCard extends StatelessWidget {
//   const _LoadingCard();
//   @override
//   Widget build(BuildContext context) => Container(height: 200, decoration: BoxDecoration(color: kSapphireTintFill, borderRadius: BorderRadius.circular(kBorderRadius)));
// }

// class _EmptyStateHero extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Container(
//     padding: const EdgeInsets.all(28),
//     decoration: BoxDecoration(color: kSapphireTintFill, borderRadius: BorderRadius.circular(kBorderRadius)),
//     child: Row(children: [const Icon(Icons.check_circle_rounded, color: Colors.green, size: 32), const SizedBox(width: 16), const Text("YOU'RE ALL CAUGHT UP!", style: TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue, letterSpacing: 1))]),
//   );
// }




















import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_provider.dart';
import '../providers/plan_provider.dart';
import '../providers/behavior_provider.dart';
import '../providers/goals_provider.dart';

// --- BRAND CONSTANTS ---
const Color kPrimaryBlue = Color(0xFF274B7F);
const Color kBackgroundWhite = Color(0xFFFFFFFF);
const Color kSapphireTintFill = Color(0xFFF1F5F9);
const double kBorderRadius = 24.0;

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentProfileProvider);
    final todaysPlanAsync = ref.watch(todaysPlanProvider);
    final todaysBlocksAsync = ref.watch(todaysBlocksProvider);
    final currentBlockAsync = ref.watch(currentBlockProvider);
    final upcomingBlocksAsync = ref.watch(upcomingBlocksProvider);
    final completionStatsAsync = ref.watch(defaultCompletionStatsProvider);
    final goalsAsync = ref.watch(goalsProvider);

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
              "COMMAND CENTER",
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
              ref.read(goalsProvider.notifier).loadGoals();
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
          await ref.read(goalsProvider.notifier).loadGoals();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. WELCOME + TIME
              _StaggeredEntrance(
                delayIndex: 0,
                child: studentAsync.when(
                  data: (student) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryBlue.withOpacity(0.6),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        student?.name.toUpperCase() ?? "USER",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: kPrimaryBlue,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                  loading: () => const LinearProgressIndicator(color: kPrimaryBlue),
                  error: (_, __) => const SizedBox(),
                ),
              ),
              const SizedBox(height: 24),

              // 2. CURRENT BLOCK OR NEXT UP
              _StaggeredEntrance(
                delayIndex: 1,
                child: currentBlockAsync.when(
                  data: (block) {
                    if (block != null) {
                      return _CurrentBlockHero(block: block);
                    }
                    // Show next upcoming block
                    return upcomingBlocksAsync.when(
                      data: (blocks) => blocks.isNotEmpty
                          ? _NextBlockCard(block: blocks.first)
                          : _EmptyStateHero(),
                      loading: () => const _LoadingCard(),
                      error: (_, __) => _EmptyStateHero(),
                    );
                  },
                  loading: () => const _LoadingCard(),
                  error: (_, __) => _EmptyStateHero(),
                ),
              ),
              const SizedBox(height: 24),

              // 3. TODAY'S PROGRESS OVERVIEW
              _StaggeredEntrance(
                delayIndex: 2,
                child: todaysBlocksAsync.when(
                  data: (blocks) {
                    final completed = blocks.where((b) => b.completionStatus == 'completed').length;
                    final total = blocks.length;
                    final completionRate = total > 0 ? completed / total : 0.0;
                    
                    final totalMinutes = blocks.fold<int>(0, (sum, b) => sum + b.durationMinutes);
                    final completedMinutes = blocks
                        .where((b) => b.completionStatus == 'completed')
                        .fold<int>(0, (sum, b) => sum + b.durationMinutes);

                    return _TodayProgressCard(
                      completed: completed,
                      total: total,
                      completionRate: completionRate,
                      totalMinutes: totalMinutes,
                      completedMinutes: completedMinutes,
                    );
                  },
                  loading: () => const _LoadingCard(),
                  error: (_, __) => const SizedBox(),
                ),
              ),
              const SizedBox(height: 24),

              // 4. GOALS AT RISK + PERFORMANCE METRICS
              _StaggeredEntrance(
                delayIndex: 3,
                child: Row(
                  children: [
                    Expanded(
                      child: goalsAsync.when(
                        data: (goals) {
                          final activeGoals = goals.where((g) => 
                            g.status == 'not_started' || g.status == 'in_progress'
                          ).toList();
                          
                          final atRisk = activeGoals.where((g) {
                            if (g.deadline == null) return false;
                            final daysLeft = g.deadline!.difference(DateTime.now()).inDays;
                            final progress = (g.estimatedHours ?? 0) > 0 
                                ? (g.actualHours / (g.estimatedHours ?? 1)) 
                                : 0.0;
                            return daysLeft <= 3 && progress < 0.5;
                          }).length;

                          return _StatCard(
                            title: 'GOALS AT RISK',
                            value: '$atRisk',
                            icon: Icons.warning_rounded,
                            iconColor: atRisk > 0 ? Colors.orangeAccent : Colors.green,
                          );
                        },
                        loading: () => const _StatCardLoading(),
                        error: (_, __) => const _StatCard(
                          title: 'GOALS AT RISK',
                          value: '--',
                          icon: Icons.warning,
                          iconColor: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: completionStatsAsync.when(
                        data: (stats) {
                          final rate = ((stats['completionRate'] as double) * 100).toInt();
                          return _StatCard(
                            title: 'COMPLETION',
                            value: '$rate%',
                            icon: Icons.analytics_rounded,
                            iconColor: rate >= 80 
                                ? Colors.green 
                                : rate >= 50 
                                    ? Colors.orange 
                                    : Colors.red,
                          );
                        },
                        loading: () => const _StatCardLoading(),
                        error: (_, __) => const _StatCard(
                          title: 'COMPLETION',
                          value: '--',
                          icon: Icons.analytics,
                          iconColor: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 5. TOTAL GOALS + PLANNED TIME
              _StaggeredEntrance(
                delayIndex: 4,
                child: Row(
                  children: [
                    Expanded(
                      child: goalsAsync.when(
                        data: (goals) {
                          final active = goals.where((g) => 
                            g.status == 'not_started' || g.status == 'in_progress'
                          ).length;
                          final completed = goals.where((g) => g.status == 'completed').length;
                          
                          return _StatCard(
                            title: 'ACTIVE GOALS',
                            value: '$active / ${goals.length}',
                            icon: Icons.flag_rounded,
                            iconColor: Colors.blue,
                          );
                        },
                        loading: () => const _StatCardLoading(),
                        error: (_, __) => const _StatCard(
                          title: 'ACTIVE GOALS',
                          value: '--',
                          icon: Icons.flag,
                          iconColor: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: todaysPlanAsync.when(
                        data: (plan) {
                          if (plan == null) {
                            return const _StatCard(
                              title: 'NO PLAN',
                              value: '0M',
                              icon: Icons.calendar_today_rounded,
                              iconColor: Colors.grey,
                            );
                          }
                          
                          final hours = (plan.totalPlannedMinutes / 60).toStringAsFixed(1);
                          return _StatCard(
                            title: 'PLANNED TODAY',
                            value: '${hours}H',
                            icon: Icons.access_time_rounded,
                            iconColor: Colors.purple,
                          );
                        },
                        loading: () => const _StatCardLoading(),
                        error: (_, __) => const _StatCard(
                          title: 'PLANNED',
                          value: '--',
                          icon: Icons.schedule,
                          iconColor: Colors.purpleAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 6. QUICK INSIGHTS
              _StaggeredEntrance(
                delayIndex: 5,
                child: goalsAsync.when(
                  data: (goals) {
                    final urgentGoals = goals.where((g) {
                      if (g.deadline == null || g.status == 'completed') return false;
                      return g.deadline!.difference(DateTime.now()).inDays <= 2;
                    }).toList();

                    if (urgentGoals.isEmpty) return const SizedBox();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'URGENT DEADLINES',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: kPrimaryBlue,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...urgentGoals.map((goal) => _UrgentGoalCard(goal: goal)),
                      ],
                    );
                  },
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
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
    final remainingMinutes = block.endTime.difference(now).inMinutes.clamp(0, block.durationMinutes);

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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.play_circle_filled_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACTIVE NOW',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      block.title.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.15),
              color: Colors.white,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TIME REMAINING',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$remainingMinutes MIN',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'DURATION',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${block.durationMinutes} MIN',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
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
                  label: const Text('COMPLETE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
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
                  label: const Text('MISS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
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

class _NextBlockCard extends StatelessWidget {
  final dynamic block;
  const _NextBlockCard({required this.block});

  @override
  Widget build(BuildContext context) {
    final minutesUntil = block.startTime.difference(DateTime.now()).inMinutes;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kSapphireTintFill,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: kPrimaryBlue.withOpacity(0.1), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.schedule_rounded, color: Colors.orange, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'NEXT UP IN $minutesUntil MIN',
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            block.title.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: kPrimaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_formatTime(block.startTime)} - ${_formatTime(block.endTime)} • ${block.durationMinutes} min',
            style: TextStyle(
              color: kPrimaryBlue.withOpacity(0.6),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _TodayProgressCard extends StatelessWidget {
  final int completed;
  final int total;
  final double completionRate;
  final int totalMinutes;
  final int completedMinutes;

  const _TodayProgressCard({
    required this.completed,
    required this.total,
    required this.completionRate,
    required this.totalMinutes,
    required this.completedMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.purple.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: kPrimaryBlue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TODAY\'S PROGRESS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: kPrimaryBlue,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ProgressMetric(
                label: 'TASKS',
                value: '$completed / $total',
                icon: Icons.check_circle_rounded,
              ),
              _ProgressMetric(
                label: 'TIME',
                value: '${(completedMinutes / 60).toStringAsFixed(1)}H / ${(totalMinutes / 60).toStringAsFixed(1)}H',
                icon: Icons.timer_rounded,
              ),
              _ProgressMetric(
                label: 'RATE',
                value: '${(completionRate * 100).toInt()}%',
                icon: Icons.trending_up_rounded,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: completionRate,
              backgroundColor: kPrimaryBlue.withOpacity(0.1),
              color: kPrimaryBlue,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProgressMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: kPrimaryBlue, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: kPrimaryBlue,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: kPrimaryBlue.withOpacity(0.5),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _UrgentGoalCard extends StatelessWidget {
  final dynamic goal;
  const _UrgentGoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    final daysLeft = goal.deadline.difference(DateTime.now()).inDays;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.warning_rounded, color: Colors.red, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: kPrimaryBlue,
                    fontSize: 13,
                  ),
                ),
                Text(
                  daysLeft == 0 ? 'DUE TODAY' : 'DUE IN $daysLeft DAY${daysLeft == 1 ? '' : 'S'}',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
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
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: kPrimaryBlue)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: kPrimaryBlue.withOpacity(0.4), letterSpacing: 1)),
        ],
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
    Future.delayed(Duration(milliseconds: 120 * widget.delayIndex), () {
      if (mounted) setState(() => _visible = true);
    });
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: _visible ? 1.0 : 0.0,
      curve: Curves.easeOutQuart,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutQuart,
        padding: EdgeInsets.only(top: _visible ? 0 : 20),
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
  Widget build(BuildContext context) => Container(height: 180, decoration: BoxDecoration(color: kSapphireTintFill, borderRadius: BorderRadius.circular(kBorderRadius)));
}

class _EmptyStateHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.green.shade50, Colors.teal.shade50],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(kBorderRadius),
      border: Border.all(color: Colors.green.withOpacity(0.2)),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ALL CAUGHT UP!",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: kPrimaryBlue,
                  fontSize: 18,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "No active tasks right now",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
