import 'package:drift/drift.dart';
import 'models_table.dart';

/// Tabel file skematik (PDF) yang di-import ke aplikasi
class Schematics extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get modelId => integer().references(Models, #id)();
  TextColumn get fileName => text().withLength(min: 1, max: 255)();
  TextColumn get filePath => text()(); // Path relatif ke folder data
  TextColumn get originalFileName => text().withLength(min: 1, max: 255)();
  TextColumn get notes => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get importedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastOpenedAt => dateTime().nullable()();
}
