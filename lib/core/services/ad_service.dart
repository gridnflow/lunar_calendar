import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// 테스트 ID → 릴리스 시 실제 AdMob ID로 교체하세요.
class AdIds {
  static const banner =
      'ca-app-pub-3940256099942544/6300978111';
  static const interstitial =
      'ca-app-pub-3940256099942544/1033173712';
  static const rewarded =
      'ca-app-pub-3940256099942544/5224354917';
}

class AdService {
  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // ── Interstitial ────────────────────────────────────────────────────────

  /// 전면 광고를 로드. 실제 로드 성공 여부를 반환.
  Future<bool> loadInterstitial() {
    final completer = Completer<bool>();
    InterstitialAd.load(
      adUnitId: AdIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial = ad;
          completer.complete(true);
        },
        onAdFailedToLoad: (_) {
          _interstitial = null;
          completer.complete(false);
        },
      ),
    );
    return completer.future;
  }

  /// 로드된 인터스티셜 광고를 표시하고 내부 참조 해제.
  void showInterstitial() {
    _interstitial?.show();
    _interstitial = null;
  }

  // ── Rewarded ────────────────────────────────────────────────────────────

  /// 보상형 광고를 로드. 실제 로드 성공 여부를 반환.
  Future<bool> loadRewarded() {
    final completer = Completer<bool>();
    RewardedAd.load(
      adUnitId: AdIds.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewarded = ad;
          completer.complete(true);
        },
        onAdFailedToLoad: (_) {
          _rewarded = null;
          completer.complete(false);
        },
      ),
    );
    return completer.future;
  }

  /// 보상형 광고를 표시. 시청 완료 시 [onRewarded] 호출.
  /// 광고가 준비되지 않았으면(네트워크 오류 등) 사용자 경험을 위해 즉시 보상.
  void showRewarded({required void Function() onRewarded}) {
    final ad = _rewarded;
    if (ad == null) {
      onRewarded();
      return;
    }
    ad.show(onUserEarnedReward: (_, reward) => onRewarded());
    _rewarded = null;
  }

  bool get isRewardedReady => _rewarded != null;
}
