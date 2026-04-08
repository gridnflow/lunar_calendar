class AppConstants {
  static const String appName = 'Lunar Calendar';

  // Google Calendar API scope (requested lazily after sign-in)
  static const String calendarScope =
      'https://www.googleapis.com/auth/calendar';

  // Cloud Functions region
  static const String functionsRegion = 'asia-northeast3';

  // Fortune push notification time (hour in local time)
  static const int fortuneNotificationHour = 6;
}
