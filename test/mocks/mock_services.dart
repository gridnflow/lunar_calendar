import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lunar_calendar/core/services/auth_service.dart';
import 'package:lunar_calendar/core/services/calendar_service.dart';
import 'package:lunar_calendar/core/services/notification_service.dart';
import 'package:lunar_calendar/core/services/user_service.dart';

class MockAuthService extends Mock implements AuthService {}
class MockUserService extends Mock implements UserService {}
class MockCalendarService extends Mock implements CalendarService {}
class MockNotificationService extends Mock implements NotificationService {}
class MockFirebaseUser extends Mock implements User {}
