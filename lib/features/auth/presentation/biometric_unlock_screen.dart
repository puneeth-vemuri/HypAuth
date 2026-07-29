import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/hypauth_logo_mark.dart';
import '../../settings/presentation/settings_providers.dart';

class BiometricUnlockScreen extends ConsumerStatefulWidget {
  final Widget child;

  const BiometricUnlockScreen({super.key, required this.child});

  @override
  ConsumerState<BiometricUnlockScreen> createState() => _BiometricUnlockScreenState();
}

class _BiometricUnlockScreenState extends ConsumerState<BiometricUnlockScreen>
    with WidgetsBindingObserver {
  bool _failed = false;
  String _biometricName = 'Face ID';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkBiometricsAndAuthenticate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final enabled = ref.read(isBiometricLockEnabledProvider);
    if (!enabled) return;

    if (state == AppLifecycleState.paused) {
      ref.read(isAppUnlockedProvider.notifier).state = false;
    } else if (state == AppLifecycleState.resumed) {
      final unlocked = ref.read(isAppUnlockedProvider);
      if (!unlocked) {
        _triggerAuthentication();
      }
    }
  }

  Future<void> _checkBiometricsAndAuthenticate() async {
    final service = ref.read(biometricServiceProvider);
    final bios = await service.getAvailableBiometrics();
    if (bios.isEmpty) {
      setState(() => _biometricName = 'Biometrics');
    }
    await _triggerAuthentication();
  }

  Future<void> _triggerAuthentication() async {
    final enabled = ref.read(isBiometricLockEnabledProvider);
    if (!enabled) {
      ref.read(isAppUnlockedProvider.notifier).state = true;
      return;
    }

    final service = ref.read(biometricServiceProvider);
    final authenticated = await service.authenticate(
      localizedReason: 'Unlock HypAuth',
    );

    if (authenticated && mounted) {
      setState(() => _failed = false);
      ref.read(isAppUnlockedProvider.notifier).state = true;
    } else if (mounted) {
      setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = ref.watch(isAppUnlockedProvider);

    if (unlocked) {
      return widget.child;
    }

    return Scaffold(
      backgroundColor: context.colors.paper,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              HypAuthLogoMark(size: 36, color: context.colors.ink),
              SizedBox(height: 24),
              if (_failed) ...[
                Text(
                  '$_biometricName NOT RECOGNISED'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500,
                    color: context.colors.danger,
                  ),
                ),
                SizedBox(height: 8),
              ],
              Text(
                'Try again, or\nuse your passcode',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.26,
                  height: 1.25,
                  color: context.colors.ink,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Your codes never leave this device, so there is no way to recover them remotely.',
                style: TextStyle(
                  fontSize: 12,
                  color: context.colors.ink3,
                  height: 1.6,
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _triggerAuthentication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.ink,
                    foregroundColor: context.colors.paper,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text('Try $_biometricName again'),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _triggerAuthentication,
                  child: Text(
                    'Enter passcode',
                    style: TextStyle(
                      fontSize: 13,
                      color: context.colors.ink2,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
