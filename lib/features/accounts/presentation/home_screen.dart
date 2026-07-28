import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import 'account_details_screen.dart';
import 'account_providers.dart';
import 'account_row.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsStream = ref.watch(accountsStreamProvider);
    final accounts = accountsStream.value ?? [];

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${accounts.length} ACCOUNTS',
                        style: const TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ink4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Codes',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ink,
                          letterSpacing: -0.15,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.push('/search'),
                        child: const Text(
                          'SEARCH',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.ink4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => context.push('/settings'),
                        child: const Text(
                          'SETTINGS',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.ink4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Account List / Empty State
              Expanded(
                child: accounts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'No accounts added yet',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.ink,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Scan a QR code to import your TOTP account.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.ink3,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: accounts.length,
                        itemBuilder: (context, index) {
                          final account = accounts[index];
                          return AccountRow(
                            key: ValueKey(account.id),
                            account: account,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AccountDetailsScreen(account: account),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),

              // Bottom Pill Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/scanner'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ink,
                    foregroundColor: AppColors.paper,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text('Add account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
