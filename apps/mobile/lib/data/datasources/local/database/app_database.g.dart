// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
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
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('folder'),
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#6C63FF'),
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
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    icon,
    colorHex,
    isDefault,
    sortOrder,
    createdAt,
  ];
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
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      icon:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}icon'],
          )!,
      colorHex:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}color_hex'],
          )!,
      isDefault:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_default'],
          )!,
      sortOrder:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}sort_order'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
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
  final String icon;
  final String colorHex;
  final bool isDefault;
  final int sortOrder;
  final DateTime createdAt;
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
    required this.isDefault,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['color_hex'] = Variable<String>(colorHex);
    map['is_default'] = Variable<bool>(isDefault);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      colorHex: Value(colorHex),
      isDefault: Value(isDefault),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
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
      icon: serializer.fromJson<String>(json['icon']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'colorHex': serializer.toJson<String>(colorHex),
      'isDefault': serializer.toJson<bool>(isDefault),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Category copyWith({
    int? id,
    String? name,
    String? icon,
    String? colorHex,
    bool? isDefault,
    int? sortOrder,
    DateTime? createdAt,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    colorHex: colorHex ?? this.colorHex,
    isDefault: isDefault ?? this.isDefault,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorHex: $colorHex, ')
          ..write('isDefault: $isDefault, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, icon, colorHex, isDefault, sortOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.colorHex == this.colorHex &&
          other.isDefault == this.isDefault &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<String> colorHex;
  final Value<bool> isDefault;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.icon = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? colorHex,
    Expression<bool>? isDefault,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (colorHex != null) 'color_hex': colorHex,
      if (isDefault != null) 'is_default': isDefault,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? icon,
    Value<String>? colorHex,
    Value<bool>? isDefault,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      isDefault: isDefault ?? this.isDefault,
      sortOrder: sortOrder ?? this.sortOrder,
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
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorHex: $colorHex, ')
          ..write('isDefault: $isDefault, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $VaultEntriesTable extends VaultEntries
    with TableInfo<$VaultEntriesTable, VaultEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaultEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uriMeta = const VerificationMeta('uri');
  @override
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
    'uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('globe'),
  );
  static const VerificationMeta _favoriteMeta = const VerificationMeta(
    'favorite',
  );
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _passwordRenewalDaysMeta =
      const VerificationMeta('passwordRenewalDays');
  @override
  late final GeneratedColumn<int> passwordRenewalDays = GeneratedColumn<int>(
    'password_renewal_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastPasswordChangeMeta =
      const VerificationMeta('lastPasswordChange');
  @override
  late final GeneratedColumn<DateTime> lastPasswordChange =
      GeneratedColumn<DateTime>(
        'last_password_change',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    username,
    password,
    uri,
    notes,
    categoryId,
    icon,
    favorite,
    passwordRenewalDays,
    lastPasswordChange,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vault_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<VaultEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('uri')) {
      context.handle(
        _uriMeta,
        uri.isAcceptableOrUnknown(data['uri']!, _uriMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('favorite')) {
      context.handle(
        _favoriteMeta,
        favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta),
      );
    }
    if (data.containsKey('password_renewal_days')) {
      context.handle(
        _passwordRenewalDaysMeta,
        passwordRenewalDays.isAcceptableOrUnknown(
          data['password_renewal_days']!,
          _passwordRenewalDaysMeta,
        ),
      );
    }
    if (data.containsKey('last_password_change')) {
      context.handle(
        _lastPasswordChangeMeta,
        lastPasswordChange.isAcceptableOrUnknown(
          data['last_password_change']!,
          _lastPasswordChangeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastPasswordChangeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaultEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaultEntry(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      username:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}username'],
          )!,
      password:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}password'],
          )!,
      uri:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}uri'],
          )!,
      notes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}notes'],
          )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      icon:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}icon'],
          )!,
      favorite:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}favorite'],
          )!,
      passwordRenewalDays:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}password_renewal_days'],
          )!,
      lastPasswordChange:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}last_password_change'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $VaultEntriesTable createAlias(String alias) {
    return $VaultEntriesTable(attachedDatabase, alias);
  }
}

class VaultEntry extends DataClass implements Insertable<VaultEntry> {
  final int id;
  final String title;
  final String username;
  final String password;
  final String uri;
  final String notes;
  final int? categoryId;
  final String icon;
  final bool favorite;
  final int passwordRenewalDays;
  final DateTime lastPasswordChange;
  final DateTime createdAt;
  final DateTime updatedAt;
  const VaultEntry({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    required this.uri,
    required this.notes,
    this.categoryId,
    required this.icon,
    required this.favorite,
    required this.passwordRenewalDays,
    required this.lastPasswordChange,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    map['uri'] = Variable<String>(uri);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['icon'] = Variable<String>(icon);
    map['favorite'] = Variable<bool>(favorite);
    map['password_renewal_days'] = Variable<int>(passwordRenewalDays);
    map['last_password_change'] = Variable<DateTime>(lastPasswordChange);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VaultEntriesCompanion toCompanion(bool nullToAbsent) {
    return VaultEntriesCompanion(
      id: Value(id),
      title: Value(title),
      username: Value(username),
      password: Value(password),
      uri: Value(uri),
      notes: Value(notes),
      categoryId:
          categoryId == null && nullToAbsent
              ? const Value.absent()
              : Value(categoryId),
      icon: Value(icon),
      favorite: Value(favorite),
      passwordRenewalDays: Value(passwordRenewalDays),
      lastPasswordChange: Value(lastPasswordChange),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VaultEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaultEntry(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String>(json['password']),
      uri: serializer.fromJson<String>(json['uri']),
      notes: serializer.fromJson<String>(json['notes']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      icon: serializer.fromJson<String>(json['icon']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      passwordRenewalDays: serializer.fromJson<int>(
        json['passwordRenewalDays'],
      ),
      lastPasswordChange: serializer.fromJson<DateTime>(
        json['lastPasswordChange'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String>(password),
      'uri': serializer.toJson<String>(uri),
      'notes': serializer.toJson<String>(notes),
      'categoryId': serializer.toJson<int?>(categoryId),
      'icon': serializer.toJson<String>(icon),
      'favorite': serializer.toJson<bool>(favorite),
      'passwordRenewalDays': serializer.toJson<int>(passwordRenewalDays),
      'lastPasswordChange': serializer.toJson<DateTime>(lastPasswordChange),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VaultEntry copyWith({
    int? id,
    String? title,
    String? username,
    String? password,
    String? uri,
    String? notes,
    Value<int?> categoryId = const Value.absent(),
    String? icon,
    bool? favorite,
    int? passwordRenewalDays,
    DateTime? lastPasswordChange,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VaultEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    username: username ?? this.username,
    password: password ?? this.password,
    uri: uri ?? this.uri,
    notes: notes ?? this.notes,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    icon: icon ?? this.icon,
    favorite: favorite ?? this.favorite,
    passwordRenewalDays: passwordRenewalDays ?? this.passwordRenewalDays,
    lastPasswordChange: lastPasswordChange ?? this.lastPasswordChange,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  VaultEntry copyWithCompanion(VaultEntriesCompanion data) {
    return VaultEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      uri: data.uri.present ? data.uri.value : this.uri,
      notes: data.notes.present ? data.notes.value : this.notes,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      icon: data.icon.present ? data.icon.value : this.icon,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      passwordRenewalDays:
          data.passwordRenewalDays.present
              ? data.passwordRenewalDays.value
              : this.passwordRenewalDays,
      lastPasswordChange:
          data.lastPasswordChange.present
              ? data.lastPasswordChange.value
              : this.lastPasswordChange,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaultEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('uri: $uri, ')
          ..write('notes: $notes, ')
          ..write('categoryId: $categoryId, ')
          ..write('icon: $icon, ')
          ..write('favorite: $favorite, ')
          ..write('passwordRenewalDays: $passwordRenewalDays, ')
          ..write('lastPasswordChange: $lastPasswordChange, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    username,
    password,
    uri,
    notes,
    categoryId,
    icon,
    favorite,
    passwordRenewalDays,
    lastPasswordChange,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaultEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.username == this.username &&
          other.password == this.password &&
          other.uri == this.uri &&
          other.notes == this.notes &&
          other.categoryId == this.categoryId &&
          other.icon == this.icon &&
          other.favorite == this.favorite &&
          other.passwordRenewalDays == this.passwordRenewalDays &&
          other.lastPasswordChange == this.lastPasswordChange &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VaultEntriesCompanion extends UpdateCompanion<VaultEntry> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> username;
  final Value<String> password;
  final Value<String> uri;
  final Value<String> notes;
  final Value<int?> categoryId;
  final Value<String> icon;
  final Value<bool> favorite;
  final Value<int> passwordRenewalDays;
  final Value<DateTime> lastPasswordChange;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const VaultEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.uri = const Value.absent(),
    this.notes = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.icon = const Value.absent(),
    this.favorite = const Value.absent(),
    this.passwordRenewalDays = const Value.absent(),
    this.lastPasswordChange = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  VaultEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.username = const Value.absent(),
    required String password,
    this.uri = const Value.absent(),
    this.notes = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.icon = const Value.absent(),
    this.favorite = const Value.absent(),
    this.passwordRenewalDays = const Value.absent(),
    required DateTime lastPasswordChange,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : title = Value(title),
       password = Value(password),
       lastPasswordChange = Value(lastPasswordChange),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<VaultEntry> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? uri,
    Expression<String>? notes,
    Expression<int>? categoryId,
    Expression<String>? icon,
    Expression<bool>? favorite,
    Expression<int>? passwordRenewalDays,
    Expression<DateTime>? lastPasswordChange,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (uri != null) 'uri': uri,
      if (notes != null) 'notes': notes,
      if (categoryId != null) 'category_id': categoryId,
      if (icon != null) 'icon': icon,
      if (favorite != null) 'favorite': favorite,
      if (passwordRenewalDays != null)
        'password_renewal_days': passwordRenewalDays,
      if (lastPasswordChange != null)
        'last_password_change': lastPasswordChange,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  VaultEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? username,
    Value<String>? password,
    Value<String>? uri,
    Value<String>? notes,
    Value<int?>? categoryId,
    Value<String>? icon,
    Value<bool>? favorite,
    Value<int>? passwordRenewalDays,
    Value<DateTime>? lastPasswordChange,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return VaultEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      username: username ?? this.username,
      password: password ?? this.password,
      uri: uri ?? this.uri,
      notes: notes ?? this.notes,
      categoryId: categoryId ?? this.categoryId,
      icon: icon ?? this.icon,
      favorite: favorite ?? this.favorite,
      passwordRenewalDays: passwordRenewalDays ?? this.passwordRenewalDays,
      lastPasswordChange: lastPasswordChange ?? this.lastPasswordChange,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (uri.present) {
      map['uri'] = Variable<String>(uri.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (passwordRenewalDays.present) {
      map['password_renewal_days'] = Variable<int>(passwordRenewalDays.value);
    }
    if (lastPasswordChange.present) {
      map['last_password_change'] = Variable<DateTime>(
        lastPasswordChange.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaultEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('uri: $uri, ')
          ..write('notes: $notes, ')
          ..write('categoryId: $categoryId, ')
          ..write('icon: $icon, ')
          ..write('favorite: $favorite, ')
          ..write('passwordRenewalDays: $passwordRenewalDays, ')
          ..write('lastPasswordChange: $lastPasswordChange, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TotpEntriesTable extends TotpEntries
    with TableInfo<$TotpEntriesTable, TotpEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TotpEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _issuerMeta = const VerificationMeta('issuer');
  @override
  late final GeneratedColumn<String> issuer = GeneratedColumn<String>(
    'issuer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountNameMeta = const VerificationMeta(
    'accountName',
  );
  @override
  late final GeneratedColumn<String> accountName = GeneratedColumn<String>(
    'account_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _secretMeta = const VerificationMeta('secret');
  @override
  late final GeneratedColumn<String> secret = GeneratedColumn<String>(
    'secret',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _digitsMeta = const VerificationMeta('digits');
  @override
  late final GeneratedColumn<int> digits = GeneratedColumn<int>(
    'digits',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(6),
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<int> period = GeneratedColumn<int>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _algorithmMeta = const VerificationMeta(
    'algorithm',
  );
  @override
  late final GeneratedColumn<String> algorithm = GeneratedColumn<String>(
    'algorithm',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('SHA1'),
  );
  static const VerificationMeta _vaultEntryIdMeta = const VerificationMeta(
    'vaultEntryId',
  );
  @override
  late final GeneratedColumn<int> vaultEntryId = GeneratedColumn<int>(
    'vault_entry_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vault_entries (id)',
    ),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    issuer,
    accountName,
    secret,
    digits,
    period,
    algorithm,
    vaultEntryId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'totp_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TotpEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('issuer')) {
      context.handle(
        _issuerMeta,
        issuer.isAcceptableOrUnknown(data['issuer']!, _issuerMeta),
      );
    } else if (isInserting) {
      context.missing(_issuerMeta);
    }
    if (data.containsKey('account_name')) {
      context.handle(
        _accountNameMeta,
        accountName.isAcceptableOrUnknown(
          data['account_name']!,
          _accountNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountNameMeta);
    }
    if (data.containsKey('secret')) {
      context.handle(
        _secretMeta,
        secret.isAcceptableOrUnknown(data['secret']!, _secretMeta),
      );
    } else if (isInserting) {
      context.missing(_secretMeta);
    }
    if (data.containsKey('digits')) {
      context.handle(
        _digitsMeta,
        digits.isAcceptableOrUnknown(data['digits']!, _digitsMeta),
      );
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    }
    if (data.containsKey('algorithm')) {
      context.handle(
        _algorithmMeta,
        algorithm.isAcceptableOrUnknown(data['algorithm']!, _algorithmMeta),
      );
    }
    if (data.containsKey('vault_entry_id')) {
      context.handle(
        _vaultEntryIdMeta,
        vaultEntryId.isAcceptableOrUnknown(
          data['vault_entry_id']!,
          _vaultEntryIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TotpEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TotpEntry(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      issuer:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}issuer'],
          )!,
      accountName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}account_name'],
          )!,
      secret:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}secret'],
          )!,
      digits:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}digits'],
          )!,
      period:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}period'],
          )!,
      algorithm:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}algorithm'],
          )!,
      vaultEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vault_entry_id'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $TotpEntriesTable createAlias(String alias) {
    return $TotpEntriesTable(attachedDatabase, alias);
  }
}

class TotpEntry extends DataClass implements Insertable<TotpEntry> {
  final int id;
  final String issuer;
  final String accountName;
  final String secret;
  final int digits;
  final int period;
  final String algorithm;
  final int? vaultEntryId;
  final DateTime createdAt;
  const TotpEntry({
    required this.id,
    required this.issuer,
    required this.accountName,
    required this.secret,
    required this.digits,
    required this.period,
    required this.algorithm,
    this.vaultEntryId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['issuer'] = Variable<String>(issuer);
    map['account_name'] = Variable<String>(accountName);
    map['secret'] = Variable<String>(secret);
    map['digits'] = Variable<int>(digits);
    map['period'] = Variable<int>(period);
    map['algorithm'] = Variable<String>(algorithm);
    if (!nullToAbsent || vaultEntryId != null) {
      map['vault_entry_id'] = Variable<int>(vaultEntryId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TotpEntriesCompanion toCompanion(bool nullToAbsent) {
    return TotpEntriesCompanion(
      id: Value(id),
      issuer: Value(issuer),
      accountName: Value(accountName),
      secret: Value(secret),
      digits: Value(digits),
      period: Value(period),
      algorithm: Value(algorithm),
      vaultEntryId:
          vaultEntryId == null && nullToAbsent
              ? const Value.absent()
              : Value(vaultEntryId),
      createdAt: Value(createdAt),
    );
  }

  factory TotpEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TotpEntry(
      id: serializer.fromJson<int>(json['id']),
      issuer: serializer.fromJson<String>(json['issuer']),
      accountName: serializer.fromJson<String>(json['accountName']),
      secret: serializer.fromJson<String>(json['secret']),
      digits: serializer.fromJson<int>(json['digits']),
      period: serializer.fromJson<int>(json['period']),
      algorithm: serializer.fromJson<String>(json['algorithm']),
      vaultEntryId: serializer.fromJson<int?>(json['vaultEntryId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'issuer': serializer.toJson<String>(issuer),
      'accountName': serializer.toJson<String>(accountName),
      'secret': serializer.toJson<String>(secret),
      'digits': serializer.toJson<int>(digits),
      'period': serializer.toJson<int>(period),
      'algorithm': serializer.toJson<String>(algorithm),
      'vaultEntryId': serializer.toJson<int?>(vaultEntryId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TotpEntry copyWith({
    int? id,
    String? issuer,
    String? accountName,
    String? secret,
    int? digits,
    int? period,
    String? algorithm,
    Value<int?> vaultEntryId = const Value.absent(),
    DateTime? createdAt,
  }) => TotpEntry(
    id: id ?? this.id,
    issuer: issuer ?? this.issuer,
    accountName: accountName ?? this.accountName,
    secret: secret ?? this.secret,
    digits: digits ?? this.digits,
    period: period ?? this.period,
    algorithm: algorithm ?? this.algorithm,
    vaultEntryId: vaultEntryId.present ? vaultEntryId.value : this.vaultEntryId,
    createdAt: createdAt ?? this.createdAt,
  );
  TotpEntry copyWithCompanion(TotpEntriesCompanion data) {
    return TotpEntry(
      id: data.id.present ? data.id.value : this.id,
      issuer: data.issuer.present ? data.issuer.value : this.issuer,
      accountName:
          data.accountName.present ? data.accountName.value : this.accountName,
      secret: data.secret.present ? data.secret.value : this.secret,
      digits: data.digits.present ? data.digits.value : this.digits,
      period: data.period.present ? data.period.value : this.period,
      algorithm: data.algorithm.present ? data.algorithm.value : this.algorithm,
      vaultEntryId:
          data.vaultEntryId.present
              ? data.vaultEntryId.value
              : this.vaultEntryId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TotpEntry(')
          ..write('id: $id, ')
          ..write('issuer: $issuer, ')
          ..write('accountName: $accountName, ')
          ..write('secret: $secret, ')
          ..write('digits: $digits, ')
          ..write('period: $period, ')
          ..write('algorithm: $algorithm, ')
          ..write('vaultEntryId: $vaultEntryId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    issuer,
    accountName,
    secret,
    digits,
    period,
    algorithm,
    vaultEntryId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TotpEntry &&
          other.id == this.id &&
          other.issuer == this.issuer &&
          other.accountName == this.accountName &&
          other.secret == this.secret &&
          other.digits == this.digits &&
          other.period == this.period &&
          other.algorithm == this.algorithm &&
          other.vaultEntryId == this.vaultEntryId &&
          other.createdAt == this.createdAt);
}

class TotpEntriesCompanion extends UpdateCompanion<TotpEntry> {
  final Value<int> id;
  final Value<String> issuer;
  final Value<String> accountName;
  final Value<String> secret;
  final Value<int> digits;
  final Value<int> period;
  final Value<String> algorithm;
  final Value<int?> vaultEntryId;
  final Value<DateTime> createdAt;
  const TotpEntriesCompanion({
    this.id = const Value.absent(),
    this.issuer = const Value.absent(),
    this.accountName = const Value.absent(),
    this.secret = const Value.absent(),
    this.digits = const Value.absent(),
    this.period = const Value.absent(),
    this.algorithm = const Value.absent(),
    this.vaultEntryId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TotpEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String issuer,
    required String accountName,
    required String secret,
    this.digits = const Value.absent(),
    this.period = const Value.absent(),
    this.algorithm = const Value.absent(),
    this.vaultEntryId = const Value.absent(),
    required DateTime createdAt,
  }) : issuer = Value(issuer),
       accountName = Value(accountName),
       secret = Value(secret),
       createdAt = Value(createdAt);
  static Insertable<TotpEntry> custom({
    Expression<int>? id,
    Expression<String>? issuer,
    Expression<String>? accountName,
    Expression<String>? secret,
    Expression<int>? digits,
    Expression<int>? period,
    Expression<String>? algorithm,
    Expression<int>? vaultEntryId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (issuer != null) 'issuer': issuer,
      if (accountName != null) 'account_name': accountName,
      if (secret != null) 'secret': secret,
      if (digits != null) 'digits': digits,
      if (period != null) 'period': period,
      if (algorithm != null) 'algorithm': algorithm,
      if (vaultEntryId != null) 'vault_entry_id': vaultEntryId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TotpEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? issuer,
    Value<String>? accountName,
    Value<String>? secret,
    Value<int>? digits,
    Value<int>? period,
    Value<String>? algorithm,
    Value<int?>? vaultEntryId,
    Value<DateTime>? createdAt,
  }) {
    return TotpEntriesCompanion(
      id: id ?? this.id,
      issuer: issuer ?? this.issuer,
      accountName: accountName ?? this.accountName,
      secret: secret ?? this.secret,
      digits: digits ?? this.digits,
      period: period ?? this.period,
      algorithm: algorithm ?? this.algorithm,
      vaultEntryId: vaultEntryId ?? this.vaultEntryId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (issuer.present) {
      map['issuer'] = Variable<String>(issuer.value);
    }
    if (accountName.present) {
      map['account_name'] = Variable<String>(accountName.value);
    }
    if (secret.present) {
      map['secret'] = Variable<String>(secret.value);
    }
    if (digits.present) {
      map['digits'] = Variable<int>(digits.value);
    }
    if (period.present) {
      map['period'] = Variable<int>(period.value);
    }
    if (algorithm.present) {
      map['algorithm'] = Variable<String>(algorithm.value);
    }
    if (vaultEntryId.present) {
      map['vault_entry_id'] = Variable<int>(vaultEntryId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TotpEntriesCompanion(')
          ..write('id: $id, ')
          ..write('issuer: $issuer, ')
          ..write('accountName: $accountName, ')
          ..write('secret: $secret, ')
          ..write('digits: $digits, ')
          ..write('period: $period, ')
          ..write('algorithm: $algorithm, ')
          ..write('vaultEntryId: $vaultEntryId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, SettingEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingEntry(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      key:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}key'],
          )!,
      value:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value'],
          )!,
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }
}

class SettingEntry extends DataClass implements Insertable<SettingEntry> {
  final int id;
  final String key;
  final String value;
  const SettingEntry({
    required this.id,
    required this.key,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(
      id: Value(id),
      key: Value(key),
      value: Value(value),
    );
  }

  factory SettingEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingEntry(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingEntry copyWith({int? id, String? key, String? value}) => SettingEntry(
    id: id ?? this.id,
    key: key ?? this.key,
    value: value ?? this.value,
  );
  SettingEntry copyWithCompanion(SettingsTableCompanion data) {
    return SettingEntry(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingEntry(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingEntry &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsTableCompanion extends UpdateCompanion<SettingEntry> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> value;
  const SettingsTableCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String value,
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingEntry> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
    });
  }

  SettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<String>? value,
  }) {
    return SettingsTableCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $PairedDevicesTable extends PairedDevices
    with TableInfo<$PairedDevicesTable, PairedDevice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PairedDevicesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceNameMeta = const VerificationMeta(
    'deviceName',
  );
  @override
  late final GeneratedColumn<String> deviceName = GeneratedColumn<String>(
    'device_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ipMeta = const VerificationMeta('ip');
  @override
  late final GeneratedColumn<String> ip = GeneratedColumn<String>(
    'ip',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(9847),
  );
  static const VerificationMeta _pairedAtMeta = const VerificationMeta(
    'pairedAt',
  );
  @override
  late final GeneratedColumn<DateTime> pairedAt = GeneratedColumn<DateTime>(
    'paired_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSeenMeta = const VerificationMeta(
    'lastSeen',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeen = GeneratedColumn<DateTime>(
    'last_seen',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pairingSecretMeta = const VerificationMeta(
    'pairingSecret',
  );
  @override
  late final GeneratedColumn<String> pairingSecret = GeneratedColumn<String>(
    'pairing_secret',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isRevokedMeta = const VerificationMeta(
    'isRevoked',
  );
  @override
  late final GeneratedColumn<bool> isRevoked = GeneratedColumn<bool>(
    'is_revoked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_revoked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    deviceName,
    ip,
    port,
    pairedAt,
    lastSeen,
    pairingSecret,
    isRevoked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'paired_devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<PairedDevice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('device_name')) {
      context.handle(
        _deviceNameMeta,
        deviceName.isAcceptableOrUnknown(data['device_name']!, _deviceNameMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceNameMeta);
    }
    if (data.containsKey('ip')) {
      context.handle(_ipMeta, ip.isAcceptableOrUnknown(data['ip']!, _ipMeta));
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    }
    if (data.containsKey('paired_at')) {
      context.handle(
        _pairedAtMeta,
        pairedAt.isAcceptableOrUnknown(data['paired_at']!, _pairedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_pairedAtMeta);
    }
    if (data.containsKey('last_seen')) {
      context.handle(
        _lastSeenMeta,
        lastSeen.isAcceptableOrUnknown(data['last_seen']!, _lastSeenMeta),
      );
    } else if (isInserting) {
      context.missing(_lastSeenMeta);
    }
    if (data.containsKey('pairing_secret')) {
      context.handle(
        _pairingSecretMeta,
        pairingSecret.isAcceptableOrUnknown(
          data['pairing_secret']!,
          _pairingSecretMeta,
        ),
      );
    }
    if (data.containsKey('is_revoked')) {
      context.handle(
        _isRevokedMeta,
        isRevoked.isAcceptableOrUnknown(data['is_revoked']!, _isRevokedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PairedDevice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PairedDevice(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      deviceId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}device_id'],
          )!,
      deviceName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}device_name'],
          )!,
      ip:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}ip'],
          )!,
      port:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}port'],
          )!,
      pairedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}paired_at'],
          )!,
      lastSeen:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}last_seen'],
          )!,
      pairingSecret:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}pairing_secret'],
          )!,
      isRevoked:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_revoked'],
          )!,
    );
  }

  @override
  $PairedDevicesTable createAlias(String alias) {
    return $PairedDevicesTable(attachedDatabase, alias);
  }
}

class PairedDevice extends DataClass implements Insertable<PairedDevice> {
  final int id;
  final String deviceId;
  final String deviceName;
  final String ip;
  final int port;
  final DateTime pairedAt;
  final DateTime lastSeen;
  final String pairingSecret;
  final bool isRevoked;
  const PairedDevice({
    required this.id,
    required this.deviceId,
    required this.deviceName,
    required this.ip,
    required this.port,
    required this.pairedAt,
    required this.lastSeen,
    required this.pairingSecret,
    required this.isRevoked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['device_name'] = Variable<String>(deviceName);
    map['ip'] = Variable<String>(ip);
    map['port'] = Variable<int>(port);
    map['paired_at'] = Variable<DateTime>(pairedAt);
    map['last_seen'] = Variable<DateTime>(lastSeen);
    map['pairing_secret'] = Variable<String>(pairingSecret);
    map['is_revoked'] = Variable<bool>(isRevoked);
    return map;
  }

  PairedDevicesCompanion toCompanion(bool nullToAbsent) {
    return PairedDevicesCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      deviceName: Value(deviceName),
      ip: Value(ip),
      port: Value(port),
      pairedAt: Value(pairedAt),
      lastSeen: Value(lastSeen),
      pairingSecret: Value(pairingSecret),
      isRevoked: Value(isRevoked),
    );
  }

  factory PairedDevice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PairedDevice(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      deviceName: serializer.fromJson<String>(json['deviceName']),
      ip: serializer.fromJson<String>(json['ip']),
      port: serializer.fromJson<int>(json['port']),
      pairedAt: serializer.fromJson<DateTime>(json['pairedAt']),
      lastSeen: serializer.fromJson<DateTime>(json['lastSeen']),
      pairingSecret: serializer.fromJson<String>(json['pairingSecret']),
      isRevoked: serializer.fromJson<bool>(json['isRevoked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'deviceName': serializer.toJson<String>(deviceName),
      'ip': serializer.toJson<String>(ip),
      'port': serializer.toJson<int>(port),
      'pairedAt': serializer.toJson<DateTime>(pairedAt),
      'lastSeen': serializer.toJson<DateTime>(lastSeen),
      'pairingSecret': serializer.toJson<String>(pairingSecret),
      'isRevoked': serializer.toJson<bool>(isRevoked),
    };
  }

  PairedDevice copyWith({
    int? id,
    String? deviceId,
    String? deviceName,
    String? ip,
    int? port,
    DateTime? pairedAt,
    DateTime? lastSeen,
    String? pairingSecret,
    bool? isRevoked,
  }) => PairedDevice(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    deviceName: deviceName ?? this.deviceName,
    ip: ip ?? this.ip,
    port: port ?? this.port,
    pairedAt: pairedAt ?? this.pairedAt,
    lastSeen: lastSeen ?? this.lastSeen,
    pairingSecret: pairingSecret ?? this.pairingSecret,
    isRevoked: isRevoked ?? this.isRevoked,
  );
  PairedDevice copyWithCompanion(PairedDevicesCompanion data) {
    return PairedDevice(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      deviceName:
          data.deviceName.present ? data.deviceName.value : this.deviceName,
      ip: data.ip.present ? data.ip.value : this.ip,
      port: data.port.present ? data.port.value : this.port,
      pairedAt: data.pairedAt.present ? data.pairedAt.value : this.pairedAt,
      lastSeen: data.lastSeen.present ? data.lastSeen.value : this.lastSeen,
      pairingSecret:
          data.pairingSecret.present
              ? data.pairingSecret.value
              : this.pairingSecret,
      isRevoked: data.isRevoked.present ? data.isRevoked.value : this.isRevoked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PairedDevice(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('deviceName: $deviceName, ')
          ..write('ip: $ip, ')
          ..write('port: $port, ')
          ..write('pairedAt: $pairedAt, ')
          ..write('lastSeen: $lastSeen, ')
          ..write('pairingSecret: $pairingSecret, ')
          ..write('isRevoked: $isRevoked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deviceId,
    deviceName,
    ip,
    port,
    pairedAt,
    lastSeen,
    pairingSecret,
    isRevoked,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PairedDevice &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.deviceName == this.deviceName &&
          other.ip == this.ip &&
          other.port == this.port &&
          other.pairedAt == this.pairedAt &&
          other.lastSeen == this.lastSeen &&
          other.pairingSecret == this.pairingSecret &&
          other.isRevoked == this.isRevoked);
}

class PairedDevicesCompanion extends UpdateCompanion<PairedDevice> {
  final Value<int> id;
  final Value<String> deviceId;
  final Value<String> deviceName;
  final Value<String> ip;
  final Value<int> port;
  final Value<DateTime> pairedAt;
  final Value<DateTime> lastSeen;
  final Value<String> pairingSecret;
  final Value<bool> isRevoked;
  const PairedDevicesCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.deviceName = const Value.absent(),
    this.ip = const Value.absent(),
    this.port = const Value.absent(),
    this.pairedAt = const Value.absent(),
    this.lastSeen = const Value.absent(),
    this.pairingSecret = const Value.absent(),
    this.isRevoked = const Value.absent(),
  });
  PairedDevicesCompanion.insert({
    this.id = const Value.absent(),
    required String deviceId,
    required String deviceName,
    this.ip = const Value.absent(),
    this.port = const Value.absent(),
    required DateTime pairedAt,
    required DateTime lastSeen,
    this.pairingSecret = const Value.absent(),
    this.isRevoked = const Value.absent(),
  }) : deviceId = Value(deviceId),
       deviceName = Value(deviceName),
       pairedAt = Value(pairedAt),
       lastSeen = Value(lastSeen);
  static Insertable<PairedDevice> custom({
    Expression<int>? id,
    Expression<String>? deviceId,
    Expression<String>? deviceName,
    Expression<String>? ip,
    Expression<int>? port,
    Expression<DateTime>? pairedAt,
    Expression<DateTime>? lastSeen,
    Expression<String>? pairingSecret,
    Expression<bool>? isRevoked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (deviceName != null) 'device_name': deviceName,
      if (ip != null) 'ip': ip,
      if (port != null) 'port': port,
      if (pairedAt != null) 'paired_at': pairedAt,
      if (lastSeen != null) 'last_seen': lastSeen,
      if (pairingSecret != null) 'pairing_secret': pairingSecret,
      if (isRevoked != null) 'is_revoked': isRevoked,
    });
  }

  PairedDevicesCompanion copyWith({
    Value<int>? id,
    Value<String>? deviceId,
    Value<String>? deviceName,
    Value<String>? ip,
    Value<int>? port,
    Value<DateTime>? pairedAt,
    Value<DateTime>? lastSeen,
    Value<String>? pairingSecret,
    Value<bool>? isRevoked,
  }) {
    return PairedDevicesCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      ip: ip ?? this.ip,
      port: port ?? this.port,
      pairedAt: pairedAt ?? this.pairedAt,
      lastSeen: lastSeen ?? this.lastSeen,
      pairingSecret: pairingSecret ?? this.pairingSecret,
      isRevoked: isRevoked ?? this.isRevoked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (deviceName.present) {
      map['device_name'] = Variable<String>(deviceName.value);
    }
    if (ip.present) {
      map['ip'] = Variable<String>(ip.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (pairedAt.present) {
      map['paired_at'] = Variable<DateTime>(pairedAt.value);
    }
    if (lastSeen.present) {
      map['last_seen'] = Variable<DateTime>(lastSeen.value);
    }
    if (pairingSecret.present) {
      map['pairing_secret'] = Variable<String>(pairingSecret.value);
    }
    if (isRevoked.present) {
      map['is_revoked'] = Variable<bool>(isRevoked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PairedDevicesCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('deviceName: $deviceName, ')
          ..write('ip: $ip, ')
          ..write('port: $port, ')
          ..write('pairedAt: $pairedAt, ')
          ..write('lastSeen: $lastSeen, ')
          ..write('pairingSecret: $pairingSecret, ')
          ..write('isRevoked: $isRevoked')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $VaultEntriesTable vaultEntries = $VaultEntriesTable(this);
  late final $TotpEntriesTable totpEntries = $TotpEntriesTable(this);
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  late final $PairedDevicesTable pairedDevices = $PairedDevicesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    vaultEntries,
    totpEntries,
    settingsTable,
    pairedDevices,
  ];
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<String> icon,
      Value<String> colorHex,
      Value<bool> isDefault,
      Value<int> sortOrder,
      required DateTime createdAt,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> icon,
      Value<String> colorHex,
      Value<bool> isDefault,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VaultEntriesTable, List<VaultEntry>>
  _vaultEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.vaultEntries,
    aliasName: $_aliasNameGenerator(
      db.categories.id,
      db.vaultEntries.categoryId,
    ),
  );

  $$VaultEntriesTableProcessedTableManager get vaultEntriesRefs {
    final manager = $$VaultEntriesTableTableManager(
      $_db,
      $_db.vaultEntries,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_vaultEntriesRefsTable($_db));
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

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> vaultEntriesRefs(
    Expression<bool> Function($$VaultEntriesTableFilterComposer f) f,
  ) {
    final $$VaultEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vaultEntries,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VaultEntriesTableFilterComposer(
            $db: $db,
            $table: $db.vaultEntries,
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

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> vaultEntriesRefs<T extends Object>(
    Expression<T> Function($$VaultEntriesTableAnnotationComposer a) f,
  ) {
    final $$VaultEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vaultEntries,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VaultEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.vaultEntries,
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
          PrefetchHooks Function({bool vaultEntriesRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                icon: icon,
                colorHex: colorHex,
                isDefault: isDefault,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> icon = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                colorHex: colorHex,
                isDefault: isDefault,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$CategoriesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({vaultEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (vaultEntriesRefs) db.vaultEntries],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (vaultEntriesRefs)
                    await $_getPrefetchedData<
                      Category,
                      $CategoriesTable,
                      VaultEntry
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._vaultEntriesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).vaultEntriesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.categoryId == item.id,
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
      PrefetchHooks Function({bool vaultEntriesRefs})
    >;
typedef $$VaultEntriesTableCreateCompanionBuilder =
    VaultEntriesCompanion Function({
      Value<int> id,
      required String title,
      Value<String> username,
      required String password,
      Value<String> uri,
      Value<String> notes,
      Value<int?> categoryId,
      Value<String> icon,
      Value<bool> favorite,
      Value<int> passwordRenewalDays,
      required DateTime lastPasswordChange,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$VaultEntriesTableUpdateCompanionBuilder =
    VaultEntriesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> username,
      Value<String> password,
      Value<String> uri,
      Value<String> notes,
      Value<int?> categoryId,
      Value<String> icon,
      Value<bool> favorite,
      Value<int> passwordRenewalDays,
      Value<DateTime> lastPasswordChange,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$VaultEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $VaultEntriesTable, VaultEntry> {
  $$VaultEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
        $_aliasNameGenerator(db.vaultEntries.categoryId, db.categories.id),
      );

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
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

  static MultiTypedResultKey<$TotpEntriesTable, List<TotpEntry>>
  _totpEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.totpEntries,
    aliasName: $_aliasNameGenerator(
      db.vaultEntries.id,
      db.totpEntries.vaultEntryId,
    ),
  );

  $$TotpEntriesTableProcessedTableManager get totpEntriesRefs {
    final manager = $$TotpEntriesTableTableManager(
      $_db,
      $_db.totpEntries,
    ).filter((f) => f.vaultEntryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_totpEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VaultEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $VaultEntriesTable> {
  $$VaultEntriesTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uri => $composableBuilder(
    column: $table.uri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get passwordRenewalDays => $composableBuilder(
    column: $table.passwordRenewalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPasswordChange => $composableBuilder(
    column: $table.lastPasswordChange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

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

  Expression<bool> totpEntriesRefs(
    Expression<bool> Function($$TotpEntriesTableFilterComposer f) f,
  ) {
    final $$TotpEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.totpEntries,
      getReferencedColumn: (t) => t.vaultEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TotpEntriesTableFilterComposer(
            $db: $db,
            $table: $db.totpEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VaultEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $VaultEntriesTable> {
  $$VaultEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uri => $composableBuilder(
    column: $table.uri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get passwordRenewalDays => $composableBuilder(
    column: $table.passwordRenewalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPasswordChange => $composableBuilder(
    column: $table.lastPasswordChange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

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

class $$VaultEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VaultEntriesTable> {
  $$VaultEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get uri =>
      $composableBuilder(column: $table.uri, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<int> get passwordRenewalDays => $composableBuilder(
    column: $table.passwordRenewalDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPasswordChange => $composableBuilder(
    column: $table.lastPasswordChange,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

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

  Expression<T> totpEntriesRefs<T extends Object>(
    Expression<T> Function($$TotpEntriesTableAnnotationComposer a) f,
  ) {
    final $$TotpEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.totpEntries,
      getReferencedColumn: (t) => t.vaultEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TotpEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.totpEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VaultEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VaultEntriesTable,
          VaultEntry,
          $$VaultEntriesTableFilterComposer,
          $$VaultEntriesTableOrderingComposer,
          $$VaultEntriesTableAnnotationComposer,
          $$VaultEntriesTableCreateCompanionBuilder,
          $$VaultEntriesTableUpdateCompanionBuilder,
          (VaultEntry, $$VaultEntriesTableReferences),
          VaultEntry,
          PrefetchHooks Function({bool categoryId, bool totpEntriesRefs})
        > {
  $$VaultEntriesTableTableManager(_$AppDatabase db, $VaultEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$VaultEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$VaultEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$VaultEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String> uri = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<int> passwordRenewalDays = const Value.absent(),
                Value<DateTime> lastPasswordChange = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => VaultEntriesCompanion(
                id: id,
                title: title,
                username: username,
                password: password,
                uri: uri,
                notes: notes,
                categoryId: categoryId,
                icon: icon,
                favorite: favorite,
                passwordRenewalDays: passwordRenewalDays,
                lastPasswordChange: lastPasswordChange,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String> username = const Value.absent(),
                required String password,
                Value<String> uri = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<int> passwordRenewalDays = const Value.absent(),
                required DateTime lastPasswordChange,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => VaultEntriesCompanion.insert(
                id: id,
                title: title,
                username: username,
                password: password,
                uri: uri,
                notes: notes,
                categoryId: categoryId,
                icon: icon,
                favorite: favorite,
                passwordRenewalDays: passwordRenewalDays,
                lastPasswordChange: lastPasswordChange,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$VaultEntriesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            categoryId = false,
            totpEntriesRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (totpEntriesRefs) db.totpEntries],
              addJoins: <
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
                if (categoryId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$VaultEntriesTableReferences
                                ._categoryIdTable(db),
                            referencedColumn:
                                $$VaultEntriesTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (totpEntriesRefs)
                    await $_getPrefetchedData<
                      VaultEntry,
                      $VaultEntriesTable,
                      TotpEntry
                    >(
                      currentTable: table,
                      referencedTable: $$VaultEntriesTableReferences
                          ._totpEntriesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$VaultEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).totpEntriesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.vaultEntryId == item.id,
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

typedef $$VaultEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VaultEntriesTable,
      VaultEntry,
      $$VaultEntriesTableFilterComposer,
      $$VaultEntriesTableOrderingComposer,
      $$VaultEntriesTableAnnotationComposer,
      $$VaultEntriesTableCreateCompanionBuilder,
      $$VaultEntriesTableUpdateCompanionBuilder,
      (VaultEntry, $$VaultEntriesTableReferences),
      VaultEntry,
      PrefetchHooks Function({bool categoryId, bool totpEntriesRefs})
    >;
typedef $$TotpEntriesTableCreateCompanionBuilder =
    TotpEntriesCompanion Function({
      Value<int> id,
      required String issuer,
      required String accountName,
      required String secret,
      Value<int> digits,
      Value<int> period,
      Value<String> algorithm,
      Value<int?> vaultEntryId,
      required DateTime createdAt,
    });
typedef $$TotpEntriesTableUpdateCompanionBuilder =
    TotpEntriesCompanion Function({
      Value<int> id,
      Value<String> issuer,
      Value<String> accountName,
      Value<String> secret,
      Value<int> digits,
      Value<int> period,
      Value<String> algorithm,
      Value<int?> vaultEntryId,
      Value<DateTime> createdAt,
    });

final class $$TotpEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $TotpEntriesTable, TotpEntry> {
  $$TotpEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VaultEntriesTable _vaultEntryIdTable(_$AppDatabase db) =>
      db.vaultEntries.createAlias(
        $_aliasNameGenerator(db.totpEntries.vaultEntryId, db.vaultEntries.id),
      );

  $$VaultEntriesTableProcessedTableManager? get vaultEntryId {
    final $_column = $_itemColumn<int>('vault_entry_id');
    if ($_column == null) return null;
    final manager = $$VaultEntriesTableTableManager(
      $_db,
      $_db.vaultEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vaultEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TotpEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TotpEntriesTable> {
  $$TotpEntriesTableFilterComposer({
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

  ColumnFilters<String> get issuer => $composableBuilder(
    column: $table.issuer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secret => $composableBuilder(
    column: $table.secret,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get digits => $composableBuilder(
    column: $table.digits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get algorithm => $composableBuilder(
    column: $table.algorithm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VaultEntriesTableFilterComposer get vaultEntryId {
    final $$VaultEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vaultEntryId,
      referencedTable: $db.vaultEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VaultEntriesTableFilterComposer(
            $db: $db,
            $table: $db.vaultEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TotpEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TotpEntriesTable> {
  $$TotpEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get issuer => $composableBuilder(
    column: $table.issuer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secret => $composableBuilder(
    column: $table.secret,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get digits => $composableBuilder(
    column: $table.digits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get algorithm => $composableBuilder(
    column: $table.algorithm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VaultEntriesTableOrderingComposer get vaultEntryId {
    final $$VaultEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vaultEntryId,
      referencedTable: $db.vaultEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VaultEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.vaultEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TotpEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TotpEntriesTable> {
  $$TotpEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get issuer =>
      $composableBuilder(column: $table.issuer, builder: (column) => column);

  GeneratedColumn<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get secret =>
      $composableBuilder(column: $table.secret, builder: (column) => column);

  GeneratedColumn<int> get digits =>
      $composableBuilder(column: $table.digits, builder: (column) => column);

  GeneratedColumn<int> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<String> get algorithm =>
      $composableBuilder(column: $table.algorithm, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$VaultEntriesTableAnnotationComposer get vaultEntryId {
    final $$VaultEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vaultEntryId,
      referencedTable: $db.vaultEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VaultEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.vaultEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TotpEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TotpEntriesTable,
          TotpEntry,
          $$TotpEntriesTableFilterComposer,
          $$TotpEntriesTableOrderingComposer,
          $$TotpEntriesTableAnnotationComposer,
          $$TotpEntriesTableCreateCompanionBuilder,
          $$TotpEntriesTableUpdateCompanionBuilder,
          (TotpEntry, $$TotpEntriesTableReferences),
          TotpEntry,
          PrefetchHooks Function({bool vaultEntryId})
        > {
  $$TotpEntriesTableTableManager(_$AppDatabase db, $TotpEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TotpEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TotpEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$TotpEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> issuer = const Value.absent(),
                Value<String> accountName = const Value.absent(),
                Value<String> secret = const Value.absent(),
                Value<int> digits = const Value.absent(),
                Value<int> period = const Value.absent(),
                Value<String> algorithm = const Value.absent(),
                Value<int?> vaultEntryId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TotpEntriesCompanion(
                id: id,
                issuer: issuer,
                accountName: accountName,
                secret: secret,
                digits: digits,
                period: period,
                algorithm: algorithm,
                vaultEntryId: vaultEntryId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String issuer,
                required String accountName,
                required String secret,
                Value<int> digits = const Value.absent(),
                Value<int> period = const Value.absent(),
                Value<String> algorithm = const Value.absent(),
                Value<int?> vaultEntryId = const Value.absent(),
                required DateTime createdAt,
              }) => TotpEntriesCompanion.insert(
                id: id,
                issuer: issuer,
                accountName: accountName,
                secret: secret,
                digits: digits,
                period: period,
                algorithm: algorithm,
                vaultEntryId: vaultEntryId,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TotpEntriesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({vaultEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (vaultEntryId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.vaultEntryId,
                            referencedTable: $$TotpEntriesTableReferences
                                ._vaultEntryIdTable(db),
                            referencedColumn:
                                $$TotpEntriesTableReferences
                                    ._vaultEntryIdTable(db)
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

typedef $$TotpEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TotpEntriesTable,
      TotpEntry,
      $$TotpEntriesTableFilterComposer,
      $$TotpEntriesTableOrderingComposer,
      $$TotpEntriesTableAnnotationComposer,
      $$TotpEntriesTableCreateCompanionBuilder,
      $$TotpEntriesTableUpdateCompanionBuilder,
      (TotpEntry, $$TotpEntriesTableReferences),
      TotpEntry,
      PrefetchHooks Function({bool vaultEntryId})
    >;
typedef $$SettingsTableTableCreateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      required String key,
      required String value,
    });
typedef $$SettingsTableTableUpdateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      Value<String> key,
      Value<String> value,
    });

class $$SettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
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

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
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

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTableTable,
          SettingEntry,
          $$SettingsTableTableFilterComposer,
          $$SettingsTableTableOrderingComposer,
          $$SettingsTableTableAnnotationComposer,
          $$SettingsTableTableCreateCompanionBuilder,
          $$SettingsTableTableUpdateCompanionBuilder,
          (
            SettingEntry,
            BaseReferences<_$AppDatabase, $SettingsTableTable, SettingEntry>,
          ),
          SettingEntry,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableTableManager(_$AppDatabase db, $SettingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$SettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
              }) => SettingsTableCompanion(id: id, key: key, value: value),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                required String value,
              }) =>
                  SettingsTableCompanion.insert(id: id, key: key, value: value),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTableTable,
      SettingEntry,
      $$SettingsTableTableFilterComposer,
      $$SettingsTableTableOrderingComposer,
      $$SettingsTableTableAnnotationComposer,
      $$SettingsTableTableCreateCompanionBuilder,
      $$SettingsTableTableUpdateCompanionBuilder,
      (
        SettingEntry,
        BaseReferences<_$AppDatabase, $SettingsTableTable, SettingEntry>,
      ),
      SettingEntry,
      PrefetchHooks Function()
    >;
typedef $$PairedDevicesTableCreateCompanionBuilder =
    PairedDevicesCompanion Function({
      Value<int> id,
      required String deviceId,
      required String deviceName,
      Value<String> ip,
      Value<int> port,
      required DateTime pairedAt,
      required DateTime lastSeen,
      Value<String> pairingSecret,
      Value<bool> isRevoked,
    });
typedef $$PairedDevicesTableUpdateCompanionBuilder =
    PairedDevicesCompanion Function({
      Value<int> id,
      Value<String> deviceId,
      Value<String> deviceName,
      Value<String> ip,
      Value<int> port,
      Value<DateTime> pairedAt,
      Value<DateTime> lastSeen,
      Value<String> pairingSecret,
      Value<bool> isRevoked,
    });

class $$PairedDevicesTableFilterComposer
    extends Composer<_$AppDatabase, $PairedDevicesTable> {
  $$PairedDevicesTableFilterComposer({
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

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ip => $composableBuilder(
    column: $table.ip,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pairedAt => $composableBuilder(
    column: $table.pairedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pairingSecret => $composableBuilder(
    column: $table.pairingSecret,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRevoked => $composableBuilder(
    column: $table.isRevoked,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PairedDevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $PairedDevicesTable> {
  $$PairedDevicesTableOrderingComposer({
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

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ip => $composableBuilder(
    column: $table.ip,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pairedAt => $composableBuilder(
    column: $table.pairedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pairingSecret => $composableBuilder(
    column: $table.pairingSecret,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRevoked => $composableBuilder(
    column: $table.isRevoked,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PairedDevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PairedDevicesTable> {
  $$PairedDevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ip =>
      $composableBuilder(column: $table.ip, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<DateTime> get pairedAt =>
      $composableBuilder(column: $table.pairedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeen =>
      $composableBuilder(column: $table.lastSeen, builder: (column) => column);

  GeneratedColumn<String> get pairingSecret => $composableBuilder(
    column: $table.pairingSecret,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRevoked =>
      $composableBuilder(column: $table.isRevoked, builder: (column) => column);
}

class $$PairedDevicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PairedDevicesTable,
          PairedDevice,
          $$PairedDevicesTableFilterComposer,
          $$PairedDevicesTableOrderingComposer,
          $$PairedDevicesTableAnnotationComposer,
          $$PairedDevicesTableCreateCompanionBuilder,
          $$PairedDevicesTableUpdateCompanionBuilder,
          (
            PairedDevice,
            BaseReferences<_$AppDatabase, $PairedDevicesTable, PairedDevice>,
          ),
          PairedDevice,
          PrefetchHooks Function()
        > {
  $$PairedDevicesTableTableManager(_$AppDatabase db, $PairedDevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PairedDevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$PairedDevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PairedDevicesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> deviceName = const Value.absent(),
                Value<String> ip = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<DateTime> pairedAt = const Value.absent(),
                Value<DateTime> lastSeen = const Value.absent(),
                Value<String> pairingSecret = const Value.absent(),
                Value<bool> isRevoked = const Value.absent(),
              }) => PairedDevicesCompanion(
                id: id,
                deviceId: deviceId,
                deviceName: deviceName,
                ip: ip,
                port: port,
                pairedAt: pairedAt,
                lastSeen: lastSeen,
                pairingSecret: pairingSecret,
                isRevoked: isRevoked,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String deviceId,
                required String deviceName,
                Value<String> ip = const Value.absent(),
                Value<int> port = const Value.absent(),
                required DateTime pairedAt,
                required DateTime lastSeen,
                Value<String> pairingSecret = const Value.absent(),
                Value<bool> isRevoked = const Value.absent(),
              }) => PairedDevicesCompanion.insert(
                id: id,
                deviceId: deviceId,
                deviceName: deviceName,
                ip: ip,
                port: port,
                pairedAt: pairedAt,
                lastSeen: lastSeen,
                pairingSecret: pairingSecret,
                isRevoked: isRevoked,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PairedDevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PairedDevicesTable,
      PairedDevice,
      $$PairedDevicesTableFilterComposer,
      $$PairedDevicesTableOrderingComposer,
      $$PairedDevicesTableAnnotationComposer,
      $$PairedDevicesTableCreateCompanionBuilder,
      $$PairedDevicesTableUpdateCompanionBuilder,
      (
        PairedDevice,
        BaseReferences<_$AppDatabase, $PairedDevicesTable, PairedDevice>,
      ),
      PairedDevice,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$VaultEntriesTableTableManager get vaultEntries =>
      $$VaultEntriesTableTableManager(_db, _db.vaultEntries);
  $$TotpEntriesTableTableManager get totpEntries =>
      $$TotpEntriesTableTableManager(_db, _db.totpEntries);
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
  $$PairedDevicesTableTableManager get pairedDevices =>
      $$PairedDevicesTableTableManager(_db, _db.pairedDevices);
}
