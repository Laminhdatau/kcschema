import 'package:drift/drift.dart';

/// Tabel tag bebas (custom label) - contoh: "sering rusak", "butuh jumper"
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100).unique()();
}
