import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:woupassv2/data/repositories/vault_entry_repository_impl.dart';
import 'package:woupassv2/domain/entities/vault_entry.dart';
import 'package:woupassv2/domain/repositories/vault_entry_repository.dart';
import 'package:woupassv2/presentation/providers/core/crypto_provider.dart';
import 'package:woupassv2/presentation/providers/core/database_provider.dart';

part 'vault_provider.g.dart';

@Riverpod(keepAlive: true)
VaultEntryRepository vaultEntryRepository(VaultEntryRepositoryRef ref) {
  return VaultEntryRepositoryImpl(
    ref.watch(appDatabaseProvider),
    ref.watch(cryptoServiceProvider),
    ref.watch(secureKeyStorageProvider),
  );
}

@riverpod
class VaultEntriesNotifier extends _$VaultEntriesNotifier {
  @override
  Future<List<VaultEntry>> build() async {
    return _loadEntries();
  }

  Future<List<VaultEntry>> _loadEntries() async {
    final repo = ref.read(vaultEntryRepositoryProvider);
    final result = await repo.getAllEntries();
    return result.getOrElse((_) => []);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadEntries());
  }

  Future<bool> addEntry(VaultEntry entry) async {
    final repo = ref.read(vaultEntryRepositoryProvider);
    final result = await repo.createEntry(entry);
    return result.fold(
      (_) => false,
      (_) {
        refresh();
        return true;
      },
    );
  }

  Future<bool> updateEntry(VaultEntry entry) async {
    final repo = ref.read(vaultEntryRepositoryProvider);
    final result = await repo.updateEntry(entry);
    return result.fold(
      (_) => false,
      (_) {
        refresh();
        return true;
      },
    );
  }

  Future<bool> deleteEntry(int id) async {
    final repo = ref.read(vaultEntryRepositoryProvider);
    final result = await repo.deleteEntry(id);
    return result.fold(
      (_) => false,
      (_) {
        refresh();
        return true;
      },
    );
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      await refresh();
      return;
    }
    final repo = ref.read(vaultEntryRepositoryProvider);
    final result = await repo.searchEntries(query);
    state = AsyncValue.data(result.getOrElse((_) => []));
  }
}
