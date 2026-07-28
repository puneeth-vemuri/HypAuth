import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class RemoveConfirmationSheet extends StatelessWidget {
  final String issuer;
  final VoidCallback onConfirmRemove;

  const RemoveConfirmationSheet({
    super.key,
    required this.issuer,
    required this.onConfirmRemove,
  });

  static Future<void> show(
    BuildContext context, {
    required String issuer,
    required VoidCallback onConfirmRemove,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => RemoveConfirmationSheet(
        issuer: issuer,
        onConfirmRemove: onConfirmRemove,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: context.colors.paper,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Remove $issuer?',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w500,
              color: context.colors.ink,
              letterSpacing: -0.15,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            'The secret is erased from this device immediately. You will be locked out of this account unless you still have its recovery codes.',
            style: TextStyle(
              fontSize: 12,
              color: context.colors.ink3,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirmRemove();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.danger,
                foregroundColor: context.colors.paper,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text('Remove'),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Keep it',
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
    );
  }
}
