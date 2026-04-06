import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import 'package:woupassv2/core/errors/failures.dart';

abstract class CryptoService {
  /// Derives a 256-bit key from the master password using Argon2id.
  Future<Uint8List> deriveKey(String masterPassword, Uint8List salt);

  /// Encrypts plaintext using AES-256-GCM.
  /// Returns base64 string of (nonce + ciphertext + tag).
  Future<String> encrypt(String plaintext, Uint8List key);

  /// Decrypts a base64 blob (nonce + ciphertext + tag) using AES-256-GCM.
  Future<Either<CryptoFailure, String>> decrypt(String encryptedBase64, Uint8List key);

  /// Generates a cryptographically secure random salt.
  Uint8List generateSalt();

  /// Creates a verification hash to confirm master password correctness.
  Future<String> createVerificationHash(Uint8List key);

  /// Verifies the derived key against the stored verification hash.
  Future<bool> verifyKey(Uint8List key, String storedHash);
}
