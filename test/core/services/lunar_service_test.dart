import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_calendar/core/services/lunar_service.dart';

void main() {
  late LunarService service;

  setUp(() => service = LunarService());

  group('lunarToSolar', () {
    test('converts lunar 2000-01-01 to solar 2000-02-05', () {
      final solar = service.lunarToSolar(2000, 1, 1);
      expect(solar, DateTime(2000, 2, 5));
    });

    test('converts lunar 1990-01-01 to expected solar date', () {
      final solar = service.lunarToSolar(1990, 1, 1);
      expect(solar.year, 1990);
      expect(solar, isA<DateTime>());
    });

    test('converts lunar 2026-06-15 without throwing', () {
      expect(() => service.lunarToSolar(2026, 6, 15), returnsNormally);
    });
  });

  group('solarToLunar', () {
    test('converts solar 2000-02-05 to lunar month 1', () {
      final lunar = service.solarToLunar(DateTime(2000, 2, 5));
      expect(lunar.getMonth(), 1);
      expect(lunar.getDay(), 1);
    });

    test('returns Lunar object for arbitrary date', () {
      final lunar = service.solarToLunar(DateTime(1990, 6, 15));
      expect(lunar, isNotNull);
      expect(lunar.getMonth(), greaterThan(0));
      expect(lunar.getDay(), greaterThan(0));
    });
  });

  group('todayLunarString', () {
    test('starts with 음력', () {
      expect(service.todayLunarString(), startsWith('음력'));
    });

    test('contains 월 and 일', () {
      final s = service.todayLunarString();
      expect(s, contains('월'));
      expect(s, contains('일'));
    });
  });

  group('todayDayPillar', () {
    test('ends with 일', () {
      expect(service.todayDayPillar(), endsWith('일'));
    });

    test('is not empty', () {
      expect(service.todayDayPillar(), isNotEmpty);
    });
  });

  group('todayMonthPillar', () {
    test('ends with 월', () {
      expect(service.todayMonthPillar(), endsWith('월'));
    });
  });

  group('todayYearPillar', () {
    test('ends with 년', () {
      expect(service.todayYearPillar(), endsWith('년'));
    });
  });

  group('todaySolarTerm', () {
    test('returns null or non-empty string', () {
      final term = service.todaySolarTerm();
      if (term != null) {
        expect(term, isNotEmpty);
      }
    });
  });

  group('getSaju', () {
    test('returns map with year, month, day, hour keys', () {
      final saju = service.getSaju(year: 1990, month: 5, day: 10);
      expect(saju.containsKey('year'), true);
      expect(saju.containsKey('month'), true);
      expect(saju.containsKey('day'), true);
      expect(saju.containsKey('hour'), true);
    });

    test('year/month/day values are non-empty', () {
      final saju = service.getSaju(year: 1985, month: 8, day: 22);
      expect(saju['year'], isNotEmpty);
      expect(saju['month'], isNotEmpty);
      expect(saju['day'], isNotEmpty);
    });

    test('hour is empty string when no hour provided', () {
      final saju = service.getSaju(year: 1995, month: 3, day: 3);
      expect(saju['hour'], '');
    });

    test('hour is non-empty when hour is provided', () {
      final saju = service.getSaju(year: 1995, month: 3, day: 3, hour: 12);
      expect(saju['hour'], isNotEmpty);
    });

    test('different birth dates produce different year pillars', () {
      final saju1 = service.getSaju(year: 1980, month: 1, day: 1);
      final saju2 = service.getSaju(year: 2000, month: 1, day: 1);
      expect(saju1['year'], isNot(equals(saju2['year'])));
    });
  });
}
