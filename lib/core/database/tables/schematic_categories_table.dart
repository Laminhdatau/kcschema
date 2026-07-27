import 'package:drift/drift.dart';
import 'schematics_table.dart';
import 'categories_table.dart';

/// Tabel junction many-to-many antara schematics dan categories
/// Satu file skematik bisa punya lebih dari satu kategori
class SchematicCategories extends Table {
  IntColumn get schematicId => integer().references(Schematics, #id)();
  IntColumn get categoryId => integer().references(Categories, #id)();

  @override
  Set<Column> get primaryKey => {schematicId, categoryId};
}
