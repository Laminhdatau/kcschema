import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/database/app_database.dart';

/// Provider untuk model yang dipilih di sidebar
class SelectedModelIdNotifier extends Notifier<int?> {
  @override
  int? build() => null;
  @override
  set state(int? value) => super.state = value;
}

final selectedModelIdProvider =
    NotifierProvider<SelectedModelIdNotifier, int?>(SelectedModelIdNotifier.new);

/// Provider untuk kategori yang dipilih di sidebar
class SelectedCategoryIdNotifier extends Notifier<int?> {
  @override
  int? build() => null;
  @override
  set state(int? value) => super.state = value;
}

final selectedCategoryIdProvider =
    NotifierProvider<SelectedCategoryIdNotifier, int?>(SelectedCategoryIdNotifier.new);

/// Provider untuk stream skematik berdasarkan model yang dipilih
final schematicListProvider = StreamProvider<List<Schematic>>((ref) {
  final db = ref.watch(databaseProvider);
  final modelId = ref.watch(selectedModelIdProvider);
  if (modelId == null) return Stream.value([]);
  return db.schematicDao.watchSchematicsByModel(modelId);
});

/// Provider untuk skematik favorit
final favoriteSchematicsProvider = StreamProvider<List<Schematic>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.schematicDao.watchFavoriteSchematics();
});

/// Provider untuk recent files
final recentSchematicsProvider = StreamProvider<List<Schematic>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.schematicDao.watchRecentSchematics(limit: 10);
});

/// Provider untuk file PDF yang sedang dibuka di viewer
class CurrentSchematicNotifier extends Notifier<Schematic?> {
  @override
  Schematic? build() => null;
  @override
  set state(Schematic? value) => super.state = value;
}

final currentSchematicProvider =
    NotifierProvider<CurrentSchematicNotifier, Schematic?>(CurrentSchematicNotifier.new);

/// Provider untuk toggle favorit skematik
final toggleSchematicFavoriteProvider =
    Provider<Future<void> Function(int id, bool isFav)>((ref) {
  final db = ref.watch(databaseProvider);
  return (int id, bool isFav) => db.schematicDao.toggleFavorite(id, isFav);
});

/// Provider untuk update last opened timestamp
final markSchematicOpenedProvider =
    Provider<Future<void> Function(int id)>((ref) {
  final db = ref.watch(databaseProvider);
  return (int id) => db.schematicDao.updateLastOpened(id);
});

/// Provider untuk hapus skematik
final deleteSchematicProvider =
    Provider<Future<int> Function(int id)>((ref) {
  final db = ref.watch(databaseProvider);
  return (int id) => db.schematicDao.deleteSchematic(id);
});

/// Provider untuk search query
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  @override
  set state(String value) => super.state = value;
}

final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

/// Provider untuk search results
final searchResultsProvider = FutureProvider<List<Schematic>>((ref) {
  final db = ref.watch(databaseProvider);
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return Future.value([]);
  return db.schematicDao.searchSchematics(query);
});

/// Provider untuk total count skematik
final schematicCountProvider = FutureProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  return db.schematicDao.countSchematics();
});

/// Provider untuk kategori dari skematik tertentu
final schematicCategoriesProvider =
    FutureProvider.family<List<Category>, int>((ref, schematicId) {
  final db = ref.watch(databaseProvider);
  return db.schematicDao.getCategoriesForSchematic(schematicId);
});

/// Provider untuk tags dari skematik tertentu
final schematicTagsProvider =
    FutureProvider.family<List<Tag>, int>((ref, schematicId) {
  final db = ref.watch(databaseProvider);
  return db.tagDao.getTagsForSchematic(schematicId);
});

/// Provider: mode tampilan (sidebar view mode)
enum SidebarViewMode { favorites, recent, browse }

class SidebarViewModeNotifier extends Notifier<SidebarViewMode> {
  @override
  SidebarViewMode build() => SidebarViewMode.browse;
  @override
  set state(SidebarViewMode value) => super.state = value;
}

final sidebarViewModeProvider =
    NotifierProvider<SidebarViewModeNotifier, SidebarViewMode>(SidebarViewModeNotifier.new);
