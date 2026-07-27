// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_dao.dart';

// ignore_for_file: type=lint
mixin _$ModelDaoMixin on DatabaseAccessor<AppDatabase> {
  $BrandsTable get brands => attachedDatabase.brands;
  $ModelsTable get models => attachedDatabase.models;
  ModelDaoManager get managers => ModelDaoManager(this);
}

class ModelDaoManager {
  final _$ModelDaoMixin _db;
  ModelDaoManager(this._db);
  $$BrandsTableTableManager get brands =>
      $$BrandsTableTableManager(_db.attachedDatabase, _db.brands);
  $$ModelsTableTableManager get models =>
      $$ModelsTableTableManager(_db.attachedDatabase, _db.models);
}
