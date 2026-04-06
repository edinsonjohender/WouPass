import 'dart:typed_data';
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:woupassv2/core/crypto/crypto_service.dart';
import 'package:woupassv2/core/crypto/secure_key_storage.dart';
import 'package:woupassv2/core/errors/failures.dart';
import 'package:woupassv2/data/datasources/local/database/app_database.dart' hide Category;
import 'package:woupassv2/domain/entities/vault_entry.dart' as domain;
import 'package:woupassv2/domain/repositories/vault_entry_repository.dart';

class VaultEntryRepositoryImpl implements VaultEntryRepository {
  final AppDatabase _db;
  final CryptoService _crypto;
  final SecureKeyStorage _keyStorage;

  VaultEntryRepositoryImpl(this._db, this._crypto, this._keyStorage);

  Future<Uint8List> _getKey() async {
    final key = await _keyStorage.getDerivedKey();
    if (key == null) throw const AuthFailure('Not authenticated');
    return key;
  }

  @override
  Future<Either<Failure, List<domain.VaultEntry>>> getAllEntries() async {
    try {
      final key = await _getKey();
      final rows = await _db.getAllVaultEntries();
      final entries = <domain.VaultEntry>[];
      for (final row in rows) {
        entries.add(await _decryptRow(row, key));
      }
      return Right(entries);
    } catch (e, st) {
      return Left(DatabaseFailure('Failed to get entries: $e', st));
    }
  }

  @override
  Future<Either<Failure, domain.VaultEntry>> getEntry(int id) async {
    try {
      final key = await _getKey();
      final row = await _db.getVaultEntry(id);
      return Right(await _decryptRow(row, key));
    } catch (e, st) {
      return Left(DatabaseFailure('Failed to get entry: $e', st));
    }
  }

  @override
  Future<Either<Failure, int>> createEntry(domain.VaultEntry entry) async {
    try {
      final key = await _getKey();
      final now = DateTime.now();
      final companion = VaultEntriesCompanion.insert(
        title: await _crypto.encrypt(entry.title, key),
        username: Value(await _crypto.encrypt(entry.username, key)),
        password: await _crypto.encrypt(entry.password, key),
        uri: Value(await _crypto.encrypt(entry.uri, key)),
        notes: Value(await _crypto.encrypt(entry.notes, key)),
        categoryId: Value(entry.categoryId),
        icon: Value(entry.icon),
        favorite: Value(entry.favorite),
        passwordRenewalDays: Value(entry.passwordRenewalDays),
        lastPasswordChange: entry.lastPasswordChange,
        createdAt: now,
        updatedAt: now,
      );
      final id = await _db.insertVaultEntry(companion);
      return Right(id);
    } catch (e, st) {
      return Left(DatabaseFailure('Failed to create entry: $e', st));
    }
  }

  @override
  Future<Either<Failure, void>> updateEntry(domain.VaultEntry entry) async {
    try {
      if (entry.id == null) return const Left(DatabaseFailure('Entry has no id'));
      final key = await _getKey();
      final companion = VaultEntriesCompanion(
        id: Value(entry.id!),
        title: Value(await _crypto.encrypt(entry.title, key)),
        username: Value(await _crypto.encrypt(entry.username, key)),
        password: Value(await _crypto.encrypt(entry.password, key)),
        uri: Value(await _crypto.encrypt(entry.uri, key)),
        notes: Value(await _crypto.encrypt(entry.notes, key)),
        categoryId: Value(entry.categoryId),
        icon: Value(entry.icon),
        favorite: Value(entry.favorite),
        passwordRenewalDays: Value(entry.passwordRenewalDays),
        lastPasswordChange: Value(entry.lastPasswordChange),
        createdAt: Value(entry.createdAt),
        updatedAt: Value(DateTime.now()),
      );
      await _db.updateVaultEntry(companion);
      return const Right(null);
    } catch (e, st) {
      return Left(DatabaseFailure('Failed to update entry: $e', st));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEntry(int id) async {
    try {
      await _db.deleteVaultEntry(id);
      return const Right(null);
    } catch (e, st) {
      return Left(DatabaseFailure('Failed to delete entry: $e', st));
    }
  }

  @override
  Future<Either<Failure, List<domain.VaultEntry>>> searchEntries(String query) async {
    try {
      final result = await getAllEntries();
      return result.map((entries) {
        final q = query.toLowerCase();
        return entries.where((e) =>
          e.title.toLowerCase().contains(q) ||
          e.username.toLowerCase().contains(q) ||
          e.uri.toLowerCase().contains(q)
        ).toList();
      });
    } catch (e, st) {
      return Left(DatabaseFailure('Search failed: $e', st));
    }
  }

  Future<domain.VaultEntry> _decryptRow(VaultEntry row, Uint8List key) async {
    final title = await _crypto.decrypt(row.title, key);
    final username = await _crypto.decrypt(row.username, key);
    final password = await _crypto.decrypt(row.password, key);
    final uri = await _crypto.decrypt(row.uri, key);
    final notes = await _crypto.decrypt(row.notes, key);

    return domain.VaultEntry(
      id: row.id,
      title: title.getOrElse((_) => '???'),
      username: username.getOrElse((_) => ''),
      password: password.getOrElse((_) => ''),
      uri: uri.getOrElse((_) => ''),
      notes: notes.getOrElse((_) => ''),
      categoryId: row.categoryId,
      icon: row.icon,
      favorite: row.favorite,
      passwordRenewalDays: row.passwordRenewalDays,
      lastPasswordChange: row.lastPasswordChange,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
