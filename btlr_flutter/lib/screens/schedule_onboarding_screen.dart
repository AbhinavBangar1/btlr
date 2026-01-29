// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// const Color kPrimaryBlue = Color(0xFF274B7F);
// const Color kBackgroundWhite = Color(0xFFFFFFFF);
// const Color kSapphireTintFill = Color(0xFFF1F5F9);
// const double kBorderRadius = 24.0;

// class ScheduleOnboardingScreen extends ConsumerStatefulWidget {
//   final int studentProfileId;
//   final VoidCallback onComplete;
  
//   const ScheduleOnboardingScreen({
//     super.key,
//     required this.studentProfileId,
//     required this.onComplete,
//   });

//   @override
//   ConsumerState<ScheduleOnboardingScreen> createState() => _ScheduleOnboardingScreenState();
// }

// class _ScheduleOnboardingScreenState extends ConsumerState<ScheduleOnboardingScreen> {
//   final List<AcademicScheduleInput> _schedules = [];
//   bool _isLoading = false;

//   void _addSchedule() {
//     showDialog(
//       context: context,
//       builder: (context) => _AddScheduleDialog(
//         onAdd: (schedule) {
//           setState(() => _schedules.add(schedule));
//         },
//       ),
//     );
//   }

//   void _editSchedule(int index) {
//     showDialog(
//       context: context,
//       builder: (context) => _AddScheduleDialog(
//         initialSchedule: _schedules[index],
//         onAdd: (schedule) {
//           setState(() => _schedules[index] = schedule);
//         },
//       ),
//     );
//   }

//   void _removeSchedule(int index) {
//     setState(() => _schedules.removeAt(index));
//   }

//   Future<void> _submit() async {
//     if (_schedules.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please add at least one class schedule'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       // Call your backend to create all schedules
//       for (final schedule in _schedules) {
//         // await ref.read(academicScheduleProvider.notifier).createSchedule(schedule);
//         // Replace above with your actual provider call
//       }

//       if (mounted) {
//         widget.onComplete();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error saving schedules: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBackgroundWhite,
//       appBar: AppBar(
//         backgroundColor: kBackgroundWhite,
//         elevation: 0,
//         centerTitle: true,
//         title: Column(
//           children: [
//             const Text(
//               "BTLR",
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.w900,
//                 color: kPrimaryBlue,
//                 letterSpacing: -2,
//               ),
//             ),
//             Text(
//               "SETUP YOUR SCHEDULE",
//               style: TextStyle(
//                 fontSize: 8,
//                 letterSpacing: 2,
//                 color: kPrimaryBlue.withOpacity(0.5),
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             margin: const EdgeInsets.all(24),
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: kSapphireTintFill,
//               borderRadius: BorderRadius.circular(kBorderRadius),
//               border: Border.all(color: kPrimaryBlue.withOpacity(0.1)),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Welcome! 👋',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w900,
//                     color: kPrimaryBlue,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   'Let\'s set up your college/school schedule so we can create the perfect study plan for you.',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: kPrimaryBlue.withOpacity(0.7),
//                     height: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           Expanded(
//             child: _schedules.isEmpty
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.school_rounded,
//                           size: 64,
//                           color: kPrimaryBlue.withOpacity(0.3),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'NO CLASSES ADDED YET',
//                           style: TextStyle(
//                             color: kPrimaryBlue.withOpacity(0.5),
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Tap the + button to add your classes',
//                           style: TextStyle(
//                             color: kPrimaryBlue.withOpacity(0.4),
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                     itemCount: _schedules.length,
//                     itemBuilder: (context, index) {
//                       final schedule = _schedules[index];
//                       return _ScheduleCard(
//                         schedule: schedule,
//                         onEdit: () => _editSchedule(index),
//                         onDelete: () => _removeSchedule(index),
//                       );
//                     },
//                   ),
//           ),

//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: kBackgroundWhite,
//               boxShadow: [
//                 BoxShadow(
//                   color: kPrimaryBlue.withOpacity(0.05),
//                   blurRadius: 20,
//                   offset: const Offset(0, -5),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton.icon(
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: kPrimaryBlue,
//                       side: const BorderSide(color: kPrimaryBlue, width: 2),
//                       padding: const EdgeInsets.symmetric(vertical: 18),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                     onPressed: _addSchedule,
//                     icon: const Icon(Icons.add_rounded),
//                     label: const Text(
//                       'ADD CLASS',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 SizedBox(
//                   width: double.infinity,
//                   child: FilledButton.icon(
//                     style: FilledButton.styleFrom(
//                       backgroundColor: kPrimaryBlue,
//                       padding: const EdgeInsets.symmetric(vertical: 18),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                     onPressed: _isLoading ? null : _submit,
//                     icon: _isLoading
//                         ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                         : const Icon(Icons.check_rounded),
//                     label: Text(
//                       _isLoading ? 'SAVING...' : 'FINISH SETUP',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (_schedules.isEmpty) ...[
//                   const SizedBox(height: 12),
//                   TextButton(
//                     onPressed: widget.onComplete,
//                     child: Text(
//                       'SKIP FOR NOW',
//                       style: TextStyle(
//                         color: kPrimaryBlue.withOpacity(0.6),
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ScheduleCard extends StatelessWidget {
//   final AcademicScheduleInput schedule;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;

//   const _ScheduleCard({
//     required this.schedule,
//     required this.onEdit,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: kSapphireTintFill,
//         borderRadius: BorderRadius.circular(kBorderRadius),
//         border: Border.all(color: kPrimaryBlue.withOpacity(0.05)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: kPrimaryBlue.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     _getTypeIcon(schedule.type),
//                     color: kPrimaryBlue,
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         schedule.title,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w900,
//                           color: kPrimaryBlue,
//                           fontSize: 16,
//                         ),
//                       ),
//                       Text(
//                         schedule.type.toUpperCase(),
//                         style: TextStyle(
//                           color: kPrimaryBlue.withOpacity(0.5),
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 1,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.edit_rounded),
//                   onPressed: onEdit,
//                   color: kPrimaryBlue,
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete_outline_rounded),
//                   onPressed: onDelete,
//                   color: Colors.red,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             if (schedule.location != null)
//               Row(
//                 children: [
//                   Icon(Icons.location_on_rounded,
//                       size: 14, color: kPrimaryBlue.withOpacity(0.6)),
//                   const SizedBox(width: 6),
//                   Text(
//                     schedule.location!,
//                     style: TextStyle(
//                       color: kPrimaryBlue.withOpacity(0.6),
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.access_time_rounded,
//                     size: 14, color: kPrimaryBlue.withOpacity(0.6)),
//                 const SizedBox(width: 6),
//                 Text(
//                   '${_formatTime(schedule.startTime)} - ${_formatTime(schedule.endTime)}',
//                   style: TextStyle(
//                     color: kPrimaryBlue.withOpacity(0.6),
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             if (schedule.isRecurring && schedule.recurringDays.isNotEmpty) ...[
//               const SizedBox(height: 8),
//               Wrap(
//                 spacing: 6,
//                 children: schedule.recurringDays.map((day) {
//                   return Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: kPrimaryBlue.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       day,
//                       style: TextStyle(
//                         color: kPrimaryBlue,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   IconData _getTypeIcon(String type) {
//     switch (type) {
//       case 'class':
//         return Icons.school_rounded;
//       case 'lab':
//         return Icons.science_rounded;
//       case 'exam':
//         return Icons.quiz_rounded;
//       case 'workshop':
//         return Icons.groups_rounded;
//       default:
//         return Icons.event_rounded;
//     }
//   }

//   String _formatTime(TimeOfDay time) {
//     final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
//     final minute = time.minute.toString().padLeft(2, '0');
//     final period = time.period == DayPeriod.am ? 'AM' : 'PM';
//     return '$hour:$minute $period';
//   }
// }

// class _AddScheduleDialog extends StatefulWidget {
//   final AcademicScheduleInput? initialSchedule;
//   final Function(AcademicScheduleInput) onAdd;

//   const _AddScheduleDialog({
//     this.initialSchedule,
//     required this.onAdd,
//   });

//   @override
//   State<_AddScheduleDialog> createState() => _AddScheduleDialogState();
// }

// class _AddScheduleDialogState extends State<_AddScheduleDialog> {
//   late TextEditingController _titleController;
//   late TextEditingController _locationController;
//   String _type = 'class';
//   TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
//   TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
//   bool _isRecurring = true;
//   Set<String> _selectedDays = {};

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.initialSchedule?.title);
//     _locationController = TextEditingController(text: widget.initialSchedule?.location);
    
//     if (widget.initialSchedule != null) {
//       _type = widget.initialSchedule!.type;
//       _startTime = widget.initialSchedule!.startTime;
//       _endTime = widget.initialSchedule!.endTime;
//       _isRecurring = widget.initialSchedule!.isRecurring;
//       _selectedDays = widget.initialSchedule!.recurringDays.toSet();
//     }
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _locationController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectTime(bool isStartTime) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: isStartTime ? _startTime : _endTime,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: kPrimaryBlue,
//               onPrimary: Colors.white,
//               onSurface: kPrimaryBlue,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null) {
//       setState(() {
//         if (isStartTime) {
//           _startTime = picked;
//         } else {
//           _endTime = picked;
//         }
//       });
//     }
//   }

//   void _submit() {
//     if (_titleController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter a title'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     if (_isRecurring && _selectedDays.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select at least one day'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     widget.onAdd(
//       AcademicScheduleInput(
//         title: _titleController.text,
//         type: _type,
//         location: _locationController.text.isEmpty ? null : _locationController.text,
//         startTime: _startTime,
//         endTime: _endTime,
//         isRecurring: _isRecurring,
//         recurringDays: _selectedDays.toList(),
//       ),
//     );

//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       backgroundColor: kBackgroundWhite,
//       title: Text(
//         widget.initialSchedule == null ? 'ADD CLASS' : 'EDIT CLASS',
//         style: const TextStyle(
//           color: kPrimaryBlue,
//           fontWeight: FontWeight.w900,
//           letterSpacing: 1,
//         ),
//       ),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _titleController,
//               cursorColor: kPrimaryBlue,
//               decoration: InputDecoration(
//                 labelText: 'CLASS NAME*',
//                 labelStyle: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
//                 hintText: 'e.g., Data Structures',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
            
//             DropdownButtonFormField<String>(
//               value: _type,
//               decoration: InputDecoration(
//                 labelText: 'TYPE',
//                 labelStyle: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
//                 ),
//               ),
//               items: const [
//                 DropdownMenuItem(value: 'class', child: Text('Class')),
//                 DropdownMenuItem(value: 'lab', child: Text('Lab')),
//                 DropdownMenuItem(value: 'exam', child: Text('Exam')),
//                 DropdownMenuItem(value: 'workshop', child: Text('Workshop')),
//               ],
//               onChanged: (v) => setState(() => _type = v!),
//             ),
//             const SizedBox(height: 16),
            
//             TextField(
//               controller: _locationController,
//               cursorColor: kPrimaryBlue,
//               decoration: InputDecoration(
//                 labelText: 'LOCATION',
//                 labelStyle: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
//                 hintText: 'e.g., Room 301',
//                 prefixIcon: const Icon(Icons.location_on_rounded, color: kPrimaryBlue),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
            
//             Row(
//               children: [
//                 Expanded(
//                   child: InkWell(
//                     onTap: () => _selectTime(true),
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: kPrimaryBlue.withOpacity(0.3)),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'START TIME',
//                             style: TextStyle(
//                               color: kPrimaryBlue.withOpacity(0.7),
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             _startTime.format(context),
//                             style: const TextStyle(
//                               color: kPrimaryBlue,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: InkWell(
//                     onTap: () => _selectTime(false),
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: kPrimaryBlue.withOpacity(0.3)),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'END TIME',
//                             style: TextStyle(
//                               color: kPrimaryBlue.withOpacity(0.7),
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             _endTime.format(context),
//                             style: const TextStyle(
//                               color: kPrimaryBlue,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
            
//             SwitchListTile(
//               title: const Text(
//                 'RECURRING',
//                 style: TextStyle(
//                   color: kPrimaryBlue,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                 ),
//               ),
//               value: _isRecurring,
//               activeColor: kPrimaryBlue,
//               onChanged: (value) => setState(() => _isRecurring = value),
//             ),
            
//             if (_isRecurring) ...[
//               const SizedBox(height: 16),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'SELECT DAYS*',
//                   style: TextStyle(
//                     color: kPrimaryBlue.withOpacity(0.7),
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
//                   final isSelected = _selectedDays.contains(day);
//                   return FilterChip(
//                     label: Text(day),
//                     selected: isSelected,
//                     onSelected: (selected) {
//                       setState(() {
//                         if (selected) {
//                           _selectedDays.add(day);
//                         } else {
//                           _selectedDays.remove(day);
//                         }
//                       });
//                     },
//                     selectedColor: kPrimaryBlue,
//                     checkmarkColor: Colors.white,
//                     labelStyle: TextStyle(
//                       color: isSelected ? Colors.white : kPrimaryBlue,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('CANCEL', style: TextStyle(color: kPrimaryBlue)),
//         ),
//         FilledButton(
//           style: FilledButton.styleFrom(
//             backgroundColor: kPrimaryBlue,
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           ),
//           onPressed: _submit,
//           child: Text(
//             widget.initialSchedule == null ? 'ADD' : 'SAVE',
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class AcademicScheduleInput {
//   final String title;
//   final String type;
//   final String? location;
//   final TimeOfDay startTime;
//   final TimeOfDay endTime;
//   final bool isRecurring;
//   final List<String> recurringDays;

//   AcademicScheduleInput({
//     required this.title,
//     required this.type,
//     this.location,
//     required this.startTime,
//     required this.endTime,
//     required this.isRecurring,
//     required this.recurringDays,
//   });

//   // Helper to convert to RRULE format
//   String get rrule {
//     if (!isRecurring || recurringDays.isEmpty) return '';
    
//     final dayMap = {
//       'Mon': 'MO',
//       'Tue': 'TU',
//       'Wed': 'WE',
//       'Thu': 'TH',
//       'Fri': 'FR',
//       'Sat': 'SA',
//       'Sun': 'SU',
//     };
    
//     final days = recurringDays.map((d) => dayMap[d]!).join(',');
//     return 'FREQ=WEEKLY;BYDAY=$days';
//   }
// }





































































import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


const Color kPrimaryBlue = Color(0xFF274B7F);
const Color kBackgroundWhite = Color(0xFFFFFFFF);
const Color kSapphireTintFill = Color(0xFFF1F5F9);
const double kBorderRadius = 24.0;


class ScheduleOnboardingScreen extends ConsumerStatefulWidget {
  final int studentProfileId;
  final VoidCallback onComplete;
  
  const ScheduleOnboardingScreen({
    super.key,
    required this.studentProfileId,
    required this.onComplete,
  });


  @override
  ConsumerState<ScheduleOnboardingScreen> createState() => _ScheduleOnboardingScreenState();
}


class _ScheduleOnboardingScreenState extends ConsumerState<ScheduleOnboardingScreen> {
  final List<AcademicScheduleInput> _schedules = [];
  bool _isLoading = false;


  void _addSchedule() {
    showDialog(
      context: context,
      builder: (context) => _AddScheduleDialog(
        onAdd: (schedule) {
          setState(() => _schedules.add(schedule));
        },
      ),
    );
  }


  void _editSchedule(int index) {
    showDialog(
      context: context,
      builder: (context) => _AddScheduleDialog(
        initialSchedule: _schedules[index],
        onAdd: (schedule) {
          setState(() => _schedules[index] = schedule);
        },
      ),
    );
  }


  void _removeSchedule(int index) {
    setState(() => _schedules.removeAt(index));
  }


  Future<void> _submit() async {
    if (_schedules.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one class schedule'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }


    setState(() => _isLoading = true);


    try {
      // Call your backend to create all schedules
      for (final schedule in _schedules) {
        // await ref.read(academicScheduleProvider.notifier).createSchedule(schedule);
        // Replace above with your actual provider call
      }


      if (mounted) {
        widget.onComplete();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving schedules: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundWhite,
      appBar: AppBar(
        backgroundColor: kBackgroundWhite,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              "BTLR",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: kPrimaryBlue,
                letterSpacing: -2,
              ),
            ),
            Text(
              "SETUP YOUR SCHEDULE",
              style: TextStyle(
                fontSize: 8,
                letterSpacing: 2,
                color: kPrimaryBlue.withOpacity(0.5),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: kSapphireTintFill,
              borderRadius: BorderRadius.circular(kBorderRadius),
              border: Border.all(color: kPrimaryBlue.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome! 👋',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: kPrimaryBlue,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Let\'s set up your college/school schedule so we can create the perfect study plan for you.',
                  style: TextStyle(
                    fontSize: 14,
                    color: kPrimaryBlue.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),


          Expanded(
            child: _schedules.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_rounded,
                          size: 64,
                          color: kPrimaryBlue.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'NO CLASSES ADDED YET',
                          style: TextStyle(
                            color: kPrimaryBlue.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the + button to add your classes',
                          style: TextStyle(
                            color: kPrimaryBlue.withOpacity(0.4),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _schedules.length,
                    itemBuilder: (context, index) {
                      final schedule = _schedules[index];
                      return _ScheduleCard(
                        schedule: schedule,
                        onEdit: () => _editSchedule(index),
                        onDelete: () => _removeSchedule(index),
                      );
                    },
                  ),
          ),


          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: kBackgroundWhite,
              boxShadow: [
                BoxShadow(
                  color: kPrimaryBlue.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kPrimaryBlue,
                      side: const BorderSide(color: kPrimaryBlue, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _addSchedule,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text(
                      'ADD CLASS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: kPrimaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _isLoading ? null : _submit,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_rounded),
                    label: Text(
                      _isLoading ? 'SAVING...' : 'FINISH SETUP',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                if (_schedules.isEmpty) ...[
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: widget.onComplete,
                    child: Text(
                      'SKIP FOR NOW',
                      style: TextStyle(
                        color: kPrimaryBlue.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _ScheduleCard extends StatelessWidget {
  final AcademicScheduleInput schedule;
  final VoidCallback onEdit;
  final VoidCallback onDelete;


  const _ScheduleCard({
    required this.schedule,
    required this.onEdit,
    required this.onDelete,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: kSapphireTintFill,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: kPrimaryBlue.withOpacity(0.05)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kPrimaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTypeIcon(schedule.type),
                    color: kPrimaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: kPrimaryBlue,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        schedule.type.toUpperCase(),
                        style: TextStyle(
                          color: kPrimaryBlue.withOpacity(0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: onEdit,
                  color: kPrimaryBlue,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: onDelete,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (schedule.location != null)
              Row(
                children: [
                  Icon(Icons.location_on_rounded,
                      size: 14, color: kPrimaryBlue.withOpacity(0.6)),
                  const SizedBox(width: 6),
                  Text(
                    schedule.location!,
                    style: TextStyle(
                      color: kPrimaryBlue.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time_rounded,
                    size: 14, color: kPrimaryBlue.withOpacity(0.6)),
                const SizedBox(width: 6),
                Text(
                  '${_formatTime(schedule.startTime)} - ${_formatTime(schedule.endTime)}',
                  style: TextStyle(
                    color: kPrimaryBlue.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (schedule.isRecurring && schedule.recurringDays.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: schedule.recurringDays.map((day) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kPrimaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      day,
                      style: TextStyle(
                        color: kPrimaryBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }


  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'class':
        return Icons.school_rounded;
      case 'lab':
        return Icons.science_rounded;
      case 'exam':
        return Icons.quiz_rounded;
      case 'workshop':
        return Icons.groups_rounded;
      default:
        return Icons.event_rounded;
    }
  }


  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}


class _AddScheduleDialog extends StatefulWidget {
  final AcademicScheduleInput? initialSchedule;
  final Function(AcademicScheduleInput) onAdd;


  const _AddScheduleDialog({
    this.initialSchedule,
    required this.onAdd,
  });


  @override
  State<_AddScheduleDialog> createState() => _AddScheduleDialogState();
}


class _AddScheduleDialogState extends State<_AddScheduleDialog> {
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  String _type = 'class';
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  bool _isRecurring = true;
  Set<String> _selectedDays = {};


  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialSchedule?.title);
    _locationController = TextEditingController(text: widget.initialSchedule?.location);
    
    if (widget.initialSchedule != null) {
      _type = widget.initialSchedule!.type;
      _startTime = widget.initialSchedule!.startTime;
      _endTime = widget.initialSchedule!.endTime;
      _isRecurring = widget.initialSchedule!.isRecurring;
      _selectedDays = widget.initialSchedule!.recurringDays.toSet();
    }
  }


  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }


  Future<void> _selectTime(bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
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
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }


  void _submit() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }


    if (_isRecurring && _selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one day'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }


    widget.onAdd(
      AcademicScheduleInput(
        title: _titleController.text,
        type: _type,
        location: _locationController.text.isEmpty ? null : _locationController.text,
        startTime: _startTime,
        endTime: _endTime,
        isRecurring: _isRecurring,
        recurringDays: _selectedDays.toList(),
      ),
    );


    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: kBackgroundWhite,
      title: Text(
        widget.initialSchedule == null ? 'ADD CLASS' : 'EDIT CLASS',
        style: const TextStyle(
          color: kPrimaryBlue,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              cursorColor: kPrimaryBlue,
              decoration: InputDecoration(
                labelText: 'CLASS NAME*',
                labelStyle: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
                hintText: 'e.g., Data Structures',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _type,
              decoration: InputDecoration(
                labelText: 'TYPE',
                labelStyle: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'class', child: Text('Class')),
                DropdownMenuItem(value: 'lab', child: Text('Lab')),
                DropdownMenuItem(value: 'exam', child: Text('Exam')),
                DropdownMenuItem(value: 'workshop', child: Text('Workshop')),
              ],
              onChanged: (v) => setState(() => _type = v!),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _locationController,
              cursorColor: kPrimaryBlue,
              decoration: InputDecoration(
                labelText: 'LOCATION',
                labelStyle: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
                hintText: 'e.g., Room 301',
                prefixIcon: const Icon(Icons.location_on_rounded, color: kPrimaryBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(true),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryBlue.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'START TIME',
                            style: TextStyle(
                              color: kPrimaryBlue.withOpacity(0.7),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _startTime.format(context),
                            style: const TextStyle(
                              color: kPrimaryBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(false),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryBlue.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'END TIME',
                            style: TextStyle(
                              color: kPrimaryBlue.withOpacity(0.7),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _endTime.format(context),
                            style: const TextStyle(
                              color: kPrimaryBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            SwitchListTile(
              title: const Text(
                'RECURRING',
                style: TextStyle(
                  color: kPrimaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              value: _isRecurring,
              activeColor: kPrimaryBlue,
              onChanged: (value) => setState(() => _isRecurring = value),
            ),
            
            if (_isRecurring) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'SELECT DAYS*',
                  style: TextStyle(
                    color: kPrimaryBlue.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                  final isSelected = _selectedDays.contains(day);
                  return FilterChip(
                    label: Text(day),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedDays.add(day);
                        } else {
                          _selectedDays.remove(day);
                        }
                      });
                    },
                    selectedColor: kPrimaryBlue,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : kPrimaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
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
          onPressed: _submit,
          child: Text(
            widget.initialSchedule == null ? 'ADD' : 'SAVE',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}


class AcademicScheduleInput {
  final String title;
  final String type;
  final String? location;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool isRecurring;
  final List<String> recurringDays;


  AcademicScheduleInput({
    required this.title,
    required this.type,
    this.location,
    required this.startTime,
    required this.endTime,
    required this.isRecurring,
    required this.recurringDays,
  });


  // Helper to convert to RRULE format
  String get rrule {
    if (!isRecurring || recurringDays.isEmpty) return '';
    
    final dayMap = {
      'Mon': 'MO',
      'Tue': 'TU',
      'Wed': 'WE',
      'Thu': 'TH',
      'Fri': 'FR',
      'Sat': 'SA',
      'Sun': 'SU',
    };
    
    final days = recurringDays.map((d) => dayMap[d]!).join(',');
    return 'FREQ=WEEKLY;BYDAY=$days';
  }
}