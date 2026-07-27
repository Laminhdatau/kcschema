// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schematic_dao.dart';

// ignore_for_file: type=lint
mixin _$SchematicDaoMixin on DatabaseAccessor<AppDatabase> {
  $BrandsTable get brands => attachedDatabase.brands;
  $ModelsTable get models => attachedDatabase.models;
  $SchematicsTable get schematics => attachedDatabase.schematics;
  $CategoriesTable get categories => attachedDatabase.categories;
  $SchematicCategoriesTable get schematicCategories =>
      attachedDatabase.schematicCategories;
  SchematicDaoManager get managers => SchematicDaoManager(this);
}

class SchematicDaoManager {
  final _$SchematicDaoMixin _db;
  SchematicDaoManager(this._db);
  $$BrandsTableTableManager get brands =>
      $$BrandsTableTableManager(_db.attachedDatabase, _db.brands);
  $$ModelsTableTableManager get models =>
      $$ModelsTableTableManager(_db.attachedDatabase, _db.models);
  $$SchematicsTableTableManager get schematics =>
      $$SchematicsTableTableManager(_db.attachedDatabase, _db.schematics);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$SchematicCategoriesTableTableManager get schematicCategories =>
      $$SchematicCategoriesTableTableManager(
        _db.attachedDatabase,
        _db.schematicCategories,
      );
}
