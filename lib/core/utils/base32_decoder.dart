import 'dart:typed_data';

/// Utility class for decoding RFC 4648 Base32 encoded strings.
class Base32Decoder {
  static const String _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

  /// Decodes a Base32 string into raw bytes.
  /// Throws [FormatException] if the string contains invalid Base32 characters.
  static Uint8List decode(String input) {
    final cleanInput = input.toUpperCase().replaceAll('=', '').replaceAll(' ', '').replaceAll('-', '');
    if (cleanInput.isEmpty) {
      return Uint8List(0);
    }

    final bits = StringBuffer();
    for (var i = 0; i < cleanInput.length; i++) {
      final char = cleanInput[i];
      final val = _alphabet.indexOf(char);
      if (val == -1) {
        throw FormatException('Invalid Base32 character: $char');
      }
      bits.write(val.toRadixString(2).padLeft(5, '0'));
    }

    final bitString = bits.toString();
    final bytesCount = bitString.length ~/ 8;
    final bytes = Uint8List(bytesCount);

    for (var i = 0; i < bytesCount; i++) {
      final byteStr = bitString.substring(i * 8, (i + 1) * 8);
      bytes[i] = int.parse(byteStr, radix: 2);
    }

    return bytes;
  }
}
