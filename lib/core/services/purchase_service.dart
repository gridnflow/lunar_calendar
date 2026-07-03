import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCat 기반 프리미엄 구독/구매 관리 (앱 전역 싱글턴).
/// .env에 REVENUECAT_ANDROID_KEY / REVENUECAT_IOS_KEY가 없으면
/// 모든 메서드는 조용히 무료 상태로 동작합니다 (개발 환경 안전).
class PurchaseService {
  PurchaseService._();
  static final PurchaseService instance = PurchaseService._();
  factory PurchaseService() => instance;

  static const entitlementId = 'premium';

  static bool _configured = false;

  /// RevenueCat SDK 설정 완료 여부.
  bool get isConfigured => _configured;

  final _premiumController = StreamController<bool>.broadcast();

  /// 프리미엄 상태 변경 스트림 (구매/복원/만료 시 발행).
  Stream<bool> get premiumStream => _premiumController.stream;

  /// 앱 시작 시 1회 호출. API 키가 없거나 미지원 플랫폼이면 no-op.
  Future<void> initialize() async {
    if (_configured || kIsWeb) return;
    final String? apiKey;
    if (Platform.isAndroid) {
      apiKey = dotenv.maybeGet('REVENUECAT_ANDROID_KEY');
    } else if (Platform.isIOS || Platform.isMacOS) {
      apiKey = dotenv.maybeGet('REVENUECAT_IOS_KEY');
    } else {
      apiKey = null;
    }
    if (apiKey == null || apiKey.isEmpty) return;

    try {
      await Purchases.configure(PurchasesConfiguration(apiKey));
      Purchases.addCustomerInfoUpdateListener((info) {
        _premiumController.add(_hasPremium(info));
      });
      _configured = true;
    } catch (_) {
      // 스토어 미연결 등 — 무료 상태로 계속 동작
    }
  }

  bool _hasPremium(CustomerInfo info) =>
      info.entitlements.active.containsKey(entitlementId);

  /// 현재 프리미엄 활성 여부.
  Future<bool> isPremium() async {
    if (!_configured) return false;
    try {
      return _hasPremium(await Purchases.getCustomerInfo());
    } catch (_) {
      return false;
    }
  }

  /// 현재 오퍼링의 판매 가능 패키지 목록 (월간/연간 등).
  Future<List<Package>> getPackages() async {
    if (!_configured) return const [];
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current?.availablePackages ?? const [];
    } catch (_) {
      return const [];
    }
  }

  /// 패키지 구매. 구매 후 프리미엄 활성 여부를 반환.
  /// 사용자가 취소하면 false (예외를 밖으로 던지지 않음).
  Future<bool> purchase(Package package) async {
    if (!_configured) return false;
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      return _hasPremium(result.customerInfo);
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) return false;
      rethrow;
    }
  }

  /// 구매 복원. 복원 후 프리미엄 활성 여부를 반환.
  Future<bool> restore() async {
    if (!_configured) return false;
    try {
      return _hasPremium(await Purchases.restorePurchases());
    } catch (_) {
      return false;
    }
  }
}
