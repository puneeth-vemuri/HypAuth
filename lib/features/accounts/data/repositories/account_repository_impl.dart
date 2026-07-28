import 'dart:math';
import '../../../core/errors/failures.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../domain/models/account.dart';
import '../../domain/models/otp_uri_data.dart';
import '../../domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final SecureStorageService _secureStorage;
  final DatabaseService _databaseService;

  AccountRepositoryImpl({
    required SecureStorageService secureStorage,
    required DatabaseService databaseService,
  })  : _secureStorage = secureStorage,
        _databaseService = databaseService;

  @override
  Stream<List<Account>> watchAccounts() => _databaseService.watchAccounts();

  @override
  Future<List<Account>> getAccounts() => _databaseService.getAccounts();

  @override
  Future<Account> addAccount(OtpUriData uriData) async {
    final existing = await _databaseService.getAccounts();
    final duplicate = existing.any((a) =>
        a.issuer.toLowerCase() == uriData.issuer.toLowerCase() &&
        a.accountName.toLowerCase() == uriData.account.toLowerCase());

    if (duplicate) {
      throw const DuplicateAccountFailure();
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString() +
        '_' +
        Random().nextInt(10000).toString();
    final now = DateTime.now();

    // 1. Save secret ONLY inside Secure Storage
    await _secureStorage.saveSecret(accountId: id, secret: uriData.secret);

    // 2. Save metadata inside local database
    final account = Account(
      id: id,
      issuer: uriData.issuer,
      accountName: uriData.account,
      icon: _determineIcon(uriData.issuer),
      createdAt: now,
      updatedAt: now,
      isFavorite: false,
      sortOrder: existing.length,
      algorithm: uriData.algorithm,
      digits: uriData.digits,
      period: uriData.period,
    );

    await _databaseService.saveAccount(account);
    return account;
  }

  @override
  Future<String?> getSecret(String accountId) {
    return _secureStorage.getSecret(accountId);
  }

  @override
  Future<void> toggleFavorite(String accountId) async {
    final accounts = await _databaseService.getAccounts();
    final idx = accounts.indexWhere((a) => a.id == accountId);
    if (idx != -1) {
      final updated = accounts[idx].copyWith(
        isFavorite: !accounts[idx].isFavorite,
        updatedAt: DateTime.now(),
      );
      await _databaseService.saveAccount(updated);
    }
  }

  @override
  Future<void> reorderAccounts(List<Account> reorderedList) async {
    final updatedList = <Account>[];
    for (var i = 0; i < reorderedList.length; i++) {
      updatedList.add(reorderedList[i].copyWith(sortOrder: i));
    }
    await _databaseService.updateAccounts(updatedList);
  }

  @override
  Future<void> deleteAccount(String accountId) async {
    // Delete metadata
    await _databaseService.deleteAccount(accountId);
    // Purge secret from secure storage
    await _secureStorage.deleteSecret(accountId);
  }

  String _determineIcon(String issuer) {
    final lower = issuer.toLowerCase();
    if (lower.contains('github')) return 'github';
    if (lower.contains('google')) return 'google';
    if (lower.contains('discord')) return 'discord';
    if (lower.contains('aws') || lower.contains('amazon')) return 'aws';
    if (lower.contains('microsoft')) return 'microsoft';
    if (lower.contains('binance') || lower.contains('crypto')) return 'crypto';
    return 'key';
  }
}
