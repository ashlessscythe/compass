// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocationsTable extends Locations
    with TableInfo<$LocationsTable, LocationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _parentLocationIdMeta = const VerificationMeta(
    'parentLocationId',
  );
  @override
  late final GeneratedColumn<String> parentLocationId = GeneratedColumn<String>(
    'parent_location_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nfcTagIdMeta = const VerificationMeta(
    'nfcTagId',
  );
  @override
  late final GeneratedColumn<String> nfcTagId = GeneratedColumn<String>(
    'nfc_tag_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
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
    name,
    parentLocationId,
    path,
    nfcTagId,
    notes,
    metadataJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_location_id')) {
      context.handle(
        _parentLocationIdMeta,
        parentLocationId.isAcceptableOrUnknown(
          data['parent_location_id']!,
          _parentLocationIdMeta,
        ),
      );
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    }
    if (data.containsKey('nfc_tag_id')) {
      context.handle(
        _nfcTagIdMeta,
        nfcTagId.isAcceptableOrUnknown(data['nfc_tag_id']!, _nfcTagIdMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
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
  LocationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentLocationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_location_id'],
      ),
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      ),
      nfcTagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nfc_tag_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocationsTable createAlias(String alias) {
    return $LocationsTable(attachedDatabase, alias);
  }
}

class LocationRow extends DataClass implements Insertable<LocationRow> {
  final String id;
  final String name;
  final String? parentLocationId;
  final String? path;
  final String? nfcTagId;
  final String? notes;
  final String metadataJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LocationRow({
    required this.id,
    required this.name,
    this.parentLocationId,
    this.path,
    this.nfcTagId,
    this.notes,
    required this.metadataJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentLocationId != null) {
      map['parent_location_id'] = Variable<String>(parentLocationId);
    }
    if (!nullToAbsent || path != null) {
      map['path'] = Variable<String>(path);
    }
    if (!nullToAbsent || nfcTagId != null) {
      map['nfc_tag_id'] = Variable<String>(nfcTagId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['metadata_json'] = Variable<String>(metadataJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocationsCompanion toCompanion(bool nullToAbsent) {
    return LocationsCompanion(
      id: Value(id),
      name: Value(name),
      parentLocationId: parentLocationId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentLocationId),
      path: path == null && nullToAbsent ? const Value.absent() : Value(path),
      nfcTagId: nfcTagId == null && nullToAbsent
          ? const Value.absent()
          : Value(nfcTagId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      metadataJson: Value(metadataJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocationRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentLocationId: serializer.fromJson<String?>(json['parentLocationId']),
      path: serializer.fromJson<String?>(json['path']),
      nfcTagId: serializer.fromJson<String?>(json['nfcTagId']),
      notes: serializer.fromJson<String?>(json['notes']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentLocationId': serializer.toJson<String?>(parentLocationId),
      'path': serializer.toJson<String?>(path),
      'nfcTagId': serializer.toJson<String?>(nfcTagId),
      'notes': serializer.toJson<String?>(notes),
      'metadataJson': serializer.toJson<String>(metadataJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocationRow copyWith({
    String? id,
    String? name,
    Value<String?> parentLocationId = const Value.absent(),
    Value<String?> path = const Value.absent(),
    Value<String?> nfcTagId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? metadataJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LocationRow(
    id: id ?? this.id,
    name: name ?? this.name,
    parentLocationId: parentLocationId.present
        ? parentLocationId.value
        : this.parentLocationId,
    path: path.present ? path.value : this.path,
    nfcTagId: nfcTagId.present ? nfcTagId.value : this.nfcTagId,
    notes: notes.present ? notes.value : this.notes,
    metadataJson: metadataJson ?? this.metadataJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocationRow copyWithCompanion(LocationsCompanion data) {
    return LocationRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentLocationId: data.parentLocationId.present
          ? data.parentLocationId.value
          : this.parentLocationId,
      path: data.path.present ? data.path.value : this.path,
      nfcTagId: data.nfcTagId.present ? data.nfcTagId.value : this.nfcTagId,
      notes: data.notes.present ? data.notes.value : this.notes,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocationRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentLocationId: $parentLocationId, ')
          ..write('path: $path, ')
          ..write('nfcTagId: $nfcTagId, ')
          ..write('notes: $notes, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    parentLocationId,
    path,
    nfcTagId,
    notes,
    metadataJson,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocationRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentLocationId == this.parentLocationId &&
          other.path == this.path &&
          other.nfcTagId == this.nfcTagId &&
          other.notes == this.notes &&
          other.metadataJson == this.metadataJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocationsCompanion extends UpdateCompanion<LocationRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentLocationId;
  final Value<String?> path;
  final Value<String?> nfcTagId;
  final Value<String?> notes;
  final Value<String> metadataJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentLocationId = const Value.absent(),
    this.path = const Value.absent(),
    this.nfcTagId = const Value.absent(),
    this.notes = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocationsCompanion.insert({
    required String id,
    required String name,
    this.parentLocationId = const Value.absent(),
    this.path = const Value.absent(),
    this.nfcTagId = const Value.absent(),
    this.notes = const Value.absent(),
    this.metadataJson = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocationRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentLocationId,
    Expression<String>? path,
    Expression<String>? nfcTagId,
    Expression<String>? notes,
    Expression<String>? metadataJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentLocationId != null) 'parent_location_id': parentLocationId,
      if (path != null) 'path': path,
      if (nfcTagId != null) 'nfc_tag_id': nfcTagId,
      if (notes != null) 'notes': notes,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocationsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? parentLocationId,
    Value<String?>? path,
    Value<String?>? nfcTagId,
    Value<String?>? notes,
    Value<String>? metadataJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentLocationId: parentLocationId ?? this.parentLocationId,
      path: path ?? this.path,
      nfcTagId: nfcTagId ?? this.nfcTagId,
      notes: notes ?? this.notes,
      metadataJson: metadataJson ?? this.metadataJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentLocationId.present) {
      map['parent_location_id'] = Variable<String>(parentLocationId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (nfcTagId.present) {
      map['nfc_tag_id'] = Variable<String>(nfcTagId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentLocationId: $parentLocationId, ')
          ..write('path: $path, ')
          ..write('nfcTagId: $nfcTagId, ')
          ..write('notes: $notes, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContainersTable extends Containers
    with TableInfo<$ContainersTable, ContainerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContainersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _parentContainerIdMeta = const VerificationMeta(
    'parentContainerId',
  );
  @override
  late final GeneratedColumn<String> parentContainerId =
      GeneratedColumn<String>(
        'parent_container_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nfcTagIdMeta = const VerificationMeta(
    'nfcTagId',
  );
  @override
  late final GeneratedColumn<String> nfcTagId = GeneratedColumn<String>(
    'nfc_tag_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
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
    name,
    parentContainerId,
    locationId,
    nfcTagId,
    notes,
    metadataJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'containers';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContainerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_container_id')) {
      context.handle(
        _parentContainerIdMeta,
        parentContainerId.isAcceptableOrUnknown(
          data['parent_container_id']!,
          _parentContainerIdMeta,
        ),
      );
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    }
    if (data.containsKey('nfc_tag_id')) {
      context.handle(
        _nfcTagIdMeta,
        nfcTagId.isAcceptableOrUnknown(data['nfc_tag_id']!, _nfcTagIdMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
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
  ContainerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContainerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentContainerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_container_id'],
      ),
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      ),
      nfcTagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nfc_tag_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ContainersTable createAlias(String alias) {
    return $ContainersTable(attachedDatabase, alias);
  }
}

class ContainerRow extends DataClass implements Insertable<ContainerRow> {
  final String id;
  final String name;
  final String? parentContainerId;
  final String? locationId;
  final String? nfcTagId;
  final String? notes;
  final String metadataJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ContainerRow({
    required this.id,
    required this.name,
    this.parentContainerId,
    this.locationId,
    this.nfcTagId,
    this.notes,
    required this.metadataJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentContainerId != null) {
      map['parent_container_id'] = Variable<String>(parentContainerId);
    }
    if (!nullToAbsent || locationId != null) {
      map['location_id'] = Variable<String>(locationId);
    }
    if (!nullToAbsent || nfcTagId != null) {
      map['nfc_tag_id'] = Variable<String>(nfcTagId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['metadata_json'] = Variable<String>(metadataJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ContainersCompanion toCompanion(bool nullToAbsent) {
    return ContainersCompanion(
      id: Value(id),
      name: Value(name),
      parentContainerId: parentContainerId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentContainerId),
      locationId: locationId == null && nullToAbsent
          ? const Value.absent()
          : Value(locationId),
      nfcTagId: nfcTagId == null && nullToAbsent
          ? const Value.absent()
          : Value(nfcTagId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      metadataJson: Value(metadataJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ContainerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContainerRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentContainerId: serializer.fromJson<String?>(
        json['parentContainerId'],
      ),
      locationId: serializer.fromJson<String?>(json['locationId']),
      nfcTagId: serializer.fromJson<String?>(json['nfcTagId']),
      notes: serializer.fromJson<String?>(json['notes']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentContainerId': serializer.toJson<String?>(parentContainerId),
      'locationId': serializer.toJson<String?>(locationId),
      'nfcTagId': serializer.toJson<String?>(nfcTagId),
      'notes': serializer.toJson<String?>(notes),
      'metadataJson': serializer.toJson<String>(metadataJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ContainerRow copyWith({
    String? id,
    String? name,
    Value<String?> parentContainerId = const Value.absent(),
    Value<String?> locationId = const Value.absent(),
    Value<String?> nfcTagId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? metadataJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ContainerRow(
    id: id ?? this.id,
    name: name ?? this.name,
    parentContainerId: parentContainerId.present
        ? parentContainerId.value
        : this.parentContainerId,
    locationId: locationId.present ? locationId.value : this.locationId,
    nfcTagId: nfcTagId.present ? nfcTagId.value : this.nfcTagId,
    notes: notes.present ? notes.value : this.notes,
    metadataJson: metadataJson ?? this.metadataJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ContainerRow copyWithCompanion(ContainersCompanion data) {
    return ContainerRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentContainerId: data.parentContainerId.present
          ? data.parentContainerId.value
          : this.parentContainerId,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      nfcTagId: data.nfcTagId.present ? data.nfcTagId.value : this.nfcTagId,
      notes: data.notes.present ? data.notes.value : this.notes,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContainerRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentContainerId: $parentContainerId, ')
          ..write('locationId: $locationId, ')
          ..write('nfcTagId: $nfcTagId, ')
          ..write('notes: $notes, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    parentContainerId,
    locationId,
    nfcTagId,
    notes,
    metadataJson,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContainerRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentContainerId == this.parentContainerId &&
          other.locationId == this.locationId &&
          other.nfcTagId == this.nfcTagId &&
          other.notes == this.notes &&
          other.metadataJson == this.metadataJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ContainersCompanion extends UpdateCompanion<ContainerRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentContainerId;
  final Value<String?> locationId;
  final Value<String?> nfcTagId;
  final Value<String?> notes;
  final Value<String> metadataJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ContainersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentContainerId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.nfcTagId = const Value.absent(),
    this.notes = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContainersCompanion.insert({
    required String id,
    required String name,
    this.parentContainerId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.nfcTagId = const Value.absent(),
    this.notes = const Value.absent(),
    this.metadataJson = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ContainerRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentContainerId,
    Expression<String>? locationId,
    Expression<String>? nfcTagId,
    Expression<String>? notes,
    Expression<String>? metadataJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentContainerId != null) 'parent_container_id': parentContainerId,
      if (locationId != null) 'location_id': locationId,
      if (nfcTagId != null) 'nfc_tag_id': nfcTagId,
      if (notes != null) 'notes': notes,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContainersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? parentContainerId,
    Value<String?>? locationId,
    Value<String?>? nfcTagId,
    Value<String?>? notes,
    Value<String>? metadataJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ContainersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentContainerId: parentContainerId ?? this.parentContainerId,
      locationId: locationId ?? this.locationId,
      nfcTagId: nfcTagId ?? this.nfcTagId,
      notes: notes ?? this.notes,
      metadataJson: metadataJson ?? this.metadataJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentContainerId.present) {
      map['parent_container_id'] = Variable<String>(parentContainerId.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (nfcTagId.present) {
      map['nfc_tag_id'] = Variable<String>(nfcTagId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContainersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentContainerId: $parentContainerId, ')
          ..write('locationId: $locationId, ')
          ..write('nfcTagId: $nfcTagId, ')
          ..write('notes: $notes, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetTypesTable extends AssetTypes
    with TableInfo<$AssetTypesTable, AssetTypeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _moduleIdMeta = const VerificationMeta(
    'moduleId',
  );
  @override
  late final GeneratedColumn<String> moduleId = GeneratedColumn<String>(
    'module_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
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
    name,
    moduleId,
    parentId,
    description,
    metadataJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssetTypeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('module_id')) {
      context.handle(
        _moduleIdMeta,
        moduleId.isAcceptableOrUnknown(data['module_id']!, _moduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleIdMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
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
  AssetTypeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetTypeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      moduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module_id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AssetTypesTable createAlias(String alias) {
    return $AssetTypesTable(attachedDatabase, alias);
  }
}

class AssetTypeRow extends DataClass implements Insertable<AssetTypeRow> {
  final String id;
  final String name;
  final String moduleId;
  final String? parentId;
  final String? description;
  final String metadataJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AssetTypeRow({
    required this.id,
    required this.name,
    required this.moduleId,
    this.parentId,
    this.description,
    required this.metadataJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['module_id'] = Variable<String>(moduleId);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['metadata_json'] = Variable<String>(metadataJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AssetTypesCompanion toCompanion(bool nullToAbsent) {
    return AssetTypesCompanion(
      id: Value(id),
      name: Value(name),
      moduleId: Value(moduleId),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      metadataJson: Value(metadataJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AssetTypeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetTypeRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      moduleId: serializer.fromJson<String>(json['moduleId']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      description: serializer.fromJson<String?>(json['description']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'moduleId': serializer.toJson<String>(moduleId),
      'parentId': serializer.toJson<String?>(parentId),
      'description': serializer.toJson<String?>(description),
      'metadataJson': serializer.toJson<String>(metadataJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AssetTypeRow copyWith({
    String? id,
    String? name,
    String? moduleId,
    Value<String?> parentId = const Value.absent(),
    Value<String?> description = const Value.absent(),
    String? metadataJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AssetTypeRow(
    id: id ?? this.id,
    name: name ?? this.name,
    moduleId: moduleId ?? this.moduleId,
    parentId: parentId.present ? parentId.value : this.parentId,
    description: description.present ? description.value : this.description,
    metadataJson: metadataJson ?? this.metadataJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AssetTypeRow copyWithCompanion(AssetTypesCompanion data) {
    return AssetTypeRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      moduleId: data.moduleId.present ? data.moduleId.value : this.moduleId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      description: data.description.present
          ? data.description.value
          : this.description,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetTypeRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('moduleId: $moduleId, ')
          ..write('parentId: $parentId, ')
          ..write('description: $description, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    moduleId,
    parentId,
    description,
    metadataJson,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetTypeRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.moduleId == this.moduleId &&
          other.parentId == this.parentId &&
          other.description == this.description &&
          other.metadataJson == this.metadataJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AssetTypesCompanion extends UpdateCompanion<AssetTypeRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> moduleId;
  final Value<String?> parentId;
  final Value<String?> description;
  final Value<String> metadataJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AssetTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.moduleId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.description = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetTypesCompanion.insert({
    required String id,
    required String name,
    required String moduleId,
    this.parentId = const Value.absent(),
    this.description = const Value.absent(),
    this.metadataJson = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       moduleId = Value(moduleId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AssetTypeRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? moduleId,
    Expression<String>? parentId,
    Expression<String>? description,
    Expression<String>? metadataJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (moduleId != null) 'module_id': moduleId,
      if (parentId != null) 'parent_id': parentId,
      if (description != null) 'description': description,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetTypesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? moduleId,
    Value<String?>? parentId,
    Value<String?>? description,
    Value<String>? metadataJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AssetTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      moduleId: moduleId ?? this.moduleId,
      parentId: parentId ?? this.parentId,
      description: description ?? this.description,
      metadataJson: metadataJson ?? this.metadataJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (moduleId.present) {
      map['module_id'] = Variable<String>(moduleId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('moduleId: $moduleId, ')
          ..write('parentId: $parentId, ')
          ..write('description: $description, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetsTable extends Assets with TableInfo<$AssetsTable, AssetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _assetTypeIdMeta = const VerificationMeta(
    'assetTypeId',
  );
  @override
  late final GeneratedColumn<String> assetTypeId = GeneratedColumn<String>(
    'asset_type_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _containerIdMeta = const VerificationMeta(
    'containerId',
  );
  @override
  late final GeneratedColumn<String> containerId = GeneratedColumn<String>(
    'container_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
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
    name,
    assetTypeId,
    quantity,
    containerId,
    locationId,
    notes,
    metadataJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('asset_type_id')) {
      context.handle(
        _assetTypeIdMeta,
        assetTypeId.isAcceptableOrUnknown(
          data['asset_type_id']!,
          _assetTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assetTypeIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('container_id')) {
      context.handle(
        _containerIdMeta,
        containerId.isAcceptableOrUnknown(
          data['container_id']!,
          _containerIdMeta,
        ),
      );
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
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
  AssetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      assetTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_type_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      containerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}container_id'],
      ),
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AssetsTable createAlias(String alias) {
    return $AssetsTable(attachedDatabase, alias);
  }
}

class AssetRow extends DataClass implements Insertable<AssetRow> {
  final String id;
  final String name;
  final String assetTypeId;
  final int quantity;
  final String? containerId;
  final String? locationId;
  final String? notes;
  final String metadataJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AssetRow({
    required this.id,
    required this.name,
    required this.assetTypeId,
    required this.quantity,
    this.containerId,
    this.locationId,
    this.notes,
    required this.metadataJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['asset_type_id'] = Variable<String>(assetTypeId);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || containerId != null) {
      map['container_id'] = Variable<String>(containerId);
    }
    if (!nullToAbsent || locationId != null) {
      map['location_id'] = Variable<String>(locationId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['metadata_json'] = Variable<String>(metadataJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AssetsCompanion toCompanion(bool nullToAbsent) {
    return AssetsCompanion(
      id: Value(id),
      name: Value(name),
      assetTypeId: Value(assetTypeId),
      quantity: Value(quantity),
      containerId: containerId == null && nullToAbsent
          ? const Value.absent()
          : Value(containerId),
      locationId: locationId == null && nullToAbsent
          ? const Value.absent()
          : Value(locationId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      metadataJson: Value(metadataJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AssetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      assetTypeId: serializer.fromJson<String>(json['assetTypeId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      containerId: serializer.fromJson<String?>(json['containerId']),
      locationId: serializer.fromJson<String?>(json['locationId']),
      notes: serializer.fromJson<String?>(json['notes']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'assetTypeId': serializer.toJson<String>(assetTypeId),
      'quantity': serializer.toJson<int>(quantity),
      'containerId': serializer.toJson<String?>(containerId),
      'locationId': serializer.toJson<String?>(locationId),
      'notes': serializer.toJson<String?>(notes),
      'metadataJson': serializer.toJson<String>(metadataJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AssetRow copyWith({
    String? id,
    String? name,
    String? assetTypeId,
    int? quantity,
    Value<String?> containerId = const Value.absent(),
    Value<String?> locationId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? metadataJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AssetRow(
    id: id ?? this.id,
    name: name ?? this.name,
    assetTypeId: assetTypeId ?? this.assetTypeId,
    quantity: quantity ?? this.quantity,
    containerId: containerId.present ? containerId.value : this.containerId,
    locationId: locationId.present ? locationId.value : this.locationId,
    notes: notes.present ? notes.value : this.notes,
    metadataJson: metadataJson ?? this.metadataJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AssetRow copyWithCompanion(AssetsCompanion data) {
    return AssetRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      assetTypeId: data.assetTypeId.present
          ? data.assetTypeId.value
          : this.assetTypeId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      containerId: data.containerId.present
          ? data.containerId.value
          : this.containerId,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      notes: data.notes.present ? data.notes.value : this.notes,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('assetTypeId: $assetTypeId, ')
          ..write('quantity: $quantity, ')
          ..write('containerId: $containerId, ')
          ..write('locationId: $locationId, ')
          ..write('notes: $notes, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    assetTypeId,
    quantity,
    containerId,
    locationId,
    notes,
    metadataJson,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.assetTypeId == this.assetTypeId &&
          other.quantity == this.quantity &&
          other.containerId == this.containerId &&
          other.locationId == this.locationId &&
          other.notes == this.notes &&
          other.metadataJson == this.metadataJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AssetsCompanion extends UpdateCompanion<AssetRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> assetTypeId;
  final Value<int> quantity;
  final Value<String?> containerId;
  final Value<String?> locationId;
  final Value<String?> notes;
  final Value<String> metadataJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AssetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.assetTypeId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.containerId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.notes = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetsCompanion.insert({
    required String id,
    required String name,
    required String assetTypeId,
    this.quantity = const Value.absent(),
    this.containerId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.notes = const Value.absent(),
    this.metadataJson = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       assetTypeId = Value(assetTypeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AssetRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? assetTypeId,
    Expression<int>? quantity,
    Expression<String>? containerId,
    Expression<String>? locationId,
    Expression<String>? notes,
    Expression<String>? metadataJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (assetTypeId != null) 'asset_type_id': assetTypeId,
      if (quantity != null) 'quantity': quantity,
      if (containerId != null) 'container_id': containerId,
      if (locationId != null) 'location_id': locationId,
      if (notes != null) 'notes': notes,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? assetTypeId,
    Value<int>? quantity,
    Value<String?>? containerId,
    Value<String?>? locationId,
    Value<String?>? notes,
    Value<String>? metadataJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AssetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      assetTypeId: assetTypeId ?? this.assetTypeId,
      quantity: quantity ?? this.quantity,
      containerId: containerId ?? this.containerId,
      locationId: locationId ?? this.locationId,
      notes: notes ?? this.notes,
      metadataJson: metadataJson ?? this.metadataJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (assetTypeId.present) {
      map['asset_type_id'] = Variable<String>(assetTypeId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (containerId.present) {
      map['container_id'] = Variable<String>(containerId.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('assetTypeId: $assetTypeId, ')
          ..write('quantity: $quantity, ')
          ..write('containerId: $containerId, ')
          ..write('locationId: $locationId, ')
          ..write('notes: $notes, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardPrintingsTable extends CardPrintings
    with TableInfo<$CardPrintingsTable, CardPrintingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardPrintingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _oracleIdMeta = const VerificationMeta(
    'oracleId',
  );
  @override
  late final GeneratedColumn<String> oracleId = GeneratedColumn<String>(
    'oracle_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _nameNormalizedMeta = const VerificationMeta(
    'nameNormalized',
  );
  @override
  late final GeneratedColumn<String> nameNormalized = GeneratedColumn<String>(
    'name_normalized',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setCodeMeta = const VerificationMeta(
    'setCode',
  );
  @override
  late final GeneratedColumn<String> setCode = GeneratedColumn<String>(
    'set_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _collectorNumberMeta = const VerificationMeta(
    'collectorNumber',
  );
  @override
  late final GeneratedColumn<String> collectorNumber = GeneratedColumn<String>(
    'collector_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _layoutMeta = const VerificationMeta('layout');
  @override
  late final GeneratedColumn<String> layout = GeneratedColumn<String>(
    'layout',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeLineMeta = const VerificationMeta(
    'typeLine',
  );
  @override
  late final GeneratedColumn<String> typeLine = GeneratedColumn<String>(
    'type_line',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _manaCostMeta = const VerificationMeta(
    'manaCost',
  );
  @override
  late final GeneratedColumn<String> manaCost = GeneratedColumn<String>(
    'mana_cost',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _oracleTextMeta = const VerificationMeta(
    'oracleText',
  );
  @override
  late final GeneratedColumn<String> oracleText = GeneratedColumn<String>(
    'oracle_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorsJsonMeta = const VerificationMeta(
    'colorsJson',
  );
  @override
  late final GeneratedColumn<String> colorsJson = GeneratedColumn<String>(
    'colors_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorIdentityJsonMeta = const VerificationMeta(
    'colorIdentityJson',
  );
  @override
  late final GeneratedColumn<String> colorIdentityJson =
      GeneratedColumn<String>(
        'color_identity_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _cmcMeta = const VerificationMeta('cmc');
  @override
  late final GeneratedColumn<double> cmc = GeneratedColumn<double>(
    'cmc',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rarityMeta = const VerificationMeta('rarity');
  @override
  late final GeneratedColumn<String> rarity = GeneratedColumn<String>(
    'rarity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
    'artist',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _setNameMeta = const VerificationMeta(
    'setName',
  );
  @override
  late final GeneratedColumn<String> setName = GeneratedColumn<String>(
    'set_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _powerMeta = const VerificationMeta('power');
  @override
  late final GeneratedColumn<String> power = GeneratedColumn<String>(
    'power',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toughnessMeta = const VerificationMeta(
    'toughness',
  );
  @override
  late final GeneratedColumn<String> toughness = GeneratedColumn<String>(
    'toughness',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loyaltyMeta = const VerificationMeta(
    'loyalty',
  );
  @override
  late final GeneratedColumn<String> loyalty = GeneratedColumn<String>(
    'loyalty',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defenseMeta = const VerificationMeta(
    'defense',
  );
  @override
  late final GeneratedColumn<String> defense = GeneratedColumn<String>(
    'defense',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageSmallUrlMeta = const VerificationMeta(
    'imageSmallUrl',
  );
  @override
  late final GeneratedColumn<String> imageSmallUrl = GeneratedColumn<String>(
    'image_small_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageNormalUrlMeta = const VerificationMeta(
    'imageNormalUrl',
  );
  @override
  late final GeneratedColumn<String> imageNormalUrl = GeneratedColumn<String>(
    'image_normal_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _facesJsonMeta = const VerificationMeta(
    'facesJson',
  );
  @override
  late final GeneratedColumn<String> facesJson = GeneratedColumn<String>(
    'faces_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _detailsJsonMeta = const VerificationMeta(
    'detailsJson',
  );
  @override
  late final GeneratedColumn<String> detailsJson = GeneratedColumn<String>(
    'details_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    oracleId,
    name,
    nameNormalized,
    setCode,
    collectorNumber,
    layout,
    typeLine,
    manaCost,
    oracleText,
    colorsJson,
    colorIdentityJson,
    cmc,
    rarity,
    artist,
    setName,
    power,
    toughness,
    loyalty,
    defense,
    imageSmallUrl,
    imageNormalUrl,
    facesJson,
    detailsJson,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_printings';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardPrintingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('oracle_id')) {
      context.handle(
        _oracleIdMeta,
        oracleId.isAcceptableOrUnknown(data['oracle_id']!, _oracleIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_normalized')) {
      context.handle(
        _nameNormalizedMeta,
        nameNormalized.isAcceptableOrUnknown(
          data['name_normalized']!,
          _nameNormalizedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameNormalizedMeta);
    }
    if (data.containsKey('set_code')) {
      context.handle(
        _setCodeMeta,
        setCode.isAcceptableOrUnknown(data['set_code']!, _setCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_setCodeMeta);
    }
    if (data.containsKey('collector_number')) {
      context.handle(
        _collectorNumberMeta,
        collectorNumber.isAcceptableOrUnknown(
          data['collector_number']!,
          _collectorNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectorNumberMeta);
    }
    if (data.containsKey('layout')) {
      context.handle(
        _layoutMeta,
        layout.isAcceptableOrUnknown(data['layout']!, _layoutMeta),
      );
    }
    if (data.containsKey('type_line')) {
      context.handle(
        _typeLineMeta,
        typeLine.isAcceptableOrUnknown(data['type_line']!, _typeLineMeta),
      );
    }
    if (data.containsKey('mana_cost')) {
      context.handle(
        _manaCostMeta,
        manaCost.isAcceptableOrUnknown(data['mana_cost']!, _manaCostMeta),
      );
    }
    if (data.containsKey('oracle_text')) {
      context.handle(
        _oracleTextMeta,
        oracleText.isAcceptableOrUnknown(data['oracle_text']!, _oracleTextMeta),
      );
    }
    if (data.containsKey('colors_json')) {
      context.handle(
        _colorsJsonMeta,
        colorsJson.isAcceptableOrUnknown(data['colors_json']!, _colorsJsonMeta),
      );
    }
    if (data.containsKey('color_identity_json')) {
      context.handle(
        _colorIdentityJsonMeta,
        colorIdentityJson.isAcceptableOrUnknown(
          data['color_identity_json']!,
          _colorIdentityJsonMeta,
        ),
      );
    }
    if (data.containsKey('cmc')) {
      context.handle(
        _cmcMeta,
        cmc.isAcceptableOrUnknown(data['cmc']!, _cmcMeta),
      );
    }
    if (data.containsKey('rarity')) {
      context.handle(
        _rarityMeta,
        rarity.isAcceptableOrUnknown(data['rarity']!, _rarityMeta),
      );
    }
    if (data.containsKey('artist')) {
      context.handle(
        _artistMeta,
        artist.isAcceptableOrUnknown(data['artist']!, _artistMeta),
      );
    }
    if (data.containsKey('set_name')) {
      context.handle(
        _setNameMeta,
        setName.isAcceptableOrUnknown(data['set_name']!, _setNameMeta),
      );
    }
    if (data.containsKey('power')) {
      context.handle(
        _powerMeta,
        power.isAcceptableOrUnknown(data['power']!, _powerMeta),
      );
    }
    if (data.containsKey('toughness')) {
      context.handle(
        _toughnessMeta,
        toughness.isAcceptableOrUnknown(data['toughness']!, _toughnessMeta),
      );
    }
    if (data.containsKey('loyalty')) {
      context.handle(
        _loyaltyMeta,
        loyalty.isAcceptableOrUnknown(data['loyalty']!, _loyaltyMeta),
      );
    }
    if (data.containsKey('defense')) {
      context.handle(
        _defenseMeta,
        defense.isAcceptableOrUnknown(data['defense']!, _defenseMeta),
      );
    }
    if (data.containsKey('image_small_url')) {
      context.handle(
        _imageSmallUrlMeta,
        imageSmallUrl.isAcceptableOrUnknown(
          data['image_small_url']!,
          _imageSmallUrlMeta,
        ),
      );
    }
    if (data.containsKey('image_normal_url')) {
      context.handle(
        _imageNormalUrlMeta,
        imageNormalUrl.isAcceptableOrUnknown(
          data['image_normal_url']!,
          _imageNormalUrlMeta,
        ),
      );
    }
    if (data.containsKey('faces_json')) {
      context.handle(
        _facesJsonMeta,
        facesJson.isAcceptableOrUnknown(data['faces_json']!, _facesJsonMeta),
      );
    }
    if (data.containsKey('details_json')) {
      context.handle(
        _detailsJsonMeta,
        detailsJson.isAcceptableOrUnknown(
          data['details_json']!,
          _detailsJsonMeta,
        ),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardPrintingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardPrintingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      oracleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oracle_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameNormalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_normalized'],
      )!,
      setCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_code'],
      )!,
      collectorNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collector_number'],
      )!,
      layout: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}layout'],
      ),
      typeLine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_line'],
      ),
      manaCost: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mana_cost'],
      ),
      oracleText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oracle_text'],
      ),
      colorsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}colors_json'],
      ),
      colorIdentityJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_identity_json'],
      ),
      cmc: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cmc'],
      ),
      rarity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rarity'],
      ),
      artist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist'],
      ),
      setName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_name'],
      ),
      power: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}power'],
      ),
      toughness: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toughness'],
      ),
      loyalty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}loyalty'],
      ),
      defense: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}defense'],
      ),
      imageSmallUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_small_url'],
      ),
      imageNormalUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_normal_url'],
      ),
      facesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}faces_json'],
      )!,
      detailsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details_json'],
      ),
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $CardPrintingsTable createAlias(String alias) {
    return $CardPrintingsTable(attachedDatabase, alias);
  }
}

class CardPrintingRow extends DataClass implements Insertable<CardPrintingRow> {
  final String id;
  final String? oracleId;
  final String name;
  final String nameNormalized;
  final String setCode;
  final String collectorNumber;
  final String? layout;
  final String? typeLine;
  final String? manaCost;
  final String? oracleText;
  final String? colorsJson;
  final String? colorIdentityJson;
  final double? cmc;
  final String? rarity;
  final String? artist;
  final String? setName;
  final String? power;
  final String? toughness;
  final String? loyalty;
  final String? defense;
  final String? imageSmallUrl;
  final String? imageNormalUrl;
  final String facesJson;
  final String? detailsJson;
  final DateTime fetchedAt;
  const CardPrintingRow({
    required this.id,
    this.oracleId,
    required this.name,
    required this.nameNormalized,
    required this.setCode,
    required this.collectorNumber,
    this.layout,
    this.typeLine,
    this.manaCost,
    this.oracleText,
    this.colorsJson,
    this.colorIdentityJson,
    this.cmc,
    this.rarity,
    this.artist,
    this.setName,
    this.power,
    this.toughness,
    this.loyalty,
    this.defense,
    this.imageSmallUrl,
    this.imageNormalUrl,
    required this.facesJson,
    this.detailsJson,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || oracleId != null) {
      map['oracle_id'] = Variable<String>(oracleId);
    }
    map['name'] = Variable<String>(name);
    map['name_normalized'] = Variable<String>(nameNormalized);
    map['set_code'] = Variable<String>(setCode);
    map['collector_number'] = Variable<String>(collectorNumber);
    if (!nullToAbsent || layout != null) {
      map['layout'] = Variable<String>(layout);
    }
    if (!nullToAbsent || typeLine != null) {
      map['type_line'] = Variable<String>(typeLine);
    }
    if (!nullToAbsent || manaCost != null) {
      map['mana_cost'] = Variable<String>(manaCost);
    }
    if (!nullToAbsent || oracleText != null) {
      map['oracle_text'] = Variable<String>(oracleText);
    }
    if (!nullToAbsent || colorsJson != null) {
      map['colors_json'] = Variable<String>(colorsJson);
    }
    if (!nullToAbsent || colorIdentityJson != null) {
      map['color_identity_json'] = Variable<String>(colorIdentityJson);
    }
    if (!nullToAbsent || cmc != null) {
      map['cmc'] = Variable<double>(cmc);
    }
    if (!nullToAbsent || rarity != null) {
      map['rarity'] = Variable<String>(rarity);
    }
    if (!nullToAbsent || artist != null) {
      map['artist'] = Variable<String>(artist);
    }
    if (!nullToAbsent || setName != null) {
      map['set_name'] = Variable<String>(setName);
    }
    if (!nullToAbsent || power != null) {
      map['power'] = Variable<String>(power);
    }
    if (!nullToAbsent || toughness != null) {
      map['toughness'] = Variable<String>(toughness);
    }
    if (!nullToAbsent || loyalty != null) {
      map['loyalty'] = Variable<String>(loyalty);
    }
    if (!nullToAbsent || defense != null) {
      map['defense'] = Variable<String>(defense);
    }
    if (!nullToAbsent || imageSmallUrl != null) {
      map['image_small_url'] = Variable<String>(imageSmallUrl);
    }
    if (!nullToAbsent || imageNormalUrl != null) {
      map['image_normal_url'] = Variable<String>(imageNormalUrl);
    }
    map['faces_json'] = Variable<String>(facesJson);
    if (!nullToAbsent || detailsJson != null) {
      map['details_json'] = Variable<String>(detailsJson);
    }
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  CardPrintingsCompanion toCompanion(bool nullToAbsent) {
    return CardPrintingsCompanion(
      id: Value(id),
      oracleId: oracleId == null && nullToAbsent
          ? const Value.absent()
          : Value(oracleId),
      name: Value(name),
      nameNormalized: Value(nameNormalized),
      setCode: Value(setCode),
      collectorNumber: Value(collectorNumber),
      layout: layout == null && nullToAbsent
          ? const Value.absent()
          : Value(layout),
      typeLine: typeLine == null && nullToAbsent
          ? const Value.absent()
          : Value(typeLine),
      manaCost: manaCost == null && nullToAbsent
          ? const Value.absent()
          : Value(manaCost),
      oracleText: oracleText == null && nullToAbsent
          ? const Value.absent()
          : Value(oracleText),
      colorsJson: colorsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(colorsJson),
      colorIdentityJson: colorIdentityJson == null && nullToAbsent
          ? const Value.absent()
          : Value(colorIdentityJson),
      cmc: cmc == null && nullToAbsent ? const Value.absent() : Value(cmc),
      rarity: rarity == null && nullToAbsent
          ? const Value.absent()
          : Value(rarity),
      artist: artist == null && nullToAbsent
          ? const Value.absent()
          : Value(artist),
      setName: setName == null && nullToAbsent
          ? const Value.absent()
          : Value(setName),
      power: power == null && nullToAbsent
          ? const Value.absent()
          : Value(power),
      toughness: toughness == null && nullToAbsent
          ? const Value.absent()
          : Value(toughness),
      loyalty: loyalty == null && nullToAbsent
          ? const Value.absent()
          : Value(loyalty),
      defense: defense == null && nullToAbsent
          ? const Value.absent()
          : Value(defense),
      imageSmallUrl: imageSmallUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageSmallUrl),
      imageNormalUrl: imageNormalUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageNormalUrl),
      facesJson: Value(facesJson),
      detailsJson: detailsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(detailsJson),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory CardPrintingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardPrintingRow(
      id: serializer.fromJson<String>(json['id']),
      oracleId: serializer.fromJson<String?>(json['oracleId']),
      name: serializer.fromJson<String>(json['name']),
      nameNormalized: serializer.fromJson<String>(json['nameNormalized']),
      setCode: serializer.fromJson<String>(json['setCode']),
      collectorNumber: serializer.fromJson<String>(json['collectorNumber']),
      layout: serializer.fromJson<String?>(json['layout']),
      typeLine: serializer.fromJson<String?>(json['typeLine']),
      manaCost: serializer.fromJson<String?>(json['manaCost']),
      oracleText: serializer.fromJson<String?>(json['oracleText']),
      colorsJson: serializer.fromJson<String?>(json['colorsJson']),
      colorIdentityJson: serializer.fromJson<String?>(
        json['colorIdentityJson'],
      ),
      cmc: serializer.fromJson<double?>(json['cmc']),
      rarity: serializer.fromJson<String?>(json['rarity']),
      artist: serializer.fromJson<String?>(json['artist']),
      setName: serializer.fromJson<String?>(json['setName']),
      power: serializer.fromJson<String?>(json['power']),
      toughness: serializer.fromJson<String?>(json['toughness']),
      loyalty: serializer.fromJson<String?>(json['loyalty']),
      defense: serializer.fromJson<String?>(json['defense']),
      imageSmallUrl: serializer.fromJson<String?>(json['imageSmallUrl']),
      imageNormalUrl: serializer.fromJson<String?>(json['imageNormalUrl']),
      facesJson: serializer.fromJson<String>(json['facesJson']),
      detailsJson: serializer.fromJson<String?>(json['detailsJson']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'oracleId': serializer.toJson<String?>(oracleId),
      'name': serializer.toJson<String>(name),
      'nameNormalized': serializer.toJson<String>(nameNormalized),
      'setCode': serializer.toJson<String>(setCode),
      'collectorNumber': serializer.toJson<String>(collectorNumber),
      'layout': serializer.toJson<String?>(layout),
      'typeLine': serializer.toJson<String?>(typeLine),
      'manaCost': serializer.toJson<String?>(manaCost),
      'oracleText': serializer.toJson<String?>(oracleText),
      'colorsJson': serializer.toJson<String?>(colorsJson),
      'colorIdentityJson': serializer.toJson<String?>(colorIdentityJson),
      'cmc': serializer.toJson<double?>(cmc),
      'rarity': serializer.toJson<String?>(rarity),
      'artist': serializer.toJson<String?>(artist),
      'setName': serializer.toJson<String?>(setName),
      'power': serializer.toJson<String?>(power),
      'toughness': serializer.toJson<String?>(toughness),
      'loyalty': serializer.toJson<String?>(loyalty),
      'defense': serializer.toJson<String?>(defense),
      'imageSmallUrl': serializer.toJson<String?>(imageSmallUrl),
      'imageNormalUrl': serializer.toJson<String?>(imageNormalUrl),
      'facesJson': serializer.toJson<String>(facesJson),
      'detailsJson': serializer.toJson<String?>(detailsJson),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  CardPrintingRow copyWith({
    String? id,
    Value<String?> oracleId = const Value.absent(),
    String? name,
    String? nameNormalized,
    String? setCode,
    String? collectorNumber,
    Value<String?> layout = const Value.absent(),
    Value<String?> typeLine = const Value.absent(),
    Value<String?> manaCost = const Value.absent(),
    Value<String?> oracleText = const Value.absent(),
    Value<String?> colorsJson = const Value.absent(),
    Value<String?> colorIdentityJson = const Value.absent(),
    Value<double?> cmc = const Value.absent(),
    Value<String?> rarity = const Value.absent(),
    Value<String?> artist = const Value.absent(),
    Value<String?> setName = const Value.absent(),
    Value<String?> power = const Value.absent(),
    Value<String?> toughness = const Value.absent(),
    Value<String?> loyalty = const Value.absent(),
    Value<String?> defense = const Value.absent(),
    Value<String?> imageSmallUrl = const Value.absent(),
    Value<String?> imageNormalUrl = const Value.absent(),
    String? facesJson,
    Value<String?> detailsJson = const Value.absent(),
    DateTime? fetchedAt,
  }) => CardPrintingRow(
    id: id ?? this.id,
    oracleId: oracleId.present ? oracleId.value : this.oracleId,
    name: name ?? this.name,
    nameNormalized: nameNormalized ?? this.nameNormalized,
    setCode: setCode ?? this.setCode,
    collectorNumber: collectorNumber ?? this.collectorNumber,
    layout: layout.present ? layout.value : this.layout,
    typeLine: typeLine.present ? typeLine.value : this.typeLine,
    manaCost: manaCost.present ? manaCost.value : this.manaCost,
    oracleText: oracleText.present ? oracleText.value : this.oracleText,
    colorsJson: colorsJson.present ? colorsJson.value : this.colorsJson,
    colorIdentityJson: colorIdentityJson.present
        ? colorIdentityJson.value
        : this.colorIdentityJson,
    cmc: cmc.present ? cmc.value : this.cmc,
    rarity: rarity.present ? rarity.value : this.rarity,
    artist: artist.present ? artist.value : this.artist,
    setName: setName.present ? setName.value : this.setName,
    power: power.present ? power.value : this.power,
    toughness: toughness.present ? toughness.value : this.toughness,
    loyalty: loyalty.present ? loyalty.value : this.loyalty,
    defense: defense.present ? defense.value : this.defense,
    imageSmallUrl: imageSmallUrl.present
        ? imageSmallUrl.value
        : this.imageSmallUrl,
    imageNormalUrl: imageNormalUrl.present
        ? imageNormalUrl.value
        : this.imageNormalUrl,
    facesJson: facesJson ?? this.facesJson,
    detailsJson: detailsJson.present ? detailsJson.value : this.detailsJson,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  CardPrintingRow copyWithCompanion(CardPrintingsCompanion data) {
    return CardPrintingRow(
      id: data.id.present ? data.id.value : this.id,
      oracleId: data.oracleId.present ? data.oracleId.value : this.oracleId,
      name: data.name.present ? data.name.value : this.name,
      nameNormalized: data.nameNormalized.present
          ? data.nameNormalized.value
          : this.nameNormalized,
      setCode: data.setCode.present ? data.setCode.value : this.setCode,
      collectorNumber: data.collectorNumber.present
          ? data.collectorNumber.value
          : this.collectorNumber,
      layout: data.layout.present ? data.layout.value : this.layout,
      typeLine: data.typeLine.present ? data.typeLine.value : this.typeLine,
      manaCost: data.manaCost.present ? data.manaCost.value : this.manaCost,
      oracleText: data.oracleText.present
          ? data.oracleText.value
          : this.oracleText,
      colorsJson: data.colorsJson.present
          ? data.colorsJson.value
          : this.colorsJson,
      colorIdentityJson: data.colorIdentityJson.present
          ? data.colorIdentityJson.value
          : this.colorIdentityJson,
      cmc: data.cmc.present ? data.cmc.value : this.cmc,
      rarity: data.rarity.present ? data.rarity.value : this.rarity,
      artist: data.artist.present ? data.artist.value : this.artist,
      setName: data.setName.present ? data.setName.value : this.setName,
      power: data.power.present ? data.power.value : this.power,
      toughness: data.toughness.present ? data.toughness.value : this.toughness,
      loyalty: data.loyalty.present ? data.loyalty.value : this.loyalty,
      defense: data.defense.present ? data.defense.value : this.defense,
      imageSmallUrl: data.imageSmallUrl.present
          ? data.imageSmallUrl.value
          : this.imageSmallUrl,
      imageNormalUrl: data.imageNormalUrl.present
          ? data.imageNormalUrl.value
          : this.imageNormalUrl,
      facesJson: data.facesJson.present ? data.facesJson.value : this.facesJson,
      detailsJson: data.detailsJson.present
          ? data.detailsJson.value
          : this.detailsJson,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardPrintingRow(')
          ..write('id: $id, ')
          ..write('oracleId: $oracleId, ')
          ..write('name: $name, ')
          ..write('nameNormalized: $nameNormalized, ')
          ..write('setCode: $setCode, ')
          ..write('collectorNumber: $collectorNumber, ')
          ..write('layout: $layout, ')
          ..write('typeLine: $typeLine, ')
          ..write('manaCost: $manaCost, ')
          ..write('oracleText: $oracleText, ')
          ..write('colorsJson: $colorsJson, ')
          ..write('colorIdentityJson: $colorIdentityJson, ')
          ..write('cmc: $cmc, ')
          ..write('rarity: $rarity, ')
          ..write('artist: $artist, ')
          ..write('setName: $setName, ')
          ..write('power: $power, ')
          ..write('toughness: $toughness, ')
          ..write('loyalty: $loyalty, ')
          ..write('defense: $defense, ')
          ..write('imageSmallUrl: $imageSmallUrl, ')
          ..write('imageNormalUrl: $imageNormalUrl, ')
          ..write('facesJson: $facesJson, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    oracleId,
    name,
    nameNormalized,
    setCode,
    collectorNumber,
    layout,
    typeLine,
    manaCost,
    oracleText,
    colorsJson,
    colorIdentityJson,
    cmc,
    rarity,
    artist,
    setName,
    power,
    toughness,
    loyalty,
    defense,
    imageSmallUrl,
    imageNormalUrl,
    facesJson,
    detailsJson,
    fetchedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardPrintingRow &&
          other.id == this.id &&
          other.oracleId == this.oracleId &&
          other.name == this.name &&
          other.nameNormalized == this.nameNormalized &&
          other.setCode == this.setCode &&
          other.collectorNumber == this.collectorNumber &&
          other.layout == this.layout &&
          other.typeLine == this.typeLine &&
          other.manaCost == this.manaCost &&
          other.oracleText == this.oracleText &&
          other.colorsJson == this.colorsJson &&
          other.colorIdentityJson == this.colorIdentityJson &&
          other.cmc == this.cmc &&
          other.rarity == this.rarity &&
          other.artist == this.artist &&
          other.setName == this.setName &&
          other.power == this.power &&
          other.toughness == this.toughness &&
          other.loyalty == this.loyalty &&
          other.defense == this.defense &&
          other.imageSmallUrl == this.imageSmallUrl &&
          other.imageNormalUrl == this.imageNormalUrl &&
          other.facesJson == this.facesJson &&
          other.detailsJson == this.detailsJson &&
          other.fetchedAt == this.fetchedAt);
}

class CardPrintingsCompanion extends UpdateCompanion<CardPrintingRow> {
  final Value<String> id;
  final Value<String?> oracleId;
  final Value<String> name;
  final Value<String> nameNormalized;
  final Value<String> setCode;
  final Value<String> collectorNumber;
  final Value<String?> layout;
  final Value<String?> typeLine;
  final Value<String?> manaCost;
  final Value<String?> oracleText;
  final Value<String?> colorsJson;
  final Value<String?> colorIdentityJson;
  final Value<double?> cmc;
  final Value<String?> rarity;
  final Value<String?> artist;
  final Value<String?> setName;
  final Value<String?> power;
  final Value<String?> toughness;
  final Value<String?> loyalty;
  final Value<String?> defense;
  final Value<String?> imageSmallUrl;
  final Value<String?> imageNormalUrl;
  final Value<String> facesJson;
  final Value<String?> detailsJson;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const CardPrintingsCompanion({
    this.id = const Value.absent(),
    this.oracleId = const Value.absent(),
    this.name = const Value.absent(),
    this.nameNormalized = const Value.absent(),
    this.setCode = const Value.absent(),
    this.collectorNumber = const Value.absent(),
    this.layout = const Value.absent(),
    this.typeLine = const Value.absent(),
    this.manaCost = const Value.absent(),
    this.oracleText = const Value.absent(),
    this.colorsJson = const Value.absent(),
    this.colorIdentityJson = const Value.absent(),
    this.cmc = const Value.absent(),
    this.rarity = const Value.absent(),
    this.artist = const Value.absent(),
    this.setName = const Value.absent(),
    this.power = const Value.absent(),
    this.toughness = const Value.absent(),
    this.loyalty = const Value.absent(),
    this.defense = const Value.absent(),
    this.imageSmallUrl = const Value.absent(),
    this.imageNormalUrl = const Value.absent(),
    this.facesJson = const Value.absent(),
    this.detailsJson = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardPrintingsCompanion.insert({
    required String id,
    this.oracleId = const Value.absent(),
    required String name,
    required String nameNormalized,
    required String setCode,
    required String collectorNumber,
    this.layout = const Value.absent(),
    this.typeLine = const Value.absent(),
    this.manaCost = const Value.absent(),
    this.oracleText = const Value.absent(),
    this.colorsJson = const Value.absent(),
    this.colorIdentityJson = const Value.absent(),
    this.cmc = const Value.absent(),
    this.rarity = const Value.absent(),
    this.artist = const Value.absent(),
    this.setName = const Value.absent(),
    this.power = const Value.absent(),
    this.toughness = const Value.absent(),
    this.loyalty = const Value.absent(),
    this.defense = const Value.absent(),
    this.imageSmallUrl = const Value.absent(),
    this.imageNormalUrl = const Value.absent(),
    this.facesJson = const Value.absent(),
    this.detailsJson = const Value.absent(),
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       nameNormalized = Value(nameNormalized),
       setCode = Value(setCode),
       collectorNumber = Value(collectorNumber),
       fetchedAt = Value(fetchedAt);
  static Insertable<CardPrintingRow> custom({
    Expression<String>? id,
    Expression<String>? oracleId,
    Expression<String>? name,
    Expression<String>? nameNormalized,
    Expression<String>? setCode,
    Expression<String>? collectorNumber,
    Expression<String>? layout,
    Expression<String>? typeLine,
    Expression<String>? manaCost,
    Expression<String>? oracleText,
    Expression<String>? colorsJson,
    Expression<String>? colorIdentityJson,
    Expression<double>? cmc,
    Expression<String>? rarity,
    Expression<String>? artist,
    Expression<String>? setName,
    Expression<String>? power,
    Expression<String>? toughness,
    Expression<String>? loyalty,
    Expression<String>? defense,
    Expression<String>? imageSmallUrl,
    Expression<String>? imageNormalUrl,
    Expression<String>? facesJson,
    Expression<String>? detailsJson,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (oracleId != null) 'oracle_id': oracleId,
      if (name != null) 'name': name,
      if (nameNormalized != null) 'name_normalized': nameNormalized,
      if (setCode != null) 'set_code': setCode,
      if (collectorNumber != null) 'collector_number': collectorNumber,
      if (layout != null) 'layout': layout,
      if (typeLine != null) 'type_line': typeLine,
      if (manaCost != null) 'mana_cost': manaCost,
      if (oracleText != null) 'oracle_text': oracleText,
      if (colorsJson != null) 'colors_json': colorsJson,
      if (colorIdentityJson != null) 'color_identity_json': colorIdentityJson,
      if (cmc != null) 'cmc': cmc,
      if (rarity != null) 'rarity': rarity,
      if (artist != null) 'artist': artist,
      if (setName != null) 'set_name': setName,
      if (power != null) 'power': power,
      if (toughness != null) 'toughness': toughness,
      if (loyalty != null) 'loyalty': loyalty,
      if (defense != null) 'defense': defense,
      if (imageSmallUrl != null) 'image_small_url': imageSmallUrl,
      if (imageNormalUrl != null) 'image_normal_url': imageNormalUrl,
      if (facesJson != null) 'faces_json': facesJson,
      if (detailsJson != null) 'details_json': detailsJson,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardPrintingsCompanion copyWith({
    Value<String>? id,
    Value<String?>? oracleId,
    Value<String>? name,
    Value<String>? nameNormalized,
    Value<String>? setCode,
    Value<String>? collectorNumber,
    Value<String?>? layout,
    Value<String?>? typeLine,
    Value<String?>? manaCost,
    Value<String?>? oracleText,
    Value<String?>? colorsJson,
    Value<String?>? colorIdentityJson,
    Value<double?>? cmc,
    Value<String?>? rarity,
    Value<String?>? artist,
    Value<String?>? setName,
    Value<String?>? power,
    Value<String?>? toughness,
    Value<String?>? loyalty,
    Value<String?>? defense,
    Value<String?>? imageSmallUrl,
    Value<String?>? imageNormalUrl,
    Value<String>? facesJson,
    Value<String?>? detailsJson,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return CardPrintingsCompanion(
      id: id ?? this.id,
      oracleId: oracleId ?? this.oracleId,
      name: name ?? this.name,
      nameNormalized: nameNormalized ?? this.nameNormalized,
      setCode: setCode ?? this.setCode,
      collectorNumber: collectorNumber ?? this.collectorNumber,
      layout: layout ?? this.layout,
      typeLine: typeLine ?? this.typeLine,
      manaCost: manaCost ?? this.manaCost,
      oracleText: oracleText ?? this.oracleText,
      colorsJson: colorsJson ?? this.colorsJson,
      colorIdentityJson: colorIdentityJson ?? this.colorIdentityJson,
      cmc: cmc ?? this.cmc,
      rarity: rarity ?? this.rarity,
      artist: artist ?? this.artist,
      setName: setName ?? this.setName,
      power: power ?? this.power,
      toughness: toughness ?? this.toughness,
      loyalty: loyalty ?? this.loyalty,
      defense: defense ?? this.defense,
      imageSmallUrl: imageSmallUrl ?? this.imageSmallUrl,
      imageNormalUrl: imageNormalUrl ?? this.imageNormalUrl,
      facesJson: facesJson ?? this.facesJson,
      detailsJson: detailsJson ?? this.detailsJson,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (oracleId.present) {
      map['oracle_id'] = Variable<String>(oracleId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameNormalized.present) {
      map['name_normalized'] = Variable<String>(nameNormalized.value);
    }
    if (setCode.present) {
      map['set_code'] = Variable<String>(setCode.value);
    }
    if (collectorNumber.present) {
      map['collector_number'] = Variable<String>(collectorNumber.value);
    }
    if (layout.present) {
      map['layout'] = Variable<String>(layout.value);
    }
    if (typeLine.present) {
      map['type_line'] = Variable<String>(typeLine.value);
    }
    if (manaCost.present) {
      map['mana_cost'] = Variable<String>(manaCost.value);
    }
    if (oracleText.present) {
      map['oracle_text'] = Variable<String>(oracleText.value);
    }
    if (colorsJson.present) {
      map['colors_json'] = Variable<String>(colorsJson.value);
    }
    if (colorIdentityJson.present) {
      map['color_identity_json'] = Variable<String>(colorIdentityJson.value);
    }
    if (cmc.present) {
      map['cmc'] = Variable<double>(cmc.value);
    }
    if (rarity.present) {
      map['rarity'] = Variable<String>(rarity.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (setName.present) {
      map['set_name'] = Variable<String>(setName.value);
    }
    if (power.present) {
      map['power'] = Variable<String>(power.value);
    }
    if (toughness.present) {
      map['toughness'] = Variable<String>(toughness.value);
    }
    if (loyalty.present) {
      map['loyalty'] = Variable<String>(loyalty.value);
    }
    if (defense.present) {
      map['defense'] = Variable<String>(defense.value);
    }
    if (imageSmallUrl.present) {
      map['image_small_url'] = Variable<String>(imageSmallUrl.value);
    }
    if (imageNormalUrl.present) {
      map['image_normal_url'] = Variable<String>(imageNormalUrl.value);
    }
    if (facesJson.present) {
      map['faces_json'] = Variable<String>(facesJson.value);
    }
    if (detailsJson.present) {
      map['details_json'] = Variable<String>(detailsJson.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardPrintingsCompanion(')
          ..write('id: $id, ')
          ..write('oracleId: $oracleId, ')
          ..write('name: $name, ')
          ..write('nameNormalized: $nameNormalized, ')
          ..write('setCode: $setCode, ')
          ..write('collectorNumber: $collectorNumber, ')
          ..write('layout: $layout, ')
          ..write('typeLine: $typeLine, ')
          ..write('manaCost: $manaCost, ')
          ..write('oracleText: $oracleText, ')
          ..write('colorsJson: $colorsJson, ')
          ..write('colorIdentityJson: $colorIdentityJson, ')
          ..write('cmc: $cmc, ')
          ..write('rarity: $rarity, ')
          ..write('artist: $artist, ')
          ..write('setName: $setName, ')
          ..write('power: $power, ')
          ..write('toughness: $toughness, ')
          ..write('loyalty: $loyalty, ')
          ..write('defense: $defense, ')
          ..write('imageSmallUrl: $imageSmallUrl, ')
          ..write('imageNormalUrl: $imageNormalUrl, ')
          ..write('facesJson: $facesJson, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CatalogMetaTable extends CatalogMeta
    with TableInfo<$CatalogMetaTable, CatalogMetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogMetaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  CatalogMetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogMetaRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CatalogMetaTable createAlias(String alias) {
    return $CatalogMetaTable(attachedDatabase, alias);
  }
}

class CatalogMetaRow extends DataClass implements Insertable<CatalogMetaRow> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const CatalogMetaRow({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CatalogMetaCompanion toCompanion(bool nullToAbsent) {
    return CatalogMetaCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory CatalogMetaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogMetaRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CatalogMetaRow copyWith({String? key, String? value, DateTime? updatedAt}) =>
      CatalogMetaRow(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CatalogMetaRow copyWithCompanion(CatalogMetaCompanion data) {
    return CatalogMetaRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogMetaRow(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogMetaRow &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class CatalogMetaCompanion extends UpdateCompanion<CatalogMetaRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CatalogMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogMetaCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<CatalogMetaRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogMetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CatalogMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    entityType,
    entityId,
    op,
    updatedAt,
    payloadJson,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOutboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
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
  SyncOutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxRow extends DataClass implements Insertable<SyncOutboxRow> {
  final int id;
  final String entityType;
  final String entityId;

  /// upsert | delete
  final String op;
  final DateTime updatedAt;

  /// JSON payload for upsert; null for delete.
  final String? payloadJson;
  final DateTime createdAt;
  const SyncOutboxRow({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.op,
    required this.updatedAt,
    this.payloadJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['op'] = Variable<String>(op);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || payloadJson != null) {
      map['payload_json'] = Variable<String>(payloadJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      op: Value(op),
      updatedAt: Value(updatedAt),
      payloadJson: payloadJson == null && nullToAbsent
          ? const Value.absent()
          : Value(payloadJson),
      createdAt: Value(createdAt),
    );
  }

  factory SyncOutboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxRow(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      op: serializer.fromJson<String>(json['op']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      payloadJson: serializer.fromJson<String?>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'op': serializer.toJson<String>(op),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'payloadJson': serializer.toJson<String?>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncOutboxRow copyWith({
    int? id,
    String? entityType,
    String? entityId,
    String? op,
    DateTime? updatedAt,
    Value<String?> payloadJson = const Value.absent(),
    DateTime? createdAt,
  }) => SyncOutboxRow(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    op: op ?? this.op,
    updatedAt: updatedAt ?? this.updatedAt,
    payloadJson: payloadJson.present ? payloadJson.value : this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncOutboxRow copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxRow(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      op: data.op.present ? data.op.value : this.op,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxRow(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    op,
    updatedAt,
    payloadJson,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxRow &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.op == this.op &&
          other.updatedAt == this.updatedAt &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxRow> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> op;
  final Value<DateTime> updatedAt;
  final Value<String?> payloadJson;
  final Value<DateTime> createdAt;
  const SyncOutboxCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.op = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required String entityId,
    required String op,
    required DateTime updatedAt,
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       op = Value(op),
       updatedAt = Value(updatedAt);
  static Insertable<SyncOutboxRow> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? op,
    Expression<DateTime>? updatedAt,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (op != null) 'op': op,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncOutboxCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? op,
    Value<DateTime>? updatedAt,
    Value<String?>? payloadJson,
    Value<DateTime>? createdAt,
  }) {
    return SyncOutboxCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      op: op ?? this.op,
      updatedAt: updatedAt ?? this.updatedAt,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cursorMeta = const VerificationMeta('cursor');
  @override
  late final GeneratedColumn<String> cursor = GeneratedColumn<String>(
    'cursor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1970-01-01T00:00:00.000Z'),
  );
  static const VerificationMeta _sessionTokenMeta = const VerificationMeta(
    'sessionToken',
  );
  @override
  late final GeneratedColumn<String> sessionToken = GeneratedColumn<String>(
    'session_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSuccessAtMeta = const VerificationMeta(
    'lastSuccessAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSuccessAt =
      GeneratedColumn<DateTime>(
        'last_success_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _hasCompletedInitialSyncMeta =
      const VerificationMeta('hasCompletedInitialSync');
  @override
  late final GeneratedColumn<bool> hasCompletedInitialSync =
      GeneratedColumn<bool>(
        'has_completed_initial_sync',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_completed_initial_sync" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cursor,
    sessionToken,
    userId,
    lastSuccessAt,
    hasCompletedInitialSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cursor')) {
      context.handle(
        _cursorMeta,
        cursor.isAcceptableOrUnknown(data['cursor']!, _cursorMeta),
      );
    }
    if (data.containsKey('session_token')) {
      context.handle(
        _sessionTokenMeta,
        sessionToken.isAcceptableOrUnknown(
          data['session_token']!,
          _sessionTokenMeta,
        ),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('last_success_at')) {
      context.handle(
        _lastSuccessAtMeta,
        lastSuccessAt.isAcceptableOrUnknown(
          data['last_success_at']!,
          _lastSuccessAtMeta,
        ),
      );
    }
    if (data.containsKey('has_completed_initial_sync')) {
      context.handle(
        _hasCompletedInitialSyncMeta,
        hasCompletedInitialSync.isAcceptableOrUnknown(
          data['has_completed_initial_sync']!,
          _hasCompletedInitialSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cursor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cursor'],
      )!,
      sessionToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_token'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      lastSuccessAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_success_at'],
      ),
      hasCompletedInitialSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_completed_initial_sync'],
      )!,
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncStateRow extends DataClass implements Insertable<SyncStateRow> {
  final int id;
  final String cursor;
  final String? sessionToken;
  final String? userId;
  final DateTime? lastSuccessAt;
  final bool hasCompletedInitialSync;
  const SyncStateRow({
    required this.id,
    required this.cursor,
    this.sessionToken,
    this.userId,
    this.lastSuccessAt,
    required this.hasCompletedInitialSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cursor'] = Variable<String>(cursor);
    if (!nullToAbsent || sessionToken != null) {
      map['session_token'] = Variable<String>(sessionToken);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || lastSuccessAt != null) {
      map['last_success_at'] = Variable<DateTime>(lastSuccessAt);
    }
    map['has_completed_initial_sync'] = Variable<bool>(hasCompletedInitialSync);
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(
      id: Value(id),
      cursor: Value(cursor),
      sessionToken: sessionToken == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionToken),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      lastSuccessAt: lastSuccessAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSuccessAt),
      hasCompletedInitialSync: Value(hasCompletedInitialSync),
    );
  }

  factory SyncStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateRow(
      id: serializer.fromJson<int>(json['id']),
      cursor: serializer.fromJson<String>(json['cursor']),
      sessionToken: serializer.fromJson<String?>(json['sessionToken']),
      userId: serializer.fromJson<String?>(json['userId']),
      lastSuccessAt: serializer.fromJson<DateTime?>(json['lastSuccessAt']),
      hasCompletedInitialSync: serializer.fromJson<bool>(
        json['hasCompletedInitialSync'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cursor': serializer.toJson<String>(cursor),
      'sessionToken': serializer.toJson<String?>(sessionToken),
      'userId': serializer.toJson<String?>(userId),
      'lastSuccessAt': serializer.toJson<DateTime?>(lastSuccessAt),
      'hasCompletedInitialSync': serializer.toJson<bool>(
        hasCompletedInitialSync,
      ),
    };
  }

  SyncStateRow copyWith({
    int? id,
    String? cursor,
    Value<String?> sessionToken = const Value.absent(),
    Value<String?> userId = const Value.absent(),
    Value<DateTime?> lastSuccessAt = const Value.absent(),
    bool? hasCompletedInitialSync,
  }) => SyncStateRow(
    id: id ?? this.id,
    cursor: cursor ?? this.cursor,
    sessionToken: sessionToken.present ? sessionToken.value : this.sessionToken,
    userId: userId.present ? userId.value : this.userId,
    lastSuccessAt: lastSuccessAt.present
        ? lastSuccessAt.value
        : this.lastSuccessAt,
    hasCompletedInitialSync:
        hasCompletedInitialSync ?? this.hasCompletedInitialSync,
  );
  SyncStateRow copyWithCompanion(SyncStateCompanion data) {
    return SyncStateRow(
      id: data.id.present ? data.id.value : this.id,
      cursor: data.cursor.present ? data.cursor.value : this.cursor,
      sessionToken: data.sessionToken.present
          ? data.sessionToken.value
          : this.sessionToken,
      userId: data.userId.present ? data.userId.value : this.userId,
      lastSuccessAt: data.lastSuccessAt.present
          ? data.lastSuccessAt.value
          : this.lastSuccessAt,
      hasCompletedInitialSync: data.hasCompletedInitialSync.present
          ? data.hasCompletedInitialSync.value
          : this.hasCompletedInitialSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateRow(')
          ..write('id: $id, ')
          ..write('cursor: $cursor, ')
          ..write('sessionToken: $sessionToken, ')
          ..write('userId: $userId, ')
          ..write('lastSuccessAt: $lastSuccessAt, ')
          ..write('hasCompletedInitialSync: $hasCompletedInitialSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cursor,
    sessionToken,
    userId,
    lastSuccessAt,
    hasCompletedInitialSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateRow &&
          other.id == this.id &&
          other.cursor == this.cursor &&
          other.sessionToken == this.sessionToken &&
          other.userId == this.userId &&
          other.lastSuccessAt == this.lastSuccessAt &&
          other.hasCompletedInitialSync == this.hasCompletedInitialSync);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateRow> {
  final Value<int> id;
  final Value<String> cursor;
  final Value<String?> sessionToken;
  final Value<String?> userId;
  final Value<DateTime?> lastSuccessAt;
  final Value<bool> hasCompletedInitialSync;
  const SyncStateCompanion({
    this.id = const Value.absent(),
    this.cursor = const Value.absent(),
    this.sessionToken = const Value.absent(),
    this.userId = const Value.absent(),
    this.lastSuccessAt = const Value.absent(),
    this.hasCompletedInitialSync = const Value.absent(),
  });
  SyncStateCompanion.insert({
    this.id = const Value.absent(),
    this.cursor = const Value.absent(),
    this.sessionToken = const Value.absent(),
    this.userId = const Value.absent(),
    this.lastSuccessAt = const Value.absent(),
    this.hasCompletedInitialSync = const Value.absent(),
  });
  static Insertable<SyncStateRow> custom({
    Expression<int>? id,
    Expression<String>? cursor,
    Expression<String>? sessionToken,
    Expression<String>? userId,
    Expression<DateTime>? lastSuccessAt,
    Expression<bool>? hasCompletedInitialSync,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cursor != null) 'cursor': cursor,
      if (sessionToken != null) 'session_token': sessionToken,
      if (userId != null) 'user_id': userId,
      if (lastSuccessAt != null) 'last_success_at': lastSuccessAt,
      if (hasCompletedInitialSync != null)
        'has_completed_initial_sync': hasCompletedInitialSync,
    });
  }

  SyncStateCompanion copyWith({
    Value<int>? id,
    Value<String>? cursor,
    Value<String?>? sessionToken,
    Value<String?>? userId,
    Value<DateTime?>? lastSuccessAt,
    Value<bool>? hasCompletedInitialSync,
  }) {
    return SyncStateCompanion(
      id: id ?? this.id,
      cursor: cursor ?? this.cursor,
      sessionToken: sessionToken ?? this.sessionToken,
      userId: userId ?? this.userId,
      lastSuccessAt: lastSuccessAt ?? this.lastSuccessAt,
      hasCompletedInitialSync:
          hasCompletedInitialSync ?? this.hasCompletedInitialSync,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cursor.present) {
      map['cursor'] = Variable<String>(cursor.value);
    }
    if (sessionToken.present) {
      map['session_token'] = Variable<String>(sessionToken.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (lastSuccessAt.present) {
      map['last_success_at'] = Variable<DateTime>(lastSuccessAt.value);
    }
    if (hasCompletedInitialSync.present) {
      map['has_completed_initial_sync'] = Variable<bool>(
        hasCompletedInitialSync.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('id: $id, ')
          ..write('cursor: $cursor, ')
          ..write('sessionToken: $sessionToken, ')
          ..write('userId: $userId, ')
          ..write('lastSuccessAt: $lastSuccessAt, ')
          ..write('hasCompletedInitialSync: $hasCompletedInitialSync')
          ..write(')'))
        .toString();
  }
}

class $InstalledDomainPacksTable extends InstalledDomainPacks
    with TableInfo<$InstalledDomainPacksTable, InstalledDomainPackRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstalledDomainPacksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moduleIdMeta = const VerificationMeta(
    'moduleId',
  );
  @override
  late final GeneratedColumn<String> moduleId = GeneratedColumn<String>(
    'module_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _installedAtMeta = const VerificationMeta(
    'installedAt',
  );
  @override
  late final GeneratedColumn<DateTime> installedAt = GeneratedColumn<DateTime>(
    'installed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    packId,
    version,
    moduleId,
    installedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'installed_domain_packs';
  @override
  VerificationContext validateIntegrity(
    Insertable<InstalledDomainPackRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('module_id')) {
      context.handle(
        _moduleIdMeta,
        moduleId.isAcceptableOrUnknown(data['module_id']!, _moduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleIdMeta);
    }
    if (data.containsKey('installed_at')) {
      context.handle(
        _installedAtMeta,
        installedAt.isAcceptableOrUnknown(
          data['installed_at']!,
          _installedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packId};
  @override
  InstalledDomainPackRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InstalledDomainPackRow(
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      moduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module_id'],
      )!,
      installedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}installed_at'],
      )!,
    );
  }

  @override
  $InstalledDomainPacksTable createAlias(String alias) {
    return $InstalledDomainPacksTable(attachedDatabase, alias);
  }
}

class InstalledDomainPackRow extends DataClass
    implements Insertable<InstalledDomainPackRow> {
  final String packId;
  final String version;
  final String moduleId;
  final DateTime installedAt;
  const InstalledDomainPackRow({
    required this.packId,
    required this.version,
    required this.moduleId,
    required this.installedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pack_id'] = Variable<String>(packId);
    map['version'] = Variable<String>(version);
    map['module_id'] = Variable<String>(moduleId);
    map['installed_at'] = Variable<DateTime>(installedAt);
    return map;
  }

  InstalledDomainPacksCompanion toCompanion(bool nullToAbsent) {
    return InstalledDomainPacksCompanion(
      packId: Value(packId),
      version: Value(version),
      moduleId: Value(moduleId),
      installedAt: Value(installedAt),
    );
  }

  factory InstalledDomainPackRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InstalledDomainPackRow(
      packId: serializer.fromJson<String>(json['packId']),
      version: serializer.fromJson<String>(json['version']),
      moduleId: serializer.fromJson<String>(json['moduleId']),
      installedAt: serializer.fromJson<DateTime>(json['installedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packId': serializer.toJson<String>(packId),
      'version': serializer.toJson<String>(version),
      'moduleId': serializer.toJson<String>(moduleId),
      'installedAt': serializer.toJson<DateTime>(installedAt),
    };
  }

  InstalledDomainPackRow copyWith({
    String? packId,
    String? version,
    String? moduleId,
    DateTime? installedAt,
  }) => InstalledDomainPackRow(
    packId: packId ?? this.packId,
    version: version ?? this.version,
    moduleId: moduleId ?? this.moduleId,
    installedAt: installedAt ?? this.installedAt,
  );
  InstalledDomainPackRow copyWithCompanion(InstalledDomainPacksCompanion data) {
    return InstalledDomainPackRow(
      packId: data.packId.present ? data.packId.value : this.packId,
      version: data.version.present ? data.version.value : this.version,
      moduleId: data.moduleId.present ? data.moduleId.value : this.moduleId,
      installedAt: data.installedAt.present
          ? data.installedAt.value
          : this.installedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InstalledDomainPackRow(')
          ..write('packId: $packId, ')
          ..write('version: $version, ')
          ..write('moduleId: $moduleId, ')
          ..write('installedAt: $installedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packId, version, moduleId, installedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InstalledDomainPackRow &&
          other.packId == this.packId &&
          other.version == this.version &&
          other.moduleId == this.moduleId &&
          other.installedAt == this.installedAt);
}

class InstalledDomainPacksCompanion
    extends UpdateCompanion<InstalledDomainPackRow> {
  final Value<String> packId;
  final Value<String> version;
  final Value<String> moduleId;
  final Value<DateTime> installedAt;
  final Value<int> rowid;
  const InstalledDomainPacksCompanion({
    this.packId = const Value.absent(),
    this.version = const Value.absent(),
    this.moduleId = const Value.absent(),
    this.installedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InstalledDomainPacksCompanion.insert({
    required String packId,
    required String version,
    required String moduleId,
    required DateTime installedAt,
    this.rowid = const Value.absent(),
  }) : packId = Value(packId),
       version = Value(version),
       moduleId = Value(moduleId),
       installedAt = Value(installedAt);
  static Insertable<InstalledDomainPackRow> custom({
    Expression<String>? packId,
    Expression<String>? version,
    Expression<String>? moduleId,
    Expression<DateTime>? installedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packId != null) 'pack_id': packId,
      if (version != null) 'version': version,
      if (moduleId != null) 'module_id': moduleId,
      if (installedAt != null) 'installed_at': installedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InstalledDomainPacksCompanion copyWith({
    Value<String>? packId,
    Value<String>? version,
    Value<String>? moduleId,
    Value<DateTime>? installedAt,
    Value<int>? rowid,
  }) {
    return InstalledDomainPacksCompanion(
      packId: packId ?? this.packId,
      version: version ?? this.version,
      moduleId: moduleId ?? this.moduleId,
      installedAt: installedAt ?? this.installedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (moduleId.present) {
      map['module_id'] = Variable<String>(moduleId.value);
    }
    if (installedAt.present) {
      map['installed_at'] = Variable<DateTime>(installedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstalledDomainPacksCompanion(')
          ..write('packId: $packId, ')
          ..write('version: $version, ')
          ..write('moduleId: $moduleId, ')
          ..write('installedAt: $installedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PackAttributeDefinitionsTable extends PackAttributeDefinitions
    with TableInfo<$PackAttributeDefinitionsTable, PackAttributeDefinitionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PackAttributeDefinitionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueTypeMeta = const VerificationMeta(
    'valueType',
  );
  @override
  late final GeneratedColumn<String> valueType = GeneratedColumn<String>(
    'value_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetTypeIdMeta = const VerificationMeta(
    'assetTypeId',
  );
  @override
  late final GeneratedColumn<String> assetTypeId = GeneratedColumn<String>(
    'asset_type_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moduleIdMeta = const VerificationMeta(
    'moduleId',
  );
  @override
  late final GeneratedColumn<String> moduleId = GeneratedColumn<String>(
    'module_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vocabularyKeyMeta = const VerificationMeta(
    'vocabularyKey',
  );
  @override
  late final GeneratedColumn<String> vocabularyKey = GeneratedColumn<String>(
    'vocabulary_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRequiredMeta = const VerificationMeta(
    'isRequired',
  );
  @override
  late final GeneratedColumn<bool> isRequired = GeneratedColumn<bool>(
    'is_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_required" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    key,
    valueType,
    assetTypeId,
    moduleId,
    displayName,
    unit,
    vocabularyKey,
    isRequired,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pack_attribute_definitions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PackAttributeDefinitionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value_type')) {
      context.handle(
        _valueTypeMeta,
        valueType.isAcceptableOrUnknown(data['value_type']!, _valueTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_valueTypeMeta);
    }
    if (data.containsKey('asset_type_id')) {
      context.handle(
        _assetTypeIdMeta,
        assetTypeId.isAcceptableOrUnknown(
          data['asset_type_id']!,
          _assetTypeIdMeta,
        ),
      );
    }
    if (data.containsKey('module_id')) {
      context.handle(
        _moduleIdMeta,
        moduleId.isAcceptableOrUnknown(data['module_id']!, _moduleIdMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('vocabulary_key')) {
      context.handle(
        _vocabularyKeyMeta,
        vocabularyKey.isAcceptableOrUnknown(
          data['vocabulary_key']!,
          _vocabularyKeyMeta,
        ),
      );
    }
    if (data.containsKey('is_required')) {
      context.handle(
        _isRequiredMeta,
        isRequired.isAcceptableOrUnknown(data['is_required']!, _isRequiredMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PackAttributeDefinitionRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PackAttributeDefinitionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      valueType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_type'],
      )!,
      assetTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_type_id'],
      ),
      moduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module_id'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      vocabularyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vocabulary_key'],
      ),
      isRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_required'],
      )!,
    );
  }

  @override
  $PackAttributeDefinitionsTable createAlias(String alias) {
    return $PackAttributeDefinitionsTable(attachedDatabase, alias);
  }
}

class PackAttributeDefinitionRow extends DataClass
    implements Insertable<PackAttributeDefinitionRow> {
  final String id;
  final String packId;
  final String key;
  final String valueType;
  final String? assetTypeId;
  final String? moduleId;
  final String? displayName;
  final String? unit;
  final String? vocabularyKey;
  final bool isRequired;
  const PackAttributeDefinitionRow({
    required this.id,
    required this.packId,
    required this.key,
    required this.valueType,
    this.assetTypeId,
    this.moduleId,
    this.displayName,
    this.unit,
    this.vocabularyKey,
    required this.isRequired,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['key'] = Variable<String>(key);
    map['value_type'] = Variable<String>(valueType);
    if (!nullToAbsent || assetTypeId != null) {
      map['asset_type_id'] = Variable<String>(assetTypeId);
    }
    if (!nullToAbsent || moduleId != null) {
      map['module_id'] = Variable<String>(moduleId);
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || vocabularyKey != null) {
      map['vocabulary_key'] = Variable<String>(vocabularyKey);
    }
    map['is_required'] = Variable<bool>(isRequired);
    return map;
  }

  PackAttributeDefinitionsCompanion toCompanion(bool nullToAbsent) {
    return PackAttributeDefinitionsCompanion(
      id: Value(id),
      packId: Value(packId),
      key: Value(key),
      valueType: Value(valueType),
      assetTypeId: assetTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(assetTypeId),
      moduleId: moduleId == null && nullToAbsent
          ? const Value.absent()
          : Value(moduleId),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      vocabularyKey: vocabularyKey == null && nullToAbsent
          ? const Value.absent()
          : Value(vocabularyKey),
      isRequired: Value(isRequired),
    );
  }

  factory PackAttributeDefinitionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PackAttributeDefinitionRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      key: serializer.fromJson<String>(json['key']),
      valueType: serializer.fromJson<String>(json['valueType']),
      assetTypeId: serializer.fromJson<String?>(json['assetTypeId']),
      moduleId: serializer.fromJson<String?>(json['moduleId']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      unit: serializer.fromJson<String?>(json['unit']),
      vocabularyKey: serializer.fromJson<String?>(json['vocabularyKey']),
      isRequired: serializer.fromJson<bool>(json['isRequired']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'key': serializer.toJson<String>(key),
      'valueType': serializer.toJson<String>(valueType),
      'assetTypeId': serializer.toJson<String?>(assetTypeId),
      'moduleId': serializer.toJson<String?>(moduleId),
      'displayName': serializer.toJson<String?>(displayName),
      'unit': serializer.toJson<String?>(unit),
      'vocabularyKey': serializer.toJson<String?>(vocabularyKey),
      'isRequired': serializer.toJson<bool>(isRequired),
    };
  }

  PackAttributeDefinitionRow copyWith({
    String? id,
    String? packId,
    String? key,
    String? valueType,
    Value<String?> assetTypeId = const Value.absent(),
    Value<String?> moduleId = const Value.absent(),
    Value<String?> displayName = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<String?> vocabularyKey = const Value.absent(),
    bool? isRequired,
  }) => PackAttributeDefinitionRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    key: key ?? this.key,
    valueType: valueType ?? this.valueType,
    assetTypeId: assetTypeId.present ? assetTypeId.value : this.assetTypeId,
    moduleId: moduleId.present ? moduleId.value : this.moduleId,
    displayName: displayName.present ? displayName.value : this.displayName,
    unit: unit.present ? unit.value : this.unit,
    vocabularyKey: vocabularyKey.present
        ? vocabularyKey.value
        : this.vocabularyKey,
    isRequired: isRequired ?? this.isRequired,
  );
  PackAttributeDefinitionRow copyWithCompanion(
    PackAttributeDefinitionsCompanion data,
  ) {
    return PackAttributeDefinitionRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      key: data.key.present ? data.key.value : this.key,
      valueType: data.valueType.present ? data.valueType.value : this.valueType,
      assetTypeId: data.assetTypeId.present
          ? data.assetTypeId.value
          : this.assetTypeId,
      moduleId: data.moduleId.present ? data.moduleId.value : this.moduleId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      unit: data.unit.present ? data.unit.value : this.unit,
      vocabularyKey: data.vocabularyKey.present
          ? data.vocabularyKey.value
          : this.vocabularyKey,
      isRequired: data.isRequired.present
          ? data.isRequired.value
          : this.isRequired,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PackAttributeDefinitionRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('key: $key, ')
          ..write('valueType: $valueType, ')
          ..write('assetTypeId: $assetTypeId, ')
          ..write('moduleId: $moduleId, ')
          ..write('displayName: $displayName, ')
          ..write('unit: $unit, ')
          ..write('vocabularyKey: $vocabularyKey, ')
          ..write('isRequired: $isRequired')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packId,
    key,
    valueType,
    assetTypeId,
    moduleId,
    displayName,
    unit,
    vocabularyKey,
    isRequired,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PackAttributeDefinitionRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.key == this.key &&
          other.valueType == this.valueType &&
          other.assetTypeId == this.assetTypeId &&
          other.moduleId == this.moduleId &&
          other.displayName == this.displayName &&
          other.unit == this.unit &&
          other.vocabularyKey == this.vocabularyKey &&
          other.isRequired == this.isRequired);
}

class PackAttributeDefinitionsCompanion
    extends UpdateCompanion<PackAttributeDefinitionRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> key;
  final Value<String> valueType;
  final Value<String?> assetTypeId;
  final Value<String?> moduleId;
  final Value<String?> displayName;
  final Value<String?> unit;
  final Value<String?> vocabularyKey;
  final Value<bool> isRequired;
  final Value<int> rowid;
  const PackAttributeDefinitionsCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.key = const Value.absent(),
    this.valueType = const Value.absent(),
    this.assetTypeId = const Value.absent(),
    this.moduleId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.unit = const Value.absent(),
    this.vocabularyKey = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PackAttributeDefinitionsCompanion.insert({
    required String id,
    required String packId,
    required String key,
    required String valueType,
    this.assetTypeId = const Value.absent(),
    this.moduleId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.unit = const Value.absent(),
    this.vocabularyKey = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       key = Value(key),
       valueType = Value(valueType);
  static Insertable<PackAttributeDefinitionRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? key,
    Expression<String>? valueType,
    Expression<String>? assetTypeId,
    Expression<String>? moduleId,
    Expression<String>? displayName,
    Expression<String>? unit,
    Expression<String>? vocabularyKey,
    Expression<bool>? isRequired,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (key != null) 'key': key,
      if (valueType != null) 'value_type': valueType,
      if (assetTypeId != null) 'asset_type_id': assetTypeId,
      if (moduleId != null) 'module_id': moduleId,
      if (displayName != null) 'display_name': displayName,
      if (unit != null) 'unit': unit,
      if (vocabularyKey != null) 'vocabulary_key': vocabularyKey,
      if (isRequired != null) 'is_required': isRequired,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PackAttributeDefinitionsCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? key,
    Value<String>? valueType,
    Value<String?>? assetTypeId,
    Value<String?>? moduleId,
    Value<String?>? displayName,
    Value<String?>? unit,
    Value<String?>? vocabularyKey,
    Value<bool>? isRequired,
    Value<int>? rowid,
  }) {
    return PackAttributeDefinitionsCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      key: key ?? this.key,
      valueType: valueType ?? this.valueType,
      assetTypeId: assetTypeId ?? this.assetTypeId,
      moduleId: moduleId ?? this.moduleId,
      displayName: displayName ?? this.displayName,
      unit: unit ?? this.unit,
      vocabularyKey: vocabularyKey ?? this.vocabularyKey,
      isRequired: isRequired ?? this.isRequired,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (valueType.present) {
      map['value_type'] = Variable<String>(valueType.value);
    }
    if (assetTypeId.present) {
      map['asset_type_id'] = Variable<String>(assetTypeId.value);
    }
    if (moduleId.present) {
      map['module_id'] = Variable<String>(moduleId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (vocabularyKey.present) {
      map['vocabulary_key'] = Variable<String>(vocabularyKey.value);
    }
    if (isRequired.present) {
      map['is_required'] = Variable<bool>(isRequired.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PackAttributeDefinitionsCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('key: $key, ')
          ..write('valueType: $valueType, ')
          ..write('assetTypeId: $assetTypeId, ')
          ..write('moduleId: $moduleId, ')
          ..write('displayName: $displayName, ')
          ..write('unit: $unit, ')
          ..write('vocabularyKey: $vocabularyKey, ')
          ..write('isRequired: $isRequired, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PackControlledValuesTable extends PackControlledValues
    with TableInfo<$PackControlledValuesTable, PackControlledValueRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PackControlledValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vocabularyKeyMeta = const VerificationMeta(
    'vocabularyKey',
  );
  @override
  late final GeneratedColumn<String> vocabularyKey = GeneratedColumn<String>(
    'vocabulary_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _canonicalKeyMeta = const VerificationMeta(
    'canonicalKey',
  );
  @override
  late final GeneratedColumn<String> canonicalKey = GeneratedColumn<String>(
    'canonical_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    vocabularyKey,
    canonicalKey,
    label,
    parentId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pack_controlled_values';
  @override
  VerificationContext validateIntegrity(
    Insertable<PackControlledValueRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('vocabulary_key')) {
      context.handle(
        _vocabularyKeyMeta,
        vocabularyKey.isAcceptableOrUnknown(
          data['vocabulary_key']!,
          _vocabularyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vocabularyKeyMeta);
    }
    if (data.containsKey('canonical_key')) {
      context.handle(
        _canonicalKeyMeta,
        canonicalKey.isAcceptableOrUnknown(
          data['canonical_key']!,
          _canonicalKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_canonicalKeyMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PackControlledValueRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PackControlledValueRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      vocabularyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vocabulary_key'],
      )!,
      canonicalKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}canonical_key'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
    );
  }

  @override
  $PackControlledValuesTable createAlias(String alias) {
    return $PackControlledValuesTable(attachedDatabase, alias);
  }
}

class PackControlledValueRow extends DataClass
    implements Insertable<PackControlledValueRow> {
  final String id;
  final String packId;
  final String vocabularyKey;
  final String canonicalKey;
  final String label;
  final String? parentId;
  const PackControlledValueRow({
    required this.id,
    required this.packId,
    required this.vocabularyKey,
    required this.canonicalKey,
    required this.label,
    this.parentId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['vocabulary_key'] = Variable<String>(vocabularyKey);
    map['canonical_key'] = Variable<String>(canonicalKey);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    return map;
  }

  PackControlledValuesCompanion toCompanion(bool nullToAbsent) {
    return PackControlledValuesCompanion(
      id: Value(id),
      packId: Value(packId),
      vocabularyKey: Value(vocabularyKey),
      canonicalKey: Value(canonicalKey),
      label: Value(label),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
    );
  }

  factory PackControlledValueRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PackControlledValueRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      vocabularyKey: serializer.fromJson<String>(json['vocabularyKey']),
      canonicalKey: serializer.fromJson<String>(json['canonicalKey']),
      label: serializer.fromJson<String>(json['label']),
      parentId: serializer.fromJson<String?>(json['parentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'vocabularyKey': serializer.toJson<String>(vocabularyKey),
      'canonicalKey': serializer.toJson<String>(canonicalKey),
      'label': serializer.toJson<String>(label),
      'parentId': serializer.toJson<String?>(parentId),
    };
  }

  PackControlledValueRow copyWith({
    String? id,
    String? packId,
    String? vocabularyKey,
    String? canonicalKey,
    String? label,
    Value<String?> parentId = const Value.absent(),
  }) => PackControlledValueRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    vocabularyKey: vocabularyKey ?? this.vocabularyKey,
    canonicalKey: canonicalKey ?? this.canonicalKey,
    label: label ?? this.label,
    parentId: parentId.present ? parentId.value : this.parentId,
  );
  PackControlledValueRow copyWithCompanion(PackControlledValuesCompanion data) {
    return PackControlledValueRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      vocabularyKey: data.vocabularyKey.present
          ? data.vocabularyKey.value
          : this.vocabularyKey,
      canonicalKey: data.canonicalKey.present
          ? data.canonicalKey.value
          : this.canonicalKey,
      label: data.label.present ? data.label.value : this.label,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PackControlledValueRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('vocabularyKey: $vocabularyKey, ')
          ..write('canonicalKey: $canonicalKey, ')
          ..write('label: $label, ')
          ..write('parentId: $parentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, packId, vocabularyKey, canonicalKey, label, parentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PackControlledValueRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.vocabularyKey == this.vocabularyKey &&
          other.canonicalKey == this.canonicalKey &&
          other.label == this.label &&
          other.parentId == this.parentId);
}

class PackControlledValuesCompanion
    extends UpdateCompanion<PackControlledValueRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> vocabularyKey;
  final Value<String> canonicalKey;
  final Value<String> label;
  final Value<String?> parentId;
  final Value<int> rowid;
  const PackControlledValuesCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.vocabularyKey = const Value.absent(),
    this.canonicalKey = const Value.absent(),
    this.label = const Value.absent(),
    this.parentId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PackControlledValuesCompanion.insert({
    required String id,
    required String packId,
    required String vocabularyKey,
    required String canonicalKey,
    required String label,
    this.parentId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       vocabularyKey = Value(vocabularyKey),
       canonicalKey = Value(canonicalKey),
       label = Value(label);
  static Insertable<PackControlledValueRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? vocabularyKey,
    Expression<String>? canonicalKey,
    Expression<String>? label,
    Expression<String>? parentId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (vocabularyKey != null) 'vocabulary_key': vocabularyKey,
      if (canonicalKey != null) 'canonical_key': canonicalKey,
      if (label != null) 'label': label,
      if (parentId != null) 'parent_id': parentId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PackControlledValuesCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? vocabularyKey,
    Value<String>? canonicalKey,
    Value<String>? label,
    Value<String?>? parentId,
    Value<int>? rowid,
  }) {
    return PackControlledValuesCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      vocabularyKey: vocabularyKey ?? this.vocabularyKey,
      canonicalKey: canonicalKey ?? this.canonicalKey,
      label: label ?? this.label,
      parentId: parentId ?? this.parentId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (vocabularyKey.present) {
      map['vocabulary_key'] = Variable<String>(vocabularyKey.value);
    }
    if (canonicalKey.present) {
      map['canonical_key'] = Variable<String>(canonicalKey.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PackControlledValuesCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('vocabularyKey: $vocabularyKey, ')
          ..write('canonicalKey: $canonicalKey, ')
          ..write('label: $label, ')
          ..write('parentId: $parentId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocationsTable locations = $LocationsTable(this);
  late final $ContainersTable containers = $ContainersTable(this);
  late final $AssetTypesTable assetTypes = $AssetTypesTable(this);
  late final $AssetsTable assets = $AssetsTable(this);
  late final $CardPrintingsTable cardPrintings = $CardPrintingsTable(this);
  late final $CatalogMetaTable catalogMeta = $CatalogMetaTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  late final $InstalledDomainPacksTable installedDomainPacks =
      $InstalledDomainPacksTable(this);
  late final $PackAttributeDefinitionsTable packAttributeDefinitions =
      $PackAttributeDefinitionsTable(this);
  late final $PackControlledValuesTable packControlledValues =
      $PackControlledValuesTable(this);
  late final Index locationsParentIdx = Index(
    'locations_parent_idx',
    'CREATE INDEX locations_parent_idx ON locations (parent_location_id)',
  );
  late final Index locationsNameIdx = Index(
    'locations_name_idx',
    'CREATE INDEX locations_name_idx ON locations (name)',
  );
  late final Index containersParentIdx = Index(
    'containers_parent_idx',
    'CREATE INDEX containers_parent_idx ON containers (parent_container_id)',
  );
  late final Index containersLocationIdx = Index(
    'containers_location_idx',
    'CREATE INDEX containers_location_idx ON containers (location_id)',
  );
  late final Index containersNameIdx = Index(
    'containers_name_idx',
    'CREATE INDEX containers_name_idx ON containers (name)',
  );
  late final Index assetTypesModuleIdx = Index(
    'asset_types_module_idx',
    'CREATE INDEX asset_types_module_idx ON asset_types (module_id)',
  );
  late final Index assetTypesParentIdx = Index(
    'asset_types_parent_idx',
    'CREATE INDEX asset_types_parent_idx ON asset_types (parent_id)',
  );
  late final Index assetsContainerIdx = Index(
    'assets_container_idx',
    'CREATE INDEX assets_container_idx ON assets (container_id)',
  );
  late final Index assetsLocationIdx = Index(
    'assets_location_idx',
    'CREATE INDEX assets_location_idx ON assets (location_id)',
  );
  late final Index assetsNameIdx = Index(
    'assets_name_idx',
    'CREATE INDEX assets_name_idx ON assets (name)',
  );
  late final Index cardPrintingsSetCollectorIdx = Index(
    'card_printings_set_collector_idx',
    'CREATE INDEX card_printings_set_collector_idx ON card_printings (set_code, collector_number)',
  );
  late final Index cardPrintingsNameIdx = Index(
    'card_printings_name_idx',
    'CREATE INDEX card_printings_name_idx ON card_printings (name_normalized)',
  );
  late final Index cardPrintingsOracleIdIdx = Index(
    'card_printings_oracle_id_idx',
    'CREATE INDEX card_printings_oracle_id_idx ON card_printings (oracle_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    locations,
    containers,
    assetTypes,
    assets,
    cardPrintings,
    catalogMeta,
    syncOutbox,
    syncState,
    installedDomainPacks,
    packAttributeDefinitions,
    packControlledValues,
    locationsParentIdx,
    locationsNameIdx,
    containersParentIdx,
    containersLocationIdx,
    containersNameIdx,
    assetTypesModuleIdx,
    assetTypesParentIdx,
    assetsContainerIdx,
    assetsLocationIdx,
    assetsNameIdx,
    cardPrintingsSetCollectorIdx,
    cardPrintingsNameIdx,
    cardPrintingsOracleIdIdx,
  ];
}

typedef $$LocationsTableCreateCompanionBuilder =
    LocationsCompanion Function({
      required String id,
      required String name,
      Value<String?> parentLocationId,
      Value<String?> path,
      Value<String?> nfcTagId,
      Value<String?> notes,
      Value<String> metadataJson,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LocationsTableUpdateCompanionBuilder =
    LocationsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> parentLocationId,
      Value<String?> path,
      Value<String?> nfcTagId,
      Value<String?> notes,
      Value<String> metadataJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocationsTableFilterComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentLocationId => $composableBuilder(
    column: $table.parentLocationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nfcTagId => $composableBuilder(
    column: $table.nfcTagId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
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
}

class $$LocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentLocationId => $composableBuilder(
    column: $table.parentLocationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nfcTagId => $composableBuilder(
    column: $table.nfcTagId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
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
}

class $$LocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentLocationId => $composableBuilder(
    column: $table.parentLocationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get nfcTagId =>
      $composableBuilder(column: $table.nfcTagId, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocationsTable,
          LocationRow,
          $$LocationsTableFilterComposer,
          $$LocationsTableOrderingComposer,
          $$LocationsTableAnnotationComposer,
          $$LocationsTableCreateCompanionBuilder,
          $$LocationsTableUpdateCompanionBuilder,
          (
            LocationRow,
            BaseReferences<_$AppDatabase, $LocationsTable, LocationRow>,
          ),
          LocationRow,
          PrefetchHooks Function()
        > {
  $$LocationsTableTableManager(_$AppDatabase db, $LocationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> parentLocationId = const Value.absent(),
                Value<String?> path = const Value.absent(),
                Value<String?> nfcTagId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocationsCompanion(
                id: id,
                name: name,
                parentLocationId: parentLocationId,
                path: path,
                nfcTagId: nfcTagId,
                notes: notes,
                metadataJson: metadataJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> parentLocationId = const Value.absent(),
                Value<String?> path = const Value.absent(),
                Value<String?> nfcTagId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocationsCompanion.insert(
                id: id,
                name: name,
                parentLocationId: parentLocationId,
                path: path,
                nfcTagId: nfcTagId,
                notes: notes,
                metadataJson: metadataJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocationsTable,
      LocationRow,
      $$LocationsTableFilterComposer,
      $$LocationsTableOrderingComposer,
      $$LocationsTableAnnotationComposer,
      $$LocationsTableCreateCompanionBuilder,
      $$LocationsTableUpdateCompanionBuilder,
      (
        LocationRow,
        BaseReferences<_$AppDatabase, $LocationsTable, LocationRow>,
      ),
      LocationRow,
      PrefetchHooks Function()
    >;
typedef $$ContainersTableCreateCompanionBuilder =
    ContainersCompanion Function({
      required String id,
      required String name,
      Value<String?> parentContainerId,
      Value<String?> locationId,
      Value<String?> nfcTagId,
      Value<String?> notes,
      Value<String> metadataJson,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ContainersTableUpdateCompanionBuilder =
    ContainersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> parentContainerId,
      Value<String?> locationId,
      Value<String?> nfcTagId,
      Value<String?> notes,
      Value<String> metadataJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ContainersTableFilterComposer
    extends Composer<_$AppDatabase, $ContainersTable> {
  $$ContainersTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentContainerId => $composableBuilder(
    column: $table.parentContainerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nfcTagId => $composableBuilder(
    column: $table.nfcTagId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
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
}

class $$ContainersTableOrderingComposer
    extends Composer<_$AppDatabase, $ContainersTable> {
  $$ContainersTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentContainerId => $composableBuilder(
    column: $table.parentContainerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nfcTagId => $composableBuilder(
    column: $table.nfcTagId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
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
}

class $$ContainersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContainersTable> {
  $$ContainersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentContainerId => $composableBuilder(
    column: $table.parentContainerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nfcTagId =>
      $composableBuilder(column: $table.nfcTagId, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ContainersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContainersTable,
          ContainerRow,
          $$ContainersTableFilterComposer,
          $$ContainersTableOrderingComposer,
          $$ContainersTableAnnotationComposer,
          $$ContainersTableCreateCompanionBuilder,
          $$ContainersTableUpdateCompanionBuilder,
          (
            ContainerRow,
            BaseReferences<_$AppDatabase, $ContainersTable, ContainerRow>,
          ),
          ContainerRow,
          PrefetchHooks Function()
        > {
  $$ContainersTableTableManager(_$AppDatabase db, $ContainersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContainersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContainersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContainersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> parentContainerId = const Value.absent(),
                Value<String?> locationId = const Value.absent(),
                Value<String?> nfcTagId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContainersCompanion(
                id: id,
                name: name,
                parentContainerId: parentContainerId,
                locationId: locationId,
                nfcTagId: nfcTagId,
                notes: notes,
                metadataJson: metadataJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> parentContainerId = const Value.absent(),
                Value<String?> locationId = const Value.absent(),
                Value<String?> nfcTagId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ContainersCompanion.insert(
                id: id,
                name: name,
                parentContainerId: parentContainerId,
                locationId: locationId,
                nfcTagId: nfcTagId,
                notes: notes,
                metadataJson: metadataJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContainersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContainersTable,
      ContainerRow,
      $$ContainersTableFilterComposer,
      $$ContainersTableOrderingComposer,
      $$ContainersTableAnnotationComposer,
      $$ContainersTableCreateCompanionBuilder,
      $$ContainersTableUpdateCompanionBuilder,
      (
        ContainerRow,
        BaseReferences<_$AppDatabase, $ContainersTable, ContainerRow>,
      ),
      ContainerRow,
      PrefetchHooks Function()
    >;
typedef $$AssetTypesTableCreateCompanionBuilder =
    AssetTypesCompanion Function({
      required String id,
      required String name,
      required String moduleId,
      Value<String?> parentId,
      Value<String?> description,
      Value<String> metadataJson,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AssetTypesTableUpdateCompanionBuilder =
    AssetTypesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> moduleId,
      Value<String?> parentId,
      Value<String?> description,
      Value<String> metadataJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AssetTypesTableFilterComposer
    extends Composer<_$AppDatabase, $AssetTypesTable> {
  $$AssetTypesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
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
}

class $$AssetTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetTypesTable> {
  $$AssetTypesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
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
}

class $$AssetTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetTypesTable> {
  $$AssetTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get moduleId =>
      $composableBuilder(column: $table.moduleId, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AssetTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssetTypesTable,
          AssetTypeRow,
          $$AssetTypesTableFilterComposer,
          $$AssetTypesTableOrderingComposer,
          $$AssetTypesTableAnnotationComposer,
          $$AssetTypesTableCreateCompanionBuilder,
          $$AssetTypesTableUpdateCompanionBuilder,
          (
            AssetTypeRow,
            BaseReferences<_$AppDatabase, $AssetTypesTable, AssetTypeRow>,
          ),
          AssetTypeRow,
          PrefetchHooks Function()
        > {
  $$AssetTypesTableTableManager(_$AppDatabase db, $AssetTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> moduleId = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetTypesCompanion(
                id: id,
                name: name,
                moduleId: moduleId,
                parentId: parentId,
                description: description,
                metadataJson: metadataJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String moduleId,
                Value<String?> parentId = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AssetTypesCompanion.insert(
                id: id,
                name: name,
                moduleId: moduleId,
                parentId: parentId,
                description: description,
                metadataJson: metadataJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AssetTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssetTypesTable,
      AssetTypeRow,
      $$AssetTypesTableFilterComposer,
      $$AssetTypesTableOrderingComposer,
      $$AssetTypesTableAnnotationComposer,
      $$AssetTypesTableCreateCompanionBuilder,
      $$AssetTypesTableUpdateCompanionBuilder,
      (
        AssetTypeRow,
        BaseReferences<_$AppDatabase, $AssetTypesTable, AssetTypeRow>,
      ),
      AssetTypeRow,
      PrefetchHooks Function()
    >;
typedef $$AssetsTableCreateCompanionBuilder =
    AssetsCompanion Function({
      required String id,
      required String name,
      required String assetTypeId,
      Value<int> quantity,
      Value<String?> containerId,
      Value<String?> locationId,
      Value<String?> notes,
      Value<String> metadataJson,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AssetsTableUpdateCompanionBuilder =
    AssetsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> assetTypeId,
      Value<int> quantity,
      Value<String?> containerId,
      Value<String?> locationId,
      Value<String?> notes,
      Value<String> metadataJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AssetsTableFilterComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetTypeId => $composableBuilder(
    column: $table.assetTypeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get containerId => $composableBuilder(
    column: $table.containerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
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
}

class $$AssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetTypeId => $composableBuilder(
    column: $table.assetTypeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get containerId => $composableBuilder(
    column: $table.containerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
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
}

class $$AssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get assetTypeId => $composableBuilder(
    column: $table.assetTypeId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get containerId => $composableBuilder(
    column: $table.containerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AssetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssetsTable,
          AssetRow,
          $$AssetsTableFilterComposer,
          $$AssetsTableOrderingComposer,
          $$AssetsTableAnnotationComposer,
          $$AssetsTableCreateCompanionBuilder,
          $$AssetsTableUpdateCompanionBuilder,
          (AssetRow, BaseReferences<_$AppDatabase, $AssetsTable, AssetRow>),
          AssetRow,
          PrefetchHooks Function()
        > {
  $$AssetsTableTableManager(_$AppDatabase db, $AssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> assetTypeId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> containerId = const Value.absent(),
                Value<String?> locationId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion(
                id: id,
                name: name,
                assetTypeId: assetTypeId,
                quantity: quantity,
                containerId: containerId,
                locationId: locationId,
                notes: notes,
                metadataJson: metadataJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String assetTypeId,
                Value<int> quantity = const Value.absent(),
                Value<String?> containerId = const Value.absent(),
                Value<String?> locationId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion.insert(
                id: id,
                name: name,
                assetTypeId: assetTypeId,
                quantity: quantity,
                containerId: containerId,
                locationId: locationId,
                notes: notes,
                metadataJson: metadataJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssetsTable,
      AssetRow,
      $$AssetsTableFilterComposer,
      $$AssetsTableOrderingComposer,
      $$AssetsTableAnnotationComposer,
      $$AssetsTableCreateCompanionBuilder,
      $$AssetsTableUpdateCompanionBuilder,
      (AssetRow, BaseReferences<_$AppDatabase, $AssetsTable, AssetRow>),
      AssetRow,
      PrefetchHooks Function()
    >;
typedef $$CardPrintingsTableCreateCompanionBuilder =
    CardPrintingsCompanion Function({
      required String id,
      Value<String?> oracleId,
      required String name,
      required String nameNormalized,
      required String setCode,
      required String collectorNumber,
      Value<String?> layout,
      Value<String?> typeLine,
      Value<String?> manaCost,
      Value<String?> oracleText,
      Value<String?> colorsJson,
      Value<String?> colorIdentityJson,
      Value<double?> cmc,
      Value<String?> rarity,
      Value<String?> artist,
      Value<String?> setName,
      Value<String?> power,
      Value<String?> toughness,
      Value<String?> loyalty,
      Value<String?> defense,
      Value<String?> imageSmallUrl,
      Value<String?> imageNormalUrl,
      Value<String> facesJson,
      Value<String?> detailsJson,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$CardPrintingsTableUpdateCompanionBuilder =
    CardPrintingsCompanion Function({
      Value<String> id,
      Value<String?> oracleId,
      Value<String> name,
      Value<String> nameNormalized,
      Value<String> setCode,
      Value<String> collectorNumber,
      Value<String?> layout,
      Value<String?> typeLine,
      Value<String?> manaCost,
      Value<String?> oracleText,
      Value<String?> colorsJson,
      Value<String?> colorIdentityJson,
      Value<double?> cmc,
      Value<String?> rarity,
      Value<String?> artist,
      Value<String?> setName,
      Value<String?> power,
      Value<String?> toughness,
      Value<String?> loyalty,
      Value<String?> defense,
      Value<String?> imageSmallUrl,
      Value<String?> imageNormalUrl,
      Value<String> facesJson,
      Value<String?> detailsJson,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$CardPrintingsTableFilterComposer
    extends Composer<_$AppDatabase, $CardPrintingsTable> {
  $$CardPrintingsTableFilterComposer({
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

  ColumnFilters<String> get oracleId => $composableBuilder(
    column: $table.oracleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameNormalized => $composableBuilder(
    column: $table.nameNormalized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setCode => $composableBuilder(
    column: $table.setCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get collectorNumber => $composableBuilder(
    column: $table.collectorNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get layout => $composableBuilder(
    column: $table.layout,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeLine => $composableBuilder(
    column: $table.typeLine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manaCost => $composableBuilder(
    column: $table.manaCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oracleText => $composableBuilder(
    column: $table.oracleText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorsJson => $composableBuilder(
    column: $table.colorsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorIdentityJson => $composableBuilder(
    column: $table.colorIdentityJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cmc => $composableBuilder(
    column: $table.cmc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rarity => $composableBuilder(
    column: $table.rarity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setName => $composableBuilder(
    column: $table.setName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get power => $composableBuilder(
    column: $table.power,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toughness => $composableBuilder(
    column: $table.toughness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loyalty => $composableBuilder(
    column: $table.loyalty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defense => $composableBuilder(
    column: $table.defense,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageSmallUrl => $composableBuilder(
    column: $table.imageSmallUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageNormalUrl => $composableBuilder(
    column: $table.imageNormalUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get facesJson => $composableBuilder(
    column: $table.facesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardPrintingsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardPrintingsTable> {
  $$CardPrintingsTableOrderingComposer({
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

  ColumnOrderings<String> get oracleId => $composableBuilder(
    column: $table.oracleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameNormalized => $composableBuilder(
    column: $table.nameNormalized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setCode => $composableBuilder(
    column: $table.setCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get collectorNumber => $composableBuilder(
    column: $table.collectorNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get layout => $composableBuilder(
    column: $table.layout,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeLine => $composableBuilder(
    column: $table.typeLine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manaCost => $composableBuilder(
    column: $table.manaCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oracleText => $composableBuilder(
    column: $table.oracleText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorsJson => $composableBuilder(
    column: $table.colorsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorIdentityJson => $composableBuilder(
    column: $table.colorIdentityJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cmc => $composableBuilder(
    column: $table.cmc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rarity => $composableBuilder(
    column: $table.rarity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setName => $composableBuilder(
    column: $table.setName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get power => $composableBuilder(
    column: $table.power,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toughness => $composableBuilder(
    column: $table.toughness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loyalty => $composableBuilder(
    column: $table.loyalty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defense => $composableBuilder(
    column: $table.defense,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageSmallUrl => $composableBuilder(
    column: $table.imageSmallUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageNormalUrl => $composableBuilder(
    column: $table.imageNormalUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get facesJson => $composableBuilder(
    column: $table.facesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardPrintingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardPrintingsTable> {
  $$CardPrintingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get oracleId =>
      $composableBuilder(column: $table.oracleId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameNormalized => $composableBuilder(
    column: $table.nameNormalized,
    builder: (column) => column,
  );

  GeneratedColumn<String> get setCode =>
      $composableBuilder(column: $table.setCode, builder: (column) => column);

  GeneratedColumn<String> get collectorNumber => $composableBuilder(
    column: $table.collectorNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get layout =>
      $composableBuilder(column: $table.layout, builder: (column) => column);

  GeneratedColumn<String> get typeLine =>
      $composableBuilder(column: $table.typeLine, builder: (column) => column);

  GeneratedColumn<String> get manaCost =>
      $composableBuilder(column: $table.manaCost, builder: (column) => column);

  GeneratedColumn<String> get oracleText => $composableBuilder(
    column: $table.oracleText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get colorsJson => $composableBuilder(
    column: $table.colorsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get colorIdentityJson => $composableBuilder(
    column: $table.colorIdentityJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cmc =>
      $composableBuilder(column: $table.cmc, builder: (column) => column);

  GeneratedColumn<String> get rarity =>
      $composableBuilder(column: $table.rarity, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get setName =>
      $composableBuilder(column: $table.setName, builder: (column) => column);

  GeneratedColumn<String> get power =>
      $composableBuilder(column: $table.power, builder: (column) => column);

  GeneratedColumn<String> get toughness =>
      $composableBuilder(column: $table.toughness, builder: (column) => column);

  GeneratedColumn<String> get loyalty =>
      $composableBuilder(column: $table.loyalty, builder: (column) => column);

  GeneratedColumn<String> get defense =>
      $composableBuilder(column: $table.defense, builder: (column) => column);

  GeneratedColumn<String> get imageSmallUrl => $composableBuilder(
    column: $table.imageSmallUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageNormalUrl => $composableBuilder(
    column: $table.imageNormalUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get facesJson =>
      $composableBuilder(column: $table.facesJson, builder: (column) => column);

  GeneratedColumn<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$CardPrintingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardPrintingsTable,
          CardPrintingRow,
          $$CardPrintingsTableFilterComposer,
          $$CardPrintingsTableOrderingComposer,
          $$CardPrintingsTableAnnotationComposer,
          $$CardPrintingsTableCreateCompanionBuilder,
          $$CardPrintingsTableUpdateCompanionBuilder,
          (
            CardPrintingRow,
            BaseReferences<_$AppDatabase, $CardPrintingsTable, CardPrintingRow>,
          ),
          CardPrintingRow,
          PrefetchHooks Function()
        > {
  $$CardPrintingsTableTableManager(_$AppDatabase db, $CardPrintingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardPrintingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardPrintingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardPrintingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> oracleId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameNormalized = const Value.absent(),
                Value<String> setCode = const Value.absent(),
                Value<String> collectorNumber = const Value.absent(),
                Value<String?> layout = const Value.absent(),
                Value<String?> typeLine = const Value.absent(),
                Value<String?> manaCost = const Value.absent(),
                Value<String?> oracleText = const Value.absent(),
                Value<String?> colorsJson = const Value.absent(),
                Value<String?> colorIdentityJson = const Value.absent(),
                Value<double?> cmc = const Value.absent(),
                Value<String?> rarity = const Value.absent(),
                Value<String?> artist = const Value.absent(),
                Value<String?> setName = const Value.absent(),
                Value<String?> power = const Value.absent(),
                Value<String?> toughness = const Value.absent(),
                Value<String?> loyalty = const Value.absent(),
                Value<String?> defense = const Value.absent(),
                Value<String?> imageSmallUrl = const Value.absent(),
                Value<String?> imageNormalUrl = const Value.absent(),
                Value<String> facesJson = const Value.absent(),
                Value<String?> detailsJson = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardPrintingsCompanion(
                id: id,
                oracleId: oracleId,
                name: name,
                nameNormalized: nameNormalized,
                setCode: setCode,
                collectorNumber: collectorNumber,
                layout: layout,
                typeLine: typeLine,
                manaCost: manaCost,
                oracleText: oracleText,
                colorsJson: colorsJson,
                colorIdentityJson: colorIdentityJson,
                cmc: cmc,
                rarity: rarity,
                artist: artist,
                setName: setName,
                power: power,
                toughness: toughness,
                loyalty: loyalty,
                defense: defense,
                imageSmallUrl: imageSmallUrl,
                imageNormalUrl: imageNormalUrl,
                facesJson: facesJson,
                detailsJson: detailsJson,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> oracleId = const Value.absent(),
                required String name,
                required String nameNormalized,
                required String setCode,
                required String collectorNumber,
                Value<String?> layout = const Value.absent(),
                Value<String?> typeLine = const Value.absent(),
                Value<String?> manaCost = const Value.absent(),
                Value<String?> oracleText = const Value.absent(),
                Value<String?> colorsJson = const Value.absent(),
                Value<String?> colorIdentityJson = const Value.absent(),
                Value<double?> cmc = const Value.absent(),
                Value<String?> rarity = const Value.absent(),
                Value<String?> artist = const Value.absent(),
                Value<String?> setName = const Value.absent(),
                Value<String?> power = const Value.absent(),
                Value<String?> toughness = const Value.absent(),
                Value<String?> loyalty = const Value.absent(),
                Value<String?> defense = const Value.absent(),
                Value<String?> imageSmallUrl = const Value.absent(),
                Value<String?> imageNormalUrl = const Value.absent(),
                Value<String> facesJson = const Value.absent(),
                Value<String?> detailsJson = const Value.absent(),
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => CardPrintingsCompanion.insert(
                id: id,
                oracleId: oracleId,
                name: name,
                nameNormalized: nameNormalized,
                setCode: setCode,
                collectorNumber: collectorNumber,
                layout: layout,
                typeLine: typeLine,
                manaCost: manaCost,
                oracleText: oracleText,
                colorsJson: colorsJson,
                colorIdentityJson: colorIdentityJson,
                cmc: cmc,
                rarity: rarity,
                artist: artist,
                setName: setName,
                power: power,
                toughness: toughness,
                loyalty: loyalty,
                defense: defense,
                imageSmallUrl: imageSmallUrl,
                imageNormalUrl: imageNormalUrl,
                facesJson: facesJson,
                detailsJson: detailsJson,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardPrintingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardPrintingsTable,
      CardPrintingRow,
      $$CardPrintingsTableFilterComposer,
      $$CardPrintingsTableOrderingComposer,
      $$CardPrintingsTableAnnotationComposer,
      $$CardPrintingsTableCreateCompanionBuilder,
      $$CardPrintingsTableUpdateCompanionBuilder,
      (
        CardPrintingRow,
        BaseReferences<_$AppDatabase, $CardPrintingsTable, CardPrintingRow>,
      ),
      CardPrintingRow,
      PrefetchHooks Function()
    >;
typedef $$CatalogMetaTableCreateCompanionBuilder =
    CatalogMetaCompanion Function({
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CatalogMetaTableUpdateCompanionBuilder =
    CatalogMetaCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CatalogMetaTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogMetaTable> {
  $$CatalogMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogMetaTable> {
  $$CatalogMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogMetaTable> {
  $$CatalogMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CatalogMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogMetaTable,
          CatalogMetaRow,
          $$CatalogMetaTableFilterComposer,
          $$CatalogMetaTableOrderingComposer,
          $$CatalogMetaTableAnnotationComposer,
          $$CatalogMetaTableCreateCompanionBuilder,
          $$CatalogMetaTableUpdateCompanionBuilder,
          (
            CatalogMetaRow,
            BaseReferences<_$AppDatabase, $CatalogMetaTable, CatalogMetaRow>,
          ),
          CatalogMetaRow,
          PrefetchHooks Function()
        > {
  $$CatalogMetaTableTableManager(_$AppDatabase db, $CatalogMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogMetaCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CatalogMetaCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogMetaTable,
      CatalogMetaRow,
      $$CatalogMetaTableFilterComposer,
      $$CatalogMetaTableOrderingComposer,
      $$CatalogMetaTableAnnotationComposer,
      $$CatalogMetaTableCreateCompanionBuilder,
      $$CatalogMetaTableUpdateCompanionBuilder,
      (
        CatalogMetaRow,
        BaseReferences<_$AppDatabase, $CatalogMetaTable, CatalogMetaRow>,
      ),
      CatalogMetaRow,
      PrefetchHooks Function()
    >;
typedef $$SyncOutboxTableCreateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<int> id,
      required String entityType,
      required String entityId,
      required String op,
      required DateTime updatedAt,
      Value<String?> payloadJson,
      Value<DateTime> createdAt,
    });
typedef $$SyncOutboxTableUpdateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> op,
      Value<DateTime> updatedAt,
      Value<String?> payloadJson,
      Value<DateTime> createdAt,
    });

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
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

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
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

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncOutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOutboxTable,
          SyncOutboxRow,
          $$SyncOutboxTableFilterComposer,
          $$SyncOutboxTableOrderingComposer,
          $$SyncOutboxTableAnnotationComposer,
          $$SyncOutboxTableCreateCompanionBuilder,
          $$SyncOutboxTableUpdateCompanionBuilder,
          (
            SyncOutboxRow,
            BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxRow>,
          ),
          SyncOutboxRow,
          PrefetchHooks Function()
        > {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncOutboxCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                op: op,
                updatedAt: updatedAt,
                payloadJson: payloadJson,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                required String entityId,
                required String op,
                required DateTime updatedAt,
                Value<String?> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncOutboxCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                op: op,
                updatedAt: updatedAt,
                payloadJson: payloadJson,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOutboxTable,
      SyncOutboxRow,
      $$SyncOutboxTableFilterComposer,
      $$SyncOutboxTableOrderingComposer,
      $$SyncOutboxTableAnnotationComposer,
      $$SyncOutboxTableCreateCompanionBuilder,
      $$SyncOutboxTableUpdateCompanionBuilder,
      (
        SyncOutboxRow,
        BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxRow>,
      ),
      SyncOutboxRow,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder =
    SyncStateCompanion Function({
      Value<int> id,
      Value<String> cursor,
      Value<String?> sessionToken,
      Value<String?> userId,
      Value<DateTime?> lastSuccessAt,
      Value<bool> hasCompletedInitialSync,
    });
typedef $$SyncStateTableUpdateCompanionBuilder =
    SyncStateCompanion Function({
      Value<int> id,
      Value<String> cursor,
      Value<String?> sessionToken,
      Value<String?> userId,
      Value<DateTime?> lastSuccessAt,
      Value<bool> hasCompletedInitialSync,
    });

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
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

  ColumnFilters<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionToken => $composableBuilder(
    column: $table.sessionToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSuccessAt => $composableBuilder(
    column: $table.lastSuccessAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasCompletedInitialSync => $composableBuilder(
    column: $table.hasCompletedInitialSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
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

  ColumnOrderings<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionToken => $composableBuilder(
    column: $table.sessionToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSuccessAt => $composableBuilder(
    column: $table.lastSuccessAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasCompletedInitialSync => $composableBuilder(
    column: $table.hasCompletedInitialSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cursor =>
      $composableBuilder(column: $table.cursor, builder: (column) => column);

  GeneratedColumn<String> get sessionToken => $composableBuilder(
    column: $table.sessionToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSuccessAt => $composableBuilder(
    column: $table.lastSuccessAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasCompletedInitialSync => $composableBuilder(
    column: $table.hasCompletedInitialSync,
    builder: (column) => column,
  );
}

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStateTable,
          SyncStateRow,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncStateRow,
            BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateRow>,
          ),
          SyncStateRow,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$AppDatabase db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> cursor = const Value.absent(),
                Value<String?> sessionToken = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime?> lastSuccessAt = const Value.absent(),
                Value<bool> hasCompletedInitialSync = const Value.absent(),
              }) => SyncStateCompanion(
                id: id,
                cursor: cursor,
                sessionToken: sessionToken,
                userId: userId,
                lastSuccessAt: lastSuccessAt,
                hasCompletedInitialSync: hasCompletedInitialSync,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> cursor = const Value.absent(),
                Value<String?> sessionToken = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime?> lastSuccessAt = const Value.absent(),
                Value<bool> hasCompletedInitialSync = const Value.absent(),
              }) => SyncStateCompanion.insert(
                id: id,
                cursor: cursor,
                sessionToken: sessionToken,
                userId: userId,
                lastSuccessAt: lastSuccessAt,
                hasCompletedInitialSync: hasCompletedInitialSync,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStateTable,
      SyncStateRow,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (
        SyncStateRow,
        BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateRow>,
      ),
      SyncStateRow,
      PrefetchHooks Function()
    >;
typedef $$InstalledDomainPacksTableCreateCompanionBuilder =
    InstalledDomainPacksCompanion Function({
      required String packId,
      required String version,
      required String moduleId,
      required DateTime installedAt,
      Value<int> rowid,
    });
typedef $$InstalledDomainPacksTableUpdateCompanionBuilder =
    InstalledDomainPacksCompanion Function({
      Value<String> packId,
      Value<String> version,
      Value<String> moduleId,
      Value<DateTime> installedAt,
      Value<int> rowid,
    });

class $$InstalledDomainPacksTableFilterComposer
    extends Composer<_$AppDatabase, $InstalledDomainPacksTable> {
  $$InstalledDomainPacksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InstalledDomainPacksTableOrderingComposer
    extends Composer<_$AppDatabase, $InstalledDomainPacksTable> {
  $$InstalledDomainPacksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InstalledDomainPacksTableAnnotationComposer
    extends Composer<_$AppDatabase, $InstalledDomainPacksTable> {
  $$InstalledDomainPacksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get packId =>
      $composableBuilder(column: $table.packId, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get moduleId =>
      $composableBuilder(column: $table.moduleId, builder: (column) => column);

  GeneratedColumn<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => column,
  );
}

class $$InstalledDomainPacksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InstalledDomainPacksTable,
          InstalledDomainPackRow,
          $$InstalledDomainPacksTableFilterComposer,
          $$InstalledDomainPacksTableOrderingComposer,
          $$InstalledDomainPacksTableAnnotationComposer,
          $$InstalledDomainPacksTableCreateCompanionBuilder,
          $$InstalledDomainPacksTableUpdateCompanionBuilder,
          (
            InstalledDomainPackRow,
            BaseReferences<
              _$AppDatabase,
              $InstalledDomainPacksTable,
              InstalledDomainPackRow
            >,
          ),
          InstalledDomainPackRow,
          PrefetchHooks Function()
        > {
  $$InstalledDomainPacksTableTableManager(
    _$AppDatabase db,
    $InstalledDomainPacksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InstalledDomainPacksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InstalledDomainPacksTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InstalledDomainPacksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> packId = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<String> moduleId = const Value.absent(),
                Value<DateTime> installedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InstalledDomainPacksCompanion(
                packId: packId,
                version: version,
                moduleId: moduleId,
                installedAt: installedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packId,
                required String version,
                required String moduleId,
                required DateTime installedAt,
                Value<int> rowid = const Value.absent(),
              }) => InstalledDomainPacksCompanion.insert(
                packId: packId,
                version: version,
                moduleId: moduleId,
                installedAt: installedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InstalledDomainPacksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InstalledDomainPacksTable,
      InstalledDomainPackRow,
      $$InstalledDomainPacksTableFilterComposer,
      $$InstalledDomainPacksTableOrderingComposer,
      $$InstalledDomainPacksTableAnnotationComposer,
      $$InstalledDomainPacksTableCreateCompanionBuilder,
      $$InstalledDomainPacksTableUpdateCompanionBuilder,
      (
        InstalledDomainPackRow,
        BaseReferences<
          _$AppDatabase,
          $InstalledDomainPacksTable,
          InstalledDomainPackRow
        >,
      ),
      InstalledDomainPackRow,
      PrefetchHooks Function()
    >;
typedef $$PackAttributeDefinitionsTableCreateCompanionBuilder =
    PackAttributeDefinitionsCompanion Function({
      required String id,
      required String packId,
      required String key,
      required String valueType,
      Value<String?> assetTypeId,
      Value<String?> moduleId,
      Value<String?> displayName,
      Value<String?> unit,
      Value<String?> vocabularyKey,
      Value<bool> isRequired,
      Value<int> rowid,
    });
typedef $$PackAttributeDefinitionsTableUpdateCompanionBuilder =
    PackAttributeDefinitionsCompanion Function({
      Value<String> id,
      Value<String> packId,
      Value<String> key,
      Value<String> valueType,
      Value<String?> assetTypeId,
      Value<String?> moduleId,
      Value<String?> displayName,
      Value<String?> unit,
      Value<String?> vocabularyKey,
      Value<bool> isRequired,
      Value<int> rowid,
    });

class $$PackAttributeDefinitionsTableFilterComposer
    extends Composer<_$AppDatabase, $PackAttributeDefinitionsTable> {
  $$PackAttributeDefinitionsTableFilterComposer({
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

  ColumnFilters<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetTypeId => $composableBuilder(
    column: $table.assetTypeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vocabularyKey => $composableBuilder(
    column: $table.vocabularyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PackAttributeDefinitionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PackAttributeDefinitionsTable> {
  $$PackAttributeDefinitionsTableOrderingComposer({
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

  ColumnOrderings<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetTypeId => $composableBuilder(
    column: $table.assetTypeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vocabularyKey => $composableBuilder(
    column: $table.vocabularyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PackAttributeDefinitionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PackAttributeDefinitionsTable> {
  $$PackAttributeDefinitionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packId =>
      $composableBuilder(column: $table.packId, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get valueType =>
      $composableBuilder(column: $table.valueType, builder: (column) => column);

  GeneratedColumn<String> get assetTypeId => $composableBuilder(
    column: $table.assetTypeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moduleId =>
      $composableBuilder(column: $table.moduleId, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get vocabularyKey => $composableBuilder(
    column: $table.vocabularyKey,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => column,
  );
}

class $$PackAttributeDefinitionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PackAttributeDefinitionsTable,
          PackAttributeDefinitionRow,
          $$PackAttributeDefinitionsTableFilterComposer,
          $$PackAttributeDefinitionsTableOrderingComposer,
          $$PackAttributeDefinitionsTableAnnotationComposer,
          $$PackAttributeDefinitionsTableCreateCompanionBuilder,
          $$PackAttributeDefinitionsTableUpdateCompanionBuilder,
          (
            PackAttributeDefinitionRow,
            BaseReferences<
              _$AppDatabase,
              $PackAttributeDefinitionsTable,
              PackAttributeDefinitionRow
            >,
          ),
          PackAttributeDefinitionRow,
          PrefetchHooks Function()
        > {
  $$PackAttributeDefinitionsTableTableManager(
    _$AppDatabase db,
    $PackAttributeDefinitionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PackAttributeDefinitionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PackAttributeDefinitionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PackAttributeDefinitionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> valueType = const Value.absent(),
                Value<String?> assetTypeId = const Value.absent(),
                Value<String?> moduleId = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> vocabularyKey = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PackAttributeDefinitionsCompanion(
                id: id,
                packId: packId,
                key: key,
                valueType: valueType,
                assetTypeId: assetTypeId,
                moduleId: moduleId,
                displayName: displayName,
                unit: unit,
                vocabularyKey: vocabularyKey,
                isRequired: isRequired,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String key,
                required String valueType,
                Value<String?> assetTypeId = const Value.absent(),
                Value<String?> moduleId = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> vocabularyKey = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PackAttributeDefinitionsCompanion.insert(
                id: id,
                packId: packId,
                key: key,
                valueType: valueType,
                assetTypeId: assetTypeId,
                moduleId: moduleId,
                displayName: displayName,
                unit: unit,
                vocabularyKey: vocabularyKey,
                isRequired: isRequired,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PackAttributeDefinitionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PackAttributeDefinitionsTable,
      PackAttributeDefinitionRow,
      $$PackAttributeDefinitionsTableFilterComposer,
      $$PackAttributeDefinitionsTableOrderingComposer,
      $$PackAttributeDefinitionsTableAnnotationComposer,
      $$PackAttributeDefinitionsTableCreateCompanionBuilder,
      $$PackAttributeDefinitionsTableUpdateCompanionBuilder,
      (
        PackAttributeDefinitionRow,
        BaseReferences<
          _$AppDatabase,
          $PackAttributeDefinitionsTable,
          PackAttributeDefinitionRow
        >,
      ),
      PackAttributeDefinitionRow,
      PrefetchHooks Function()
    >;
typedef $$PackControlledValuesTableCreateCompanionBuilder =
    PackControlledValuesCompanion Function({
      required String id,
      required String packId,
      required String vocabularyKey,
      required String canonicalKey,
      required String label,
      Value<String?> parentId,
      Value<int> rowid,
    });
typedef $$PackControlledValuesTableUpdateCompanionBuilder =
    PackControlledValuesCompanion Function({
      Value<String> id,
      Value<String> packId,
      Value<String> vocabularyKey,
      Value<String> canonicalKey,
      Value<String> label,
      Value<String?> parentId,
      Value<int> rowid,
    });

class $$PackControlledValuesTableFilterComposer
    extends Composer<_$AppDatabase, $PackControlledValuesTable> {
  $$PackControlledValuesTableFilterComposer({
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

  ColumnFilters<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vocabularyKey => $composableBuilder(
    column: $table.vocabularyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get canonicalKey => $composableBuilder(
    column: $table.canonicalKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PackControlledValuesTableOrderingComposer
    extends Composer<_$AppDatabase, $PackControlledValuesTable> {
  $$PackControlledValuesTableOrderingComposer({
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

  ColumnOrderings<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vocabularyKey => $composableBuilder(
    column: $table.vocabularyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get canonicalKey => $composableBuilder(
    column: $table.canonicalKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PackControlledValuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PackControlledValuesTable> {
  $$PackControlledValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packId =>
      $composableBuilder(column: $table.packId, builder: (column) => column);

  GeneratedColumn<String> get vocabularyKey => $composableBuilder(
    column: $table.vocabularyKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get canonicalKey => $composableBuilder(
    column: $table.canonicalKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);
}

class $$PackControlledValuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PackControlledValuesTable,
          PackControlledValueRow,
          $$PackControlledValuesTableFilterComposer,
          $$PackControlledValuesTableOrderingComposer,
          $$PackControlledValuesTableAnnotationComposer,
          $$PackControlledValuesTableCreateCompanionBuilder,
          $$PackControlledValuesTableUpdateCompanionBuilder,
          (
            PackControlledValueRow,
            BaseReferences<
              _$AppDatabase,
              $PackControlledValuesTable,
              PackControlledValueRow
            >,
          ),
          PackControlledValueRow,
          PrefetchHooks Function()
        > {
  $$PackControlledValuesTableTableManager(
    _$AppDatabase db,
    $PackControlledValuesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PackControlledValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PackControlledValuesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PackControlledValuesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> vocabularyKey = const Value.absent(),
                Value<String> canonicalKey = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PackControlledValuesCompanion(
                id: id,
                packId: packId,
                vocabularyKey: vocabularyKey,
                canonicalKey: canonicalKey,
                label: label,
                parentId: parentId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String vocabularyKey,
                required String canonicalKey,
                required String label,
                Value<String?> parentId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PackControlledValuesCompanion.insert(
                id: id,
                packId: packId,
                vocabularyKey: vocabularyKey,
                canonicalKey: canonicalKey,
                label: label,
                parentId: parentId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PackControlledValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PackControlledValuesTable,
      PackControlledValueRow,
      $$PackControlledValuesTableFilterComposer,
      $$PackControlledValuesTableOrderingComposer,
      $$PackControlledValuesTableAnnotationComposer,
      $$PackControlledValuesTableCreateCompanionBuilder,
      $$PackControlledValuesTableUpdateCompanionBuilder,
      (
        PackControlledValueRow,
        BaseReferences<
          _$AppDatabase,
          $PackControlledValuesTable,
          PackControlledValueRow
        >,
      ),
      PackControlledValueRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocationsTableTableManager get locations =>
      $$LocationsTableTableManager(_db, _db.locations);
  $$ContainersTableTableManager get containers =>
      $$ContainersTableTableManager(_db, _db.containers);
  $$AssetTypesTableTableManager get assetTypes =>
      $$AssetTypesTableTableManager(_db, _db.assetTypes);
  $$AssetsTableTableManager get assets =>
      $$AssetsTableTableManager(_db, _db.assets);
  $$CardPrintingsTableTableManager get cardPrintings =>
      $$CardPrintingsTableTableManager(_db, _db.cardPrintings);
  $$CatalogMetaTableTableManager get catalogMeta =>
      $$CatalogMetaTableTableManager(_db, _db.catalogMeta);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
  $$InstalledDomainPacksTableTableManager get installedDomainPacks =>
      $$InstalledDomainPacksTableTableManager(_db, _db.installedDomainPacks);
  $$PackAttributeDefinitionsTableTableManager get packAttributeDefinitions =>
      $$PackAttributeDefinitionsTableTableManager(
        _db,
        _db.packAttributeDefinitions,
      );
  $$PackControlledValuesTableTableManager get packControlledValues =>
      $$PackControlledValuesTableTableManager(_db, _db.packControlledValues);
}
