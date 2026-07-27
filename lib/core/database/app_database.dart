import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/brands_table.dart';
import 'tables/models_table.dart';
import 'tables/categories_table.dart';
import 'tables/schematics_table.dart';
import 'tables/schematic_categories_table.dart';
import 'tables/tags_table.dart';
import 'tables/schematic_tags_table.dart';

import 'daos/brand_dao.dart';
import 'daos/model_dao.dart';
import 'daos/category_dao.dart';
import 'daos/schematic_dao.dart';
import 'daos/tag_dao.dart';

import 'seed_data.dart';

part 'app_database.g.dart';

/// Database utama KYASCHEMA menggunakan Drift (SQLite).
///
/// Menyimpan semua metadata skematik HP:
/// - Merk (brands), Tipe HP (models), Kategori blok rangkaian (categories)
/// - File skematik (schematics) dengan relasi many-to-many ke categories dan tags
@DriftDatabase(
  tables: [
    Brands,
    Models,
    Categories,
    Schematics,
    SchematicCategories,
    Tags,
    SchematicTags,
  ],
  daos: [
    BrandDao,
    ModelDao,
    CategoryDao,
    SchematicDao,
    TagDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor untuk testing dengan QueryExecutor kustom
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  /// Buat koneksi database menggunakan drift_flutter
  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'kyaschema_db');
  }

  /// Seed kategori default saat database pertama kali dibuat
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          // Seed kategori default
          await _seedDefaultCategories();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future schema migrations akan ditangani di sini
        },
      );

  /// Insert 12 kategori default dari SeedData
  Future<void> _seedDefaultCategories() async {
    for (final category in SeedData.defaultCategories) {
      await into(categories).insert(CategoriesCompanion(
        name: Value(category['name'] as String),
        isDefault: const Value(true),
        iconKey: Value(category['icon_key'] as String),
      ));
    }
  }
}
