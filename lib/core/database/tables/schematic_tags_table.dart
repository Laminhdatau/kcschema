import 'package:drift/drift.dart';
import 'schematics_table.dart';
import 'tags_table.dart';

/// Tabel junction many-to-many antara schematics dan tags
class SchematicTags extends Table {
  IntColumn get schematicId => integer().references(Schematics, #id)();
  IntColumn get tagId => integer().references(Tags, #id)();

  @override
  Set<Column> get primaryKey => {schematicId, tagId};
}
