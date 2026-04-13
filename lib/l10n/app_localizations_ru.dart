// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Лунный календарь';

  @override
  String get navCalendar => 'Календарь';

  @override
  String get navFortune => 'Гороскоп';

  @override
  String get navFamily => 'Семья';

  @override
  String get navSettings => 'Настройки';

  @override
  String get calendarTitle => 'Календарь';

  @override
  String get calendarNoEvents => 'Событий на этот день нет';

  @override
  String get calendarConnectRequired =>
      'Требуется подключение Google Календаря';

  @override
  String get calendarRetry => 'Повторить';

  @override
  String get calendarAddAnniversary => 'Добавить дату';

  @override
  String get calendarAnniversaryList => 'Список дат';

  @override
  String get anniversaryAdd => 'Добавить дату';

  @override
  String get anniversaryName => 'Название (например: Поминки бабушки)';

  @override
  String get anniversaryType_jesa => 'Поминки';

  @override
  String get anniversaryType_birthday => 'День рождения';

  @override
  String get anniversaryType_other => 'Другое';

  @override
  String get anniversaryLunarHint =>
      'Введите дату по лунному календарю.\nПример: Лунный ДР 15/3 → выберите месяц 3, день 15';

  @override
  String get anniversaryLunarMonth => 'Лунный месяц';

  @override
  String get anniversaryLunarDay => 'Лунный день';

  @override
  String get anniversaryLeapMonth => 'Високосный месяц';

  @override
  String get anniversaryCancel => 'Отмена';

  @override
  String get anniversarySave => 'Сохранить';

  @override
  String get anniversaryDelete => 'Удалить дату';

  @override
  String anniversaryDeleteConfirm(String name) {
    return 'Удалить \"$name\"?';
  }

  @override
  String anniversaryAdded(String name) {
    return '$name добавлен(а)';
  }

  @override
  String anniversaryDeleted(String name) {
    return '\"$name\" удалён(а)';
  }

  @override
  String get anniversaryEmpty => 'Нет зарегистрированных дат';

  @override
  String get anniversaryListTitle => 'Список дат';

  @override
  String get anniversaryClose => 'Закрыть';

  @override
  String get fortuneTitle => 'Гороскоп на сегодня';

  @override
  String get fortuneLoading => 'Загрузка гороскопа...';

  @override
  String fortuneError(String error) {
    return 'Не удалось загрузить гороскоп: $error';
  }

  @override
  String get fortuneSaju => 'Четыре столпа судьбы';

  @override
  String get fortuneSajuPrompt =>
      'Введите дату рождения в Настройках, чтобы увидеть Четыре столпа.';

  @override
  String get fortuneToday => 'Сегодня';

  @override
  String fortuneLunarDate(int month, int day) {
    return 'Лун. кал. $month/$day';
  }

  @override
  String get fortuneYearSuffix => 'Год';

  @override
  String get fortuneMonthSuffix => 'Мес.';

  @override
  String get fortuneDaySuffix => 'День';

  @override
  String fortuneSolarTerm(String term) {
    return 'Сезон: $term';
  }

  @override
  String get familyTitle => 'Семейные даты';

  @override
  String get familyEmpty => 'Нет зарегистрированных дат';

  @override
  String get familyAddButton => 'Добавить дату';

  @override
  String get familyToday => 'Сегодня 🎉';

  @override
  String familyDDaySoon(int diff, String lunarDate) {
    return 'D-$diff  $lunarDate';
  }

  @override
  String familyDDay(int diff, String lunarDate) {
    return '$lunarDate (D-$diff)';
  }

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsBirthDate => 'Дата рождения';

  @override
  String get settingsRegisterBirthday =>
      'Добавить день рождения в Google Календарь';

  @override
  String get settingsSignOut => 'Выйти';

  @override
  String get settingsBirthdayDialogTitle => 'Зарегистрировать день рождения';

  @override
  String settingsBirthdayDialogBody(int month, int day) {
    return 'Добавить лунный день рождения ($month/$day) в Google Календарь на 20 лет?';
  }

  @override
  String settingsBirthdayRegistered(int count) {
    return 'Зарегистрировано $count событий!';
  }

  @override
  String get settingsBirthdayNone =>
      'Дата рождения не найдена. Пожалуйста, введите её при первом запуске.';

  @override
  String get settingsLegalTitle => 'Информация и правовые уведомления';

  @override
  String get settingsPrivacy => 'Политика конфиденциальности';

  @override
  String get settingsPrivacyBody =>
      'Приложение собирает имя и email через Google Sign-In и сохраняет дату рождения в Firestore. Данные используются только для расчёта гороскопа и четырёх столпов, третьим лицам не передаются.';

  @override
  String get settingsCalendarPermission => 'Разрешение Google Календаря';

  @override
  String get settingsCalendarPermissionBody =>
      'При синхронизации запрашивается доступ на чтение/запись Google Календаря. Разрешение используется только для просмотра событий и регистрации лунных дней рождения.';

  @override
  String get settingsNotificationPermission => 'Разрешение на уведомления';

  @override
  String get settingsNotificationPermissionBody =>
      'Локальные уведомления напоминают о датах (за 7 дней, 3 дня и в сам день). Уведомления обрабатываются только на устройстве и не отправляются на внешние серверы.';

  @override
  String get settingsAI => 'ИИ-гороскоп (Gemini)';

  @override
  String get settingsAIBody =>
      'Ежедневный гороскоп создаётся с помощью Google Gemini API. При генерации могут передаваться данные четырёх столпов. После 1200 запросов в день переключается на локальный гороскоп.';

  @override
  String get settingsAdMob => 'Реклама (AdMob)';

  @override
  String get settingsAdMobBody =>
      'Приложение показывает рекламу через Google AdMob. AdMob может собирать идентификаторы устройств для оптимизации рекламы. Подробнее — в Политике конфиденциальности Google.';

  @override
  String settingsVersion(String version) {
    return 'Версия $version  ·  © 2026 Gridnflow';
  }

  @override
  String get onboardingTitle => 'Укажите дату рождения';

  @override
  String get onboardingSubtitle =>
      'Используется для гороскопа и четырёх столпов.\nМожно изменить позже в Настройках.';

  @override
  String get onboardingSolar => 'Григорианский календарь';

  @override
  String get onboardingLunar => 'Лунный календарь';

  @override
  String get onboardingSolarHint =>
      'Введите дату по григорианскому календарю (например: 20 апреля 1990)';

  @override
  String get onboardingLunarHint =>
      'Введите дату по лунному календарю (например: лунный 15/3)';

  @override
  String get onboardingYear => 'Год';

  @override
  String get onboardingMonth => 'Месяц';

  @override
  String get onboardingDay => 'День';

  @override
  String get onboardingHour => 'Час рождения (необязательно, 0–23)';

  @override
  String get onboardingStart => 'Начать';

  @override
  String get onboardingSkip => 'Ввести позже';

  @override
  String get onboardingRequired => 'Обязательно';

  @override
  String onboardingRange(int min, int max) {
    return '$min–$max';
  }

  @override
  String get loginTitle => 'Войдите, чтобы продолжить';

  @override
  String get loginGoogle => 'Продолжить с Google';

  @override
  String get languageSelect => 'Выберите язык';

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
