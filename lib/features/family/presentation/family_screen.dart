import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/family_anniversary.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/services/lunar_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

String _typeLabel(String type, AppLocalizations l) {
  switch (type) {
    case AnniversaryType.jesa: return l.anniversaryType_jesa;
    case AnniversaryType.birthday: return l.anniversaryType_birthday;
    default: return l.anniversaryType_other;
  }
}

class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final anniversariesAsync = ref.watch(anniversariesProvider);
    final lunar = ref.read(lunarServiceProvider);
    final uid = ref.read(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.familyTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l.anniversaryAdd,
            onPressed: uid == null
                ? null
                : () => _showAddDialog(context, ref, uid, l),
          ),
        ],
      ),
      body: anniversariesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.generalError(e.toString()))),
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(l.familyEmpty,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: uid == null
                        ? null
                        : () => _showAddDialog(context, ref, uid, l),
                    icon: const Icon(Icons.add),
                    label: Text(l.familyAddButton),
                  ),
                ],
              ),
            );
          }

          final byType = <String, List<FamilyAnniversary>>{};
          for (final ann in list) {
            byType.putIfAbsent(ann.type, () => []).add(ann);
          }
          const order = [
            AnniversaryType.jesa,
            AnniversaryType.birthday,
            AnniversaryType.other,
          ];
          final sortedTypes = order.where(byType.containsKey).toList();

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            children: [
              for (final type in sortedTypes) ...[
                _TypeHeader(type: _typeLabel(type, l)),
                for (final ann in byType[type]!)
                  _AnniversaryCard(
                    ann: ann,
                    lunar: lunar,
                    l: l,
                    onDelete: uid == null
                        ? null
                        : () => _confirmDelete(context, ref, uid, ann, l),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _showAddDialog(
      BuildContext context, WidgetRef ref, String uid, AppLocalizations l) async {
    final nameCtrl = TextEditingController();
    String type = AnniversaryType.other;
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
                _AnniversaryTypeSelector(
                  selected: type,
                  onChanged: (v) => setState(() => type = v),
                  jesa: l.anniversaryType_jesa,
                  birthday: l.anniversaryType_birthday,
                  other: l.anniversaryType_other,
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
                Row(children: [
                  Expanded(
                    child: _PickerField(
                      label: l.anniversaryLunarMonth,
                      value: lunarMonth,
                      min: 1,
                      max: 12,
                      suffix: l.fortuneMonthSuffix,
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
                      suffix: l.fortuneDaySuffix,
                      onChanged: (v) => setState(() => lunarDay = v),
                    ),
                  ),
                ]),
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
                child: Text(l.anniversaryCancel)),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l.anniversarySave)),
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

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, String uid,
      FamilyAnniversary ann, AppLocalizations l) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.anniversaryDelete),
        content: Text(l.anniversaryDeleteConfirm(ann.name)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.anniversaryCancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error),
            child: Text(l.anniversaryDelete),
          ),
        ],
      ),
    );

    if (ok == true && context.mounted) {
      await ref.read(anniversaryServiceProvider).delete(uid, ann.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.anniversaryDeleted(ann.name))),
        );
      }
    }
  }
}

class _TypeHeader extends StatelessWidget {
  final String type;
  const _TypeHeader({required this.type});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.anniversaryColor(type);
    final icon = AppTheme.anniversaryIcon(type);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 0, 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            type,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: color, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _AnniversaryCard extends StatelessWidget {
  final FamilyAnniversary ann;
  final LunarService lunar;
  final AppLocalizations l;
  final VoidCallback? onDelete;

  const _AnniversaryCard(
      {required this.ann, required this.lunar, required this.l, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.anniversaryColor(ann.type);
    final icon = AppTheme.anniversaryIcon(ann.type);

    String solarStr = '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (final year in [now.year, now.year + 1]) {
      try {
        final solar = lunar.lunarToSolar(year, ann.lunarMonth, ann.lunarDay,
            isLeap: ann.isLeap);
        final solarDay = DateTime(solar.year, solar.month, solar.day);
        final diff = solarDay.difference(today).inDays;
        if (diff >= 0) {
          final lunarAnn = lunar.solarToLunar(solarDay);
          final lunarDateStr = l.fortuneLunarDate(lunarAnn.getMonth(), lunarAnn.getDay());
          solarStr = diff == 0
              ? l.familyToday
              : diff <= 7
                  ? l.familyDDaySoon(diff, lunarDateStr)
                  : l.familyDDay(diff, lunarDateStr);
          break;
        }
      } catch (_) {}
    }

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(ann.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          l.fortuneLunarDate(ann.lunarMonth, ann.lunarDay) +
          (ann.isLeap ? ' (${l.anniversaryLeapMonth})' : ''),
          style: const TextStyle(fontSize: 13),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (solarStr.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Text(solarStr,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: color)),
              ),
            IconButton(
              icon: Icon(Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error, size: 20),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final String suffix;
  final void Function(int) onChanged;

  const _PickerField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.suffix = '',
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
        (i) => DropdownMenuItem(value: min + i, child: Text('${min + i}$suffix')),
      ),
      onChanged: (v) => onChanged(v ?? value),
    );
  }
}

class _AnniversaryTypeSelector extends StatelessWidget {
  final String selected;
  final void Function(String) onChanged;
  final String jesa;
  final String birthday;
  final String other;

  const _AnniversaryTypeSelector({
    required this.selected,
    required this.onChanged,
    required this.jesa,
    required this.birthday,
    required this.other,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final types = [
      (value: AnniversaryType.jesa, icon: Icons.local_fire_department, label: jesa),
      (value: AnniversaryType.birthday, icon: Icons.cake, label: birthday),
      (value: AnniversaryType.other, icon: Icons.star_outline, label: other),
    ];
    return Row(
      children: types.map((t) {
        final isSelected = selected == t.value;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: InkWell(
              onTap: () => onChanged(t.value),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? cs.primary : cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? null
                      : Border.all(color: cs.outlineVariant),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(t.icon,
                        size: 22,
                        color: isSelected ? cs.onPrimary : cs.onSurfaceVariant),
                    const SizedBox(height: 5),
                    Text(
                      t.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
