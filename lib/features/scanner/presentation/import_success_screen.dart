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
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Text(
                'ADDED',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                  color: context.colors.accent,
                ),
              ),
              SizedBox(height: 10),
              Text(
                account.issuer,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: context.colors.ink,
                  letterSpacing: -0.15,
                ),
              ),
              SizedBox(height: 4),
              Text(
                account.accountName,
                style: TextStyle(
                  fontSize: 12,
                  color: context.colors.ink3,
                ),
              ),
              SizedBox(height: 26),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: context.colors.rule, width: 1),
                  ),
                ),
                child: Column(
                  children: [
                    _buildKvRow(context, 'Algorithm', account.algorithm),
                    _buildKvRow(context, 'Digits', '${account.digits}'),
                    _buildKvRow(context, 'Period', '${account.period}s', isLast: true),
                  ],
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.ink,
                    foregroundColor: context.colors.paper,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text('Done'),
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: onScanAnother,
                  child: Text(
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

  Widget _buildKvRow(BuildContext context, String key, String val, {bool isLast = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
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
