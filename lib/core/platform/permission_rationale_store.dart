import 'package:shared_preferences/shared_preferences.dart';

/// Persists whether we already showed a permission rationale dialog.
///
/// Goal: avoid nagging users with the same explanation every time they open the app.
class PermissionRationaleStore {
  static const _prefix = 'permission_rationale_shown:';

  Future<bool> wasShown(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_prefix$key') ?? false;
  }

  Future<void> markShown(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix$key', true);
  }

  Future<void> reset(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$key');
  }
}

