import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: studentAsync.when(
        data: (student) {
          if (student == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_off, size: 64),
                  const SizedBox(height: 16),
                  const Text('No profile found'),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => _showCreateProfileDialog(context, ref),
                    child: const Text('Create Profile'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          student.name[0].toUpperCase(),
                          style: const TextStyle(fontSize: 32, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        student.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        student.email,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),

                // Schedule Preferences
                _SettingsSection(
                  title: 'Schedule Preferences',
                  children: [
                    _SettingsTile(
                      icon: Icons.wb_sunny,
                      title: 'Wake Time',
                      subtitle: student.wakeTime,
                      onTap: () => _showTimePickerDialog(
                        context,
                        ref,
                        'Wake Time',
                        student.wakeTime,
                        (time) async {
                          await ref.read(studentProfileProvider.notifier).updateProfile(
                            wakeTime: time,
                          );
                        },
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.nightlight,
                      title: 'Sleep Time',
                      subtitle: student.sleepTime,
                      onTap: () => _showTimePickerDialog(
                        context,
                        ref,
                        'Sleep Time',
                        student.sleepTime,
                        (time) async {
                          await ref.read(studentProfileProvider.notifier).updateProfile(
                            sleepTime: time,
                          );
                        },
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.timer,
                      title: 'Study Block Duration',
                      subtitle: '${student.preferredStudyBlockMinutes} minutes',
                      onTap: () => _showDurationPickerDialog(
                        context,
                        ref,
                        'Study Block Duration',
                        student.preferredStudyBlockMinutes,
                        (duration) async {
                          await ref.read(studentProfileProvider.notifier).updateProfile(
                            preferredStudyBlockMinutes: duration,
                          );
                        },
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.coffee,
                      title: 'Break Duration',
                      subtitle: '${student.preferredBreakMinutes} minutes',
                      onTap: () => _showDurationPickerDialog(
                        context,
                        ref,
                        'Break Duration',
                        student.preferredBreakMinutes,
                        (duration) async {
                          await ref.read(studentProfileProvider.notifier).updateProfile(
                            preferredBreakMinutes: duration,
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Account Settings
                _SettingsSection(
                  title: 'Account',
                  children: [
                    _SettingsTile(
                      icon: Icons.person,
                      title: 'Name',
                      subtitle: student.name,
                      onTap: () => _showTextEditDialog(
                        context,
                        ref,
                        'Name',
                        student.name,
                        (name) async {
                          await ref.read(studentProfileProvider.notifier).updateProfile(
                            name: name,
                          );
                        },
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.public,
                      title: 'Timezone',
                      subtitle: student.timezone,
                      onTap: () => _showTextEditDialog(
                        context,
                        ref,
                        'Timezone',
                        student.timezone,
                        (timezone) async {
                          await ref.read(studentProfileProvider.notifier).updateProfile(
                            timezone: timezone,
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Data & Privacy
                _SettingsSection(
                  title: 'Data & Privacy',
                  children: [
                    _SettingsTile(
                      icon: Icons.delete_forever,
                      title: 'Delete Account',
                      subtitle: 'Permanently delete your profile and data',
                      onTap: () => _showDeleteConfirmDialog(context, ref),
                      isDestructive: true,
                    ),
                  ],
                ),

                // App Info
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Student Butler 2.0',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('Version 1.0.0'),
                      SizedBox(height: 4),
                      Text('Built with Serverpod'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showCreateProfileDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (nameController.text.isEmpty || emailController.text.isEmpty) return;

              await ref.read(studentProfileProvider.notifier).createProfile(
                name: nameController.text,
                email: emailController.text,
                timezone: 'UTC',
                wakeTime: '07:00',
                sleepTime: '23:00',
                preferredStudyBlockMinutes: 50,
                preferredBreakMinutes: 10,
              );

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile created!')),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showTimePickerDialog(
    BuildContext context,
    WidgetRef ref,
    String title,
    String currentValue,
    Function(String) onSave,
  ) {
    final parts = currentValue.split(':');
    TimeOfDay initialTime = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );

    showTimePicker(
      context: context,
      initialTime: initialTime,
    ).then((time) async {
    if (time != null) {
      final formatted = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      await onSave(formatted);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title updated!')),
        );
      }
    }
  });
  }

  void _showDurationPickerDialog(
    BuildContext context,
    WidgetRef ref,
    String title,
    int currentValue,
    Function(int) onSave,
  ) {
    final controller = TextEditingController(text: currentValue.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Minutes',
            suffixText: 'min',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value > 0) {
                onSave(value);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title updated!')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showTextEditDialog(
    BuildContext context,
    WidgetRef ref,
    String title,
    String currentValue,
    Function(String) onSave,
  ) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onSave(controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title updated!')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'This will permanently delete your profile and all data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(studentProfileProvider.notifier).deleteProfile();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deleted')),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : null;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}