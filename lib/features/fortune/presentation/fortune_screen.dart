import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/service_providers.dart';

class FortuneScreen extends ConsumerWidget {
  const FortuneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lunar = ref.read(lunarServiceProvider);
    final profileAsync = ref.watch(userProfileProvider);

    final todayLunar = lunar.todayLunarString();
    final dayPillar = lunar.todayDayPillar();
    final monthPillar = lunar.todayMonthPillar();
    final yearPillar = lunar.todayYearPillar();
    final solarTerm = lunar.todaySolarTerm();

    return Scaffold(
      appBar: AppBar(title: const Text('Today\'s Fortune')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _InfoCard(
            title: 'Today',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(todayLunar,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(children: [
                  _PillarChip(label: yearPillar),
                  const SizedBox(width: 8),
                  _PillarChip(label: monthPillar),
                  const SizedBox(width: 8),
                  _PillarChip(label: dayPillar),
                ]),
                if (solarTerm != null) ...[
                  const SizedBox(height: 8),
                  Chip(
                    label: Text('절기: $solarTerm'),
                    backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          profileAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => const SizedBox.shrink(),
            data: (profile) {
              if (profile == null || profile.birthYear == 0) {
                return const _InfoCard(
                  title: 'Your Saju (四柱)',
                  child: Text('Enter your birth info in Settings to see your four pillars.'),
                );
              }

              final birthDate = profile.isLunarBirth
                  ? lunar.lunarToSolar(
                      profile.birthYear, profile.birthMonth, profile.birthDay)
                  : DateTime(profile.birthYear, profile.birthMonth, profile.birthDay);

              final saju = lunar.getSaju(
                year: birthDate.year,
                month: birthDate.month,
                day: birthDate.day,
                hour: profile.birthHour,
              );

              return _InfoCard(
                title: 'Your Saju (四柱)',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SajuColumn(label: '年', value: saju['year'] ?? ''),
                    _SajuColumn(label: '月', value: saju['month'] ?? ''),
                    _SajuColumn(label: '日', value: saju['day'] ?? ''),
                    if ((saju['hour'] ?? '').isNotEmpty)
                      _SajuColumn(label: '時', value: saju['hour']!),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _InfoCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _PillarChip extends StatelessWidget {
  final String label;
  const _PillarChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)),
    );
  }
}

class _SajuColumn extends StatelessWidget {
  final String label;
  final String value;
  const _SajuColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
