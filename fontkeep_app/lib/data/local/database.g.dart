// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FontsTable extends Fonts with TableInfo<$FontsTable, Font> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FontsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familyNameMeta = const VerificationMeta(
    'familyName',
  );
  @override
  late final GeneratedColumn<String> familyName = GeneratedColumn<String>(
    'family_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subFamilyMeta = const VerificationMeta(
    'subFamily',
  );
  @override
  late final GeneratedColumn<String> subFamily = GeneratedColumn<String>(
    'sub_family',
    aliasedName,
    false,
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
  static const VerificationMeta _fileHashMeta = const VerificationMeta(
    'fileHash',
  );
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateAddedMeta = const VerificationMeta(
    'dateAdded',
  );
  @override
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
    'date_added',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isBuiltInMeta = const VerificationMeta(
    'isBuiltIn',
  );
  @override
  late final GeneratedColumn<bool> isBuiltIn = GeneratedColumn<bool>(
    'is_built_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_built_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    familyName,
    subFamily,
    filePath,
    fileHash,
    fileSize,
    dateAdded,
    isSystem,
    isBuiltIn,
    isSynced,
    remoteId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fonts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Font> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_name')) {
      context.handle(
        _familyNameMeta,
        familyName.isAcceptableOrUnknown(data['family_name']!, _familyNameMeta),
      );
    } else if (isInserting) {
      context.missing(_familyNameMeta);
    }
    if (data.containsKey('sub_family')) {
      context.handle(
        _subFamilyMeta,
        subFamily.isAcceptableOrUnknown(data['sub_family']!, _subFamilyMeta),
      );
    } else if (isInserting) {
      context.missing(_subFamilyMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_hash')) {
      context.handle(
        _fileHashMeta,
        fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta),
      );
    } else if (isInserting) {
      context.missing(_fileHashMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('date_added')) {
      context.handle(
        _dateAddedMeta,
        dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta),
      );
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('is_built_in')) {
      context.handle(
        _isBuiltInMeta,
        isBuiltIn.isAcceptableOrUnknown(data['is_built_in']!, _isBuiltInMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Font map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Font(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      familyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_name'],
      )!,
      subFamily: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_family'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      fileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_hash'],
      )!,
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      )!,
      dateAdded: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_added'],
      )!,
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      isBuiltIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_built_in'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
    );
  }

  @override
  $FontsTable createAlias(String alias) {
    return $FontsTable(attachedDatabase, alias);
  }
}

class Font extends DataClass implements Insertable<Font> {
  final String id;
  final String familyName;
  final String subFamily;
  final String filePath;
  final String fileHash;
  final int fileSize;
  final DateTime dateAdded;
  final bool isSystem;
  final bool isBuiltIn;
  final bool isSynced;
  final String? remoteId;
  const Font({
    required this.id,
    required this.familyName,
    required this.subFamily,
    required this.filePath,
    required this.fileHash,
    required this.fileSize,
    required this.dateAdded,
    required this.isSystem,
    required this.isBuiltIn,
    required this.isSynced,
    this.remoteId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_name'] = Variable<String>(familyName);
    map['sub_family'] = Variable<String>(subFamily);
    map['file_path'] = Variable<String>(filePath);
    map['file_hash'] = Variable<String>(fileHash);
    map['file_size'] = Variable<int>(fileSize);
    map['date_added'] = Variable<DateTime>(dateAdded);
    map['is_system'] = Variable<bool>(isSystem);
    map['is_built_in'] = Variable<bool>(isBuiltIn);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    return map;
  }

  FontsCompanion toCompanion(bool nullToAbsent) {
    return FontsCompanion(
      id: Value(id),
      familyName: Value(familyName),
      subFamily: Value(subFamily),
      filePath: Value(filePath),
      fileHash: Value(fileHash),
      fileSize: Value(fileSize),
      dateAdded: Value(dateAdded),
      isSystem: Value(isSystem),
      isBuiltIn: Value(isBuiltIn),
      isSynced: Value(isSynced),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
    );
  }

  factory Font.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Font(
      id: serializer.fromJson<String>(json['id']),
      familyName: serializer.fromJson<String>(json['familyName']),
      subFamily: serializer.fromJson<String>(json['subFamily']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileHash: serializer.fromJson<String>(json['fileHash']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      dateAdded: serializer.fromJson<DateTime>(json['dateAdded']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      isBuiltIn: serializer.fromJson<bool>(json['isBuiltIn']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyName': serializer.toJson<String>(familyName),
      'subFamily': serializer.toJson<String>(subFamily),
      'filePath': serializer.toJson<String>(filePath),
      'fileHash': serializer.toJson<String>(fileHash),
      'fileSize': serializer.toJson<int>(fileSize),
      'dateAdded': serializer.toJson<DateTime>(dateAdded),
      'isSystem': serializer.toJson<bool>(isSystem),
      'isBuiltIn': serializer.toJson<bool>(isBuiltIn),
      'isSynced': serializer.toJson<bool>(isSynced),
      'remoteId': serializer.toJson<String?>(remoteId),
    };
  }

  Font copyWith({
    String? id,
    String? familyName,
    String? subFamily,
    String? filePath,
    String? fileHash,
    int? fileSize,
    DateTime? dateAdded,
    bool? isSystem,
    bool? isBuiltIn,
    bool? isSynced,
    Value<String?> remoteId = const Value.absent(),
  }) => Font(
    id: id ?? this.id,
    familyName: familyName ?? this.familyName,
    subFamily: subFamily ?? this.subFamily,
    filePath: filePath ?? this.filePath,
    fileHash: fileHash ?? this.fileHash,
    fileSize: fileSize ?? this.fileSize,
    dateAdded: dateAdded ?? this.dateAdded,
    isSystem: isSystem ?? this.isSystem,
    isBuiltIn: isBuiltIn ?? this.isBuiltIn,
    isSynced: isSynced ?? this.isSynced,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
  );
  Font copyWithCompanion(FontsCompanion data) {
    return Font(
      id: data.id.present ? data.id.value : this.id,
      familyName: data.familyName.present
          ? data.familyName.value
          : this.familyName,
      subFamily: data.subFamily.present ? data.subFamily.value : this.subFamily,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      isBuiltIn: data.isBuiltIn.present ? data.isBuiltIn.value : this.isBuiltIn,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Font(')
          ..write('id: $id, ')
          ..write('familyName: $familyName, ')
          ..write('subFamily: $subFamily, ')
          ..write('filePath: $filePath, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileSize: $fileSize, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('isSystem: $isSystem, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('isSynced: $isSynced, ')
          ..write('remoteId: $remoteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    familyName,
    subFamily,
    filePath,
    fileHash,
    fileSize,
    dateAdded,
    isSystem,
    isBuiltIn,
    isSynced,
    remoteId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Font &&
          other.id == this.id &&
          other.familyName == this.familyName &&
          other.subFamily == this.subFamily &&
          other.filePath == this.filePath &&
          other.fileHash == this.fileHash &&
          other.fileSize == this.fileSize &&
          other.dateAdded == this.dateAdded &&
          other.isSystem == this.isSystem &&
          other.isBuiltIn == this.isBuiltIn &&
          other.isSynced == this.isSynced &&
          other.remoteId == this.remoteId);
}

class FontsCompanion extends UpdateCompanion<Font> {
  final Value<String> id;
  final Value<String> familyName;
  final Value<String> subFamily;
  final Value<String> filePath;
  final Value<String> fileHash;
  final Value<int> fileSize;
  final Value<DateTime> dateAdded;
  final Value<bool> isSystem;
  final Value<bool> isBuiltIn;
  final Value<bool> isSynced;
  final Value<String?> remoteId;
  final Value<int> rowid;
  const FontsCompanion({
    this.id = const Value.absent(),
    this.familyName = const Value.absent(),
    this.subFamily = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FontsCompanion.insert({
    required String id,
    required String familyName,
    required String subFamily,
    required String filePath,
    required String fileHash,
    required int fileSize,
    this.dateAdded = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       familyName = Value(familyName),
       subFamily = Value(subFamily),
       filePath = Value(filePath),
       fileHash = Value(fileHash),
       fileSize = Value(fileSize);
  static Insertable<Font> custom({
    Expression<String>? id,
    Expression<String>? familyName,
    Expression<String>? subFamily,
    Expression<String>? filePath,
    Expression<String>? fileHash,
    Expression<int>? fileSize,
    Expression<DateTime>? dateAdded,
    Expression<bool>? isSystem,
    Expression<bool>? isBuiltIn,
    Expression<bool>? isSynced,
    Expression<String>? remoteId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyName != null) 'family_name': familyName,
      if (subFamily != null) 'sub_family': subFamily,
      if (filePath != null) 'file_path': filePath,
      if (fileHash != null) 'file_hash': fileHash,
      if (fileSize != null) 'file_size': fileSize,
      if (dateAdded != null) 'date_added': dateAdded,
      if (isSystem != null) 'is_system': isSystem,
      if (isBuiltIn != null) 'is_built_in': isBuiltIn,
      if (isSynced != null) 'is_synced': isSynced,
      if (remoteId != null) 'remote_id': remoteId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FontsCompanion copyWith({
    Value<String>? id,
    Value<String>? familyName,
    Value<String>? subFamily,
    Value<String>? filePath,
    Value<String>? fileHash,
    Value<int>? fileSize,
    Value<DateTime>? dateAdded,
    Value<bool>? isSystem,
    Value<bool>? isBuiltIn,
    Value<bool>? isSynced,
    Value<String?>? remoteId,
    Value<int>? rowid,
  }) {
    return FontsCompanion(
      id: id ?? this.id,
      familyName: familyName ?? this.familyName,
      subFamily: subFamily ?? this.subFamily,
      filePath: filePath ?? this.filePath,
      fileHash: fileHash ?? this.fileHash,
      fileSize: fileSize ?? this.fileSize,
      dateAdded: dateAdded ?? this.dateAdded,
      isSystem: isSystem ?? this.isSystem,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      isSynced: isSynced ?? this.isSynced,
      remoteId: remoteId ?? this.remoteId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyName.present) {
      map['family_name'] = Variable<String>(familyName.value);
    }
    if (subFamily.present) {
      map['sub_family'] = Variable<String>(subFamily.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<DateTime>(dateAdded.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (isBuiltIn.present) {
      map['is_built_in'] = Variable<bool>(isBuiltIn.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FontsCompanion(')
          ..write('id: $id, ')
          ..write('familyName: $familyName, ')
          ..write('subFamily: $subFamily, ')
          ..write('filePath: $filePath, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileSize: $fileSize, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('isSystem: $isSystem, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('isSynced: $isSynced, ')
          ..write('remoteId: $remoteId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CollectionsTable extends Collections
    with TableInfo<$CollectionsTable, Collection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionsTable(this.attachedDatabase, [this._alias]);
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
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collections';
  @override
  VerificationContext validateIntegrity(
    Insertable<Collection> instance, {
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
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Collection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Collection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      ),
    );
  }

  @override
  $CollectionsTable createAlias(String alias) {
    return $CollectionsTable(attachedDatabase, alias);
  }
}

class Collection extends DataClass implements Insertable<Collection> {
  final int id;
  final String name;
  final int? color;
  const Collection({required this.id, required this.name, this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    return map;
  }

  CollectionsCompanion toCompanion(bool nullToAbsent) {
    return CollectionsCompanion(
      id: Value(id),
      name: Value(name),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
    );
  }

  factory Collection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Collection(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int?>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int?>(color),
    };
  }

  Collection copyWith({
    int? id,
    String? name,
    Value<int?> color = const Value.absent(),
  }) => Collection(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color.present ? color.value : this.color,
  );
  Collection copyWithCompanion(CollectionsCompanion data) {
    return Collection(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Collection(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Collection &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color);
}

class CollectionsCompanion extends UpdateCompanion<Collection> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> color;
  const CollectionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
  });
  CollectionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Collection> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
    });
  }

  CollectionsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int?>? color,
  }) {
    return CollectionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
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
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $FontCollectionsTable extends FontCollections
    with TableInfo<$FontCollectionsTable, FontCollection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FontCollectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fontIdMeta = const VerificationMeta('fontId');
  @override
  late final GeneratedColumn<String> fontId = GeneratedColumn<String>(
    'font_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES fonts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _collectionIdMeta = const VerificationMeta(
    'collectionId',
  );
  @override
  late final GeneratedColumn<int> collectionId = GeneratedColumn<int>(
    'collection_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES collections (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [fontId, collectionId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'font_collections';
  @override
  VerificationContext validateIntegrity(
    Insertable<FontCollection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('font_id')) {
      context.handle(
        _fontIdMeta,
        fontId.isAcceptableOrUnknown(data['font_id']!, _fontIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fontIdMeta);
    }
    if (data.containsKey('collection_id')) {
      context.handle(
        _collectionIdMeta,
        collectionId.isAcceptableOrUnknown(
          data['collection_id']!,
          _collectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fontId, collectionId};
  @override
  FontCollection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FontCollection(
      fontId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}font_id'],
      )!,
      collectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}collection_id'],
      )!,
    );
  }

  @override
  $FontCollectionsTable createAlias(String alias) {
    return $FontCollectionsTable(attachedDatabase, alias);
  }
}

class FontCollection extends DataClass implements Insertable<FontCollection> {
  final String fontId;
  final int collectionId;
  const FontCollection({required this.fontId, required this.collectionId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['font_id'] = Variable<String>(fontId);
    map['collection_id'] = Variable<int>(collectionId);
    return map;
  }

  FontCollectionsCompanion toCompanion(bool nullToAbsent) {
    return FontCollectionsCompanion(
      fontId: Value(fontId),
      collectionId: Value(collectionId),
    );
  }

  factory FontCollection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FontCollection(
      fontId: serializer.fromJson<String>(json['fontId']),
      collectionId: serializer.fromJson<int>(json['collectionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fontId': serializer.toJson<String>(fontId),
      'collectionId': serializer.toJson<int>(collectionId),
    };
  }

  FontCollection copyWith({String? fontId, int? collectionId}) =>
      FontCollection(
        fontId: fontId ?? this.fontId,
        collectionId: collectionId ?? this.collectionId,
      );
  FontCollection copyWithCompanion(FontCollectionsCompanion data) {
    return FontCollection(
      fontId: data.fontId.present ? data.fontId.value : this.fontId,
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FontCollection(')
          ..write('fontId: $fontId, ')
          ..write('collectionId: $collectionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(fontId, collectionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FontCollection &&
          other.fontId == this.fontId &&
          other.collectionId == this.collectionId);
}

class FontCollectionsCompanion extends UpdateCompanion<FontCollection> {
  final Value<String> fontId;
  final Value<int> collectionId;
  final Value<int> rowid;
  const FontCollectionsCompanion({
    this.fontId = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FontCollectionsCompanion.insert({
    required String fontId,
    required int collectionId,
    this.rowid = const Value.absent(),
  }) : fontId = Value(fontId),
       collectionId = Value(collectionId);
  static Insertable<FontCollection> custom({
    Expression<String>? fontId,
    Expression<int>? collectionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fontId != null) 'font_id': fontId,
      if (collectionId != null) 'collection_id': collectionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FontCollectionsCompanion copyWith({
    Value<String>? fontId,
    Value<int>? collectionId,
    Value<int>? rowid,
  }) {
    return FontCollectionsCompanion(
      fontId: fontId ?? this.fontId,
      collectionId: collectionId ?? this.collectionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fontId.present) {
      map['font_id'] = Variable<String>(fontId.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<int>(collectionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FontCollectionsCompanion(')
          ..write('fontId: $fontId, ')
          ..write('collectionId: $collectionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncLogsTable extends SyncLogs with TableInfo<$SyncLogsTable, SyncLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    deviceName,
    action,
    details,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    if (data.containsKey('device_name')) {
      context.handle(
        _deviceNameMeta,
        deviceName.isAcceptableOrUnknown(data['device_name']!, _deviceNameMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceNameMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      deviceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_name'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
    );
  }

  @override
  $SyncLogsTable createAlias(String alias) {
    return $SyncLogsTable(attachedDatabase, alias);
  }
}

class SyncLog extends DataClass implements Insertable<SyncLog> {
  final int id;
  final DateTime timestamp;
  final String deviceName;
  final String action;
  final String? details;
  const SyncLog({
    required this.id,
    required this.timestamp,
    required this.deviceName,
    required this.action,
    this.details,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['device_name'] = Variable<String>(deviceName);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    return map;
  }

  SyncLogsCompanion toCompanion(bool nullToAbsent) {
    return SyncLogsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      deviceName: Value(deviceName),
      action: Value(action),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
    );
  }

  factory SyncLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncLog(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      deviceName: serializer.fromJson<String>(json['deviceName']),
      action: serializer.fromJson<String>(json['action']),
      details: serializer.fromJson<String?>(json['details']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'deviceName': serializer.toJson<String>(deviceName),
      'action': serializer.toJson<String>(action),
      'details': serializer.toJson<String?>(details),
    };
  }

  SyncLog copyWith({
    int? id,
    DateTime? timestamp,
    String? deviceName,
    String? action,
    Value<String?> details = const Value.absent(),
  }) => SyncLog(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    deviceName: deviceName ?? this.deviceName,
    action: action ?? this.action,
    details: details.present ? details.value : this.details,
  );
  SyncLog copyWithCompanion(SyncLogsCompanion data) {
    return SyncLog(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      deviceName: data.deviceName.present
          ? data.deviceName.value
          : this.deviceName,
      action: data.action.present ? data.action.value : this.action,
      details: data.details.present ? data.details.value : this.details,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncLog(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('deviceName: $deviceName, ')
          ..write('action: $action, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, deviceName, action, details);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncLog &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.deviceName == this.deviceName &&
          other.action == this.action &&
          other.details == this.details);
}

class SyncLogsCompanion extends UpdateCompanion<SyncLog> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<String> deviceName;
  final Value<String> action;
  final Value<String?> details;
  const SyncLogsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.deviceName = const Value.absent(),
    this.action = const Value.absent(),
    this.details = const Value.absent(),
  });
  SyncLogsCompanion.insert({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    required String deviceName,
    required String action,
    this.details = const Value.absent(),
  }) : deviceName = Value(deviceName),
       action = Value(action);
  static Insertable<SyncLog> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<String>? deviceName,
    Expression<String>? action,
    Expression<String>? details,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (deviceName != null) 'device_name': deviceName,
      if (action != null) 'action': action,
      if (details != null) 'details': details,
    });
  }

  SyncLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<String>? deviceName,
    Value<String>? action,
    Value<String?>? details,
  }) {
    return SyncLogsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      deviceName: deviceName ?? this.deviceName,
      action: action ?? this.action,
      details: details ?? this.details,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (deviceName.present) {
      map['device_name'] = Variable<String>(deviceName.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncLogsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('deviceName: $deviceName, ')
          ..write('action: $action, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FontsTable fonts = $FontsTable(this);
  late final $CollectionsTable collections = $CollectionsTable(this);
  late final $FontCollectionsTable fontCollections = $FontCollectionsTable(
    this,
  );
  late final $SyncLogsTable syncLogs = $SyncLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    fonts,
    collections,
    fontCollections,
    syncLogs,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'fonts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('font_collections', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'collections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('font_collections', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$FontsTableCreateCompanionBuilder =
    FontsCompanion Function({
      required String id,
      required String familyName,
      required String subFamily,
      required String filePath,
      required String fileHash,
      required int fileSize,
      Value<DateTime> dateAdded,
      Value<bool> isSystem,
      Value<bool> isBuiltIn,
      Value<bool> isSynced,
      Value<String?> remoteId,
      Value<int> rowid,
    });
typedef $$FontsTableUpdateCompanionBuilder =
    FontsCompanion Function({
      Value<String> id,
      Value<String> familyName,
      Value<String> subFamily,
      Value<String> filePath,
      Value<String> fileHash,
      Value<int> fileSize,
      Value<DateTime> dateAdded,
      Value<bool> isSystem,
      Value<bool> isBuiltIn,
      Value<bool> isSynced,
      Value<String?> remoteId,
      Value<int> rowid,
    });

final class $$FontsTableReferences
    extends BaseReferences<_$AppDatabase, $FontsTable, Font> {
  $$FontsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FontCollectionsTable, List<FontCollection>>
  _fontCollectionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fontCollections,
    aliasName: $_aliasNameGenerator(db.fonts.id, db.fontCollections.fontId),
  );

  $$FontCollectionsTableProcessedTableManager get fontCollectionsRefs {
    final manager = $$FontCollectionsTableTableManager(
      $_db,
      $_db.fontCollections,
    ).filter((f) => f.fontId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _fontCollectionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FontsTableFilterComposer extends Composer<_$AppDatabase, $FontsTable> {
  $$FontsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyName => $composableBuilder(
    column: $table.familyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subFamily => $composableBuilder(
    column: $table.subFamily,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> fontCollectionsRefs(
    Expression<bool> Function($$FontCollectionsTableFilterComposer f) f,
  ) {
    final $$FontCollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fontCollections,
      getReferencedColumn: (t) => t.fontId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FontCollectionsTableFilterComposer(
            $db: $db,
            $table: $db.fontCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FontsTableOrderingComposer
    extends Composer<_$AppDatabase, $FontsTable> {
  $$FontsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyName => $composableBuilder(
    column: $table.familyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subFamily => $composableBuilder(
    column: $table.subFamily,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FontsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FontsTable> {
  $$FontsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get familyName => $composableBuilder(
    column: $table.familyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subFamily =>
      $composableBuilder(column: $table.subFamily, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<DateTime> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<bool> get isBuiltIn =>
      $composableBuilder(column: $table.isBuiltIn, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  Expression<T> fontCollectionsRefs<T extends Object>(
    Expression<T> Function($$FontCollectionsTableAnnotationComposer a) f,
  ) {
    final $$FontCollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fontCollections,
      getReferencedColumn: (t) => t.fontId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FontCollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.fontCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FontsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FontsTable,
          Font,
          $$FontsTableFilterComposer,
          $$FontsTableOrderingComposer,
          $$FontsTableAnnotationComposer,
          $$FontsTableCreateCompanionBuilder,
          $$FontsTableUpdateCompanionBuilder,
          (Font, $$FontsTableReferences),
          Font,
          PrefetchHooks Function({bool fontCollectionsRefs})
        > {
  $$FontsTableTableManager(_$AppDatabase db, $FontsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FontsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FontsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FontsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> familyName = const Value.absent(),
                Value<String> subFamily = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> fileHash = const Value.absent(),
                Value<int> fileSize = const Value.absent(),
                Value<DateTime> dateAdded = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FontsCompanion(
                id: id,
                familyName: familyName,
                subFamily: subFamily,
                filePath: filePath,
                fileHash: fileHash,
                fileSize: fileSize,
                dateAdded: dateAdded,
                isSystem: isSystem,
                isBuiltIn: isBuiltIn,
                isSynced: isSynced,
                remoteId: remoteId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String familyName,
                required String subFamily,
                required String filePath,
                required String fileHash,
                required int fileSize,
                Value<DateTime> dateAdded = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FontsCompanion.insert(
                id: id,
                familyName: familyName,
                subFamily: subFamily,
                filePath: filePath,
                fileHash: fileHash,
                fileSize: fileSize,
                dateAdded: dateAdded,
                isSystem: isSystem,
                isBuiltIn: isBuiltIn,
                isSynced: isSynced,
                remoteId: remoteId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$FontsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({fontCollectionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (fontCollectionsRefs) db.fontCollections,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (fontCollectionsRefs)
                    await $_getPrefetchedData<
                      Font,
                      $FontsTable,
                      FontCollection
                    >(
                      currentTable: table,
                      referencedTable: $$FontsTableReferences
                          ._fontCollectionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$FontsTableReferences(
                        db,
                        table,
                        p0,
                      ).fontCollectionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.fontId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FontsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FontsTable,
      Font,
      $$FontsTableFilterComposer,
      $$FontsTableOrderingComposer,
      $$FontsTableAnnotationComposer,
      $$FontsTableCreateCompanionBuilder,
      $$FontsTableUpdateCompanionBuilder,
      (Font, $$FontsTableReferences),
      Font,
      PrefetchHooks Function({bool fontCollectionsRefs})
    >;
typedef $$CollectionsTableCreateCompanionBuilder =
    CollectionsCompanion Function({
      Value<int> id,
      required String name,
      Value<int?> color,
    });
typedef $$CollectionsTableUpdateCompanionBuilder =
    CollectionsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int?> color,
    });

final class $$CollectionsTableReferences
    extends BaseReferences<_$AppDatabase, $CollectionsTable, Collection> {
  $$CollectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FontCollectionsTable, List<FontCollection>>
  _fontCollectionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fontCollections,
    aliasName: $_aliasNameGenerator(
      db.collections.id,
      db.fontCollections.collectionId,
    ),
  );

  $$FontCollectionsTableProcessedTableManager get fontCollectionsRefs {
    final manager = $$FontCollectionsTableTableManager(
      $_db,
      $_db.fontCollections,
    ).filter((f) => f.collectionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _fontCollectionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CollectionsTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableFilterComposer({
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

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> fontCollectionsRefs(
    Expression<bool> Function($$FontCollectionsTableFilterComposer f) f,
  ) {
    final $$FontCollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fontCollections,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FontCollectionsTableFilterComposer(
            $db: $db,
            $table: $db.fontCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CollectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableOrderingComposer({
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

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CollectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableAnnotationComposer({
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

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  Expression<T> fontCollectionsRefs<T extends Object>(
    Expression<T> Function($$FontCollectionsTableAnnotationComposer a) f,
  ) {
    final $$FontCollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fontCollections,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FontCollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.fontCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CollectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectionsTable,
          Collection,
          $$CollectionsTableFilterComposer,
          $$CollectionsTableOrderingComposer,
          $$CollectionsTableAnnotationComposer,
          $$CollectionsTableCreateCompanionBuilder,
          $$CollectionsTableUpdateCompanionBuilder,
          (Collection, $$CollectionsTableReferences),
          Collection,
          PrefetchHooks Function({bool fontCollectionsRefs})
        > {
  $$CollectionsTableTableManager(_$AppDatabase db, $CollectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> color = const Value.absent(),
              }) => CollectionsCompanion(id: id, name: name, color: color),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int?> color = const Value.absent(),
              }) =>
                  CollectionsCompanion.insert(id: id, name: name, color: color),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CollectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({fontCollectionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (fontCollectionsRefs) db.fontCollections,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (fontCollectionsRefs)
                    await $_getPrefetchedData<
                      Collection,
                      $CollectionsTable,
                      FontCollection
                    >(
                      currentTable: table,
                      referencedTable: $$CollectionsTableReferences
                          ._fontCollectionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CollectionsTableReferences(
                            db,
                            table,
                            p0,
                          ).fontCollectionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.collectionId == item.id,
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

typedef $$CollectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectionsTable,
      Collection,
      $$CollectionsTableFilterComposer,
      $$CollectionsTableOrderingComposer,
      $$CollectionsTableAnnotationComposer,
      $$CollectionsTableCreateCompanionBuilder,
      $$CollectionsTableUpdateCompanionBuilder,
      (Collection, $$CollectionsTableReferences),
      Collection,
      PrefetchHooks Function({bool fontCollectionsRefs})
    >;
typedef $$FontCollectionsTableCreateCompanionBuilder =
    FontCollectionsCompanion Function({
      required String fontId,
      required int collectionId,
      Value<int> rowid,
    });
typedef $$FontCollectionsTableUpdateCompanionBuilder =
    FontCollectionsCompanion Function({
      Value<String> fontId,
      Value<int> collectionId,
      Value<int> rowid,
    });

final class $$FontCollectionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $FontCollectionsTable, FontCollection> {
  $$FontCollectionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FontsTable _fontIdTable(_$AppDatabase db) => db.fonts.createAlias(
    $_aliasNameGenerator(db.fontCollections.fontId, db.fonts.id),
  );

  $$FontsTableProcessedTableManager get fontId {
    final $_column = $_itemColumn<String>('font_id')!;

    final manager = $$FontsTableTableManager(
      $_db,
      $_db.fonts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fontIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CollectionsTable _collectionIdTable(_$AppDatabase db) =>
      db.collections.createAlias(
        $_aliasNameGenerator(
          db.fontCollections.collectionId,
          db.collections.id,
        ),
      );

  $$CollectionsTableProcessedTableManager get collectionId {
    final $_column = $_itemColumn<int>('collection_id')!;

    final manager = $$CollectionsTableTableManager(
      $_db,
      $_db.collections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_collectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FontCollectionsTableFilterComposer
    extends Composer<_$AppDatabase, $FontCollectionsTable> {
  $$FontCollectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FontsTableFilterComposer get fontId {
    final $$FontsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fontId,
      referencedTable: $db.fonts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FontsTableFilterComposer(
            $db: $db,
            $table: $db.fonts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CollectionsTableFilterComposer get collectionId {
    final $$CollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableFilterComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FontCollectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FontCollectionsTable> {
  $$FontCollectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FontsTableOrderingComposer get fontId {
    final $$FontsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fontId,
      referencedTable: $db.fonts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FontsTableOrderingComposer(
            $db: $db,
            $table: $db.fonts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CollectionsTableOrderingComposer get collectionId {
    final $$CollectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableOrderingComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FontCollectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FontCollectionsTable> {
  $$FontCollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FontsTableAnnotationComposer get fontId {
    final $$FontsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fontId,
      referencedTable: $db.fonts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FontsTableAnnotationComposer(
            $db: $db,
            $table: $db.fonts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CollectionsTableAnnotationComposer get collectionId {
    final $$CollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FontCollectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FontCollectionsTable,
          FontCollection,
          $$FontCollectionsTableFilterComposer,
          $$FontCollectionsTableOrderingComposer,
          $$FontCollectionsTableAnnotationComposer,
          $$FontCollectionsTableCreateCompanionBuilder,
          $$FontCollectionsTableUpdateCompanionBuilder,
          (FontCollection, $$FontCollectionsTableReferences),
          FontCollection,
          PrefetchHooks Function({bool fontId, bool collectionId})
        > {
  $$FontCollectionsTableTableManager(
    _$AppDatabase db,
    $FontCollectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FontCollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FontCollectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FontCollectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> fontId = const Value.absent(),
                Value<int> collectionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FontCollectionsCompanion(
                fontId: fontId,
                collectionId: collectionId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String fontId,
                required int collectionId,
                Value<int> rowid = const Value.absent(),
              }) => FontCollectionsCompanion.insert(
                fontId: fontId,
                collectionId: collectionId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FontCollectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({fontId = false, collectionId = false}) {
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
                    if (fontId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.fontId,
                                referencedTable:
                                    $$FontCollectionsTableReferences
                                        ._fontIdTable(db),
                                referencedColumn:
                                    $$FontCollectionsTableReferences
                                        ._fontIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (collectionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.collectionId,
                                referencedTable:
                                    $$FontCollectionsTableReferences
                                        ._collectionIdTable(db),
                                referencedColumn:
                                    $$FontCollectionsTableReferences
                                        ._collectionIdTable(db)
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

typedef $$FontCollectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FontCollectionsTable,
      FontCollection,
      $$FontCollectionsTableFilterComposer,
      $$FontCollectionsTableOrderingComposer,
      $$FontCollectionsTableAnnotationComposer,
      $$FontCollectionsTableCreateCompanionBuilder,
      $$FontCollectionsTableUpdateCompanionBuilder,
      (FontCollection, $$FontCollectionsTableReferences),
      FontCollection,
      PrefetchHooks Function({bool fontId, bool collectionId})
    >;
typedef $$SyncLogsTableCreateCompanionBuilder =
    SyncLogsCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      required String deviceName,
      required String action,
      Value<String?> details,
    });
typedef $$SyncLogsTableUpdateCompanionBuilder =
    SyncLogsCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<String> deviceName,
      Value<String> action,
      Value<String?> details,
    });

class $$SyncLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncLogsTable> {
  $$SyncLogsTableFilterComposer({
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

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncLogsTable> {
  $$SyncLogsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncLogsTable> {
  $$SyncLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);
}

class $$SyncLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncLogsTable,
          SyncLog,
          $$SyncLogsTableFilterComposer,
          $$SyncLogsTableOrderingComposer,
          $$SyncLogsTableAnnotationComposer,
          $$SyncLogsTableCreateCompanionBuilder,
          $$SyncLogsTableUpdateCompanionBuilder,
          (SyncLog, BaseReferences<_$AppDatabase, $SyncLogsTable, SyncLog>),
          SyncLog,
          PrefetchHooks Function()
        > {
  $$SyncLogsTableTableManager(_$AppDatabase db, $SyncLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> deviceName = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String?> details = const Value.absent(),
              }) => SyncLogsCompanion(
                id: id,
                timestamp: timestamp,
                deviceName: deviceName,
                action: action,
                details: details,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                required String deviceName,
                required String action,
                Value<String?> details = const Value.absent(),
              }) => SyncLogsCompanion.insert(
                id: id,
                timestamp: timestamp,
                deviceName: deviceName,
                action: action,
                details: details,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncLogsTable,
      SyncLog,
      $$SyncLogsTableFilterComposer,
      $$SyncLogsTableOrderingComposer,
      $$SyncLogsTableAnnotationComposer,
      $$SyncLogsTableCreateCompanionBuilder,
      $$SyncLogsTableUpdateCompanionBuilder,
      (SyncLog, BaseReferences<_$AppDatabase, $SyncLogsTable, SyncLog>),
      SyncLog,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FontsTableTableManager get fonts =>
      $$FontsTableTableManager(_db, _db.fonts);
  $$CollectionsTableTableManager get collections =>
      $$CollectionsTableTableManager(_db, _db.collections);
  $$FontCollectionsTableTableManager get fontCollections =>
      $$FontCollectionsTableTableManager(_db, _db.fontCollections);
  $$SyncLogsTableTableManager get syncLogs =>
      $$SyncLogsTableTableManager(_db, _db.syncLogs);
}
