import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lunar_calendar/core/providers/service_providers.dart';
import 'package:lunar_calendar/features/auth/presentation/login_screen.dart';

import '../../mocks/mock_services.dart';

void main() {
  late MockAuthService mockAuth;
  late MockUserService mockUser;
  late MockNotificationService mockNotif;

  setUp(() {
    mockAuth = MockAuthService();
    mockUser = MockUserService();
    mockNotif = MockNotificationService();
  });

  Widget buildSubject() {
    return ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuth),
        userServiceProvider.overrideWithValue(mockUser),
        notificationServiceProvider.overrideWithValue(mockNotif),
      ],
      child: const MaterialApp(home: LoginScreen()),
    );
  }

  group('LoginScreen', () {
    testWidgets('renders app name', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.text('Lunar Calendar'), findsOneWidget);
    });

    testWidgets('renders subtitle', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.text('음력 달력 · 오늘의 운세 · 일정 관리'), findsOneWidget);
    });

    testWidgets('renders sign-in button', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.text('Sign in with Google'), findsOneWidget);
    });

    testWidgets('renders calendar icon', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.byIcon(Icons.calendar_month), findsOneWidget);
    });

    testWidgets('shows snackbar on sign-in failure', (tester) async {
      when(() => mockAuth.signInWithGoogle())
          .thenThrow(Exception('auth error'));

      await tester.pumpWidget(buildSubject());
      await tester.tap(find.text('Sign in with Google'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Sign-in failed'), findsOneWidget);
    });
  });
}
