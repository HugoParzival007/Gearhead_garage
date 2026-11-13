import 'package:drift/drift.dart';

import '../../core/clock.dart';
import '../../core/id_generator.dart';
import '../database/app_database.dart';
import '../models/drafts.dart';

class VehicleRepository {
  VehicleRepository(this._db, {required this._ids, required this._clock});

  final AppDatabase _db;
  final IdGenerator _ids;
  final Clock _clock;

  Stream<List<Vehicle>> watchActive() {
    final q = _db.select(_db.vehicles)
      ..where((v) => v.deletedAt.isNull() & v.archivedAt.isNull())
      ..orderBy([(v) => OrderingTerm.asc(v.createdAt)]);
    return q.watch();
  }

  Stream<Vehicle?> watchById(String id) {
    final q = _db.select(_db.vehicles)
      ..where((v) => v.id.equals(id) & v.deletedAt.isNull());
    return q.watchSingleOrNull();
  }

  Future<String> create(VehicleDraft d) async {
    final c = _validated(d);
    final id = _ids.newId();
    final now = _clock();
    await _db
        .into(_db.vehicles)
        .insert(
          VehiclesCompanion.insert(
            id: id,
            createdAt: now,
            updatedAt: now,
            vehicleType: c.vehicleType,
            nickname: c.nickname,
            make: c.make,
            model: c.model,
            version: Value(c.version),
            year: Value(c.year),
            engine: Value(c.engine),
            fuelType: c.fuelType,
            currentKm: Value(c.currentKm),
            plate: Value(c.plate),
            projectBudgetCents: Value(c.projectBudgetCents),
          ),
        );
    return id;
  }

  Future<void> update(String id, VehicleDraft d) async {
    final c = _validated(d);
    await (_db.update(
      _db.vehicles,
    )..where((v) => v.id.equals(id) & v.deletedAt.isNull())).write(
      VehiclesCompanion(
        updatedAt: Value(_clock()),
        vehicleType: Value(c.vehicleType),
        nickname: Value(c.nickname),
        make: Value(c.make),
        model: Value(c.model),
        version: Value(c.version),
        year: Value(c.year),
        engine: Value(c.engine),
        fuelType: Value(c.fuelType),
        currentKm: Value(c.currentKm),
        plate: Value(c.plate),
        projectBudgetCents: Value(c.projectBudgetCents),
      ),
    );
  }

  /// Raises the odometer; no-op when [km] is not above the current value.
  Future<void> raiseKm(String id, int km) async {
    if (km < 0) throw ArgumentError.value(km, 'km', 'must not be negative');
    await (_db.update(_db.vehicles)..where(
          (v) =>
              v.id.equals(id) &
              v.deletedAt.isNull() &
              v.currentKm.isSmallerThanValue(km),
        ))
        .write(
          VehiclesCompanion(currentKm: Value(km), updatedAt: Value(_clock())),
        );
  }

  /// Logical delete of the vehicle and everything under it, one timestamp.
  Future<void> softDelete(String id) {
    return _db.transaction(() async {
      final now = _clock();
      final stamp = Value<DateTime?>(now);

      final modIds =
          await (_db.selectOnly(_db.modifications)
                ..addColumns([_db.modifications.id])
                ..where(
                  _db.modifications.vehicleId.equals(id) &
                      _db.modifications.deletedAt.isNull(),
                ))
              .map((r) => r.read(_db.modifications.id)!)
              .get();
      final maintIds =
          await (_db.selectOnly(_db.maintenanceRecords)
                ..addColumns([_db.maintenanceRecords.id])
                ..where(
                  _db.maintenanceRecords.vehicleId.equals(id) &
                      _db.maintenanceRecords.deletedAt.isNull(),
                ))
              .map((r) => r.read(_db.maintenanceRecords.id)!)
              .get();

      final parentIds = [...modIds, ...maintIds];
      if (parentIds.isNotEmpty) {
        await (_db.update(_db.lineItems)
              ..where((i) => i.parentId.isIn(parentIds) & i.deletedAt.isNull()))
            .write(LineItemsCompanion(deletedAt: stamp, updatedAt: Value(now)));
      }
      await (_db.update(
        _db.modifications,
      )..where((m) => m.vehicleId.equals(id) & m.deletedAt.isNull())).write(
        ModificationsCompanion(deletedAt: stamp, updatedAt: Value(now)),
      );
      await (_db.update(
        _db.maintenanceRecords,
      )..where((m) => m.vehicleId.equals(id) & m.deletedAt.isNull())).write(
        MaintenanceRecordsCompanion(deletedAt: stamp, updatedAt: Value(now)),
      );
      await (_db.update(_db.vehicles)
            ..where((v) => v.id.equals(id) & v.deletedAt.isNull()))
          .write(VehiclesCompanion(deletedAt: stamp, updatedAt: Value(now)));
    });
  }

  VehicleDraft _validated(VehicleDraft d) {
    String required(String v, String name) {
      final t = v.trim();
      if (t.isEmpty) throw ArgumentError.value(v, name, 'must not be blank');
      return t;
    }

    String? optional(String? v) {
      final t = v?.trim();
      return (t == null || t.isEmpty) ? null : t;
    }

    final nickname = required(d.nickname, 'nickname');
    if (nickname.length > 60) {
      throw ArgumentError.value(d.nickname, 'nickname', 'max 60 characters');
    }
    if (d.currentKm < 0) {
      throw ArgumentError.value(d.currentKm, 'currentKm', 'must be >= 0');
    }
    final budget = d.projectBudgetCents;
    if (budget != null && budget < 0) {
      throw ArgumentError.value(budget, 'projectBudgetCents', 'must be >= 0');
    }
    return VehicleDraft(
      vehicleType: d.vehicleType,
      nickname: nickname,
      make: required(d.make, 'make'),
      model: required(d.model, 'model'),
      version: optional(d.version),
      year: d.year,
      engine: optional(d.engine),
      fuelType: d.fuelType,
      currentKm: d.currentKm,
      plate: optional(d.plate),
      projectBudgetCents: budget,
    );
  }
}
