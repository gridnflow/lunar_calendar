import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/service_providers.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_month, size: 80, color: Color(0xFF1A237E)),
                const SizedBox(height: 24),
                const Text(
                  'Lunar Calendar',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  '음력 달력 · 오늘의 운세 · 일정 관리',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 48),
                FilledButton.icon(
                  onPressed: () => _signIn(context, ref),
                  icon: const Icon(Icons.login),
                  label: const Text('Sign in with Google'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
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
