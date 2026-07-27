import 'package:drift/drift.dart';

/// Tabel merk HP (Brand) - contoh: Xiaomi, Samsung, Oppo
class Brands extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100).unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
