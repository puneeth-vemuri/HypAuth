import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/clipboard_service.dart';
import '../../../core/services/totp_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../settings/presentation/settings_providers.dart';
import '../domain/models/account.dart';
import 'account_providers.dart';

final clipboardServiceProvider = Provider<ClipboardService>((ref) {
  final service = ClipboardService();
  ref.onDispose(() => service.dispose());
  return service;
});

class AccountRow extends ConsumerStatefulWidget {
  final Account account;
  final VoidCallback? onTap;
  final bool isSearchMatch;
  final String? searchQuery;

  const AccountRow({
    super.key,
    required this.account,
    this.onTap,
    this.isSearchMatch = false,
    this.searchQuery,
  });

  @override
  ConsumerState<AccountRow> createState() => _AccountRowState();
}

class _AccountRowState extends ConsumerState<AccountRow> {
  String? _secret;
  String _currentOtp = '------';
  int _remainingSeconds = 30;
  bool _copiedFlash = false;
  Timer? _flashTimer;

  @override
  void initState() {
    super.initState();
    _loadSecretAndGenerateOtp();
  }

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
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

  void _copyToClipboard() {
    final rawCode = _currentOtp.replaceAll(' ', '');
    final clearSeconds = ref.read(clipboardClearSecondsProvider);
    ref.read(clipboardServiceProvider).copyWithAutoClear(
          rawCode,
          clearAfterSeconds: clearSeconds,
        );

    HapticFeedback.lightImpact();

    setState(() => _copiedFlash = true);
    _flashTimer?.cancel();
    _flashTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _copiedFlash = false);
    });

    _showToast(context, 'Code copied', 'Clears in ${clearSeconds}s');
  }

  void _showToast(BuildContext context, String message, String hint) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 86,
        left: 21,
        right: 21,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.colors.ink,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: context.colors.paper,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  hint,
                  style: const TextStyle(
                    color: Color(0xFF9C9A91),
                    fontFamily: 'monospace',
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
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

    final codeColor = _copiedFlash
        ? context.colors.accent
        : (isWarning ? context.colors.danger : context.colors.ink);

    final trackColor = isWarning ? context.colors.danger : context.colors.accent;

    return InkWell(
      onTap: _copyToClipboard,
      onLongPress: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: context.colors.rule, width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Issuer
            _buildHighlightedText(
              widget.account.issuer,
              widget.searchQuery,
              const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: context.colors.ink,
              ),
            ),
            const SizedBox(height: 1),

            // Email / Account
            _buildHighlightedText(
              widget.account.accountName,
              widget.searchQuery,
              const TextStyle(
                fontSize: 11,
                color: context.colors.ink3,
              ),
            ),
            const SizedBox(height: 7),

            // Code
            Text(
              _currentOtp,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 27,
                letterSpacing: 1.62, // +0.06em
                fontWeight: FontWeight.w500,
                color: codeColor,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 10),

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
                      color: trackColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),

            // Seconds Counter
            Text(
              '${_remainingSeconds}s',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: isWarning ? context.colors.danger : context.colors.ink4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedText(
      String text, String? query, TextStyle baseStyle) {
    if (query == null || query.trim().isEmpty) {
      return Text(text, style: baseStyle);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
      return Text(text, style: baseStyle);
    }

    final before = text.substring(0, index);
    final match = text.substring(index, index + query.length);
    final after = text.substring(index + query.length);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: before, style: baseStyle),
          TextSpan(
            text: match,
            style: baseStyle.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: context.colors.accent,
              decorationThickness: 2,
            ),
          ),
          TextSpan(text: after, style: baseStyle),
        ],
      ),
    );
  }
}
