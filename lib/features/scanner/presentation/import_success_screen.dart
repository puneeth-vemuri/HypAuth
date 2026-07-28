import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../accounts/domain/models/account.dart';

class ImportSuccessScreen extends StatelessWidget {
  final Account account;
  final VoidCallback onScanAnother;

  const ImportSuccessScreen({
    super.key,
    required this.account,
    required this.onScanAnother,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Text(
                'ADDED',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                  color: context.colors.accent,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                account.issuer,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: context.colors.ink,
                  letterSpacing: -0.15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                account.accountName,
                style: const TextStyle(
                  fontSize: 12,
                  color: context.colors.ink3,
                ),
              ),
              const SizedBox(height: 26),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: context.colors.rule, width: 1),
                  ),
                ),
                child: Column(
                  children: [
                    _buildKvRow('Algorithm', account.algorithm),
                    _buildKvRow('Digits', '${account.digits}'),
                    _buildKvRow('Period', '${account.period}s', isLast: true),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.ink,
                    foregroundColor: context.colors.paper,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text('Done'),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: onScanAnother,
                  child: const Text(
                    'Scan another',
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

  Widget _buildKvRow(String key, String val, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
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
            style: const TextStyle(
              fontSize: 12,
              color: context.colors.ink3,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            val,
            style: const TextStyle(
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
