// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '农历日历';

  @override
  String get navCalendar => '日历';

  @override
  String get navFortune => '运势';

  @override
  String get navFamily => '家人';

  @override
  String get navSettings => '设置';

  @override
  String get calendarTitle => '日历';

  @override
  String get calendarNoEvents => '当天没有日程';

  @override
  String get calendarConnectRequired => '需要连接 Google 日历';

  @override
  String get calendarRetry => '重试';

  @override
  String get calendarAddAnniversary => '添加纪念日';

  @override
  String get calendarAnniversaryList => '纪念日列表';

  @override
  String get anniversaryAdd => '添加纪念日';

  @override
  String get anniversaryName => '名称（例：祖母忌日）';

  @override
  String get anniversaryType_jesa => '祭祀';

  @override
  String get anniversaryType_birthday => '生日';

  @override
  String get anniversaryType_other => '其他';

  @override
  String get anniversaryLunarHint => '请按农历输入日期。\n例）农历生日3月15日→选择3月15日';

  @override
  String get anniversaryLunarMonth => '农历月';

  @override
  String get anniversaryLunarDay => '农历日';

  @override
  String get anniversaryLeapMonth => '闰月';

  @override
  String get anniversaryCancel => '取消';

  @override
  String get anniversarySave => '保存';

  @override
  String get anniversaryDelete => '删除纪念日';

  @override
  String anniversaryDeleteConfirm(String name) {
    return '确定删除\"$name\"？';
  }

  @override
  String anniversaryAdded(String name) {
    return '已添加 $name';
  }

  @override
  String anniversaryDeleted(String name) {
    return '已删除\"$name\"';
  }

  @override
  String get anniversaryEmpty => '暂无纪念日';

  @override
  String get anniversaryListTitle => '纪念日列表';

  @override
  String get anniversaryClose => '关闭';

  @override
  String get fortuneTitle => '今日运势';

  @override
  String get fortuneLoading => '正在加载运势...';

  @override
  String fortuneError(String error) {
    return '无法加载运势: $error';
  }

  @override
  String get fortuneSaju => '四柱八字';

  @override
  String get fortuneSajuPrompt => '在设置中输入生日即可查看四柱八字。';

  @override
  String get fortuneToday => '今天';

  @override
  String fortuneLunarDate(int month, int day) {
    return '农历$month月$day日';
  }

  @override
  String get fortuneYearSuffix => '年';

  @override
  String get fortuneMonthSuffix => '月';

  @override
  String get fortuneDaySuffix => '日';

  @override
  String fortuneSolarTerm(String term) {
    return '节气: $term';
  }

  @override
  String get familyTitle => '家人纪念日';

  @override
  String get familyEmpty => '暂无纪念日';

  @override
  String get familyAddButton => '添加纪念日';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsBirthDate => '生日';

  @override
  String get settingsRegisterBirthday => '将生日注册到 Google 日历';

  @override
  String get settingsSignOut => '退出登录';

  @override
  String get settingsBirthdayDialogTitle => '注册我的生日';

  @override
  String settingsBirthdayDialogBody(int month, int day) {
    return '将农历生日（$month月$day日）注册到 Google 日历20年？';
  }

  @override
  String settingsBirthdayRegistered(int count) {
    return '已注册 $count 个生日日程！';
  }

  @override
  String get settingsBirthdayNone => '未找到生日信息，请在引导页输入。';

  @override
  String get settingsLegalTitle => '信息与法律声明';

  @override
  String get settingsPrivacy => '隐私政策';

  @override
  String get settingsPrivacyBody =>
      '本应用通过Google登录收集姓名和邮箱，并将生日存储在Firestore中。所收集信息仅用于运势和四柱八字计算，不会提供给第三方。';

  @override
  String get settingsCalendarPermission => 'Google 日历权限';

  @override
  String get settingsCalendarPermissionBody =>
      '使用日历同步功能时，将请求Google日历的读写权限。该权限仅用于查看日程和注册农历生日。';

  @override
  String get settingsNotificationPermission => '通知权限';

  @override
  String get settingsNotificationPermissionBody =>
      '使用本地通知提醒纪念日（提前7天、3天及当天）。通知仅在设备本地处理，不会发送到外部服务器。';

  @override
  String get settingsAI => 'AI 运势（Gemini）';

  @override
  String get settingsAIBody =>
      '今日运势由Google Gemini API生成。生成时可能会发送四柱信息。每日超过1200次后将切换为本地运势。';

  @override
  String get settingsAdMob => '广告（AdMob）';

  @override
  String get settingsAdMobBody =>
      '本应用通过Google AdMob展示广告。AdMob可能收集设备标识符等信息用于广告优化。详情请参阅Google隐私政策。';

  @override
  String settingsVersion(String version) {
    return 'Version $version  ·  © 2026 Gridnflow';
  }

  @override
  String get onboardingTitle => '请告诉我们您的生日';

  @override
  String get onboardingSubtitle => '用于运势和四柱八字计算。\n之后可在设置中修改。';

  @override
  String get onboardingSolar => '阳历生日';

  @override
  String get onboardingLunar => '农历生日';

  @override
  String get onboardingSolarHint => '请输入阳历日期（例：1990年4月20日）';

  @override
  String get onboardingLunarHint => '请输入农历日期（例：农历3月15日）';

  @override
  String get onboardingYear => '年';

  @override
  String get onboardingMonth => '月';

  @override
  String get onboardingDay => '日';

  @override
  String get onboardingHour => '出生时辰（可选，0–23）';

  @override
  String get onboardingStart => '开始';

  @override
  String get onboardingSkip => '稍后输入';

  @override
  String get onboardingRequired => '必填';

  @override
  String onboardingRange(int min, int max) {
    return '$min–$max';
  }

  @override
  String get loginTitle => '登录后开始';

  @override
  String get loginGoogle => '使用 Google 继续';

  @override
  String get languageSelect => '选择语言';

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

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => '農曆日曆';

  @override
  String get navCalendar => '日曆';

  @override
  String get navFortune => '運勢';

  @override
  String get navFamily => '家人';

  @override
  String get navSettings => '設定';

  @override
  String get calendarTitle => '日曆';

  @override
  String get calendarNoEvents => '當天沒有行程';

  @override
  String get calendarConnectRequired => '需要連接 Google 日曆';

  @override
  String get calendarRetry => '重試';

  @override
  String get calendarAddAnniversary => '新增紀念日';

  @override
  String get calendarAnniversaryList => '紀念日清單';

  @override
  String get anniversaryAdd => '新增紀念日';

  @override
  String get anniversaryName => '名稱（例：祖母忌日）';

  @override
  String get anniversaryType_jesa => '祭祀';

  @override
  String get anniversaryType_birthday => '生日';

  @override
  String get anniversaryType_other => '其他';

  @override
  String get anniversaryLunarHint => '請以農曆輸入日期。\n例）農曆生日3月15日→選擇3月15日';

  @override
  String get anniversaryLunarMonth => '農曆月';

  @override
  String get anniversaryLunarDay => '農曆日';

  @override
  String get anniversaryLeapMonth => '閏月';

  @override
  String get anniversaryCancel => '取消';

  @override
  String get anniversarySave => '儲存';

  @override
  String get anniversaryDelete => '刪除紀念日';

  @override
  String anniversaryDeleteConfirm(String name) {
    return '確定刪除「$name」？';
  }

  @override
  String anniversaryAdded(String name) {
    return '已新增 $name';
  }

  @override
  String anniversaryDeleted(String name) {
    return '已刪除「$name」';
  }

  @override
  String get anniversaryEmpty => '尚無紀念日';

  @override
  String get anniversaryListTitle => '紀念日清單';

  @override
  String get anniversaryClose => '關閉';

  @override
  String get fortuneTitle => '今日運勢';

  @override
  String get fortuneLoading => '正在載入運勢...';

  @override
  String fortuneError(String error) {
    return '無法載入運勢: $error';
  }

  @override
  String get fortuneSaju => '四柱八字';

  @override
  String get fortuneSajuPrompt => '在設定中輸入生日即可查看四柱八字。';

  @override
  String get fortuneToday => '今天';

  @override
  String fortuneLunarDate(int month, int day) {
    return '農曆$month月$day日';
  }

  @override
  String get fortuneYearSuffix => '年';

  @override
  String get fortuneMonthSuffix => '月';

  @override
  String get fortuneDaySuffix => '日';

  @override
  String fortuneSolarTerm(String term) {
    return '節氣: $term';
  }

  @override
  String get familyTitle => '家人紀念日';

  @override
  String get familyEmpty => '尚無紀念日';

  @override
  String get familyAddButton => '新增紀念日';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsBirthDate => '生日';

  @override
  String get settingsRegisterBirthday => '將生日註冊到 Google 日曆';

  @override
  String get settingsSignOut => '登出';

  @override
  String get settingsBirthdayDialogTitle => '註冊我的生日';

  @override
  String settingsBirthdayDialogBody(int month, int day) {
    return '將農曆生日（$month月$day日）註冊到 Google 日曆20年？';
  }

  @override
  String settingsBirthdayRegistered(int count) {
    return '已註冊 $count 個生日行程！';
  }

  @override
  String get settingsBirthdayNone => '未找到生日資訊，請在引導頁輸入。';

  @override
  String get settingsLegalTitle => '資訊與法律聲明';

  @override
  String get settingsPrivacy => '隱私權政策';

  @override
  String get settingsPrivacyBody =>
      '本應用透過Google登入收集姓名和電子郵件，並將生日儲存在Firestore中。所收集資訊僅用於運勢和四柱八字計算，不會提供給第三方。';

  @override
  String get settingsCalendarPermission => 'Google 日曆權限';

  @override
  String get settingsCalendarPermissionBody =>
      '使用日曆同步功能時，將請求Google日曆的讀寫權限。該權限僅用於查看行程和註冊農曆生日。';

  @override
  String get settingsNotificationPermission => '通知權限';

  @override
  String get settingsNotificationPermissionBody =>
      '使用本機通知提醒紀念日（提前7天、3天及當天）。通知僅在裝置本機處理，不會傳送至外部伺服器。';

  @override
  String get settingsAI => 'AI 運勢（Gemini）';

  @override
  String get settingsAIBody =>
      '今日運勢由Google Gemini API生成。生成時可能會傳送四柱資訊。每日超過1200次後將切換為本機運勢。';

  @override
  String get settingsAdMob => '廣告（AdMob）';

  @override
  String get settingsAdMobBody =>
      '本應用透過Google AdMob展示廣告。AdMob可能收集裝置識別碼等資訊用於廣告最佳化。詳情請參閱Google隱私權政策。';

  @override
  String settingsVersion(String version) {
    return 'Version $version  ·  © 2026 Gridnflow';
  }

  @override
  String get onboardingTitle => '請告訴我們您的生日';

  @override
  String get onboardingSubtitle => '用於運勢和四柱八字計算。\n之後可在設定中修改。';

  @override
  String get onboardingSolar => '陽曆生日';

  @override
  String get onboardingLunar => '農曆生日';

  @override
  String get onboardingSolarHint => '請輸入陽曆日期（例：1990年4月20日）';

  @override
  String get onboardingLunarHint => '請輸入農曆日期（例：農曆3月15日）';

  @override
  String get onboardingYear => '年';

  @override
  String get onboardingMonth => '月';

  @override
  String get onboardingDay => '日';

  @override
  String get onboardingHour => '出生時辰（選填，0–23）';

  @override
  String get onboardingStart => '開始';

  @override
  String get onboardingSkip => '稍後輸入';

  @override
  String get onboardingRequired => '必填';

  @override
  String onboardingRange(int min, int max) {
    return '$min–$max';
  }

  @override
  String get loginTitle => '登入後開始';

  @override
  String get loginGoogle => '使用 Google 繼續';

  @override
  String get languageSelect => '選擇語言';

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
