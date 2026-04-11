import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class CalendarService {
  final AuthService _authService;
  final gcal.CalendarApi? Function(String token)? _apiFactory;

  CalendarService(this._authService,
      {gcal.CalendarApi? Function(String token)? apiFactory})
      : _apiFactory = apiFactory;

  Future<gcal.CalendarApi?> _getApi() async {
    final token = await _authService.getGoogleAccessToken();
    if (token == null) return null;
    if (_apiFactory != null) return _apiFactory(token);
    return gcal.CalendarApi(_AuthClient(token));
  }

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
