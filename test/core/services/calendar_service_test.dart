import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:mocktail/mocktail.dart';
import 'package:lunar_calendar/core/services/calendar_service.dart';

import '../../mocks/mock_services.dart';

class MockCalendarApi extends Mock implements gcal.CalendarApi {}

class MockEventsResource extends Mock implements gcal.EventsResource {}

void main() {
  setUpAll(() {
    registerFallbackValue(gcal.Event());
    registerFallbackValue(gcal.Events());
  });

  late MockAuthService mockAuth;
  late MockCalendarApi mockApi;
  late MockEventsResource mockEvents;
  late CalendarService service;

  setUp(() {
    mockAuth = MockAuthService();
    mockApi = MockCalendarApi();
    mockEvents = MockEventsResource();
    when(() => mockApi.events).thenReturn(mockEvents);

    service = CalendarService(
      mockAuth,
      apiFactory: (_) => mockApi,
    );
  });

  group('CalendarService', () {
    group('getUpcomingEvents', () {
      test('returns empty list when token is null', () async {
        when(() => mockAuth.getGoogleAccessToken()).thenAnswer((_) async => null);
        // Service without factory so it hits the null-token path
        final noTokenService = CalendarService(mockAuth);

        final result = await noTokenService.getUpcomingEvents();
        expect(result, isEmpty);
      });

      test('returns events list from API', () async {
        when(() => mockAuth.getGoogleAccessToken())
            .thenAnswer((_) async => 'token');

        final event1 = gcal.Event()..summary = 'Test Event';
        final eventList = gcal.Events()..items = [event1];

        when(() => mockEvents.list(
              any(),
              timeMin: any(named: 'timeMin'),
              maxResults: any(named: 'maxResults'),
              singleEvents: any(named: 'singleEvents'),
              orderBy: any(named: 'orderBy'),
            )).thenAnswer((_) async => eventList);

        final result = await service.getUpcomingEvents();
        expect(result.length, 1);
        expect(result.first.summary, 'Test Event');
      });

      test('returns empty list when API items is null', () async {
        when(() => mockAuth.getGoogleAccessToken())
            .thenAnswer((_) async => 'token');

        final eventList = gcal.Events()..items = null;
        when(() => mockEvents.list(
              any(),
              timeMin: any(named: 'timeMin'),
              maxResults: any(named: 'maxResults'),
              singleEvents: any(named: 'singleEvents'),
              orderBy: any(named: 'orderBy'),
            )).thenAnswer((_) async => eventList);

        final result = await service.getUpcomingEvents();
        expect(result, isEmpty);
      });
    });

    group('insertEvent', () {
      test('does nothing when token is null', () async {
        when(() => mockAuth.getGoogleAccessToken()).thenAnswer((_) async => null);
        final noTokenService = CalendarService(mockAuth);

        await noTokenService.insertEvent(title: 'Test', date: DateTime(2026, 5, 1));
        verifyNever(() => mockEvents.insert(any(), any()));
      });

      test('inserts event with correct summary', () async {
        when(() => mockAuth.getGoogleAccessToken())
            .thenAnswer((_) async => 'token');
        when(() => mockEvents.insert(any(), any()))
            .thenAnswer((_) async => gcal.Event());

        await service.insertEvent(title: 'Birthday', date: DateTime(2026, 6, 1));

        final captured =
            verify(() => mockEvents.insert(captureAny(), any())).captured;
        final insertedEvent = captured.first as gcal.Event;
        expect(insertedEvent.summary, 'Birthday');
      });

      test('sets all-day event dates correctly', () async {
        when(() => mockAuth.getGoogleAccessToken())
            .thenAnswer((_) async => 'token');
        when(() => mockEvents.insert(any(), any()))
            .thenAnswer((_) async => gcal.Event());

        await service.insertEvent(title: 'Test', date: DateTime(2026, 3, 15));

        final captured =
            verify(() => mockEvents.insert(captureAny(), any())).captured;
        final event = captured.first as gcal.Event;
        expect(event.start?.date, DateTime.utc(2026, 3, 15));
        expect(event.end?.date, DateTime.utc(2026, 3, 16));
      });
    });

    group('registerLunarBirthdays', () {
      test('inserts one event per date', () async {
        when(() => mockAuth.getGoogleAccessToken())
            .thenAnswer((_) async => 'token');
        when(() => mockEvents.insert(any(), any()))
            .thenAnswer((_) async => gcal.Event());

        final dates = [
          DateTime(2026, 4, 10),
          DateTime(2027, 3, 30),
          DateTime(2028, 4, 18),
        ];

        await service.registerLunarBirthdays(name: 'Alice', dates: dates);
        verify(() => mockEvents.insert(any(), any())).called(3);
      });

      test('does nothing for empty dates list', () async {
        when(() => mockAuth.getGoogleAccessToken())
            .thenAnswer((_) async => 'token');

        await service.registerLunarBirthdays(name: 'Alice', dates: []);
        verifyNever(() => mockEvents.insert(any(), any()));
      });

      test('title includes name and 음력생일', () async {
        when(() => mockAuth.getGoogleAccessToken())
            .thenAnswer((_) async => 'token');
        when(() => mockEvents.insert(any(), any()))
            .thenAnswer((_) async => gcal.Event());

        await service.registerLunarBirthdays(
          name: 'Bob',
          dates: [DateTime(2026, 5, 1)],
        );

        final captured =
            verify(() => mockEvents.insert(captureAny(), any())).captured;
        final event = captured.first as gcal.Event;
        expect(event.summary, contains('Bob'));
        expect(event.summary, contains('음력생일'));
      });
    });
  });
}
