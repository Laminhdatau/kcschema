import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tags_table.dart';
import '../tables/schematic_tags_table.dart';

part 'tag_dao.g.dart';

/// DAO untuk operasi CRUD pada tabel Tags (Label custom)
@DriftAccessor(tables: [Tags, SchematicTags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  TagDao(super.db);

  /// Ambil semua tag, urut berdasarkan nama
  Future<List<Tag>> getAllTags() {
    return (select(tags)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  }

  /// Stream semua tag (reactive)
  Stream<List<Tag>> watchAllTags() {
    return (select(tags)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();
  }

  /// Tambah tag baru
  Future<int> insertTag(TagsCompanion tag) {
    return into(tags).insert(tag);
  }

  /// Hapus tag + relasi
  Future<int> deleteTag(int id) async {
    return transaction(() async {
      await (delete(schematicTags)..where((st) => st.tagId.equals(id))).go();
      return (delete(tags)..where((t) => t.id.equals(id))).go();
    });
  }

  /// Assign tag ke skematik
  Future<void> addTagToSchematic(int schematicId, int tagId) {
    return into(schematicTags).insert(SchematicTagsCompanion(
      schematicId: Value(schematicId),
      tagId: Value(tagId),
    ));
  }

  /// Hapus tag dari skematik
  Future<int> removeTagFromSchematic(int schematicId, int tagId) {
    return (delete(schematicTags)
          ..where(
              (st) => st.schematicId.equals(schematicId) & st.tagId.equals(tagId)))
        .go();
  }

  /// Ambil tag dari suatu skematik
  Future<List<Tag>> getTagsForSchematic(int schematicId) async {
    final query = select(tags).join([
      innerJoin(schematicTags, schematicTags.tagId.equalsExp(tags.id)),
    ])
      ..where(schematicTags.schematicId.equals(schematicId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(tags)).toList();
  }
}
