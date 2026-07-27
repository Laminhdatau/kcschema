import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/schematics_table.dart';
import '../tables/schematic_categories_table.dart';
import '../tables/categories_table.dart';
import '../tables/models_table.dart';

part 'schematic_dao.g.dart';

/// DAO untuk operasi CRUD pada tabel Schematics (File Skematik PDF)
@DriftAccessor(tables: [Schematics, SchematicCategories, Categories, Models])
class SchematicDao extends DatabaseAccessor<AppDatabase>
    with _$SchematicDaoMixin {
  SchematicDao(super.db);

  /// Ambil semua skematik dari suatu model HP
  Future<List<Schematic>> getSchematicsByModel(int modelId) {
    return (select(schematics)
          ..where((s) => s.modelId.equals(modelId))
          ..orderBy([(s) => OrderingTerm.desc(s.importedAt)]))
        .get();
  }

  /// Stream skematik dari suatu model (reactive)
  Stream<List<Schematic>> watchSchematicsByModel(int modelId) {
    return (select(schematics)
          ..where((s) => s.modelId.equals(modelId))
          ..orderBy([(s) => OrderingTerm.desc(s.importedAt)]))
        .watch();
  }

  /// Ambil skematik berdasarkan kategori
  Future<List<Schematic>> getSchematicsByCategory(int categoryId) async {
    final query = select(schematics).join([
      innerJoin(schematicCategories,
          schematicCategories.schematicId.equalsExp(schematics.id)),
    ])
      ..where(schematicCategories.categoryId.equals(categoryId))
      ..orderBy([OrderingTerm.desc(schematics.importedAt)]);

    final rows = await query.get();
    return rows.map((row) => row.readTable(schematics)).toList();
  }

  /// Stream skematik favorit
  Stream<List<Schematic>> watchFavoriteSchematics() {
    return (select(schematics)
          ..where((s) => s.isFavorite.equals(true))
          ..orderBy([(s) => OrderingTerm.desc(s.importedAt)]))
        .watch();
  }

  /// Stream recent files (10 terakhir yang dibuka)
  Stream<List<Schematic>> watchRecentSchematics({int limit = 10}) {
    return (select(schematics)
          ..where((s) => s.lastOpenedAt.isNotNull())
          ..orderBy([(s) => OrderingTerm.desc(s.lastOpenedAt)])
          ..limit(limit))
        .watch();
  }

  /// Tambah skematik baru + assign kategori
  Future<int> insertSchematic(
    SchematicsCompanion schematic,
    List<int> categoryIds,
  ) async {
    return transaction(() async {
      final schematicId = await into(schematics).insert(schematic);

      for (final categoryId in categoryIds) {
        await into(schematicCategories).insert(SchematicCategoriesCompanion(
          schematicId: Value(schematicId),
          categoryId: Value(categoryId),
        ));
      }

      return schematicId;
    });
  }

  /// Update metadata skematik
  Future<bool> updateSchematic(Schematic schematic) {
    return update(schematics).replace(schematic);
  }

  /// Update timestamp terakhir dibuka
  Future<void> updateLastOpened(int schematicId) {
    return (update(schematics)..where((s) => s.id.equals(schematicId))).write(
      SchematicsCompanion(lastOpenedAt: Value(DateTime.now())),
    );
  }

  /// Toggle favorit
  Future<void> toggleFavorite(int schematicId, bool isFavorite) {
    return (update(schematics)..where((s) => s.id.equals(schematicId)))
        .write(SchematicsCompanion(isFavorite: Value(isFavorite)));
  }

  /// Hapus skematik (beserta relasi kategori & tag)
  Future<int> deleteSchematic(int id) async {
    return transaction(() async {
      await (delete(schematicCategories)
            ..where((sc) => sc.schematicId.equals(id)))
          .go();
      return (delete(schematics)..where((s) => s.id.equals(id))).go();
    });
  }

  /// Update kategori skematik (hapus semua lalu insert ulang)
  Future<void> updateSchematicCategories(
    int schematicId,
    List<int> categoryIds,
  ) async {
    return transaction(() async {
      await (delete(schematicCategories)
            ..where((sc) => sc.schematicId.equals(schematicId)))
          .go();
      for (final categoryId in categoryIds) {
        await into(schematicCategories).insert(SchematicCategoriesCompanion(
          schematicId: Value(schematicId),
          categoryId: Value(categoryId),
        ));
      }
    });
  }

  /// Ambil kategori dari suatu skematik
  Future<List<Category>> getCategoriesForSchematic(int schematicId) async {
    final query = select(categories).join([
      innerJoin(schematicCategories,
          schematicCategories.categoryId.equalsExp(categories.id)),
    ])
      ..where(schematicCategories.schematicId.equals(schematicId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(categories)).toList();
  }

  /// Cari skematik berdasarkan nama file
  Future<List<Schematic>> searchSchematics(String query) {
    return (select(schematics)
          ..where((s) =>
              s.fileName.like('%$query%') |
              s.originalFileName.like('%$query%'))
          ..orderBy([(s) => OrderingTerm.asc(s.fileName)]))
        .get();
  }

  /// Hitung total skematik
  Future<int> countSchematics() async {
    final count = countAll();
    final query = selectOnly(schematics)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
