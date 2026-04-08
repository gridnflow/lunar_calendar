import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  // Sign-in uses only basic scopes; calendar scope is requested lazily.
  static const List<String> _basicScopes = ['email', 'profile'];
  static const String _calendarScope =
      'https://www.googleapis.com/auth/calendar';

  AuthService({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
      : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn =
            googleSignIn ?? GoogleSignIn(scopes: _basicScopes);

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  /// Returns the OAuth access token needed for Google Calendar API calls.
  /// Requests the calendar scope on first use if not already granted.
  Future<String?> getGoogleAccessToken() async {
    final account =
        _googleSignIn.currentUser ?? await _googleSignIn.signInSilently();
    if (account == null) return null;

    // Request calendar scope if not yet granted.
    final hasCalendar = await _googleSignIn.requestScopes([_calendarScope]);
    if (!hasCalendar) return null;

    final auth = await account.authentication;
    return auth.accessToken;
  }

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }
}
