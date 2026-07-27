import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/models_table.dart';
import '../tables/brands_table.dart';

part 'model_dao.g.dart';

/// DAO untuk operasi CRUD pada tabel Models (Tipe HP)
@DriftAccessor(tables: [Models, Brands])
class ModelDao extends DatabaseAccessor<AppDatabase> with _$ModelDaoMixin {
  ModelDao(super.db);

  /// Ambil semua model dari suatu merk
  Future<List<Model>> getModelsByBrand(int brandId) {
    return (select(models)
          ..where((m) => m.brandId.equals(brandId))
          ..orderBy([(m) => OrderingTerm.asc(m.name)]))
        .get();
  }

  /// Stream model dari suatu merk (reactive)
  Stream<List<Model>> watchModelsByBrand(int brandId) {
    return (select(models)
          ..where((m) => m.brandId.equals(brandId))
          ..orderBy([(m) => OrderingTerm.asc(m.name)]))
        .watch();
  }

  /// Ambil model favorit saja
  Stream<List<Model>> watchFavoriteModels() {
    return (select(models)
          ..where((m) => m.isFavorite.equals(true))
          ..orderBy([(m) => OrderingTerm.asc(m.name)]))
        .watch();
  }

  /// Tambah model baru
  Future<int> insertModel(ModelsCompanion model) {
    return into(models).insert(model);
  }

  /// Update model
  Future<bool> updateModel(Model model) {
    return update(models).replace(model);
  }

  /// Toggle favorit
  Future<void> toggleFavorite(int modelId, bool isFavorite) {
    return (update(models)..where((m) => m.id.equals(modelId)))
        .write(ModelsCompanion(isFavorite: Value(isFavorite)));
  }

  /// Hapus model
  Future<int> deleteModel(int id) {
    return (delete(models)..where((m) => m.id.equals(id))).go();
  }

  /// Cari model berdasarkan nama (untuk search)
  Future<List<Model>> searchModels(String query) {
    return (select(models)
          ..where((m) => m.name.like('%$query%'))
          ..orderBy([(m) => OrderingTerm.asc(m.name)]))
        .get();
  }
}
