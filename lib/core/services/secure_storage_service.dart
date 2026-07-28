import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;
  final Map<String, String> _inMemoryFallback = {}; // Fallback for unit testing/desktop mock

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  String _formatKey(String accountId) => '${AppConstants.secureStorageSecretPrefix}$accountId';

  Future<void> saveSecret({required String accountId, required String secret}) async {
    try {
      await _storage.write(key: _formatKey(accountId), value: secret);
    } catch (_) {
      _inMemoryFallback[_formatKey(accountId)] = secret;
    }
  }

  Future<String?> getSecret(String accountId) async {
    try {
      final val = await _storage.read(key: _formatKey(accountId));
      if (val != null) return val;
      return _inMemoryFallback[_formatKey(accountId)];
    } catch (_) {
      return _inMemoryFallback[_formatKey(accountId)];
    }
  }

  Future<void> deleteSecret(String accountId) async {
    try {
      await _storage.delete(key: _formatKey(accountId));
    } catch (_) {}
    _inMemoryFallback.remove(_formatKey(accountId));
  }

  Future<void> clearAllSecrets() async {
    try {
      await _storage.deleteAll();
    } catch (_) {}
    _inMemoryFallback.clear();
  }
}
