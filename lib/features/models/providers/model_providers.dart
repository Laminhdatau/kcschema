import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/database/app_database.dart';

/// Provider untuk stream model berdasarkan brand ID yang dipilih
class SelectedBrandIdNotifier extends Notifier<int?> {
  @override
  int? build() => null;
  @override
  set state(int? value) => super.state = value;
}

final selectedBrandIdProvider =
    NotifierProvider<SelectedBrandIdNotifier, int?>(SelectedBrandIdNotifier.new);

final modelListProvider = StreamProvider<List<Model>>((ref) {
  final db = ref.watch(databaseProvider);
  final brandId = ref.watch(selectedBrandIdProvider);
  if (brandId == null) return Stream.value([]);
  return db.modelDao.watchModelsByBrand(brandId);
});

/// Provider untuk model favorit
final favoriteModelsProvider = StreamProvider<List<Model>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.modelDao.watchFavoriteModels();
});

/// Provider untuk tambah model
final addModelProvider =
    Provider<Future<int> Function(int brandId, String name)>((ref) {
  final db = ref.watch(databaseProvider);
  return (int brandId, String name) => db.modelDao.insertModel(
        ModelsCompanion(
          brandId: Value(brandId),
          name: Value(name),
        ),
      );
});

/// Provider untuk hapus model
final deleteModelProvider = Provider<Future<int> Function(int id)>((ref) {
  final db = ref.watch(databaseProvider);
  return (int id) => db.modelDao.deleteModel(id);
});

/// Provider untuk update model (rename, dsb)
final updateModelProvider =
    Provider<Future<bool> Function(Model model)>((ref) {
  final db = ref.watch(databaseProvider);
  return (Model model) => db.modelDao.updateModel(model);
});

/// Provider untuk toggle favorit model
final toggleModelFavoriteProvider =
    Provider<Future<void> Function(int id, bool isFav)>((ref) {
  final db = ref.watch(databaseProvider);
  return (int id, bool isFav) => db.modelDao.toggleFavorite(id, isFav);
});
