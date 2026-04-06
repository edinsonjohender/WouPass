import 'package:drift/drift.dart';
import 'categories_table.dart';

class VaultEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get username => text().withDefault(const Constant(''))();
  TextColumn get password => text()();
  TextColumn get uri => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();
  TextColumn get icon => text().withDefault(const Constant('globe'))();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();
  IntColumn get passwordRenewalDays => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastPasswordChange => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
