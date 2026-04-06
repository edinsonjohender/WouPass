import 'package:drift/drift.dart';
import 'vault_entries_table.dart';

class TotpEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get issuer => text()();
  TextColumn get accountName => text()();
  TextColumn get secret => text()();
  IntColumn get digits => integer().withDefault(const Constant(6))();
  IntColumn get period => integer().withDefault(const Constant(30))();
  TextColumn get algorithm => text().withDefault(const Constant('SHA1'))();
  IntColumn get vaultEntryId => integer().nullable().references(VaultEntries, #id)();
  DateTimeColumn get createdAt => dateTime()();
}
