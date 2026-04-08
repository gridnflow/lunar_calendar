import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_calendar/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('appName is correct', () {
      expect(AppConstants.appName, 'Lunar Calendar');
    });

    test('googleScopes contains calendar scope', () {
      expect(
        AppConstants.googleScopes,
        contains('https://www.googleapis.com/auth/calendar'),
      );
    });

    test('googleScopes contains email and profile', () {
      expect(AppConstants.googleScopes, contains('email'));
      expect(AppConstants.googleScopes, contains('profile'));
    });

    test('googleScopes has exactly 3 entries', () {
      expect(AppConstants.googleScopes.length, 3);
    });

    test('functionsRegion is set', () {
      expect(AppConstants.functionsRegion, isNotEmpty);
    });

    test('fortuneNotificationHour is 6', () {
      expect(AppConstants.fortuneNotificationHour, 6);
    });
  });
}
