// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/plan_provider.dart';

// class ScheduleScreen extends ConsumerWidget {
//   const ScheduleScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final todaysPlanAsync = ref.watch(todaysPlanProvider);
//     final todaysBlocksAsync = ref.watch(todaysBlocksProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Today\'s Schedule'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               ref.read(todaysPlanProvider.notifier).reload();
//             },
//           ),
//           PopupMenuButton<String>(
//             onSelected: (value) async {
//               if (value == 'regenerate') {
//                 await ref.read(todaysPlanProvider.notifier).regeneratePlan();
//                 if (context.mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Plan regenerated!')),
//                   );
//                 }
//               } else if (value == 'generate') {
//                 await ref.read(todaysPlanProvider.notifier).generatePlan();
//                 if (context.mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('New plan generated!')),
//                   );
//                 }
//               }
//             },
//             itemBuilder: (context) => [
//               const PopupMenuItem(
//                 value: 'generate',
//                 child: Row(
//                   children: [
//                     Icon(Icons.auto_awesome),
//                     SizedBox(width: 8),
//                     Text('Generate Plan'),
//                   ],
//                 ),
//               ),
//               const PopupMenuItem(
//                 value: 'regenerate',
//                 child: Row(
//                   children: [
//                     Icon(Icons.refresh),
//                     SizedBox(width: 8),
//                     Text('Regenerate'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () => ref.read(todaysPlanProvider.notifier).reload(),
//         child: todaysPlanAsync.when(
//           data: (plan) {
//             if (plan == null) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.calendar_today_outlined,
//                       size: 64,
//                       color: Colors.grey[400],
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'No plan for today',
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Generate a plan to get started',
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                     const SizedBox(height: 24),
//                     FilledButton.icon(
//                       onPressed: () async {
//                         await ref.read(todaysPlanProvider.notifier).generatePlan();
//                       },
//                       icon: const Icon(Icons.auto_awesome),
//                       label: const Text('Generate Plan'),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             return Column(
//               children: [
//                 // Plan Info Card
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(16),
//                   color: Theme.of(context).colorScheme.primaryContainer,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Plan v${plan.version}',
//                             style: Theme.of(context).textTheme.titleMedium,
//                           ),
//                           Text(
//                             '${plan.totalPlannedMinutes} min planned',
//                             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                           ),
//                         ],
//                       ),
//                       if (plan.reasoning != null) ...[
//                         const SizedBox(height: 8),
//                         Text(
//                           plan.reasoning!,
//                           style: Theme.of(context).textTheme.bodySmall,
//                           maxLines: 3,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                       if (plan.adaptationNotes != null) ...[
//                         const SizedBox(height: 4),
//                         Text(
//                           'Adapted: ${plan.adaptationNotes}',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontStyle: FontStyle.italic,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),

//                 // Time Blocks List
//                 Expanded(
//                   child: todaysBlocksAsync.when(
//                     data: (blocks) {
//                       if (blocks.isEmpty) {
//                         return const Center(
//                           child: Text('No time blocks scheduled'),
//                         );
//                       }

//                       return ListView.builder(
//                         padding: const EdgeInsets.all(16),
//                         itemCount: blocks.length,
//                         itemBuilder: (context, index) {
//                           final block = blocks[index];
//                           final isFirst = index == 0;
//                           final isLast = index == blocks.length - 1;
                          
//                           return _TimeBlockCard(
//                             block: block,
//                             isFirst: isFirst,
//                             isLast: isLast,
//                           );
//                         },
//                       );
//                     },
//                     loading: () => const Center(child: CircularProgressIndicator()),
//                     error: (error, _) => Center(child: Text('Error: $error')),
//                   ),
//                 ),
//               ],
//             );
//           },
//           loading: () => const Center(child: CircularProgressIndicator()),
//           error: (error, _) => Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.error_outline, size: 64, color: Colors.red),
//                 const SizedBox(height: 16),
//                 Text('Error: $error'),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _TimeBlockCard extends ConsumerWidget {
//   final dynamic block;
//   final bool isFirst;
//   final bool isLast;

//   const _TimeBlockCard({
//     required this.block,
//     required this.isFirst,
//     required this.isLast,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final now = DateTime.now();
//     final isCurrentBlock = now.isAfter(block.startTime) && now.isBefore(block.endTime);
//     final isPast = now.isAfter(block.endTime);
//     Color borderColor;
//     IconData icon;
//     Color iconColor;

//     if (block.completionStatus == 'completed') {
//       borderColor = Colors.green;
//       icon = Icons.check_circle;
//       iconColor = Colors.green;
//     } else if (block.completionStatus == 'missed') {
//       borderColor = Colors.red;
//       icon = Icons.cancel;
//       iconColor = Colors.red;
//     } else if (block.completionStatus == 'postponed') {
//       borderColor = Colors.orange;
//       icon = Icons.schedule;
//       iconColor = Colors.orange;
//     } else if (isCurrentBlock) {
//       borderColor = Colors.blue;
//       icon = Icons.play_circle;
//       iconColor = Colors.blue;
//     } else if (isPast) {
//       borderColor = Colors.grey;
//       icon = Icons.circle_outlined;
//       iconColor = Colors.grey;
//     } else {
//       borderColor = Colors.grey.shade300;
//       icon = Icons.circle_outlined;
//       iconColor = Colors.grey;
//     }

//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: isLast ? 0 : 12,
//         left: 24,
//       ),
//       child: IntrinsicHeight(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Timeline
//             Column(
//               children: [
//                 Icon(icon, color: iconColor, size: 24),
//                 if (!isLast)
//                   Expanded(
//                     child: Container(
//                       width: 2,
//                       color: borderColor,
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(width: 16),

//             // Card
//             Expanded(
//               child: Card(
//                 margin: EdgeInsets.zero,
//                 color: isCurrentBlock 
//                     ? Theme.of(context).colorScheme.primaryContainer 
//                     : null,
//                 child: InkWell(
//                   onTap: () => _showBlockActions(context, ref),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 block.title,
//                                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                                       fontWeight: FontWeight.bold,
//                                       decoration: block.completionStatus == 'completed'
//                                           ? TextDecoration.lineThrough
//                                           : null,
//                                     ),
//                               ),
//                             ),
//                             _BlockTypeChip(type: block.blockType),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           children: [
//                             Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
//                             const SizedBox(width: 4),
//                             Text(
//                               '${_formatTime(block.startTime)} - ${_formatTime(block.endTime)}',
//                               style: TextStyle(color: Colors.grey[600]),
//                             ),
//                             const SizedBox(width: 12),
//                             Text(
//                               '${block.durationMinutes} min',
//                               style: TextStyle(color: Colors.grey[600]),
//                             ),
//                           ],
//                         ),
//                         if (block.description != null) ...[
//                           const SizedBox(height: 8),
//                           Text(
//                             block.description,
//                             style: TextStyle(color: Colors.grey[700]),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                         if (block.actualDurationMinutes != null) ...[
//                           const SizedBox(height: 8),
//                           Row(
//                             children: [
//                               Icon(Icons.timer, size: 16, color: Colors.grey[600]),
//                               const SizedBox(width: 4),
//                               Text(
//                                 'Actual: ${block.actualDurationMinutes} min',
//                                 style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                               ),
//                             ],
//                           ),
//                         ],
//                         if (block.energyLevel != null) ...[
//                           const SizedBox(height: 4),
//                           Row(
//                             children: [
//                               ...List.generate(5, (i) => Icon(
//                                 i < block.energyLevel 
//                                     ? Icons.battery_full 
//                                     : Icons.battery_0_bar,
//                                 size: 16,
//                                 color: Colors.grey[600],
//                               )),
//                             ],
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showBlockActions(BuildContext context, WidgetRef ref) {
//     if (block.completionStatus == 'completed') return;

//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               block.title,
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 24),
//             FilledButton.icon(
//               onPressed: () async {
//                 final actions = ref.read(timeBlockActionsProvider);
//                 await actions.completeBlock(block.id);
//                 if (context.mounted) {
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Block completed! 🎉')),
//                   );
//                 }
//               },
//               icon: const Icon(Icons.check),
//               label: const Text('Mark as Completed'),
//             ),
//             const SizedBox(height: 12),
//             OutlinedButton.icon(
//               onPressed: () async {
//                 final actions = ref.read(timeBlockActionsProvider);
//                 await actions.missBlock(block.id, 'User marked as missed');
//                 if (context.mounted) {
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Block marked as missed')),
//                   );
//                 }
//               },
//               icon: const Icon(Icons.close),
//               label: const Text('Mark as Missed'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatTime(DateTime time) {
//     return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
//   }
// }

// class _BlockTypeChip extends StatelessWidget {
//   final String type;

//   const _BlockTypeChip({required this.type});

//   @override
//   Widget build(BuildContext context) {
//     Color color;
//     IconData icon;

//     switch (type) {
//       case 'study':
//         color = Colors.blue;
//         icon = Icons.book;
//         break;
//       case 'class':
//         color = Colors.purple;
//         icon = Icons.school;
//         break;
//       case 'break':
//         color = Colors.green;
//         icon = Icons.coffee;
//         break;
//       case 'exam_prep':
//         color = Colors.orange;
//         icon = Icons.quiz;
//         break;
//       case 'project_work':
//         color = Colors.teal;
//         icon = Icons.code;
//         break;
//       case 'opportunity_prep':
//         color = Colors.pink;
//         icon = Icons.star;
//         break;
//       default:
//         color = Colors.grey;
//         icon = Icons.circle;
//     }

//     return Chip(
//       avatar: Icon(icon, size: 16, color: color),
//       label: Text(type.replaceAll('_', ' '), style: const TextStyle(fontSize: 11)),
//       backgroundColor: color.withValues(alpha: 0.2),
//       padding: EdgeInsets.zero,
//       visualDensity: VisualDensity.compact,
//     );
//   }
// }





























import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/plan_provider.dart';
import '../providers/ui_state_provider.dart';

// Brand Constants


class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysPlanAsync = ref.watch(todaysPlanProvider);
    final todaysBlocksAsync = ref.watch(todaysBlocksProvider);
    final isCalendarView = ref.watch(viewModeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Daily Blueprint',
          style: TextStyle(
            color: kPrimaryBlue,
            fontWeight: FontWeight.w800,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          // View Toggle Button
          IconButton(
            icon: Icon(
              isCalendarView ? Icons.view_list_rounded : Icons.calendar_view_week_rounded,
              color: kPrimaryBlue,
            ),
            onPressed: () {
              ref.read(viewModeProvider.notifier).update((state) => !state);
            },
            tooltip: isCalendarView ? 'List View' : 'Calendar View',
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: kPrimaryBlue),
            onPressed: () => ref.read(todaysPlanProvider.notifier).reload(),
          ),
          _buildPremiumMenu(context, ref),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: kPrimaryBlue,
        onRefresh: () => ref.read(todaysPlanProvider.notifier).reload(),
        child: todaysPlanAsync.when(
          data: (plan) {
            if (plan == null) return _buildEmptyState(context, ref);

            return CustomScrollView(
              slivers: [
                // Plan Summary Card - REASONING REMOVED
                SliverToBoxAdapter(
                  child: _buildPlanHeader(context, plan),
                ),

                // Time Blocks List
                todaysBlocksAsync.when(
                  data: (blocks) {
                    if (blocks.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(child: Text('No blocks scheduled')),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) => _TimeBlockCard(
                            block: blocks[index],
                            isFirst: index == 0,
                            isLast: index == blocks.length - 1,
                          ),
                          childCount: blocks.length,
                        ),
                      ),
                    );
                  },
                  loading: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, _) => SliverFillRemaining(
                    child: Center(child: Text('Error: $error')),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _buildErrorState(error.toString()),
        ),
      ),
    );
  }

  Widget _buildPremiumMenu(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: const Icon(Icons.more_horiz_rounded, color: kPrimaryBlue),
      onSelected: (value) async {
        if (value == 'regenerate') {
          await ref.read(todaysPlanProvider.notifier).regeneratePlan();
        } else if (value == 'generate') {
          await ref.read(todaysPlanProvider.notifier).generatePlan();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'generate',
          child: ListTile(
            leading: Icon(Icons.auto_awesome, color: kPrimaryBlue),
            title: Text('New Plan'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'regenerate',
          child: ListTile(
            leading: Icon(Icons.loop, color: kPrimaryBlue),
            title: Text('Optimize Current'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanHeader(BuildContext context, dynamic plan) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimaryBlue, Color(0xFF3E69A8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: kPrimaryBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Plan Version ${plan.version}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${plan.totalPlannedMinutes} min',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_rounded, size: 80, color: kAccentBlue),
          const SizedBox(height: 24),
          const Text(
            'The day is a blank canvas.',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: kPrimaryBlue),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => ref.read(todaysPlanProvider.notifier).generatePlan(),
            style: FilledButton.styleFrom(
              backgroundColor: kPrimaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generate Blueprint'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(error, textAlign: TextAlign.center),
          ],
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
    final isCurrent = now.isAfter(block.startTime) && now.isBefore(block.endTime);

    final statusColor = block.completionStatus == 'completed'
        ? Colors.green
        : block.completionStatus == 'missed'
        ? Colors.red
        : isCurrent ? kPrimaryBlue : Colors.grey.shade300;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: isCurrent ? Colors.white : statusColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: statusColor, width: isCurrent ? 4 : 2),
                  boxShadow: isCurrent ? [BoxShadow(color: kPrimaryBlue.withOpacity(0.3), blurRadius: 8)] : null,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: statusColor.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: GestureDetector(
                onTap: () => _showBlockActions(context, ref),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isCurrent ? kAccentBlue : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isCurrent ? kPrimaryBlue.withOpacity(0.5) : Colors.grey.shade100,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              block.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: kPrimaryBlue,
                                decoration: block.completionStatus == 'completed' ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ),
                          _BlockTypeBadge(type: block.blockType),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time_filled_rounded, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${_formatTime(block.startTime)} - ${_formatTime(block.endTime)}',
                            style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.timer_rounded, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${block.durationMinutes}m',
                            style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      if (block.description != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          block.description,
                          style: TextStyle(color: Colors.blueGrey.shade700, fontSize: 14, height: 1.3),
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
    );
  }

  void _showBlockActions(BuildContext context, WidgetRef ref) {
    if (block.completionStatus == 'completed') return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(block.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kPrimaryBlue)),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                await ref.read(timeBlockActionsProvider).completeBlock(block.id);
                if (context.mounted) Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                backgroundColor: kPrimaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Mark Completed', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () async {
                await ref.read(timeBlockActionsProvider).missBlock(block.id, 'Missed');
                if (context.mounted) Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                foregroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Mark Missed', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

class _BlockTypeBadge extends StatelessWidget {
  final String type;
  const _BlockTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    Color color = kPrimaryBlue;
    switch (type) {
      case 'study': color = Colors.indigo; break;
      case 'class': color = Colors.deepPurple; break;
      case 'break': color = Colors.teal; break;
      case 'exam_prep': color = Colors.orange.shade800; break;
      case 'project_work': color = Colors.blueGrey; break;
      case 'opportunity_prep': color = Colors.pink.shade700; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        type.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
      ),
    );
  }
}