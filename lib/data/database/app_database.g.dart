// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VehiclesTable extends Vehicles with TableInfo<$VehiclesTable, Vehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<VehicleType, String> vehicleType =
      GeneratedColumn<String>(
        'vehicle_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<VehicleType>($VehiclesTable.$convertervehicleType);
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _makeMeta = const VerificationMeta('make');
  @override
  late final GeneratedColumn<String> make = GeneratedColumn<String>(
    'make',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _engineMeta = const VerificationMeta('engine');
  @override
  late final GeneratedColumn<String> engine = GeneratedColumn<String>(
    'engine',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FuelType, String> fuelType =
      GeneratedColumn<String>(
        'fuel_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FuelType>($VehiclesTable.$converterfuelType);
  static const VerificationMeta _currentKmMeta = const VerificationMeta(
    'currentKm',
  );
  @override
  late final GeneratedColumn<int> currentKm = GeneratedColumn<int>(
    'current_km',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _coverPhotoIdMeta = const VerificationMeta(
    'coverPhotoId',
  );
  @override
  late final GeneratedColumn<String> coverPhotoId = GeneratedColumn<String>(
    'cover_photo_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plateMeta = const VerificationMeta('plate');
  @override
  late final GeneratedColumn<String> plate = GeneratedColumn<String>(
    'plate',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _projectBudgetCentsMeta =
      const VerificationMeta('projectBudgetCents');
  @override
  late final GeneratedColumn<int> projectBudgetCents = GeneratedColumn<int>(
    'project_budget_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    vehicleType,
    nickname,
    make,
    model,
    version,
    year,
    engine,
    fuelType,
    currentKm,
    coverPhotoId,
    plate,
    projectBudgetCents,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vehicle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('make')) {
      context.handle(
        _makeMeta,
        make.isAcceptableOrUnknown(data['make']!, _makeMeta),
      );
    } else if (isInserting) {
      context.missing(_makeMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('engine')) {
      context.handle(
        _engineMeta,
        engine.isAcceptableOrUnknown(data['engine']!, _engineMeta),
      );
    }
    if (data.containsKey('current_km')) {
      context.handle(
        _currentKmMeta,
        currentKm.isAcceptableOrUnknown(data['current_km']!, _currentKmMeta),
      );
    }
    if (data.containsKey('cover_photo_id')) {
      context.handle(
        _coverPhotoIdMeta,
        coverPhotoId.isAcceptableOrUnknown(
          data['cover_photo_id']!,
          _coverPhotoIdMeta,
        ),
      );
    }
    if (data.containsKey('plate')) {
      context.handle(
        _plateMeta,
        plate.isAcceptableOrUnknown(data['plate']!, _plateMeta),
      );
    }
    if (data.containsKey('project_budget_cents')) {
      context.handle(
        _projectBudgetCentsMeta,
        projectBudgetCents.isAcceptableOrUnknown(
          data['project_budget_cents']!,
          _projectBudgetCentsMeta,
        ),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehicle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      vehicleType: $VehiclesTable.$convertervehicleType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}vehicle_type'],
        )!,
      ),
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      make: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}make'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      engine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}engine'],
      ),
      fuelType: $VehiclesTable.$converterfuelType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}fuel_type'],
        )!,
      ),
      currentKm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_km'],
      )!,
      coverPhotoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_photo_id'],
      ),
      plate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plate'],
      ),
      projectBudgetCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_budget_cents'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<VehicleType, String, String> $convertervehicleType =
      const EnumNameConverter<VehicleType>(VehicleType.values);
  static JsonTypeConverter2<FuelType, String, String> $converterfuelType =
      const EnumNameConverter<FuelType>(FuelType.values);
}

class Vehicle extends DataClass implements Insertable<Vehicle> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final VehicleType vehicleType;
  final String nickname;
  final String make;
  final String model;
  final String? version;
  final int? year;
  final String? engine;
  final FuelType fuelType;
  final int currentKm;

  /// No FK: attachments table arrives in M1c.
  final String? coverPhotoId;
  final String? plate;
  final int? projectBudgetCents;
  final DateTime? archivedAt;
  const Vehicle({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.vehicleType,
    required this.nickname,
    required this.make,
    required this.model,
    this.version,
    this.year,
    this.engine,
    required this.fuelType,
    required this.currentKm,
    this.coverPhotoId,
    this.plate,
    this.projectBudgetCents,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['vehicle_type'] = Variable<String>(
        $VehiclesTable.$convertervehicleType.toSql(vehicleType),
      );
    }
    map['nickname'] = Variable<String>(nickname);
    map['make'] = Variable<String>(make);
    map['model'] = Variable<String>(model);
    if (!nullToAbsent || version != null) {
      map['version'] = Variable<String>(version);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || engine != null) {
      map['engine'] = Variable<String>(engine);
    }
    {
      map['fuel_type'] = Variable<String>(
        $VehiclesTable.$converterfuelType.toSql(fuelType),
      );
    }
    map['current_km'] = Variable<int>(currentKm);
    if (!nullToAbsent || coverPhotoId != null) {
      map['cover_photo_id'] = Variable<String>(coverPhotoId);
    }
    if (!nullToAbsent || plate != null) {
      map['plate'] = Variable<String>(plate);
    }
    if (!nullToAbsent || projectBudgetCents != null) {
      map['project_budget_cents'] = Variable<int>(projectBudgetCents);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      vehicleType: Value(vehicleType),
      nickname: Value(nickname),
      make: Value(make),
      model: Value(model),
      version: version == null && nullToAbsent
          ? const Value.absent()
          : Value(version),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      engine: engine == null && nullToAbsent
          ? const Value.absent()
          : Value(engine),
      fuelType: Value(fuelType),
      currentKm: Value(currentKm),
      coverPhotoId: coverPhotoId == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPhotoId),
      plate: plate == null && nullToAbsent
          ? const Value.absent()
          : Value(plate),
      projectBudgetCents: projectBudgetCents == null && nullToAbsent
          ? const Value.absent()
          : Value(projectBudgetCents),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory Vehicle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehicle(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      vehicleType: $VehiclesTable.$convertervehicleType.fromJson(
        serializer.fromJson<String>(json['vehicleType']),
      ),
      nickname: serializer.fromJson<String>(json['nickname']),
      make: serializer.fromJson<String>(json['make']),
      model: serializer.fromJson<String>(json['model']),
      version: serializer.fromJson<String?>(json['version']),
      year: serializer.fromJson<int?>(json['year']),
      engine: serializer.fromJson<String?>(json['engine']),
      fuelType: $VehiclesTable.$converterfuelType.fromJson(
        serializer.fromJson<String>(json['fuelType']),
      ),
      currentKm: serializer.fromJson<int>(json['currentKm']),
      coverPhotoId: serializer.fromJson<String?>(json['coverPhotoId']),
      plate: serializer.fromJson<String?>(json['plate']),
      projectBudgetCents: serializer.fromJson<int?>(json['projectBudgetCents']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'vehicleType': serializer.toJson<String>(
        $VehiclesTable.$convertervehicleType.toJson(vehicleType),
      ),
      'nickname': serializer.toJson<String>(nickname),
      'make': serializer.toJson<String>(make),
      'model': serializer.toJson<String>(model),
      'version': serializer.toJson<String?>(version),
      'year': serializer.toJson<int?>(year),
      'engine': serializer.toJson<String?>(engine),
      'fuelType': serializer.toJson<String>(
        $VehiclesTable.$converterfuelType.toJson(fuelType),
      ),
      'currentKm': serializer.toJson<int>(currentKm),
      'coverPhotoId': serializer.toJson<String?>(coverPhotoId),
      'plate': serializer.toJson<String?>(plate),
      'projectBudgetCents': serializer.toJson<int?>(projectBudgetCents),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  Vehicle copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    VehicleType? vehicleType,
    String? nickname,
    String? make,
    String? model,
    Value<String?> version = const Value.absent(),
    Value<int?> year = const Value.absent(),
    Value<String?> engine = const Value.absent(),
    FuelType? fuelType,
    int? currentKm,
    Value<String?> coverPhotoId = const Value.absent(),
    Value<String?> plate = const Value.absent(),
    Value<int?> projectBudgetCents = const Value.absent(),
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => Vehicle(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    vehicleType: vehicleType ?? this.vehicleType,
    nickname: nickname ?? this.nickname,
    make: make ?? this.make,
    model: model ?? this.model,
    version: version.present ? version.value : this.version,
    year: year.present ? year.value : this.year,
    engine: engine.present ? engine.value : this.engine,
    fuelType: fuelType ?? this.fuelType,
    currentKm: currentKm ?? this.currentKm,
    coverPhotoId: coverPhotoId.present ? coverPhotoId.value : this.coverPhotoId,
    plate: plate.present ? plate.value : this.plate,
    projectBudgetCents: projectBudgetCents.present
        ? projectBudgetCents.value
        : this.projectBudgetCents,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  Vehicle copyWithCompanion(VehiclesCompanion data) {
    return Vehicle(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      vehicleType: data.vehicleType.present
          ? data.vehicleType.value
          : this.vehicleType,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      make: data.make.present ? data.make.value : this.make,
      model: data.model.present ? data.model.value : this.model,
      version: data.version.present ? data.version.value : this.version,
      year: data.year.present ? data.year.value : this.year,
      engine: data.engine.present ? data.engine.value : this.engine,
      fuelType: data.fuelType.present ? data.fuelType.value : this.fuelType,
      currentKm: data.currentKm.present ? data.currentKm.value : this.currentKm,
      coverPhotoId: data.coverPhotoId.present
          ? data.coverPhotoId.value
          : this.coverPhotoId,
      plate: data.plate.present ? data.plate.value : this.plate,
      projectBudgetCents: data.projectBudgetCents.present
          ? data.projectBudgetCents.value
          : this.projectBudgetCents,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehicle(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('vehicleType: $vehicleType, ')
          ..write('nickname: $nickname, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('version: $version, ')
          ..write('year: $year, ')
          ..write('engine: $engine, ')
          ..write('fuelType: $fuelType, ')
          ..write('currentKm: $currentKm, ')
          ..write('coverPhotoId: $coverPhotoId, ')
          ..write('plate: $plate, ')
          ..write('projectBudgetCents: $projectBudgetCents, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    vehicleType,
    nickname,
    make,
    model,
    version,
    year,
    engine,
    fuelType,
    currentKm,
    coverPhotoId,
    plate,
    projectBudgetCents,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehicle &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.vehicleType == this.vehicleType &&
          other.nickname == this.nickname &&
          other.make == this.make &&
          other.model == this.model &&
          other.version == this.version &&
          other.year == this.year &&
          other.engine == this.engine &&
          other.fuelType == this.fuelType &&
          other.currentKm == this.currentKm &&
          other.coverPhotoId == this.coverPhotoId &&
          other.plate == this.plate &&
          other.projectBudgetCents == this.projectBudgetCents &&
          other.archivedAt == this.archivedAt);
}

class VehiclesCompanion extends UpdateCompanion<Vehicle> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<VehicleType> vehicleType;
  final Value<String> nickname;
  final Value<String> make;
  final Value<String> model;
  final Value<String?> version;
  final Value<int?> year;
  final Value<String?> engine;
  final Value<FuelType> fuelType;
  final Value<int> currentKm;
  final Value<String?> coverPhotoId;
  final Value<String?> plate;
  final Value<int?> projectBudgetCents;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.vehicleType = const Value.absent(),
    this.nickname = const Value.absent(),
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.version = const Value.absent(),
    this.year = const Value.absent(),
    this.engine = const Value.absent(),
    this.fuelType = const Value.absent(),
    this.currentKm = const Value.absent(),
    this.coverPhotoId = const Value.absent(),
    this.plate = const Value.absent(),
    this.projectBudgetCents = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehiclesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    required VehicleType vehicleType,
    required String nickname,
    required String make,
    required String model,
    this.version = const Value.absent(),
    this.year = const Value.absent(),
    this.engine = const Value.absent(),
    required FuelType fuelType,
    this.currentKm = const Value.absent(),
    this.coverPhotoId = const Value.absent(),
    this.plate = const Value.absent(),
    this.projectBudgetCents = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       vehicleType = Value(vehicleType),
       nickname = Value(nickname),
       make = Value(make),
       model = Value(model),
       fuelType = Value(fuelType);
  static Insertable<Vehicle> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? vehicleType,
    Expression<String>? nickname,
    Expression<String>? make,
    Expression<String>? model,
    Expression<String>? version,
    Expression<int>? year,
    Expression<String>? engine,
    Expression<String>? fuelType,
    Expression<int>? currentKm,
    Expression<String>? coverPhotoId,
    Expression<String>? plate,
    Expression<int>? projectBudgetCents,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (vehicleType != null) 'vehicle_type': vehicleType,
      if (nickname != null) 'nickname': nickname,
      if (make != null) 'make': make,
      if (model != null) 'model': model,
      if (version != null) 'version': version,
      if (year != null) 'year': year,
      if (engine != null) 'engine': engine,
      if (fuelType != null) 'fuel_type': fuelType,
      if (currentKm != null) 'current_km': currentKm,
      if (coverPhotoId != null) 'cover_photo_id': coverPhotoId,
      if (plate != null) 'plate': plate,
      if (projectBudgetCents != null)
        'project_budget_cents': projectBudgetCents,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehiclesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<VehicleType>? vehicleType,
    Value<String>? nickname,
    Value<String>? make,
    Value<String>? model,
    Value<String?>? version,
    Value<int?>? year,
    Value<String?>? engine,
    Value<FuelType>? fuelType,
    Value<int>? currentKm,
    Value<String?>? coverPhotoId,
    Value<String?>? plate,
    Value<int?>? projectBudgetCents,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return VehiclesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      vehicleType: vehicleType ?? this.vehicleType,
      nickname: nickname ?? this.nickname,
      make: make ?? this.make,
      model: model ?? this.model,
      version: version ?? this.version,
      year: year ?? this.year,
      engine: engine ?? this.engine,
      fuelType: fuelType ?? this.fuelType,
      currentKm: currentKm ?? this.currentKm,
      coverPhotoId: coverPhotoId ?? this.coverPhotoId,
      plate: plate ?? this.plate,
      projectBudgetCents: projectBudgetCents ?? this.projectBudgetCents,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (vehicleType.present) {
      map['vehicle_type'] = Variable<String>(
        $VehiclesTable.$convertervehicleType.toSql(vehicleType.value),
      );
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (make.present) {
      map['make'] = Variable<String>(make.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (engine.present) {
      map['engine'] = Variable<String>(engine.value);
    }
    if (fuelType.present) {
      map['fuel_type'] = Variable<String>(
        $VehiclesTable.$converterfuelType.toSql(fuelType.value),
      );
    }
    if (currentKm.present) {
      map['current_km'] = Variable<int>(currentKm.value);
    }
    if (coverPhotoId.present) {
      map['cover_photo_id'] = Variable<String>(coverPhotoId.value);
    }
    if (plate.present) {
      map['plate'] = Variable<String>(plate.value);
    }
    if (projectBudgetCents.present) {
      map['project_budget_cents'] = Variable<int>(projectBudgetCents.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('vehicleType: $vehicleType, ')
          ..write('nickname: $nickname, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('version: $version, ')
          ..write('year: $year, ')
          ..write('engine: $engine, ')
          ..write('fuelType: $fuelType, ')
          ..write('currentKm: $currentKm, ')
          ..write('coverPhotoId: $coverPhotoId, ')
          ..write('plate: $plate, ')
          ..write('projectBudgetCents: $projectBudgetCents, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModificationsTable extends Modifications
    with TableInfo<$ModificationsTable, Modification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ModCategory, String> category =
      GeneratedColumn<String>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ModCategory>($ModificationsTable.$convertercategory);
  @override
  late final GeneratedColumnWithTypeConverter<ModificationStatus, String>
  status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ModificationStatus>($ModificationsTable.$converterstatus);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kmMeta = const VerificationMeta('km');
  @override
  late final GeneratedColumn<int> km = GeneratedColumn<int>(
    'km',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _laborCostCentsMeta = const VerificationMeta(
    'laborCostCents',
  );
  @override
  late final GeneratedColumn<int> laborCostCents = GeneratedColumn<int>(
    'labor_cost_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _laborByMeta = const VerificationMeta(
    'laborBy',
  );
  @override
  late final GeneratedColumn<String> laborBy = GeneratedColumn<String>(
    'labor_by',
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
  static const VerificationMeta _performanceNotesMeta = const VerificationMeta(
    'performanceNotes',
  );
  @override
  late final GeneratedColumn<String> performanceNotes = GeneratedColumn<String>(
    'performance_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimatedCostCentsMeta =
      const VerificationMeta('estimatedCostCents');
  @override
  late final GeneratedColumn<int> estimatedCostCents = GeneratedColumn<int>(
    'estimated_cost_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requiresRegularizationMeta =
      const VerificationMeta('requiresRegularization');
  @override
  late final GeneratedColumn<bool> requiresRegularization =
      GeneratedColumn<bool>(
        'requires_regularization',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("requires_regularization" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  late final GeneratedColumnWithTypeConverter<RegularizationStatus?, String>
  regularizationStatus =
      GeneratedColumn<String>(
        'regularization_status',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<RegularizationStatus?>(
        $ModificationsTable.$converterregularizationStatusn,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    vehicleId,
    title,
    category,
    status,
    date,
    km,
    laborCostCents,
    laborBy,
    notes,
    performanceNotes,
    estimatedCostCents,
    requiresRegularization,
    regularizationStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'modifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<Modification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('km')) {
      context.handle(_kmMeta, km.isAcceptableOrUnknown(data['km']!, _kmMeta));
    }
    if (data.containsKey('labor_cost_cents')) {
      context.handle(
        _laborCostCentsMeta,
        laborCostCents.isAcceptableOrUnknown(
          data['labor_cost_cents']!,
          _laborCostCentsMeta,
        ),
      );
    }
    if (data.containsKey('labor_by')) {
      context.handle(
        _laborByMeta,
        laborBy.isAcceptableOrUnknown(data['labor_by']!, _laborByMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('performance_notes')) {
      context.handle(
        _performanceNotesMeta,
        performanceNotes.isAcceptableOrUnknown(
          data['performance_notes']!,
          _performanceNotesMeta,
        ),
      );
    }
    if (data.containsKey('estimated_cost_cents')) {
      context.handle(
        _estimatedCostCentsMeta,
        estimatedCostCents.isAcceptableOrUnknown(
          data['estimated_cost_cents']!,
          _estimatedCostCentsMeta,
        ),
      );
    }
    if (data.containsKey('requires_regularization')) {
      context.handle(
        _requiresRegularizationMeta,
        requiresRegularization.isAcceptableOrUnknown(
          data['requires_regularization']!,
          _requiresRegularizationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Modification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Modification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: $ModificationsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      status: $ModificationsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      km: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}km'],
      ),
      laborCostCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}labor_cost_cents'],
      )!,
      laborBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}labor_by'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      performanceNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}performance_notes'],
      ),
      estimatedCostCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_cost_cents'],
      ),
      requiresRegularization: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_regularization'],
      )!,
      regularizationStatus: $ModificationsTable.$converterregularizationStatusn
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}regularization_status'],
            ),
          ),
    );
  }

  @override
  $ModificationsTable createAlias(String alias) {
    return $ModificationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ModCategory, String, String> $convertercategory =
      const EnumNameConverter<ModCategory>(ModCategory.values);
  static JsonTypeConverter2<ModificationStatus, String, String>
  $converterstatus = const EnumNameConverter<ModificationStatus>(
    ModificationStatus.values,
  );
  static JsonTypeConverter2<RegularizationStatus, String, String>
  $converterregularizationStatus =
      const EnumNameConverter<RegularizationStatus>(
        RegularizationStatus.values,
      );
  static JsonTypeConverter2<RegularizationStatus?, String?, String?>
  $converterregularizationStatusn = JsonTypeConverter2.asNullable(
    $converterregularizationStatus,
  );
}

class Modification extends DataClass implements Insertable<Modification> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String vehicleId;
  final String title;
  final ModCategory category;
  final ModificationStatus status;
  final DateTime date;
  final int? km;
  final int laborCostCents;
  final String? laborBy;
  final String? notes;
  final String? performanceNotes;
  final int? estimatedCostCents;
  final bool requiresRegularization;
  final RegularizationStatus? regularizationStatus;
  const Modification({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.vehicleId,
    required this.title,
    required this.category,
    required this.status,
    required this.date,
    this.km,
    required this.laborCostCents,
    this.laborBy,
    this.notes,
    this.performanceNotes,
    this.estimatedCostCents,
    required this.requiresRegularization,
    this.regularizationStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['title'] = Variable<String>(title);
    {
      map['category'] = Variable<String>(
        $ModificationsTable.$convertercategory.toSql(category),
      );
    }
    {
      map['status'] = Variable<String>(
        $ModificationsTable.$converterstatus.toSql(status),
      );
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || km != null) {
      map['km'] = Variable<int>(km);
    }
    map['labor_cost_cents'] = Variable<int>(laborCostCents);
    if (!nullToAbsent || laborBy != null) {
      map['labor_by'] = Variable<String>(laborBy);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || performanceNotes != null) {
      map['performance_notes'] = Variable<String>(performanceNotes);
    }
    if (!nullToAbsent || estimatedCostCents != null) {
      map['estimated_cost_cents'] = Variable<int>(estimatedCostCents);
    }
    map['requires_regularization'] = Variable<bool>(requiresRegularization);
    if (!nullToAbsent || regularizationStatus != null) {
      map['regularization_status'] = Variable<String>(
        $ModificationsTable.$converterregularizationStatusn.toSql(
          regularizationStatus,
        ),
      );
    }
    return map;
  }

  ModificationsCompanion toCompanion(bool nullToAbsent) {
    return ModificationsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      vehicleId: Value(vehicleId),
      title: Value(title),
      category: Value(category),
      status: Value(status),
      date: Value(date),
      km: km == null && nullToAbsent ? const Value.absent() : Value(km),
      laborCostCents: Value(laborCostCents),
      laborBy: laborBy == null && nullToAbsent
          ? const Value.absent()
          : Value(laborBy),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      performanceNotes: performanceNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(performanceNotes),
      estimatedCostCents: estimatedCostCents == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedCostCents),
      requiresRegularization: Value(requiresRegularization),
      regularizationStatus: regularizationStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(regularizationStatus),
    );
  }

  factory Modification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Modification(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      title: serializer.fromJson<String>(json['title']),
      category: $ModificationsTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      status: $ModificationsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      date: serializer.fromJson<DateTime>(json['date']),
      km: serializer.fromJson<int?>(json['km']),
      laborCostCents: serializer.fromJson<int>(json['laborCostCents']),
      laborBy: serializer.fromJson<String?>(json['laborBy']),
      notes: serializer.fromJson<String?>(json['notes']),
      performanceNotes: serializer.fromJson<String?>(json['performanceNotes']),
      estimatedCostCents: serializer.fromJson<int?>(json['estimatedCostCents']),
      requiresRegularization: serializer.fromJson<bool>(
        json['requiresRegularization'],
      ),
      regularizationStatus: $ModificationsTable.$converterregularizationStatusn
          .fromJson(serializer.fromJson<String?>(json['regularizationStatus'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(
        $ModificationsTable.$convertercategory.toJson(category),
      ),
      'status': serializer.toJson<String>(
        $ModificationsTable.$converterstatus.toJson(status),
      ),
      'date': serializer.toJson<DateTime>(date),
      'km': serializer.toJson<int?>(km),
      'laborCostCents': serializer.toJson<int>(laborCostCents),
      'laborBy': serializer.toJson<String?>(laborBy),
      'notes': serializer.toJson<String?>(notes),
      'performanceNotes': serializer.toJson<String?>(performanceNotes),
      'estimatedCostCents': serializer.toJson<int?>(estimatedCostCents),
      'requiresRegularization': serializer.toJson<bool>(requiresRegularization),
      'regularizationStatus': serializer.toJson<String?>(
        $ModificationsTable.$converterregularizationStatusn.toJson(
          regularizationStatus,
        ),
      ),
    };
  }

  Modification copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? vehicleId,
    String? title,
    ModCategory? category,
    ModificationStatus? status,
    DateTime? date,
    Value<int?> km = const Value.absent(),
    int? laborCostCents,
    Value<String?> laborBy = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> performanceNotes = const Value.absent(),
    Value<int?> estimatedCostCents = const Value.absent(),
    bool? requiresRegularization,
    Value<RegularizationStatus?> regularizationStatus = const Value.absent(),
  }) => Modification(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    vehicleId: vehicleId ?? this.vehicleId,
    title: title ?? this.title,
    category: category ?? this.category,
    status: status ?? this.status,
    date: date ?? this.date,
    km: km.present ? km.value : this.km,
    laborCostCents: laborCostCents ?? this.laborCostCents,
    laborBy: laborBy.present ? laborBy.value : this.laborBy,
    notes: notes.present ? notes.value : this.notes,
    performanceNotes: performanceNotes.present
        ? performanceNotes.value
        : this.performanceNotes,
    estimatedCostCents: estimatedCostCents.present
        ? estimatedCostCents.value
        : this.estimatedCostCents,
    requiresRegularization:
        requiresRegularization ?? this.requiresRegularization,
    regularizationStatus: regularizationStatus.present
        ? regularizationStatus.value
        : this.regularizationStatus,
  );
  Modification copyWithCompanion(ModificationsCompanion data) {
    return Modification(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      status: data.status.present ? data.status.value : this.status,
      date: data.date.present ? data.date.value : this.date,
      km: data.km.present ? data.km.value : this.km,
      laborCostCents: data.laborCostCents.present
          ? data.laborCostCents.value
          : this.laborCostCents,
      laborBy: data.laborBy.present ? data.laborBy.value : this.laborBy,
      notes: data.notes.present ? data.notes.value : this.notes,
      performanceNotes: data.performanceNotes.present
          ? data.performanceNotes.value
          : this.performanceNotes,
      estimatedCostCents: data.estimatedCostCents.present
          ? data.estimatedCostCents.value
          : this.estimatedCostCents,
      requiresRegularization: data.requiresRegularization.present
          ? data.requiresRegularization.value
          : this.requiresRegularization,
      regularizationStatus: data.regularizationStatus.present
          ? data.regularizationStatus.value
          : this.regularizationStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Modification(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('km: $km, ')
          ..write('laborCostCents: $laborCostCents, ')
          ..write('laborBy: $laborBy, ')
          ..write('notes: $notes, ')
          ..write('performanceNotes: $performanceNotes, ')
          ..write('estimatedCostCents: $estimatedCostCents, ')
          ..write('requiresRegularization: $requiresRegularization, ')
          ..write('regularizationStatus: $regularizationStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    vehicleId,
    title,
    category,
    status,
    date,
    km,
    laborCostCents,
    laborBy,
    notes,
    performanceNotes,
    estimatedCostCents,
    requiresRegularization,
    regularizationStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Modification &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.vehicleId == this.vehicleId &&
          other.title == this.title &&
          other.category == this.category &&
          other.status == this.status &&
          other.date == this.date &&
          other.km == this.km &&
          other.laborCostCents == this.laborCostCents &&
          other.laborBy == this.laborBy &&
          other.notes == this.notes &&
          other.performanceNotes == this.performanceNotes &&
          other.estimatedCostCents == this.estimatedCostCents &&
          other.requiresRegularization == this.requiresRegularization &&
          other.regularizationStatus == this.regularizationStatus);
}

class ModificationsCompanion extends UpdateCompanion<Modification> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> vehicleId;
  final Value<String> title;
  final Value<ModCategory> category;
  final Value<ModificationStatus> status;
  final Value<DateTime> date;
  final Value<int?> km;
  final Value<int> laborCostCents;
  final Value<String?> laborBy;
  final Value<String?> notes;
  final Value<String?> performanceNotes;
  final Value<int?> estimatedCostCents;
  final Value<bool> requiresRegularization;
  final Value<RegularizationStatus?> regularizationStatus;
  final Value<int> rowid;
  const ModificationsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.status = const Value.absent(),
    this.date = const Value.absent(),
    this.km = const Value.absent(),
    this.laborCostCents = const Value.absent(),
    this.laborBy = const Value.absent(),
    this.notes = const Value.absent(),
    this.performanceNotes = const Value.absent(),
    this.estimatedCostCents = const Value.absent(),
    this.requiresRegularization = const Value.absent(),
    this.regularizationStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModificationsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    required String vehicleId,
    required String title,
    required ModCategory category,
    required ModificationStatus status,
    required DateTime date,
    this.km = const Value.absent(),
    this.laborCostCents = const Value.absent(),
    this.laborBy = const Value.absent(),
    this.notes = const Value.absent(),
    this.performanceNotes = const Value.absent(),
    this.estimatedCostCents = const Value.absent(),
    this.requiresRegularization = const Value.absent(),
    this.regularizationStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       vehicleId = Value(vehicleId),
       title = Value(title),
       category = Value(category),
       status = Value(status),
       date = Value(date);
  static Insertable<Modification> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? vehicleId,
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? status,
    Expression<DateTime>? date,
    Expression<int>? km,
    Expression<int>? laborCostCents,
    Expression<String>? laborBy,
    Expression<String>? notes,
    Expression<String>? performanceNotes,
    Expression<int>? estimatedCostCents,
    Expression<bool>? requiresRegularization,
    Expression<String>? regularizationStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (status != null) 'status': status,
      if (date != null) 'date': date,
      if (km != null) 'km': km,
      if (laborCostCents != null) 'labor_cost_cents': laborCostCents,
      if (laborBy != null) 'labor_by': laborBy,
      if (notes != null) 'notes': notes,
      if (performanceNotes != null) 'performance_notes': performanceNotes,
      if (estimatedCostCents != null)
        'estimated_cost_cents': estimatedCostCents,
      if (requiresRegularization != null)
        'requires_regularization': requiresRegularization,
      if (regularizationStatus != null)
        'regularization_status': regularizationStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModificationsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? vehicleId,
    Value<String>? title,
    Value<ModCategory>? category,
    Value<ModificationStatus>? status,
    Value<DateTime>? date,
    Value<int?>? km,
    Value<int>? laborCostCents,
    Value<String?>? laborBy,
    Value<String?>? notes,
    Value<String?>? performanceNotes,
    Value<int?>? estimatedCostCents,
    Value<bool>? requiresRegularization,
    Value<RegularizationStatus?>? regularizationStatus,
    Value<int>? rowid,
  }) {
    return ModificationsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      vehicleId: vehicleId ?? this.vehicleId,
      title: title ?? this.title,
      category: category ?? this.category,
      status: status ?? this.status,
      date: date ?? this.date,
      km: km ?? this.km,
      laborCostCents: laborCostCents ?? this.laborCostCents,
      laborBy: laborBy ?? this.laborBy,
      notes: notes ?? this.notes,
      performanceNotes: performanceNotes ?? this.performanceNotes,
      estimatedCostCents: estimatedCostCents ?? this.estimatedCostCents,
      requiresRegularization:
          requiresRegularization ?? this.requiresRegularization,
      regularizationStatus: regularizationStatus ?? this.regularizationStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $ModificationsTable.$convertercategory.toSql(category.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ModificationsTable.$converterstatus.toSql(status.value),
      );
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (km.present) {
      map['km'] = Variable<int>(km.value);
    }
    if (laborCostCents.present) {
      map['labor_cost_cents'] = Variable<int>(laborCostCents.value);
    }
    if (laborBy.present) {
      map['labor_by'] = Variable<String>(laborBy.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (performanceNotes.present) {
      map['performance_notes'] = Variable<String>(performanceNotes.value);
    }
    if (estimatedCostCents.present) {
      map['estimated_cost_cents'] = Variable<int>(estimatedCostCents.value);
    }
    if (requiresRegularization.present) {
      map['requires_regularization'] = Variable<bool>(
        requiresRegularization.value,
      );
    }
    if (regularizationStatus.present) {
      map['regularization_status'] = Variable<String>(
        $ModificationsTable.$converterregularizationStatusn.toSql(
          regularizationStatus.value,
        ),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModificationsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('km: $km, ')
          ..write('laborCostCents: $laborCostCents, ')
          ..write('laborBy: $laborBy, ')
          ..write('notes: $notes, ')
          ..write('performanceNotes: $performanceNotes, ')
          ..write('estimatedCostCents: $estimatedCostCents, ')
          ..write('requiresRegularization: $requiresRegularization, ')
          ..write('regularizationStatus: $regularizationStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceRecordsTable extends MaintenanceRecords
    with TableInfo<$MaintenanceRecordsTable, MaintenanceRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<MaintenanceType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MaintenanceType>($MaintenanceRecordsTable.$convertertype);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kmMeta = const VerificationMeta('km');
  @override
  late final GeneratedColumn<int> km = GeneratedColumn<int>(
    'km',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _laborCostCentsMeta = const VerificationMeta(
    'laborCostCents',
  );
  @override
  late final GeneratedColumn<int> laborCostCents = GeneratedColumn<int>(
    'labor_cost_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _laborByMeta = const VerificationMeta(
    'laborBy',
  );
  @override
  late final GeneratedColumn<String> laborBy = GeneratedColumn<String>(
    'labor_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeMeta = const VerificationMeta('place');
  @override
  late final GeneratedColumn<String> place = GeneratedColumn<String>(
    'place',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    vehicleId,
    type,
    date,
    km,
    laborCostCents,
    laborBy,
    place,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaintenanceRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('km')) {
      context.handle(_kmMeta, km.isAcceptableOrUnknown(data['km']!, _kmMeta));
    }
    if (data.containsKey('labor_cost_cents')) {
      context.handle(
        _laborCostCentsMeta,
        laborCostCents.isAcceptableOrUnknown(
          data['labor_cost_cents']!,
          _laborCostCentsMeta,
        ),
      );
    }
    if (data.containsKey('labor_by')) {
      context.handle(
        _laborByMeta,
        laborBy.isAcceptableOrUnknown(data['labor_by']!, _laborByMeta),
      );
    }
    if (data.containsKey('place')) {
      context.handle(
        _placeMeta,
        place.isAcceptableOrUnknown(data['place']!, _placeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      type: $MaintenanceRecordsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      km: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}km'],
      ),
      laborCostCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}labor_cost_cents'],
      )!,
      laborBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}labor_by'],
      ),
      place: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $MaintenanceRecordsTable createAlias(String alias) {
    return $MaintenanceRecordsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MaintenanceType, String, String> $convertertype =
      const EnumNameConverter<MaintenanceType>(MaintenanceType.values);
}

class MaintenanceRecord extends DataClass
    implements Insertable<MaintenanceRecord> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String vehicleId;
  final MaintenanceType type;
  final DateTime date;
  final int? km;
  final int laborCostCents;
  final String? laborBy;
  final String? place;
  final String? notes;
  const MaintenanceRecord({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.vehicleId,
    required this.type,
    required this.date,
    this.km,
    required this.laborCostCents,
    this.laborBy,
    this.place,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['vehicle_id'] = Variable<String>(vehicleId);
    {
      map['type'] = Variable<String>(
        $MaintenanceRecordsTable.$convertertype.toSql(type),
      );
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || km != null) {
      map['km'] = Variable<int>(km);
    }
    map['labor_cost_cents'] = Variable<int>(laborCostCents);
    if (!nullToAbsent || laborBy != null) {
      map['labor_by'] = Variable<String>(laborBy);
    }
    if (!nullToAbsent || place != null) {
      map['place'] = Variable<String>(place);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  MaintenanceRecordsCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceRecordsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      vehicleId: Value(vehicleId),
      type: Value(type),
      date: Value(date),
      km: km == null && nullToAbsent ? const Value.absent() : Value(km),
      laborCostCents: Value(laborCostCents),
      laborBy: laborBy == null && nullToAbsent
          ? const Value.absent()
          : Value(laborBy),
      place: place == null && nullToAbsent
          ? const Value.absent()
          : Value(place),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory MaintenanceRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceRecord(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      type: $MaintenanceRecordsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      date: serializer.fromJson<DateTime>(json['date']),
      km: serializer.fromJson<int?>(json['km']),
      laborCostCents: serializer.fromJson<int>(json['laborCostCents']),
      laborBy: serializer.fromJson<String?>(json['laborBy']),
      place: serializer.fromJson<String?>(json['place']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'type': serializer.toJson<String>(
        $MaintenanceRecordsTable.$convertertype.toJson(type),
      ),
      'date': serializer.toJson<DateTime>(date),
      'km': serializer.toJson<int?>(km),
      'laborCostCents': serializer.toJson<int>(laborCostCents),
      'laborBy': serializer.toJson<String?>(laborBy),
      'place': serializer.toJson<String?>(place),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  MaintenanceRecord copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? vehicleId,
    MaintenanceType? type,
    DateTime? date,
    Value<int?> km = const Value.absent(),
    int? laborCostCents,
    Value<String?> laborBy = const Value.absent(),
    Value<String?> place = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => MaintenanceRecord(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    vehicleId: vehicleId ?? this.vehicleId,
    type: type ?? this.type,
    date: date ?? this.date,
    km: km.present ? km.value : this.km,
    laborCostCents: laborCostCents ?? this.laborCostCents,
    laborBy: laborBy.present ? laborBy.value : this.laborBy,
    place: place.present ? place.value : this.place,
    notes: notes.present ? notes.value : this.notes,
  );
  MaintenanceRecord copyWithCompanion(MaintenanceRecordsCompanion data) {
    return MaintenanceRecord(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      type: data.type.present ? data.type.value : this.type,
      date: data.date.present ? data.date.value : this.date,
      km: data.km.present ? data.km.value : this.km,
      laborCostCents: data.laborCostCents.present
          ? data.laborCostCents.value
          : this.laborCostCents,
      laborBy: data.laborBy.present ? data.laborBy.value : this.laborBy,
      place: data.place.present ? data.place.value : this.place,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceRecord(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('km: $km, ')
          ..write('laborCostCents: $laborCostCents, ')
          ..write('laborBy: $laborBy, ')
          ..write('place: $place, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    vehicleId,
    type,
    date,
    km,
    laborCostCents,
    laborBy,
    place,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceRecord &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.vehicleId == this.vehicleId &&
          other.type == this.type &&
          other.date == this.date &&
          other.km == this.km &&
          other.laborCostCents == this.laborCostCents &&
          other.laborBy == this.laborBy &&
          other.place == this.place &&
          other.notes == this.notes);
}

class MaintenanceRecordsCompanion extends UpdateCompanion<MaintenanceRecord> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> vehicleId;
  final Value<MaintenanceType> type;
  final Value<DateTime> date;
  final Value<int?> km;
  final Value<int> laborCostCents;
  final Value<String?> laborBy;
  final Value<String?> place;
  final Value<String?> notes;
  final Value<int> rowid;
  const MaintenanceRecordsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.type = const Value.absent(),
    this.date = const Value.absent(),
    this.km = const Value.absent(),
    this.laborCostCents = const Value.absent(),
    this.laborBy = const Value.absent(),
    this.place = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaintenanceRecordsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    required String vehicleId,
    required MaintenanceType type,
    required DateTime date,
    this.km = const Value.absent(),
    this.laborCostCents = const Value.absent(),
    this.laborBy = const Value.absent(),
    this.place = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       vehicleId = Value(vehicleId),
       type = Value(type),
       date = Value(date);
  static Insertable<MaintenanceRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? vehicleId,
    Expression<String>? type,
    Expression<DateTime>? date,
    Expression<int>? km,
    Expression<int>? laborCostCents,
    Expression<String>? laborBy,
    Expression<String>? place,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (type != null) 'type': type,
      if (date != null) 'date': date,
      if (km != null) 'km': km,
      if (laborCostCents != null) 'labor_cost_cents': laborCostCents,
      if (laborBy != null) 'labor_by': laborBy,
      if (place != null) 'place': place,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaintenanceRecordsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? vehicleId,
    Value<MaintenanceType>? type,
    Value<DateTime>? date,
    Value<int?>? km,
    Value<int>? laborCostCents,
    Value<String?>? laborBy,
    Value<String?>? place,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return MaintenanceRecordsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      vehicleId: vehicleId ?? this.vehicleId,
      type: type ?? this.type,
      date: date ?? this.date,
      km: km ?? this.km,
      laborCostCents: laborCostCents ?? this.laborCostCents,
      laborBy: laborBy ?? this.laborBy,
      place: place ?? this.place,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $MaintenanceRecordsTable.$convertertype.toSql(type.value),
      );
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (km.present) {
      map['km'] = Variable<int>(km.value);
    }
    if (laborCostCents.present) {
      map['labor_cost_cents'] = Variable<int>(laborCostCents.value);
    }
    if (laborBy.present) {
      map['labor_by'] = Variable<String>(laborBy.value);
    }
    if (place.present) {
      map['place'] = Variable<String>(place.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('km: $km, ')
          ..write('laborCostCents: $laborCostCents, ')
          ..write('laborBy: $laborBy, ')
          ..write('place: $place, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LineItemsTable extends LineItems
    with TableInfo<$LineItemsTable, LineItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LineItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LineItemParent, String>
  parentType = GeneratedColumn<String>(
    'parent_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<LineItemParent>($LineItemsTable.$converterparentType);
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _partCodeMeta = const VerificationMeta(
    'partCode',
  );
  @override
  late final GeneratedColumn<String> partCode = GeneratedColumn<String>(
    'part_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _unitPriceCentsMeta = const VerificationMeta(
    'unitPriceCents',
  );
  @override
  late final GeneratedColumn<int> unitPriceCents = GeneratedColumn<int>(
    'unit_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    parentType,
    parentId,
    name,
    brand,
    partCode,
    quantity,
    unitPriceCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'line_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<LineItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_parentIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('part_code')) {
      context.handle(
        _partCodeMeta,
        partCode.isAcceptableOrUnknown(data['part_code']!, _partCodeMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit_price_cents')) {
      context.handle(
        _unitPriceCentsMeta,
        unitPriceCents.isAcceptableOrUnknown(
          data['unit_price_cents']!,
          _unitPriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPriceCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LineItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LineItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      parentType: $LineItemsTable.$converterparentType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}parent_type'],
        )!,
      ),
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      partCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_code'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unitPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_cents'],
      )!,
    );
  }

  @override
  $LineItemsTable createAlias(String alias) {
    return $LineItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LineItemParent, String, String>
  $converterparentType = const EnumNameConverter<LineItemParent>(
    LineItemParent.values,
  );
}

class LineItem extends DataClass implements Insertable<LineItem> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final LineItemParent parentType;

  /// Polymorphic (modification or maintenance): no FK.
  final String parentId;
  final String name;
  final String? brand;
  final String? partCode;
  final int quantity;
  final int unitPriceCents;
  const LineItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.parentType,
    required this.parentId,
    required this.name,
    this.brand,
    this.partCode,
    required this.quantity,
    required this.unitPriceCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['parent_type'] = Variable<String>(
        $LineItemsTable.$converterparentType.toSql(parentType),
      );
    }
    map['parent_id'] = Variable<String>(parentId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || partCode != null) {
      map['part_code'] = Variable<String>(partCode);
    }
    map['quantity'] = Variable<int>(quantity);
    map['unit_price_cents'] = Variable<int>(unitPriceCents);
    return map;
  }

  LineItemsCompanion toCompanion(bool nullToAbsent) {
    return LineItemsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      parentType: Value(parentType),
      parentId: Value(parentId),
      name: Value(name),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      partCode: partCode == null && nullToAbsent
          ? const Value.absent()
          : Value(partCode),
      quantity: Value(quantity),
      unitPriceCents: Value(unitPriceCents),
    );
  }

  factory LineItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LineItem(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      parentType: $LineItemsTable.$converterparentType.fromJson(
        serializer.fromJson<String>(json['parentType']),
      ),
      parentId: serializer.fromJson<String>(json['parentId']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      partCode: serializer.fromJson<String?>(json['partCode']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPriceCents: serializer.fromJson<int>(json['unitPriceCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'parentType': serializer.toJson<String>(
        $LineItemsTable.$converterparentType.toJson(parentType),
      ),
      'parentId': serializer.toJson<String>(parentId),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'partCode': serializer.toJson<String?>(partCode),
      'quantity': serializer.toJson<int>(quantity),
      'unitPriceCents': serializer.toJson<int>(unitPriceCents),
    };
  }

  LineItem copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    LineItemParent? parentType,
    String? parentId,
    String? name,
    Value<String?> brand = const Value.absent(),
    Value<String?> partCode = const Value.absent(),
    int? quantity,
    int? unitPriceCents,
  }) => LineItem(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    parentType: parentType ?? this.parentType,
    parentId: parentId ?? this.parentId,
    name: name ?? this.name,
    brand: brand.present ? brand.value : this.brand,
    partCode: partCode.present ? partCode.value : this.partCode,
    quantity: quantity ?? this.quantity,
    unitPriceCents: unitPriceCents ?? this.unitPriceCents,
  );
  LineItem copyWithCompanion(LineItemsCompanion data) {
    return LineItem(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      parentType: data.parentType.present
          ? data.parentType.value
          : this.parentType,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      partCode: data.partCode.present ? data.partCode.value : this.partCode,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPriceCents: data.unitPriceCents.present
          ? data.unitPriceCents.value
          : this.unitPriceCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LineItem(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('parentType: $parentType, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('partCode: $partCode, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceCents: $unitPriceCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    parentType,
    parentId,
    name,
    brand,
    partCode,
    quantity,
    unitPriceCents,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LineItem &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.parentType == this.parentType &&
          other.parentId == this.parentId &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.partCode == this.partCode &&
          other.quantity == this.quantity &&
          other.unitPriceCents == this.unitPriceCents);
}

class LineItemsCompanion extends UpdateCompanion<LineItem> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<LineItemParent> parentType;
  final Value<String> parentId;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String?> partCode;
  final Value<int> quantity;
  final Value<int> unitPriceCents;
  final Value<int> rowid;
  const LineItemsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.parentType = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.partCode = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPriceCents = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LineItemsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    required LineItemParent parentType,
    required String parentId,
    required String name,
    this.brand = const Value.absent(),
    this.partCode = const Value.absent(),
    this.quantity = const Value.absent(),
    required int unitPriceCents,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       parentType = Value(parentType),
       parentId = Value(parentId),
       name = Value(name),
       unitPriceCents = Value(unitPriceCents);
  static Insertable<LineItem> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? parentType,
    Expression<String>? parentId,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? partCode,
    Expression<int>? quantity,
    Expression<int>? unitPriceCents,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (parentType != null) 'parent_type': parentType,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (partCode != null) 'part_code': partCode,
      if (quantity != null) 'quantity': quantity,
      if (unitPriceCents != null) 'unit_price_cents': unitPriceCents,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LineItemsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<LineItemParent>? parentType,
    Value<String>? parentId,
    Value<String>? name,
    Value<String?>? brand,
    Value<String?>? partCode,
    Value<int>? quantity,
    Value<int>? unitPriceCents,
    Value<int>? rowid,
  }) {
    return LineItemsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      parentType: parentType ?? this.parentType,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      partCode: partCode ?? this.partCode,
      quantity: quantity ?? this.quantity,
      unitPriceCents: unitPriceCents ?? this.unitPriceCents,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (parentType.present) {
      map['parent_type'] = Variable<String>(
        $LineItemsTable.$converterparentType.toSql(parentType.value),
      );
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (partCode.present) {
      map['part_code'] = Variable<String>(partCode.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPriceCents.present) {
      map['unit_price_cents'] = Variable<int>(unitPriceCents.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LineItemsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('parentType: $parentType, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('partCode: $partCode, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceCents: $unitPriceCents, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $ModificationsTable modifications = $ModificationsTable(this);
  late final $MaintenanceRecordsTable maintenanceRecords =
      $MaintenanceRecordsTable(this);
  late final $LineItemsTable lineItems = $LineItemsTable(this);
  late final Index lineItemsParent = Index(
    'line_items_parent',
    'CREATE INDEX line_items_parent ON line_items (parent_type, parent_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vehicles,
    modifications,
    maintenanceRecords,
    lineItems,
    lineItemsParent,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$VehiclesTableCreateCompanionBuilder = VehiclesCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  required VehicleType vehicleType,
  required String nickname,
  required String make,
  required String model,
  Value<String?> version,
  Value<int?> year,
  Value<String?> engine,
  required FuelType fuelType,
  Value<int> currentKm,
  Value<String?> coverPhotoId,
  Value<String?> plate,
  Value<int?> projectBudgetCents,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});
typedef $$VehiclesTableUpdateCompanionBuilder = VehiclesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<VehicleType> vehicleType,
  Value<String> nickname,
  Value<String> make,
  Value<String> model,
  Value<String?> version,
  Value<int?> year,
  Value<String?> engine,
  Value<FuelType> fuelType,
  Value<int> currentKm,
  Value<String?> coverPhotoId,
  Value<String?> plate,
  Value<int?> projectBudgetCents,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});

final class $$VehiclesTableReferences
    extends BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle> {
  $$VehiclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ModificationsTable, List<Modification>>
  _modificationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.modifications,
    aliasName: 'vehicles__id__modifications__vehicle_id',
  );

  $$ModificationsTableProcessedTableManager get modificationsRefs {
    final manager = $$ModificationsTableTableManager(
      $_db,
      $_db.modifications,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_modificationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MaintenanceRecordsTable, List<MaintenanceRecord>>
  _maintenanceRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.maintenanceRecords,
        aliasName: 'vehicles__id__maintenance_records__vehicle_id',
      );

  $$MaintenanceRecordsTableProcessedTableManager get maintenanceRecordsRefs {
    final manager = $$MaintenanceRecordsTableTableManager(
      $_db,
      $_db.maintenanceRecords,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _maintenanceRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<VehicleType, VehicleType, String>
  get vehicleType => $composableBuilder(
    column: $table.vehicleType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get make => $composableBuilder(
    column: $table.make,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get engine => $composableBuilder(
    column: $table.engine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FuelType, FuelType, String> get fuelType =>
      $composableBuilder(
        column: $table.fuelType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get currentKm => $composableBuilder(
    column: $table.currentKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverPhotoId => $composableBuilder(
    column: $table.coverPhotoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get projectBudgetCents => $composableBuilder(
    column: $table.projectBudgetCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> modificationsRefs(
    Expression<bool> Function($$ModificationsTableFilterComposer f) f,
  ) {
    final $$ModificationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modifications,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModificationsTableFilterComposer(
            $db: $db,
            $table: $db.modifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> maintenanceRecordsRefs(
    Expression<bool> Function($$MaintenanceRecordsTableFilterComposer f) f,
  ) {
    final $$MaintenanceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.maintenanceRecords,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.maintenanceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleType => $composableBuilder(
    column: $table.vehicleType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get make => $composableBuilder(
    column: $table.make,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get engine => $composableBuilder(
    column: $table.engine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentKm => $composableBuilder(
    column: $table.currentKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverPhotoId => $composableBuilder(
    column: $table.coverPhotoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get projectBudgetCents => $composableBuilder(
    column: $table.projectBudgetCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<VehicleType, String> get vehicleType =>
      $composableBuilder(
        column: $table.vehicleType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get make =>
      $composableBuilder(column: $table.make, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get engine =>
      $composableBuilder(column: $table.engine, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FuelType, String> get fuelType =>
      $composableBuilder(column: $table.fuelType, builder: (column) => column);

  GeneratedColumn<int> get currentKm =>
      $composableBuilder(column: $table.currentKm, builder: (column) => column);

  GeneratedColumn<String> get coverPhotoId => $composableBuilder(
    column: $table.coverPhotoId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get plate =>
      $composableBuilder(column: $table.plate, builder: (column) => column);

  GeneratedColumn<int> get projectBudgetCents => $composableBuilder(
    column: $table.projectBudgetCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  Expression<T> modificationsRefs<T extends Object>(
    Expression<T> Function($$ModificationsTableAnnotationComposer a) f,
  ) {
    final $$ModificationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modifications,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModificationsTableAnnotationComposer(
            $db: $db,
            $table: $db.modifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> maintenanceRecordsRefs<T extends Object>(
    Expression<T> Function($$MaintenanceRecordsTableAnnotationComposer a) f,
  ) {
    final $$MaintenanceRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.maintenanceRecords,
          getReferencedColumn: (t) => t.vehicleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MaintenanceRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.maintenanceRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$VehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiclesTable,
          Vehicle,
          $$VehiclesTableFilterComposer,
          $$VehiclesTableOrderingComposer,
          $$VehiclesTableAnnotationComposer,
          $$VehiclesTableCreateCompanionBuilder,
          $$VehiclesTableUpdateCompanionBuilder,
          (Vehicle, $$VehiclesTableReferences),
          Vehicle,
          PrefetchHooks Function({
            bool modificationsRefs,
            bool maintenanceRecordsRefs,
          })
        > {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<VehicleType> vehicleType = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String> make = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<String?> version = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> engine = const Value.absent(),
                Value<FuelType> fuelType = const Value.absent(),
                Value<int> currentKm = const Value.absent(),
                Value<String?> coverPhotoId = const Value.absent(),
                Value<String?> plate = const Value.absent(),
                Value<int?> projectBudgetCents = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                vehicleType: vehicleType,
                nickname: nickname,
                make: make,
                model: model,
                version: version,
                year: year,
                engine: engine,
                fuelType: fuelType,
                currentKm: currentKm,
                coverPhotoId: coverPhotoId,
                plate: plate,
                projectBudgetCents: projectBudgetCents,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required VehicleType vehicleType,
                required String nickname,
                required String make,
                required String model,
                Value<String?> version = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> engine = const Value.absent(),
                required FuelType fuelType,
                Value<int> currentKm = const Value.absent(),
                Value<String?> coverPhotoId = const Value.absent(),
                Value<String?> plate = const Value.absent(),
                Value<int?> projectBudgetCents = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                vehicleType: vehicleType,
                nickname: nickname,
                make: make,
                model: model,
                version: version,
                year: year,
                engine: engine,
                fuelType: fuelType,
                currentKm: currentKm,
                coverPhotoId: coverPhotoId,
                plate: plate,
                projectBudgetCents: projectBudgetCents,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VehiclesTable, Vehicle>(table),
                  $$VehiclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({modificationsRefs = false, maintenanceRecordsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (modificationsRefs) db.modifications,
                    if (maintenanceRecordsRefs) db.maintenanceRecords,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (modificationsRefs)
                        await $_getPrefetchedDataByColumns<
                          Vehicle,
                          $VehiclesTable,
                          Modification,
                          $ModificationsTable
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._modificationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).modificationsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'vehicle_id',
                          typedResults: items,
                        ),
                      if (maintenanceRecordsRefs)
                        await $_getPrefetchedDataByColumns<
                          Vehicle,
                          $VehiclesTable,
                          MaintenanceRecord,
                          $MaintenanceRecordsTable
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._maintenanceRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).maintenanceRecordsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'vehicle_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiclesTable,
      Vehicle,
      $$VehiclesTableFilterComposer,
      $$VehiclesTableOrderingComposer,
      $$VehiclesTableAnnotationComposer,
      $$VehiclesTableCreateCompanionBuilder,
      $$VehiclesTableUpdateCompanionBuilder,
      (Vehicle, $$VehiclesTableReferences),
      Vehicle,
      PrefetchHooks Function({
        bool modificationsRefs,
        bool maintenanceRecordsRefs,
      })
    >;
typedef $$ModificationsTableCreateCompanionBuilder =
    ModificationsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      required String vehicleId,
      required String title,
      required ModCategory category,
      required ModificationStatus status,
      required DateTime date,
      Value<int?> km,
      Value<int> laborCostCents,
      Value<String?> laborBy,
      Value<String?> notes,
      Value<String?> performanceNotes,
      Value<int?> estimatedCostCents,
      Value<bool> requiresRegularization,
      Value<RegularizationStatus?> regularizationStatus,
      Value<int> rowid,
    });
typedef $$ModificationsTableUpdateCompanionBuilder =
    ModificationsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> vehicleId,
      Value<String> title,
      Value<ModCategory> category,
      Value<ModificationStatus> status,
      Value<DateTime> date,
      Value<int?> km,
      Value<int> laborCostCents,
      Value<String?> laborBy,
      Value<String?> notes,
      Value<String?> performanceNotes,
      Value<int?> estimatedCostCents,
      Value<bool> requiresRegularization,
      Value<RegularizationStatus?> regularizationStatus,
      Value<int> rowid,
    });

final class $$ModificationsTableReferences
    extends BaseReferences<_$AppDatabase, $ModificationsTable, Modification> {
  $$ModificationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('modifications__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<String>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ModificationsTableFilterComposer
    extends Composer<_$AppDatabase, $ModificationsTable> {
  $$ModificationsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ModCategory, ModCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ModificationStatus, ModificationStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get km => $composableBuilder(
    column: $table.km,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get laborCostCents => $composableBuilder(
    column: $table.laborCostCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get laborBy => $composableBuilder(
    column: $table.laborBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get performanceNotes => $composableBuilder(
    column: $table.performanceNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedCostCents => $composableBuilder(
    column: $table.estimatedCostCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresRegularization => $composableBuilder(
    column: $table.requiresRegularization,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    RegularizationStatus?,
    RegularizationStatus,
    String
  >
  get regularizationStatus => $composableBuilder(
    column: $table.regularizationStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ModificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ModificationsTable> {
  $$ModificationsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get km => $composableBuilder(
    column: $table.km,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get laborCostCents => $composableBuilder(
    column: $table.laborCostCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get laborBy => $composableBuilder(
    column: $table.laborBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get performanceNotes => $composableBuilder(
    column: $table.performanceNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedCostCents => $composableBuilder(
    column: $table.estimatedCostCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresRegularization => $composableBuilder(
    column: $table.requiresRegularization,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regularizationStatus => $composableBuilder(
    column: $table.regularizationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ModificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModificationsTable> {
  $$ModificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ModCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ModificationStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get km =>
      $composableBuilder(column: $table.km, builder: (column) => column);

  GeneratedColumn<int> get laborCostCents => $composableBuilder(
    column: $table.laborCostCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get laborBy =>
      $composableBuilder(column: $table.laborBy, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get performanceNotes => $composableBuilder(
    column: $table.performanceNotes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedCostCents => $composableBuilder(
    column: $table.estimatedCostCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requiresRegularization => $composableBuilder(
    column: $table.requiresRegularization,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<RegularizationStatus?, String>
  get regularizationStatus => $composableBuilder(
    column: $table.regularizationStatus,
    builder: (column) => column,
  );

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ModificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ModificationsTable,
          Modification,
          $$ModificationsTableFilterComposer,
          $$ModificationsTableOrderingComposer,
          $$ModificationsTableAnnotationComposer,
          $$ModificationsTableCreateCompanionBuilder,
          $$ModificationsTableUpdateCompanionBuilder,
          (Modification, $$ModificationsTableReferences),
          Modification,
          PrefetchHooks Function({bool vehicleId})
        > {
  $$ModificationsTableTableManager(_$AppDatabase db, $ModificationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<ModCategory> category = const Value.absent(),
                Value<ModificationStatus> status = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> km = const Value.absent(),
                Value<int> laborCostCents = const Value.absent(),
                Value<String?> laborBy = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> performanceNotes = const Value.absent(),
                Value<int?> estimatedCostCents = const Value.absent(),
                Value<bool> requiresRegularization = const Value.absent(),
                Value<RegularizationStatus?> regularizationStatus =
                    const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModificationsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                vehicleId: vehicleId,
                title: title,
                category: category,
                status: status,
                date: date,
                km: km,
                laborCostCents: laborCostCents,
                laborBy: laborBy,
                notes: notes,
                performanceNotes: performanceNotes,
                estimatedCostCents: estimatedCostCents,
                requiresRegularization: requiresRegularization,
                regularizationStatus: regularizationStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required String vehicleId,
                required String title,
                required ModCategory category,
                required ModificationStatus status,
                required DateTime date,
                Value<int?> km = const Value.absent(),
                Value<int> laborCostCents = const Value.absent(),
                Value<String?> laborBy = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> performanceNotes = const Value.absent(),
                Value<int?> estimatedCostCents = const Value.absent(),
                Value<bool> requiresRegularization = const Value.absent(),
                Value<RegularizationStatus?> regularizationStatus =
                    const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModificationsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                vehicleId: vehicleId,
                title: title,
                category: category,
                status: status,
                date: date,
                km: km,
                laborCostCents: laborCostCents,
                laborBy: laborBy,
                notes: notes,
                performanceNotes: performanceNotes,
                estimatedCostCents: estimatedCostCents,
                requiresRegularization: requiresRegularization,
                regularizationStatus: regularizationStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ModificationsTable, Modification>(table),
                  $$ModificationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false}) {
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
                    if (vehicleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.vehicleId,
                        referencedTable: $$ModificationsTableReferences
                            ._vehicleIdTable(db),
                        referencedColumn: $$ModificationsTableReferences
                            ._vehicleIdTable(db)
                            .id,
                      ) as T;
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

typedef $$ModificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ModificationsTable,
      Modification,
      $$ModificationsTableFilterComposer,
      $$ModificationsTableOrderingComposer,
      $$ModificationsTableAnnotationComposer,
      $$ModificationsTableCreateCompanionBuilder,
      $$ModificationsTableUpdateCompanionBuilder,
      (Modification, $$ModificationsTableReferences),
      Modification,
      PrefetchHooks Function({bool vehicleId})
    >;
typedef $$MaintenanceRecordsTableCreateCompanionBuilder =
    MaintenanceRecordsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      required String vehicleId,
      required MaintenanceType type,
      required DateTime date,
      Value<int?> km,
      Value<int> laborCostCents,
      Value<String?> laborBy,
      Value<String?> place,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$MaintenanceRecordsTableUpdateCompanionBuilder =
    MaintenanceRecordsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> vehicleId,
      Value<MaintenanceType> type,
      Value<DateTime> date,
      Value<int?> km,
      Value<int> laborCostCents,
      Value<String?> laborBy,
      Value<String?> place,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$MaintenanceRecordsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MaintenanceRecordsTable,
          MaintenanceRecord
        > {
  $$MaintenanceRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('maintenance_records__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<String>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MaintenanceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceRecordsTable> {
  $$MaintenanceRecordsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MaintenanceType, MaintenanceType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get km => $composableBuilder(
    column: $table.km,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get laborCostCents => $composableBuilder(
    column: $table.laborCostCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get laborBy => $composableBuilder(
    column: $table.laborBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenanceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceRecordsTable> {
  $$MaintenanceRecordsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get km => $composableBuilder(
    column: $table.km,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get laborCostCents => $composableBuilder(
    column: $table.laborCostCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get laborBy => $composableBuilder(
    column: $table.laborBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenanceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceRecordsTable> {
  $$MaintenanceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MaintenanceType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get km =>
      $composableBuilder(column: $table.km, builder: (column) => column);

  GeneratedColumn<int> get laborCostCents => $composableBuilder(
    column: $table.laborCostCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get laborBy =>
      $composableBuilder(column: $table.laborBy, builder: (column) => column);

  GeneratedColumn<String> get place =>
      $composableBuilder(column: $table.place, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenanceRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaintenanceRecordsTable,
          MaintenanceRecord,
          $$MaintenanceRecordsTableFilterComposer,
          $$MaintenanceRecordsTableOrderingComposer,
          $$MaintenanceRecordsTableAnnotationComposer,
          $$MaintenanceRecordsTableCreateCompanionBuilder,
          $$MaintenanceRecordsTableUpdateCompanionBuilder,
          (MaintenanceRecord, $$MaintenanceRecordsTableReferences),
          MaintenanceRecord,
          PrefetchHooks Function({bool vehicleId})
        > {
  $$MaintenanceRecordsTableTableManager(
    _$AppDatabase db,
    $MaintenanceRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<MaintenanceType> type = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> km = const Value.absent(),
                Value<int> laborCostCents = const Value.absent(),
                Value<String?> laborBy = const Value.absent(),
                Value<String?> place = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MaintenanceRecordsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                vehicleId: vehicleId,
                type: type,
                date: date,
                km: km,
                laborCostCents: laborCostCents,
                laborBy: laborBy,
                place: place,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required String vehicleId,
                required MaintenanceType type,
                required DateTime date,
                Value<int?> km = const Value.absent(),
                Value<int> laborCostCents = const Value.absent(),
                Value<String?> laborBy = const Value.absent(),
                Value<String?> place = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MaintenanceRecordsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                vehicleId: vehicleId,
                type: type,
                date: date,
                km: km,
                laborCostCents: laborCostCents,
                laborBy: laborBy,
                place: place,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MaintenanceRecordsTable, MaintenanceRecord>(
                    table,
                  ),
                  $$MaintenanceRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false}) {
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
                    if (vehicleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.vehicleId,
                        referencedTable: $$MaintenanceRecordsTableReferences
                            ._vehicleIdTable(db),
                        referencedColumn: $$MaintenanceRecordsTableReferences
                            ._vehicleIdTable(db)
                            .id,
                      ) as T;
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

typedef $$MaintenanceRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaintenanceRecordsTable,
      MaintenanceRecord,
      $$MaintenanceRecordsTableFilterComposer,
      $$MaintenanceRecordsTableOrderingComposer,
      $$MaintenanceRecordsTableAnnotationComposer,
      $$MaintenanceRecordsTableCreateCompanionBuilder,
      $$MaintenanceRecordsTableUpdateCompanionBuilder,
      (MaintenanceRecord, $$MaintenanceRecordsTableReferences),
      MaintenanceRecord,
      PrefetchHooks Function({bool vehicleId})
    >;
typedef $$LineItemsTableCreateCompanionBuilder = LineItemsCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  required LineItemParent parentType,
  required String parentId,
  required String name,
  Value<String?> brand,
  Value<String?> partCode,
  Value<int> quantity,
  required int unitPriceCents,
  Value<int> rowid,
});
typedef $$LineItemsTableUpdateCompanionBuilder = LineItemsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<LineItemParent> parentType,
  Value<String> parentId,
  Value<String> name,
  Value<String?> brand,
  Value<String?> partCode,
  Value<int> quantity,
  Value<int> unitPriceCents,
  Value<int> rowid,
});

class $$LineItemsTableFilterComposer
    extends Composer<_$AppDatabase, $LineItemsTable> {
  $$LineItemsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LineItemParent, LineItemParent, String>
  get parentType => $composableBuilder(
    column: $table.parentType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partCode => $composableBuilder(
    column: $table.partCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPriceCents => $composableBuilder(
    column: $table.unitPriceCents,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LineItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $LineItemsTable> {
  $$LineItemsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentType => $composableBuilder(
    column: $table.parentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partCode => $composableBuilder(
    column: $table.partCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPriceCents => $composableBuilder(
    column: $table.unitPriceCents,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LineItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LineItemsTable> {
  $$LineItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LineItemParent, String> get parentType =>
      $composableBuilder(
        column: $table.parentType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get partCode =>
      $composableBuilder(column: $table.partCode, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitPriceCents => $composableBuilder(
    column: $table.unitPriceCents,
    builder: (column) => column,
  );
}

class $$LineItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LineItemsTable,
          LineItem,
          $$LineItemsTableFilterComposer,
          $$LineItemsTableOrderingComposer,
          $$LineItemsTableAnnotationComposer,
          $$LineItemsTableCreateCompanionBuilder,
          $$LineItemsTableUpdateCompanionBuilder,
          (LineItem, BaseReferences<_$AppDatabase, $LineItemsTable, LineItem>),
          LineItem,
          PrefetchHooks Function()
        > {
  $$LineItemsTableTableManager(_$AppDatabase db, $LineItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LineItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LineItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LineItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<LineItemParent> parentType = const Value.absent(),
                Value<String> parentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> partCode = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> unitPriceCents = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LineItemsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                parentType: parentType,
                parentId: parentId,
                name: name,
                brand: brand,
                partCode: partCode,
                quantity: quantity,
                unitPriceCents: unitPriceCents,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required LineItemParent parentType,
                required String parentId,
                required String name,
                Value<String?> brand = const Value.absent(),
                Value<String?> partCode = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                required int unitPriceCents,
                Value<int> rowid = const Value.absent(),
              }) => LineItemsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                parentType: parentType,
                parentId: parentId,
                name: name,
                brand: brand,
                partCode: partCode,
                quantity: quantity,
                unitPriceCents: unitPriceCents,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LineItemsTable, LineItem>(table),
                  BaseReferences<_$AppDatabase, $LineItemsTable, LineItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LineItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LineItemsTable,
      LineItem,
      $$LineItemsTableFilterComposer,
      $$LineItemsTableOrderingComposer,
      $$LineItemsTableAnnotationComposer,
      $$LineItemsTableCreateCompanionBuilder,
      $$LineItemsTableUpdateCompanionBuilder,
      (LineItem, BaseReferences<_$AppDatabase, $LineItemsTable, LineItem>),
      LineItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$ModificationsTableTableManager get modifications =>
      $$ModificationsTableTableManager(_db, _db.modifications);
  $$MaintenanceRecordsTableTableManager get maintenanceRecords =>
      $$MaintenanceRecordsTableTableManager(_db, _db.maintenanceRecords);
  $$LineItemsTableTableManager get lineItems =>
      $$LineItemsTableTableManager(_db, _db.lineItems);
}
