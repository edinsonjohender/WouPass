import 'package:drift/drift.dart';

@DataClassName('SettingEntry')
class SettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();

  @override
  String get tableName => 'settings';
}
