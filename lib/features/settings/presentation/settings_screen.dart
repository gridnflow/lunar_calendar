import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/user_profile.dart';
import '../../../core/providers/service_providers.dart';
import '../../../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Future<void> _editBirthday(BuildContext context, AppLocalizations l) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final profile = await ref.read(userServiceProvider).getProfile(user.uid);

    final yearCtrl = TextEditingController(
        text: (profile != null && profile.birthYear != 0)
            ? '${profile.birthYear}'
            : '');
    final monthCtrl = TextEditingController(
        text: (profile != null && profile.birthMonth != 0)
            ? '${profile.birthMonth}'
            : '');
    final dayCtrl = TextEditingController(
        text: (profile != null && profile.birthDay != 0)
            ? '${profile.birthDay}'
            : '');
    final hourCtrl = TextEditingController(
        text: profile?.birthHour != null ? '${profile!.birthHour}' : '');
    bool isLunar = profile?.isLunarBirth ?? false;

    if (!context.mounted) return;

    final formKey = GlobalKey<FormState>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l.settingsBirthDate),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SegmentedButton<bool>(
                    segments: [
                      ButtonSegment(
                          value: false,
                          label: Text(l.onboardingSolar),
                          icon: const Icon(Icons.wb_sunny_outlined)),
                      ButtonSegment(
                          value: true,
                          label: Text(l.onboardingLunar),
                          icon: const Icon(Icons.nightlight_outlined)),
                    ],
                    selected: {isLunar},
                    onSelectionChanged: (v) =>
                        setState(() => isLunar = v.first),
                  ),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: _EditField(ctrl: yearCtrl, label: l.onboardingYear, min: 1900, max: 2100, required: true, requiredMsg: l.onboardingRequired)),
                    const SizedBox(width: 8),
                    Expanded(child: _EditField(ctrl: monthCtrl, label: l.onboardingMonth, min: 1, max: 12, required: true, requiredMsg: l.onboardingRequired)),
                    const SizedBox(width: 8),
                    Expanded(child: _EditField(ctrl: dayCtrl, label: l.onboardingDay, min: 1, max: 31, required: true, requiredMsg: l.onboardingRequired)),
                  ]),
                  const SizedBox(height: 12),
                  _EditField(ctrl: hourCtrl, label: l.onboardingHour, min: 0, max: 23, required: false, requiredMsg: l.onboardingRequired),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l.anniversaryCancel)),
            FilledButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(ctx, true);
                  }
                },
                child: Text(l.anniversarySave)),
          ],
        ),
      ),
    );

    if (confirmed != true) return;

    final updated = profile != null
        ? profile.copyWith(
            birthYear: int.parse(yearCtrl.text),
            birthMonth: int.parse(monthCtrl.text),
            birthDay: int.parse(dayCtrl.text),
            birthHour: hourCtrl.text.isEmpty ? null : int.parse(hourCtrl.text),
            isLunarBirth: isLunar,
          )
        : UserProfile(
            uid: user.uid,
            email: user.email ?? '',
            displayName: user.displayName ?? '',
            birthYear: int.parse(yearCtrl.text),
            birthMonth: int.parse(monthCtrl.text),
            birthDay: int.parse(dayCtrl.text),
            birthHour: hourCtrl.text.isEmpty ? null : int.parse(hourCtrl.text),
            isLunarBirth: isLunar,
          );
    await ref.read(userServiceProvider).saveProfile(updated);
    ref.invalidate(userProfileProvider);
    ref.invalidate(todayFortuneProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(userProfileProvider);
    final user = ref.read(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // 계정 정보 카드
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      (user?.displayName ?? '?').isNotEmpty
                          ? user!.displayName![0].toUpperCase()
                          : '?',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.displayName ?? '',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(user?.email ?? '',
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 생년월일 읽기 전용
          profileAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (err, st) => const SizedBox.shrink(),
            data: (profile) {
              if (profile == null || profile.birthYear == 0) {
                return OutlinedButton.icon(
                  onPressed: () => _editBirthday(context, l),
                  icon: const Icon(Icons.cake_outlined),
                  label: Text(l.settingsBirthDate),
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48)),
                );
              }
              return Card(
                child: InkWell(
                  onTap: () => _editBirthday(context, l),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.settingsBirthDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(
                                '${profile.birthYear}년 ${profile.birthMonth}월 ${profile.birthDay}일'
                                '${profile.birthHour != null ? '  ${profile.birthHour}시' : ''}'
                                '  (${profile.isLunarBirth ? l.onboardingLunar : l.onboardingSolar})',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.edit_outlined,
                            size: 18,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          OutlinedButton.icon(
            onPressed: () => context.push('/language'),
            icon: const Icon(Icons.language),
            label: Text(l.languageSelect),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48)),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => ref.read(authServiceProvider).signOut(),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48)),
            child: Text(l.settingsSignOut),
          ),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 8),

          Text(l.settingsLegalTitle,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _LegalTile(
            icon: Icons.shield_outlined,
            title: l.settingsPrivacy,
            body: l.settingsPrivacyBody,
          ),
          _LegalTile(
            icon: Icons.calendar_today_outlined,
            title: l.settingsCalendarPermission,
            body: l.settingsCalendarPermissionBody,
          ),
          _LegalTile(
            icon: Icons.notifications_outlined,
            title: l.settingsNotificationPermission,
            body: l.settingsNotificationPermissionBody,
          ),
          _LegalTile(
            icon: Icons.auto_awesome_outlined,
            title: l.settingsAI,
            body: l.settingsAIBody,
          ),
          _LegalTile(
            icon: Icons.ad_units_outlined,
            title: l.settingsAdMob,
            body: l.settingsAdMobBody,
          ),
          const SizedBox(height: 8),
          Text(
            l.settingsVersion('1.0.0'),
            style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final int min;
  final int max;
  final bool required;
  final String requiredMsg;

  const _EditField({
    required this.ctrl,
    required this.label,
    required this.min,
    required this.max,
    required this.requiredMsg,
    this.required = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: TextInputType.number,
      validator: (v) {
        if (!required && (v == null || v.isEmpty)) return null;
        if (required && (v == null || v.isEmpty)) return requiredMsg;
        final n = int.tryParse(v!);
        if (n == null || n < min || n > max) return '$min–$max';
        return null;
      },
    );
  }
}

class _LegalTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String body;
  const _LegalTile(
      {required this.icon, required this.title, required this.body});

  @override
  State<_LegalTile> createState() => _LegalTileState();
}

class _LegalTileState extends State<_LegalTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(widget.icon,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(widget.title,
                          style:
                              const TextStyle(fontWeight: FontWeight.w600))),
                  Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 8),
                Text(widget.body,
                    style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
