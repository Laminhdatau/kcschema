import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/brands_table.dart';

part 'brand_dao.g.dart';

/// DAO untuk operasi CRUD pada tabel Brands (Merk HP)
@DriftAccessor(tables: [Brands])
class BrandDao extends DatabaseAccessor<AppDatabase> with _$BrandDaoMixin {
  BrandDao(super.db);

  /// Ambil semua merk, urut berdasarkan nama
  Future<List<Brand>> getAllBrands() {
    return (select(brands)..orderBy([(b) => OrderingTerm.asc(b.name)])).get();
  }

  /// Stream semua merk (reactive, auto-update UI)
  Stream<List<Brand>> watchAllBrands() {
    return (select(brands)..orderBy([(b) => OrderingTerm.asc(b.name)])).watch();
  }

  /// Tambah merk baru
  Future<int> insertBrand(BrandsCompanion brand) {
    return into(brands).insert(brand);
  }

  /// Update merk
  Future<bool> updateBrand(Brand brand) {
    return update(brands).replace(brand);
  }

  /// Hapus merk berdasarkan ID
  Future<int> deleteBrand(int id) {
    return (delete(brands)..where((b) => b.id.equals(id))).go();
  }

  /// Cari merk berdasarkan nama
  Future<Brand?> getBrandByName(String name) {
    return (select(brands)..where((b) => b.name.equals(name)))
        .getSingleOrNull();
  }
}
