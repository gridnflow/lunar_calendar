// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Ay Takvimi';

  @override
  String get navCalendar => 'Takvim';

  @override
  String get navFortune => 'Fal';

  @override
  String get navFamily => 'Aile';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get calendarTitle => 'Takvim';

  @override
  String get calendarNoEvents => 'Bu gün için etkinlik yok';

  @override
  String get calendarConnectRequired => 'Google Takvim bağlantısı gerekli';

  @override
  String get calendarRetry => 'Tekrar dene';

  @override
  String get calendarAddAnniversary => 'Yıl Dönümü Ekle';

  @override
  String get calendarAnniversaryList => 'Yıl Dönümleri';

  @override
  String get anniversaryAdd => 'Yıl Dönümü Ekle';

  @override
  String get anniversaryName => 'Ad (örn: Büyükannenin anma töreni)';

  @override
  String get anniversaryType_jesa => 'Anma';

  @override
  String get anniversaryType_birthday => 'Doğum Günü';

  @override
  String get anniversaryType_other => 'Diğer';

  @override
  String get anniversaryLunarHint =>
      'Tarihi ay takvimine göre girin.\nÖrn: Ay takvimi doğum günü 15/3 → ay 3, gün 15 seçin';

  @override
  String get anniversaryLunarMonth => 'Ay (lunar)';

  @override
  String get anniversaryLunarDay => 'Gün (lunar)';

  @override
  String get anniversaryLeapMonth => 'Artık ay';

  @override
  String get anniversaryCancel => 'İptal';

  @override
  String get anniversarySave => 'Kaydet';

  @override
  String get anniversaryDelete => 'Yıl Dönümünü Sil';

  @override
  String anniversaryDeleteConfirm(String name) {
    return '\"$name\" silinsin mi?';
  }

  @override
  String anniversaryAdded(String name) {
    return '$name eklendi';
  }

  @override
  String anniversaryDeleted(String name) {
    return '\"$name\" silindi';
  }

  @override
  String get anniversaryEmpty => 'Kayıtlı yıl dönümü yok';

  @override
  String get anniversaryListTitle => 'Yıl Dönümleri';

  @override
  String get anniversaryClose => 'Kapat';

  @override
  String get fortuneTitle => 'Bugünün Falı';

  @override
  String get fortuneLoading => 'Fal yükleniyor...';

  @override
  String fortuneError(String error) {
    return 'Fal yüklenemedi: $error';
  }

  @override
  String get fortuneSaju => 'Dört Direk';

  @override
  String get fortuneSajuPrompt =>
      'Dört Direk\'i görmek için Ayarlar\'a doğum tarihinizi girin.';

  @override
  String get fortuneToday => 'Bugün';

  @override
  String fortuneLunarDate(int month, int day) {
    return 'Ay takvimi $month/$day';
  }

  @override
  String get fortuneYearSuffix => 'Yıl';

  @override
  String get fortuneMonthSuffix => 'Ay';

  @override
  String get fortuneDaySuffix => 'Gün';

  @override
  String fortuneSolarTerm(String term) {
    return 'Mevsim: $term';
  }

  @override
  String get familyTitle => 'Aile Yıl Dönümleri';

  @override
  String get familyEmpty => 'Kayıtlı yıl dönümü yok';

  @override
  String get familyAddButton => 'Yıl Dönümü Ekle';

  @override
  String get familyToday => 'Bugün 🎉';

  @override
  String familyDDaySoon(int diff, String lunarDate) {
    return 'D-$diff  $lunarDate';
  }

  @override
  String familyDDay(int diff, String lunarDate) {
    return '$lunarDate (D-$diff)';
  }

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsBirthDate => 'Doğum Tarihi';

  @override
  String settingsBirthYear(int year) {
    return '$year';
  }

  @override
  String settingsBirthMonth(int month) {
    return '$month';
  }

  @override
  String settingsBirthDay(int day) {
    return '$day';
  }

  @override
  String settingsBirthHour(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsRegisterBirthday => 'Doğum Gününü Google Takvim\'e Ekle';

  @override
  String get settingsSignOut => 'Çıkış Yap';

  @override
  String get settingsBirthdayDialogTitle => 'Doğum Günümü Kaydet';

  @override
  String settingsBirthdayDialogBody(int month, int day) {
    return 'Ay takvimi doğum gününü ($month/$day) Google Takvim\'e 20 yıl eklensin mi?';
  }

  @override
  String settingsBirthdayRegistered(int count) {
    return '$count doğum günü etkinliği kaydedildi!';
  }

  @override
  String get settingsBirthdayNone =>
      'Doğum tarihi bulunamadı. Lütfen giriş sırasında girin.';

  @override
  String get settingsLegalTitle => 'Bilgi ve Yasal Uyarılar';

  @override
  String get settingsPrivacy => 'Gizlilik Politikası';

  @override
  String get settingsPrivacyBody =>
      'Bu uygulama Google Sign-In aracılığıyla adınızı ve e-postanızı toplar, doğum tarihinizi Firestore\'da saklar. Bilgiler yalnızca fal ve Dört Direk hesaplamaları için kullanılır, üçüncü taraflarla paylaşılmaz.';

  @override
  String get settingsCalendarPermission => 'Google Takvim İzni';

  @override
  String get settingsCalendarPermissionBody =>
      'Takvim senkronizasyonu kullanılırken Google Takvim okuma/yazma izni istenir. Bu izin yalnızca etkinlikleri görüntülemek ve ay takvimi doğum günlerini kaydetmek için kullanılır.';

  @override
  String get settingsNotificationPermission => 'Bildirim İzni';

  @override
  String get settingsNotificationPermissionBody =>
      'Yıl dönümlerini hatırlatmak için yerel bildirimler kullanılır (7 gün, 3 gün önce ve günü). Bildirimler yalnızca cihazda işlenir, harici sunuculara gönderilmez.';

  @override
  String get settingsAI => 'AI Fal (Gemini)';

  @override
  String get settingsAIBody =>
      'Günlük fal Google Gemini API ile oluşturulur. Oluşturma sırasında Dört Direk bilgileri gönderilebilir. Günlük 1.200 aşımında yerel fala geçer.';

  @override
  String get settingsAdMob => 'Reklamlar (AdMob)';

  @override
  String get settingsAdMobBody =>
      'Bu uygulama Google AdMob aracılığıyla reklam gösterir. AdMob, reklam optimizasyonu için cihaz tanımlayıcıları toplayabilir. Ayrıntılar için Google Gizlilik Politikası\'na bakın.';

  @override
  String settingsVersion(String version) {
    return 'Sürüm $version  ·  © 2026 Gridnflow';
  }

  @override
  String get onboardingTitle => 'Doğum tarihinizi söyleyin';

  @override
  String get onboardingSubtitle =>
      'Fal ve Dört Direk için kullanılır.\nDaha sonra Ayarlar\'dan değiştirebilirsiniz.';

  @override
  String get onboardingSolar => 'Miladi Takvim';

  @override
  String get onboardingLunar => 'Ay Takvimi';

  @override
  String get onboardingSolarHint => 'Miladi tarih girin (örn: 20 Nisan 1990)';

  @override
  String get onboardingLunarHint => 'Ay takvimi tarihi girin (örn: Lunar 15/3)';

  @override
  String get onboardingYear => 'Yıl';

  @override
  String get onboardingMonth => 'Ay';

  @override
  String get onboardingDay => 'Gün';

  @override
  String get onboardingHour => 'Doğum saati (isteğe bağlı, 0–23)';

  @override
  String get onboardingStart => 'Başla';

  @override
  String get onboardingSkip => 'Sonra gireceğim';

  @override
  String get onboardingRequired => 'Zorunlu';

  @override
  String onboardingRange(int min, int max) {
    return '$min–$max';
  }

  @override
  String get loginTitle => 'Devam etmek için giriş yapın';

  @override
  String get loginGoogle => 'Google ile devam et';

  @override
  String get languageSelect => 'Dil Seçin';

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
