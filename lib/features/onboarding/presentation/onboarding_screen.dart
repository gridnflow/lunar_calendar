import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/user_profile.dart';
import '../../../core/providers/service_providers.dart';

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
  }

  Future<void> _skip() async {
    // 생년월일 없이 진행 — birthYear=0으로 빈 프로필 저장
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
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
                  '생년월일을 알려주세요',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '사주와 오늘의 운세에 활용됩니다.\n나중에 Settings에서 변경할 수 있어요.',
                  style: TextStyle(
                      color: cs.onSurfaceVariant, height: 1.5),
                ),
                const SizedBox(height: 40),
                Row(children: [
                  Expanded(
                      child: _Field(
                          controller: _yearCtrl,
                          label: '년',
                          min: 1900,
                          max: 2100)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _Field(
                          controller: _monthCtrl,
                          label: '월',
                          min: 1,
                          max: 12)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _Field(
                          controller: _dayCtrl,
                          label: '일',
                          min: 1,
                          max: 31)),
                ]),
                const SizedBox(height: 16),
                _Field(
                  controller: _hourCtrl,
                  label: '태어난 시간 (선택, 0–23)',
                  min: 0,
                  max: 23,
                  required: false,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('음력 생일'),
                  value: _isLunar,
                  onChanged: (v) => setState(() => _isLunar = v),
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
                      : const Text('시작하기', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _saving ? null : _skip,
                  style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(48)),
                  child: Text('나중에 입력할게요',
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

  const _Field({
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
      decoration: InputDecoration(
          labelText: label, border: const OutlineInputBorder()),
      keyboardType: TextInputType.number,
      validator: (v) {
        if (!required && (v == null || v.isEmpty)) return null;
        if (required && (v == null || v.isEmpty)) return '필수';
        final n = int.tryParse(v!);
        if (n == null || n < min || n > max) return '$min–$max';
        return null;
      },
    );
  }
}
