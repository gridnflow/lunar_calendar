// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '음력 달력';

  @override
  String get navCalendar => '달력';

  @override
  String get navFortune => '운세';

  @override
  String get navFamily => '가족';

  @override
  String get navSettings => '설정';

  @override
  String get calendarTitle => '달력';

  @override
  String get calendarNoEvents => '이 날의 일정이 없습니다';

  @override
  String get calendarConnectRequired => 'Google Calendar 연결 필요';

  @override
  String get calendarRetry => '재시도';

  @override
  String get calendarAddAnniversary => '기념일 추가';

  @override
  String get calendarAnniversaryList => '기념일 목록';

  @override
  String get anniversaryAdd => '기념일 추가';

  @override
  String get anniversaryName => '이름 (예: 할아버지 제사)';

  @override
  String get anniversaryType_jesa => '제사';

  @override
  String get anniversaryType_birthday => '생일';

  @override
  String get anniversaryType_other => '기타';

  @override
  String get anniversaryLunarHint =>
      '날짜는 음력으로 입력해주세요.\n예) 음력 생일이 3월 15일이면 3월, 15일 선택';

  @override
  String get anniversaryLunarMonth => '음력 월';

  @override
  String get anniversaryLunarDay => '음력 일';

  @override
  String get anniversaryLeapMonth => '윤달';

  @override
  String get anniversaryCancel => '취소';

  @override
  String get anniversarySave => '저장';

  @override
  String get anniversaryDelete => '기념일 삭제';

  @override
  String anniversaryDeleteConfirm(String name) {
    return '\"$name\"을 삭제할까요?';
  }

  @override
  String anniversaryAdded(String name) {
    return '$name 기념일이 추가됐습니다';
  }

  @override
  String anniversaryDeleted(String name) {
    return '\"$name\" 삭제됐습니다';
  }

  @override
  String get anniversaryEmpty => '등록된 기념일이 없습니다';

  @override
  String get anniversaryListTitle => '기념일 목록';

  @override
  String get anniversaryClose => '닫기';

  @override
  String get fortuneTitle => '오늘의 운세';

  @override
  String get fortuneLoading => '운세를 불러오는 중...';

  @override
  String fortuneError(String error) {
    return '운세를 불러올 수 없습니다: $error';
  }

  @override
  String get fortuneSaju => '사주 (四柱)';

  @override
  String get fortuneSajuPrompt => 'Settings에서 생년월일을 입력하면 사주를 볼 수 있습니다.';

  @override
  String get fortuneToday => '오늘';

  @override
  String fortuneLunarDate(int month, int day) {
    return '음력 $month월 $day일';
  }

  @override
  String get fortuneYearSuffix => '년';

  @override
  String get fortuneMonthSuffix => '월';

  @override
  String get fortuneDaySuffix => '일';

  @override
  String fortuneSolarTerm(String term) {
    return '절기: $term';
  }

  @override
  String get familyTitle => '가족 기념일';

  @override
  String get familyEmpty => '등록된 기념일이 없습니다';

  @override
  String generalError(String error) {
    return '오류: $error';
  }

  @override
  String get familyAddButton => '기념일 추가';

  @override
  String get familyToday => '오늘 🎉';

  @override
  String familyDDaySoon(int diff, String lunarDate) {
    return 'D-$diff  $lunarDate';
  }

  @override
  String familyDDay(int diff, String lunarDate) {
    return '$lunarDate (D-$diff)';
  }

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsBirthDate => '생년월일';

  @override
  String settingsBirthYear(int year) {
    return '$year년';
  }

  @override
  String settingsBirthMonth(int month) {
    return '$month월';
  }

  @override
  String settingsBirthDay(int day) {
    return '$day일';
  }

  @override
  String settingsBirthHour(int hour) {
    return '$hour시';
  }

  @override
  String get settingsRegisterBirthday => '내 생일 Google Calendar에 등록';

  @override
  String get settingsSignOut => 'Sign Out';

  @override
  String get settingsBirthdayDialogTitle => '내 생일 등록';

  @override
  String settingsBirthdayDialogBody(int month, int day) {
    return '음력 생일 ($month월 $day일)을\nGoogle Calendar에 20년치 등록할까요?';
  }

  @override
  String settingsBirthdayRegistered(int count) {
    return '$count개 생일 일정이 등록됐습니다!';
  }

  @override
  String get settingsBirthdayNone => '생일 정보가 없습니다. 온보딩에서 입력해주세요.';

  @override
  String get settingsLegalTitle => '정보 및 법적 고지';

  @override
  String get settingsPrivacy => '개인정보 처리방침';

  @override
  String get settingsPrivacyBody =>
      '본 앱은 Google 로그인을 통해 이름, 이메일 주소를 수집하며, 사용자가 입력한 생년월일을 Firestore에 저장합니다. 수집된 정보는 오늘의 운세 및 사주 계산에만 활용되며, 제3자에게 제공되지 않습니다.';

  @override
  String get settingsCalendarPermission => 'Google Calendar 권한';

  @override
  String get settingsCalendarPermissionBody =>
      '캘린더 연동 기능 사용 시 Google Calendar 읽기/쓰기 권한을 요청합니다. 해당 권한은 일정 조회 및 음력 생일 등록에만 사용됩니다.';

  @override
  String get settingsNotificationPermission => '알림 권한';

  @override
  String get settingsNotificationPermissionBody =>
      '기념일 사전 알림(7일 전, 3일 전, 당일)을 위해 로컬 알림 권한을 사용합니다. 알림은 기기 내에서만 처리되며 외부 서버로 전송되지 않습니다.';

  @override
  String get settingsAI => 'AI 운세 (Gemini)';

  @override
  String get settingsAIBody =>
      '오늘의 운세는 Google Gemini API를 통해 생성됩니다. 운세 생성 시 일주·월주·년주 및 사주 정보가 전송될 수 있습니다. 하루 1,200회 초과 시 로컬 운세로 대체됩니다.';

  @override
  String get settingsAdMob => '광고 (AdMob)';

  @override
  String get settingsAdMobBody =>
      '본 앱은 Google AdMob을 통해 광고를 표시합니다. AdMob은 광고 최적화를 위해 기기 식별자 등의 정보를 수집할 수 있습니다. 자세한 내용은 Google 개인정보처리방침을 참조하세요.';

  @override
  String settingsVersion(String version) {
    return 'Version $version  ·  © 2026 Gridnflow';
  }

  @override
  String get onboardingTitle => '생년월일을 알려주세요';

  @override
  String get onboardingSubtitle =>
      '사주와 오늘의 운세에 활용됩니다.\n나중에 Settings에서 변경할 수 있어요.';

  @override
  String get onboardingSolar => '양력 생일';

  @override
  String get onboardingLunar => '음력 생일';

  @override
  String get onboardingSolarHint => '양력 날짜를 입력하세요 (예: 1990년 4월 20일)';

  @override
  String get onboardingLunarHint => '음력 날짜를 입력하세요 (예: 음력 3월 15일)';

  @override
  String get onboardingYear => '년';

  @override
  String get onboardingMonth => '월';

  @override
  String get onboardingDay => '일';

  @override
  String get onboardingHour => '태어난 시간 (선택, 0–23)';

  @override
  String get onboardingStart => '시작하기';

  @override
  String get onboardingSkip => '나중에 입력할게요';

  @override
  String get onboardingRequired => '필수';

  @override
  String onboardingRange(int min, int max) {
    return '$min–$max';
  }

  @override
  String get loginTitle => '로그인하여 시작하세요';

  @override
  String get loginGoogle => 'Google로 계속하기';

  @override
  String get languageSelect => '언어 선택';

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
