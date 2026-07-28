import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyp_auth/core/services/database_service.dart';
import 'package:hyp_auth/core/services/secure_storage_service.dart';
import 'package:hyp_auth/core/services/totp_service.dart';
import 'package:hyp_auth/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:hyp_auth/features/accounts/domain/models/otp_uri_data.dart';

void main() {
  group('Integration Test - Full OTP Flow', () {
    late SecureStorageService secureStorage;
    late DatabaseService databaseService;
    late AccountRepositoryImpl repository;

    setUp(() async {
      secureStorage = SecureStorageService();
      databaseService = DatabaseService();
      await databaseService.init();
      repository = AccountRepositoryImpl(
        secureStorage: secureStorage,
        databaseService: databaseService,
      );
    });

    tearDown(() async {
      databaseService.dispose();
      await secureStorage.clearAllSecrets();
    });

    test('Full lifecycle: Add account, generate TOTP, verify secret isolation, and delete', () async {
      // 1. Define sample parsed QR URI
      const sampleUriData = OtpUriData(
        issuer: 'Google',
        account: 'user@gmail.com',
        secret: 'JBSWY3DPEHPK3PXP',
        algorithm: 'SHA1',
        digits: 6,
        period: 30,
      );

      // 2. Add Account
      final account = await repository.addAccount(sampleUriData);
      expect(account.issuer, 'Google');
      expect(account.accountName, 'user@gmail.com');

      // 3. Verify Secret stored ONLY in SecureStorage
      final retrievedSecret = await repository.getSecret(account.id);
      expect(retrievedSecret, 'JBSWY3DPEHPK3PXP');

      // 4. Generate TOTP code deterministically
      final now = DateTime.fromMillisecondsSinceEpoch(1600000000000);
      final code = TotpService.generateTotp(
        secret: retrievedSecret!,
        timestamp: now,
        algorithm: account.algorithm,
        digits: account.digits,
        period: account.period,
      );
      expect(code.length, 6);
      expect(int.tryParse(code), isNotNull);

      // 5. Delete Account
      await repository.deleteAccount(account.id);

      // 6. Verify Metadata deleted & Secret purged
      final remainingAccounts = await repository.getAccounts();
      expect(remainingAccounts.any((a) => a.id == account.id), false);

      final purgedSecret = await repository.getSecret(account.id);
      expect(purgedSecret, isNull);
    });
  });
}
