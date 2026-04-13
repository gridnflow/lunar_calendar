import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:table_calendar/table_calendar.dart';

import '../../../core/models/family_anniversary.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/services/lunar_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

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
    final l = AppLocalizations.of(context)!;
    final lunar = ref.read(lunarServiceProvider);
    final eventsAsync = ref.watch(upcomingEventsProvider);
    final anniversariesAsync = ref.watch(anniversariesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.calendarTitle),
            Text(
              lunar.todayLunarString(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l.calendarAddAnniversary,
            onPressed: () => _showAddAnniversaryDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: l.calendarAnniversaryList,
            onPressed: () => _showAnniversaryListSheet(context),
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
                Icon(Icons.calendar_today, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(height: 16),
                Text(l.calendarConnectRequired,
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('$e',
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(upcomingEventsProvider),
                  icon: const Icon(Icons.refresh),
                  label: Text(l.calendarRetry),
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
          );
        },
      ),
    );
  }

  Future<void> _showAddAnniversaryDialog(BuildContext context) async {
    final uid = ref.read(currentUserIdProvider);
    if (uid == null) return;

    final l = AppLocalizations.of(context)!;
    final nameCtrl = TextEditingController();
    String type = l.anniversaryType_other;
    int lunarMonth = 1;
    int lunarDay = 1;
    bool isLeap = false;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l.anniversaryAdd),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: l.anniversaryName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: l.anniversaryType_jesa, label: Text(l.anniversaryType_jesa), icon: const Icon(Icons.local_fire_department)),
                    ButtonSegment(value: l.anniversaryType_birthday, label: Text(l.anniversaryType_birthday), icon: const Icon(Icons.cake)),
                    ButtonSegment(value: l.anniversaryType_other, label: Text(l.anniversaryType_other), icon: const Icon(Icons.star)),
                  ],
                  selected: {type},
                  onSelectionChanged: (v) => setState(() => type = v.first),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(ctx).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.nightlight_outlined,
                          size: 16,
                          color: Theme.of(ctx).colorScheme.onSecondaryContainer),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l.anniversaryLunarHint,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: Theme.of(ctx).colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _PickerField(
                        label: l.anniversaryLunarMonth,
                        value: lunarMonth,
                        min: 1,
                        max: 12,
                        onChanged: (v) => setState(() => lunarMonth = v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PickerField(
                        label: l.anniversaryLunarDay,
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
                  title: Text(l.anniversaryLeapMonth),
                  value: isLeap,
                  onChanged: (v) => setState(() => isLeap = v ?? false),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.anniversaryCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.anniversarySave),
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
        SnackBar(content: Text(l.anniversaryAdded(nameCtrl.text.trim()))),
      );
    }
  }

  Future<void> _showAnniversaryListSheet(BuildContext context) async {
    final uid = ref.read(currentUserIdProvider);
    if (uid == null) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _AnniversaryListSheet(uid: uid),
    );
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
  const _CalendarBody({
    required this.events,
    required this.anniversaries,
    required this.focusedDay,
    required this.selectedDay,
    required this.lunar,
    required this.onDaySelected,
    required this.eventsForDay,
    required this.anniversariesForDay,
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
                dots.add(_dot(AppTheme.anniversaryColor(ann.type)));
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
          _AnniversaryBar(anniversaries: selectedAnniversaries),
        Expanded(
          child: selectedEvents.isEmpty
              ? Center(
                  child: Text(AppLocalizations.of(context)!.calendarNoEvents,
                      style: TextStyle(color: colorScheme.onSurfaceVariant)))
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
                        : 'All day';
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.primaryContainer,
                        child: Icon(Icons.event,
                            color: colorScheme.primary, size: 18),
                      ),
                      title: Text(event.summary ?? '(No title)'),
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

  const _AnniversaryBar({required this.anniversaries});

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
          final color = AppTheme.anniversaryColor(ann.type);
          final icon = AppTheme.anniversaryIcon(ann.type);
          return Chip(
            avatar: Icon(icon, size: 16, color: color),
            label: Text(
              '${ann.name} (${AppLocalizations.of(outerContext)!.fortuneLunarDate(ann.lunarMonth, ann.lunarDay)})',
              style: const TextStyle(color: Colors.black),
            ),
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
    final lunarLabel = '$lunarMonth/$lunarDay';

    Color? bgColor;
    Color textColor = cs.onSurface;

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
          style: TextStyle(fontSize: 9, color: cs.onSurfaceVariant),
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

class _AnniversaryListSheet extends ConsumerWidget {
  final String uid;
  const _AnniversaryListSheet({required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final anniversariesAsync = ref.watch(anniversariesProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      maxChildSize: 0.85,
      builder: (_, controller) => Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(l.anniversaryListTitle,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface)),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 16),
                  label: Text(l.anniversaryClose),
                  style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      foregroundColor: colorScheme.onSurface),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: anniversariesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (list) {
                if (list.isEmpty) {
                  return Center(
                    child: Text(l.anniversaryEmpty,
                        style:
                            TextStyle(color: colorScheme.onSurfaceVariant)),
                  );
                }
                return ListView.separated(
                  controller: controller,
                  itemCount: list.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, indent: 56),
                  itemBuilder: (context, i) {
                    final ann = list[i];
                    final color = AppTheme.anniversaryColor(ann.type);
                    final icon = AppTheme.anniversaryIcon(ann.type);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color.withValues(alpha: 0.15),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      title: Text(ann.name),
                      subtitle: Text(
                          '${l.fortuneLunarDate(ann.lunarMonth, ann.lunarDay)}${ann.isLeap ? ' (${l.anniversaryLeapMonth})' : ''}  ·  ${ann.type}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline,
                            color: colorScheme.error),
                        onPressed: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(l.anniversaryDelete),
                              content: Text(
                                  l.anniversaryDeleteConfirm(ann.name)),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(ctx, false),
                                    child: Text(l.anniversaryCancel)),
                                FilledButton(
                                    onPressed: () =>
                                        Navigator.pop(ctx, true),
                                    style: FilledButton.styleFrom(
                                        backgroundColor: colorScheme.error),
                                    child: Text(l.anniversaryDelete)),
                              ],
                            ),
                          );
                          if (ok == true && context.mounted) {
                            await ref
                                .read(anniversaryServiceProvider)
                                .delete(uid, ann.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        l.anniversaryDeleted(ann.name))),
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
