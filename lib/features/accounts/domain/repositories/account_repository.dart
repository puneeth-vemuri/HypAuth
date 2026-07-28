import '../models/account.dart';
import '../models/otp_uri_data.dart';

abstract class AccountRepository {
  /// Stream of all registered accounts.
  Stream<List<Account>> watchAccounts();

  /// Fetches current list of accounts.
  Future<List<Account>> getAccounts();

  /// Adds a new account given parsed OTP URI data.
  Future<Account> addAccount(OtpUriData uriData);

  /// Retrieves the decrypted TOTP secret for an account ID.
  Future<String?> getSecret(String accountId);

  /// Toggles favorite status for an account.
  Future<void> toggleFavorite(String accountId);

  /// Updates account ordering.
  Future<void> reorderAccounts(List<Account> reorderedList);

  /// Deletes an account and purges its secret from Secure Storage.
  Future<void> deleteAccount(String accountId);
}
