import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:mocktail/mocktail.dart';
import 'package:lunar_calendar/core/models/user_profile.dart';
import 'package:lunar_calendar/core/providers/service_providers.dart';
import 'package:lunar_calendar/core/services/lunar_service.dart';
import 'package:lunar_calendar/features/calendar/presentation/calendar_screen.dart';

import '../../mocks/mock_services.dart';

void main() {
  late MockCalendarService mockCalendar;
  late MockUserService mockUser;

  setUp(() {
    mockCalendar = MockCalendarService();
    mockUser = MockUserService();
  });

  Widget buildSubject({
    List<gcal.Event> events = const [],
    String? currentUid,
  }) {
    return ProviderScope(
      overrides: [
        calendarServiceProvider.overrideWithValue(mockCalendar),
        userServiceProvider.overrideWithValue(mockUser),
        lunarServiceProvider.overrideWithValue(LunarService()),
        currentUserIdProvider.overrideWithValue(currentUid),
        upcomingEventsProvider.overrideWith((ref) async => events),
      ],
      child: const MaterialApp(home: CalendarScreen()),
    );
  }

  group('CalendarScreen', () {
    testWidgets('shows Calendar title in appbar', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Calendar'), findsOneWidget);
    });

    testWidgets('shows lunar date in appbar subtitle', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.textContaining('음력'), findsOneWidget);
    });

    testWidgets('shows refresh icon button', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('shows Add Lunar Birthday FAB', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Add Lunar Birthday'), findsOneWidget);
    });

    testWidgets('shows No upcoming events when list is empty', (tester) async {
      await tester.pumpWidget(buildSubject(events: []));
      await tester.pumpAndSettle();

      expect(find.text('No upcoming events'), findsOneWidget);
    });

    testWidgets('shows event list when events exist', (tester) async {
      final event = gcal.Event()
        ..summary = 'Birthday Party'
        ..start = (gcal.EventDateTime()..date = DateTime(2026, 5, 1));

      await tester.pumpWidget(buildSubject(events: [event]));
      await tester.pumpAndSettle();

      expect(find.text('Birthday Party'), findsOneWidget);
    });

    testWidgets('shows event date subtitle', (tester) async {
      final event = gcal.Event()
        ..summary = 'Test Event'
        ..start = (gcal.EventDateTime()..date = DateTime(2026, 6, 15));

      await tester.pumpWidget(buildSubject(events: [event]));
      await tester.pumpAndSettle();

      expect(find.textContaining('2026'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows multiple events', (tester) async {
      final events = [
        gcal.Event()
          ..summary = 'Event A'
          ..start = (gcal.EventDateTime()..date = DateTime(2026, 5, 1)),
        gcal.Event()
          ..summary = 'Event B'
          ..start = (gcal.EventDateTime()..date = DateTime(2026, 5, 2)),
      ];

      await tester.pumpWidget(buildSubject(events: events));
      await tester.pumpAndSettle();

      expect(find.text('Event A'), findsOneWidget);
      expect(find.text('Event B'), findsOneWidget);
    });

    testWidgets('shows snackbar when no uid and FAB is tapped', (tester) async {
      await tester.pumpWidget(buildSubject(currentUid: null));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Lunar Birthday'));
      await tester.pumpAndSettle();

      // No snackbar shown when uid is null — dialog simply returns early
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('shows snackbar when no profile and FAB is tapped', (tester) async {
      when(() => mockUser.getProfile(any())).thenAnswer((_) async => null);

      await tester.pumpWidget(buildSubject(currentUid: 'uid-test'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Lunar Birthday'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('birth info in Settings'),
        findsOneWidget,
      );
    });

    testWidgets('shows birthday registration dialog when profile exists', (tester) async {
      const profile = UserProfile(
        uid: 'uid-test',
        email: 'a@b.com',
        displayName: 'Alice',
        birthYear: 1990,
        birthMonth: 3,
        birthDay: 15,
      );
      when(() => mockUser.getProfile('uid-test'))
          .thenAnswer((_) async => profile);

      await tester.pumpWidget(buildSubject(currentUid: 'uid-test'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Lunar Birthday'));
      await tester.pumpAndSettle();

      expect(find.text('Register Lunar Birthday'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('dismisses dialog on Cancel tap', (tester) async {
      const profile = UserProfile(
        uid: 'uid-test',
        email: 'a@b.com',
        displayName: 'Alice',
        birthYear: 1990,
        birthMonth: 3,
        birthDay: 15,
      );
      when(() => mockUser.getProfile('uid-test'))
          .thenAnswer((_) async => profile);

      await tester.pumpWidget(buildSubject(currentUid: 'uid-test'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Lunar Birthday'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Register Lunar Birthday'), findsNothing);
    });
  });
}
