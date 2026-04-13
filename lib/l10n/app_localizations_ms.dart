// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appTitle => 'Kalendar Lunar';

  @override
  String get navCalendar => 'Kalendar';

  @override
  String get navFortune => 'Ramalan';

  @override
  String get navFamily => 'Keluarga';

  @override
  String get navSettings => 'Tetapan';

  @override
  String get calendarTitle => 'Kalendar';

  @override
  String get calendarNoEvents => 'Tiada acara pada hari ini';

  @override
  String get calendarConnectRequired => 'Sambungan Google Calendar diperlukan';

  @override
  String get calendarRetry => 'Cuba lagi';

  @override
  String get calendarAddAnniversary => 'Tambah Ulang Tahun';

  @override
  String get calendarAnniversaryList => 'Senarai Ulang Tahun';

  @override
  String get anniversaryAdd => 'Tambah Ulang Tahun';

  @override
  String get anniversaryName => 'Nama (cth: Arwah nenek)';

  @override
  String get anniversaryType_jesa => 'Arwah';

  @override
  String get anniversaryType_birthday => 'Hari Lahir';

  @override
  String get anniversaryType_other => 'Lain-lain';

  @override
  String get anniversaryLunarHint =>
      'Sila masukkan tarikh mengikut kalendar lunar.\nCth: Hari lahir lunar 15/3 → pilih bulan 3, hari 15';

  @override
  String get anniversaryLunarMonth => 'Bulan lunar';

  @override
  String get anniversaryLunarDay => 'Hari lunar';

  @override
  String get anniversaryLeapMonth => 'Bulan lompat';

  @override
  String get anniversaryCancel => 'Batal';

  @override
  String get anniversarySave => 'Simpan';

  @override
  String get anniversaryDelete => 'Padam Ulang Tahun';

  @override
  String anniversaryDeleteConfirm(String name) {
    return 'Padam \"$name\"?';
  }

  @override
  String anniversaryAdded(String name) {
    return '$name telah ditambah';
  }

  @override
  String anniversaryDeleted(String name) {
    return '\"$name\" dipadam';
  }

  @override
  String get anniversaryEmpty => 'Tiada ulang tahun didaftarkan';

  @override
  String get anniversaryListTitle => 'Senarai Ulang Tahun';

  @override
  String get anniversaryClose => 'Tutup';

  @override
  String get fortuneTitle => 'Ramalan Hari Ini';

  @override
  String get fortuneLoading => 'Memuatkan ramalan...';

  @override
  String fortuneError(String error) {
    return 'Tidak dapat memuatkan ramalan: $error';
  }

  @override
  String get fortuneSaju => 'Empat Tiang';

  @override
  String get fortuneSajuPrompt =>
      'Masukkan tarikh lahir dalam Tetapan untuk melihat Empat Tiang.';

  @override
  String get fortuneToday => 'Hari ini';

  @override
  String fortuneLunarDate(int month, int day) {
    return 'Kalendar lunar $month/$day';
  }

  @override
  String get fortuneYearSuffix => 'Tahun';

  @override
  String get fortuneMonthSuffix => 'Bulan';

  @override
  String get fortuneDaySuffix => 'Hari';

  @override
  String fortuneSolarTerm(String term) {
    return 'Musim: $term';
  }

  @override
  String get familyTitle => 'Ulang Tahun Keluarga';

  @override
  String get familyEmpty => 'Tiada ulang tahun didaftarkan';

  @override
  String get familyAddButton => 'Tambah Ulang Tahun';

  @override
  String get settingsTitle => 'Tetapan';

  @override
  String get settingsBirthDate => 'Tarikh Lahir';

  @override
  String get settingsRegisterBirthday => 'Daftar Hari Lahir ke Google Calendar';

  @override
  String get settingsSignOut => 'Log Keluar';

  @override
  String get settingsBirthdayDialogTitle => 'Daftar Hari Lahir Saya';

  @override
  String settingsBirthdayDialogBody(int month, int day) {
    return 'Daftar hari lahir lunar ($month/$day) ke Google Calendar selama 20 tahun?';
  }

  @override
  String settingsBirthdayRegistered(int count) {
    return '$count acara hari lahir telah didaftarkan!';
  }

  @override
  String get settingsBirthdayNone =>
      'Tarikh lahir tidak ditemui. Sila masukkan semasa orientasi.';

  @override
  String get settingsLegalTitle => 'Maklumat & Undang-undang';

  @override
  String get settingsPrivacy => 'Dasar Privasi';

  @override
  String get settingsPrivacyBody =>
      'Aplikasi ini mengumpul nama dan e-mel melalui Google Sign-In, dan menyimpan tarikh lahir di Firestore. Maklumat hanya digunakan untuk pengiraan ramalan dan tidak dikongsi dengan pihak ketiga.';

  @override
  String get settingsCalendarPermission => 'Kebenaran Google Calendar';

  @override
  String get settingsCalendarPermissionBody =>
      'Semasa menggunakan penyegerakan kalendar, kami meminta kebenaran baca/tulis Google Calendar. Kebenaran ini hanya digunakan untuk melihat acara dan mendaftar hari lahir lunar.';

  @override
  String get settingsNotificationPermission => 'Kebenaran Pemberitahuan';

  @override
  String get settingsNotificationPermissionBody =>
      'Pemberitahuan tempatan digunakan untuk mengingatkan ulang tahun (7 hari, 3 hari, dan pada hari tersebut). Pemberitahuan hanya diproses pada peranti dan tidak dihantar ke pelayan luar.';

  @override
  String get settingsAI => 'Ramalan AI (Gemini)';

  @override
  String get settingsAIBody =>
      'Ramalan harian dijana menggunakan Google Gemini API. Maklumat Empat Tiang mungkin dihantar semasa penjanaan. Digantikan dengan ramalan tempatan selepas 1,200 kali sehari.';

  @override
  String get settingsAdMob => 'Iklan (AdMob)';

  @override
  String get settingsAdMobBody =>
      'Aplikasi ini memaparkan iklan melalui Google AdMob. AdMob mungkin mengumpul pengecam peranti untuk pengoptimuman iklan. Lihat Dasar Privasi Google untuk maklumat lanjut.';

  @override
  String settingsVersion(String version) {
    return 'Versi $version  ·  © 2026 Gridnflow';
  }

  @override
  String get onboardingTitle => 'Beritahu kami tarikh lahir anda';

  @override
  String get onboardingSubtitle =>
      'Digunakan untuk ramalan dan Empat Tiang.\nAnda boleh menukarnya kemudian dalam Tetapan.';

  @override
  String get onboardingSolar => 'Kalendar Masihi';

  @override
  String get onboardingLunar => 'Kalendar Lunar';

  @override
  String get onboardingSolarHint =>
      'Masukkan tarikh Masihi (cth: 20 April 1990)';

  @override
  String get onboardingLunarHint => 'Masukkan tarikh lunar (cth: Lunar 15/3)';

  @override
  String get onboardingYear => 'Tahun';

  @override
  String get onboardingMonth => 'Bulan';

  @override
  String get onboardingDay => 'Hari';

  @override
  String get onboardingHour => 'Jam lahir (pilihan, 0–23)';

  @override
  String get onboardingStart => 'Mulakan';

  @override
  String get onboardingSkip => 'Isi kemudian';

  @override
  String get onboardingRequired => 'Wajib';

  @override
  String onboardingRange(int min, int max) {
    return '$min–$max';
  }

  @override
  String get loginTitle => 'Log masuk untuk teruskan';

  @override
  String get loginGoogle => 'Teruskan dengan Google';

  @override
  String get languageSelect => 'Pilih Bahasa';

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
