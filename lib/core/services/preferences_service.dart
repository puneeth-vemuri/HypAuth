import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  // Fallback storage for Database and SecureStorage
  String? getFallbackData(String key) => _prefs.getString(key);
  Future<void> saveFallbackData(String key, String value) => _prefs.setString(key, value);
  Future<void> removeFallbackData(String key) => _prefs.remove(key);
  Future<void> clearAllFallbackData(String prefix) async {
    final keys = _prefs.getKeys().where((k) => k.startsWith(prefix)).toList();
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }

  // Settings
  bool get isBiometricLockEnabled => _prefs.getBool('biometric_lock_enabled') ?? false;
  Future<void> setBiometricLockEnabled(bool value) => _prefs.setBool('biometric_lock_enabled', value);

  int get themeModeIndex => _prefs.getInt('theme_mode') ?? 2; // Default to dark (ThemeMode.dark.index)
  Future<void> setThemeModeIndex(int index) => _prefs.setInt('theme_mode', index);

  int get clipboardClearSeconds => _prefs.getInt('clipboard_clear_seconds') ?? 30;
  Future<void> setClipboardClearSeconds(int seconds) => _prefs.setInt('clipboard_clear_seconds', seconds);
}
