import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/providers/fortune_unlock_provider.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/night_sky.dart';
import '../../../l10n/app_localizations.dart';

class FortuneScreen extends ConsumerStatefulWidget {
  const FortuneScreen({super.key});

  @override
  ConsumerState<FortuneScreen> createState() => _FortuneScreenState();
}

class _FortuneScreenState extends ConsumerState<FortuneScreen> {
  bool _adLoading = false;

  @override
  void initState() {
    super.initState();
    ref.read(analyticsServiceProvider).logFortuneViewed();
  }

  /// 보상형 광고를 로드·표시하고, 시청 완료 시 오늘의 상세운세 잠금 해제.
  Future<void> _unlockWithAd() async {
    setState(() => _adLoading = true);
    final adService = ref.read(adServiceProvider);
    await adService.loadRewarded();
    if (!mounted) return;
    setState(() => _adLoading = false);
    adService.showRewarded(
      onRewarded: () {
        ref.read(analyticsServiceProvider).logDetailedFortuneUnlocked();
        ref.read(fortuneUnlockedProvider.notifier).unlock();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final lunar = ref.read(lunarServiceProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final basicFortuneAsync = ref.watch(basicFortuneProvider);
    // 프리미엄 사용자는 광고 없이 항상 상세운세 이용 가능
    final isUnlocked =
        ref.watch(isPremiumProvider) || ref.watch(fortuneUnlockedProvider);

    final todayLunar = l.fortuneLunarDate(lunar.todayLunarMonth(), lunar.todayLunarDay());
    final dayPillar = '${lunar.todayDayGanZhi()}${l.fortuneDaySuffix}';
    final monthPillar = '${lunar.todayMonthGanZhi()}${l.fortuneMonthSuffix}';
    final yearPillar = '${lunar.todayYearGanZhi()}${l.fortuneYearSuffix}';
    final solarTerm = lunar.todaySolarTerm();

    return Scaffold(
      appBar: AppBar(
        title: Text(l.fortuneTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // ── 날짜/절기 헤더 카드 (나이트스카이 그라디언트) ──
          _LunarInfoCard(
            todayLunar: todayLunar,
            yearPillar: yearPillar,
            monthPillar: monthPillar,
            dayPillar: dayPillar,
            solarTerm: solarTerm != null ? l.fortuneSolarTerm(solarTerm) : null,
          ),
          const SizedBox(height: 16),

          // ── 오늘의 운세 (무료 기본) ──
          _SectionCard(
            title: l.fortuneTitle,
            icon: Icons.today_outlined,
            child: basicFortuneAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text(
                l.fortuneError(e.toString()),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              data: (text) {
                ref.read(reviewServiceProvider).recordFortuneViewAndMaybeReview();
                return _FortuneText(text: text);
              },
            ),
          ),
          const SizedBox(height: 16),

          // ── AI 상세운세 (보상형 광고로 잠금 해제) ──
          if (isUnlocked)
            _SectionCard(
              title: l.fortuneDetailedTitle,
              icon: Icons.auto_awesome,
              child: ref.watch(todayFortuneProvider).when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Text(
                      l.fortuneError(e.toString()),
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    data: (text) => _FortuneText(text: text),
                  ),
            )
          else
            _UnlockCard(
              title: l.fortuneDetailedTitle,
              description: l.fortuneUnlockDesc,
              buttonLabel: _adLoading ? l.fortuneUnlocking : l.fortuneUnlockButton,
              loading: _adLoading,
              onPressed: _adLoading ? null : _unlockWithAd,
            ),
          const SizedBox(height: 16),

          // ── 사주 ──
          profileAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => const SizedBox.shrink(),
            data: (profile) {
              if (profile == null || profile.birthYear == 0) {
                return _SectionCard(
                  title: l.fortuneSaju,
                  icon: Icons.person_outline,
                  child: Text(l.fortuneSajuPrompt,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant)),
                );
              }

              final birthDate = profile.isLunarBirth
                  ? lunar.lunarToSolar(profile.birthYear, profile.birthMonth, profile.birthDay)
                  : DateTime(profile.birthYear, profile.birthMonth, profile.birthDay);

              final saju = lunar.getSaju(
                year: birthDate.year,
                month: birthDate.month,
                day: birthDate.day,
                hour: profile.birthHour,
              );

              return _SectionCard(
                title: l.fortuneSaju,
                icon: Icons.person_outline,
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

// ────────────────────────────────────────────────
// 나이트스카이 그라디언트 헤더 카드
// ────────────────────────────────────────────────
class _LunarInfoCard extends StatelessWidget {
  final String todayLunar;
  final String yearPillar;
  final String monthPillar;
  final String dayPillar;
  final String? solarTerm;

  const _LunarInfoCard({
    required this.todayLunar,
    required this.yearPillar,
    required this.monthPillar,
    required this.dayPillar,
    this.solarTerm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B1233).withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: NightSky(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                todayLunar,
                style: GoogleFonts.notoSansKr(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _GoldChip(label: yearPillar),
                  const SizedBox(width: 8),
                  _GoldChip(label: monthPillar),
                  const SizedBox(width: 8),
                  _GoldChip(label: dayPillar),
                ],
              ),
              if (solarTerm != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppTheme.moonGold.withValues(alpha: 0.45)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.eco_outlined,
                          size: 13, color: AppTheme.moonGold),
                      const SizedBox(width: 4),
                      Text(solarTerm!,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.9))),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GoldChip extends StatelessWidget {
  final String label;
  const _GoldChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        gradient: AppTheme.goldAccentGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────
// 일반 섹션 카드
// ────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _SectionCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: cs.primary),
                ),
                const SizedBox(width: 10),
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            Divider(color: cs.outlineVariant.withValues(alpha: 0.3)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────
// 운세 텍스트
// ────────────────────────────────────────────────
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
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: cs.onPrimaryContainer,
                            fontSize: 13)),
                  ),
                  const SizedBox(height: 8),
                  Text(body,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(height: 1.7)),
                ],
              ),
            );
          }
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Text(section,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(height: 1.7)),
        );
      }).toList(),
    );
  }
}

// ────────────────────────────────────────────────
// AI 상세운세 잠금 해제 카드
// ────────────────────────────────────────────────
class _UnlockCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonLabel;
  final bool loading;
  final VoidCallback? onPressed;

  const _UnlockCard({
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.auto_awesome, size: 16, color: cs.primary),
                ),
                const SizedBox(width: 10),
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(description,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant, height: 1.5)),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onPressed,
                icon: loading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_circle_outline, size: 20),
                label: Text(buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────
// 사주 컬럼
// ────────────────────────────────────────────────
class _SajuColumn extends StatelessWidget {
  final String label;
  final String value;
  const _SajuColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: cs.onSurfaceVariant)),
        const SizedBox(height: 6),
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: cs.onPrimaryContainer)),
        ),
      ],
    );
  }
}
