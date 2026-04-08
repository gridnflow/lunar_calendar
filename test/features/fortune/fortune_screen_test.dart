import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_calendar/core/models/user_profile.dart';
import 'package:lunar_calendar/core/providers/service_providers.dart';
import 'package:lunar_calendar/core/services/lunar_service.dart';
import 'package:lunar_calendar/features/fortune/presentation/fortune_screen.dart';

import '../../mocks/mock_services.dart';

void main() {
  late MockUserService mockUser;

  setUp(() {
    mockUser = MockUserService();
  });

  Widget buildSubject({UserProfile? profile}) {
    return ProviderScope(
      overrides: [
        userServiceProvider.overrideWithValue(mockUser),
        // Use real LunarService — no external deps
        lunarServiceProvider.overrideWithValue(LunarService()),
        userProfileProvider.overrideWith((ref) async => profile),
      ],
      child: const MaterialApp(home: FortuneScreen()),
    );
  }

  group('FortuneScreen', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text("Today's Fortune"), findsOneWidget);
    });

    testWidgets('shows Today card', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Today'), findsOneWidget);
    });

    testWidgets('shows lunar date string starting with 음력', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final lunarTexts = find.textContaining('음력');
      expect(lunarTexts, findsAtLeastNWidgets(1));
    });

    testWidgets('shows year/month/day pillar chips', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Pillars end with 년, 월, 일
      expect(find.textContaining('년'), findsAtLeastNWidgets(1));
      expect(find.textContaining('월'), findsAtLeastNWidgets(1));
      expect(find.textContaining('일'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows prompt to enter birth info when no profile', (tester) async {
      await tester.pumpWidget(buildSubject(profile: null));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Enter your birth info'),
        findsOneWidget,
      );
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

      // Saju column labels
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

    testWidgets('shows Your Saju card title', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Your Saju (四柱)'), findsOneWidget);
    });

    testWidgets('converts lunar birth date to solar for saju', (tester) async {
      const profile = UserProfile(
        uid: 'uid-3',
        email: 'c@d.com',
        displayName: 'Test',
        birthYear: 1990,
        birthMonth: 3,
        birthDay: 15,
        isLunarBirth: true,
      );

      await tester.pumpWidget(buildSubject(profile: profile));
      await tester.pumpAndSettle();

      // Should render without throwing
      expect(find.text('年'), findsOneWidget);
    });
  });
}
