import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_calendar/core/models/user_profile.dart';
import 'package:lunar_calendar/core/providers/service_providers.dart';
import 'package:lunar_calendar/core/services/lunar_service.dart';
import 'package:lunar_calendar/features/fortune/presentation/fortune_screen.dart';

void main() {
  Widget buildSubject({UserProfile? profile, String fortune = '오늘의 운세입니다.'}) {
    return ProviderScope(
      overrides: [
        lunarServiceProvider.overrideWithValue(LunarService()),
        userProfileProvider.overrideWith((ref) async => profile),
        todayFortuneProvider.overrideWith((ref) async => fortune),
      ],
      child: const MaterialApp(home: FortuneScreen()),
    );
  }

  group('FortuneScreen', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      expect(find.text('오늘의 운세'), findsOneWidget);
    });

    testWidgets('shows today lunar card', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      expect(find.text('오늘'), findsOneWidget);
    });

    testWidgets('shows fortune card', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.text('운세'), findsOneWidget);
    });

    testWidgets('shows fortune text when loaded', (tester) async {
      await tester.pumpWidget(buildSubject(fortune: '좋은 하루입니다.'));
      await tester.pumpAndSettle();
      expect(find.textContaining('좋은 하루입니다'), findsOneWidget);
    });

    testWidgets('shows prompt when no profile', (tester) async {
      await tester.pumpWidget(buildSubject(profile: null));
      await tester.pumpAndSettle();
      expect(find.textContaining('Settings'), findsOneWidget);
    });

    testWidgets('shows saju columns when profile has birth info', (tester) async {
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
