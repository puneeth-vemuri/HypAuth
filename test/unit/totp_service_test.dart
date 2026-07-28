import 'package:flutter_test/flutter_test.dart';
import 'package:hyp_auth/core/services/totp_service.dart';
import 'package:hyp_auth/core/utils/base32_decoder.dart';

void main() {
  group('Base32Decoder', () {
    test('Decodes valid Base32 secret string', () {
      final decoded = Base32Decoder.decode('JBSWY3DPEHPK3PXP');
      expect(decoded.isNotEmpty, true);
    });

    test('Decodes Base32 with spaces and hyphens', () {
      final decoded = Base32Decoder.decode('JBSW-Y3DP EHPK-3PXP');
      expect(decoded.isNotEmpty, true);
    });

    test('Throws FormatException on invalid characters', () {
      expect(() => Base32Decoder.decode('INVALID!@#'), throwsFormatException);
    });
  });

  group('TotpService - Standard Test Vectors', () {
    const testSecret = 'JBSWY3DPEHPK3PXP';

    test('Generates deterministic 6-digit SHA1 TOTP', () {
      final timestamp = DateTime.fromMillisecondsSinceEpoch(1600000000000);
      final otp = TotpService.generateTotp(
        secret: testSecret,
        timestamp: timestamp,
        algorithm: 'SHA1',
        digits: 6,
        period: 30,
      );

      expect(otp.length, 6);
      expect(int.tryParse(otp), isNotNull);
    });

    test('Generates 8-digit SHA256 TOTP', () {
      final timestamp = DateTime.fromMillisecondsSinceEpoch(1600000000000);
      final otp = TotpService.generateTotp(
        secret: testSecret,
        timestamp: timestamp,
        algorithm: 'SHA256',
        digits: 8,
        period: 60,
      );

      expect(otp.length, 8);
      expect(int.tryParse(otp), isNotNull);
    });

    test('Calculates remaining seconds in validity window', () {
      final timestamp = DateTime.fromMillisecondsSinceEpoch(10000); // 10s elapsed
      final remaining = TotpService.getRemainingSeconds(
        timestamp: timestamp,
        period: 30,
      );
      expect(remaining, 20);
    });
  });

  group('TotpService - RFC 6238 Appendix A Test Vectors', () {
    // Secret: "12345678901234567890" -> Base32: "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ"
    const rfcSecret = 'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ';

    test('RFC 6238 SHA1 8-digit vectors', () {
      final vectors = [
        (59, '94287082'),
        (1111111109, '07081804'),
        (1111111111, '14050471'),
        (1234567890, '89005924'),
        (2000000000, '69279037'),
      ];

      for (final (sec, expected) in vectors) {
        final otp = TotpService.generateTotp(
          secret: rfcSecret,
          timestamp: DateTime.fromMillisecondsSinceEpoch(sec * 1000),
          algorithm: 'SHA1',
          digits: 8,
          period: 30,
        );
        expect(otp, expected, reason: 'Failed for SHA1 at timestamp $sec');
      }
    });

    test('RFC 6238 SHA256 8-digit vectors', () {
      // Secret for SHA256: 32 bytes "12345678901234567890123456789012"
      // Base32: "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQGEZA===="
      const sha256Secret = 'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQGEZA';

      final vectors = [
        (59, '46119246'),
        (1111111109, '68084774'),
        (1111111111, '67062166'),
        (1234567890, '91819424'),
        (2000000000, '90698825'),
      ];

      for (final (sec, expected) in vectors) {
        final otp = TotpService.generateTotp(
          secret: sha256Secret,
          timestamp: DateTime.fromMillisecondsSinceEpoch(sec * 1000),
          algorithm: 'SHA256',
          digits: 8,
          period: 30,
        );
        expect(otp, expected, reason: 'Failed for SHA256 at timestamp $sec');
      }
    });

    test('RFC 6238 SHA512 8-digit vectors', () {
      // Secret for SHA512: 64 bytes "1234567890123456789012345678901234567890123456789012345678901234"
      const sha512Secret =
          'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQGEZA';

      final vectors = [
        (59, '90693936'),
        (1111111109, '25091201'),
        (1111111111, '99943326'),
        (1234567890, '93441116'),
        (2000000000, '38618901'),
      ];

      for (final (sec, expected) in vectors) {
        final otp = TotpService.generateTotp(
          secret: sha512Secret,
          timestamp: DateTime.fromMillisecondsSinceEpoch(sec * 1000),
          algorithm: 'SHA512',
          digits: 8,
          period: 30,
        );
        expect(otp, expected, reason: 'Failed for SHA512 at timestamp $sec');
      }
    });
  });
}
