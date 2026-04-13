import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;

import '../models/family_anniversary.dart';
import '../models/user_profile.dart';
import '../services/anniversary_service.dart';
import '../services/auth_service.dart';
import '../services/calendar_service.dart';
import '../services/fortune_service.dart';
import '../services/lunar_service.dart';
import '../services/ad_service.dart';
import '../services/notification_service.dart';
import '../services/user_service.dart';
import '../services/widget_service.dart';
import 'locale_provider.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final userServiceProvider = Provider<UserService>((ref) => UserService());

final lunarServiceProvider = Provider<LunarService>((ref) => LunarService());

final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());

final calendarServiceProvider = Provider<CalendarService>(
  (ref) => CalendarService(ref.read(authServiceProvider)),
);

/// The current Firebase user (null if signed out). Override in tests.
final currentUserProvider = Provider<User?>((ref) {
  return FirebaseAuth.instance.currentUser;
});

/// Convenience provider for just the uid.
final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(currentUserProvider)?.uid;
});

/// The current user's Firestore profile.
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return null;
  return ref.read(userServiceProvider).getProfile(uid);
});

/// Upcoming Google Calendar events.
final upcomingEventsProvider = FutureProvider<List<gcal.Event>>((ref) {
  return ref.read(calendarServiceProvider).getUpcomingEvents();
});

final anniversaryServiceProvider =
    Provider<AnniversaryService>((ref) => AnniversaryService());

/// Stream of the current user's family anniversaries.
final anniversariesProvider = StreamProvider<List<FamilyAnniversary>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return const Stream.empty();
  return ref.read(anniversaryServiceProvider).watchAnniversaries(uid);
});

final fortuneServiceProvider = Provider<FortuneService>((ref) {
  final apiKey = dotenv.maybeGet('GEMINI_API_KEY') ?? '';
  return FortuneService(apiKey: apiKey);
});

/// 기념일 변경 시 알림 자동 재스케줄링 (App 위젯에서 watch)
final anniversaryNotificationSchedulerProvider = Provider<void>((ref) {
  final anniversariesAsync = ref.watch(anniversariesProvider);
  final lunar = ref.read(lunarServiceProvider);
  final notifications = ref.read(notificationServiceProvider);

  anniversariesAsync.whenData((anniversaries) {
    notifications.scheduleAnniversaryNotifications(anniversaries, lunar);
  });
});

final widgetServiceProvider =
    Provider<WidgetService>((ref) => WidgetService());

final adServiceProvider =
    Provider<AdService>((ref) => AdService());

/// Today's fortune text (cached per session).
final todayFortuneProvider = FutureProvider<String>((ref) async {
  final lunar = ref.read(lunarServiceProvider);
  final profile = await ref.watch(userProfileProvider.future);
  final fortune = ref.read(fortuneServiceProvider);
  final locale = ref.watch(localeProvider);
  final langCode = locale.countryCode != null
      ? '${locale.languageCode}_${locale.countryCode}'
      : locale.languageCode;

  Map<String, String>? saju;
  if (profile != null && profile.birthYear != 0) {
    final birthDate = profile.isLunarBirth
        ? lunar.lunarToSolar(profile.birthYear, profile.birthMonth, profile.birthDay)
        : DateTime(profile.birthYear, profile.birthMonth, profile.birthDay);
    saju = lunar.getSaju(
      year: birthDate.year,
      month: birthDate.month,
      day: birthDate.day,
      hour: profile.birthHour,
    );
  }

  final text = await fortune.getTodayFortune(
    yearPillar: lunar.todayYearPillar(),
    monthPillar: lunar.todayMonthPillar(),
    dayPillar: lunar.todayDayPillar(),
    lunarDate: lunar.todayLunarString(),
    sajuYear: saju?['year'],
    sajuMonth: saju?['month'],
    sajuDay: saju?['day'],
    sajuHour: saju?['hour'],
    languageCode: langCode,
  );

  // 위젯 데이터 갱신 (fire-and-forget)
  ref.read(widgetServiceProvider).updateWidgets(
        lunar: lunar,
        profile: profile,
        fortuneText: text,
      );

  return text;
});
