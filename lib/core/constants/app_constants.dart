class AppConstants {
  static const String appName = 'HypAuth';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String secureStorageSecretPrefix = 'totp_secret_';
  static const String biometricLockEnabledKey = 'biometric_lock_enabled';
  static const String themeModeKey = 'theme_mode';
  static const String clipboardAutoClearSecondsKey = 'clipboard_clear_seconds';
  
  // Defaults
  static const int defaultPeriod = 30;
  static const int defaultDigits = 6;
  static const String defaultAlgorithm = 'SHA1';
  static const int defaultClipboardClearSeconds = 30;
}
