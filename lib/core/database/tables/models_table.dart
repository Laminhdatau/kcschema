import 'package:drift/drift.dart';
import 'brands_table.dart';

/// Tabel tipe/model HP - contoh: Redmi Note 8, Galaxy A03
class Models extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get brandId => integer().references(Brands, #id)();
  TextColumn get name => text().withLength(min: 1, max: 150)();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
