import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:woupassv2/core/crypto/crypto_service.dart';
import 'package:woupassv2/core/crypto/crypto_service_impl.dart';
import 'package:woupassv2/core/crypto/secure_key_storage.dart';

part 'crypto_provider.g.dart';

@Riverpod(keepAlive: true)
CryptoService cryptoService(CryptoServiceRef ref) {
  return CryptoServiceImpl();
}

@Riverpod(keepAlive: true)
SecureKeyStorage secureKeyStorage(SecureKeyStorageRef ref) {
  return SecureKeyStorage();
}
