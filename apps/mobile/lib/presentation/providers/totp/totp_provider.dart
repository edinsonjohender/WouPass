import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:woupassv2/data/repositories/totp_repository_impl.dart';
import 'package:woupassv2/domain/entities/totp_entry.dart';
import 'package:woupassv2/domain/repositories/totp_repository.dart';
import 'package:woupassv2/presentation/providers/core/crypto_provider.dart';
import 'package:woupassv2/presentation/providers/core/database_provider.dart';

part 'totp_provider.g.dart';

@Riverpod(keepAlive: true)
TotpRepository totpRepository(TotpRepositoryRef ref) {
  return TotpRepositoryImpl(
    ref.watch(appDatabaseProvider),
    ref.watch(cryptoServiceProvider),
    ref.watch(secureKeyStorageProvider),
  );
}

@riverpod
class TotpEntriesNotifier extends _$TotpEntriesNotifier {
  @override
  Future<List<TotpEntry>> build() async {
    final repo = ref.read(totpRepositoryProvider);
    final result = await repo.getAllEntries();
    return result.getOrElse((_) => []);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final repo = ref.read(totpRepositoryProvider);
    final result = await repo.getAllEntries();
    state = AsyncValue.data(result.getOrElse((_) => []));
  }

  Future<bool> addEntry(TotpEntry entry) async {
    final repo = ref.read(totpRepositoryProvider);
    final result = await repo.createEntry(entry);
    return result.fold((_) => false, (_) { refresh(); return true; });
  }

  Future<bool> deleteEntry(int id) async {
    final repo = ref.read(totpRepositoryProvider);
    final result = await repo.deleteEntry(id);
    return result.fold((_) => false, (_) { refresh(); return true; });
  }
}
