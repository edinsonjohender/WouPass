import 'package:drift/drift.dart';

class PairedDevices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get deviceId => text()();
  TextColumn get deviceName => text()();
  TextColumn get ip => text().withDefault(const Constant(''))();
  IntColumn get port => integer().withDefault(const Constant(9847))();
  DateTimeColumn get pairedAt => dateTime()();
  DateTimeColumn get lastSeen => dateTime()();
  TextColumn get pairingSecret => text().withDefault(const Constant(''))();
  BoolColumn get isRevoked => boolean().withDefault(const Constant(false))();
}
