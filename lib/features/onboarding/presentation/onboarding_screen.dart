import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/user_profile.dart';
import '../../../core/providers/service_providers.dart';
import '../../../l10n/app_localizations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      final user = ref.read(currentUserProvider)!;
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

      await ref.read(userServiceProvider).saveProfile(profile);
      ref.invalidate(userProfileProvider);

      if (mounted) context.go('/calendar');
    } catch (e) {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _skip() async {
    try {
      final user = ref.read(currentUserProvider)!;
      await ref.read(userServiceProvider).saveProfile(UserProfile(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        birthYear: 0,
        birthMonth: 0,
        birthDay: 0,
      ));
      ref.invalidate(userProfileProvider);
      if (mounted) context.go('/calendar');
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Icon(Icons.auto_awesome, size: 48, color: cs.primary),
                const SizedBox(height: 16),
                Text(
                  l.onboardingTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  l.onboardingSubtitle,
                  style: TextStyle(color: cs.onSurfaceVariant, height: 1.5),
                ),
                const SizedBox(height: 32),
                SegmentedButton<bool>(
                  segments: [
                    ButtonSegment(
                      value: false,
                      label: Text(l.onboardingSolar),
                      icon: const Icon(Icons.wb_sunny_outlined),
                    ),
                    ButtonSegment(
                      value: true,
                      label: Text(l.onboardingLunar),
                      icon: const Icon(Icons.nightlight_outlined),
                    ),
                  ],
                  selected: {_isLunar},
                  onSelectionChanged: (v) => setState(() => _isLunar = v.first),
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(const Size.fromHeight(48)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLunar ? l.onboardingLunarHint : l.onboardingSolarHint,
                  style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                      child: _Field(
                          controller: _yearCtrl,
                          label: l.onboardingYear,
                          min: 1900,
                          max: 2100,
                          requiredMsg: l.onboardingRequired,
                          rangeMsg: '1900–2100')),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _Field(
                          controller: _monthCtrl,
                          label: l.onboardingMonth,
                          min: 1,
                          max: 12,
                          requiredMsg: l.onboardingRequired,
                          rangeMsg: '1–12')),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _Field(
                          controller: _dayCtrl,
                          label: l.onboardingDay,
                          min: 1,
                          max: 31,
                          requiredMsg: l.onboardingRequired,
                          rangeMsg: '1–31')),
                ]),
                const SizedBox(height: 16),
                _Field(
                  controller: _hourCtrl,
                  label: l.onboardingHour,
                  min: 0,
                  max: 23,
                  required: false,
                  requiredMsg: l.onboardingRequired,
                  rangeMsg: '0–23',
                ),
                const SizedBox(height: 40),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52)),
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(l.onboardingStart,
                          style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _saving ? null : _skip,
                  style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(48)),
                  child: Text(l.onboardingSkip,
                      style: TextStyle(color: cs.onSurfaceVariant)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int min;
  final int max;
  final bool required;
  final String requiredMsg;
  final String rangeMsg;

  const _Field({
    required this.controller,
    required this.label,
    required this.min,
    required this.max,
    required this.requiredMsg,
    required this.rangeMsg,
    this.required = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: label, border: const OutlineInputBorder()),
      keyboardType: TextInputType.number,
      validator: (v) {
        if (!required && (v == null || v.isEmpty)) return null;
        if (required && (v == null || v.isEmpty)) return requiredMsg;
        final n = int.tryParse(v!);
        if (n == null || n < min || n > max) return rangeMsg;
        return null;
      },
    );
  }
}
