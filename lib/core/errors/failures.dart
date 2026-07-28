/// Abstract base class for domain failures.
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class InvalidQrCodeFailure extends Failure {
  const InvalidQrCodeFailure([super.message = 'Invalid OTP QR code format']);
}

class DuplicateAccountFailure extends Failure {
  const DuplicateAccountFailure([super.message = 'Account already exists']);
}

class SecureStorageFailure extends Failure {
  const SecureStorageFailure([super.message = 'Failed to access secure storage']);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'Database operation failed']);
}

class BiometricFailure extends Failure {
  const BiometricFailure([super.message = 'Biometric authentication failed']);
}

class TotpGenerationException implements Exception {
  final String message;
  TotpGenerationException(this.message);

  @override
  String toString() => 'TotpGenerationException: $message';
}

class QrParseException implements Exception {
  final String message;
  QrParseException(this.message);

  @override
  String toString() => 'QrParseException: $message';
}
