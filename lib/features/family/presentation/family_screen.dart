import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/family_anniversary.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/services/lunar_service.dart';
import '../../../core/theme/app_theme.dart';

class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anniversariesAsync = ref.watch(anniversariesProvider);
    final lunar = ref.read(lunarServiceProvider);
    final uid = ref.read(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('가족 기념일'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '기념일 추가',
            onPressed: uid == null
                ? null
                : () => _showAddDialog(context, ref, uid),
          ),
        ],
      ),
      body: anniversariesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
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
                  Text('등록된 기념일이 없습니다',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: uid == null
                        ? null
                        : () => _showAddDialog(context, ref, uid),
                    icon: const Icon(Icons.add),
                    label: const Text('기념일 추가'),
                  ),
                ],
              ),
            );
          }

          // 타입별 그룹
          final byType = <String, List<FamilyAnniversary>>{};
          for (final ann in list) {
            byType.putIfAbsent(ann.type, () => []).add(ann);
          }
          final order = ['제사', '생일', '기타'];
          final sortedTypes = order.where(byType.containsKey).toList();

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            children: [
              for (final type in sortedTypes) ...[
                _TypeHeader(type: type),
                for (final ann in byType[type]!)
                  _AnniversaryCard(
                    ann: ann,
                    lunar: lunar,
                    onDelete: uid == null
                        ? null
                        : () => _confirmDelete(context, ref, uid, ann),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _showAddDialog(
      BuildContext context, WidgetRef ref, String uid) async {
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
                    labelText: '이름 (예: 할머니 제사)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                        value: '제사',
                        label: Text('제사'),
                        icon: Icon(Icons.local_fire_department)),
                    ButtonSegment(
                        value: '생일',
                        label: Text('생일'),
                        icon: Icon(Icons.cake)),
                    ButtonSegment(
                        value: '기타',
                        label: Text('기타'),
                        icon: Icon(Icons.star)),
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
                          '날짜는 음력으로 입력해주세요.\n예) 음력 생일이 3월 15일이면 3월, 15일 선택',
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
                ]),
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
                child: const Text('취소')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('저장')),
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

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, String uid,
      FamilyAnniversary ann) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('기념일 삭제'),
        content: Text('"${ann.name}"을 삭제할까요?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('취소')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (ok == true && context.mounted) {
      await ref.read(anniversaryServiceProvider).delete(uid, ann.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${ann.name}" 삭제됐습니다')),
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
  final VoidCallback? onDelete;

  const _AnniversaryCard(
      {required this.ann, required this.lunar, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.anniversaryColor(ann.type);
    final icon = AppTheme.anniversaryIcon(ann.type);

    // 음력 오늘 기준으로 D-day 계산 (양력 변환 후 비교)
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
          // 음력 날짜로 표시
          final lunarAnn = lunar.solarToLunar(solarDay);
          final lunarAnnStr = '${lunarAnn.getMonth()}/${lunarAnn.getDay()}';
          solarStr = diff == 0
              ? '오늘 🎉'
              : diff <= 7
                  ? 'D-$diff  음력$lunarAnnStr'
                  : '음력$lunarAnnStr (D-$diff)';
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
          '음력 ${ann.lunarMonth}월 ${ann.lunarDay}일'
          '${ann.isLeap ? ' (윤달)' : ''}',
          style: const TextStyle(fontSize: 13),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (solarStr.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: color.withValues(alpha: 0.3)),
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: List.generate(
        max - min + 1,
        (i) => DropdownMenuItem(value: min + i, child: Text('${min + i}')),
      ),
      onChanged: (v) => onChanged(v ?? value),
    );
  }
}
