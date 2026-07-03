import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/providers/service_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/night_sky.dart';
import '../../../l10n/app_localizations.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: NightSky(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 5),
                Text(
                  l.appTitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 14),
                // 골드 라인 장식
                Container(
                  width: 36,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: AppTheme.goldAccentGradient,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  l.loginTagline,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: 0.75),
                    letterSpacing: 0.3,
                    height: 1.5,
                  ),
                ),
                const Spacer(flex: 4),
                FilledButton.icon(
                  onPressed: () => _signIn(context, ref),
                  icon: const Icon(Icons.login),
                  label: Text(l.loginGoogle),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryLight,
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signIn(BuildContext context, WidgetRef ref) async {
    try {
      final credential = await ref.read(authServiceProvider).signInWithGoogle();
      final user = credential.user!;

      await ref.read(userServiceProvider).createFromGoogleUser(user);
      ref.read(analyticsServiceProvider).logLogin();

      final fcmToken = await ref.read(notificationServiceProvider).getToken();
      if (fcmToken != null) {
        await ref.read(userServiceProvider).saveFcmToken(user.uid, fcmToken);
      }

      await ref.read(notificationServiceProvider).subscribeToTopic('daily_fortune');

      if (context.mounted) context.go('/calendar');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-in failed: $e')),
        );
      }
    }
  }
}
