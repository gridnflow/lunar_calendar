import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lunar_calendar/core/models/user_profile.dart';
import 'package:lunar_calendar/core/providers/service_providers.dart';
import 'package:lunar_calendar/features/settings/presentation/settings_screen.dart';

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

  late MockUserService mockUser;
  late MockAuthService mockAuth;
  late MockFirebaseUser mockFirebaseUser;

  setUp(() {
    mockUser = MockUserService();
    mockAuth = MockAuthService();
    mockFirebaseUser = MockFirebaseUser();

    when(() => mockFirebaseUser.uid).thenReturn('test-uid');
    when(() => mockFirebaseUser.email).thenReturn('test@example.com');
    when(() => mockFirebaseUser.displayName).thenReturn('Test User');
  });

  Widget buildSubject({UserProfile? profile}) {
    return ProviderScope(
      overrides: [
        userServiceProvider.overrideWithValue(mockUser),
        authServiceProvider.overrideWithValue(mockAuth),
        currentUserProvider.overrideWithValue(mockFirebaseUser),
        userProfileProvider.overrideWith(
          (ref) async => profile,
        ),
      ],
      child: const MaterialApp(home: SettingsScreen()),
    );
  }

  group('SettingsScreen', () {
    testWidgets('shows appbar with Settings title', (tester) async {
      when(() => mockUser.getProfile(any())).thenAnswer((_) async => null);

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('shows Birth Info section', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Birth Info'), findsOneWidget);
    });

    testWidgets('shows Year, Month, Day input fields', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Year'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Month'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Day'), findsOneWidget);
    });

    testWidgets('shows optional hour field', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.textContaining('Hour'), findsOneWidget);
    });

    testWidgets('shows lunar toggle', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Lunar calendar birth date'), findsOneWidget);
    });

    testWidgets('shows Save button', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('shows Sign Out button', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Sign Out'), findsOneWidget);
    });

    testWidgets('pre-fills form when profile exists', (tester) async {
      const existingProfile = UserProfile(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        birthYear: 1990,
        birthMonth: 5,
        birthDay: 20,
        isLunarBirth: true,
      );

      await tester.pumpWidget(buildSubject(profile: existingProfile));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Year'), findsOneWidget);
      final yearField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, 'Year'),
      );
      expect(yearField.controller?.text, '1990');
    });

    testWidgets('shows validation error when saving empty Year', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Required'), findsWidgets);
    });

    testWidgets('saves profile when form is valid', (tester) async {
      when(() => mockUser.saveProfile(any())).thenAnswer((_) async {});

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Year'), '1990');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Month'), '5');
      await tester.enterText(find.widgetWithText(TextFormField, 'Day'), '20');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      verify(() => mockUser.saveProfile(any())).called(1);
    });

    testWidgets('calls signOut when Sign Out tapped', (tester) async {
      when(() => mockAuth.signOut()).thenAnswer((_) async {});

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign Out'));
      await tester.pumpAndSettle();

      verify(() => mockAuth.signOut()).called(1);
    });

    testWidgets('toggles isLunar switch', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      final switchWidget = tester.widget<Switch>(switchFinder);
      expect(switchWidget.value, false);

      await tester.tap(switchFinder);
      await tester.pump();

      final updatedSwitch = tester.widget<Switch>(switchFinder);
      expect(updatedSwitch.value, true);
    });
  });
}
