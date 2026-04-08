import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_calendar/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('appName is correct', () {
      expect(AppConstants.appName, 'Lunar Calendar');
    });

    test('calendarScope is Google Calendar API scope', () {
      expect(
        AppConstants.calendarScope,
        'https://www.googleapis.com/auth/calendar',
      );
    });

    test('functionsRegion is set', () {
      expect(AppConstants.functionsRegion, isNotEmpty);
    });

    test('fortuneNotificationHour is 6', () {
      expect(AppConstants.fortuneNotificationHour, 6);
    });
  });
}
