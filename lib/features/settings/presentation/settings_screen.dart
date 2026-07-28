import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import 'settings_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _biometricLabel = 'Face ID and passcode';

  @override
  void initState() {
    super.initState();
    _queryBiometrics();
  }

  Future<void> _queryBiometrics() async {
    final bios = await ref.read(biometricServiceProvider).getAvailableBiometrics();
    if (mounted && bios.isNotEmpty) {
      setState(() {
        _biometricLabel = 'Biometric unlock';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final biometricLock = ref.watch(isBiometricLockEnabledProvider);
    final clearSeconds = ref.watch(clipboardClearSecondsProvider);

    return Scaffold(
      backgroundColor: context.colors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                      color: context.colors.ink,
                      letterSpacing: -0.15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: context.colors.ink2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // SECURITY Section
              Text(
                'SECURITY',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                  color: context.colors.ink4,
                ),
              ),
              const SizedBox(height: 4),

              // Rows
              _buildSwitchRow(
                title: _biometricLabel,
                subtitle: 'Required on open',
                value: biometricLock,
                onChanged: (val) {
                  ref.read(isBiometricLockEnabledProvider.notifier).setEnabled(val);
                },
              ),
              _buildOptionRow(
                title: 'Clear clipboard',
                value: '${clearSeconds}s',
                onTap: () {
                  final nextVal = clearSeconds == 15
                      ? 30
                      : (clearSeconds == 30 ? 60 : 15);
                  ref.read(clipboardClearSecondsProvider.notifier).setSeconds(nextVal);
                },
              ),
              _buildOptionRow(
                title: 'Theme Mode',
                value: ref.watch(themeModeProvider).name,
                onTap: () {
                  final current = ref.read(themeModeProvider);
                  final next = current == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
                  ref.read(themeModeProvider.notifier).setThemeMode(next);
                },
              ),

              _buildSwitchRow(
                title: 'Block screenshots',
                subtitle: 'Android only',
                value: true,
                onChanged: (_) {},
              ),

              const SizedBox(height: 20),

              // ACCOUNTS Section
              Text(
                'ACCOUNTS',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                  color: context.colors.ink4,
                ),
              ),
              const SizedBox(height: 4),

              _buildOptionRow(
                title: 'Reorder accounts',
                value: 'Tap to reorder',
                onTap: () => context.push('/reorder'),
              ),

              const Spacer(),

              // Footer
              Text(
                'HypAuth ${AppConstants.appVersion}\nNo network permission requested.',
                style: TextStyle(
                  fontSize: 11,
                  color: context.colors.ink4,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.colors.rule, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: context.colors.ink,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: context.colors.ink3,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            activeColor: context.colors.paper,
            activeTrackColor: context.colors.accent,
            inactiveTrackColor: context.colors.rule2,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionRow({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: context.colors.rule, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: context.colors.ink,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                color: context.colors.ink3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
