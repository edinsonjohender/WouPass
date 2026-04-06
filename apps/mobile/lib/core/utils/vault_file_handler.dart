import 'dart:convert';
import 'package:woupassv2/core/crypto/crypto_service.dart';

class VaultExportData {
  final int version;
  final String salt;
  final String verificationHash;
  final String ciphertext;

  VaultExportData({
    required this.version,
    required this.salt,
    required this.verificationHash,
    required this.ciphertext,
  });

  Map<String, dynamic> toJson() => {
    'version': version,
    'salt': salt,
    'verificationHash': verificationHash,
    'ciphertext': ciphertext,
  };

  factory VaultExportData.fromJson(Map<String, dynamic> json) => VaultExportData(
    version: json['version'] as int,
    salt: json['salt'] as String,
    verificationHash: json['verificationHash'] as String,
    ciphertext: json['ciphertext'] as String,
  );
}

class VaultFileHandler {
  final CryptoService _crypto;

  VaultFileHandler(this._crypto);

  Future<String> exportVault({
    required Map<String, dynamic> vaultData,
    required String exportPassword,
  }) async {
    final salt = _crypto.generateSalt();
    final key = await _crypto.deriveKey(exportPassword, salt);
    final verificationHash = await _crypto.createVerificationHash(key);
    final jsonString = jsonEncode(vaultData);
    final ciphertext = await _crypto.encrypt(jsonString, key);

    final exportData = VaultExportData(
      version: 1,
      salt: base64Encode(salt),
      verificationHash: verificationHash,
      ciphertext: ciphertext,
    );

    return jsonEncode(exportData.toJson());
  }

  Future<Map<String, dynamic>?> importVault({
    required String fileContent,
    required String importPassword,
  }) async {
    final exportData = VaultExportData.fromJson(jsonDecode(fileContent));
    final salt = base64Decode(exportData.salt);
    final key = await _crypto.deriveKey(importPassword, salt);

    final isValid = await _crypto.verifyKey(key, exportData.verificationHash);
    if (!isValid) return null;

    final result = await _crypto.decrypt(exportData.ciphertext, key);
    return result.fold(
      (_) => null,
      (json) => jsonDecode(json) as Map<String, dynamic>,
    );
  }
}
