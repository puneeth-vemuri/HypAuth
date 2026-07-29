import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/totp_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_toast.dart';
import '../domain/models/account.dart';
import 'account_providers.dart';
import 'remove_confirmation_sheet.dart';

class AccountDetailsScreen extends ConsumerStatefulWidget {
  final Account account;

  const AccountDetailsScreen({super.key, required this.account});

  @override
  ConsumerState<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends ConsumerState<AccountDetailsScreen> {
  String? _secret;
  String _currentOtp = '------';
  int _remainingSeconds = 30;

  @override
  void initState() {
    super.initState();
    _loadSecretAndGenerateOtp();
  }

  Future<void> _loadSecretAndGenerateOtp() async {
    final secret =
        await ref.read(accountNotifierProvider.notifier).getSecret(widget.account.id);
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

  void _confirmDelete() {
    RemoveConfirmationSheet.show(
      context,
      issuer: widget.account.issuer,
      onConfirmRemove: () async {
        await ref
            .read(accountNotifierProvider.notifier)
            .deleteAccount(widget.account.id);
        if (mounted) {
          Navigator.pop(context);
          CustomToast.show(context, 'Account removed');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<int>>(secondsTickerProvider, (prev, next) {
      if (next.hasValue) {
        _updateOtp();
      }
    });

    final isWarning = _remainingSeconds <= 10;
    final progressRatio = _remainingSeconds / widget.account.period;
    final createdStr =
        '${widget.account.createdAt.day.toString().padLeft(2, '0')}.${widget.account.createdAt.month.toString().padLeft(2, '0')}.${widget.account.createdAt.year.toString().substring(2)}';

    return Scaffold(
      backgroundColor: context.colors.paper,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 21.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'BACK',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w500,
                        color: context.colors.ink2,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ref
                          .read(accountNotifierProvider.notifier)
                          .toggleFavorite(widget.account.id);
                    },
                    child: Text(
                      'PIN',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w500,
                        color: widget.account.isFavorite
                            ? context.colors.accent
                            : context.colors.ink4,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 26),

              // Issuer & Email
              Text(
                widget.account.issuer.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                  color: context.colors.ink4,
                ),
              ),
              SizedBox(height: 4),
              Text(
                widget.account.accountName,
                style: TextStyle(
                  fontSize: 12,
                  color: context.colors.ink3,
                ),
              ),
              SizedBox(height: 20),

              // Large 40px Mono Code
              Text(
                _currentOtp,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 40,
                  letterSpacing: 1.6, // +0.04em
                  fontWeight: FontWeight.w500,
                  color: isWarning ? context.colors.danger : context.colors.ink,
                  height: 1.0,
                ),
              ),
              SizedBox(height: 16),

              // Track Bar
              Container(
                height: 2,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.colors.rule,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progressRatio.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isWarning ? context.colors.danger : context.colors.accent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 7),

              // Seconds Counter
              Text(
                'Refreshes in ${_remainingSeconds}s',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: isWarning ? context.colors.danger : context.colors.ink4,
                ),
              ),
              SizedBox(height: 26),

              // Key Values List
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: context.colors.rule, width: 1),
                  ),
                ),
                child: Column(
                  children: [
                    _buildKvRow('Algorithm', widget.account.algorithm),
                    _buildKvRow(
                        'Digits, period', '${widget.account.digits}, ${widget.account.period}s'),
                    _buildKvRow('Added', createdStr, isLast: true),
                  ],
                ),
              ),

              Spacer(),

              // Remove Account Outlined Red Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _confirmDelete,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.colors.danger,
                    side: BorderSide(color: context.colors.dangerRule, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Remove account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKvRow(String key, String val, {bool isLast = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: context.colors.rule, width: 1),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: TextStyle(
              fontSize: 12,
              color: context.colors.ink3,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            val,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: context.colors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
