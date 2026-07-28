import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/biometric_service.dart';

import '../../../core/services/preferences_service.dart';

// Biometric lock status
final biometricServiceProvider = Provider<BiometricService>((ref) => BiometricService());
final preferencesServiceProvider = Provider<PreferencesService>((ref) => throw UnimplementedError());

class BiometricLockNotifier extends Notifier<bool> {
  @override
  bool build() {
    return ref.read(preferencesServiceProvider).isBiometricLockEnabled;
  }

  void setEnabled(bool value) {
    ref.read(preferencesServiceProvider).setBiometricLockEnabled(value);
    state = value;
  }
}

final isBiometricLockEnabledProvider = NotifierProvider<BiometricLockNotifier, bool>(() => BiometricLockNotifier());

// We only lock the app if biometric lock is actually enabled in preferences
final isAppUnlockedProvider = StateProvider<bool>((ref) {
  return !ref.read(preferencesServiceProvider).isBiometricLockEnabled;
});

// Settings Providers
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final index = ref.read(preferencesServiceProvider).themeModeIndex;
    return ThemeMode.values[index];
  }

  void setThemeMode(ThemeMode mode) {
    ref.read(preferencesServiceProvider).setThemeModeIndex(mode.index);
    state = mode;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() => ThemeModeNotifier());

class ClipboardClearSecondsNotifier extends Notifier<int> {
  @override
  int build() {
    return ref.read(preferencesServiceProvider).clipboardClearSeconds;
  }

  void setSeconds(int seconds) {
    ref.read(preferencesServiceProvider).setClipboardClearSeconds(seconds);
    state = seconds;
  }
}

final clipboardClearSecondsProvider = NotifierProvider<ClipboardClearSecondsNotifier, int>(() => ClipboardClearSecondsNotifier());

