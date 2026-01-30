// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../providers/scraping_provider.dart';
// import '../providers/activity_provider.dart';
// import '../providers/opportunities_provider.dart';
// import 'dart:convert'; 

// // --- BRAND CONSTANTS ---
// const Color kPrimaryBlue = Color(0xFF274B7F); // BTLR Sapphire
// const Color kBackgroundWhite = Color(0xFFFFFFFF);
// const Color kSapphireTintFill = Color(0xFFF1F5F9);
// const double kBorderRadius = 24.0;

// class DiscoverScreen extends ConsumerStatefulWidget {
//   const DiscoverScreen({super.key});

//   @override
//   ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
// }

// class _DiscoverScreenState extends ConsumerState<DiscoverScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String _selectedPlatform = 'all';

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final scrapedContentAsync = ref.watch(scrapedContentProvider);
//     final activityDashboardAsync = ref.watch(activityDashboardProvider);
//     final unreadCount = ref.watch(unreadScrapedContentCountProvider);

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
//               "DISCOVER & TRACK",
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
//               ref.read(scrapedContentProvider.notifier).scrapeAll();
//               ref.read(activityDashboardProvider.notifier).syncAll();
//             },
//           ),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: kPrimaryBlue,
//           unselectedLabelColor: kPrimaryBlue.withOpacity(0.5),
//           indicatorColor: kPrimaryBlue,
//           labelStyle: const TextStyle(
//             fontWeight: FontWeight.w900,
//             fontSize: 12,
//             letterSpacing: 1.5,
//           ),
//           tabs: [
//             Tab(
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text('DISCOVER'),
//                   if (unreadCount > 0) ...[
//                     const SizedBox(width: 8),
//                     Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: const BoxDecoration(
//                         color: kPrimaryBlue,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Text(
//                         '$unreadCount',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             const Tab(text: 'MY PROFILES'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           // TAB 1: SCRAPED OPPORTUNITIES
//           _buildOpportunitiesTab(scrapedContentAsync),
          
//           // TAB 2: ACTIVITY TRACKING
//           _buildProgressTab(scrapedContentAsync),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: kPrimaryBlue,
//         onPressed: () => _showSetupDialog(context),
//         icon: const Icon(Icons.settings_rounded, color: Colors.white),
//         label: const Text(
//           'SETUP',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 1.2,
//           ),
//         ),
//       ),
//     );
//   }

//   // TAB 1: OPPORTUNITIES FROM SCRAPING
//   Widget _buildOpportunitiesTab(AsyncValue<List<dynamic>> scrapedContentAsync) {
//     return Column(
//       children: [
//         // Platform Filter
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'PLATFORM',
//                 style: TextStyle(
//                   fontSize: 9,
//                   fontWeight: FontWeight.w900,
//                   color: kPrimaryBlue.withOpacity(0.5),
//                   letterSpacing: 2.5,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     _FilterChip(
//                       label: 'ALL',
//                       isSelected: _selectedPlatform == 'all',
//                       onTap: () => setState(() => _selectedPlatform = 'all'),
//                     ),
//                     const SizedBox(width: 8),
//                     _FilterChip(
//                       label: 'DEVPOST',
//                       isSelected: _selectedPlatform == 'devpost',
//                       onTap: () => setState(() => _selectedPlatform = 'devpost'),
//                     ),
//                     const SizedBox(width: 8),
//                     _FilterChip(
//                       label: 'INTERNSHALA',
//                       isSelected: _selectedPlatform == 'internshala',
//                       onTap: () => setState(() => _selectedPlatform = 'internshala'),
//                     ),
//                     const SizedBox(width: 8),
//                     _FilterChip(
//                       label: 'ANGELLIST',
//                       isSelected: _selectedPlatform == 'angellist',
//                       onTap: () => setState(() => _selectedPlatform = 'angellist'),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Opportunities List
//         Expanded(
//           child: scrapedContentAsync.when(
//             data: (content) {
//               final filtered = _selectedPlatform == 'all'
//                   ? content
//                   : content.where((c) => c.platform == _selectedPlatform).toList();

//               if (filtered.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.search_off_rounded,
//                         size: 64,
//                         color: kPrimaryBlue.withOpacity(0.3),
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'NO OPPORTUNITIES FOUND',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w900,
//                           color: kPrimaryBlue,
//                           letterSpacing: 1,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       TextButton(
//                         onPressed: () => ref.read(scrapedContentProvider.notifier).scrapeAll(),
//                         child: const Text('TAP TO SCRAPE NOW'),
//                       ),
//                     ],
//                   ),
//                 );
//               }

//               return RefreshIndicator(
//                 color: kPrimaryBlue,
//                 onRefresh: () => ref.read(scrapedContentProvider.notifier).loadScrapedContent(),
//                 child: ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: filtered.length,
//                   itemBuilder: (context, index) {
//                     return _ScrapedContentCard(content: filtered[index]);
//                   },
//                 ),
//               );
//             },
//             loading: () => const Center(
//               child: CircularProgressIndicator(color: kPrimaryBlue),
//             ),
//             error: (err, _) => Center(
//               child: Text(
//                 'Error: $err',
//                 style: const TextStyle(color: kPrimaryBlue),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // TAB 2: PROGRESS TRACKING
// Widget _buildProgressTab(AsyncValue<List<dynamic>> scrapedContentAsync) {
//   return scrapedContentAsync.when(
//     data: (content) {
//       // Filter for profile platforms
//       final githubData = content.where((c) => c.platform == 'github').firstOrNull;
//       final leetcodeData = content.where((c) => c.platform == 'leetcode').firstOrNull;
//       final codeforcesData = content.where((c) => c.platform == 'codeforces').firstOrNull;

//       if (githubData == null && leetcodeData == null && codeforcesData == null) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.timeline_rounded,
//                 size: 64,
//                 color: kPrimaryBlue.withOpacity(0.3),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'NO PROFILES SETUP',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w900,
//                   color: kPrimaryBlue,
//                   letterSpacing: 1,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Add your coding profiles in Settings',
//                 style: TextStyle(color: kPrimaryBlue),
//               ),
//             ],
//           ),
//         );
//       }

//       return RefreshIndicator(
//         color: kPrimaryBlue,
//         onRefresh: () => ref.read(scrapedContentProvider.notifier).scrapeAll(),
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             // GitHub Card
//             if (githubData != null) ...[
//               _ProfileCard(
//                 title: 'GITHUB',
//                 icon: Icons.code,
//                 color: Colors.black87,
//                 data: githubData,
//               ),
//               const SizedBox(height: 16),
//             ],

//             // LeetCode Card
//             if (leetcodeData != null) ...[
//               _ProfileCard(
//                 title: 'LEETCODE',
//                 icon: Icons.terminal,
//                 color: Colors.orange,
//                 data: leetcodeData,
//               ),
//               const SizedBox(height: 16),
//             ],

//             // Codeforces Card
//             if (codeforcesData != null) ...[
//               _ProfileCard(
//                 title: 'CODEFORCES',
//                 icon: Icons.emoji_events,
//                 color: Colors.blue,
//                 data: codeforcesData,
//               ),
//             ],
//           ],
//         ),
//       );
//     },
//     loading: () => const Center(
//       child: CircularProgressIndicator(color: kPrimaryBlue),
//     ),
//     error: (err, _) => Center(
//       child: Text('Error: $err', style: const TextStyle(color: kPrimaryBlue)),
//     ),
//   );
// }


//   void _showSetupDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => _SetupDialog(),
//     );
//   }
// }

// // SCRAPED CONTENT CARD
// class _ScrapedContentCard extends ConsumerWidget {
//   final dynamic content;
//   const _ScrapedContentCard({required this.content});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: kSapphireTintFill,
//         borderRadius: BorderRadius.circular(kBorderRadius),
//         border: Border.all(color: kPrimaryBlue.withOpacity(0.05)),
//       ),
//       child: InkWell(
//         onTap: () async {
//           // Mark as read and open URL
//           await ref.read(scrapedContentProvider.notifier).markAsRead(content.id);
//           if (await canLaunchUrl(Uri.parse(content.sourceUrl))) {
//             await launchUrl(Uri.parse(content.sourceUrl));
//           }
//         },
//         borderRadius: BorderRadius.circular(kBorderRadius),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       content.title.toUpperCase(),
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w900,
//                         color: kPrimaryBlue,
//                         fontSize: 14,
//                         letterSpacing: -0.2,
//                       ),
//                     ),
//                   ),
//                   _PlatformBadge(platform: content.platform),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 content.summary,
//                 style: TextStyle(
//                   color: kPrimaryBlue.withOpacity(0.6),
//                   fontSize: 12,
//                   height: 1.4,
//                 ),
//                 maxLines: 3,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.open_in_new_rounded,
//                     size: 14,
//                     color: kPrimaryBlue.withOpacity(0.5),
//                   ),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: Text(
//                       content.sourceUrl,
//                       style: TextStyle(
//                         color: kPrimaryBlue.withOpacity(0.5),
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   // Add to opportunities button
//                   IconButton(
//                     icon: const Icon(Icons.add_circle_outline, color: kPrimaryBlue),
//                     onPressed: () => _showAddToOpportunitiesDialog(context, ref, content),
//                     tooltip: 'Add to Opportunities',
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showAddToOpportunitiesDialog(BuildContext context, WidgetRef ref, dynamic content) {
//     String type = 'hackathon';
    
//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           title: const Text(
//             'ADD TO OPPORTUNITIES',
//             style: TextStyle(
//               color: kPrimaryBlue,
//               fontWeight: FontWeight.w900,
//               letterSpacing: 1,
//             ),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 content.title,
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 initialValue: type,
//                 decoration: const InputDecoration(labelText: 'TYPE'),
//                 items: const [
//                   DropdownMenuItem(value: 'hackathon', child: Text('Hackathon')),
//                   DropdownMenuItem(value: 'internship', child: Text('Internship')),
//                   DropdownMenuItem(value: 'scholarship', child: Text('Scholarship')),
//                   DropdownMenuItem(value: 'workshop', child: Text('Workshop')),
//                   DropdownMenuItem(value: 'competition', child: Text('Competition')),
//                 ],
//                 onChanged: (v) => setState(() => type = v!),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('CANCEL'),
//             ),
//             FilledButton(
//               style: FilledButton.styleFrom(backgroundColor: kPrimaryBlue),
//               onPressed: () async {
//                 await ref.read(opportunitiesProvider.notifier).createOpportunity(
//                   title: content.title,
//                   type: type,
//                   description: content.summary,
//                   sourceUrl: content.sourceUrl,
//                 );
//                 if (context.mounted) Navigator.pop(context);
//                 if (context.mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Added to opportunities!')),
//                   );
//                 }
//               },
//               child: const Text('ADD'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ACTIVITY CARD (LeetCode/GitHub)
// class _ActivityCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Color color;
//   final Map<String, dynamic> data;
//   final VoidCallback onSync;

//   const _ActivityCard({
//     required this.title,
//     required this.icon,
//     required this.color,
//     required this.data,
//     required this.onSync,
//   });

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
//           Row(
//             children: [
//               Icon(icon, color: color, size: 24),
//               const SizedBox(width: 12),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w900,
//                   color: kPrimaryBlue,
//                   letterSpacing: 1,
//                 ),
//               ),
//               const Spacer(),
//               IconButton(
//                 icon: const Icon(Icons.refresh, color: kPrimaryBlue),
//                 onPressed: onSync,
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'Username: ${data['username']}',
//             style: TextStyle(
//               color: kPrimaryBlue.withOpacity(0.6),
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 12),
//           _buildPlatformDetails(data),
//         ],
//       ),
//     );
//   }

//   Widget _buildPlatformDetails(Map<String, dynamic> data) {
//     if (title == 'LEETCODE') {
//       final problems = data['problemsSolved'] as Map<String, dynamic>?;
//       return Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _MiniStat(label: 'TOTAL', value: '${problems?['total'] ?? 0}'),
//               _MiniStat(label: 'EASY', value: '${problems?['easy'] ?? 0}'),
//               _MiniStat(label: 'MEDIUM', value: '${problems?['medium'] ?? 0}'),
//               _MiniStat(label: 'HARD', value: '${problems?['hard'] ?? 0}'),
//             ],
//           ),
//           if (data['ranking'] != null) ...[
//             const SizedBox(height: 12),
//             Text(
//               'Global Rank: ${data['ranking']}',
//               style: TextStyle(
//                 color: kPrimaryBlue.withOpacity(0.6),
//                 fontSize: 11,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ],
//       );
//     } else {
//       // GitHub
//       final activity = data['activitySummary'] as Map<String, dynamic>?;
//       return Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _MiniStat(label: 'COMMITS', value: '${activity?['commits'] ?? 0}'),
//               _MiniStat(label: 'PRS', value: '${activity?['pullRequests'] ?? 0}'),
//               _MiniStat(label: 'ISSUES', value: '${activity?['issues'] ?? 0}'),
//               _MiniStat(label: 'REPOS', value: '${data['publicRepos'] ?? 0}'),
//             ],
//           ),
//         ],
//       );
//     }
//   }
// }

// // HELPER WIDGETS
// class _FilterChip extends StatelessWidget {
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const _FilterChip({
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected ? kPrimaryBlue : kSapphireTintFill,
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: isSelected ? Colors.white : kPrimaryBlue,
//             fontWeight: FontWeight.w900,
//             fontSize: 10,
//             letterSpacing: 1,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _PlatformBadge extends StatelessWidget {
//   final String platform;
//   const _PlatformBadge({required this.platform});

//   @override
//   Widget build(BuildContext context) {
//     Color color;
//     switch (platform.toLowerCase()) {
//       case 'devpost':
//         color = Colors.purple;
//         break;
//       case 'internshala':
//         color = Colors.blue;
//         break;
//       case 'angellist':
//         color = Colors.orange;
//         break;
//       default:
//         color = Colors.grey;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Text(
//         platform.toUpperCase(),
//         style: TextStyle(
//           color: color,
//           fontSize: 9,
//           fontWeight: FontWeight.w900,
//         ),
//       ),
//     );
//   }
// }

// class _StatItem extends StatelessWidget {
//   final String label;
//   final String value;
//   final IconData icon;

//   const _StatItem({
//     required this.label,
//     required this.value,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Icon(icon, size: 28, color: kPrimaryBlue),
//         const SizedBox(height: 8),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w900,
//             color: kPrimaryBlue,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 9,
//             fontWeight: FontWeight.w800,
//             color: kPrimaryBlue.withOpacity(0.4),
//             letterSpacing: 1,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _MiniStat extends StatelessWidget {
//   final String label;
//   final String value;

//   const _MiniStat({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w900,
//             color: kPrimaryBlue,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 8,
//             fontWeight: FontWeight.w800,
//             color: kPrimaryBlue.withOpacity(0.4),
//             letterSpacing: 1,
//           ),
//         ),
//       ],
//     );
//   }
// }

// // SETUP DIALOG
// class _SetupDialog extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<_SetupDialog> createState() => _SetupDialogState();
// }

// class _SetupDialogState extends ConsumerState<_SetupDialog> {

//   final _leetcodeController = TextEditingController();
//   final _githubController = TextEditingController();
//   final _platformController = TextEditingController();
//   final _urlController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       title: const Text(
//         'SETUP TRACKING',
//         style: TextStyle(
//           color: kPrimaryBlue,
//           fontWeight: FontWeight.w900,
//           letterSpacing: 1,
//         ),
//       ),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Activity Trackers', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _leetcodeController,
//               decoration: const InputDecoration(
//                 labelText: 'LeetCode Username',
//                 prefixIcon: Icon(Icons.code),
//               ),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _githubController,
//               decoration: const InputDecoration(
//                 labelText: 'GitHub Username',
//                 prefixIcon: Icon(Icons.code_outlined),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text('Scraping Platforms', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _platformController,
//               decoration: const InputDecoration(
//                 labelText: 'Platform Name',
//                 hintText: 'e.g., devpost, internshala',
//               ),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _urlController,
//               decoration: const InputDecoration(
//                 labelText: 'Custom URL (optional)',
//                 hintText: 'https://example.com',
//               ),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('CANCEL'),
//         ),
//         FilledButton(
//           style: FilledButton.styleFrom(backgroundColor: kPrimaryBlue),
//           onPressed: () async {
//             // Setup LeetCode
//             if (_leetcodeController.text.isNotEmpty) {
//               await ref.read(activityDashboardProvider.notifier).setupTracker(
//                     'leetcode',
//                     _leetcodeController.text,
//                   );
//             }

//             // Setup GitHub
//             if (_githubController.text.isNotEmpty) {
//               await ref.read(activityDashboardProvider.notifier).setupTracker(
//                     'github',
//                     _githubController.text,
//                   );
//             }

//             // Add scraping platform
//             if (_platformController.text.isNotEmpty) {
//               await ref.read(scrapedContentProvider.notifier).addCustomUrl(
//                     _platformController.text,
//                     _urlController.text.isEmpty ? null : _urlController.text,
//                   );
//             }

//             if (context.mounted) Navigator.pop(context);
//           },
//           child: const Text('SAVE'),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _leetcodeController.dispose();
//     _githubController.dispose();
//     _platformController.dispose();
//     _urlController.dispose();
//     super.dispose();
//   }

  
// }

// // PROFILE CARD (GitHub/LeetCode/Codeforces)
// class _ProfileCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Color color;
//   final dynamic data;

//   const _ProfileCard({
//     required this.title,
//     required this.icon,
//     required this.color,
//     required this.data,
//   });

//   @override
//   Widget build(BuildContext context) {
//     Map<String, dynamic> metadata = {};
//     try {
//       metadata = jsonDecode(data.metadata ?? '{}');
//     } catch (e) {
//       // ignore
//     }

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: kSapphireTintFill,
//         borderRadius: BorderRadius.circular(kBorderRadius),
//         border: Border.all(color: color.withOpacity(0.1), width: 2),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, color: color, size: 24),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w900,
//                         color: kPrimaryBlue,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                     Text(
//                       metadata['username'] ?? 'Unknown',
//                       style: TextStyle(
//                         color: kPrimaryBlue.withOpacity(0.5),
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.open_in_new, color: color),
//                 onPressed: () async {
//                   final url = Uri.parse(data.sourceUrl);
//                   if (await canLaunchUrl(url)) {
//                     await launchUrl(url);
//                   }
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           _buildStats(metadata),
//         ],
//       ),
//     );
//   }

//   Widget _buildStats(Map<String, dynamic> metadata) {
//     if (title == 'GITHUB') {
//       return Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _StatBox(
//                 label: 'CONTRIBUTIONS',
//                 value: '${metadata['contributions'] ?? 0}',
//                 color: color,
//               ),
//               _StatBox(
//                 label: 'REPOS',
//                 value: '${metadata['repos'] ?? 0}',
//                 color: color,
//               ),
//             ],
//           ),
//         ],
//       );
//     } else if (title == 'LEETCODE') {
//       return Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _StatBox(label: 'EASY', value: '${metadata['easy'] ?? 0}', color: Colors.green),
//               _StatBox(label: 'MEDIUM', value: '${metadata['medium'] ?? 0}', color: Colors.orange),
//               _StatBox(label: 'HARD', value: '${metadata['hard'] ?? 0}', color: Colors.red),
//               _StatBox(label: 'TOTAL', value: '${metadata['total'] ?? 0}', color: color),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.05),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Ranking:',
//                       style: TextStyle(
//                         color: kPrimaryBlue.withOpacity(0.6),
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Text(
//                       '#${metadata['ranking'] ?? 'N/A'}',
//                       style: const TextStyle(
//                         color: kPrimaryBlue,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Next Contest:',
//                       style: TextStyle(
//                         color: kPrimaryBlue.withOpacity(0.6),
//                         fontSize: 11,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         metadata['nextContest'] ?? 'None',
//                         style: TextStyle(
//                           color: kPrimaryBlue.withOpacity(0.8),
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.right,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     } else {
//       // Codeforces
//       return Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _StatBox(
//                 label: 'RATING',
//                 value: '${metadata['rating'] ?? 0}',
//                 color: color,
//               ),
//               _StatBox(
//                 label: 'MAX RATING',
//                 value: '${metadata['maxRating'] ?? 0}',
//                 color: color,
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.05),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Rank:',
//                       style: TextStyle(
//                         color: kPrimaryBlue.withOpacity(0.6),
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Text(
//                       metadata['rank'] ?? 'Unrated',
//                       style: const TextStyle(
//                         color: kPrimaryBlue,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Next Contest:',
//                       style: TextStyle(
//                         color: kPrimaryBlue.withOpacity(0.6),
//                         fontSize: 11,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         metadata['nextContest'] ?? 'None',
//                         style: TextStyle(
//                           color: kPrimaryBlue.withOpacity(0.8),
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.right,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     }
//   }
// }

// class _StatBox extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color color;

//   const _StatBox({
//     required this.label,
//     required this.value,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w900,
//               color: color,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 8,
//               fontWeight: FontWeight.w800,
//               color: color.withOpacity(0.6),
//               letterSpacing: 1,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





























// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../providers/scraping_provider.dart';
// import '../providers/activity_provider.dart';
// import '../providers/opportunities_provider.dart';
// import 'dart:convert';


// // --- BRAND CONSTANTS ---
// const Color kPrimaryBlue = Color(0xFF274B7F);
// const Color kBackgroundWhite = Color(0xFFFFFFFF);
// const Color kSapphireTintFill = Color(0xFFF1F5F9);
// const Color kAccentBlue = Color(0xFFE8F1FF);
// const double kBorderRadius = 24.0;


// class DiscoverScreen extends ConsumerStatefulWidget {
//   const DiscoverScreen({super.key});

//   @override
//   ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
// }


// class _DiscoverScreenState extends ConsumerState<DiscoverScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String _selectedPlatform = 'all';
//   String _selectedType = 'all';
//   String _selectedStatus = 'all';

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final scrapedContentAsync = ref.watch(scrapedContentProvider);
//     final unreadCount = ref.watch(unreadScrapedContentCountProvider);

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
//               "DISCOVER & TRACK",
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
//               ref.read(scrapedContentProvider.notifier).scrapeAll();
//               ref.read(activityDashboardProvider.notifier).syncAll();
//               ref.read(opportunitiesProvider.notifier).loadOpportunities();
//             },
//           ),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: kPrimaryBlue,
//           unselectedLabelColor: kPrimaryBlue.withOpacity(0.5),
//           indicatorColor: kPrimaryBlue,
//           labelStyle: const TextStyle(
//             fontWeight: FontWeight.w900,
//             fontSize: 12,
//             letterSpacing: 1.5,
//           ),
//           tabs: [
//             const Tab(text: 'OPPORTUNITIES'),
//             Tab(
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text('DISCOVER'),
//                   if (unreadCount > 0) ...[
//                     const SizedBox(width: 8),
//                     Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: const BoxDecoration(
//                         color: kPrimaryBlue,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Text(
//                         '$unreadCount',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             const Tab(text: 'MY PROFILES'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildOpportunitiesTab(),
//           _buildDiscoverTab(scrapedContentAsync),
//           _buildProfilesTab(scrapedContentAsync),
//         ],
//       ),
//       floatingActionButton: _tabController.index == 2
//           ? FloatingActionButton.extended(
//               backgroundColor: kPrimaryBlue,
//               onPressed: () => _showSetupDialog(context),
//               icon: const Icon(Icons.settings_rounded, color: Colors.white),
//               label: const Text(
//                 'SETUP',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1.2,
//                 ),
//               ),
//             )
//           : null,
//     );
//   }

//   // TAB 1: OPPORTUNITIES MANAGEMENT
//   Widget _buildOpportunitiesTab() {
//     final opportunitiesAsync = ref.watch(opportunitiesProvider);
//     final opportunityStatsAsync = ref.watch(opportunityStatsProvider);

//     return Column(
//       children: [
//         // Stats Banner
//         opportunityStatsAsync.when(
//           data: (stats) => Container(
//             margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: kSapphireTintFill,
//               borderRadius: BorderRadius.circular(kBorderRadius),
//               border: Border.all(color: kPrimaryBlue.withOpacity(0.05)),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _StatItem(label: 'TOTAL', value: '${stats['total']}', icon: Icons.folder),
//                 _StatItem(label: 'RELEVANT', value: '${stats['highRelevance']}', icon: Icons.star),
//                 _StatItem(label: 'APPLIED', value: '${(stats['byStatus'] as Map)['applied'] ?? 0}', icon: Icons.send),
//                 _StatItem(label: 'URGENT', value: '${stats['upcomingDeadlines']}', icon: Icons.alarm),
//               ],
//             ),
//           ),
//           loading: () => const LinearProgressIndicator(color: kPrimaryBlue),
//           error: (_, __) => const SizedBox(),
//         ),

//         // Filters
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'TYPE',
//                 style: TextStyle(
//                   fontSize: 9,
//                   fontWeight: FontWeight.w900,
//                   color: kPrimaryBlue.withOpacity(0.5),
//                   letterSpacing: 2.5,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     _FilterChip(label: 'ALL', isSelected: _selectedType == 'all', onTap: () => setState(() => _selectedType = 'all')),
//                     const SizedBox(width: 8),
//                     _FilterChip(label: 'HACKATHONS', isSelected: _selectedType == 'hackathon', onTap: () => setState(() => _selectedType = 'hackathon')),
//                     const SizedBox(width: 8),
//                     _FilterChip(label: 'INTERNSHIPS', isSelected: _selectedType == 'internship', onTap: () => setState(() => _selectedType = 'internship')),
//                     const SizedBox(width: 8),
//                     _FilterChip(label: 'SCHOLARSHIPS', isSelected: _selectedType == 'scholarship', onTap: () => setState(() => _selectedType = 'scholarship')),
//                     const SizedBox(width: 8),
//                     _FilterChip(label: 'WORKSHOPS', isSelected: _selectedType == 'workshop', onTap: () => setState(() => _selectedType = 'workshop')),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'STATUS',
//                 style: TextStyle(
//                   fontSize: 9,
//                   fontWeight: FontWeight.w900,
//                   color: kPrimaryBlue.withOpacity(0.5),
//                   letterSpacing: 2.5,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     _FilterChip(label: 'ALL', isSelected: _selectedStatus == 'all', onTap: () => setState(() => _selectedStatus = 'all')),
//                     const SizedBox(width: 8),
//                     _FilterChip(label: 'NEW', isSelected: _selectedStatus == 'discovered', onTap: () => setState(() => _selectedStatus = 'discovered')),
//                     const SizedBox(width: 8),
//                     _FilterChip(label: 'INTERESTED', isSelected: _selectedStatus == 'interested', onTap: () => setState(() => _selectedStatus = 'interested')),
//                     const SizedBox(width: 8),
//                     _FilterChip(label: 'APPLIED', isSelected: _selectedStatus == 'applied', onTap: () => setState(() => _selectedStatus = 'applied')),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Opportunities List
//         Expanded(
//           child: opportunitiesAsync.when(
//             data: (opportunities) {
//               final filtered = _filterOpportunities(opportunities);
//               if (filtered.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.search_off_rounded, size: 64, color: kPrimaryBlue.withOpacity(0.3)),
//                       const SizedBox(height: 16),
//                       const Text('NO OPPORTUNITIES FOUND', style: TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue)),
//                       const SizedBox(height: 16),
//                       FilledButton.icon(
//                         style: FilledButton.styleFrom(backgroundColor: kPrimaryBlue),
//                         onPressed: () => _showAddOpportunityDialog(context),
//                         icon: const Icon(Icons.add),
//                         label: const Text('ADD OPPORTUNITY'),
//                       ),
//                     ],
//                   ),
//                 );
//               }

//               return RefreshIndicator(
//                 color: kPrimaryBlue,
//                 onRefresh: () => ref.read(opportunitiesProvider.notifier).loadOpportunities(),
//                 child: ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 24),
//                   itemCount: filtered.length,
//                   itemBuilder: (context, index) => _OpportunityCard(opportunity: filtered[index]),
//                 ),
//               );
//             },
//             loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryBlue)),
//             error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: kPrimaryBlue))),
//           ),
//         ),
//       ],
//     );
//   }

//   // TAB 2: DISCOVER (Scraped Content)
//   Widget _buildDiscoverTab(AsyncValue<List<dynamic>> scrapedContentAsync) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'PLATFORM',
//                 style: TextStyle(
//                   fontSize: 9,
//                   fontWeight: FontWeight.w900,
//                   color: kPrimaryBlue.withOpacity(0.5),
//                   letterSpacing: 2.5,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     _FilterChip(label: 'ALL', isSelected: _selectedPlatform == 'all', onTap: () => setState(() => _selectedPlatform = 'all')),
//                     const SizedBox(width: 8),
//                     _FilterChip(label: 'DEVPOST', isSelected: _selectedPlatform == 'devpost', onTap: () => setState(() => _selectedPlatform = 'devpost')),
//                     const SizedBox(width: 8),
//                     _FilterChip(label: 'INTERNSHALA', isSelected: _selectedPlatform == 'internshala', onTap: () => setState(() => _selectedPlatform = 'internshala')),
//                     const SizedBox(width: 8),
//                     _FilterChip(label: 'ANGELLIST', isSelected: _selectedPlatform == 'angellist', onTap: () => setState(() => _selectedPlatform = 'angellist')),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: scrapedContentAsync.when(
//             data: (content) {
//               final filtered = _selectedPlatform == 'all'
//                   ? content.where((c) => c.platform != 'github' && c.platform != 'leetcode' && c.platform != 'codeforces').toList()
//                   : content.where((c) => c.platform == _selectedPlatform).toList();

//               if (filtered.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.search_off_rounded, size: 64, color: kPrimaryBlue.withOpacity(0.3)),
//                       const SizedBox(height: 16),
//                       const Text('NO OPPORTUNITIES FOUND', style: TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue)),
//                       const SizedBox(height: 8),
//                       TextButton(
//                         onPressed: () => ref.read(scrapedContentProvider.notifier).scrapeAll(),
//                         child: const Text('TAP TO SCRAPE NOW'),
//                       ),
//                     ],
//                   ),
//                 );
//               }

//               return RefreshIndicator(
//                 color: kPrimaryBlue,
//                 onRefresh: () => ref.read(scrapedContentProvider.notifier).loadScrapedContent(),
//                 child: ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: filtered.length,
//                   itemBuilder: (context, index) => _ScrapedContentCard(content: filtered[index]),
//                 ),
//               );
//             },
//             loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryBlue)),
//             error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: kPrimaryBlue))),
//           ),
//         ),
//       ],
//     );
//   }

//   // TAB 3: MY PROFILES
//   Widget _buildProfilesTab(AsyncValue<List<dynamic>> scrapedContentAsync) {
//     return scrapedContentAsync.when(
//       data: (content) {
//         final githubData = content.where((c) => c.platform == 'github').firstOrNull;
//         final leetcodeData = content.where((c) => c.platform == 'leetcode').firstOrNull;
//         final codeforcesData = content.where((c) => c.platform == 'codeforces').firstOrNull;

//         if (githubData == null && leetcodeData == null && codeforcesData == null) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.timeline_rounded, size: 64, color: kPrimaryBlue.withOpacity(0.3)),
//                 const SizedBox(height: 16),
//                 const Text('NO PROFILES SETUP', style: TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue)),
//                 const SizedBox(height: 8),
//                 const Text('Add your coding profiles in Settings', style: TextStyle(color: kPrimaryBlue)),
//               ],
//             ),
//           );
//         }

//         return RefreshIndicator(
//           color: kPrimaryBlue,
//           onRefresh: () => ref.read(scrapedContentProvider.notifier).scrapeAll(),
//           child: ListView(
//             padding: const EdgeInsets.all(16),
//             children: [
//               if (githubData != null) ...[
//                 _ProfileCard(title: 'GITHUB', icon: Icons.code, color: Colors.black87, data: githubData),
//                 const SizedBox(height: 16),
//               ],
//               if (leetcodeData != null) ...[
//                 _ProfileCard(title: 'LEETCODE', icon: Icons.terminal, color: Colors.orange, data: leetcodeData),
//                 const SizedBox(height: 16),
//               ],
//               if (codeforcesData != null) ...[
//                 _ProfileCard(title: 'CODEFORCES', icon: Icons.emoji_events, color: Colors.blue, data: codeforcesData),
//               ],
//             ],
//           ),
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryBlue)),
//       error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: kPrimaryBlue))),
//     );
//   }

//   // FILTER LOGIC
//   List<dynamic> _filterOpportunities(List<dynamic> opportunities) {
//     var filtered = opportunities;
//     if (_selectedType != 'all') filtered = filtered.where((o) => o.type == _selectedType).toList();
//     if (_selectedStatus != 'all') filtered = filtered.where((o) => o.status == _selectedStatus).toList();
//     filtered.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
//     return filtered;
//   }

//   void _showSetupDialog(BuildContext context) {
//     showDialog(context: context, builder: (context) => _SetupDialog());
//   }

//   void _showAddOpportunityDialog(BuildContext context) {
//     final titleController = TextEditingController();
//     final organizationController = TextEditingController();
//     final urlController = TextEditingController();
//     String type = 'hackathon';

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           title: const Text('NEW OPPORTUNITY', style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.w900)),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(controller: titleController, decoration: const InputDecoration(labelText: 'TITLE')),
//                 const SizedBox(height: 16),
//                 TextField(controller: organizationController, decoration: const InputDecoration(labelText: 'ORGANIZATION')),
//                 const SizedBox(height: 16),
//                 TextField(controller: urlController, decoration: const InputDecoration(labelText: 'URL')),
//                 const SizedBox(height: 16),
//                 DropdownButtonFormField<String>(
//                   initialValue: type,
//                   decoration: const InputDecoration(labelText: 'TYPE'),
//                   items: const [
//                     DropdownMenuItem(value: 'hackathon', child: Text('Hackathon')),
//                     DropdownMenuItem(value: 'internship', child: Text('Internship')),
//                     DropdownMenuItem(value: 'scholarship', child: Text('Scholarship')),
//                     DropdownMenuItem(value: 'workshop', child: Text('Workshop')),
//                   ],
//                   onChanged: (v) => setState(() => type = v!),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
//             FilledButton(
//               style: FilledButton.styleFrom(backgroundColor: kPrimaryBlue),
//               onPressed: () async {
//                 if (titleController.text.isEmpty) return;
//                 await ref.read(opportunitiesProvider.notifier).createOpportunity(
//                   title: titleController.text,
//                   type: type,
//                   organization: organizationController.text.isEmpty ? null : organizationController.text,
//                   sourceUrl: urlController.text.isEmpty ? null : urlController.text,
//                 );
//                 if (context.mounted) Navigator.pop(context);
//               },
//               child: const Text('ADD'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ========== OPPORTUNITY CARD ==========
// class _OpportunityCard extends ConsumerWidget {
//   final dynamic opportunity;
//   const _OpportunityCard({required this.opportunity});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: kSapphireTintFill,
//         borderRadius: BorderRadius.circular(kBorderRadius),
//         border: Border.all(color: kPrimaryBlue.withOpacity(0.05)),
//       ),
//       child: InkWell(
//         onTap: () => _showOpportunityDetails(context, ref, opportunity),
//         borderRadius: BorderRadius.circular(kBorderRadius),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(opportunity.title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue, fontSize: 16)),
//                         if (opportunity.organization != null)
//                           Text(opportunity.organization!.toUpperCase(), style: TextStyle(color: kPrimaryBlue.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                   ),
//                   _ExecutiveRelevanceIndicator(score: opportunity.relevanceScore),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   _StatusChip(status: opportunity.status),
//                   const SizedBox(width: 8),
//                   _TypeBadge(type: opportunity.type),
//                 ],
//               ),
//               if (opportunity.deadline != null) ...[
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_today_rounded, size: 14, color: kPrimaryBlue.withOpacity(0.5)),
//                     const SizedBox(width: 6),
//                     Text('DEADLINE: ${_formatDate(opportunity.deadline)}', style: TextStyle(color: kPrimaryBlue.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.w800)),
//                   ],
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

//   void _showOpportunityDetails(BuildContext context, WidgetRef ref, dynamic opportunity) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: kBackgroundWhite,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
//       isScrollControlled: true,
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.6,
//         expand: false,
//         builder: (context, scrollController) => Padding(
//           padding: const EdgeInsets.all(32),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(opportunity.title.toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: kPrimaryBlue)),
//               const SizedBox(height: 8),
//               if (opportunity.organization != null) Text(opportunity.organization!.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   _StatusChip(status: opportunity.status),
//                   const Spacer(),
//                   _ExecutiveRelevanceIndicator(score: opportunity.relevanceScore),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               if (opportunity.description != null) Text(opportunity.description!, style: TextStyle(color: kPrimaryBlue.withOpacity(0.7), fontSize: 16)),
//               const Spacer(),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   if (opportunity.status == 'discovered')
//                     FilledButton.icon(
//                       style: FilledButton.styleFrom(backgroundColor: kPrimaryBlue, padding: const EdgeInsets.symmetric(vertical: 18)),
//                       onPressed: () async {
//                         await ref.read(opportunitiesProvider.notifier).updateStatus(opportunity.id, 'interested');
//                         if (context.mounted) Navigator.pop(context);
//                       },
//                       icon: const Icon(Icons.favorite_rounded),
//                       label: const Text('MARK AS INTERESTED'),
//                     ),
//                   if (opportunity.status == 'interested')
//                     FilledButton.icon(
//                       style: FilledButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 18)),
//                       onPressed: () async {
//                         await ref.read(opportunitiesProvider.notifier).updateStatus(opportunity.id, 'applied');
//                         if (context.mounted) Navigator.pop(context);
//                       },
//                       icon: const Icon(Icons.send_rounded),
//                       label: const Text('MARK AS APPLIED'),
//                     ),
//                   const SizedBox(height: 12),
//                   OutlinedButton.icon(
//                     style: OutlinedButton.styleFrom(foregroundColor: kPrimaryBlue, padding: const EdgeInsets.symmetric(vertical: 18)),
//                     onPressed: () async {
//                       await ref.read(opportunitiesProvider.notifier).updateStatus(opportunity.id, 'ignored');
//                       if (context.mounted) Navigator.pop(context);
//                     },
//                     icon: const Icon(Icons.block_rounded),
//                     label: const Text('IGNORE'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ========== SCRAPED CONTENT CARD ==========
// class _ScrapedContentCard extends ConsumerWidget {
//   final dynamic content;
//   const _ScrapedContentCard({required this.content});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: kSapphireTintFill,
//         borderRadius: BorderRadius.circular(kBorderRadius),
//         border: Border.all(color: kPrimaryBlue.withOpacity(0.05)),
//       ),
//       child: InkWell(
//         onTap: () async {
//           await ref.read(scrapedContentProvider.notifier).markAsRead(content.id);
//           if (await canLaunchUrl(Uri.parse(content.sourceUrl))) {
//             await launchUrl(Uri.parse(content.sourceUrl));
//           }
//         },
//         borderRadius: BorderRadius.circular(kBorderRadius),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Expanded(child: Text(content.title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue, fontSize: 14))),
//                   _PlatformBadge(platform: content.platform),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Text(content.summary, style: TextStyle(color: kPrimaryBlue.withOpacity(0.6), fontSize: 12, height: 1.4), maxLines: 3, overflow: TextOverflow.ellipsis),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Icon(Icons.open_in_new_rounded, size: 14, color: kPrimaryBlue.withOpacity(0.5)),
//                   const SizedBox(width: 6),
//                   Expanded(child: Text(content.sourceUrl, style: TextStyle(color: kPrimaryBlue.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
//                   IconButton(icon: const Icon(Icons.add_circle_outline, color: kPrimaryBlue), onPressed: () => _showAddToOpportunitiesDialog(context, ref, content)),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showAddToOpportunitiesDialog(BuildContext context, WidgetRef ref, dynamic content) {
//     String type = 'hackathon';
//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           title: const Text('ADD TO OPPORTUNITIES', style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.w900)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(content.title, style: const TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 initialValue: type,
//                 decoration: const InputDecoration(labelText: 'TYPE'),
//                 items: const [
//                   DropdownMenuItem(value: 'hackathon', child: Text('Hackathon')),
//                   DropdownMenuItem(value: 'internship', child: Text('Internship')),
//                   DropdownMenuItem(value: 'scholarship', child: Text('Scholarship')),
//                   DropdownMenuItem(value: 'workshop', child: Text('Workshop')),
//                 ],
//                 onChanged: (v) => setState(() => type = v!),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
//             FilledButton(
//               style: FilledButton.styleFrom(backgroundColor: kPrimaryBlue),
//               onPressed: () async {
//                 await ref.read(opportunitiesProvider.notifier).createOpportunity(title: content.title, type: type, description: content.summary, sourceUrl: content.sourceUrl);
//                 if (context.mounted) Navigator.pop(context);
//                 if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to opportunities!')));
//               },
//               child: const Text('ADD'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ========== PROFILE CARD ==========
// class _ProfileCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Color color;
//   final dynamic data;

//   const _ProfileCard({required this.title, required this.icon, required this.color, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     Map<String, dynamic> metadata = {};
//     try {
//       metadata = jsonDecode(data.metadata ?? '{}');
//     } catch (e) {}

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: kSapphireTintFill,
//         borderRadius: BorderRadius.circular(kBorderRadius),
//         border: Border.all(color: color.withOpacity(0.1), width: 2),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 24)),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kPrimaryBlue)),
//                     Text(metadata['username'] ?? 'Unknown', style: TextStyle(color: kPrimaryBlue.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.w600)),
//                   ],
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.open_in_new, color: color),
//                 onPressed: () async {
//                   final url = Uri.parse(data.sourceUrl);
//                   if (await canLaunchUrl(url)) await launchUrl(url);
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           _buildStats(metadata),
//         ],
//       ),
//     );
//   }

//   Widget _buildStats(Map<String, dynamic> metadata) {
//     if (title == 'GITHUB') {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _StatBox(label: 'CONTRIBUTIONS', value: '${metadata['contributions'] ?? 0}', color: color),
//           _StatBox(label: 'REPOS', value: '${metadata['repos'] ?? 0}', color: color),
//         ],
//       );
//     } else if (title == 'LEETCODE') {
//       return Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _StatBox(label: 'EASY', value: '${metadata['easy'] ?? 0}', color: Colors.green),
//               _StatBox(label: 'MEDIUM', value: '${metadata['medium'] ?? 0}', color: Colors.orange),
//               _StatBox(label: 'HARD', value: '${metadata['hard'] ?? 0}', color: Colors.red),
//               _StatBox(label: 'TOTAL', value: '${metadata['total'] ?? 0}', color: color),
//             ],
//           ),
//         ],
//       );
//     } else {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _StatBox(label: 'RATING', value: '${metadata['rating'] ?? 0}', color: color),
//           _StatBox(label: 'MAX RATING', value: '${metadata['maxRating'] ?? 0}', color: color),
//         ],
//       );
//     }
//   }
// }

// // ========== HELPER WIDGETS ==========
// class _FilterChip extends StatelessWidget {
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;
//   const _FilterChip({required this.label, required this.isSelected, required this.onTap});
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: onTap,
//     child: AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       decoration: BoxDecoration(color: isSelected ? kPrimaryBlue : kSapphireTintFill, borderRadius: BorderRadius.circular(30)),
//       child: Text(label, style: TextStyle(color: isSelected ? Colors.white : kPrimaryBlue, fontWeight: FontWeight.w900, fontSize: 10)),
//     ),
//   );
// }

// class _PlatformBadge extends StatelessWidget {
//   final String platform;
//   const _PlatformBadge({required this.platform});
//   @override
//   Widget build(BuildContext context) {
//     Color color = platform.toLowerCase() == 'devpost' ? Colors.purple : platform.toLowerCase() == 'internshala' ? Colors.blue : Colors.orange;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
//       child: Text(platform.toUpperCase(), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900)),
//     );
//   }
// }

// class _StatItem extends StatelessWidget {
//   final String label, value;
//   final IconData icon;
//   const _StatItem({required this.label, required this.value, required this.icon});
//   @override
//   Widget build(BuildContext context) => Column(children: [Icon(icon, size: 28, color: kPrimaryBlue), const SizedBox(height: 8), Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: kPrimaryBlue)), Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: kPrimaryBlue.withOpacity(0.4)))]);
// }

// class _StatBox extends StatelessWidget {
//   final String label, value;
//   final Color color;
//   const _StatBox({required this.label, required this.value, required this.color});
//   @override
//   Widget build(BuildContext context) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//     decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
//     child: Column(children: [Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)), const SizedBox(height: 4), Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: color.withOpacity(0.6)))]),
//   );
// }

// class _TypeBadge extends StatelessWidget {
//   final String type;
//   const _TypeBadge({required this.type});
//   @override
//   Widget build(BuildContext context) {
//     IconData icon = type.toLowerCase() == 'hackathon' ? Icons.code_rounded : type.toLowerCase() == 'internship' ? Icons.work_outline_rounded : type.toLowerCase() == 'scholarship' ? Icons.school_rounded : Icons.group_rounded;
//     Color color = type.toLowerCase() == 'hackathon' ? Colors.purple : type.toLowerCase() == 'internship' ? Colors.blue : type.toLowerCase() == 'scholarship' ? Colors.green : Colors.orange;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 12, color: color), const SizedBox(width: 6), Text(type.toUpperCase(), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900))]),
//     );
//   }
// }

// class _StatusChip extends StatelessWidget {
//   final String status;
//   const _StatusChip({required this.status});
//   @override
//   Widget build(BuildContext context) {
//     Color color = status.toLowerCase() == 'discovered' ? Colors.blue : status.toLowerCase() == 'interested' ? Colors.orange : status.toLowerCase() == 'applied' ? Colors.green : Colors.grey;
//     String label = status.toLowerCase() == 'discovered' ? 'NEW' : status.toUpperCase();
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
//       child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900)),
//     );
//   }
// }

// class _ExecutiveRelevanceIndicator extends StatelessWidget {
//   final double score;
//   const _ExecutiveRelevanceIndicator({required this.score});
//   @override
//   Widget build(BuildContext context) {
//     final percentage = (score * 100).toInt();
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(color: kPrimaryBlue, borderRadius: BorderRadius.circular(12)),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.bolt_rounded, size: 12, color: Colors.white), const SizedBox(width: 4), Text('$percentage%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10))]),
//     );
//   }
// }

// // ========== SETUP DIALOG ==========
// class _SetupDialog extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<_SetupDialog> createState() => _SetupDialogState();
// }

// class _SetupDialogState extends ConsumerState<_SetupDialog> {
//   final _leetcodeController = TextEditingController();
//   final _githubController = TextEditingController();
//   final _platformController = TextEditingController();
//   final _urlController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       title: const Text('SETUP TRACKING', style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.w900)),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Activity Trackers', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             TextField(controller: _leetcodeController, decoration: const InputDecoration(labelText: 'LeetCode Username', prefixIcon: Icon(Icons.code))),
//             const SizedBox(height: 8),
//             TextField(controller: _githubController, decoration: const InputDecoration(labelText: 'GitHub Username', prefixIcon: Icon(Icons.code_outlined))),
//             const SizedBox(height: 24),
//             const Text('Scraping Platforms', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             TextField(controller: _platformController, decoration: const InputDecoration(labelText: 'Platform Name', hintText: 'e.g., devpost')),
//             const SizedBox(height: 8),
//             TextField(controller: _urlController, decoration: const InputDecoration(labelText: 'Custom URL (optional)')),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
//         FilledButton(
//           style: FilledButton.styleFrom(backgroundColor: kPrimaryBlue),
//           onPressed: () async {
//             if (_leetcodeController.text.isNotEmpty) await ref.read(activityDashboardProvider.notifier).setupTracker('leetcode', _leetcodeController.text);
//             if (_githubController.text.isNotEmpty) await ref.read(activityDashboardProvider.notifier).setupTracker('github', _githubController.text);
//             if (_platformController.text.isNotEmpty) await ref.read(scrapedContentProvider.notifier).addCustomUrl(_platformController.text, _urlController.text.isEmpty ? null : _urlController.text);
//             if (context.mounted) Navigator.pop(context);
//           },
//           child: const Text('SAVE'),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _leetcodeController.dispose();
//     _githubController.dispose();
//     _platformController.dispose();
//     _urlController.dispose();
//     super.dispose();
//   }
// }























import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/scraping_provider.dart';
import '../providers/activity_provider.dart';
import '../providers/opportunities_provider.dart';
import 'dart:convert';


// --- BRAND CONSTANTS ---
const Color kPrimaryBlue = Color(0xFF274B7F);
const Color kBackgroundWhite = Color(0xFFFFFFFF);
const Color kSapphireTintFill = Color(0xFFF1F5F9);
const Color kAccentBlue = Color(0xFFE8F1FF);
const double kBorderRadius = 24.0;


class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}


class _DiscoverScreenState extends ConsumerState<DiscoverScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPlatform = 'all';
  String _selectedType = 'all';
  String _selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Add listener to rebuild when tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrapedContentAsync = ref.watch(scrapedContentProvider);
    final unreadCount = ref.watch(unreadScrapedContentCountProvider);

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
              "DISCOVER & TRACK",
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
              ref.read(scrapedContentProvider.notifier).scrapeAll();
              ref.read(activityDashboardProvider.notifier).syncAll();
              ref.read(opportunitiesProvider.notifier).loadOpportunities();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: kPrimaryBlue,
          unselectedLabelColor: kPrimaryBlue.withOpacity(0.5),
          indicatorColor: kPrimaryBlue,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
          tabs: [
            const Tab(text: 'MY INTERESTS'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('DISCOVER'),
                  if (unreadCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: kPrimaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Tab(text: 'MY PROFILES'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(), // Prevent swipe gestures from interfering
        children: [
          _buildOpportunitiesTab(),
          _buildDiscoverTab(scrapedContentAsync),
          _buildProfilesTab(scrapedContentAsync),
        ],
      ),
      floatingActionButton: _tabController.index == 2
          ? FloatingActionButton.extended(
              backgroundColor: kPrimaryBlue,
              onPressed: () => _showSetupDialog(context),
              icon: const Icon(Icons.settings_rounded, color: Colors.white),
              label: const Text(
                'SETUP',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            )
          : null,
    );
  }

  // TAB 1: OPPORTUNITIES MANAGEMENT
  Widget _buildOpportunitiesTab() {
    final opportunitiesAsync = ref.watch(opportunitiesProvider);
    final opportunityStatsAsync = ref.watch(opportunityStatsProvider);

    return Column(
      children: [
        // Stats Banner
        opportunityStatsAsync.when(
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
                _StatItem(label: 'TOTAL', value: '${stats['total']}', icon: Icons.folder),
                _StatItem(label: 'RELEVANT', value: '${stats['highRelevance']}', icon: Icons.star),
                _StatItem(label: 'APPLIED', value: '${(stats['byStatus'] as Map)['applied'] ?? 0}', icon: Icons.send),
                _StatItem(label: 'URGENT', value: '${stats['upcomingDeadlines']}', icon: Icons.alarm),
              ],
            ),
          ),
          loading: () => const LinearProgressIndicator(color: kPrimaryBlue),
          error: (_, __) => const SizedBox(),
        ),

        // Filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TYPE',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: kPrimaryBlue.withOpacity(0.5),
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
              const SizedBox(height: 16),
              Text(
                'STATUS',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: kPrimaryBlue.withOpacity(0.5),
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
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
                      Icon(Icons.search_off_rounded, size: 64, color: kPrimaryBlue.withOpacity(0.3)),
                      const SizedBox(height: 16),
                      const Text('NO OPPORTUNITIES FOUND', style: TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue)),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: kPrimaryBlue),
                        onPressed: () => _showAddOpportunityDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('ADD OPPORTUNITY'),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: kPrimaryBlue,
                onRefresh: () => ref.read(opportunitiesProvider.notifier).loadOpportunities(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => _OpportunityCard(opportunity: filtered[index]),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryBlue)),
            error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: kPrimaryBlue))),
          ),
        ),
      ],
    );
  }

  // TAB 2: DISCOVER (Scraped Content)
  Widget _buildDiscoverTab(AsyncValue<List<dynamic>> scrapedContentAsync) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PLATFORM',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: kPrimaryBlue.withOpacity(0.5),
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(label: 'ALL', isSelected: _selectedPlatform == 'all', onTap: () => setState(() => _selectedPlatform = 'all')),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'DEVPOST', isSelected: _selectedPlatform == 'devpost', onTap: () => setState(() => _selectedPlatform = 'devpost')),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'INTERNSHALA', isSelected: _selectedPlatform == 'internshala', onTap: () => setState(() => _selectedPlatform = 'internshala')),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'ANGELLIST', isSelected: _selectedPlatform == 'angellist', onTap: () => setState(() => _selectedPlatform = 'angellist')),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: scrapedContentAsync.when(
            data: (content) {
              final filtered = _selectedPlatform == 'all'
                  ? content.where((c) => c.platform != 'github' && c.platform != 'leetcode' && c.platform != 'codeforces').toList()
                  : content.where((c) => c.platform == _selectedPlatform).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off_rounded, size: 64, color: kPrimaryBlue.withOpacity(0.3)),
                      const SizedBox(height: 16),
                      const Text('NO OPPORTUNITIES FOUND', style: TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue)),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => ref.read(scrapedContentProvider.notifier).scrapeAll(),
                        child: const Text('TAP TO SCRAPE NOW'),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: kPrimaryBlue,
                onRefresh: () => ref.read(scrapedContentProvider.notifier).loadScrapedContent(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => _ScrapedContentCard(content: filtered[index]),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryBlue)),
            error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: kPrimaryBlue))),
          ),
        ),
      ],
    );
  }

  // TAB 3: MY PROFILES
  Widget _buildProfilesTab(AsyncValue<List<dynamic>> scrapedContentAsync) {
    return scrapedContentAsync.when(
      data: (content) {
        try {
          final githubData = content.where((c) => c?.platform == 'github').firstOrNull;
          final leetcodeData = content.where((c) => c?.platform == 'leetcode').firstOrNull;
          final codeforcesData = content.where((c) => c?.platform == 'codeforces').firstOrNull;

          if (githubData == null && leetcodeData == null && codeforcesData == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timeline_rounded, size: 64, color: kPrimaryBlue.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text('NO PROFILES SETUP', style: TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue)),
                  const SizedBox(height: 8),
                  const Text('Add your coding profiles in Settings', style: TextStyle(color: kPrimaryBlue)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: kPrimaryBlue,
            onRefresh: () => ref.read(scrapedContentProvider.notifier).scrapeAll(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (githubData != null) ...[
                  _ProfileCard(title: 'GITHUB', icon: Icons.code, color: Colors.black87, data: githubData),
                  const SizedBox(height: 16),
                ],
                if (leetcodeData != null) ...[
                  _ProfileCard(title: 'LEETCODE', icon: Icons.terminal, color: Colors.orange, data: leetcodeData),
                  const SizedBox(height: 16),
                ],
                if (codeforcesData != null) ...[
                  _ProfileCard(title: 'CODEFORCES', icon: Icons.emoji_events, color: Colors.blue, data: codeforcesData),
                ],
              ],
            ),
          );
        } catch (e) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: kPrimaryBlue.withOpacity(0.3)),
                const SizedBox(height: 16),
                Text('Error loading profiles: $e', style: const TextStyle(color: kPrimaryBlue)),
              ],
            ),
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryBlue)),
      error: (err, stack) {
        debugPrint('Profile tab error: $err');
        debugPrint('Stack trace: $stack');
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: kPrimaryBlue.withOpacity(0.3)),
              const SizedBox(height: 16),
              Text('Error: $err', style: const TextStyle(color: kPrimaryBlue)),
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: kPrimaryBlue),
                onPressed: () => ref.read(scrapedContentProvider.notifier).scrapeAll(),
                child: const Text('RETRY'),
              ),
            ],
          ),
        );
      },
    );
  }

  // FILTER LOGIC
  List<dynamic> _filterOpportunities(List<dynamic> opportunities) {
    var filtered = opportunities;
    if (_selectedType != 'all') filtered = filtered.where((o) => o.type == _selectedType).toList();
    if (_selectedStatus != 'all') filtered = filtered.where((o) => o.status == _selectedStatus).toList();
    filtered.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    return filtered;
  }

  void _showSetupDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => _SetupDialog());
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
          title: const Text('NEW OPPORTUNITY', style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.w900)),
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

// ========== OPPORTUNITY CARD ==========
class _OpportunityCard extends ConsumerWidget {
  final dynamic opportunity;
  const _OpportunityCard({required this.opportunity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
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
                        Text(opportunity.title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue, fontSize: 16)),
                        if (opportunity.organization != null)
                          Text(opportunity.organization!.toUpperCase(), style: TextStyle(color: kPrimaryBlue.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold)),
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
                    Text('DEADLINE: ${_formatDate(opportunity.deadline)}', style: TextStyle(color: kPrimaryBlue.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.w800)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

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
              if (opportunity.organization != null) Text(opportunity.organization!.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              const SizedBox(height: 24),
              Row(
                children: [
                  _StatusChip(status: opportunity.status),
                  const Spacer(),
                  _ExecutiveRelevanceIndicator(score: opportunity.relevanceScore),
                ],
              ),
              const SizedBox(height: 24),
              if (opportunity.description != null) Text(opportunity.description!, style: TextStyle(color: kPrimaryBlue.withOpacity(0.7), fontSize: 16)),
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
}

// ========== SCRAPED CONTENT CARD ==========
class _ScrapedContentCard extends ConsumerWidget {
  final dynamic content;
  const _ScrapedContentCard({required this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kSapphireTintFill,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: kPrimaryBlue.withOpacity(0.05)),
      ),
      child: InkWell(
        onTap: () async {
          await ref.read(scrapedContentProvider.notifier).markAsRead(content.id);
          if (await canLaunchUrl(Uri.parse(content.sourceUrl))) {
            await launchUrl(Uri.parse(content.sourceUrl));
          }
        },
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(content.title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue, fontSize: 14))),
                  _PlatformBadge(platform: content.platform),
                ],
              ),
              const SizedBox(height: 12),
              Text(content.summary, style: TextStyle(color: kPrimaryBlue.withOpacity(0.6), fontSize: 12, height: 1.4), maxLines: 3, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.open_in_new_rounded, size: 14, color: kPrimaryBlue.withOpacity(0.5)),
                  const SizedBox(width: 6),
                  Expanded(child: Text(content.sourceUrl, style: TextStyle(color: kPrimaryBlue.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  IconButton(icon: const Icon(Icons.add_circle_outline, color: kPrimaryBlue), onPressed: () => _showAddToOpportunitiesDialog(context, ref, content)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddToOpportunitiesDialog(BuildContext context, WidgetRef ref, dynamic content) {
    String type = 'hackathon';
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('ADD TO OPPORTUNITIES', style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.w900)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(content.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'TYPE'),
                items: const [
                  DropdownMenuItem(value: 'hackathon', child: Text('Hackathon')),
                  DropdownMenuItem(value: 'internship', child: Text('Internship')),
                  DropdownMenuItem(value: 'scholarship', child: Text('Scholarship')),
                  DropdownMenuItem(value: 'workshop', child: Text('Workshop')),
                ],
                onChanged: (v) => setState(() => type = v!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: kPrimaryBlue),
              onPressed: () async {
                await ref.read(opportunitiesProvider.notifier).createOpportunity(title: content.title, type: type, description: content.summary, sourceUrl: content.sourceUrl);
                if (context.mounted) Navigator.pop(context);
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to opportunities!')));
              },
              child: const Text('ADD'),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== PROFILE CARD ==========
class _ProfileCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final dynamic data;

  const _ProfileCard({required this.title, required this.icon, required this.color, required this.data});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> metadata = {};
    try {
      metadata = jsonDecode(data.metadata ?? '{}');
    } catch (e) {
      debugPrint('Error parsing metadata: $e');
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kSapphireTintFill,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: color.withOpacity(0.1), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kPrimaryBlue)),
                    Text(metadata['username'] ?? 'Unknown', style: TextStyle(color: kPrimaryBlue.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.open_in_new, color: color),
                onPressed: () async {
                  final url = Uri.parse(data.sourceUrl);
                  if (await canLaunchUrl(url)) await launchUrl(url);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStats(metadata),
        ],
      ),
    );
  }

  Widget _buildStats(Map<String, dynamic> metadata) {
    if (title == 'GITHUB') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatBox(label: 'CONTRIBUTIONS', value: '${metadata['contributions'] ?? 0}', color: color),
          _StatBox(label: 'REPOS', value: '${metadata['repos'] ?? 0}', color: color),
        ],
      );
    } else if (title == 'LEETCODE') {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatBox(label: 'EASY', value: '${metadata['easy'] ?? 0}', color: Colors.green),
              _StatBox(label: 'MEDIUM', value: '${metadata['medium'] ?? 0}', color: Colors.orange),
              _StatBox(label: 'HARD', value: '${metadata['hard'] ?? 0}', color: Colors.red),
              _StatBox(label: 'TOTAL', value: '${metadata['total'] ?? 0}', color: color),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatBox(label: 'RATING', value: '${metadata['rating'] ?? 0}', color: color),
          _StatBox(label: 'MAX RATING', value: '${metadata['maxRating'] ?? 0}', color: color),
        ],
      );
    }
  }
}

// ========== HELPER WIDGETS ==========
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
      child: Text(label, style: TextStyle(color: isSelected ? Colors.white : kPrimaryBlue, fontWeight: FontWeight.w900, fontSize: 10)),
    ),
  );
}

class _PlatformBadge extends StatelessWidget {
  final String platform;
  const _PlatformBadge({required this.platform});
  @override
  Widget build(BuildContext context) {
    Color color = platform.toLowerCase() == 'devpost' ? Colors.purple : platform.toLowerCase() == 'internshala' ? Colors.blue : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(platform.toUpperCase(), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900)),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _StatItem({required this.label, required this.value, required this.icon});
  @override
  Widget build(BuildContext context) => Column(children: [Icon(icon, size: 28, color: kPrimaryBlue), const SizedBox(height: 8), Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: kPrimaryBlue)), Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: kPrimaryBlue.withOpacity(0.4)))]);
}

class _StatBox extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatBox({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
    child: Column(children: [Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)), const SizedBox(height: 4), Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: color.withOpacity(0.6)))]),
  );
}

class _TypeBadge extends StatelessWidget {
  final String type;
  const _TypeBadge({required this.type});
  @override
  Widget build(BuildContext context) {
    IconData icon = type.toLowerCase() == 'hackathon' ? Icons.code_rounded : type.toLowerCase() == 'internship' ? Icons.work_outline_rounded : type.toLowerCase() == 'scholarship' ? Icons.school_rounded : Icons.group_rounded;
    Color color = type.toLowerCase() == 'hackathon' ? Colors.purple : type.toLowerCase() == 'internship' ? Colors.blue : type.toLowerCase() == 'scholarship' ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 12, color: color), const SizedBox(width: 6), Text(type.toUpperCase(), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900))]),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});
  @override
  Widget build(BuildContext context) {
    Color color = status.toLowerCase() == 'discovered' ? Colors.blue : status.toLowerCase() == 'interested' ? Colors.orange : status.toLowerCase() == 'applied' ? Colors.green : Colors.grey;
    String label = status.toLowerCase() == 'discovered' ? 'NEW' : status.toUpperCase();
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
      child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.bolt_rounded, size: 12, color: Colors.white), const SizedBox(width: 4), Text('$percentage%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10))]),
    );
  }
}

// ========== SETUP DIALOG ==========
class _SetupDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<_SetupDialog> createState() => _SetupDialogState();
}

class _SetupDialogState extends ConsumerState<_SetupDialog> {
  final _leetcodeController = TextEditingController();
  final _githubController = TextEditingController();
  final _platformController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('SETUP TRACKING', style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.w900)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Activity Trackers', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: _leetcodeController, decoration: const InputDecoration(labelText: 'LeetCode Username', prefixIcon: Icon(Icons.code))),
            const SizedBox(height: 8),
            TextField(controller: _githubController, decoration: const InputDecoration(labelText: 'GitHub Username', prefixIcon: Icon(Icons.code_outlined))),
            const SizedBox(height: 24),
            const Text('Scraping Platforms', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: _platformController, decoration: const InputDecoration(labelText: 'Platform Name', hintText: 'e.g., devpost')),
            const SizedBox(height: 8),
            TextField(controller: _urlController, decoration: const InputDecoration(labelText: 'Custom URL (optional)')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: kPrimaryBlue),
          onPressed: () async {
            if (_leetcodeController.text.isNotEmpty) await ref.read(activityDashboardProvider.notifier).setupTracker('leetcode', _leetcodeController.text);
            if (_githubController.text.isNotEmpty) await ref.read(activityDashboardProvider.notifier).setupTracker('github', _githubController.text);
            if (_platformController.text.isNotEmpty) await ref.read(scrapedContentProvider.notifier).addCustomUrl(_platformController.text, _urlController.text.isEmpty ? null : _urlController.text);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('SAVE'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _leetcodeController.dispose();
    _githubController.dispose();
    _platformController.dispose();
    _urlController.dispose();
    super.dispose();
  }
}