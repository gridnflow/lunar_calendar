import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/fortune/presentation/fortune_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../providers/service_providers.dart';
import '../services/ad_service.dart';

final _authStreamProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(_authStreamProvider);
  final profileAsync = ref.watch(userProfileProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final loc = state.matchedLocation;

      if (!isLoggedIn) {
        return loc == '/login' ? null : '/login';
      }

      // 로그인됐지만 프로필 아직 로딩 중 → 대기
      if (profileAsync.isLoading) return null;

      final profile = profileAsync.valueOrNull;
      final needsOnboarding = profile == null;
      final onOnboarding = loc == '/onboarding';

      if (needsOnboarding && !onOnboarding) return '/onboarding';
      if (!needsOnboarding && (loc == '/login' || onOnboarding)) {
        return '/calendar';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/calendar',
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: '/fortune',
            builder: (context, state) => const FortuneScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});

class MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;
  BannerAd? _bannerAd;
  bool _bannerLoaded = false;

  static const _routes = ['/calendar', '/fortune', '/settings'];

  @override
  void initState() {
    super.initState();
    _loadBanner();
    _showInterstitialOnEntry();
  }

  void _loadBanner() {
    _bannerAd = BannerAd(
      adUnitId: AdIds.banner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _bannerLoaded = true),
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          _bannerAd = null;
        },
      ),
    )..load();
  }

  void _showInterstitialOnEntry() async {
    final adService = ref.read(adServiceProvider);
    await adService.loadInterstitial();
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) adService.showInterstitial();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_bannerLoaded && _bannerAd != null)
            SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
              context.go(_routes[index]);
            },
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.calendar_month), label: 'Calendar'),
              NavigationDestination(
                  icon: Icon(Icons.auto_awesome), label: 'Fortune'),
              NavigationDestination(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        ],
      ),
    );
  }
}
