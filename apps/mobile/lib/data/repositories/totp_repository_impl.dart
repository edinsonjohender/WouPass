import 'dart:typed_data';
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:woupassv2/core/crypto/crypto_service.dart';
import 'package:woupassv2/core/crypto/secure_key_storage.dart';
import 'package:woupassv2/core/errors/failures.dart';
import 'package:woupassv2/data/datasources/local/database/app_database.dart' as db;
import 'package:woupassv2/domain/entities/totp_entry.dart' as domain;
import 'package:woupassv2/domain/repositories/totp_repository.dart';

class TotpRepositoryImpl implements TotpRepository {
  final db.AppDatabase _db;
  final CryptoService _crypto;
  final SecureKeyStorage _keyStorage;

  TotpRepositoryImpl(this._db, this._crypto, this._keyStorage);

  Future<Uint8List> _getKey() async {
    final key = await _keyStorage.getDerivedKey();
    if (key == null) throw const AuthFailure('Not authenticated');
    return key;
  }

  @override
  Future<Either<Failure, List<domain.TotpEntry>>> getAllEntries() async {
    try {
      final key = await _getKey();
      final rows = await _db.getAllTotpEntries();
      final entries = <domain.TotpEntry>[];
      for (final row in rows) {
        entries.add(await _decryptRow(row, key));
      }
      return Right(entries);
    } catch (e, st) {
      return Left(DatabaseFailure('Failed to get TOTP entries: $e', st));
    }
  }

  @override
  Future<Either<Failure, int>> createEntry(domain.TotpEntry entry) async {
    try {
      final key = await _getKey();
      final id = await _db.insertTotpEntry(db.TotpEntriesCompanion.insert(
        issuer: await _crypto.encrypt(entry.issuer, key),
        accountName: await _crypto.encrypt(entry.accountName, key),
        secret: await _crypto.encrypt(entry.secret, key),
        digits: Value(entry.digits),
        period: Value(entry.period),
        algorithm: Value(entry.algorithm),
        vaultEntryId: Value(entry.vaultEntryId),
        createdAt: DateTime.now(),
      ));
      return Right(id);
    } catch (e, st) {
      return Left(DatabaseFailure('Failed to create TOTP entry: $e', st));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEntry(int id) async {
    try {
      await _db.deleteTotpEntry(id);
      return const Right(null);
    } catch (e, st) {
      return Left(DatabaseFailure('Failed to delete TOTP entry: $e', st));
    }
  }

  Future<domain.TotpEntry> _decryptRow(db.TotpEntry row, Uint8List key) async {
    final issuer = await _crypto.decrypt(row.issuer, key);
    final accountName = await _crypto.decrypt(row.accountName, key);
    final secret = await _crypto.decrypt(row.secret, key);

    return domain.TotpEntry(
      id: row.id,
      issuer: issuer.getOrElse((_) => '???'),
      accountName: accountName.getOrElse((_) => ''),
      secret: secret.getOrElse((_) => ''),
      digits: row.digits,
      period: row.period,
      algorithm: row.algorithm,
      vaultEntryId: row.vaultEntryId,
      createdAt: row.createdAt,
    );
  }
}
