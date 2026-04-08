import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:table_calendar/table_calendar.dart';

import '../../../core/providers/service_providers.dart';
import '../../../core/services/lunar_service.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  List<gcal.Event> _eventsForDay(DateTime day, List<gcal.Event> allEvents) {
    return allEvents.where((event) {
      final start = event.start?.dateTime ?? event.start?.date;
      if (start == null) return false;
      return isSameDay(start, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lunar = ref.read(lunarServiceProvider);
    final eventsAsync = ref.watch(upcomingEventsProvider);
    final lunarToday = lunar.todayLunarString();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Calendar'),
            Text(lunarToday, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(upcomingEventsProvider),
          ),
        ],
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Google Calendar 연결 필요', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('$e', style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(upcomingEventsProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('재시도'),
                ),
              ],
            ),
          ),
        ),
        data: (events) => _CalendarBody(
          events: events,
          focusedDay: _focusedDay,
          selectedDay: _selectedDay,
          lunar: lunar,
          onDaySelected: (selected, focused) {
            setState(() {
              _selectedDay = selected;
              _focusedDay = focused;
            });
          },
          eventsForDay: (day) => _eventsForDay(day, events),
          onRegisterBirthday: () => _showRegisterBirthdayDialog(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRegisterBirthdayDialog(context),
        icon: const Icon(Icons.cake),
        label: const Text('음력 생일 등록'),
      ),
    );
  }

  Future<void> _showRegisterBirthdayDialog(BuildContext context) async {
    final uid = ref.read(currentUserIdProvider);
    if (uid == null) return;

    final profile = await ref.read(userServiceProvider).getProfile(uid);
    if (profile == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings에서 생일 정보를 먼저 입력해주세요')),
        );
      }
      return;
    }

    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('음력 생일 등록'),
        content: Text(
          '음력 생일 (${profile.birthMonth}월 ${profile.birthDay}일)을\n'
          'Google Calendar에 20년치 등록할까요?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('등록'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final dates = ref.read(lunarServiceProvider).getLunarBirthdayDates(
          birthMonth: profile.birthMonth,
          birthDay: profile.birthDay,
        );

    await ref.read(calendarServiceProvider).registerLunarBirthdays(
          name: profile.displayName,
          dates: dates,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${dates.length}개 생일 일정이 등록됐습니다!')),
      );
      ref.invalidate(upcomingEventsProvider);
    }
  }
}

class _CalendarBody extends StatelessWidget {
  final List<gcal.Event> events;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final LunarService lunar;
  final void Function(DateTime, DateTime) onDaySelected;
  final List<gcal.Event> Function(DateTime) eventsForDay;
  final VoidCallback onRegisterBirthday;

  const _CalendarBody({
    required this.events,
    required this.focusedDay,
    required this.selectedDay,
    required this.lunar,
    required this.onDaySelected,
    required this.eventsForDay,
    required this.onRegisterBirthday,
  });

  @override
  Widget build(BuildContext context) {
    final selectedEvents = eventsForDay(selectedDay ?? focusedDay);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        TableCalendar<gcal.Event>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: focusedDay,
          selectedDayPredicate: (day) => isSameDay(selectedDay, day),
          eventLoader: eventsForDay,
          onDaySelected: onDaySelected,
          calendarFormat: CalendarFormat.month,
          availableCalendarFormats: const {CalendarFormat.month: 'Month'},
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarBuilders: CalendarBuilders(
            // Show lunar date below solar date
            defaultBuilder: (context, day, focusedDay) =>
                _DayCell(day: day, lunar: lunar),
            todayBuilder: (context, day, focusedDay) =>
                _DayCell(day: day, lunar: lunar, isToday: true, colorScheme: colorScheme),
            selectedBuilder: (context, day, focusedDay) =>
                _DayCell(day: day, lunar: lunar, isSelected: true, colorScheme: colorScheme),
          ),
          calendarStyle: CalendarStyle(
            markerDecoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            markerSize: 5,
            cellMargin: const EdgeInsets.all(2),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          rowHeight: 72,
        ),
        const Divider(height: 1),
        Expanded(
          child: selectedEvents.isEmpty
              ? const Center(
                  child: Text('이 날의 일정이 없습니다', style: TextStyle(color: Colors.grey)),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: selectedEvents.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, indent: 56),
                  itemBuilder: (context, i) {
                    final event = selectedEvents[i];
                    final start = event.start?.dateTime ?? event.start?.date;
                    final timeStr = event.start?.dateTime != null
                        ? '${start!.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}'
                        : '종일';
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.primaryContainer,
                        child: Icon(Icons.event, color: colorScheme.primary, size: 18),
                      ),
                      title: Text(event.summary ?? '(제목 없음)'),
                      subtitle: Text(timeStr),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime day;
  final LunarService lunar;
  final bool isToday;
  final bool isSelected;
  final ColorScheme? colorScheme;

  const _DayCell({
    required this.day,
    required this.lunar,
    this.isToday = false,
    this.isSelected = false,
    this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final cs = colorScheme ?? Theme.of(context).colorScheme;
    final lunarDate = lunar.solarToLunar(day);
    final lunarMonth = lunarDate.getMonth();
    final lunarDay = lunarDate.getDay();
    // Show "M/D" on the 1st of each lunar month, just day otherwise
    final lunarLabel = lunarDay == 1 ? '$lunarMonth월' : '$lunarDay';

    Color? bgColor;
    Color textColor = Colors.black87;

    if (isSelected) {
      bgColor = cs.primary;
      textColor = cs.onPrimary;
    } else if (isToday) {
      bgColor = cs.primaryContainer;
      textColor = cs.onPrimaryContainer;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: bgColor != null
              ? BoxDecoration(color: bgColor, shape: BoxShape.circle)
              : null,
          alignment: Alignment.center,
          child: Text(
            '${day.day}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          lunarLabel,
          style: const TextStyle(fontSize: 9, color: Colors.black54),
        ),
      ],
    );
  }
}
