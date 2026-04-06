import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import 'package:woupassv2/core/crypto/crypto_service.dart';
import 'package:woupassv2/core/crypto/secure_key_storage.dart';
import 'package:woupassv2/core/errors/failures.dart';
import 'package:woupassv2/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final CryptoService _cryptoService;
  final SecureKeyStorage _keyStorage;

  AuthRepositoryImpl(this._cryptoService, this._keyStorage);

  @override
  Future<Either<Failure, void>> setupMasterPassword(String masterPassword) async {
    try {
      final salt = _cryptoService.generateSalt();
      final derivedKey = await _cryptoService.deriveKey(masterPassword, salt);
      final verificationHash = await _cryptoService.createVerificationHash(derivedKey);

      await _keyStorage.storeSalt(salt);
      await _keyStorage.storeVerificationHash(verificationHash);
      await _keyStorage.storeDerivedKey(derivedKey);

      return const Right(null);
    } catch (e, st) {
      return Left(AuthFailure('Failed to setup master password: $e', st));
    }
  }

  @override
  Future<Either<Failure, Uint8List>> verifyMasterPassword(String masterPassword) async {
    try {
      final salt = await _keyStorage.getSalt();
      if (salt == null) {
        return const Left(AuthFailure('No vault found. Please setup first.'));
      }

      final verificationHash = await _keyStorage.getVerificationHash();
      if (verificationHash == null) {
        return const Left(AuthFailure('Vault corrupted: missing verification hash.'));
      }

      final derivedKey = await _cryptoService.deriveKey(masterPassword, salt);
      final isValid = await _cryptoService.verifyKey(derivedKey, verificationHash);

      if (!isValid) {
        return const Left(AuthFailure('Incorrect master password.'));
      }

      await _keyStorage.storeDerivedKey(derivedKey);
      return Right(derivedKey);
    } catch (e, st) {
      return Left(AuthFailure('Verification failed: $e', st));
    }
  }

  @override
  Future<Either<Failure, void>> changeMasterPassword(String oldPassword, String newPassword) async {
    try {
      final verifyResult = await verifyMasterPassword(oldPassword);
      return verifyResult.fold(
        (failure) => Left(failure),
        (oldKey) async {
          final newSalt = _cryptoService.generateSalt();
          final newKey = await _cryptoService.deriveKey(newPassword, newSalt);
          final newVerificationHash = await _cryptoService.createVerificationHash(newKey);


          await _keyStorage.storeSalt(newSalt);
          await _keyStorage.storeVerificationHash(newVerificationHash);
          await _keyStorage.storeDerivedKey(newKey);

          return const Right(null);
        },
      );
    } catch (e, st) {
      return Left(AuthFailure('Failed to change master password: $e', st));
    }
  }

  @override
  Future<bool> isVaultInitialized() async {
    return await _keyStorage.isVaultInitialized();
  }

  @override
  Future<bool> hasCachedKey() async {
    return await _keyStorage.hasDerivedKey();
  }

  @override
  Future<void> lock() async {
    await _keyStorage.clearDerivedKey();
  }
}
