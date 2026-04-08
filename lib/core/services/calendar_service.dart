import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class CalendarService {
  final AuthService _authService;
  CalendarService(this._authService);

  Future<gcal.CalendarApi?> _getApi() async {
    final token = await _authService.getGoogleAccessToken();
    if (token == null) return null;
    final client = _AuthClient(token);
    return gcal.CalendarApi(client);
  }

  /// Insert a single event into the user's primary calendar.
  Future<void> insertEvent({
    required String title,
    required DateTime date,
    String? description,
  }) async {
    final api = await _getApi();
    if (api == null) return;

    final allDay = DateTime.utc(date.year, date.month, date.day);
    final nextDay = DateTime.utc(date.year, date.month, date.day + 1);

    final event = gcal.Event()
      ..summary = title
      ..description = description
      ..start = (gcal.EventDateTime()..date = allDay)
      ..end = (gcal.EventDateTime()..date = nextDay);

    await api.events.insert(event, 'primary');
  }

  /// Register all lunar birthday dates for the next [years] years.
  Future<void> registerLunarBirthdays({
    required String name,
    required List<DateTime> dates,
  }) async {
    for (final date in dates) {
      await insertEvent(
        title: '🌙 $name 음력생일',
        date: date,
        description: 'Lunar calendar birthday for $name',
      );
    }
  }

  /// Fetch upcoming events from the primary calendar.
  Future<List<gcal.Event>> getUpcomingEvents({int maxResults = 30}) async {
    final api = await _getApi();
    if (api == null) return [];

    final events = await api.events.list(
      'primary',
      timeMin: DateTime.now().toUtc(),
      maxResults: maxResults,
      singleEvents: true,
      orderBy: 'startTime',
    );
    return events.items ?? [];
  }
}

class _AuthClient extends http.BaseClient {
  final String _token;
  final _inner = http.Client();
  _AuthClient(this._token);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_token';
    return _inner.send(request);
  }
}
