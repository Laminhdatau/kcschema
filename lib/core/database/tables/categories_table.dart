import 'package:drift/drift.dart';

/// Tabel kategori blok rangkaian - contoh: Charging, LCD, Audio
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100).unique()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  TextColumn get iconKey => text().withLength(max: 50).nullable()();
}
