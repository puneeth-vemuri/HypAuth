import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/services/totp_service.dart';
import '../domain/models/account.dart';
import '../domain/models/otp_uri_data.dart';
import '../domain/repositories/account_repository.dart';
import '../data/repositories/account_repository_impl.dart';

// Storage & Repository providers
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  final db = DatabaseService();
  ref.onDispose(() => db.dispose());
  return db;
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepositoryImpl(
    secureStorage: ref.watch(secureStorageProvider),
    databaseService: ref.watch(databaseServiceProvider),
  );
});

// Stream of accounts
final accountsStreamProvider = StreamProvider<List<Account>>((ref) {
  return ref.watch(accountRepositoryProvider).watchAccounts();
});

// Search filter state
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filtered Accounts
final filteredAccountsProvider = Provider<List<Account>>((ref) {
  final accountsAsync = ref.watch(accountsStreamProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();

  return accountsAsync.when(
    data: (list) {
      if (query.isEmpty) return list;
      return list.where((a) =>
          a.issuer.toLowerCase().contains(query) ||
          a.accountName.toLowerCase().contains(query)).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// 1-second ticker stream for smooth progress ring updates
final secondsTickerProvider = StreamProvider<int>((ref) async* {
  while (true) {
    yield TotpService.getRemainingSeconds();
    await Future.delayed(const Duration(seconds: 1));
  }
});

// AsyncNotifier for Account Operations
class AccountNotifier extends StateNotifier<AsyncValue<void>> {
  final AccountRepository _repository;

  AccountNotifier(this._repository) : super(const AsyncData(null));

  Future<bool> addAccountFromUri(OtpUriData uriData) async {
    state = const AsyncLoading();
    try {
      await _repository.addAccount(uriData);
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<void> toggleFavorite(String accountId) async {
    await _repository.toggleFavorite(accountId);
  }

  Future<void> deleteAccount(String accountId) async {
    await _repository.deleteAccount(accountId);
  }

  Future<void> reorderAccounts(List<Account> accounts) async {
    await _repository.reorderAccounts(accounts);
  }

  Future<String?> getSecret(String accountId) {
    return _repository.getSecret(accountId);
  }
}

final accountNotifierProvider =
    StateNotifierProvider<AccountNotifier, AsyncValue<void>>((ref) {
  return AccountNotifier(ref.watch(accountRepositoryProvider));
});
