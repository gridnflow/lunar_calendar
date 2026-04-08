import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_calendar/core/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    group('toFirestore', () {
      test('serializes all required fields', () {
        const profile = UserProfile(
          uid: 'uid-1',
          email: 'test@example.com',
          displayName: 'Test User',
          birthYear: 1990,
          birthMonth: 5,
          birthDay: 20,
        );

        final map = profile.toFirestore();

        expect(map['uid'], 'uid-1');
        expect(map['email'], 'test@example.com');
        expect(map['displayName'], 'Test User');
        expect(map['birthYear'], 1990);
        expect(map['birthMonth'], 5);
        expect(map['birthDay'], 20);
        expect(map['birthHour'], isNull);
        expect(map['isLunarBirth'], false);
      });

      test('serializes optional birthHour when provided', () {
        const profile = UserProfile(
          uid: 'uid-2',
          email: 'a@b.com',
          displayName: 'User',
          birthYear: 1985,
          birthMonth: 3,
          birthDay: 15,
          birthHour: 14,
        );

        final map = profile.toFirestore();
        expect(map['birthHour'], 14);
      });

      test('serializes isLunarBirth true', () {
        const profile = UserProfile(
          uid: 'uid-3',
          email: 'a@b.com',
          displayName: 'User',
          birthYear: 1992,
          birthMonth: 7,
          birthDay: 7,
          isLunarBirth: true,
        );

        final map = profile.toFirestore();
        expect(map['isLunarBirth'], true);
      });
    });

    group('fromFirestore', () {
      test('deserializes all fields correctly', () {
        final data = {
          'uid': 'uid-10',
          'email': 'hello@test.com',
          'displayName': 'Hello User',
          'birthYear': 2000,
          'birthMonth': 12,
          'birthDay': 31,
          'birthHour': 23,
          'isLunarBirth': true,
        };

        final profile = UserProfile.fromFirestore(data);

        expect(profile.uid, 'uid-10');
        expect(profile.email, 'hello@test.com');
        expect(profile.displayName, 'Hello User');
        expect(profile.birthYear, 2000);
        expect(profile.birthMonth, 12);
        expect(profile.birthDay, 31);
        expect(profile.birthHour, 23);
        expect(profile.isLunarBirth, true);
      });

      test('defaults isLunarBirth to false when absent', () {
        final data = {
          'uid': 'uid-20',
          'email': 'x@x.com',
          'displayName': 'X',
          'birthYear': 1995,
          'birthMonth': 1,
          'birthDay': 1,
          'birthHour': null,
        };

        final profile = UserProfile.fromFirestore(data);
        expect(profile.isLunarBirth, false);
        expect(profile.birthHour, isNull);
      });

      test('birthHour is null when absent in data', () {
        final data = {
          'uid': 'uid-30',
          'email': 'y@y.com',
          'displayName': 'Y',
          'birthYear': 1988,
          'birthMonth': 6,
          'birthDay': 15,
        };

        final profile = UserProfile.fromFirestore(data);
        expect(profile.birthHour, isNull);
      });
    });

    group('round-trip', () {
      test('toFirestore -> fromFirestore preserves all values', () {
        const original = UserProfile(
          uid: 'rt-uid',
          email: 'roundtrip@test.com',
          displayName: 'Round Trip',
          birthYear: 1978,
          birthMonth: 11,
          birthDay: 22,
          birthHour: 9,
          isLunarBirth: true,
        );

        final restored = UserProfile.fromFirestore(original.toFirestore());

        expect(restored.uid, original.uid);
        expect(restored.email, original.email);
        expect(restored.displayName, original.displayName);
        expect(restored.birthYear, original.birthYear);
        expect(restored.birthMonth, original.birthMonth);
        expect(restored.birthDay, original.birthDay);
        expect(restored.birthHour, original.birthHour);
        expect(restored.isLunarBirth, original.isLunarBirth);
      });
    });
  });
}
