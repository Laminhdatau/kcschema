import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/database/app_database.dart';

/// Provider untuk stream daftar semua merk (reactive)
final brandListProvider = StreamProvider<List<Brand>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.brandDao.watchAllBrands();
});

/// Provider untuk tambah merk baru
final addBrandProvider = Provider<Future<int> Function(String name)>((ref) {
  final db = ref.watch(databaseProvider);
  return (String name) => db.brandDao.insertBrand(
        BrandsCompanion(name: Value(name)),
      );
});

/// Provider untuk update merk
final updateBrandProvider =
    Provider<Future<bool> Function(Brand brand)>((ref) {
  final db = ref.watch(databaseProvider);
  return (Brand brand) => db.brandDao.updateBrand(brand);
});

/// Provider untuk hapus merk
final deleteBrandProvider = Provider<Future<int> Function(int id)>((ref) {
  final db = ref.watch(databaseProvider);
  return (int id) => db.brandDao.deleteBrand(id);
});
