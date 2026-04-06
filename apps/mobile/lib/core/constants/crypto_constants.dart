abstract final class CryptoConstants {
  static const int argon2Memory = 65536;    // 64 MB
  static const int argon2Iterations = 3;
  static const int argon2Parallelism = 4;
  static const int derivedKeyLength = 32;   // 256 bits for AES-256
  static const int saltLength = 16;         // 128-bit salt
  static const int nonceLength = 12;        // 96-bit nonce for GCM
  static const int tagLength = 16;          // 128-bit auth tag
  static const String verificationConstant = 'WOUPASS_KEY_VERIFY_V1';
}
