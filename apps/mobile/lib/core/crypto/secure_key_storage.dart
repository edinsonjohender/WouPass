import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureKeyStorage {
  static const _keyName = 'woupass_dk';
  static const _saltName = 'woupass_salt';
  static const _verificationName = 'woupass_verify';

  final FlutterSecureStorage _storage;

  SecureKeyStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  Future<void> storeDerivedKey(Uint8List key) async {
    await _storage.write(key: _keyName, value: base64Encode(key));
  }

  Future<Uint8List?> getDerivedKey() async {
    final encoded = await _storage.read(key: _keyName);
    if (encoded == null) return null;
    return base64Decode(encoded);
  }

  Future<void> clearDerivedKey() async {
    await _storage.delete(key: _keyName);
  }

  Future<bool> hasDerivedKey() async {
    return await _storage.containsKey(key: _keyName);
  }

  Future<void> storeSalt(Uint8List salt) async {
    await _storage.write(key: _saltName, value: base64Encode(salt));
  }

  Future<Uint8List?> getSalt() async {
    final encoded = await _storage.read(key: _saltName);
    if (encoded == null) return null;
    return base64Decode(encoded);
  }

  Future<void> storeVerificationHash(String hash) async {
    await _storage.write(key: _verificationName, value: hash);
  }

  Future<String?> getVerificationHash() async {
    return await _storage.read(key: _verificationName);
  }

  Future<bool> isVaultInitialized() async {
    return await _storage.containsKey(key: _saltName) &&
        await _storage.containsKey(key: _verificationName);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
