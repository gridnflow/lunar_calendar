import 'package:firebase_analytics/firebase_analytics.dart';

/// 수익화 의사결정용 핵심 이벤트 로깅.
/// 로깅 실패가 앱 흐름을 깨지 않도록 모든 호출은 조용히 실패합니다.
class AnalyticsService {
  /// go_router에 연결해 화면 전환(screen_view)을 자동 기록하는 옵저버.
  FirebaseAnalyticsObserver createObserver() =>
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

  Future<void> _log(String name, [Map<String, Object>? parameters]) async {
    try {
      await FirebaseAnalytics.instance
          .logEvent(name: name, parameters: parameters);
    } catch (_) {
      // Firebase 미초기화(테스트) 또는 미지원 플랫폼 — 무시
    }
  }

  /// 구글 로그인 성공.
  Future<void> logLogin() async {
    try {
      await FirebaseAnalytics.instance.logLogin(loginMethod: 'google');
    } catch (_) {}
  }

  /// 운세 탭 진입 (기본 운세 노출).
  Future<void> logFortuneViewed() => _log('fortune_viewed');

  /// 보상형 광고 시청 완료 → AI 상세운세 잠금 해제.
  Future<void> logDetailedFortuneUnlocked() =>
      _log('detailed_fortune_unlocked', {'source': 'rewarded_ad'});

  /// 가족 기념일 추가.
  Future<void> logAnniversaryAdded({required String type}) =>
      _log('anniversary_added', {'type': type});

  /// 기념일 삭제.
  Future<void> logAnniversaryDeleted() => _log('anniversary_deleted');

  /// 프리미엄 구매 완료.
  Future<void> logPremiumPurchased({required String packageId}) =>
      _log('premium_purchased', {'package': packageId});

  /// 구매 복원 성공.
  Future<void> logPurchasesRestored() => _log('purchases_restored');
}
