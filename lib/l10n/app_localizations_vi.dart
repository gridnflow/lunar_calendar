// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Lịch Âm';

  @override
  String get navCalendar => 'Lịch';

  @override
  String get navFortune => 'Tử vi';

  @override
  String get navFamily => 'Gia đình';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get calendarTitle => 'Lịch';

  @override
  String get calendarNoEvents => 'Không có sự kiện trong ngày này';

  @override
  String get calendarConnectRequired => 'Cần kết nối Google Calendar';

  @override
  String get calendarRetry => 'Thử lại';

  @override
  String get calendarAddAnniversary => 'Thêm ngày kỷ niệm';

  @override
  String get calendarAnniversaryList => 'Danh sách kỷ niệm';

  @override
  String get anniversaryAdd => 'Thêm ngày kỷ niệm';

  @override
  String get anniversaryName => 'Tên (ví dụ: Giỗ bà nội)';

  @override
  String get anniversaryType_jesa => 'Giỗ';

  @override
  String get anniversaryType_birthday => 'Sinh nhật';

  @override
  String get anniversaryType_other => 'Khác';

  @override
  String get anniversaryLunarHint =>
      'Vui lòng nhập ngày theo âm lịch.\nVD: Sinh nhật âm lịch 15/3 → chọn tháng 3, ngày 15';

  @override
  String get anniversaryLunarMonth => 'Tháng âm lịch';

  @override
  String get anniversaryLunarDay => 'Ngày âm lịch';

  @override
  String get anniversaryLeapMonth => 'Tháng nhuận';

  @override
  String get anniversaryCancel => 'Hủy';

  @override
  String get anniversarySave => 'Lưu';

  @override
  String get anniversaryDelete => 'Xóa kỷ niệm';

  @override
  String anniversaryDeleteConfirm(String name) {
    return 'Xóa \"$name\"?';
  }

  @override
  String anniversaryAdded(String name) {
    return 'Đã thêm $name';
  }

  @override
  String anniversaryDeleted(String name) {
    return 'Đã xóa \"$name\"';
  }

  @override
  String get anniversaryEmpty => 'Chưa có ngày kỷ niệm nào';

  @override
  String get anniversaryListTitle => 'Danh sách kỷ niệm';

  @override
  String get anniversaryClose => 'Đóng';

  @override
  String get fortuneTitle => 'Tử vi hôm nay';

  @override
  String get fortuneLoading => 'Đang tải tử vi...';

  @override
  String fortuneError(String error) {
    return 'Không thể tải tử vi: $error';
  }

  @override
  String get fortuneSaju => 'Tứ trụ';

  @override
  String get fortuneSajuPrompt => 'Nhập ngày sinh trong Cài đặt để xem Tứ trụ.';

  @override
  String get fortuneToday => 'Hôm nay';

  @override
  String fortuneLunarDate(int month, int day) {
    return 'Âm lịch $month/$day';
  }

  @override
  String get fortuneYearSuffix => 'Năm';

  @override
  String get fortuneMonthSuffix => 'Tháng';

  @override
  String get fortuneDaySuffix => 'Ngày';

  @override
  String fortuneSolarTerm(String term) {
    return 'Tiết khí: $term';
  }

  @override
  String get familyTitle => 'Kỷ niệm gia đình';

  @override
  String get familyEmpty => 'Chưa có ngày kỷ niệm nào';

  @override
  String get familyAddButton => 'Thêm kỷ niệm';

  @override
  String get familyToday => 'Hôm nay 🎉';

  @override
  String familyDDaySoon(int diff, String lunarDate) {
    return 'D-$diff  $lunarDate';
  }

  @override
  String familyDDay(int diff, String lunarDate) {
    return '$lunarDate (D-$diff)';
  }

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsBirthDate => 'Ngày sinh';

  @override
  String get settingsRegisterBirthday =>
      'Đăng ký sinh nhật vào Google Calendar';

  @override
  String get settingsSignOut => 'Đăng xuất';

  @override
  String get settingsBirthdayDialogTitle => 'Đăng ký sinh nhật';

  @override
  String settingsBirthdayDialogBody(int month, int day) {
    return 'Đăng ký sinh nhật âm lịch ($month/$day) vào Google Calendar cho 20 năm?';
  }

  @override
  String settingsBirthdayRegistered(int count) {
    return 'Đã đăng ký $count sự kiện sinh nhật!';
  }

  @override
  String get settingsBirthdayNone =>
      'Không tìm thấy ngày sinh. Vui lòng nhập trong quá trình giới thiệu.';

  @override
  String get settingsLegalTitle => 'Thông tin & Pháp lý';

  @override
  String get settingsPrivacy => 'Chính sách bảo mật';

  @override
  String get settingsPrivacyBody =>
      'Ứng dụng thu thập tên và email qua Google Sign-In, lưu ngày sinh vào Firestore. Thông tin chỉ dùng để tính tử vi và tứ trụ, không chia sẻ với bên thứ ba.';

  @override
  String get settingsCalendarPermission => 'Quyền Google Calendar';

  @override
  String get settingsCalendarPermissionBody =>
      'Khi dùng tính năng đồng bộ, chúng tôi yêu cầu quyền đọc/ghi Google Calendar. Quyền này chỉ dùng để xem lịch và đăng ký sinh nhật âm lịch.';

  @override
  String get settingsNotificationPermission => 'Quyền thông báo';

  @override
  String get settingsNotificationPermissionBody =>
      'Thông báo cục bộ nhắc nhở kỷ niệm (trước 7 ngày, 3 ngày và ngay hôm đó). Thông báo chỉ xử lý trên thiết bị, không gửi đến máy chủ bên ngoài.';

  @override
  String get settingsAI => 'Tử vi AI (Gemini)';

  @override
  String get settingsAIBody =>
      'Tử vi hôm nay được tạo bởi Google Gemini API. Thông tin tứ trụ có thể được gửi khi tạo. Chuyển sang tử vi cục bộ sau 1.200 lần/ngày.';

  @override
  String get settingsAdMob => 'Quảng cáo (AdMob)';

  @override
  String get settingsAdMobBody =>
      'Ứng dụng hiển thị quảng cáo qua Google AdMob. AdMob có thể thu thập mã định danh thiết bị để tối ưu hóa quảng cáo. Xem Chính sách bảo mật của Google để biết thêm.';

  @override
  String settingsVersion(String version) {
    return 'Phiên bản $version  ·  © 2026 Gridnflow';
  }

  @override
  String get onboardingTitle => 'Cho chúng tôi biết ngày sinh của bạn';

  @override
  String get onboardingSubtitle =>
      'Dùng để tính tử vi và tứ trụ.\nBạn có thể thay đổi sau trong Cài đặt.';

  @override
  String get onboardingSolar => 'Dương lịch';

  @override
  String get onboardingLunar => 'Âm lịch';

  @override
  String get onboardingSolarHint =>
      'Nhập ngày dương lịch (VD: ngày 20 tháng 4 năm 1990)';

  @override
  String get onboardingLunarHint => 'Nhập ngày âm lịch (VD: âm lịch 15/3)';

  @override
  String get onboardingYear => 'Năm';

  @override
  String get onboardingMonth => 'Tháng';

  @override
  String get onboardingDay => 'Ngày';

  @override
  String get onboardingHour => 'Giờ sinh (tùy chọn, 0–23)';

  @override
  String get onboardingStart => 'Bắt đầu';

  @override
  String get onboardingSkip => 'Nhập sau';

  @override
  String get onboardingRequired => 'Bắt buộc';

  @override
  String onboardingRange(int min, int max) {
    return '$min–$max';
  }

  @override
  String get loginTitle => 'Đăng nhập để tiếp tục';

  @override
  String get loginGoogle => 'Tiếp tục bằng Google';

  @override
  String get languageSelect => 'Chọn ngôn ngữ';

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
