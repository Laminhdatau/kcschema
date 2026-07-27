import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/database/app_database.dart';

/// Provider untuk stream semua kategori
final categoryListProvider = StreamProvider<List<Category>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.categoryDao.watchAllCategories();
});
