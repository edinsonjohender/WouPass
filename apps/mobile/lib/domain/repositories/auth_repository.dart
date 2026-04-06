import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import 'package:woupassv2/core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> setupMasterPassword(String masterPassword);
  Future<Either<Failure, Uint8List>> verifyMasterPassword(String masterPassword);
  Future<Either<Failure, void>> changeMasterPassword(String oldPassword, String newPassword);
  Future<bool> isVaultInitialized();
  Future<bool> hasCachedKey();
  Future<void> lock();
}
