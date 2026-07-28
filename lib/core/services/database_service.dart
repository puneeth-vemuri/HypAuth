import 'dart:async';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/accounts/data/models/isar_account.dart';
import '../../features/accounts/domain/models/account.dart';

/// Database service managing account metadata persistence via Isar.
class DatabaseService {
  Isar? _isar;
  final List<Account> _inMemoryAccounts = [];
  final _controller = StreamController<List<Account>>.broadcast();

  DatabaseService({Isar? isar}) : _isar = isar {
    _notify();
  }

  /// Initializes Isar database if not provided during construction.
  Future<void> init() async {
    if (_isar != null) return;
    try {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [IsarAccountSchema],
        directory: dir.path,
        name: 'hyp_auth_db',
      );
      final isarAccounts = await _isar!.isarAccounts.where().findAll();
      _inMemoryAccounts.clear();
      _inMemoryAccounts.addAll(isarAccounts.map((e) => e.toDomain()));
      _notify();
    } catch (_) {
      // In-memory fallback for unit tests or unsupported platforms
    }
  }

  Stream<List<Account>> watchAccounts() {
    if (_isar != null) {
      return _isar!.isarAccounts.where().watch(fireImmediately: true).map(
        (list) {
          final domainList = list.map((e) => e.toDomain()).toList();
          domainList.sort(_sortComparator);
          return List.unmodifiable(domainList);
        },
      );
    }
    return _controller.stream;
  }

  Future<List<Account>> getAccounts() async {
    if (_isar != null) {
      final list = await _isar!.isarAccounts.where().findAll();
      final domainList = list.map((e) => e.toDomain()).toList();
      domainList.sort(_sortComparator);
      return List.unmodifiable(domainList);
    }

    _inMemoryAccounts.sort(_sortComparator);
    return List.unmodifiable(_inMemoryAccounts);
  }

  Future<void> saveAccount(Account account) async {
    if (_isar != null) {
      await _isar!.writeTxn(() async {
        final existing = await _isar!.isarAccounts.filter().uuidEqualTo(account.id).findFirst();
        final entity = IsarAccount.fromDomain(account);
        if (existing != null) {
          entity.id = existing.id;
        }
        await _isar!.isarAccounts.put(entity);
      });
      return;
    }

    final idx = _inMemoryAccounts.indexWhere((a) => a.id == account.id);
    if (idx != -1) {
      _inMemoryAccounts[idx] = account;
    } else {
      _inMemoryAccounts.add(account);
    }
    _notify();
  }

  Future<void> updateAccounts(List<Account> accounts) async {
    if (_isar != null) {
      await _isar!.writeTxn(() async {
        for (final account in accounts) {
          final existing = await _isar!.isarAccounts.filter().uuidEqualTo(account.id).findFirst();
          final entity = IsarAccount.fromDomain(account);
          if (existing != null) {
            entity.id = existing.id;
          }
          await _isar!.isarAccounts.put(entity);
        }
      });
      return;
    }

    _inMemoryAccounts.clear();
    _inMemoryAccounts.addAll(accounts);
    _notify();
  }

  Future<void> deleteAccount(String id) async {
    if (_isar != null) {
      await _isar!.writeTxn(() async {
        await _isar!.isarAccounts.filter().uuidEqualTo(id).deleteAll();
      });
      return;
    }

    _inMemoryAccounts.removeWhere((a) => a.id == id);
    _notify();
  }

  int _sortComparator(Account a, Account b) {
    if (a.isFavorite != b.isFavorite) {
      return a.isFavorite ? -1 : 1;
    }
    return a.sortOrder.compareTo(b.sortOrder);
  }

  void _notify() {
    final list = List<Account>.from(_inMemoryAccounts);
    list.sort(_sortComparator);
    _controller.add(List.unmodifiable(list));
  }

  void dispose() {
    _controller.close();
  }
}

