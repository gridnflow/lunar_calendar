// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Kalender Lunar';

  @override
  String get navCalendar => 'Kalender';

  @override
  String get navFortune => 'Ramalan';

  @override
  String get navFamily => 'Keluarga';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String get calendarTitle => 'Kalender';

  @override
  String get calendarNoEvents => 'Tidak ada acara pada hari ini';

  @override
  String get calendarConnectRequired => 'Koneksi Google Calendar diperlukan';

  @override
  String get calendarRetry => 'Coba lagi';

  @override
  String get calendarAddAnniversary => 'Tambah Peringatan';

  @override
  String get calendarAnniversaryList => 'Daftar Peringatan';

  @override
  String get anniversaryAdd => 'Tambah Peringatan';

  @override
  String get anniversaryName => 'Nama (mis. Arwah nenek)';

  @override
  String get anniversaryType_jesa => 'Arwah';

  @override
  String get anniversaryType_birthday => 'Ulang Tahun';

  @override
  String get anniversaryType_other => 'Lainnya';

  @override
  String get anniversaryLunarHint =>
      'Masukkan tanggal berdasarkan kalender lunar.\nContoh: Ulang tahun lunar 15/3 → pilih bulan 3, hari 15';

  @override
  String get anniversaryLunarMonth => 'Bulan lunar';

  @override
  String get anniversaryLunarDay => 'Hari lunar';

  @override
  String get anniversaryLeapMonth => 'Bulan kabisat';

  @override
  String get anniversaryCancel => 'Batal';

  @override
  String get anniversarySave => 'Simpan';

  @override
  String get anniversaryDelete => 'Hapus Peringatan';

  @override
  String anniversaryDeleteConfirm(String name) {
    return 'Hapus \"$name\"?';
  }

  @override
  String anniversaryAdded(String name) {
    return '$name telah ditambahkan';
  }

  @override
  String anniversaryDeleted(String name) {
    return '\"$name\" dihapus';
  }

  @override
  String get anniversaryEmpty => 'Belum ada peringatan terdaftar';

  @override
  String get anniversaryListTitle => 'Daftar Peringatan';

  @override
  String get anniversaryClose => 'Tutup';

  @override
  String get fortuneTitle => 'Ramalan Hari Ini';

  @override
  String get fortuneLoading => 'Memuat ramalan...';

  @override
  String fortuneError(String error) {
    return 'Tidak dapat memuat ramalan: $error';
  }

  @override
  String get fortuneSaju => 'Empat Pilar';

  @override
  String get fortuneSajuPrompt =>
      'Masukkan tanggal lahir di Pengaturan untuk melihat Empat Pilar.';

  @override
  String get fortuneToday => 'Hari ini';

  @override
  String fortuneLunarDate(int month, int day) {
    return 'Kalender lunar $month/$day';
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
  String get familyTitle => 'Peringatan Keluarga';

  @override
  String get familyEmpty => 'Belum ada peringatan terdaftar';

  @override
  String get familyAddButton => 'Tambah Peringatan';

  @override
  String get familyToday => 'Hari ini 🎉';

  @override
  String familyDDaySoon(int diff, String lunarDate) {
    return 'D-$diff  $lunarDate';
  }

  @override
  String familyDDay(int diff, String lunarDate) {
    return '$lunarDate (D-$diff)';
  }

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsBirthDate => 'Tanggal Lahir';

  @override
  String get settingsRegisterBirthday =>
      'Daftarkan Ulang Tahun ke Google Calendar';

  @override
  String get settingsSignOut => 'Keluar';

  @override
  String get settingsBirthdayDialogTitle => 'Daftarkan Ulang Tahun Saya';

  @override
  String settingsBirthdayDialogBody(int month, int day) {
    return 'Daftarkan ulang tahun lunar ($month/$day) ke Google Calendar selama 20 tahun?';
  }

  @override
  String settingsBirthdayRegistered(int count) {
    return '$count acara ulang tahun telah didaftarkan!';
  }

  @override
  String get settingsBirthdayNone =>
      'Tanggal lahir tidak ditemukan. Silakan masukkan saat orientasi.';

  @override
  String get settingsLegalTitle => 'Informasi & Hukum';

  @override
  String get settingsPrivacy => 'Kebijakan Privasi';

  @override
  String get settingsPrivacyBody =>
      'Aplikasi ini mengumpulkan nama dan email melalui Google Sign-In, dan menyimpan tanggal lahir di Firestore. Informasi hanya digunakan untuk perhitungan ramalan dan tidak dibagikan ke pihak ketiga.';

  @override
  String get settingsCalendarPermission => 'Izin Google Calendar';

  @override
  String get settingsCalendarPermissionBody =>
      'Saat menggunakan sinkronisasi kalender, kami meminta izin baca/tulis Google Calendar. Izin ini hanya digunakan untuk melihat acara dan mendaftarkan ulang tahun lunar.';

  @override
  String get settingsNotificationPermission => 'Izin Notifikasi';

  @override
  String get settingsNotificationPermissionBody =>
      'Notifikasi lokal digunakan untuk mengingatkan peringatan (7 hari, 3 hari, dan pada hari tersebut). Notifikasi hanya diproses di perangkat dan tidak dikirim ke server eksternal.';

  @override
  String get settingsAI => 'Ramalan AI (Gemini)';

  @override
  String get settingsAIBody =>
      'Ramalan harian dibuat menggunakan Google Gemini API. Informasi Empat Pilar mungkin dikirimkan saat pembuatan. Diganti ramalan lokal setelah 1.200 kali per hari.';

  @override
  String get settingsAdMob => 'Iklan (AdMob)';

  @override
  String get settingsAdMobBody =>
      'Aplikasi ini menampilkan iklan melalui Google AdMob. AdMob dapat mengumpulkan pengidentifikasi perangkat untuk optimasi iklan. Lihat Kebijakan Privasi Google untuk detailnya.';

  @override
  String settingsVersion(String version) {
    return 'Versi $version  ·  © 2026 Gridnflow';
  }

  @override
  String get onboardingTitle => 'Beritahu kami tanggal lahir Anda';

  @override
  String get onboardingSubtitle =>
      'Digunakan untuk ramalan dan Empat Pilar.\nAnda dapat mengubahnya nanti di Pengaturan.';

  @override
  String get onboardingSolar => 'Kalender Masehi';

  @override
  String get onboardingLunar => 'Kalender Lunar';

  @override
  String get onboardingSolarHint =>
      'Masukkan tanggal Masehi (mis. 20 April 1990)';

  @override
  String get onboardingLunarHint => 'Masukkan tanggal lunar (mis. Lunar 15/3)';

  @override
  String get onboardingYear => 'Tahun';

  @override
  String get onboardingMonth => 'Bulan';

  @override
  String get onboardingDay => 'Hari';

  @override
  String get onboardingHour => 'Jam lahir (opsional, 0–23)';

  @override
  String get onboardingStart => 'Mulai';

  @override
  String get onboardingSkip => 'Isi nanti';

  @override
  String get onboardingRequired => 'Wajib';

  @override
  String onboardingRange(int min, int max) {
    return '$min–$max';
  }

  @override
  String get loginTitle => 'Masuk untuk melanjutkan';

  @override
  String get loginGoogle => 'Lanjutkan dengan Google';

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
