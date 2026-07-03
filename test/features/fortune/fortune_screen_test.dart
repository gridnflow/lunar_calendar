import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_calendar/core/models/user_profile.dart';
import 'package:lunar_calendar/core/providers/fortune_unlock_provider.dart';
import 'package:lunar_calendar/core/providers/service_providers.dart';
import 'package:lunar_calendar/core/services/lunar_service.dart';
import 'package:lunar_calendar/features/fortune/presentation/fortune_screen.dart';
import 'package:lunar_calendar/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 항상 잠금 해제된 상태의 노티파이어 (상세운세 표시 테스트용).
class _UnlockedNotifier extends FortuneUnlockNotifier {
  @override
  bool build() => true;
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildSubject({
    UserProfile? profile,
    String basicFortune = '오늘의 기본 운세입니다.',
    String detailedFortune = 'AI 상세운세입니다.',
    bool unlocked = false,
  }) {
    return ProviderScope(
      overrides: [
        lunarServiceProvider.overrideWithValue(LunarService()),
        userProfileProvider.overrideWith((ref) async => profile),
        basicFortuneProvider.overrideWith((ref) async => basicFortune),
        todayFortuneProvider.overrideWith((ref) async => detailedFortune),
        if (unlocked)
          fortuneUnlockedProvider.overrideWith(_UnlockedNotifier.new),
      ],
      child: const MaterialApp(
        locale: Locale('ko'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: FortuneScreen(),
      ),
    );
  }

  group('FortuneScreen', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      expect(find.text('오늘의 운세'), findsWidgets);
    });

    testWidgets('shows basic fortune text when loaded', (tester) async {
      await tester.pumpWidget(buildSubject(basicFortune: '좋은 하루입니다.'));
      await tester.pumpAndSettle();
      expect(find.textContaining('좋은 하루입니다'), findsOneWidget);
    });

    testWidgets('shows unlock card when detailed fortune is locked',
        (tester) async {
      await tester.pumpWidget(buildSubject(detailedFortune: '상세운세 내용'));
      await tester.pumpAndSettle();
      expect(find.text('광고 보고 상세운세 보기'), findsOneWidget);
      expect(find.textContaining('상세운세 내용'), findsNothing);
    });

    testWidgets('shows detailed fortune when unlocked', (tester) async {
      await tester.pumpWidget(
          buildSubject(detailedFortune: '상세운세 내용', unlocked: true));
      await tester.pumpAndSettle();
      expect(find.textContaining('상세운세 내용'), findsOneWidget);
      expect(find.text('광고 보고 상세운세 보기'), findsNothing);
    });

    testWidgets('shows prompt when no profile', (tester) async {
      await tester.pumpWidget(buildSubject(profile: null));
      await tester.pumpAndSettle();
      expect(find.textContaining('Settings'), findsOneWidget);
    });

    testWidgets('shows saju columns when profile has birth info',
        (tester) async {
      const profile = UserProfile(
        uid: 'uid-1',
        email: 'a@b.com',
        displayName: 'Test',
        birthYear: 1990,
        birthMonth: 5,
        birthDay: 10,
      );
      await tester.pumpWidget(buildSubject(profile: profile));
      await tester.pumpAndSettle();
      expect(find.text('年'), findsOneWidget);
      expect(find.text('月'), findsOneWidget);
      expect(find.text('日'), findsOneWidget);
    });

    testWidgets('shows 時 column when birthHour is provided', (tester) async {
      const profile = UserProfile(
        uid: 'uid-2',
        email: 'b@c.com',
        displayName: 'Test',
        birthYear: 1990,
        birthMonth: 5,
        birthDay: 10,
        birthHour: 14,
      );
      await tester.pumpWidget(buildSubject(profile: profile));
      await tester.pumpAndSettle();
      expect(find.text('時'), findsOneWidget);
    });
  });
}
