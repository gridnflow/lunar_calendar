import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/service_providers.dart';
import '../../../l10n/app_localizations.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.3),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primaryContainer,
                    ),
                    child: Icon(Icons.calendar_month, size: 52, color: colorScheme.primary),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    l.appTitle,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  FilledButton.icon(
                    onPressed: () => _signIn(context, ref),
                    icon: const Icon(Icons.login),
                    label: Text(l.loginGoogle),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
                ],
              ),
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
