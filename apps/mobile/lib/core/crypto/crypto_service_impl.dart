import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:fpdart/fpdart.dart';
import 'package:woupassv2/core/constants/crypto_constants.dart';
import 'package:woupassv2/core/errors/failures.dart';
import 'crypto_service.dart';

class CryptoServiceImpl implements CryptoService {
  final AesGcm _aesGcm = AesGcm.with256bits();

  @override
  Future<Uint8List> deriveKey(String masterPassword, Uint8List salt) async {
    final algorithm = Argon2id(
      memory: CryptoConstants.argon2Memory,
      parallelism: CryptoConstants.argon2Parallelism,
      iterations: CryptoConstants.argon2Iterations,
      hashLength: CryptoConstants.derivedKeyLength,
    );
    final result = await algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(masterPassword)),
      nonce: salt,
    );
    final bytes = await result.extractBytes();
    return Uint8List.fromList(bytes);
  }

  @override
  Future<String> encrypt(String plaintext, Uint8List key) async {
    final secretKey = SecretKey(key);
    final secretBox = await _aesGcm.encrypt(
      utf8.encode(plaintext),
      secretKey: secretKey,
    );
    final combined = <int>[
      ...secretBox.nonce,
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
    ];
    return base64Encode(Uint8List.fromList(combined));
  }

  @override
  Future<Either<CryptoFailure, String>> decrypt(
    String encryptedBase64,
    Uint8List key,
  ) async {
    try {
      final combined = base64Decode(encryptedBase64);
      if (combined.length < CryptoConstants.nonceLength + CryptoConstants.tagLength) {
        return const Left(CryptoFailure('Invalid encrypted data: too short'));
      }

      final nonce = combined.sublist(0, CryptoConstants.nonceLength);
      final cipherText = combined.sublist(
        CryptoConstants.nonceLength,
        combined.length - CryptoConstants.tagLength,
      );
      final mac = Mac(combined.sublist(combined.length - CryptoConstants.tagLength));

      final secretBox = SecretBox(
        cipherText,
        nonce: nonce,
        mac: mac,
      );

      final decrypted = await _aesGcm.decrypt(
        secretBox,
        secretKey: SecretKey(key),
      );
      return Right(utf8.decode(decrypted));
    } catch (e, st) {
      return Left(CryptoFailure('Decryption failed: $e', st));
    }
  }

  @override
  Uint8List generateSalt() {
    final bytes = SecretKeyData.random(length: CryptoConstants.saltLength).bytes;
    return Uint8List.fromList(bytes);
  }

  @override
  Future<String> createVerificationHash(Uint8List key) async {
    return encrypt(CryptoConstants.verificationConstant, key);
  }

  @override
  Future<bool> verifyKey(Uint8List key, String storedHash) async {
    final result = await decrypt(storedHash, key);
    return result.fold(
      (_) => false,
      (plaintext) => plaintext == CryptoConstants.verificationConstant,
    );
  }
}
