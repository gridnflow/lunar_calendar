import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kFortuneUnlockKey = 'fortune_unlocked_date';

/// 오늘의 AI 상세운세 잠금 해제 여부 (보상형 광고 시청 시 하루 동안 유지).
class FortuneUnlockNotifier extends Notifier<bool> {
  @override
  bool build() {
    _loadSaved();
    return false;
  }

  static String _today() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_kFortuneUnlockKey) == _today()) {
      state = true;
    }
  }

  /// 보상형 광고 시청 완료 시 호출 — 오늘 하루 상세운세 잠금 해제.
  Future<void> unlock() async {
    state = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kFortuneUnlockKey, _today());
  }
}

final fortuneUnlockedProvider = NotifierProvider<FortuneUnlockNotifier, bool>(
  FortuneUnlockNotifier.new,
);
