// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BrandsTable extends Brands with TableInfo<$BrandsTable, Brand> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrandsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brands';
  @override
  VerificationContext validateIntegrity(
    Insertable<Brand> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Brand map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Brand(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BrandsTable createAlias(String alias) {
    return $BrandsTable(attachedDatabase, alias);
  }
}

class Brand extends DataClass implements Insertable<Brand> {
  final int id;
  final String name;
  final DateTime createdAt;
  const Brand({required this.id, required this.name, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BrandsCompanion toCompanion(bool nullToAbsent) {
    return BrandsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory Brand.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Brand(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Brand copyWith({int? id, String? name, DateTime? createdAt}) => Brand(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
  );
  Brand copyWithCompanion(BrandsCompanion data) {
    return Brand(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Brand(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Brand &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class BrandsCompanion extends UpdateCompanion<Brand> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  const BrandsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BrandsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Brand> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BrandsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
  }) {
    return BrandsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrandsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ModelsTable extends Models with TableInfo<$ModelsTable, Model> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<int> brandId = GeneratedColumn<int>(
    'brand_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES brands (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 150,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    brandId,
    name,
    isFavorite,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'models';
  @override
  VerificationContext validateIntegrity(
    Insertable<Model> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    } else if (isInserting) {
      context.missing(_brandIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Model map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Model(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brand_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ModelsTable createAlias(String alias) {
    return $ModelsTable(attachedDatabase, alias);
  }
}

class Model extends DataClass implements Insertable<Model> {
  final int id;
  final int brandId;
  final String name;
  final bool isFavorite;
  final DateTime createdAt;
  const Model({
    required this.id,
    required this.brandId,
    required this.name,
    required this.isFavorite,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['brand_id'] = Variable<int>(brandId);
    map['name'] = Variable<String>(name);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ModelsCompanion toCompanion(bool nullToAbsent) {
    return ModelsCompanion(
      id: Value(id),
      brandId: Value(brandId),
      name: Value(name),
      isFavorite: Value(isFavorite),
      createdAt: Value(createdAt),
    );
  }

  factory Model.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Model(
      id: serializer.fromJson<int>(json['id']),
      brandId: serializer.fromJson<int>(json['brandId']),
      name: serializer.fromJson<String>(json['name']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'brandId': serializer.toJson<int>(brandId),
      'name': serializer.toJson<String>(name),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Model copyWith({
    int? id,
    int? brandId,
    String? name,
    bool? isFavorite,
    DateTime? createdAt,
  }) => Model(
    id: id ?? this.id,
    brandId: brandId ?? this.brandId,
    name: name ?? this.name,
    isFavorite: isFavorite ?? this.isFavorite,
    createdAt: createdAt ?? this.createdAt,
  );
  Model copyWithCompanion(ModelsCompanion data) {
    return Model(
      id: data.id.present ? data.id.value : this.id,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      name: data.name.present ? data.name.value : this.name,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Model(')
          ..write('id: $id, ')
          ..write('brandId: $brandId, ')
          ..write('name: $name, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, brandId, name, isFavorite, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Model &&
          other.id == this.id &&
          other.brandId == this.brandId &&
          other.name == this.name &&
          other.isFavorite == this.isFavorite &&
          other.createdAt == this.createdAt);
}

class ModelsCompanion extends UpdateCompanion<Model> {
  final Value<int> id;
  final Value<int> brandId;
  final Value<String> name;
  final Value<bool> isFavorite;
  final Value<DateTime> createdAt;
  const ModelsCompanion({
    this.id = const Value.absent(),
    this.brandId = const Value.absent(),
    this.name = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ModelsCompanion.insert({
    this.id = const Value.absent(),
    required int brandId,
    required String name,
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : brandId = Value(brandId),
       name = Value(name);
  static Insertable<Model> custom({
    Expression<int>? id,
    Expression<int>? brandId,
    Expression<String>? name,
    Expression<bool>? isFavorite,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brandId != null) 'brand_id': brandId,
      if (name != null) 'name': name,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ModelsCompanion copyWith({
    Value<int>? id,
    Value<int>? brandId,
    Value<String>? name,
    Value<bool>? isFavorite,
    Value<DateTime>? createdAt,
  }) {
    return ModelsCompanion(
      id: id ?? this.id,
      brandId: brandId ?? this.brandId,
      name: name ?? this.name,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<int>(brandId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModelsCompanion(')
          ..write('id: $id, ')
          ..write('brandId: $brandId, ')
          ..write('name: $name, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, isDefault, iconKey];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      ),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final bool isDefault;
  final String? iconKey;
  const Category({
    required this.id,
    required this.name,
    required this.isDefault,
    this.iconKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_default'] = Variable<bool>(isDefault);
    if (!nullToAbsent || iconKey != null) {
      map['icon_key'] = Variable<String>(iconKey);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      isDefault: Value(isDefault),
      iconKey: iconKey == null && nullToAbsent
          ? const Value.absent()
          : Value(iconKey),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      iconKey: serializer.fromJson<String?>(json['iconKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isDefault': serializer.toJson<bool>(isDefault),
      'iconKey': serializer.toJson<String?>(iconKey),
    };
  }

  Category copyWith({
    int? id,
    String? name,
    bool? isDefault,
    Value<String?> iconKey = const Value.absent(),
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    isDefault: isDefault ?? this.isDefault,
    iconKey: iconKey.present ? iconKey.value : this.iconKey,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDefault: $isDefault, ')
          ..write('iconKey: $iconKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isDefault, iconKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.isDefault == this.isDefault &&
          other.iconKey == this.iconKey);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isDefault;
  final Value<String?> iconKey;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.iconKey = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isDefault = const Value.absent(),
    this.iconKey = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isDefault,
    Expression<String>? iconKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isDefault != null) 'is_default': isDefault,
      if (iconKey != null) 'icon_key': iconKey,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isDefault,
    Value<String?>? iconKey,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
      iconKey: iconKey ?? this.iconKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDefault: $isDefault, ')
          ..write('iconKey: $iconKey')
          ..write(')'))
        .toString();
  }
}

class $SchematicsTable extends Schematics
    with TableInfo<$SchematicsTable, Schematic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchematicsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _modelIdMeta = const VerificationMeta(
    'modelId',
  );
  @override
  late final GeneratedColumn<int> modelId = GeneratedColumn<int>(
    'model_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES models (id)',
    ),
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalFileNameMeta = const VerificationMeta(
    'originalFileName',
  );
  @override
  late final GeneratedColumn<String> originalFileName = GeneratedColumn<String>(
    'original_file_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastOpenedAtMeta = const VerificationMeta(
    'lastOpenedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastOpenedAt = GeneratedColumn<DateTime>(
    'last_opened_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    modelId,
    fileName,
    filePath,
    originalFileName,
    notes,
    isFavorite,
    importedAt,
    lastOpenedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schematics';
  @override
  VerificationContext validateIntegrity(
    Insertable<Schematic> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('model_id')) {
      context.handle(
        _modelIdMeta,
        modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modelIdMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('original_file_name')) {
      context.handle(
        _originalFileNameMeta,
        originalFileName.isAcceptableOrUnknown(
          data['original_file_name']!,
          _originalFileNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalFileNameMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    }
    if (data.containsKey('last_opened_at')) {
      context.handle(
        _lastOpenedAtMeta,
        lastOpenedAt.isAcceptableOrUnknown(
          data['last_opened_at']!,
          _lastOpenedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Schematic map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Schematic(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      modelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}model_id'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      originalFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_file_name'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_at'],
      )!,
      lastOpenedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_opened_at'],
      ),
    );
  }

  @override
  $SchematicsTable createAlias(String alias) {
    return $SchematicsTable(attachedDatabase, alias);
  }
}

class Schematic extends DataClass implements Insertable<Schematic> {
  final int id;
  final int modelId;
  final String fileName;
  final String filePath;
  final String originalFileName;
  final String? notes;
  final bool isFavorite;
  final DateTime importedAt;
  final DateTime? lastOpenedAt;
  const Schematic({
    required this.id,
    required this.modelId,
    required this.fileName,
    required this.filePath,
    required this.originalFileName,
    this.notes,
    required this.isFavorite,
    required this.importedAt,
    this.lastOpenedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['model_id'] = Variable<int>(modelId);
    map['file_name'] = Variable<String>(fileName);
    map['file_path'] = Variable<String>(filePath);
    map['original_file_name'] = Variable<String>(originalFileName);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['imported_at'] = Variable<DateTime>(importedAt);
    if (!nullToAbsent || lastOpenedAt != null) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt);
    }
    return map;
  }

  SchematicsCompanion toCompanion(bool nullToAbsent) {
    return SchematicsCompanion(
      id: Value(id),
      modelId: Value(modelId),
      fileName: Value(fileName),
      filePath: Value(filePath),
      originalFileName: Value(originalFileName),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isFavorite: Value(isFavorite),
      importedAt: Value(importedAt),
      lastOpenedAt: lastOpenedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOpenedAt),
    );
  }

  factory Schematic.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Schematic(
      id: serializer.fromJson<int>(json['id']),
      modelId: serializer.fromJson<int>(json['modelId']),
      fileName: serializer.fromJson<String>(json['fileName']),
      filePath: serializer.fromJson<String>(json['filePath']),
      originalFileName: serializer.fromJson<String>(json['originalFileName']),
      notes: serializer.fromJson<String?>(json['notes']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
      lastOpenedAt: serializer.fromJson<DateTime?>(json['lastOpenedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'modelId': serializer.toJson<int>(modelId),
      'fileName': serializer.toJson<String>(fileName),
      'filePath': serializer.toJson<String>(filePath),
      'originalFileName': serializer.toJson<String>(originalFileName),
      'notes': serializer.toJson<String?>(notes),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'importedAt': serializer.toJson<DateTime>(importedAt),
      'lastOpenedAt': serializer.toJson<DateTime?>(lastOpenedAt),
    };
  }

  Schematic copyWith({
    int? id,
    int? modelId,
    String? fileName,
    String? filePath,
    String? originalFileName,
    Value<String?> notes = const Value.absent(),
    bool? isFavorite,
    DateTime? importedAt,
    Value<DateTime?> lastOpenedAt = const Value.absent(),
  }) => Schematic(
    id: id ?? this.id,
    modelId: modelId ?? this.modelId,
    fileName: fileName ?? this.fileName,
    filePath: filePath ?? this.filePath,
    originalFileName: originalFileName ?? this.originalFileName,
    notes: notes.present ? notes.value : this.notes,
    isFavorite: isFavorite ?? this.isFavorite,
    importedAt: importedAt ?? this.importedAt,
    lastOpenedAt: lastOpenedAt.present ? lastOpenedAt.value : this.lastOpenedAt,
  );
  Schematic copyWithCompanion(SchematicsCompanion data) {
    return Schematic(
      id: data.id.present ? data.id.value : this.id,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      originalFileName: data.originalFileName.present
          ? data.originalFileName.value
          : this.originalFileName,
      notes: data.notes.present ? data.notes.value : this.notes,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
      lastOpenedAt: data.lastOpenedAt.present
          ? data.lastOpenedAt.value
          : this.lastOpenedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Schematic(')
          ..write('id: $id, ')
          ..write('modelId: $modelId, ')
          ..write('fileName: $fileName, ')
          ..write('filePath: $filePath, ')
          ..write('originalFileName: $originalFileName, ')
          ..write('notes: $notes, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('importedAt: $importedAt, ')
          ..write('lastOpenedAt: $lastOpenedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    modelId,
    fileName,
    filePath,
    originalFileName,
    notes,
    isFavorite,
    importedAt,
    lastOpenedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Schematic &&
          other.id == this.id &&
          other.modelId == this.modelId &&
          other.fileName == this.fileName &&
          other.filePath == this.filePath &&
          other.originalFileName == this.originalFileName &&
          other.notes == this.notes &&
          other.isFavorite == this.isFavorite &&
          other.importedAt == this.importedAt &&
          other.lastOpenedAt == this.lastOpenedAt);
}

class SchematicsCompanion extends UpdateCompanion<Schematic> {
  final Value<int> id;
  final Value<int> modelId;
  final Value<String> fileName;
  final Value<String> filePath;
  final Value<String> originalFileName;
  final Value<String?> notes;
  final Value<bool> isFavorite;
  final Value<DateTime> importedAt;
  final Value<DateTime?> lastOpenedAt;
  const SchematicsCompanion({
    this.id = const Value.absent(),
    this.modelId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.filePath = const Value.absent(),
    this.originalFileName = const Value.absent(),
    this.notes = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
  });
  SchematicsCompanion.insert({
    this.id = const Value.absent(),
    required int modelId,
    required String fileName,
    required String filePath,
    required String originalFileName,
    this.notes = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
  }) : modelId = Value(modelId),
       fileName = Value(fileName),
       filePath = Value(filePath),
       originalFileName = Value(originalFileName);
  static Insertable<Schematic> custom({
    Expression<int>? id,
    Expression<int>? modelId,
    Expression<String>? fileName,
    Expression<String>? filePath,
    Expression<String>? originalFileName,
    Expression<String>? notes,
    Expression<bool>? isFavorite,
    Expression<DateTime>? importedAt,
    Expression<DateTime>? lastOpenedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modelId != null) 'model_id': modelId,
      if (fileName != null) 'file_name': fileName,
      if (filePath != null) 'file_path': filePath,
      if (originalFileName != null) 'original_file_name': originalFileName,
      if (notes != null) 'notes': notes,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (importedAt != null) 'imported_at': importedAt,
      if (lastOpenedAt != null) 'last_opened_at': lastOpenedAt,
    });
  }

  SchematicsCompanion copyWith({
    Value<int>? id,
    Value<int>? modelId,
    Value<String>? fileName,
    Value<String>? filePath,
    Value<String>? originalFileName,
    Value<String?>? notes,
    Value<bool>? isFavorite,
    Value<DateTime>? importedAt,
    Value<DateTime?>? lastOpenedAt,
  }) {
    return SchematicsCompanion(
      id: id ?? this.id,
      modelId: modelId ?? this.modelId,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      originalFileName: originalFileName ?? this.originalFileName,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
      importedAt: importedAt ?? this.importedAt,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (modelId.present) {
      map['model_id'] = Variable<int>(modelId.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (originalFileName.present) {
      map['original_file_name'] = Variable<String>(originalFileName.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    if (lastOpenedAt.present) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchematicsCompanion(')
          ..write('id: $id, ')
          ..write('modelId: $modelId, ')
          ..write('fileName: $fileName, ')
          ..write('filePath: $filePath, ')
          ..write('originalFileName: $originalFileName, ')
          ..write('notes: $notes, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('importedAt: $importedAt, ')
          ..write('lastOpenedAt: $lastOpenedAt')
          ..write(')'))
        .toString();
  }
}

class $SchematicCategoriesTable extends SchematicCategories
    with TableInfo<$SchematicCategoriesTable, SchematicCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchematicCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _schematicIdMeta = const VerificationMeta(
    'schematicId',
  );
  @override
  late final GeneratedColumn<int> schematicId = GeneratedColumn<int>(
    'schematic_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES schematics (id)',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [schematicId, categoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schematic_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<SchematicCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('schematic_id')) {
      context.handle(
        _schematicIdMeta,
        schematicId.isAcceptableOrUnknown(
          data['schematic_id']!,
          _schematicIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schematicIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {schematicId, categoryId};
  @override
  SchematicCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchematicCategory(
      schematicId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schematic_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
    );
  }

  @override
  $SchematicCategoriesTable createAlias(String alias) {
    return $SchematicCategoriesTable(attachedDatabase, alias);
  }
}

class SchematicCategory extends DataClass
    implements Insertable<SchematicCategory> {
  final int schematicId;
  final int categoryId;
  const SchematicCategory({
    required this.schematicId,
    required this.categoryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['schematic_id'] = Variable<int>(schematicId);
    map['category_id'] = Variable<int>(categoryId);
    return map;
  }

  SchematicCategoriesCompanion toCompanion(bool nullToAbsent) {
    return SchematicCategoriesCompanion(
      schematicId: Value(schematicId),
      categoryId: Value(categoryId),
    );
  }

  factory SchematicCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchematicCategory(
      schematicId: serializer.fromJson<int>(json['schematicId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'schematicId': serializer.toJson<int>(schematicId),
      'categoryId': serializer.toJson<int>(categoryId),
    };
  }

  SchematicCategory copyWith({int? schematicId, int? categoryId}) =>
      SchematicCategory(
        schematicId: schematicId ?? this.schematicId,
        categoryId: categoryId ?? this.categoryId,
      );
  SchematicCategory copyWithCompanion(SchematicCategoriesCompanion data) {
    return SchematicCategory(
      schematicId: data.schematicId.present
          ? data.schematicId.value
          : this.schematicId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchematicCategory(')
          ..write('schematicId: $schematicId, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(schematicId, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchematicCategory &&
          other.schematicId == this.schematicId &&
          other.categoryId == this.categoryId);
}

class SchematicCategoriesCompanion extends UpdateCompanion<SchematicCategory> {
  final Value<int> schematicId;
  final Value<int> categoryId;
  final Value<int> rowid;
  const SchematicCategoriesCompanion({
    this.schematicId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SchematicCategoriesCompanion.insert({
    required int schematicId,
    required int categoryId,
    this.rowid = const Value.absent(),
  }) : schematicId = Value(schematicId),
       categoryId = Value(categoryId);
  static Insertable<SchematicCategory> custom({
    Expression<int>? schematicId,
    Expression<int>? categoryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (schematicId != null) 'schematic_id': schematicId,
      if (categoryId != null) 'category_id': categoryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SchematicCategoriesCompanion copyWith({
    Value<int>? schematicId,
    Value<int>? categoryId,
    Value<int>? rowid,
  }) {
    return SchematicCategoriesCompanion(
      schematicId: schematicId ?? this.schematicId,
      categoryId: categoryId ?? this.categoryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (schematicId.present) {
      map['schematic_id'] = Variable<int>(schematicId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchematicCategoriesCompanion(')
          ..write('schematicId: $schematicId, ')
          ..write('categoryId: $categoryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String name;
  const Tag({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(id: Value(id), name: Value(name));
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Tag copyWith({int? id, String? name}) =>
      Tag(id: id ?? this.id, name: name ?? this.name);
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag && other.id == this.id && other.name == this.name);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  TagsCompanion.insert({this.id = const Value.absent(), required String name})
    : name = Value(name);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  TagsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return TagsCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $SchematicTagsTable extends SchematicTags
    with TableInfo<$SchematicTagsTable, SchematicTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchematicTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _schematicIdMeta = const VerificationMeta(
    'schematicId',
  );
  @override
  late final GeneratedColumn<int> schematicId = GeneratedColumn<int>(
    'schematic_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES schematics (id)',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [schematicId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schematic_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<SchematicTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('schematic_id')) {
      context.handle(
        _schematicIdMeta,
        schematicId.isAcceptableOrUnknown(
          data['schematic_id']!,
          _schematicIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schematicIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {schematicId, tagId};
  @override
  SchematicTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchematicTag(
      schematicId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schematic_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $SchematicTagsTable createAlias(String alias) {
    return $SchematicTagsTable(attachedDatabase, alias);
  }
}

class SchematicTag extends DataClass implements Insertable<SchematicTag> {
  final int schematicId;
  final int tagId;
  const SchematicTag({required this.schematicId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['schematic_id'] = Variable<int>(schematicId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  SchematicTagsCompanion toCompanion(bool nullToAbsent) {
    return SchematicTagsCompanion(
      schematicId: Value(schematicId),
      tagId: Value(tagId),
    );
  }

  factory SchematicTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchematicTag(
      schematicId: serializer.fromJson<int>(json['schematicId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'schematicId': serializer.toJson<int>(schematicId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  SchematicTag copyWith({int? schematicId, int? tagId}) => SchematicTag(
    schematicId: schematicId ?? this.schematicId,
    tagId: tagId ?? this.tagId,
  );
  SchematicTag copyWithCompanion(SchematicTagsCompanion data) {
    return SchematicTag(
      schematicId: data.schematicId.present
          ? data.schematicId.value
          : this.schematicId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchematicTag(')
          ..write('schematicId: $schematicId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(schematicId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchematicTag &&
          other.schematicId == this.schematicId &&
          other.tagId == this.tagId);
}

class SchematicTagsCompanion extends UpdateCompanion<SchematicTag> {
  final Value<int> schematicId;
  final Value<int> tagId;
  final Value<int> rowid;
  const SchematicTagsCompanion({
    this.schematicId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SchematicTagsCompanion.insert({
    required int schematicId,
    required int tagId,
    this.rowid = const Value.absent(),
  }) : schematicId = Value(schematicId),
       tagId = Value(tagId);
  static Insertable<SchematicTag> custom({
    Expression<int>? schematicId,
    Expression<int>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (schematicId != null) 'schematic_id': schematicId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SchematicTagsCompanion copyWith({
    Value<int>? schematicId,
    Value<int>? tagId,
    Value<int>? rowid,
  }) {
    return SchematicTagsCompanion(
      schematicId: schematicId ?? this.schematicId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (schematicId.present) {
      map['schematic_id'] = Variable<int>(schematicId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchematicTagsCompanion(')
          ..write('schematicId: $schematicId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BrandsTable brands = $BrandsTable(this);
  late final $ModelsTable models = $ModelsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $SchematicsTable schematics = $SchematicsTable(this);
  late final $SchematicCategoriesTable schematicCategories =
      $SchematicCategoriesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $SchematicTagsTable schematicTags = $SchematicTagsTable(this);
  late final BrandDao brandDao = BrandDao(this as AppDatabase);
  late final ModelDao modelDao = ModelDao(this as AppDatabase);
  late final CategoryDao categoryDao = CategoryDao(this as AppDatabase);
  late final SchematicDao schematicDao = SchematicDao(this as AppDatabase);
  late final TagDao tagDao = TagDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    brands,
    models,
    categories,
    schematics,
    schematicCategories,
    tags,
    schematicTags,
  ];
}

typedef $$BrandsTableCreateCompanionBuilder =
    BrandsCompanion Function({
      Value<int> id,
      required String name,
      Value<DateTime> createdAt,
    });
typedef $$BrandsTableUpdateCompanionBuilder =
    BrandsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
    });

final class $$BrandsTableReferences
    extends BaseReferences<_$AppDatabase, $BrandsTable, Brand> {
  $$BrandsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ModelsTable, List<Model>> _modelsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.models,
    aliasName: $_aliasNameGenerator(db.brands.id, db.models.brandId),
  );

  $$ModelsTableProcessedTableManager get modelsRefs {
    final manager = $$ModelsTableTableManager(
      $_db,
      $_db.models,
    ).filter((f) => f.brandId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_modelsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BrandsTableFilterComposer
    extends Composer<_$AppDatabase, $BrandsTable> {
  $$BrandsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> modelsRefs(
    Expression<bool> Function($$ModelsTableFilterComposer f) f,
  ) {
    final $$ModelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.models,
      getReferencedColumn: (t) => t.brandId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelsTableFilterComposer(
            $db: $db,
            $table: $db.models,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BrandsTableOrderingComposer
    extends Composer<_$AppDatabase, $BrandsTable> {
  $$BrandsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BrandsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BrandsTable> {
  $$BrandsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> modelsRefs<T extends Object>(
    Expression<T> Function($$ModelsTableAnnotationComposer a) f,
  ) {
    final $$ModelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.models,
      getReferencedColumn: (t) => t.brandId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelsTableAnnotationComposer(
            $db: $db,
            $table: $db.models,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BrandsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BrandsTable,
          Brand,
          $$BrandsTableFilterComposer,
          $$BrandsTableOrderingComposer,
          $$BrandsTableAnnotationComposer,
          $$BrandsTableCreateCompanionBuilder,
          $$BrandsTableUpdateCompanionBuilder,
          (Brand, $$BrandsTableReferences),
          Brand,
          PrefetchHooks Function({bool modelsRefs})
        > {
  $$BrandsTableTableManager(_$AppDatabase db, $BrandsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrandsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrandsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrandsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BrandsCompanion(id: id, name: name, createdAt: createdAt),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime> createdAt = const Value.absent(),
              }) => BrandsCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$BrandsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({modelsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (modelsRefs) db.models],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (modelsRefs)
                    await $_getPrefetchedData<Brand, $BrandsTable, Model>(
                      currentTable: table,
                      referencedTable: $$BrandsTableReferences._modelsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$BrandsTableReferences(db, table, p0).modelsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.brandId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BrandsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BrandsTable,
      Brand,
      $$BrandsTableFilterComposer,
      $$BrandsTableOrderingComposer,
      $$BrandsTableAnnotationComposer,
      $$BrandsTableCreateCompanionBuilder,
      $$BrandsTableUpdateCompanionBuilder,
      (Brand, $$BrandsTableReferences),
      Brand,
      PrefetchHooks Function({bool modelsRefs})
    >;
typedef $$ModelsTableCreateCompanionBuilder =
    ModelsCompanion Function({
      Value<int> id,
      required int brandId,
      required String name,
      Value<bool> isFavorite,
      Value<DateTime> createdAt,
    });
typedef $$ModelsTableUpdateCompanionBuilder =
    ModelsCompanion Function({
      Value<int> id,
      Value<int> brandId,
      Value<String> name,
      Value<bool> isFavorite,
      Value<DateTime> createdAt,
    });

final class $$ModelsTableReferences
    extends BaseReferences<_$AppDatabase, $ModelsTable, Model> {
  $$ModelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BrandsTable _brandIdTable(_$AppDatabase db) => db.brands.createAlias(
    $_aliasNameGenerator(db.models.brandId, db.brands.id),
  );

  $$BrandsTableProcessedTableManager get brandId {
    final $_column = $_itemColumn<int>('brand_id')!;

    final manager = $$BrandsTableTableManager(
      $_db,
      $_db.brands,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_brandIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SchematicsTable, List<Schematic>>
  _schematicsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.schematics,
    aliasName: $_aliasNameGenerator(db.models.id, db.schematics.modelId),
  );

  $$SchematicsTableProcessedTableManager get schematicsRefs {
    final manager = $$SchematicsTableTableManager(
      $_db,
      $_db.schematics,
    ).filter((f) => f.modelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_schematicsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ModelsTableFilterComposer
    extends Composer<_$AppDatabase, $ModelsTable> {
  $$ModelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BrandsTableFilterComposer get brandId {
    final $$BrandsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brandId,
      referencedTable: $db.brands,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrandsTableFilterComposer(
            $db: $db,
            $table: $db.brands,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> schematicsRefs(
    Expression<bool> Function($$SchematicsTableFilterComposer f) f,
  ) {
    final $$SchematicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.schematics,
      getReferencedColumn: (t) => t.modelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchematicsTableFilterComposer(
            $db: $db,
            $table: $db.schematics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ModelsTableOrderingComposer
    extends Composer<_$AppDatabase, $ModelsTable> {
  $$ModelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BrandsTableOrderingComposer get brandId {
    final $$BrandsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brandId,
      referencedTable: $db.brands,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrandsTableOrderingComposer(
            $db: $db,
            $table: $db.brands,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ModelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModelsTable> {
  $$ModelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BrandsTableAnnotationComposer get brandId {
    final $$BrandsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brandId,
      referencedTable: $db.brands,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrandsTableAnnotationComposer(
            $db: $db,
            $table: $db.brands,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> schematicsRefs<T extends Object>(
    Expression<T> Function($$SchematicsTableAnnotationComposer a) f,
  ) {
    final $$SchematicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.schematics,
      getReferencedColumn: (t) => t.modelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchematicsTableAnnotationComposer(
            $db: $db,
            $table: $db.schematics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ModelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ModelsTable,
          Model,
          $$ModelsTableFilterComposer,
          $$ModelsTableOrderingComposer,
          $$ModelsTableAnnotationComposer,
          $$ModelsTableCreateCompanionBuilder,
          $$ModelsTableUpdateCompanionBuilder,
          (Model, $$ModelsTableReferences),
          Model,
          PrefetchHooks Function({bool brandId, bool schematicsRefs})
        > {
  $$ModelsTableTableManager(_$AppDatabase db, $ModelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> brandId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ModelsCompanion(
                id: id,
                brandId: brandId,
                name: name,
                isFavorite: isFavorite,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int brandId,
                required String name,
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ModelsCompanion.insert(
                id: id,
                brandId: brandId,
                name: name,
                isFavorite: isFavorite,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ModelsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({brandId = false, schematicsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (schematicsRefs) db.schematics],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (brandId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.brandId,
                                referencedTable: $$ModelsTableReferences
                                    ._brandIdTable(db),
                                referencedColumn: $$ModelsTableReferences
                                    ._brandIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (schematicsRefs)
                    await $_getPrefetchedData<Model, $ModelsTable, Schematic>(
                      currentTable: table,
                      referencedTable: $$ModelsTableReferences
                          ._schematicsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ModelsTableReferences(db, table, p0).schematicsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.modelId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ModelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ModelsTable,
      Model,
      $$ModelsTableFilterComposer,
      $$ModelsTableOrderingComposer,
      $$ModelsTableAnnotationComposer,
      $$ModelsTableCreateCompanionBuilder,
      $$ModelsTableUpdateCompanionBuilder,
      (Model, $$ModelsTableReferences),
      Model,
      PrefetchHooks Function({bool brandId, bool schematicsRefs})
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> isDefault,
      Value<String?> iconKey,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> isDefault,
      Value<String?> iconKey,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SchematicCategoriesTable, List<SchematicCategory>>
  _schematicCategoriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.schematicCategories,
        aliasName: $_aliasNameGenerator(
          db.categories.id,
          db.schematicCategories.categoryId,
        ),
      );

  $$SchematicCategoriesTableProcessedTableManager get schematicCategoriesRefs {
    final manager = $$SchematicCategoriesTableTableManager(
      $_db,
      $_db.schematicCategories,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _schematicCategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> schematicCategoriesRefs(
    Expression<bool> Function($$SchematicCategoriesTableFilterComposer f) f,
  ) {
    final $$SchematicCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.schematicCategories,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchematicCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.schematicCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  Expression<T> schematicCategoriesRefs<T extends Object>(
    Expression<T> Function($$SchematicCategoriesTableAnnotationComposer a) f,
  ) {
    final $$SchematicCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.schematicCategories,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SchematicCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.schematicCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({bool schematicCategoriesRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<String?> iconKey = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                isDefault: isDefault,
                iconKey: iconKey,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> isDefault = const Value.absent(),
                Value<String?> iconKey = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                isDefault: isDefault,
                iconKey: iconKey,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({schematicCategoriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (schematicCategoriesRefs) db.schematicCategories,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (schematicCategoriesRefs)
                    await $_getPrefetchedData<
                      Category,
                      $CategoriesTable,
                      SchematicCategory
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._schematicCategoriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).schematicCategoriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool schematicCategoriesRefs})
    >;
typedef $$SchematicsTableCreateCompanionBuilder =
    SchematicsCompanion Function({
      Value<int> id,
      required int modelId,
      required String fileName,
      required String filePath,
      required String originalFileName,
      Value<String?> notes,
      Value<bool> isFavorite,
      Value<DateTime> importedAt,
      Value<DateTime?> lastOpenedAt,
    });
typedef $$SchematicsTableUpdateCompanionBuilder =
    SchematicsCompanion Function({
      Value<int> id,
      Value<int> modelId,
      Value<String> fileName,
      Value<String> filePath,
      Value<String> originalFileName,
      Value<String?> notes,
      Value<bool> isFavorite,
      Value<DateTime> importedAt,
      Value<DateTime?> lastOpenedAt,
    });

final class $$SchematicsTableReferences
    extends BaseReferences<_$AppDatabase, $SchematicsTable, Schematic> {
  $$SchematicsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ModelsTable _modelIdTable(_$AppDatabase db) => db.models.createAlias(
    $_aliasNameGenerator(db.schematics.modelId, db.models.id),
  );

  $$ModelsTableProcessedTableManager get modelId {
    final $_column = $_itemColumn<int>('model_id')!;

    final manager = $$ModelsTableTableManager(
      $_db,
      $_db.models,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SchematicCategoriesTable, List<SchematicCategory>>
  _schematicCategoriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.schematicCategories,
        aliasName: $_aliasNameGenerator(
          db.schematics.id,
          db.schematicCategories.schematicId,
        ),
      );

  $$SchematicCategoriesTableProcessedTableManager get schematicCategoriesRefs {
    final manager = $$SchematicCategoriesTableTableManager(
      $_db,
      $_db.schematicCategories,
    ).filter((f) => f.schematicId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _schematicCategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SchematicTagsTable, List<SchematicTag>>
  _schematicTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.schematicTags,
    aliasName: $_aliasNameGenerator(
      db.schematics.id,
      db.schematicTags.schematicId,
    ),
  );

  $$SchematicTagsTableProcessedTableManager get schematicTagsRefs {
    final manager = $$SchematicTagsTableTableManager(
      $_db,
      $_db.schematicTags,
    ).filter((f) => f.schematicId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_schematicTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SchematicsTableFilterComposer
    extends Composer<_$AppDatabase, $SchematicsTable> {
  $$SchematicsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalFileName => $composableBuilder(
    column: $table.originalFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ModelsTableFilterComposer get modelId {
    final $$ModelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelId,
      referencedTable: $db.models,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelsTableFilterComposer(
            $db: $db,
            $table: $db.models,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> schematicCategoriesRefs(
    Expression<bool> Function($$SchematicCategoriesTableFilterComposer f) f,
  ) {
    final $$SchematicCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.schematicCategories,
      getReferencedColumn: (t) => t.schematicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchematicCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.schematicCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> schematicTagsRefs(
    Expression<bool> Function($$SchematicTagsTableFilterComposer f) f,
  ) {
    final $$SchematicTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.schematicTags,
      getReferencedColumn: (t) => t.schematicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchematicTagsTableFilterComposer(
            $db: $db,
            $table: $db.schematicTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SchematicsTableOrderingComposer
    extends Composer<_$AppDatabase, $SchematicsTable> {
  $$SchematicsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalFileName => $composableBuilder(
    column: $table.originalFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ModelsTableOrderingComposer get modelId {
    final $$ModelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelId,
      referencedTable: $db.models,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelsTableOrderingComposer(
            $db: $db,
            $table: $db.models,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SchematicsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchematicsTable> {
  $$SchematicsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get originalFileName => $composableBuilder(
    column: $table.originalFileName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => column,
  );

  $$ModelsTableAnnotationComposer get modelId {
    final $$ModelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelId,
      referencedTable: $db.models,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelsTableAnnotationComposer(
            $db: $db,
            $table: $db.models,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> schematicCategoriesRefs<T extends Object>(
    Expression<T> Function($$SchematicCategoriesTableAnnotationComposer a) f,
  ) {
    final $$SchematicCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.schematicCategories,
          getReferencedColumn: (t) => t.schematicId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SchematicCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.schematicCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> schematicTagsRefs<T extends Object>(
    Expression<T> Function($$SchematicTagsTableAnnotationComposer a) f,
  ) {
    final $$SchematicTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.schematicTags,
      getReferencedColumn: (t) => t.schematicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchematicTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.schematicTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SchematicsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchematicsTable,
          Schematic,
          $$SchematicsTableFilterComposer,
          $$SchematicsTableOrderingComposer,
          $$SchematicsTableAnnotationComposer,
          $$SchematicsTableCreateCompanionBuilder,
          $$SchematicsTableUpdateCompanionBuilder,
          (Schematic, $$SchematicsTableReferences),
          Schematic,
          PrefetchHooks Function({
            bool modelId,
            bool schematicCategoriesRefs,
            bool schematicTagsRefs,
          })
        > {
  $$SchematicsTableTableManager(_$AppDatabase db, $SchematicsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchematicsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchematicsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchematicsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> modelId = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> originalFileName = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> importedAt = const Value.absent(),
                Value<DateTime?> lastOpenedAt = const Value.absent(),
              }) => SchematicsCompanion(
                id: id,
                modelId: modelId,
                fileName: fileName,
                filePath: filePath,
                originalFileName: originalFileName,
                notes: notes,
                isFavorite: isFavorite,
                importedAt: importedAt,
                lastOpenedAt: lastOpenedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int modelId,
                required String fileName,
                required String filePath,
                required String originalFileName,
                Value<String?> notes = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> importedAt = const Value.absent(),
                Value<DateTime?> lastOpenedAt = const Value.absent(),
              }) => SchematicsCompanion.insert(
                id: id,
                modelId: modelId,
                fileName: fileName,
                filePath: filePath,
                originalFileName: originalFileName,
                notes: notes,
                isFavorite: isFavorite,
                importedAt: importedAt,
                lastOpenedAt: lastOpenedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SchematicsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                modelId = false,
                schematicCategoriesRefs = false,
                schematicTagsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (schematicCategoriesRefs) db.schematicCategories,
                    if (schematicTagsRefs) db.schematicTags,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (modelId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.modelId,
                                    referencedTable: $$SchematicsTableReferences
                                        ._modelIdTable(db),
                                    referencedColumn:
                                        $$SchematicsTableReferences
                                            ._modelIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (schematicCategoriesRefs)
                        await $_getPrefetchedData<
                          Schematic,
                          $SchematicsTable,
                          SchematicCategory
                        >(
                          currentTable: table,
                          referencedTable: $$SchematicsTableReferences
                              ._schematicCategoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SchematicsTableReferences(
                                db,
                                table,
                                p0,
                              ).schematicCategoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.schematicId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (schematicTagsRefs)
                        await $_getPrefetchedData<
                          Schematic,
                          $SchematicsTable,
                          SchematicTag
                        >(
                          currentTable: table,
                          referencedTable: $$SchematicsTableReferences
                              ._schematicTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SchematicsTableReferences(
                                db,
                                table,
                                p0,
                              ).schematicTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.schematicId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SchematicsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchematicsTable,
      Schematic,
      $$SchematicsTableFilterComposer,
      $$SchematicsTableOrderingComposer,
      $$SchematicsTableAnnotationComposer,
      $$SchematicsTableCreateCompanionBuilder,
      $$SchematicsTableUpdateCompanionBuilder,
      (Schematic, $$SchematicsTableReferences),
      Schematic,
      PrefetchHooks Function({
        bool modelId,
        bool schematicCategoriesRefs,
        bool schematicTagsRefs,
      })
    >;
typedef $$SchematicCategoriesTableCreateCompanionBuilder =
    SchematicCategoriesCompanion Function({
      required int schematicId,
      required int categoryId,
      Value<int> rowid,
    });
typedef $$SchematicCategoriesTableUpdateCompanionBuilder =
    SchematicCategoriesCompanion Function({
      Value<int> schematicId,
      Value<int> categoryId,
      Value<int> rowid,
    });

final class $$SchematicCategoriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SchematicCategoriesTable,
          SchematicCategory
        > {
  $$SchematicCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SchematicsTable _schematicIdTable(_$AppDatabase db) =>
      db.schematics.createAlias(
        $_aliasNameGenerator(
          db.schematicCategories.schematicId,
          db.schematics.id,
        ),
      );

  $$SchematicsTableProcessedTableManager get schematicId {
    final $_column = $_itemColumn<int>('schematic_id')!;

    final manager = $$SchematicsTableTableManager(
      $_db,
      $_db.schematics,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_schematicIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
        $_aliasNameGenerator(
          db.schematicCategories.categoryId,
          db.categories.id,
        ),
      );

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SchematicCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $SchematicCategoriesTable> {
  $$SchematicCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SchematicsTableFilterComposer get schematicId {
    final $$SchematicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.schematicId,
      referencedTable: $db.schematics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchematicsTableFilterComposer(
            $db: $db,
            $table: $db.schematics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SchematicCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SchematicCategoriesTable> {
  $$SchematicCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SchematicsTableOrderingComposer get schematicId {
    final $$SchematicsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.schematicId,
      referencedTable: $db.schematics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchematicsTableOrderingComposer(
            $db: $db,
            $table: $db.schematics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SchematicCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchematicCategoriesTable> {
  $$SchematicCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SchematicsTableAnnotationComposer get schematicId {
    final $$SchematicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.schematicId,
      referencedTable: $db.schematics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchematicsTableAnnotationComposer(
            $db: $db,
            $table: $db.schematics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SchematicCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchematicCategoriesTable,
          SchematicCategory,
          $$SchematicCategoriesTableFilterComposer,
          $$SchematicCategoriesTableOrderingComposer,
          $$SchematicCategoriesTableAnnotationComposer,
          $$SchematicCategoriesTableCreateCompanionBuilder,
          $$SchematicCategoriesTableUpdateCompanionBuilder,
          (SchematicCategory, $$SchematicCategoriesTableReferences),
          SchematicCategory,
          PrefetchHooks Function({bool schematicId, bool categoryId})
        > {
  $$SchematicCategoriesTableTableManager(
    _$AppDatabase db,
    $SchematicCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchematicCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchematicCategoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SchematicCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> schematicId = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchematicCategoriesCompanion(
                schematicId: schematicId,
                categoryId: categoryId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int schematicId,
                required int categoryId,
                Value<int> rowid = const Value.absent(),
              }) => SchematicCategoriesCompanion.insert(
                schematicId: schematicId,
                categoryId: categoryId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SchematicCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({schematicId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (schematicId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.schematicId,
                                referencedTable:
                                    $$SchematicCategoriesTableReferences
                                        ._schematicIdTable(db),
                                referencedColumn:
                                    $$SchematicCategoriesTableReferences
                                        ._schematicIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable:
                                    $$SchematicCategoriesTableReferences
                                        ._categoryIdTable(db),
                                referencedColumn:
                                    $$SchematicCategoriesTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SchematicCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchematicCategoriesTable,
      SchematicCategory,
      $$SchematicCategoriesTableFilterComposer,
      $$SchematicCategoriesTableOrderingComposer,
      $$SchematicCategoriesTableAnnotationComposer,
      $$SchematicCategoriesTableCreateCompanionBuilder,
      $$SchematicCategoriesTableUpdateCompanionBuilder,
      (SchematicCategory, $$SchematicCategoriesTableReferences),
      SchematicCategory,
      PrefetchHooks Function({bool schematicId, bool categoryId})
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({Value<int> id, required String name});
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({Value<int> id, Value<String> name});

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SchematicTagsTable, List<SchematicTag>>
  _schematicTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.schematicTags,
    aliasName: $_aliasNameGenerator(db.tags.id, db.schematicTags.tagId),
  );

  $$SchematicTagsTableProcessedTableManager get schematicTagsRefs {
    final manager = $$SchematicTagsTableTableManager(
      $_db,
      $_db.schematicTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_schematicTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> schematicTagsRefs(
    Expression<bool> Function($$SchematicTagsTableFilterComposer f) f,
  ) {
    final $$SchematicTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.schematicTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchematicTagsTableFilterComposer(
            $db: $db,
            $table: $db.schematicTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> schematicTagsRefs<T extends Object>(
    Expression<T> Function($$SchematicTagsTableAnnotationComposer a) f,
  ) {
    final $$SchematicTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.schematicTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchematicTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.schematicTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool schematicTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => TagsCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  TagsCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TagsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({schematicTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (schematicTagsRefs) db.schematicTags,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (schematicTagsRefs)
                    await $_getPrefetchedData<Tag, $TagsTable, SchematicTag>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences
                          ._schematicTagsRefsTable(db),
                      managerFromTypedResult: (p0) => $$TagsTableReferences(
                        db,
                        table,
                        p0,
                      ).schematicTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool schematicTagsRefs})
    >;
typedef $$SchematicTagsTableCreateCompanionBuilder =
    SchematicTagsCompanion Function({
      required int schematicId,
      required int tagId,
      Value<int> rowid,
    });
typedef $$SchematicTagsTableUpdateCompanionBuilder =
    SchematicTagsCompanion Function({
      Value<int> schematicId,
      Value<int> tagId,
      Value<int> rowid,
    });

final class $$SchematicTagsTableReferences
    extends BaseReferences<_$AppDatabase, $SchematicTagsTable, SchematicTag> {
  $$SchematicTagsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SchematicsTable _schematicIdTable(_$AppDatabase db) =>
      db.schematics.createAlias(
        $_aliasNameGenerator(db.schematicTags.schematicId, db.schematics.id),
      );

  $$SchematicsTableProcessedTableManager get schematicId {
    final $_column = $_itemColumn<int>('schematic_id')!;

    final manager = $$SchematicsTableTableManager(
      $_db,
      $_db.schematics,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_schematicIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) => db.tags.createAlias(
    $_aliasNameGenerator(db.schematicTags.tagId, db.tags.id),
  );

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SchematicTagsTableFilterComposer
    extends Composer<_$AppDatabase, $SchematicTagsTable> {
  $$SchematicTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SchematicsTableFilterComposer get schematicId {
    final $$SchematicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.schematicId,
      referencedTable: $db.schematics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchematicsTableFilterComposer(
            $db: $db,
            $table: $db.schematics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SchematicTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $SchematicTagsTable> {
  $$SchematicTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SchematicsTableOrderingComposer get schematicId {
    final $$SchematicsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.schematicId,
      referencedTable: $db.schematics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchematicsTableOrderingComposer(
            $db: $db,
            $table: $db.schematics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SchematicTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchematicTagsTable> {
  $$SchematicTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SchematicsTableAnnotationComposer get schematicId {
    final $$SchematicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.schematicId,
      referencedTable: $db.schematics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchematicsTableAnnotationComposer(
            $db: $db,
            $table: $db.schematics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SchematicTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchematicTagsTable,
          SchematicTag,
          $$SchematicTagsTableFilterComposer,
          $$SchematicTagsTableOrderingComposer,
          $$SchematicTagsTableAnnotationComposer,
          $$SchematicTagsTableCreateCompanionBuilder,
          $$SchematicTagsTableUpdateCompanionBuilder,
          (SchematicTag, $$SchematicTagsTableReferences),
          SchematicTag,
          PrefetchHooks Function({bool schematicId, bool tagId})
        > {
  $$SchematicTagsTableTableManager(_$AppDatabase db, $SchematicTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchematicTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchematicTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchematicTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> schematicId = const Value.absent(),
                Value<int> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchematicTagsCompanion(
                schematicId: schematicId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int schematicId,
                required int tagId,
                Value<int> rowid = const Value.absent(),
              }) => SchematicTagsCompanion.insert(
                schematicId: schematicId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SchematicTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({schematicId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (schematicId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.schematicId,
                                referencedTable: $$SchematicTagsTableReferences
                                    ._schematicIdTable(db),
                                referencedColumn: $$SchematicTagsTableReferences
                                    ._schematicIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable: $$SchematicTagsTableReferences
                                    ._tagIdTable(db),
                                referencedColumn: $$SchematicTagsTableReferences
                                    ._tagIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SchematicTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchematicTagsTable,
      SchematicTag,
      $$SchematicTagsTableFilterComposer,
      $$SchematicTagsTableOrderingComposer,
      $$SchematicTagsTableAnnotationComposer,
      $$SchematicTagsTableCreateCompanionBuilder,
      $$SchematicTagsTableUpdateCompanionBuilder,
      (SchematicTag, $$SchematicTagsTableReferences),
      SchematicTag,
      PrefetchHooks Function({bool schematicId, bool tagId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BrandsTableTableManager get brands =>
      $$BrandsTableTableManager(_db, _db.brands);
  $$ModelsTableTableManager get models =>
      $$ModelsTableTableManager(_db, _db.models);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$SchematicsTableTableManager get schematics =>
      $$SchematicsTableTableManager(_db, _db.schematics);
  $$SchematicCategoriesTableTableManager get schematicCategories =>
      $$SchematicCategoriesTableTableManager(_db, _db.schematicCategories);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$SchematicTagsTableTableManager get schematicTags =>
      $$SchematicTagsTableTableManager(_db, _db.schematicTags);
}
