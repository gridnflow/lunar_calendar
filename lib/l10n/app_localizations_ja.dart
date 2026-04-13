// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '旧暦カレンダー';

  @override
  String get navCalendar => 'カレンダー';

  @override
  String get navFortune => '運勢';

  @override
  String get navFamily => '家族';

  @override
  String get navSettings => '設定';

  @override
  String get calendarTitle => 'カレンダー';

  @override
  String get calendarNoEvents => 'この日の予定はありません';

  @override
  String get calendarConnectRequired => 'Google カレンダーの接続が必要です';

  @override
  String get calendarRetry => '再試行';

  @override
  String get calendarAddAnniversary => '記念日を追加';

  @override
  String get calendarAnniversaryList => '記念日リスト';

  @override
  String get anniversaryAdd => '記念日を追加';

  @override
  String get anniversaryName => '名前（例：祖母の法事）';

  @override
  String get anniversaryType_jesa => '法事';

  @override
  String get anniversaryType_birthday => '誕生日';

  @override
  String get anniversaryType_other => 'その他';

  @override
  String get anniversaryLunarHint =>
      '日付は旧暦で入力してください。\n例）旧暦誕生日が3月15日なら3月・15日を選択';

  @override
  String get anniversaryLunarMonth => '旧暦 月';

  @override
  String get anniversaryLunarDay => '旧暦 日';

  @override
  String get anniversaryLeapMonth => '閏月';

  @override
  String get anniversaryCancel => 'キャンセル';

  @override
  String get anniversarySave => '保存';

  @override
  String get anniversaryDelete => '記念日を削除';

  @override
  String anniversaryDeleteConfirm(String name) {
    return '「$name」を削除しますか？';
  }

  @override
  String anniversaryAdded(String name) {
    return '$name を追加しました';
  }

  @override
  String anniversaryDeleted(String name) {
    return '「$name」を削除しました';
  }

  @override
  String get anniversaryEmpty => '登録された記念日はありません';

  @override
  String get anniversaryListTitle => '記念日リスト';

  @override
  String get anniversaryClose => '閉じる';

  @override
  String get fortuneTitle => '今日の運勢';

  @override
  String get fortuneLoading => '運勢を読み込んでいます...';

  @override
  String fortuneError(String error) {
    return '運勢を読み込めません: $error';
  }

  @override
  String get fortuneSaju => '四柱推命';

  @override
  String get fortuneSajuPrompt => '設定で生年月日を入力すると四柱推命が表示されます。';

  @override
  String get fortuneToday => '今日';

  @override
  String fortuneLunarDate(int month, int day) {
    return '旧暦$month月$day日';
  }

  @override
  String get fortuneYearSuffix => '年';

  @override
  String get fortuneMonthSuffix => '月';

  @override
  String get fortuneDaySuffix => '日';

  @override
  String fortuneSolarTerm(String term) {
    return '節気: $term';
  }

  @override
  String get familyTitle => '家族の記念日';

  @override
  String get familyEmpty => '登録された記念日はありません';

  @override
  String get familyAddButton => '記念日を追加';

  @override
  String get familyToday => '今日 🎉';

  @override
  String familyDDaySoon(int diff, String lunarDate) {
    return 'D-$diff  $lunarDate';
  }

  @override
  String familyDDay(int diff, String lunarDate) {
    return '$lunarDate (D-$diff)';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsBirthDate => '生年月日';

  @override
  String settingsBirthYear(int year) {
    return '$year年';
  }

  @override
  String settingsBirthMonth(int month) {
    return '$month月';
  }

  @override
  String settingsBirthDay(int day) {
    return '$day日';
  }

  @override
  String settingsBirthHour(int hour) {
    return '$hour時';
  }

  @override
  String get settingsRegisterBirthday => '誕生日を Google カレンダーに登録';

  @override
  String get settingsSignOut => 'サインアウト';

  @override
  String get settingsBirthdayDialogTitle => '誕生日を登録';

  @override
  String settingsBirthdayDialogBody(int month, int day) {
    return '旧暦誕生日（$month月$day日）を\nGoogle カレンダーに20年分登録しますか？';
  }

  @override
  String settingsBirthdayRegistered(int count) {
    return '$count件の誕生日を登録しました！';
  }

  @override
  String get settingsBirthdayNone => '生年月日が登録されていません。オンボーディングで入力してください。';

  @override
  String get settingsLegalTitle => '情報・法的通知';

  @override
  String get settingsPrivacy => 'プライバシーポリシー';

  @override
  String get settingsPrivacyBody =>
      '本アプリはGoogleログインを通じて氏名・メールアドレスを取得し、入力された生年月日をFirestoreに保存します。収集した情報は運勢・四柱推命の計算にのみ使用し、第三者に提供しません。';

  @override
  String get settingsCalendarPermission => 'Google カレンダー権限';

  @override
  String get settingsCalendarPermissionBody =>
      'カレンダー連携機能の使用時に読み取り/書き込み権限を要求します。この権限は予定の閲覧と旧暦誕生日の登録にのみ使用されます。';

  @override
  String get settingsNotificationPermission => '通知権限';

  @override
  String get settingsNotificationPermissionBody =>
      '記念日の事前通知（7日前・3日前・当日）のためにローカル通知を使用します。通知は端末内でのみ処理され、外部サーバーには送信されません。';

  @override
  String get settingsAI => 'AI 運勢（Gemini）';

  @override
  String get settingsAIBody =>
      '今日の運勢はGoogle Gemini APIで生成されます。生成時に四柱情報が送信される場合があります。1日1,200回超過時はローカル運勢に切り替わります。';

  @override
  String get settingsAdMob => '広告（AdMob）';

  @override
  String get settingsAdMobBody =>
      '本アプリはGoogle AdMobを通じて広告を表示します。AdMobは広告最適化のためデバイス識別子等の情報を収集することがあります。詳細はGoogleのプライバシーポリシーをご参照ください。';

  @override
  String settingsVersion(String version) {
    return 'Version $version  ·  © 2026 Gridnflow';
  }

  @override
  String get onboardingTitle => '生年月日を教えてください';

  @override
  String get onboardingSubtitle => '運勢・四柱推命に活用されます。\n後で設定から変更できます。';

  @override
  String get onboardingSolar => '新暦（陽暦）';

  @override
  String get onboardingLunar => '旧暦（陰暦）';

  @override
  String get onboardingSolarHint => '新暦で入力してください（例：1990年4月20日）';

  @override
  String get onboardingLunarHint => '旧暦で入力してください（例：旧暦3月15日）';

  @override
  String get onboardingYear => '年';

  @override
  String get onboardingMonth => '月';

  @override
  String get onboardingDay => '日';

  @override
  String get onboardingHour => '生まれた時間（任意、0〜23）';

  @override
  String get onboardingStart => '始める';

  @override
  String get onboardingSkip => '後で入力する';

  @override
  String get onboardingRequired => '必須';

  @override
  String onboardingRange(int min, int max) {
    return '$min〜$max';
  }

  @override
  String get loginTitle => 'ログインして始めましょう';

  @override
  String get loginGoogle => 'Googleで続ける';

  @override
  String get languageSelect => '言語を選択';

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
