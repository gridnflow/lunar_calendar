import 'package:home_widget/home_widget.dart';

import '../models/user_profile.dart';
import 'lunar_service.dart';

class WidgetService {
  static const _appGroupId = 'com.gridnflow.lunar.calendar';

  static const _pkg = 'com.gridnflow.lunar.calendar';
  static const _smallProvider = '$_pkg.LunarWidgetSmall';
  static const _mediumProvider = '$_pkg.LunarWidgetMedium';
  static const _largeProvider = '$_pkg.LunarWidgetLarge';

  Future<void> updateWidgets({
    required LunarService lunar,
    UserProfile? profile,
    String? fortuneText,
  }) async {
    await HomeWidget.setAppGroupId(_appGroupId);

    final now = DateTime.now();
    final lunarDate = lunar.solarToLunar(now);
    final lunarMonth = lunarDate.getMonth();
    final lunarDay = lunarDate.getDay();
    final solarTerm = lunar.todaySolarTerm();
    final dayPillar = lunar.todayDayPillar();

    // 공통 데이터
    await HomeWidget.saveWidgetData('solar_day', '${now.day}');
    await HomeWidget.saveWidgetData(
        'solar_full', '${now.year}년 ${now.month}월 ${now.day}일');
    await HomeWidget.saveWidgetData('lunar_short', '$lunarMonth/$lunarDay');
    await HomeWidget.saveWidgetData(
        'lunar_full', '음력 $lunarMonth월 $lunarDay일');
    await HomeWidget.saveWidgetData('day_pillar', dayPillar);
    await HomeWidget.saveWidgetData('solar_term', solarTerm ?? '');

    // 사주 (4x4 위젯용)
    if (profile != null && profile.birthYear != 0) {
      final birthDate = profile.isLunarBirth
          ? lunar.lunarToSolar(
              profile.birthYear, profile.birthMonth, profile.birthDay)
          : DateTime(
              profile.birthYear, profile.birthMonth, profile.birthDay);
      final saju = lunar.getSaju(
        year: birthDate.year,
        month: birthDate.month,
        day: birthDate.day,
        hour: profile.birthHour,
      );
      await HomeWidget.saveWidgetData('saju_year', saju['year'] ?? '--');
      await HomeWidget.saveWidgetData('saju_month', saju['month'] ?? '--');
      await HomeWidget.saveWidgetData('saju_day', saju['day'] ?? '--');
      await HomeWidget.saveWidgetData(
          'saju_hour', saju['hour']?.isNotEmpty == true ? saju['hour']! : '--');
    } else {
      await HomeWidget.saveWidgetData('saju_year', '--');
      await HomeWidget.saveWidgetData('saju_month', '--');
      await HomeWidget.saveWidgetData('saju_day', '--');
      await HomeWidget.saveWidgetData('saju_hour', '--');
    }

    // 운세 요약 (첫 200자)
    if (fortuneText != null && fortuneText.isNotEmpty) {
      final summary = fortuneText.replaceAll(RegExp(r'\*\*[^*]+\*\*\s*'), '');
      await HomeWidget.saveWidgetData(
          'fortune_summary',
          summary.length > 200 ? '${summary.substring(0, 200)}…' : summary);
    }

    // 위젯 갱신 트리거 (홈 화면에 위젯이 없으면 예외 무시)
    try {
      await HomeWidget.updateWidget(
          androidName: _smallProvider, qualifiedAndroidName: _smallProvider);
    } catch (_) {}
    try {
      await HomeWidget.updateWidget(
          androidName: _mediumProvider, qualifiedAndroidName: _mediumProvider);
    } catch (_) {}
    try {
      await HomeWidget.updateWidget(
          androidName: _largeProvider, qualifiedAndroidName: _largeProvider);
    } catch (_) {}
  }
}
