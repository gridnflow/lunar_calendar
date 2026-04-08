import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lunar_calendar/core/models/user_profile.dart';
import 'package:lunar_calendar/core/services/user_service.dart';

import '../../mocks/mock_services.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const UserProfile(
      uid: '',
      email: '',
      displayName: '',
      birthYear: 0,
      birthMonth: 1,
      birthDay: 1,
    ));
  });

  late FakeFirebaseFirestore fakeFirestore;
  late UserService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    service = UserService(db: fakeFirestore);
  });

  group('getProfile', () {
    test('returns null when user doc does not exist', () async {
      final result = await service.getProfile('nonexistent-uid');
      expect(result, isNull);
    });

    test('returns UserProfile when doc exists', () async {
      const profile = UserProfile(
        uid: 'uid-1',
        email: 'a@b.com',
        displayName: 'Alice',
        birthYear: 1990,
        birthMonth: 3,
        birthDay: 15,
      );
      await fakeFirestore
          .collection('users')
          .doc('uid-1')
          .set(profile.toFirestore());

      final result = await service.getProfile('uid-1');

      expect(result, isNotNull);
      expect(result!.uid, 'uid-1');
      expect(result.email, 'a@b.com');
      expect(result.birthYear, 1990);
    });
  });

  group('saveProfile', () {
    test('creates document with correct data', () async {
      const profile = UserProfile(
        uid: 'uid-save',
        email: 'save@test.com',
        displayName: 'Save User',
        birthYear: 1995,
        birthMonth: 7,
        birthDay: 20,
        birthHour: 10,
        isLunarBirth: true,
      );

      await service.saveProfile(profile);

      final doc = await fakeFirestore.collection('users').doc('uid-save').get();
      expect(doc.exists, true);
      expect(doc.data()!['email'], 'save@test.com');
      expect(doc.data()!['birthHour'], 10);
      expect(doc.data()!['isLunarBirth'], true);
    });

    test('updates existing document without overwriting other fields', () async {
      await fakeFirestore
          .collection('users')
          .doc('uid-update')
          .set({'uid': 'uid-update', 'fcmToken': 'existing-token'});

      const profile = UserProfile(
        uid: 'uid-update',
        email: 'update@test.com',
        displayName: 'Update User',
        birthYear: 2000,
        birthMonth: 1,
        birthDay: 1,
      );
      await service.saveProfile(profile);

      final doc =
          await fakeFirestore.collection('users').doc('uid-update').get();
      expect(doc.data()!['fcmToken'], 'existing-token');
      expect(doc.data()!['email'], 'update@test.com');
    });
  });

  group('hasProfile', () {
    test('returns false when doc does not exist', () async {
      final result = await service.hasProfile('no-uid');
      expect(result, false);
    });

    test('returns false when doc exists but birthYear is null', () async {
      await fakeFirestore
          .collection('users')
          .doc('uid-no-birth')
          .set({'uid': 'uid-no-birth', 'email': 'x@x.com'});

      final result = await service.hasProfile('uid-no-birth');
      expect(result, false);
    });

    test('returns true when doc exists with birthYear', () async {
      await fakeFirestore.collection('users').doc('uid-has-birth').set(
            const UserProfile(
              uid: 'uid-has-birth',
              email: 'b@b.com',
              displayName: 'B',
              birthYear: 1990,
              birthMonth: 1,
              birthDay: 1,
            ).toFirestore(),
          );

      final result = await service.hasProfile('uid-has-birth');
      expect(result, true);
    });
  });

  group('saveFcmToken', () {
    test('saves fcmToken field to Firestore', () async {
      await fakeFirestore
          .collection('users')
          .doc('uid-fcm')
          .set({'uid': 'uid-fcm'});

      await service.saveFcmToken('uid-fcm', 'fcm-token-abc');

      final doc =
          await fakeFirestore.collection('users').doc('uid-fcm').get();
      expect(doc.data()!['fcmToken'], 'fcm-token-abc');
    });

    test('creates doc if not exists when saving token', () async {
      await service.saveFcmToken('new-uid', 'token-xyz');
      final doc =
          await fakeFirestore.collection('users').doc('new-uid').get();
      expect(doc.exists, true);
      expect(doc.data()!['fcmToken'], 'token-xyz');
    });
  });

  group('createFromGoogleUser', () {
    test('creates new document for first-time user', () async {
      final mockUser = MockFirebaseUser();
      when(() => mockUser.uid).thenReturn('new-google-uid');
      when(() => mockUser.email).thenReturn('google@test.com');
      when(() => mockUser.displayName).thenReturn('Google User');

      await service.createFromGoogleUser(mockUser);

      final doc = await fakeFirestore
          .collection('users')
          .doc('new-google-uid')
          .get();
      expect(doc.exists, true);
      expect(doc.data()!['email'], 'google@test.com');
      expect(doc.data()!['displayName'], 'Google User');
    });

    test('does not overwrite existing user with birthYear', () async {
      await fakeFirestore.collection('users').doc('existing-uid').set(
            const UserProfile(
              uid: 'existing-uid',
              email: 'old@test.com',
              displayName: 'Old Name',
              birthYear: 1980,
              birthMonth: 5,
              birthDay: 10,
            ).toFirestore(),
          );

      final mockUser = MockFirebaseUser();
      when(() => mockUser.uid).thenReturn('existing-uid');
      when(() => mockUser.email).thenReturn('new@test.com');
      when(() => mockUser.displayName).thenReturn('New Name');

      await service.createFromGoogleUser(mockUser);

      final doc = await fakeFirestore
          .collection('users')
          .doc('existing-uid')
          .get();
      expect(doc.data()!['birthYear'], 1980);
    });

    test('handles null email and displayName gracefully', () async {
      final mockUser = MockFirebaseUser();
      when(() => mockUser.uid).thenReturn('null-fields-uid');
      when(() => mockUser.email).thenReturn(null);
      when(() => mockUser.displayName).thenReturn(null);

      await service.createFromGoogleUser(mockUser);

      final doc = await fakeFirestore
          .collection('users')
          .doc('null-fields-uid')
          .get();
      expect(doc.data()!['email'], '');
      expect(doc.data()!['displayName'], '');
    });
  });

  group('watchProfile', () {
    test('emits null when document does not exist', () async {
      expect(
        service.watchProfile('no-doc'),
        emits(isNull),
      );
    });

    test('emits UserProfile when document exists', () async {
      const profile = UserProfile(
        uid: 'watch-uid',
        email: 'watch@test.com',
        displayName: 'Watch User',
        birthYear: 1992,
        birthMonth: 4,
        birthDay: 18,
      );
      await fakeFirestore
          .collection('users')
          .doc('watch-uid')
          .set(profile.toFirestore());

      expect(
        service.watchProfile('watch-uid'),
        emits(predicate<dynamic>(
          (p) => p is UserProfile && p.email == 'watch@test.com',
        )),
      );
    });
  });
}
