import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/categories_table.dart';

part 'category_dao.g.dart';

/// DAO untuk operasi CRUD pada tabel Categories (Kategori Blok Rangkaian)
@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  /// Ambil semua kategori, urut berdasarkan nama
  Future<List<Category>> getAllCategories() {
    return (select(categories)..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();
  }

  /// Stream semua kategori (reactive)
  Stream<List<Category>> watchAllCategories() {
    return (select(categories)..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .watch();
  }

  /// Tambah kategori baru
  Future<int> insertCategory(CategoriesCompanion category) {
    return into(categories).insert(category);
  }

  /// Update kategori
  Future<bool> updateCategory(Category category) {
    return update(categories).replace(category);
  }

  /// Hapus kategori (hanya non-default)
  Future<int> deleteCategory(int id) {
    return (delete(categories)
          ..where((c) => c.id.equals(id) & c.isDefault.equals(false)))
        .go();
  }
}
