// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_dao.dart';

// ignore_for_file: type=lint
mixin _$BrandDaoMixin on DatabaseAccessor<AppDatabase> {
  $BrandsTable get brands => attachedDatabase.brands;
  BrandDaoManager get managers => BrandDaoManager(this);
}

class BrandDaoManager {
  final _$BrandDaoMixin _db;
  BrandDaoManager(this._db);
  $$BrandsTableTableManager get brands =>
      $$BrandsTableTableManager(_db.attachedDatabase, _db.brands);
}
