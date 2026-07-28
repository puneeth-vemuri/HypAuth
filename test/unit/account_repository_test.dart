import 'package:flutter_test/flutter_test.dart';
import 'package:hyp_auth/core/errors/failures.dart';
import 'package:hyp_auth/core/services/database_service.dart';
import 'package:hyp_auth/core/services/secure_storage_service.dart';
import 'package:hyp_auth/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:hyp_auth/features/accounts/domain/models/otp_uri_data.dart';

void main() {
  group('AccountRepositoryImpl', () {
    late SecureStorageService secureStorage;
    late DatabaseService databaseService;
    late AccountRepositoryImpl repository;

    setUp(() {
      secureStorage = SecureStorageService();
      databaseService = DatabaseService();
      repository = AccountRepositoryImpl(
        secureStorage: secureStorage,
        databaseService: databaseService,
      );
    });

    tearDown(() {
      databaseService.dispose();
    });

    test('Adds account and stores secret in secure storage', () async {
      const uriData = OtpUriData(
        issuer: 'AWS',
        account: 'admin@company.com',
        secret: 'JBSWY3DPEHPK3PXP',
      );

      final account = await repository.addAccount(uriData);
      expect(account.issuer, 'AWS');
      expect(account.accountName, 'admin@company.com');

      final storedSecret = await repository.getSecret(account.id);
      expect(storedSecret, 'JBSWY3DPEHPK3PXP');
    });

    test('Throws DuplicateAccountFailure when adding duplicate issuer + account', () async {
      const uriData = OtpUriData(
        issuer: 'GitHub',
        account: 'dev@company.com',
        secret: 'JBSWY3DPEHPK3PXP',
      );

      await repository.addAccount(uriData);
      expect(
        () => repository.addAccount(uriData),
        throwsA(isA<DuplicateAccountFailure>()),
      );
    });

    test('Deletes account and purges secret', () async {
      const uriData = OtpUriData(
        issuer: 'Discord',
        account: 'user#1234',
        secret: 'JBSWY3DPEHPK3PXP',
      );

      final account = await repository.addAccount(uriData);
      await repository.deleteAccount(account.id);

      final accounts = await repository.getAccounts();
      expect(accounts.any((a) => a.id == account.id), false);

      final secret = await repository.getSecret(account.id);
      expect(secret, null);
    });
  });
}
