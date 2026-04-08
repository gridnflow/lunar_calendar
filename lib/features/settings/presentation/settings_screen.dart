import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/models/user_profile.dart';
import '../../../core/services/user_service.dart';
import '../../../core/services/auth_service.dart';

final _userServiceProvider = Provider((ref) => UserService());
final _authServiceProvider = Provider((ref) => AuthService());

final _profileProvider = FutureProvider<UserProfile?>((ref) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return null;
  return ref.read(_userServiceProvider).getProfile(uid);
});

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _yearCtrl = TextEditingController();
  final _monthCtrl = TextEditingController();
  final _dayCtrl = TextEditingController();
  final _hourCtrl = TextEditingController();
  bool _isLunar = false;
  bool _saving = false;

  @override
  void dispose() {
    _yearCtrl.dispose();
    _monthCtrl.dispose();
    _dayCtrl.dispose();
    _hourCtrl.dispose();
    super.dispose();
  }

  void _prefillFromProfile(UserProfile profile) {
    _yearCtrl.text = profile.birthYear.toString();
    _monthCtrl.text = profile.birthMonth.toString();
    _dayCtrl.text = profile.birthDay.toString();
    _hourCtrl.text = profile.birthHour?.toString() ?? '';
    _isLunar = profile.isLunarBirth;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final user = FirebaseAuth.instance.currentUser!;
    final profile = UserProfile(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      birthYear: int.parse(_yearCtrl.text),
      birthMonth: int.parse(_monthCtrl.text),
      birthDay: int.parse(_dayCtrl.text),
      birthHour: _hourCtrl.text.isEmpty ? null : int.parse(_hourCtrl.text),
      isLunarBirth: _isLunar,
    );

    await ref.read(_userServiceProvider).saveProfile(profile);
    setState(() => _saving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved')),
      );
      ref.invalidate(_profileProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(_profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          if (profile != null && _yearCtrl.text.isEmpty) {
            _prefillFromProfile(profile);
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Birth Info', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: _NumberField(controller: _yearCtrl, label: 'Year', min: 1900, max: 2100)),
                    const SizedBox(width: 12),
                    Expanded(child: _NumberField(controller: _monthCtrl, label: 'Month', min: 1, max: 12)),
                    const SizedBox(width: 12),
                    Expanded(child: _NumberField(controller: _dayCtrl, label: 'Day', min: 1, max: 31)),
                  ]),
                  const SizedBox(height: 12),
                  _NumberField(controller: _hourCtrl, label: 'Hour (optional, 0–23)', min: 0, max: 23, required: false),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Lunar calendar birth date'),
                    value: _isLunar,
                    onChanged: (v) => setState(() => _isLunar = v),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                    child: _saving ? const CircularProgressIndicator() : const Text('Save'),
                  ),
                  const Divider(height: 48),
                  OutlinedButton(
                    onPressed: () => ref.read(_authServiceProvider).signOut(),
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int min;
  final int max;
  final bool required;

  const _NumberField({
    required this.controller,
    required this.label,
    required this.min,
    required this.max,
    this.required = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: TextInputType.number,
      validator: (v) {
        if (!required && (v == null || v.isEmpty)) return null;
        if (required && (v == null || v.isEmpty)) return 'Required';
        final n = int.tryParse(v!);
        if (n == null || n < min || n > max) return '$min–$max';
        return null;
      },
    );
  }
}
