import 'dart:math';

class PasswordGenerator {
  static const _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const _digits = '0123456789';
  static const _symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  static String generate({
    int length = 20,
    bool useLowercase = true,
    bool useUppercase = true,
    bool useDigits = true,
    bool useSymbols = true,
  }) {
    final random = Random.secure();
    final chars = StringBuffer();

    if (useLowercase) chars.write(_lowercase);
    if (useUppercase) chars.write(_uppercase);
    if (useDigits) chars.write(_digits);
    if (useSymbols) chars.write(_symbols);

    final charPool = chars.toString();
    if (charPool.isEmpty) return '';

    return List.generate(
      length,
      (_) => charPool[random.nextInt(charPool.length)],
    ).join();
  }
}
