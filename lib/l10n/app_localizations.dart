import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('ja'),
    Locale('ko'),
    Locale('ms'),
    Locale('ru'),
    Locale('tr'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Lunar Calendar'**
  String get appTitle;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navFortune.
  ///
  /// In en, this message translates to:
  /// **'Fortune'**
  String get navFortune;

  /// No description provided for @navFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get navFamily;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events for this day'**
  String get calendarNoEvents;

  /// No description provided for @calendarConnectRequired.
  ///
  /// In en, this message translates to:
  /// **'Google Calendar connection required'**
  String get calendarConnectRequired;

  /// No description provided for @calendarRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get calendarRetry;

  /// No description provided for @calendarAddAnniversary.
  ///
  /// In en, this message translates to:
  /// **'Add Anniversary'**
  String get calendarAddAnniversary;

  /// No description provided for @calendarAnniversaryList.
  ///
  /// In en, this message translates to:
  /// **'Anniversary List'**
  String get calendarAnniversaryList;

  /// No description provided for @anniversaryAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Anniversary'**
  String get anniversaryAdd;

  /// No description provided for @anniversaryName.
  ///
  /// In en, this message translates to:
  /// **'Name (e.g. Grandma\'s memorial)'**
  String get anniversaryName;

  /// No description provided for @anniversaryType_jesa.
  ///
  /// In en, this message translates to:
  /// **'Memorial'**
  String get anniversaryType_jesa;

  /// No description provided for @anniversaryType_birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get anniversaryType_birthday;

  /// No description provided for @anniversaryType_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get anniversaryType_other;

  /// No description provided for @anniversaryLunarHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the date in lunar calendar.\nEx) Lunar birthday Mar 15 → select month 3, day 15'**
  String get anniversaryLunarHint;

  /// No description provided for @anniversaryLunarMonth.
  ///
  /// In en, this message translates to:
  /// **'Lunar month'**
  String get anniversaryLunarMonth;

  /// No description provided for @anniversaryLunarDay.
  ///
  /// In en, this message translates to:
  /// **'Lunar day'**
  String get anniversaryLunarDay;

  /// No description provided for @anniversaryLeapMonth.
  ///
  /// In en, this message translates to:
  /// **'Leap month'**
  String get anniversaryLeapMonth;

  /// No description provided for @anniversaryCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get anniversaryCancel;

  /// No description provided for @anniversarySave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get anniversarySave;

  /// No description provided for @anniversaryDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Anniversary'**
  String get anniversaryDelete;

  /// No description provided for @anniversaryDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String anniversaryDeleteConfirm(String name);

  /// No description provided for @anniversaryAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} has been added'**
  String anniversaryAdded(String name);

  /// No description provided for @anniversaryDeleted.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" deleted'**
  String anniversaryDeleted(String name);

  /// No description provided for @anniversaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No anniversaries registered'**
  String get anniversaryEmpty;

  /// No description provided for @anniversaryListTitle.
  ///
  /// In en, this message translates to:
  /// **'Anniversary List'**
  String get anniversaryListTitle;

  /// No description provided for @anniversaryClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get anniversaryClose;

  /// No description provided for @fortuneTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Fortune'**
  String get fortuneTitle;

  /// No description provided for @fortuneLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading fortune...'**
  String get fortuneLoading;

  /// No description provided for @fortuneError.
  ///
  /// In en, this message translates to:
  /// **'Cannot load fortune: {error}'**
  String fortuneError(String error);

  /// No description provided for @fortuneSaju.
  ///
  /// In en, this message translates to:
  /// **'Four Pillars (四柱)'**
  String get fortuneSaju;

  /// No description provided for @fortuneSajuPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter your birth date in Settings to see your Four Pillars.'**
  String get fortuneSajuPrompt;

  /// No description provided for @fortuneToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get fortuneToday;

  /// No description provided for @fortuneLunarDate.
  ///
  /// In en, this message translates to:
  /// **'Lunar {month}/{day}'**
  String fortuneLunarDate(int month, int day);

  /// No description provided for @fortuneYearSuffix.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get fortuneYearSuffix;

  /// No description provided for @fortuneMonthSuffix.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get fortuneMonthSuffix;

  /// No description provided for @fortuneDaySuffix.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get fortuneDaySuffix;

  /// No description provided for @fortuneSolarTerm.
  ///
  /// In en, this message translates to:
  /// **'Solar term: {term}'**
  String fortuneSolarTerm(String term);

  /// No description provided for @familyTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Anniversaries'**
  String get familyTitle;

  /// No description provided for @familyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No anniversaries registered'**
  String get familyEmpty;

  /// No description provided for @familyAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add Anniversary'**
  String get familyAddButton;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get settingsBirthDate;

  /// No description provided for @settingsRegisterBirthday.
  ///
  /// In en, this message translates to:
  /// **'Register Birthday in Google Calendar'**
  String get settingsRegisterBirthday;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get settingsSignOut;

  /// No description provided for @settingsBirthdayDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Register My Birthday'**
  String get settingsBirthdayDialogTitle;

  /// No description provided for @settingsBirthdayDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Register lunar birthday ({month}/{day}) to Google Calendar for 20 years?'**
  String settingsBirthdayDialogBody(int month, int day);

  /// No description provided for @settingsBirthdayRegistered.
  ///
  /// In en, this message translates to:
  /// **'{count} birthday events registered!'**
  String settingsBirthdayRegistered(int count);

  /// No description provided for @settingsBirthdayNone.
  ///
  /// In en, this message translates to:
  /// **'No birth date found. Please enter it during onboarding.'**
  String get settingsBirthdayNone;

  /// No description provided for @settingsLegalTitle.
  ///
  /// In en, this message translates to:
  /// **'Information & Legal'**
  String get settingsLegalTitle;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacy;

  /// No description provided for @settingsPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'This app collects your name and email via Google Sign-In, and stores your birth date in Firestore. This information is used solely for fortune and Four Pillars calculations, and is not shared with third parties.'**
  String get settingsPrivacyBody;

  /// No description provided for @settingsCalendarPermission.
  ///
  /// In en, this message translates to:
  /// **'Google Calendar Permission'**
  String get settingsCalendarPermission;

  /// No description provided for @settingsCalendarPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'When using calendar sync, we request read/write access to Google Calendar. This permission is used only for viewing events and registering lunar birthdays.'**
  String get settingsCalendarPermissionBody;

  /// No description provided for @settingsNotificationPermission.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission'**
  String get settingsNotificationPermission;

  /// No description provided for @settingsNotificationPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Local notifications are used to remind you of anniversaries (7 days, 3 days, and on the day). Notifications are processed on-device only and are not sent to external servers.'**
  String get settingsNotificationPermissionBody;

  /// No description provided for @settingsAI.
  ///
  /// In en, this message translates to:
  /// **'AI Fortune (Gemini)'**
  String get settingsAI;

  /// No description provided for @settingsAIBody.
  ///
  /// In en, this message translates to:
  /// **'Daily fortune is generated via the Google Gemini API. Your Four Pillars info may be sent during generation. Replaced by local fortune after 1,200 daily uses.'**
  String get settingsAIBody;

  /// No description provided for @settingsAdMob.
  ///
  /// In en, this message translates to:
  /// **'Ads (AdMob)'**
  String get settingsAdMob;

  /// No description provided for @settingsAdMobBody.
  ///
  /// In en, this message translates to:
  /// **'This app displays ads via Google AdMob. AdMob may collect device identifiers for ad optimization. See Google\'s Privacy Policy for details.'**
  String get settingsAdMobBody;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}  ·  © 2026 Gridnflow'**
  String settingsVersion(String version);

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us your birth date'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Used for fortune and Four Pillars.\nYou can change this later in Settings.'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingSolar.
  ///
  /// In en, this message translates to:
  /// **'Solar calendar'**
  String get onboardingSolar;

  /// No description provided for @onboardingLunar.
  ///
  /// In en, this message translates to:
  /// **'Lunar calendar'**
  String get onboardingLunar;

  /// No description provided for @onboardingSolarHint.
  ///
  /// In en, this message translates to:
  /// **'Enter solar date (e.g. April 20, 1990)'**
  String get onboardingSolarHint;

  /// No description provided for @onboardingLunarHint.
  ///
  /// In en, this message translates to:
  /// **'Enter lunar date (e.g. Lunar Mar 15)'**
  String get onboardingLunarHint;

  /// No description provided for @onboardingYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get onboardingYear;

  /// No description provided for @onboardingMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get onboardingMonth;

  /// No description provided for @onboardingDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get onboardingDay;

  /// No description provided for @onboardingHour.
  ///
  /// In en, this message translates to:
  /// **'Birth hour (optional, 0–23)'**
  String get onboardingHour;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingStart;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'I\'ll enter it later'**
  String get onboardingSkip;

  /// No description provided for @onboardingRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get onboardingRequired;

  /// No description provided for @onboardingRange.
  ///
  /// In en, this message translates to:
  /// **'{min}–{max}'**
  String onboardingRange(int min, int max);

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get loginTitle;

  /// No description provided for @loginGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginGoogle;

  /// No description provided for @languageSelect.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get languageSelect;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageKo.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get languageKo;

  /// No description provided for @languageJa.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get languageJa;

  /// No description provided for @languageZhHans.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get languageZhHans;

  /// No description provided for @languageZhHant.
  ///
  /// In en, this message translates to:
  /// **'繁體中文'**
  String get languageZhHant;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'id',
    'ja',
    'ko',
    'ms',
    'ru',
    'tr',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ms':
      return AppLocalizationsMs();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
