import 'package:lunar/lunar.dart';

class LunarService {
  /// Convert a lunar date to solar (양력).
  DateTime lunarToSolar(int year, int month, int day, {bool isLeap = false}) {
    final lunar = Lunar.fromYmd(year, month, day);
    final solar = lunar.getSolar();
    return DateTime(solar.getYear(), solar.getMonth(), solar.getDay());
  }

  /// Convert a solar date to lunar (음력).
  Lunar solarToLunar(DateTime date) {
    final solar = Solar.fromYmd(date.year, date.month, date.day);
    return solar.getLunar();
  }

  /// Get today's lunar date string, e.g. "음력 3월 12일 (甲辰년)"
  String todayLunarString() {
    final lunar = solarToLunar(DateTime.now());
    return '음력 ${lunar.getMonth()}월 ${lunar.getDay()}일';
  }

  /// Get today's 일주 (day pillar) — Heavenly Stem + Earthly Branch.
  String todayDayPillar() {
    final lunar = solarToLunar(DateTime.now());
    return '${lunar.getDayInGanZhi()}일';
  }

  /// Get today's 월주 (month pillar).
  String todayMonthPillar() {
    final lunar = solarToLunar(DateTime.now());
    return '${lunar.getMonthInGanZhi()}월';
  }

  /// Get today's 연주 (year pillar).
  String todayYearPillar() {
    final lunar = solarToLunar(DateTime.now());
    return '${lunar.getYearInGanZhi()}년';
  }

  /// Get the 절기 (solar term) for today, or null if none.
  String? todaySolarTerm() {
    final lunar = solarToLunar(DateTime.now());
    final term = lunar.getJieQi();
    return term.isEmpty ? null : term;
  }

  /// Generate solar dates for a lunar birthday over the next [years] years.
  List<DateTime> getLunarBirthdayDates({
    required int birthMonth,
    required int birthDay,
    int years = 20,
  }) {
    final now = DateTime.now();
    final result = <DateTime>[];

    for (int y = now.year; y <= now.year + years; y++) {
      try {
        final solar = lunarToSolar(y, birthMonth, birthDay);
        result.add(solar);
      } catch (_) {
        // Skip years where the lunar date doesn't exist (e.g. leap month edge cases)
      }
    }
    return result;
  }

  /// Get 사주 (four pillars) for a given birth datetime.
  Map<String, String> getSaju({
    required int year,
    required int month,
    required int day,
    int? hour,
  }) {
    final solar = Solar.fromYmd(year, month, day);
    final lunar = solar.getLunar();
    final eightChar = lunar.getEightChar();

    return {
      'year': eightChar.getYear(),
      'month': eightChar.getMonth(),
      'day': eightChar.getDay(),
      'hour': hour != null ? eightChar.getTime() : '',
    };
  }
}
