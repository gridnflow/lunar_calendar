import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;

import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/calendar_service.dart';
import '../services/lunar_service.dart';
import '../services/notification_service.dart';
import '../services/user_service.dart';

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
