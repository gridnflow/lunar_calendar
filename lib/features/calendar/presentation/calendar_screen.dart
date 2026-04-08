import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:table_calendar/table_calendar.dart';

import '../../../core/models/family_anniversary.dart';
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

  List<FamilyAnniversary> _anniversariesForDay(
    DateTime day,
    List<FamilyAnniversary> all,
    LunarService lunar,
  ) {
    return all.where((ann) {
      for (final year in [day.year - 1, day.year, day.year + 1]) {
        try {
          final solar =
              lunar.lunarToSolar(year, ann.lunarMonth, ann.lunarDay, isLeap: ann.isLeap);
          if (isSameDay(solar, day)) return true;
        } catch (_) {}
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lunar = ref.read(lunarServiceProvider);
    final eventsAsync = ref.watch(upcomingEventsProvider);
    final anniversariesAsync = ref.watch(anniversariesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Calendar'),
            Text(
              lunar.todayLunarString(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '기념일 추가',
            onPressed: () => _showAddAnniversaryDialog(context),
          ),
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
                const Text('Google Calendar 연결 필요',
                    style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('$e',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center),
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
        data: (events) {
          final anniversaries = anniversariesAsync.valueOrNull ?? [];
          return _CalendarBody(
            events: events,
            anniversaries: anniversaries,
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
            anniversariesForDay: (day) =>
                _anniversariesForDay(day, anniversaries, lunar),
            onRegisterBirthday: () => _showRegisterBirthdayDialog(context),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRegisterBirthdayDialog(context),
        icon: const Icon(Icons.cake),
        label: const Text('음력 생일 등록'),
      ),
    );
  }

  Future<void> _showAddAnniversaryDialog(BuildContext context) async {
    final uid = ref.read(currentUserIdProvider);
    if (uid == null) return;

    final nameCtrl = TextEditingController();
    String type = '기타';
    int lunarMonth = 1;
    int lunarDay = 1;
    bool isLeap = false;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('기념일 추가'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: '이름 (예: 할아버지 제사)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: '제사', label: Text('제사'), icon: Icon(Icons.local_fire_department)),
                    ButtonSegment(value: '생일', label: Text('생일'), icon: Icon(Icons.cake)),
                    ButtonSegment(value: '기타', label: Text('기타'), icon: Icon(Icons.star)),
                  ],
                  selected: {type},
                  onSelectionChanged: (v) => setState(() => type = v.first),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _PickerField(
                        label: '음력 월',
                        value: lunarMonth,
                        min: 1,
                        max: 12,
                        onChanged: (v) => setState(() => lunarMonth = v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PickerField(
                        label: '음력 일',
                        value: lunarDay,
                        min: 1,
                        max: 30,
                        onChanged: (v) => setState(() => lunarDay = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('윤달'),
                  value: isLeap,
                  onChanged: (v) => setState(() => isLeap = v ?? false),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || nameCtrl.text.trim().isEmpty) return;

    await ref.read(anniversaryServiceProvider).add(
          uid,
          FamilyAnniversary(
            id: '',
            name: nameCtrl.text.trim(),
            type: type,
            lunarMonth: lunarMonth,
            lunarDay: lunarDay,
            isLeap: isLeap,
          ),
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${nameCtrl.text.trim()} 기념일이 추가됐습니다')),
      );
    }
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
  final List<FamilyAnniversary> anniversaries;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final LunarService lunar;
  final void Function(DateTime, DateTime) onDaySelected;
  final List<gcal.Event> Function(DateTime) eventsForDay;
  final List<FamilyAnniversary> Function(DateTime) anniversariesForDay;
  final VoidCallback onRegisterBirthday;

  const _CalendarBody({
    required this.events,
    required this.anniversaries,
    required this.focusedDay,
    required this.selectedDay,
    required this.lunar,
    required this.onDaySelected,
    required this.eventsForDay,
    required this.anniversariesForDay,
    required this.onRegisterBirthday,
  });

  @override
  Widget build(BuildContext context) {
    final selected = selectedDay ?? focusedDay;
    final selectedEvents = eventsForDay(selected);
    final selectedAnniversaries = anniversariesForDay(selected);
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
            defaultBuilder: (context, day, _) =>
                _DayCell(day: day, lunar: lunar),
            todayBuilder: (context, day, _) => _DayCell(
                day: day,
                lunar: lunar,
                isToday: true,
                colorScheme: colorScheme),
            selectedBuilder: (context, day, _) => _DayCell(
                day: day,
                lunar: lunar,
                isSelected: true,
                colorScheme: colorScheme),
            markerBuilder: (context, day, dayEvents) {
              final dots = <Widget>[];
              if (dayEvents.isNotEmpty) {
                dots.add(_dot(colorScheme.primary));
              }
              for (final ann in anniversariesForDay(day)) {
                dots.add(_dot(ann.type == '제사'
                    ? Colors.red
                    : ann.type == '생일'
                        ? Colors.orange
                        : Colors.green));
              }
              if (dots.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: dots
                      .take(3)
                      .map((d) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: d,
                          ))
                      .toList(),
                ),
              );
            },
          ),
          calendarStyle: const CalendarStyle(
            markersMaxCount: 0, // we handle markers ourselves
            cellMargin: EdgeInsets.all(2),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          rowHeight: 72,
        ),
        const Divider(height: 1),
        // Anniversary chips for selected day
        if (selectedAnniversaries.isNotEmpty)
          _AnniversaryBar(
              anniversaries: selectedAnniversaries, context: context),
        Expanded(
          child: selectedEvents.isEmpty
              ? const Center(
                  child: Text('이 날의 일정이 없습니다',
                      style: TextStyle(color: Colors.grey)))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: selectedEvents.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, indent: 56),
                  itemBuilder: (context, i) {
                    final event = selectedEvents[i];
                    final start =
                        event.start?.dateTime ?? event.start?.date;
                    final timeStr = event.start?.dateTime != null
                        ? '${start!.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}'
                        : '종일';
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.primaryContainer,
                        child: Icon(Icons.event,
                            color: colorScheme.primary, size: 18),
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

  Widget _dot(Color color) => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _AnniversaryBar extends StatelessWidget {
  final List<FamilyAnniversary> anniversaries;
  final BuildContext context;

  const _AnniversaryBar(
      {required this.anniversaries, required this.context});

  @override
  Widget build(BuildContext outerContext) {
    return Container(
      width: double.infinity,
      color: Theme.of(outerContext).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: anniversaries.map((ann) {
          final color = ann.type == '제사'
              ? Colors.red
              : ann.type == '생일'
                  ? Colors.orange
                  : Colors.green;
          final icon = ann.type == '제사'
              ? Icons.local_fire_department
              : ann.type == '생일'
                  ? Icons.cake
                  : Icons.star;
          return Chip(
            avatar: Icon(icon, size: 16, color: color),
            label: Text('${ann.name} (음력 ${ann.lunarMonth}/${ann.lunarDay})'),
            backgroundColor: color.withValues(alpha: 0.12),
            side: BorderSide(color: color.withValues(alpha: 0.4)),
          );
        }).toList(),
      ),
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
              fontWeight:
                  isToday || isSelected ? FontWeight.bold : FontWeight.normal,
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

class _PickerField extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final void Function(int) onChanged;

  const _PickerField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: List.generate(
        max - min + 1,
        (i) => DropdownMenuItem(value: min + i, child: Text('${min + i}')),
      ),
      onChanged: (v) => onChanged(v ?? value),
    );
  }
}
