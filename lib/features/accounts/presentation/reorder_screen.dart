import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/models/account.dart';
import 'account_providers.dart';

class ReorderScreen extends ConsumerStatefulWidget {
  const ReorderScreen({super.key});

  @override
  ConsumerState<ReorderScreen> createState() => _ReorderScreenState();
}

class _ReorderScreenState extends ConsumerState<ReorderScreen> {
  List<Account> _accounts = [];

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  void _loadAccounts() {
    final current = ref.read(accountsStreamProvider).value ?? [];
    setState(() {
      _accounts = List.from(current);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<Account>>>(accountsStreamProvider, (prev, next) {
      if (next.hasValue && _accounts.isEmpty) {
        setState(() {
          _accounts = List.from(next.value!);
        });
      }
    });

    return Scaffold(
      backgroundColor: context.colors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21.0, vertical: 14.0),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reorder',
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
                      'Done',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: context.colors.accent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Reorderable List
              Expanded(
                child: ReorderableListView.builder(
                  itemCount: _accounts.length,
                  onReorderStart: (_) {
                    HapticFeedback.mediumImpact();
                  },
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex -= 1;
                    setState(() {
                      final item = _accounts.removeAt(oldIndex);
                      _accounts.insert(newIndex, item);
                    });
                    ref
                        .read(accountNotifierProvider.notifier)
                        .reorderAccounts(_accounts);
                  },
                  itemBuilder: (context, index) {
                    final account = _accounts[index];
                    return Container(
                      key: ValueKey(account.id),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: context.colors.rule, width: 1),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Handle Icon
                          Icon(
                            Icons.drag_handle,
                            size: 20,
                            color: Color(0xFFC9C7BE),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  account.issuer,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: context.colors.ink,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  account.accountName,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: context.colors.ink3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Footer
              const Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  'Codes are hidden while reordering. Order saves on drop.',
                  style: TextStyle(
                    fontSize: 11,
                    color: context.colors.ink4,
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
