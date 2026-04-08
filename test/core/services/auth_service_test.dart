import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lunar_calendar/core/services/auth_service.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseUser extends Mock implements User {}

class FakeAuthCredential extends Fake implements AuthCredential {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAuthCredential());
  });

  late MockFirebaseAuth mockAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late AuthService service;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    service = AuthService(auth: mockAuth, googleSignIn: mockGoogleSignIn);
  });

  group('AuthService', () {
    group('currentUser', () {
      test('returns null when not signed in', () {
        when(() => mockAuth.currentUser).thenReturn(null);
        expect(service.currentUser, isNull);
      });

      test('returns user when signed in', () {
        final user = MockFirebaseUser();
        when(() => mockAuth.currentUser).thenReturn(user);
        expect(service.currentUser, user);
      });
    });

    group('authStateChanges', () {
      test('returns stream from FirebaseAuth', () {
        when(() => mockAuth.authStateChanges())
            .thenAnswer((_) => const Stream.empty());
        expect(service.authStateChanges, isA<Stream<User?>>());
      });
    });

    group('signInWithGoogle', () {
      test('throws when googleSignIn returns null', () async {
        when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);
        expect(() => service.signInWithGoogle(), throwsException);
      });

      test('completes sign-in flow and returns UserCredential', () async {
        final mockAccount = MockGoogleSignInAccount();
        final mockGoogleAuth = MockGoogleSignInAuthentication();
        final mockCredential = MockUserCredential();

        when(() => mockGoogleSignIn.signIn())
            .thenAnswer((_) async => mockAccount);
        when(() => mockAccount.authentication)
            .thenAnswer((_) async => mockGoogleAuth);
        when(() => mockGoogleAuth.accessToken).thenReturn('access-token');
        when(() => mockGoogleAuth.idToken).thenReturn('id-token');
        when(() => mockAuth.signInWithCredential(any()))
            .thenAnswer((_) async => mockCredential);

        final result = await service.signInWithGoogle();
        expect(result, mockCredential);
        verify(() => mockAuth.signInWithCredential(any())).called(1);
      });
    });

    group('getGoogleAccessToken', () {
      test('returns null when no current user and silent sign-in fails', () async {
        when(() => mockGoogleSignIn.currentUser).thenReturn(null);
        when(() => mockGoogleSignIn.signInSilently())
            .thenAnswer((_) async => null);

        final token = await service.getGoogleAccessToken();
        expect(token, isNull);
      });

      test('returns null when calendar scope is denied', () async {
        final mockAccount = MockGoogleSignInAccount();

        when(() => mockGoogleSignIn.currentUser).thenReturn(mockAccount);
        when(() => mockGoogleSignIn.requestScopes(any()))
            .thenAnswer((_) async => false);

        final token = await service.getGoogleAccessToken();
        expect(token, isNull);
      });

      test('returns access token when calendar scope is granted', () async {
        final mockAccount = MockGoogleSignInAccount();
        final mockGoogleAuth = MockGoogleSignInAuthentication();

        when(() => mockGoogleSignIn.currentUser).thenReturn(mockAccount);
        when(() => mockGoogleSignIn.requestScopes(any()))
            .thenAnswer((_) async => true);
        when(() => mockAccount.authentication)
            .thenAnswer((_) async => mockGoogleAuth);
        when(() => mockGoogleAuth.accessToken).thenReturn('my-token');

        final token = await service.getGoogleAccessToken();
        expect(token, 'my-token');
      });

      test('uses silent sign-in when currentUser is null', () async {
        final mockAccount = MockGoogleSignInAccount();
        final mockGoogleAuth = MockGoogleSignInAuthentication();

        when(() => mockGoogleSignIn.currentUser).thenReturn(null);
        when(() => mockGoogleSignIn.signInSilently())
            .thenAnswer((_) async => mockAccount);
        when(() => mockGoogleSignIn.requestScopes(any()))
            .thenAnswer((_) async => true);
        when(() => mockAccount.authentication)
            .thenAnswer((_) async => mockGoogleAuth);
        when(() => mockGoogleAuth.accessToken).thenReturn('silent-token');

        final token = await service.getGoogleAccessToken();
        expect(token, 'silent-token');
      });
    });

    group('signOut', () {
      test('calls both firebase and google sign-out', () async {
        when(() => mockAuth.signOut()).thenAnswer((_) async {});
        when(() => mockGoogleSignIn.signOut())
            .thenAnswer((_) async => null);

        await service.signOut();

        verify(() => mockAuth.signOut()).called(1);
        verify(() => mockGoogleSignIn.signOut()).called(1);
      });
    });
  });
}
