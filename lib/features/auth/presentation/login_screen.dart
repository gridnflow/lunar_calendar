import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/user_service.dart';

final _authServiceProvider = Provider((ref) => AuthService());
final _userServiceProvider = Provider((ref) => UserService());
final _notificationServiceProvider = Provider((ref) => NotificationService());

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(_authServiceProvider);
    final userService = ref.read(_userServiceProvider);
    final notificationService = ref.read(_notificationServiceProvider);

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
                  onPressed: () async {
                    try {
                      final credential = await authService.signInWithGoogle();
                      final user = credential.user!;

                      // Create Firestore profile entry if first sign-in
                      await userService.createFromGoogleUser(user);

                      // Save FCM token for push notifications
                      final fcmToken = await notificationService.getToken();
                      if (fcmToken != null) {
                        await userService.saveFcmToken(user.uid, fcmToken);
                      }

                      // Subscribe to daily fortune topic
                      await notificationService.subscribeToTopic('daily_fortune');

                      if (context.mounted) context.go('/calendar');
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sign-in failed: $e')),
                        );
                      }
                    }
                  },
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
}
