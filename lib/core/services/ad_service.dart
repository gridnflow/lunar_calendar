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

  Future<void> loadInterstitial() async {
    await InterstitialAd.load(
      adUnitId: AdIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (_) => _interstitial = null,
      ),
    );
  }

  /// 로드된 인터스티셜 광고를 표시하고 내부 참조 해제.
  void showInterstitial() {
    _interstitial?.show();
    _interstitial = null;
  }

  // ── Rewarded ────────────────────────────────────────────────────────────

  Future<void> loadRewarded() async {
    await RewardedAd.load(
      adUnitId: AdIds.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewarded = ad,
        onAdFailedToLoad: (_) => _rewarded = null,
      ),
    );
  }

  /// 보상형 광고를 표시. 시청 완료 시 [onRewarded] 호출.
  void showRewarded({required void Function() onRewarded}) {
    final ad = _rewarded;
    if (ad == null) {
      onRewarded(); // 광고 없으면 바로 보상 지급
      return;
    }
    ad.show(onUserEarnedReward: (_, reward) => onRewarded());
    _rewarded = null;
  }

  bool get isRewardedReady => _rewarded != null;
}
