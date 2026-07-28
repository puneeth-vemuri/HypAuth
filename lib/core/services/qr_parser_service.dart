import '../../features/accounts/domain/models/otp_uri_data.dart';
import '../errors/exceptions.dart';
import '../utils/base32_decoder.dart';

class QrParserService {
  /// Parses a raw QR string into an [OtpUriData] object.
  /// Throws [QrParseException] if the URI format or parameters are invalid.
  static OtpUriData parseUri(String rawString) {
    final uriString = rawString.trim();
    if (!uriString.startsWith('otpauth://totp/')) {
      throw QrParseException('Only otpauth://totp/ URIs are supported');
    }

    final Uri uri;
    try {
      uri = Uri.parse(uriString);
    } catch (e) {
      throw QrParseException('Malformed URI structure: $e');
    }

    // Extract path segment (e.g. GitHub:user@gmail.com or user@gmail.com)
    final rawPath = Uri.decodeComponent(uri.path.substring(1)); // strip leading slash
    if (rawPath.isEmpty) {
      throw QrParseException('Missing account path in OTP URI');
    }

    String pathIssuer = '';
    String accountName = rawPath;

    if (rawPath.contains(':')) {
      final parts = rawPath.split(':');
      pathIssuer = parts[0].trim();
      accountName = parts.sublist(1).join(':').trim();
    }

    final queryParams = uri.queryParameters;
    final secret = queryParams['secret']?.trim() ?? '';
    if (secret.isEmpty) {
      throw QrParseException('Missing required parameter: secret');
    }

    // Validate base32 secret
    try {
      Base32Decoder.decode(secret);
    } catch (_) {
      throw QrParseException('Secret key is not valid Base32 string');
    }

    final queryIssuer = queryParams['issuer']?.trim() ?? '';
    final finalIssuer = queryIssuer.isNotEmpty ? queryIssuer : (pathIssuer.isNotEmpty ? pathIssuer : 'Authenticator');

    final algorithmStr = (queryParams['algorithm'] ?? 'SHA1').toUpperCase();
    if (!['SHA1', 'SHA256', 'SHA512'].contains(algorithmStr)) {
      throw QrParseException('Unsupported algorithm: $algorithmStr');
    }

    final digits = int.tryParse(queryParams['digits'] ?? '6') ?? 6;
    if (digits != 6 && digits != 8) {
      throw QrParseException('Digits must be 6 or 8');
    }

    final period = int.tryParse(queryParams['period'] ?? '30') ?? 30;
    if (period <= 0) {
      throw QrParseException('Period must be greater than 0');
    }

    return OtpUriData(
      issuer: finalIssuer,
      account: accountName,
      secret: secret,
      algorithm: algorithmStr,
      digits: digits,
      period: period,
    );
  }
}
