import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/biometric_service.dart';

// Biometric lock status
final biometricServiceProvider = Provider<BiometricService>((ref) => BiometricService());

final isBiometricLockEnabledProvider = StateProvider<bool>((ref) => false);
final isAppUnlockedProvider = StateProvider<bool>((ref) => true);

// Settings Providers
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);
final clipboardClearSecondsProvider = StateProvider<int>((ref) => 30);
