// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_dao.dart';

// ignore_for_file: type=lint
mixin _$TagDaoMixin on DatabaseAccessor<AppDatabase> {
  $TagsTable get tags => attachedDatabase.tags;
  $BrandsTable get brands => attachedDatabase.brands;
  $ModelsTable get models => attachedDatabase.models;
  $SchematicsTable get schematics => attachedDatabase.schematics;
  $SchematicTagsTable get schematicTags => attachedDatabase.schematicTags;
  TagDaoManager get managers => TagDaoManager(this);
}

class TagDaoManager {
  final _$TagDaoMixin _db;
  TagDaoManager(this._db);
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
  $$BrandsTableTableManager get brands =>
      $$BrandsTableTableManager(_db.attachedDatabase, _db.brands);
  $$ModelsTableTableManager get models =>
      $$ModelsTableTableManager(_db.attachedDatabase, _db.models);
  $$SchematicsTableTableManager get schematics =>
      $$SchematicsTableTableManager(_db.attachedDatabase, _db.schematics);
  $$SchematicTagsTableTableManager get schematicTags =>
      $$SchematicTagsTableTableManager(_db.attachedDatabase, _db.schematicTags);
}
