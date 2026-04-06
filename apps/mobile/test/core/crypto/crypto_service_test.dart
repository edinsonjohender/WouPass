import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:woupassv2/core/crypto/crypto_service_impl.dart';

void main() {
  late CryptoServiceImpl crypto;

  setUp(() {
    crypto = CryptoServiceImpl();
  });

  group('generateSalt', () {
    test('generates 16 bytes', () {
      final salt = crypto.generateSalt();
      expect(salt.length, 16);
    });

    test('generates unique salts', () {
      final salt1 = crypto.generateSalt();
      final salt2 = crypto.generateSalt();
      expect(salt1, isNot(equals(salt2)));
    });
  });

  group('deriveKey', () {
    test('produces 32-byte key', () async {
      final salt = crypto.generateSalt();
      final key = await crypto.deriveKey('testpassword', salt);
      expect(key.length, 32);
    });

    test('is deterministic with same password and salt', () async {
      final salt = crypto.generateSalt();
      final key1 = await crypto.deriveKey('testpassword', salt);
      final key2 = await crypto.deriveKey('testpassword', salt);
      expect(key1, equals(key2));
    });

    test('produces different keys for different passwords', () async {
      final salt = crypto.generateSalt();
      final key1 = await crypto.deriveKey('password1', salt);
      final key2 = await crypto.deriveKey('password2', salt);
      expect(key1, isNot(equals(key2)));
    });

    test('produces different keys for different salts', () async {
      final salt1 = crypto.generateSalt();
      final salt2 = crypto.generateSalt();
      final key1 = await crypto.deriveKey('testpassword', salt1);
      final key2 = await crypto.deriveKey('testpassword', salt2);
      expect(key1, isNot(equals(key2)));
    });
  });

  group('encrypt and decrypt', () {
    test('round-trip returns original plaintext', () async {
      final salt = crypto.generateSalt();
      final key = await crypto.deriveKey('testpassword', salt);

      const plaintext = 'Hello, WouPass! This is a secret message.';
      final encrypted = await crypto.encrypt(plaintext, key);
      final decrypted = await crypto.decrypt(encrypted, key);

      expect(decrypted.isRight(), true);
      decrypted.fold(
        (_) => fail('Should not fail'),
        (result) => expect(result, equals(plaintext)),
      );
    });

    test('encrypts to different ciphertext each time (random nonce)', () async {
      final salt = crypto.generateSalt();
      final key = await crypto.deriveKey('testpassword', salt);

      const plaintext = 'Same message';
      final encrypted1 = await crypto.encrypt(plaintext, key);
      final encrypted2 = await crypto.encrypt(plaintext, key);

      expect(encrypted1, isNot(equals(encrypted2)));
    });

    test('fails to decrypt with wrong key', () async {
      final salt = crypto.generateSalt();
      final key1 = await crypto.deriveKey('correctpassword', salt);
      final key2 = await crypto.deriveKey('wrongpassword', salt);

      const plaintext = 'Secret data';
      final encrypted = await crypto.encrypt(plaintext, key1);
      final result = await crypto.decrypt(encrypted, key2);

      expect(result.isLeft(), true);
    });

    test('fails with tampered ciphertext', () async {
      final salt = crypto.generateSalt();
      final key = await crypto.deriveKey('testpassword', salt);

      const plaintext = 'Tamper test';
      final encrypted = await crypto.encrypt(plaintext, key);

      // Tamper with the base64 string
      final tampered = '${encrypted.substring(0, encrypted.length - 4)}XXXX';
      final result = await crypto.decrypt(tampered, key);

      expect(result.isLeft(), true);
    });

    test('handles empty string', () async {
      final salt = crypto.generateSalt();
      final key = await crypto.deriveKey('testpassword', salt);

      const plaintext = '';
      final encrypted = await crypto.encrypt(plaintext, key);
      final decrypted = await crypto.decrypt(encrypted, key);

      expect(decrypted.isRight(), true);
      decrypted.fold(
        (_) => fail('Should not fail'),
        (result) => expect(result, equals('')),
      );
    });

    test('handles unicode and special characters', () async {
      final salt = crypto.generateSalt();
      final key = await crypto.deriveKey('testpassword', salt);

      const plaintext = 'Contraseña: ñ, ü, é, 日本語, 🔐';
      final encrypted = await crypto.encrypt(plaintext, key);
      final decrypted = await crypto.decrypt(encrypted, key);

      expect(decrypted.isRight(), true);
      decrypted.fold(
        (_) => fail('Should not fail'),
        (result) => expect(result, equals(plaintext)),
      );
    });

    test('handles very long text', () async {
      final salt = crypto.generateSalt();
      final key = await crypto.deriveKey('testpassword', salt);

      final plaintext = 'A' * 10000;
      final encrypted = await crypto.encrypt(plaintext, key);
      final decrypted = await crypto.decrypt(encrypted, key);

      expect(decrypted.isRight(), true);
      decrypted.fold(
        (_) => fail('Should not fail'),
        (result) => expect(result, equals(plaintext)),
      );
    });
  });

  group('verification hash', () {
    test('verifyKey returns true with correct key', () async {
      final salt = crypto.generateSalt();
      final key = await crypto.deriveKey('testpassword', salt);

      final hash = await crypto.createVerificationHash(key);
      final isValid = await crypto.verifyKey(key, hash);

      expect(isValid, true);
    });

    test('verifyKey returns false with wrong key', () async {
      final salt = crypto.generateSalt();
      final key1 = await crypto.deriveKey('correctpassword', salt);
      final key2 = await crypto.deriveKey('wrongpassword', salt);

      final hash = await crypto.createVerificationHash(key1);
      final isValid = await crypto.verifyKey(key2, hash);

      expect(isValid, false);
    });
  });
}
