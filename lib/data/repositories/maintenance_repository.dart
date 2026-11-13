import 'package:drift/drift.dart';

import '../../core/clock.dart';
import '../../core/id_generator.dart';
import '../database/app_database.dart';
import '../database/enums.dart';
import '../models/drafts.dart';
import '../models/records.dart';
import 'line_items_support.dart';
import 'vehicle_repository.dart';

class MaintenanceRepository {
  MaintenanceRepository(
    this._db,
    this._vehicles, {
    required this._ids,
    required this._clock,
  }) : _items = LineItemsSupport(_db);

  final AppDatabase _db;
  final VehicleRepository _vehicles;
  final IdGenerator _ids;
  final Clock _clock;
  final LineItemsSupport _items;

  /// Active records (date desc, createdAt desc) with active parts.
  /// Re-emits when either table changes.
  Stream<List<MaintenanceWithItems>> watchByVehicle(String vehicleId) {
    return _db
        .customSelect(
          'SELECT 1',
          readsFrom: {_db.maintenanceRecords, _db.lineItems},
        )
        .watch()
        .asyncMap((_) => _load(vehicleId));
  }

  Future<List<MaintenanceWithItems>> _load(String vehicleId) async {
    final rows =
        await (_db.select(_db.maintenanceRecords)
              ..where(
                (m) => m.vehicleId.equals(vehicleId) & m.deletedAt.isNull(),
              )
              ..orderBy([
                (m) => OrderingTerm.desc(m.date),
                (m) => OrderingTerm.desc(m.createdAt),
              ]))
            .get();
    final items = await _items.load(
      LineItemParent.maintenance,
      rows.map((m) => m.id).toList(),
    );
    return [for (final m in rows) MaintenanceWithItems(m, items[m.id] ?? [])];
  }

  Future<String> save(
    MaintenanceDraft d,
    List<LineItemDraft> items, {
    String? id,
  }) async {
    final lines = LineItemsSupport.validate(items);
    if (d.laborCostCents < 0) {
      throw ArgumentError.value(d.laborCostCents, 'laborCostCents', '>= 0');
    }
    final km = d.km;
    if (km != null && km < 0) {
      throw ArgumentError.value(km, 'km', 'must be >= 0');
    }

    return _db.transaction(() async {
      await _items.requireActiveVehicle(d.vehicleId);
      final now = _clock();
      final String recordId;
      if (id == null) {
        recordId = _ids.newId();
        await _db
            .into(_db.maintenanceRecords)
            .insert(
              MaintenanceRecordsCompanion.insert(
                id: recordId,
                createdAt: now,
                updatedAt: now,
                vehicleId: d.vehicleId,
                type: d.type,
                date: d.date,
                km: Value(km),
                laborCostCents: Value(d.laborCostCents),
                laborBy: Value(LineItemsSupport.optional(d.laborBy)),
                place: Value(LineItemsSupport.optional(d.place)),
                notes: Value(LineItemsSupport.optional(d.notes)),
              ),
            );
      } else {
        recordId = id;
        final updated =
            await (_db.update(
              _db.maintenanceRecords,
            )..where((m) => m.id.equals(id) & m.deletedAt.isNull())).write(
              MaintenanceRecordsCompanion(
                updatedAt: Value(now),
                vehicleId: Value(d.vehicleId),
                type: Value(d.type),
                date: Value(d.date),
                km: Value(km),
                laborCostCents: Value(d.laborCostCents),
                laborBy: Value(LineItemsSupport.optional(d.laborBy)),
                place: Value(LineItemsSupport.optional(d.place)),
                notes: Value(LineItemsSupport.optional(d.notes)),
              ),
            );
        if (updated == 0) {
          throw ArgumentError.value(id, 'id', 'maintenance not found');
        }
      }
      await _items.replace(
        LineItemParent.maintenance,
        recordId,
        lines,
        now,
        _ids.newId,
      );
      if (km != null) await _vehicles.raiseKm(d.vehicleId, km);
      return recordId;
    });
  }

  Future<void> softDelete(String id) {
    return _db.transaction(() async {
      final now = _clock();
      await _items.softDeleteFor(LineItemParent.maintenance, id, now);
      await (_db.update(
        _db.maintenanceRecords,
      )..where((m) => m.id.equals(id) & m.deletedAt.isNull())).write(
        MaintenanceRecordsCompanion(
          deletedAt: Value(now),
          updatedAt: Value(now),
        ),
      );
    });
  }
}
