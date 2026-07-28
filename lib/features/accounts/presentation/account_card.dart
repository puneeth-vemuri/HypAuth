import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/totp_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/countdown_ring.dart';
import '../../../core/widgets/custom_toast.dart';
import '../domain/models/account.dart';
import 'account_providers.dart';

import '../../../core/services/clipboard_service.dart';
import '../../settings/presentation/settings_providers.dart';
import '../../../core/theme/app_theme.dart';

final clipboardServiceProvider = Provider<ClipboardService>((ref) {
  final service = ClipboardService();
  ref.onDispose(() => service.dispose());
  return service;
});

class AccountCard extends ConsumerStatefulWidget {
  final Account account;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const AccountCard({
    super.key,
    required this.account,
    this.onTap,
    this.onDelete,
  });

  @override
  ConsumerState<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends ConsumerState<AccountCard> {
  String? _secret;
  String _currentOtp = '------';
  int _remainingSeconds = 30;

  @override
  void initState() {
    super.initState();
    _loadSecretAndGenerateOtp();
  }

  Future<void> _loadSecretAndGenerateOtp() async {
    final secret = await ref.read(accountNotifierProvider.notifier).getSecret(widget.account.id);
    if (mounted && secret != null) {
      setState(() {
        _secret = secret;
        _updateOtp();
      });
    }
  }

  void _updateOtp() {
    if (_secret == null) return;
    try {
      final code = TotpService.generateTotp(
        secret: _secret!,
        algorithm: widget.account.algorithm,
        digits: widget.account.digits,
        period: widget.account.period,
      );
      final remaining = TotpService.getRemainingSeconds(period: widget.account.period);
      if (mounted) {
        setState(() {
          _currentOtp = _formatOtp(code);
          _remainingSeconds = remaining;
        });
      }
    } catch (_) {}
  }

  String _formatOtp(String code) {
    if (code.length == 6) {
      return '${code.substring(0, 3)} ${code.substring(3)}';
    } else if (code.length == 8) {
      return '${code.substring(0, 4)} ${code.substring(4)}';
    }
    return code;
  }

  void _copyToClipboard() {
    final rawCode = _currentOtp.replaceAll(' ', '');
    final clearSeconds = ref.read(clipboardClearSecondsProvider);
    ref.read(clipboardServiceProvider).copyWithAutoClear(
      rawCode,
      clearAfterSeconds: clearSeconds,
    );
    HapticFeedback.lightImpact();
    CustomToast.show(context, 'Copied $rawCode to clipboard (clears in ${clearSeconds}s)');
  }

  IconData _getIssuerIcon(String iconKey) {
    switch (iconKey.toLowerCase()) {
      case 'github':
        return Icons.code;
      case 'google':
        return Icons.g_mobiledata;
      case 'discord':
        return Icons.chat_bubble_outline;
      case 'aws':
        return Icons.cloud_outlined;
      case 'microsoft':
        return Icons.window;
      case 'crypto':
        return Icons.currency_bitcoin;
      default:
        return Icons.shield_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to 1-second ticker to regenerate OTP seamlessly
    ref.listen<AsyncValue<int>>(secondsTickerProvider, (prev, next) {
      if (next.hasValue) {
        _updateOtp();
      }
    });

    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: _copyToClipboard,
        onLongPress: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Issuer Icon Badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIssuerIcon(widget.account.icon),
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),

              // Issuer & Account Labels
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.account.issuer,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.account.isFavorite) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: Colors.amber,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.account.accountName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Animated OTP Code Display
                    Text(
                      _currentOtp,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: _remainingSeconds <= 5
                            ? AppColors.darkError
                            : theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // Countdown Ring & Copy Button
              Column(
                children: [
                  CountdownRing(
                    remainingSeconds: _remainingSeconds,
                    totalPeriod: widget.account.period,
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 20),
                    onPressed: _copyToClipboard,
                    tooltip: 'Copy OTP',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
