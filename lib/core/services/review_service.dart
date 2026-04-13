import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  static const _viewCountKey = 'fortune_view_count';
  static const _firstOpenKey = 'first_open_date';
  static const _reviewDoneKey = 'review_requested';

  static const int _minViews = 3;
  static const int _minDays = 3;

  /// Call this every time the user views the fortune screen.
  /// Returns true if the review prompt was shown.
  Future<bool> recordFortuneViewAndMaybeReview() async {
    final prefs = await SharedPreferences.getInstance();

    // Already requested once — don't ask again
    if (prefs.getBool(_reviewDoneKey) ?? false) return false;

    // Record first open date
    final now = DateTime.now();
    if (!prefs.containsKey(_firstOpenKey)) {
      await prefs.setString(_firstOpenKey, now.toIso8601String());
    }

    // Increment view count
    final count = (prefs.getInt(_viewCountKey) ?? 0) + 1;
    await prefs.setInt(_viewCountKey, count);

    // Check conditions
    if (count < _minViews) return false;

    final firstOpenStr = prefs.getString(_firstOpenKey)!;
    final firstOpen = DateTime.parse(firstOpenStr);
    final daysSinceInstall = now.difference(firstOpen).inDays;
    if (daysSinceInstall < _minDays) return false;

    // All conditions met — request review
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
      await prefs.setBool(_reviewDoneKey, true);
      return true;
    }

    return false;
  }
}
