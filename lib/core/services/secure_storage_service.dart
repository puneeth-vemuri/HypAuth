import '../constants/app_constants.dart';
import 'preferences_service.dart';

/// Secure storage service managing OTP secrets.
/// This bypasses FlutterSecureStorage to ensure compatibility with unsigned iOS builds
/// (sideloading) where Keychain access is blocked by the OS sandbox.
class SecureStorageService {
  final PreferencesService _prefs;

  SecureStorageService(this._prefs);

  String _formatKey(String accountId) => '${AppConstants.secureStorageSecretPrefix}$accountId';

  Future<void> saveSecret({required String accountId, required String secret}) async {
    await _prefs.saveFallbackData(_formatKey(accountId), secret);
  }

  Future<String?> getSecret(String accountId) async {
    return _prefs.getFallbackData(_formatKey(accountId));
  }

  Future<void> deleteSecret(String accountId) async {
    await _prefs.removeFallbackData(_formatKey(accountId));
  }

  Future<void> clearAllSecrets() async {
    await _prefs.clearAllFallbackData(AppConstants.secureStorageSecretPrefix);
  }
}
