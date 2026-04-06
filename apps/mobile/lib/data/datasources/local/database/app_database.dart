import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:woupassv2/core/constants/app_constants.dart';
import 'tables/vault_entries_table.dart';
import 'tables/categories_table.dart';
import 'tables/totp_entries_table.dart';
import 'tables/settings_table.dart';
import 'tables/paired_devices_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [VaultEntries, Categories, TotpEntries, SettingsTable, PairedDevices])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _seedDefaultCategories();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(pairedDevices);
      }
      if (from < 3) {
        // Add ip and port columns to paired_devices
        await m.addColumn(pairedDevices, pairedDevices.ip);
        await m.addColumn(pairedDevices, pairedDevices.port);
      }
      if (from < 4) {
        // Add pairingSecret column for PSK-encrypted reconnect
        await m.addColumn(pairedDevices, pairedDevices.pairingSecret);
      }
    },
  );

  Future<void> _seedDefaultCategories() async {
    final defaults = [
      ('General', 'globe', '#6C63FF', true, 0),
      ('Social', 'users', '#FF6584', false, 1),
      ('Finance', 'credit-card', '#43A047', false, 2),
      ('Email', 'mail', '#FF9800', false, 3),
      ('Work', 'briefcase', '#2196F3', false, 4),
    ];
    for (final (name, icon, color, isDefault, order) in defaults) {
      await into(categories).insert(CategoriesCompanion.insert(
        name: name,
        icon: Value(icon),
        colorHex: Value(color),
        isDefault: Value(isDefault),
        sortOrder: Value(order),
        createdAt: DateTime.now(),
      ));
    }
  }

  // ---- VaultEntries ----
  Future<List<VaultEntry>> getAllVaultEntries() => select(vaultEntries).get();
  Stream<List<VaultEntry>> watchAllVaultEntries() => select(vaultEntries).watch();
  Future<VaultEntry> getVaultEntry(int id) =>
      (select(vaultEntries)..where((t) => t.id.equals(id))).getSingle();
  Future<int> insertVaultEntry(VaultEntriesCompanion entry) =>
      into(vaultEntries).insert(entry);
  Future<bool> updateVaultEntry(VaultEntriesCompanion entry) =>
      update(vaultEntries).replace(entry);
  Future<int> deleteVaultEntry(int id) =>
      (delete(vaultEntries)..where((t) => t.id.equals(id))).go();

  // ---- Categories ----
  Future<List<Category>> getAllCategories() => select(categories).get();
  Stream<List<Category>> watchAllCategories() => select(categories).watch();
  Future<int> insertCategory(CategoriesCompanion entry) =>
      into(categories).insert(entry);
  Future<bool> updateCategory(CategoriesCompanion entry) =>
      update(categories).replace(entry);
  Future<int> deleteCategory(int id) =>
      (delete(categories)..where((t) => t.id.equals(id))).go();

  // ---- TotpEntries ----
  Future<List<TotpEntry>> getAllTotpEntries() => select(totpEntries).get();
  Future<int> insertTotpEntry(TotpEntriesCompanion entry) =>
      into(totpEntries).insert(entry);
  Future<int> deleteTotpEntry(int id) =>
      (delete(totpEntries)..where((t) => t.id.equals(id))).go();

  // ---- PairedDevices ----
  Future<List<PairedDevice>> getAllPairedDevices() =>
      (select(pairedDevices)..where((t) => t.isRevoked.equals(false))).get();

  Future<PairedDevice?> getPairedDeviceByDeviceId(String deviceId) =>
      (select(pairedDevices)
            ..where((t) => t.deviceId.equals(deviceId))
            ..where((t) => t.isRevoked.equals(false)))
          .getSingleOrNull();

  Future<int> insertPairedDevice(PairedDevicesCompanion device) =>
      into(pairedDevices).insert(device);

  Future<void> revokePairedDevice(int id) async {
    await (update(pairedDevices)..where((t) => t.id.equals(id)))
        .write(const PairedDevicesCompanion(isRevoked: Value(true)));
  }

  Future<int> deletePairedDevice(int id) =>
      (delete(pairedDevices)..where((t) => t.id.equals(id))).go();

  // ---- Settings ----
  Future<String?> getSetting(String key) async {
    final result = await (select(settingsTable)..where((t) => t.key.equals(key))).getSingleOrNull();
    return result?.value;
  }
  Future<void> setSetting(String key, String value) async {
    await into(settingsTable).insertOnConflictUpdate(
      SettingsTableCompanion.insert(key: key, value: value),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseName));
    return NativeDatabase.createInBackground(file);
  });
}
