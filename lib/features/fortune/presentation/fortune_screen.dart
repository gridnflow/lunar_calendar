import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/providers/service_providers.dart';
import '../../../core/services/ad_service.dart';

class FortuneScreen extends ConsumerStatefulWidget {
  const FortuneScreen({super.key});

  @override
  ConsumerState<FortuneScreen> createState() => _FortuneScreenState();
}

class _FortuneScreenState extends ConsumerState<FortuneScreen> {
  BannerAd? _bannerAd;
  bool _bannerLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBanner();
    // 보상형 광고 미리 로드
    ref.read(adServiceProvider).loadRewarded();
  }

  void _loadBanner() {
    _bannerAd = BannerAd(
      adUnitId: AdIds.banner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _bannerLoaded = true),
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          _bannerAd = null;
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _refreshWithRewardedAd() {
    final adService = ref.read(adServiceProvider);
    adService.showRewarded(onRewarded: () {
      ref.invalidate(todayFortuneProvider);
      // 다음 광고 미리 로드
      adService.loadRewarded();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lunar = ref.read(lunarServiceProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final fortuneAsync = ref.watch(todayFortuneProvider);

    final todayLunar = lunar.todayLunarString();
    final dayPillar = lunar.todayDayPillar();
    final monthPillar = lunar.todayMonthPillar();
    final yearPillar = lunar.todayYearPillar();
    final solarTerm = lunar.todaySolarTerm();

    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 운세'),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            tooltip: '광고 보고 운세 다시 보기',
            onPressed: _refreshWithRewardedAd,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _InfoCard(
                  title: '오늘',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(todayLunar,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
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
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiaryContainer,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _InfoCard(
                  title: '운세',
                  child: fortuneAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Text('운세를 불러올 수 없습니다: $e',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error)),
                    data: (text) => _FortuneText(text: text),
                  ),
                ),
                const SizedBox(height: 16),
                profileAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => const SizedBox.shrink(),
                  data: (profile) {
                    if (profile == null || profile.birthYear == 0) {
                      return const _InfoCard(
                        title: '사주 (四柱)',
                        child: Text(
                            'Settings에서 생년월일을 입력하면 사주를 볼 수 있습니다.'),
                      );
                    }

                    final birthDate = profile.isLunarBirth
                        ? lunar.lunarToSolar(profile.birthYear,
                            profile.birthMonth, profile.birthDay)
                        : DateTime(profile.birthYear, profile.birthMonth,
                            profile.birthDay);

                    final saju = lunar.getSaju(
                      year: birthDate.year,
                      month: birthDate.month,
                      day: birthDate.day,
                      hour: profile.birthHour,
                    );

                    return _InfoCard(
                      title: '사주 (四柱)',
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
          ),
          if (_bannerLoaded && _bannerAd != null)
            SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }
}

class _FortuneText extends StatelessWidget {
  final String text;
  const _FortuneText({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sections = text.split('\n\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.map((section) {
        if (section.trim().isEmpty) return const SizedBox.shrink();
        if (section.startsWith('**')) {
          final end = section.indexOf('**', 2);
          if (end != -1) {
            final title = section.substring(2, end);
            final body = section.substring(end + 2).trim();
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: cs.onPrimaryContainer,
                            fontSize: 13)),
                  ),
                  const SizedBox(height: 6),
                  Text(body, style: const TextStyle(height: 1.6)),
                ],
              ),
            );
          }
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(section, style: const TextStyle(height: 1.6)),
        );
      }).toList(),
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
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer)),
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
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(value,
            style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
