import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/family/presentation/family_screen.dart';
import '../../features/fortune/presentation/fortune_screen.dart';
import '../../features/onboarding/presentation/language_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../providers/service_providers.dart';
import '../services/ad_service.dart'; // AdIds.banner
import '../../l10n/app_localizations.dart';

final _authStreamProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final routerProvider = Provider<GoRouter>((ref) {
  // Use a ValueNotifier so GoRouter is created ONCE and only refreshes
  // its redirect logic — not recreated — when auth/profile state changes.
  final notifier = ValueNotifier<int>(0);

  ref.listen(_authStreamProvider, (prev, next) => notifier.value++);
  ref.listen(userProfileProvider, (prev, next) => notifier.value++);

  final router = GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(_authStreamProvider);
      final profileAsync = ref.read(userProfileProvider);

      final isLoggedIn = authState.valueOrNull != null;
      final loc = state.matchedLocation;

      if (!isLoggedIn) {
        return loc == '/login' ? null : '/login';
      }

      // 로그인됐지만 프로필 아직 로딩 중 → 대기
      if (profileAsync.isLoading) return null;

      final profile = profileAsync.valueOrNull;
      final needsOnboarding = profile == null;
      final onOnboardingFlow = loc == '/language' || loc == '/onboarding';

      if (needsOnboarding && !onOnboardingFlow) return '/language';
      if (!needsOnboarding && (loc == '/login' || loc == '/onboarding')) {
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
        path: '/language',
        builder: (context, state) => const LanguageScreen(),
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
            path: '/family',
            builder: (context, state) => const FamilyScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );

  ref.onDispose(() {
    notifier.dispose();
    router.dispose();
  });

  return router;
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

  static const _routes = ['/calendar', '/fortune', '/family', '/settings'];

  @override
  void initState() {
    super.initState();
    _loadBanner();
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
            destinations: [
              NavigationDestination(
                  icon: const Icon(Icons.calendar_month),
                  label: AppLocalizations.of(context)!.navCalendar),
              NavigationDestination(
                  icon: const Icon(Icons.auto_awesome),
                  label: AppLocalizations.of(context)!.navFortune),
              NavigationDestination(
                  icon: const Icon(Icons.people_outline),
                  label: AppLocalizations.of(context)!.navFamily),
              NavigationDestination(
                  icon: const Icon(Icons.settings),
                  label: AppLocalizations.of(context)!.navSettings),
            ],
          ),
        ],
      ),
    );
  }
}
