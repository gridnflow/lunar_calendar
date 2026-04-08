import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;

import '../../../core/services/auth_service.dart';
import '../../../core/services/calendar_service.dart';
import '../../../core/services/lunar_service.dart';
import '../../../core/services/user_service.dart';

final _authServiceProvider = Provider((ref) => AuthService());
final _calendarServiceProvider = Provider(
  (ref) => CalendarService(ref.read(_authServiceProvider)),
);
final _lunarServiceProvider = Provider((ref) => LunarService());
final _userServiceProvider = Provider((ref) => UserService());

final _upcomingEventsProvider = FutureProvider<List<gcal.Event>>((ref) {
  return ref.read(_calendarServiceProvider).getUpcomingEvents();
});

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lunar = ref.read(_lunarServiceProvider);
    final eventsAsync = ref.watch(_upcomingEventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Calendar'),
            Text(lunar.todayLunarString(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_upcomingEventsProvider),
          ),
        ],
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (events) {
          if (events.isEmpty) {
            return const Center(child: Text('No upcoming events'));
          }
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, i) {
              final event = events[i];
              final date = event.start?.dateTime ?? event.start?.date;
              return ListTile(
                leading: const Icon(Icons.event),
                title: Text(event.summary ?? ''),
                subtitle: date != null
                    ? Text('${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}')
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRegisterBirthdayDialog(context, ref),
        icon: const Icon(Icons.cake),
        label: const Text('Add Lunar Birthday'),
      ),
    );
  }

  Future<void> _showRegisterBirthdayDialog(BuildContext context, WidgetRef ref) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final profile = await ref.read(_userServiceProvider).getProfile(uid);
    if (profile == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please set your birth info in Settings first')),
        );
      }
      return;
    }

    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Register Lunar Birthday'),
        content: Text(
          'Register your lunar birthday (${profile.birthMonth}월 ${profile.birthDay}일) '
          'to Google Calendar for the next 20 years?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Register')),
        ],
      ),
    );

    if (confirmed != true) return;

    final lunar = ref.read(_lunarServiceProvider);
    final dates = lunar.getLunarBirthdayDates(
      birthMonth: profile.birthMonth,
      birthDay: profile.birthDay,
    );

    await ref.read(_calendarServiceProvider).registerLunarBirthdays(
      name: profile.displayName,
      dates: dates,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${dates.length} birthday events registered!')),
      );
      ref.invalidate(_upcomingEventsProvider);
    }
  }
}
