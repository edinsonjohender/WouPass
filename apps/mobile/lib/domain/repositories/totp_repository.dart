import 'package:fpdart/fpdart.dart';
import 'package:woupassv2/core/errors/failures.dart';
import 'package:woupassv2/domain/entities/totp_entry.dart';

abstract class TotpRepository {
  Future<Either<Failure, List<TotpEntry>>> getAllEntries();
  Future<Either<Failure, int>> createEntry(TotpEntry entry);
  Future<Either<Failure, void>> deleteEntry(int id);
}
