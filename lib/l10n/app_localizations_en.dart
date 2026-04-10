// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Lunar Calendar';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navFortune => 'Fortune';

  @override
  String get navFamily => 'Family';

  @override
  String get navSettings => 'Settings';

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get calendarNoEvents => 'No events for this day';

  @override
  String get calendarConnectRequired => 'Google Calendar connection required';

  @override
  String get calendarRetry => 'Retry';

  @override
  String get calendarAddAnniversary => 'Add Anniversary';

  @override
  String get calendarAnniversaryList => 'Anniversary List';

  @override
  String get anniversaryAdd => 'Add Anniversary';

  @override
  String get anniversaryName => 'Name (e.g. Grandma\'s memorial)';

  @override
  String get anniversaryType_jesa => 'Memorial';

  @override
  String get anniversaryType_birthday => 'Birthday';

  @override
  String get anniversaryType_other => 'Other';

  @override
  String get anniversaryLunarHint =>
      'Enter the date in lunar calendar.\nEx) Lunar birthday Mar 15 → select month 3, day 15';

  @override
  String get anniversaryLunarMonth => 'Lunar month';

  @override
  String get anniversaryLunarDay => 'Lunar day';

  @override
  String get anniversaryLeapMonth => 'Leap month';

  @override
  String get anniversaryCancel => 'Cancel';

  @override
  String get anniversarySave => 'Save';

  @override
  String get anniversaryDelete => 'Delete Anniversary';

  @override
  String anniversaryDeleteConfirm(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String anniversaryAdded(String name) {
    return '$name has been added';
  }

  @override
  String anniversaryDeleted(String name) {
    return '\"$name\" deleted';
  }

  @override
  String get anniversaryEmpty => 'No anniversaries registered';

  @override
  String get anniversaryListTitle => 'Anniversary List';

  @override
  String get anniversaryClose => 'Close';

  @override
  String get fortuneTitle => 'Today\'s Fortune';

  @override
  String get fortuneLoading => 'Loading fortune...';

  @override
  String fortuneError(String error) {
    return 'Cannot load fortune: $error';
  }

  @override
  String get fortuneSaju => 'Four Pillars (四柱)';

  @override
  String get fortuneSajuPrompt =>
      'Enter your birth date in Settings to see your Four Pillars.';

  @override
  String get fortuneToday => 'Today';

  @override
  String fortuneSolarTerm(String term) {
    return 'Solar term: $term';
  }

  @override
  String get familyTitle => 'Family Anniversaries';

  @override
  String get familyEmpty => 'No anniversaries registered';

  @override
  String get familyAddButton => 'Add Anniversary';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsBirthDate => 'Birth Date';

  @override
  String get settingsRegisterBirthday => 'Register Birthday in Google Calendar';

  @override
  String get settingsSignOut => 'Sign Out';

  @override
  String get settingsBirthdayDialogTitle => 'Register My Birthday';

  @override
  String settingsBirthdayDialogBody(int month, int day) {
    return 'Register lunar birthday ($month/$day) to Google Calendar for 20 years?';
  }

  @override
  String settingsBirthdayRegistered(int count) {
    return '$count birthday events registered!';
  }

  @override
  String get settingsBirthdayNone =>
      'No birth date found. Please enter it during onboarding.';

  @override
  String get settingsLegalTitle => 'Information & Legal';

  @override
  String get settingsPrivacy => 'Privacy Policy';

  @override
  String get settingsPrivacyBody =>
      'This app collects your name and email via Google Sign-In, and stores your birth date in Firestore. This information is used solely for fortune and Four Pillars calculations, and is not shared with third parties.';

  @override
  String get settingsCalendarPermission => 'Google Calendar Permission';

  @override
  String get settingsCalendarPermissionBody =>
      'When using calendar sync, we request read/write access to Google Calendar. This permission is used only for viewing events and registering lunar birthdays.';

  @override
  String get settingsNotificationPermission => 'Notification Permission';

  @override
  String get settingsNotificationPermissionBody =>
      'Local notifications are used to remind you of anniversaries (7 days, 3 days, and on the day). Notifications are processed on-device only and are not sent to external servers.';

  @override
  String get settingsAI => 'AI Fortune (Gemini)';

  @override
  String get settingsAIBody =>
      'Daily fortune is generated via the Google Gemini API. Your Four Pillars info may be sent during generation. Replaced by local fortune after 1,200 daily uses.';

  @override
  String get settingsAdMob => 'Ads (AdMob)';

  @override
  String get settingsAdMobBody =>
      'This app displays ads via Google AdMob. AdMob may collect device identifiers for ad optimization. See Google\'s Privacy Policy for details.';

  @override
  String settingsVersion(String version) {
    return 'Version $version  ·  © 2026 Gridnflow';
  }

  @override
  String get onboardingTitle => 'Tell us your birth date';

  @override
  String get onboardingSubtitle =>
      'Used for fortune and Four Pillars.\nYou can change this later in Settings.';

  @override
  String get onboardingSolar => 'Solar calendar';

  @override
  String get onboardingLunar => 'Lunar calendar';

  @override
  String get onboardingSolarHint => 'Enter solar date (e.g. April 20, 1990)';

  @override
  String get onboardingLunarHint => 'Enter lunar date (e.g. Lunar Mar 15)';

  @override
  String get onboardingYear => 'Year';

  @override
  String get onboardingMonth => 'Month';

  @override
  String get onboardingDay => 'Day';

  @override
  String get onboardingHour => 'Birth hour (optional, 0–23)';

  @override
  String get onboardingStart => 'Get Started';

  @override
  String get onboardingSkip => 'I\'ll enter it later';

  @override
  String get onboardingRequired => 'Required';

  @override
  String onboardingRange(int min, int max) {
    return '$min–$max';
  }

  @override
  String get loginTitle => 'Sign in to continue';

  @override
  String get loginGoogle => 'Continue with Google';

  @override
  String get languageSelect => 'Select Language';

  @override
  String get languageEn => 'English';

  @override
  String get languageKo => '한국어';

  @override
  String get languageJa => '日本語';

  @override
  String get languageZhHans => '简体中文';

  @override
  String get languageZhHant => '繁體中文';
}
