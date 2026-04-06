import 'package:fpdart/fpdart.dart';
import 'package:woupassv2/core/errors/failures.dart';
import 'package:woupassv2/domain/entities/vault_entry.dart';

abstract class VaultEntryRepository {
  Future<Either<Failure, List<VaultEntry>>> getAllEntries();
  Future<Either<Failure, VaultEntry>> getEntry(int id);
  Future<Either<Failure, int>> createEntry(VaultEntry entry);
  Future<Either<Failure, void>> updateEntry(VaultEntry entry);
  Future<Either<Failure, void>> deleteEntry(int id);
  Future<Either<Failure, List<VaultEntry>>> searchEntries(String query);
}
