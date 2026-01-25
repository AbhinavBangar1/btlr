import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_provider.dart';

// --- BRAND CONSTANTS ---
const Color kPrimaryBlue = Color(0xFF274B7F); // BTLR Sapphire
const Color kBackgroundWhite = Color(0xFFFFFFFF);
const Color kSapphireTintFill = Color(0xFFF1F5F9); // Light bluish tint
const double kBorderRadius = 24.0;

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentProfileProvider);

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
              "PREFERENCES",
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 3,
                color: kPrimaryBlue.withOpacity(0.5),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      body: studentAsync.when(
        data: (student) {
          if (student == null) return _NoProfileState(onAction: () => _showCreateProfileDialog(context, ref));

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // 1. REDESIGNED PREMIUM PROFILE HERO (Centered Small Rect, No Badge)
                _StaggeredEntrance(
                  delayIndex: 0,
                  // Wrap in Center for horizontal alignment
                  child: Center(
                    child: Container(
                      // Fixed smaller dimensions
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      height: 200,
                      width: 300,
                      child: Stack(
                        children: [
                          // Main Card Body
                          Container(
                            margin: const EdgeInsets.only(top: 40),
                            padding: const EdgeInsets.fromLTRB(24, 55, 24, 24),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [kPrimaryBlue, Color(0xFF3B64A0)],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: kPrimaryBlue.withOpacity(0.25),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  student.name.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  student.email.toLowerCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                //Badge removed from here
                              ],
                            ),
                          ),
                          // Elevated Avatar
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: kBackgroundWhite, width: 4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 42,
                                backgroundColor: const Color(0xFFF1F5F9),
                                child: Text(
                                  student.name[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 36,
                                    color: kPrimaryBlue,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 2. SETTINGS LIST (Sapphire Tinted)
                _StaggeredEntrance(
                  delayIndex: 1,
                  child: _SettingsSection(
                    title: 'SCHEDULE PREFERENCES',
                    children: [
                      _SettingsTile(
                        icon: Icons.wb_sunny_rounded,
                        title: 'Wake Time',
                        subtitle: student.wakeTime,
                        onTap: () => _showTimePickerDialog(context, ref, 'Wake Time', student.wakeTime,
                                (time) async => await ref.read(studentProfileProvider.notifier).updateProfile(wakeTime: time)),
                      ),
                      _SettingsTile(
                        icon: Icons.nightlight_round,
                        title: 'Sleep Time',
                        subtitle: student.sleepTime,
                        onTap: () => _showTimePickerDialog(context, ref, 'Sleep Time', student.sleepTime,
                                (time) async => await ref.read(studentProfileProvider.notifier).updateProfile(sleepTime: time)),
                      ),
                      _SettingsTile(
                        icon: Icons.timer_rounded,
                        title: 'Study Duration',
                        subtitle: '${student.preferredStudyBlockMinutes} minutes',
                        onTap: () => _showDurationPickerDialog(context, ref, 'Study Duration', student.preferredStudyBlockMinutes,
                                (dur) async => await ref.read(studentProfileProvider.notifier).updateProfile(preferredStudyBlockMinutes: dur)),
                      ),
                      _SettingsTile(
                        icon: Icons.coffee_rounded,
                        title: 'Break Duration',
                        subtitle: '${student.preferredBreakMinutes} minutes',
                        onTap: () => _showDurationPickerDialog(context, ref, 'Break Duration', student.preferredBreakMinutes,
                                (dur) async => await ref.read(studentProfileProvider.notifier).updateProfile(preferredBreakMinutes: dur)),
                      ),
                    ],
                  ),
                ),

                _StaggeredEntrance(
                  delayIndex: 2,
                  child: _SettingsSection(
                    title: 'ACCOUNT CONFIGURATION',
                    children: [
                      _SettingsTile(
                        icon: Icons.person_rounded,
                        title: 'Name',
                        subtitle: student.name,
                        onTap: () => _showTextEditDialog(context, ref, 'Name', student.name,
                                (name) async => await ref.read(studentProfileProvider.notifier).updateProfile(name: name)),
                      ),
                      _SettingsTile(
                        icon: Icons.public_rounded,
                        title: 'Timezone',
                        subtitle: student.timezone,
                        onTap: () => _showTextEditDialog(context, ref, 'Timezone', student.timezone,
                                (tz) async => await ref.read(studentProfileProvider.notifier).updateProfile(timezone: tz)),
                      ),
                    ],
                  ),
                ),

                _StaggeredEntrance(
                  delayIndex: 3,
                  child: _SettingsSection(
                    title: 'PRIVACY & SECURITY',
                    children: [
                      _SettingsTile(
                        icon: Icons.delete_forever_rounded,
                        title: 'Delete Account',
                        subtitle: 'Permanently remove your profile',
                        onTap: () => _showDeleteConfirmDialog(context, ref),
                        isDestructive: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                const _AppInfoFooter(),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryBlue)),
        error: (error, _) => Center(child: Text('Error: $error', style: const TextStyle(color: kPrimaryBlue))),
      ),
    );
  }

  // Logic blocks remain exactly as provided to protect backend
  void _showCreateProfileDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => _ThemedDialog(
        title: 'CREATE PROFILE',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'NAME')),
            const SizedBox(height: 16),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'EMAIL')),
          ],
        ),
        onAction: () async {
          if (nameController.text.isEmpty || emailController.text.isEmpty) return;
          await ref.read(studentProfileProvider.notifier).createProfile(
            name: nameController.text, email: emailController.text, timezone: 'UTC', wakeTime: '07:00', sleepTime: '23:00', preferredStudyBlockMinutes: 50, preferredBreakMinutes: 10,
          );
          if (context.mounted) Navigator.pop(context);
        },
        actionLabel: 'CREATE',
      ),
    );
  }

  void _showTimePickerDialog(BuildContext context, WidgetRef ref, String title, String current, Function(String) onSave) {
    final parts = current.split(':');
    showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
      builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: kPrimaryBlue)), child: child!),
    ).then((time) async {
      if (time != null) {
        final formatted = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        await onSave(formatted);
      }
    });
  }

  void _showDurationPickerDialog(BuildContext context, WidgetRef ref, String title, int current, Function(int) onSave) {
    final controller = TextEditingController(text: current.toString());
    showDialog(
      context: context,
      builder: (context) => _ThemedDialog(
        title: title.toUpperCase(),
        content: TextField(controller: controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'MINUTES', suffixText: 'min')),
        onAction: () {
          final value = int.tryParse(controller.text);
          if (value != null && value > 0) { onSave(value); Navigator.pop(context); }
        },
        actionLabel: 'SAVE',
      ),
    );
  }

  void _showTextEditDialog(BuildContext context, WidgetRef ref, String title, String current, Function(String) onSave) {
    final controller = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (context) => _ThemedDialog(
        title: 'EDIT $title',
        content: TextField(controller: controller, decoration: InputDecoration(labelText: title.toUpperCase())),
        onAction: () {
          if (controller.text.isNotEmpty) { onSave(controller.text); Navigator.pop(context); }
        },
        actionLabel: 'SAVE',
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _ThemedDialog(
        title: 'DELETE ACCOUNT?',
        content: const Text('This will permanently delete your profile and all data. This action cannot be undone.', style: TextStyle(color: kPrimaryBlue)),
        onAction: () async {
          await ref.read(studentProfileProvider.notifier).deleteProfile();
          if (context.mounted) Navigator.pop(context);
        },
        actionLabel: 'DELETE',
        isDestructive: true,
      ),
    );
  }
}

// --- SUB-COMPONENTS ---

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 16, 12),
          child: Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: kPrimaryBlue, letterSpacing: 2.5)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: kSapphireTintFill,
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  final bool isDestructive;
  const _SettingsTile({required this.icon, required this.title, required this.subtitle, required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.redAccent : kPrimaryBlue;
    return ListTile(
      leading: Container(
        height: 40, width: 40,
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 15)),
      subtitle: Text(subtitle, style: TextStyle(color: kPrimaryBlue.withOpacity(0.5), fontSize: 13)),
      trailing: Icon(Icons.chevron_right_rounded, color: kPrimaryBlue.withOpacity(0.3)),
      onTap: onTap,
    );
  }
}

class _ThemedDialog extends StatelessWidget {
  final String title, actionLabel;
  final Widget content;
  final VoidCallback onAction;
  final bool isDestructive;
  const _ThemedDialog({required this.title, required this.content, required this.onAction, required this.actionLabel, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kBorderRadius)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue, fontSize: 18, letterSpacing: 1)),
      content: content,
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: kPrimaryBlue))),
        FilledButton(onPressed: onAction, style: FilledButton.styleFrom(backgroundColor: isDestructive ? Colors.redAccent : kPrimaryBlue), child: Text(actionLabel)),
      ],
    );
  }
}

class _AppInfoFooter extends StatelessWidget {
  const _AppInfoFooter();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("STUDENT BUTLER 2.0", style: TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue, fontSize: 14, letterSpacing: 2.5)),
        const SizedBox(height: 8),
        Text("VERSION 1.0.0", style: TextStyle(color: kPrimaryBlue.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text("POWERED BY SERVERPOD", style: TextStyle(color: kPrimaryBlue.withOpacity(0.4), fontSize: 10, letterSpacing: 1)),
      ],
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
      child: AnimatedPadding(duration: const Duration(milliseconds: 1000), curve: Curves.easeOutQuart, padding: EdgeInsets.only(top: _visible ? 0 : 30), child: widget.child),
    );
  }
}

class _NoProfileState extends StatelessWidget {
  final VoidCallback onAction;
  const _NoProfileState({required this.onAction});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_off_rounded, size: 80, color: kPrimaryBlue),
          const SizedBox(height: 24),
          const Text('NO PROFILE FOUND', style: TextStyle(fontWeight: FontWeight.w900, color: kPrimaryBlue, fontSize: 18, letterSpacing: 1)),
          const SizedBox(height: 32),
          FilledButton(onPressed: onAction, style: FilledButton.styleFrom(backgroundColor: kPrimaryBlue, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20)), child: const Text('CREATE PROFILE')),
        ],
      ),
    );
  }
}