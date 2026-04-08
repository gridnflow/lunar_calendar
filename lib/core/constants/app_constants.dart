class AppConstants {
  static const String appName = 'Lunar Calendar';

  // Google Calendar API scopes
  static const List<String> googleScopes = [
    'https://www.googleapis.com/auth/calendar',
    'email',
    'profile',
  ];

  // Cloud Functions region
  static const String functionsRegion = 'asia-northeast3';

  // Fortune push notification time (hour in local time)
  static const int fortuneNotificationHour = 6;
}
