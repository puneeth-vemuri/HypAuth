import 'package:flutter_test/flutter_test.dart';
import 'package:hyp_auth/core/errors/exceptions.dart';
import 'package:hyp_auth/core/services/qr_parser_service.dart';

void main() {
  group('QrParserService', () {
    test('Parses standard GitHub OTP URI', () {
      const uri =
          'otpauth://totp/GitHub:user@gmail.com?secret=JBSWY3DPEHPK3PXP&issuer=GitHub&algorithm=SHA1&digits=6&period=30';
      final data = QrParserService.parseUri(uri);

      expect(data.issuer, 'GitHub');
      expect(data.account, 'user@gmail.com');
      expect(data.secret, 'JBSWY3DPEHPK3PXP');
      expect(data.algorithm, 'SHA1');
      expect(data.digits, 6);
      expect(data.period, 30);
    });

    test('Parses URI without explicit issuer parameter', () {
      const uri = 'otpauth://totp/Google:john@doe.com?secret=JBSWY3DPEHPK3PXP';
      final data = QrParserService.parseUri(uri);

      expect(data.issuer, 'Google');
      expect(data.account, 'john@doe.com');
    });

    test('Throws QrParseException on unsupported protocol', () {
      const invalidUri = 'https://example.com/login';
      expect(() => QrParserService.parseUri(invalidUri), throwsA(isA<QrParseException>()));
    });

    test('Throws QrParseException on missing secret', () {
      const invalidUri = 'otpauth://totp/GitHub:user@gmail.com?issuer=GitHub';
      expect(() => QrParserService.parseUri(invalidUri), throwsA(isA<QrParseException>()));
    });
  });
}
