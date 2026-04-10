import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/service_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {

  Future<void> _registerBirthday(BuildContext context) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final profile = await ref.read(userServiceProvider).getProfile(user.uid);
    if (profile == null || profile.birthYear == 0) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('생일 정보가 없습니다. 온보딩에서 입력해주세요.')),
        );
      }
      return;
    }

    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('내 생일 등록'),
        content: Text(
          '음력 생일 (${profile.birthMonth}월 ${profile.birthDay}일)을\n'
          'Google Calendar에 20년치 등록할까요?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('등록'),
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
        SnackBar(content: Text('${dates.length}개 생일 일정이 등록됐습니다!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final user = ref.read(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
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
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.displayName ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
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

          // 생년월일 정보 (읽기 전용)
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
                      Text('생년월일',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        '${profile.birthYear}년 ${profile.birthMonth}월 ${profile.birthDay}일'
                        '${profile.birthHour != null ? '  ${profile.birthHour}시' : ''}'
                        '  (${profile.isLunarBirth ? '음력' : '양력'})',
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
            onPressed: () => _registerBirthday(context),
            icon: const Icon(Icons.cake),
            label: const Text('내 생일 Google Calendar에 등록'),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48)),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.push('/language'),
            icon: const Icon(Icons.language),
            label: const Text('Language / 언어 설정'),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48)),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => ref.read(authServiceProvider).signOut(),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48)),
            child: const Text('Sign Out'),
          ),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 8),

          // 데이터 보호 & 법적 고지
          Text('정보 및 법적 고지',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _LegalTile(
            icon: Icons.shield_outlined,
            title: '개인정보 처리방침',
            body: '본 앱은 Google 로그인을 통해 이름, 이메일 주소를 수집하며, '
                '사용자가 입력한 생년월일을 Firestore에 저장합니다. '
                '수집된 정보는 오늘의 운세 및 사주 계산에만 활용되며, '
                '제3자에게 제공되지 않습니다.',
          ),
          _LegalTile(
            icon: Icons.calendar_today_outlined,
            title: 'Google Calendar 권한',
            body: '캘린더 연동 기능 사용 시 Google Calendar 읽기/쓰기 권한을 요청합니다. '
                '해당 권한은 일정 조회 및 음력 생일 등록에만 사용됩니다.',
          ),
          _LegalTile(
            icon: Icons.notifications_outlined,
            title: '알림 권한',
            body: '기념일 사전 알림(7일 전, 3일 전, 당일)을 위해 로컬 알림 권한을 사용합니다. '
                '알림은 기기 내에서만 처리되며 외부 서버로 전송되지 않습니다.',
          ),
          _LegalTile(
            icon: Icons.auto_awesome_outlined,
            title: 'AI 운세 (Gemini)',
            body: '오늘의 운세는 Google Gemini API를 통해 생성됩니다. '
                '운세 생성 시 일주·월주·년주 및 사주 정보가 전송될 수 있습니다. '
                '하루 1,200회 초과 시 로컬 운세로 대체됩니다.',
          ),
          _LegalTile(
            icon: Icons.ad_units_outlined,
            title: '광고 (AdMob)',
            body: '본 앱은 Google AdMob을 통해 광고를 표시합니다. '
                'AdMob은 광고 최적화를 위해 기기 식별자 등의 정보를 수집할 수 있습니다. '
                '자세한 내용은 Google 개인정보처리방침을 참조하세요.',
          ),
          const SizedBox(height: 8),
          Text(
            'Version 1.0.0  ·  © 2026 Gridnflow',
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
                          style: const TextStyle(fontWeight: FontWeight.w600))),
                  Icon(
                      _expanded
                          ? Icons.expand_less
                          : Icons.expand_more,
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
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
