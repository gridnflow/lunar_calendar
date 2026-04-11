import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/service_providers.dart';
import '../../../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Future<void> _registerBirthday(BuildContext context, AppLocalizations l) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final profile = await ref.read(userServiceProvider).getProfile(user.uid);
    if (profile == null || profile.birthYear == 0) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.settingsBirthdayNone)),
        );
      }
      return;
    }

    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.settingsBirthdayDialogTitle),
        content: Text(l.settingsBirthdayDialogBody(
            profile.birthMonth, profile.birthDay)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.anniversaryCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.anniversarySave),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final dates = ref.read(lunarServiceProvider).getLunarBirthdayDates(
          birthMonth: profile.birthMonth,
          birthDay: profile.birthDay,
        );

    await ref.read(calendarServiceProvider).registerLunarBirthdays(
          name: profile.displayName,
          dates: dates,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.settingsBirthdayRegistered(dates.length))),
      );
    }
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
                return const SizedBox.shrink();
              }
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
              );
            },
          ),
          const SizedBox(height: 16),

          OutlinedButton.icon(
            onPressed: () => _registerBirthday(context, l),
            icon: const Icon(Icons.cake),
            label: Text(l.settingsRegisterBirthday),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48)),
          ),
          const SizedBox(height: 12),
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
