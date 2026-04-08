import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lunar_calendar/core/services/notification_service.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockNotificationSettings extends Mock implements NotificationSettings {}

void main() {
  late MockFirebaseMessaging mockFcm;
  late NotificationService service;

  setUp(() {
    mockFcm = MockFirebaseMessaging();
    service = NotificationService(fcm: mockFcm);
  });

  group('NotificationService', () {
    group('getToken', () {
      test('returns token from FirebaseMessaging', () async {
        when(() => mockFcm.getToken()).thenAnswer((_) async => 'fcm-token-123');

        final token = await service.getToken();
        expect(token, 'fcm-token-123');
      });

      test('returns null when FCM returns null', () async {
        when(() => mockFcm.getToken()).thenAnswer((_) async => null);

        final token = await service.getToken();
        expect(token, isNull);
      });
    });

    group('subscribeToTopic', () {
      test('calls FCM subscribeToTopic with correct topic', () async {
        when(() => mockFcm.subscribeToTopic(any()))
            .thenAnswer((_) async {});

        await service.subscribeToTopic('daily_fortune');

        verify(() => mockFcm.subscribeToTopic('daily_fortune')).called(1);
      });
    });

    group('unsubscribeFromTopic', () {
      test('calls FCM unsubscribeFromTopic with correct topic', () async {
        when(() => mockFcm.unsubscribeFromTopic(any()))
            .thenAnswer((_) async {});

        await service.unsubscribeFromTopic('daily_fortune');

        verify(() => mockFcm.unsubscribeFromTopic('daily_fortune')).called(1);
      });
    });
  });
}
