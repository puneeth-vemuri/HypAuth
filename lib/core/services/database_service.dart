import 'dart:async';
import 'dart:convert';
import '../../features/accounts/domain/models/account.dart';
import 'preferences_service.dart';

/// Database service managing account metadata persistence purely via SharedPreferences.
/// This bypasses Isar to ensure compatibility with unsigned iOS builds (sideloading)
/// where dylibs might be blocked by the OS sandbox.
class DatabaseService {
  final PreferencesService _prefs;
  final List<Account> _inMemoryAccounts = [];
  final _controller = StreamController<List<Account>>.broadcast();

  DatabaseService(this._prefs) {
    _notify();
  }

  /// Initializes the database by loading from SharedPreferences.
  Future<void> init() async {
    _loadFromFallback();
  }

  void _loadFromFallback() {
    try {
      final jsonStr = _prefs.getFallbackData('database_fallback_accounts');
      if (jsonStr != null) {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        final accounts = decoded.map((e) => Account.fromJson(e as Map<String, dynamic>)).toList();
        _inMemoryAccounts.clear();
        _inMemoryAccounts.addAll(accounts);
        _notify();
      }
    } catch (_) {}
  }

  Future<void> _saveToFallback() async {
    final list = _inMemoryAccounts.map((e) => e.toJson()).toList();
    await _prefs.saveFallbackData('database_fallback_accounts', jsonEncode(list));
  }

  Stream<List<Account>> watchAccounts() async* {
    yield await getAccounts();
    yield* _controller.stream;
  }

  Future<List<Account>> getAccounts() async {
    _inMemoryAccounts.sort(_sortComparator);
    return List.unmodifiable(_inMemoryAccounts);
  }

  Future<void> saveAccount(Account account) async {
    final idx = _inMemoryAccounts.indexWhere((a) => a.id == account.id);
    if (idx != -1) {
      _inMemoryAccounts[idx] = account;
    } else {
      _inMemoryAccounts.add(account);
    }
    await _saveToFallback();
    _notify();
  }

  Future<void> updateAccounts(List<Account> accounts) async {
    _inMemoryAccounts.clear();
    _inMemoryAccounts.addAll(accounts);
    await _saveToFallback();
    _notify();
  }

  Future<void> deleteAccount(String id) async {
    _inMemoryAccounts.removeWhere((a) => a.id == id);
    await _saveToFallback();
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

