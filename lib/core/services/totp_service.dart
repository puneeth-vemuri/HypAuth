import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import '../utils/base32_decoder.dart';

/// Service responsible for generating RFC6238 TOTP codes.
class TotpService {
  /// Generates a TOTP code for a given secret string and parameters.
  ///
  /// [secret] Base32 encoded secret key.
  /// [timestamp] Optional Unix timestamp in milliseconds (defaults to DateTime.now()).
  /// [algorithm] 'SHA1', 'SHA256', or 'SHA512'.
  /// [digits] Number of digits in generated OTP (6 or 8).
  /// [period] Period in seconds (e.g. 30 or 60).
  static String generateTotp({
    required String secret,
    DateTime? timestamp,
    String algorithm = 'SHA1',
    int digits = 6,
    int period = 30,
  }) {
    if (secret.isEmpty) {
      throw ArgumentError('Secret cannot be empty');
    }

    final keyBytes = Base32Decoder.decode(secret);
    final nowMs = (timestamp ?? DateTime.now()).millisecondsSinceEpoch;
    final timeSeconds = nowMs ~/ 1000;
    final counter = timeSeconds ~/ period;

    return generateHotp(
      keyBytes: keyBytes,
      counter: counter,
      algorithm: algorithm,
      digits: digits,
    );
  }

  /// Generates an HOTP code using RFC4226 dynamic truncation.
  static String generateHotp({
    required Uint8List keyBytes,
    required int counter,
    String algorithm = 'SHA1',
    int digits = 6,
  }) {
    // 8-byte counter buffer in big-endian byte order
    final counterBytes = Uint8List(8);
    var tempCounter = counter;
    for (var i = 7; i >= 0; i--) {
      counterBytes[i] = tempCounter & 0xff;
      tempCounter >>= 8;
    }

    // Select hash algorithm
    final Hash hmacAlgo;
    final normalizedAlgo = algorithm.toUpperCase();
    if (normalizedAlgo == 'SHA256') {
      hmacAlgo = sha256;
    } else if (normalizedAlgo == 'SHA512') {
      hmacAlgo = sha512;
    } else {
      hmacAlgo = sha1;
    }

    final hmac = Hmac(hmacAlgo, keyBytes);
    final digest = hmac.convert(counterBytes).bytes;

    // Dynamic truncation offset
    final offset = digest[digest.length - 1] & 0x0f;

    // Extract 4-byte binary code
    final binary = ((digest[offset] & 0x7f) << 24) |
        ((digest[offset + 1] & 0xff) << 16) |
        ((digest[offset + 2] & 0xff) << 8) |
        (digest[offset + 3] & 0xff);

    final otp = binary % pow(10, digits).toInt();
    return otp.toString().padLeft(digits, '0');
  }

  /// Calculates remaining seconds in current validity window.
  static int getRemainingSeconds({
    DateTime? timestamp,
    int period = 30,
  }) {
    final nowMs = (timestamp ?? DateTime.now()).millisecondsSinceEpoch;
    final timeSeconds = nowMs ~/ 1000;
    final elapsed = timeSeconds % period;
    return period - elapsed;
  }
}
