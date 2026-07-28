import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/models/account.dart';
import 'account_details_screen.dart';
import 'account_providers.dart';
import 'account_row.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 120), () {
      ref.read(searchQueryProvider.notifier).state = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allAccounts = ref.watch(accountsStreamProvider).value ?? [];
    final filteredAccounts = ref.watch(filteredAccountsProvider);
    final query = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar Header
              Container(
                padding: const EdgeInsets.only(bottom: 14),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.ink, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.ink,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Search accounts...',
                          hintStyle: TextStyle(color: AppColors.ink4),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: _onSearchChanged,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_controller.text.isNotEmpty) {
                          _controller.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        } else {
                          context.pop();
                        }
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.ink4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Micro Label
              Text(
                '${filteredAccounts.length} OF ${allAccounts.length}'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ink4,
                ),
              ),
              const SizedBox(height: 6),

              // Results List / Empty State
              Expanded(
                child: filteredAccounts.isEmpty
                    ? Center(
                        child: Text(
                          query.isNotEmpty
                              ? 'No accounts match "$query"'
                              : 'Type to search accounts',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.ink3,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredAccounts.length,
                        itemBuilder: (context, index) {
                          final account = filteredAccounts[index];
                          return AccountRow(
                            account: account,
                            isSearchMatch: true,
                            searchQuery: query,
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

              // Footer
              const Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  'Searches issuer, account, and email.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.ink4,
                    height: 1.55,
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
