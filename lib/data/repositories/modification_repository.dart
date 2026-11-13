import 'package:drift/drift.dart';

import '../../core/clock.dart';
import '../../core/id_generator.dart';
import '../database/app_database.dart';
import '../database/enums.dart';
import '../models/drafts.dart';
import '../models/records.dart';
import 'line_items_support.dart';
import 'vehicle_repository.dart';

class ModificationRepository {
  ModificationRepository(
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

  /// Active modifications (date desc, createdAt desc) with active parts.
  /// Re-emits when either table changes.
  Stream<List<ModificationWithItems>> watchByVehicle(String vehicleId) {
    return _db
        .customSelect('SELECT 1', readsFrom: {_db.modifications, _db.lineItems})
        .watch()
        .asyncMap((_) => _load(vehicleId));
  }

  Future<List<ModificationWithItems>> _load(String vehicleId) async {
    final mods =
        await (_db.select(_db.modifications)
              ..where(
                (m) => m.vehicleId.equals(vehicleId) & m.deletedAt.isNull(),
              )
              ..orderBy([
                (m) => OrderingTerm.desc(m.date),
                (m) => OrderingTerm.desc(m.createdAt),
              ]))
            .get();
    final items = await _items.load(
      LineItemParent.modification,
      mods.map((m) => m.id).toList(),
    );
    return [for (final m in mods) ModificationWithItems(m, items[m.id] ?? [])];
  }

  Future<String> save(
    ModificationDraft d,
    List<LineItemDraft> items, {
    String? id,
  }) async {
    final title = LineItemsSupport.requiredTitle(d.title, 'title');
    final lines = LineItemsSupport.validate(items);
    if (d.laborCostCents < 0) {
      throw ArgumentError.value(d.laborCostCents, 'laborCostCents', '>= 0');
    }
    final est = d.estimatedCostCents;
    if (est != null && est < 0) {
      throw ArgumentError.value(est, 'estimatedCostCents', 'must be >= 0');
    }
    final km = d.km;
    if (km != null && km < 0) {
      throw ArgumentError.value(km, 'km', 'must be >= 0');
    }
    if (d.regularizationStatus != null && !d.requiresRegularization) {
      throw ArgumentError.value(
        d.regularizationStatus,
        'regularizationStatus',
        'requires requiresRegularization',
      );
    }
    final regStatus = d.requiresRegularization
        ? (d.regularizationStatus ?? RegularizationStatus.pending)
        : null;

    return _db.transaction(() async {
      await _items.requireActiveVehicle(d.vehicleId);
      final now = _clock();
      final String recordId;
      if (id == null) {
        recordId = _ids.newId();
        await _db
            .into(_db.modifications)
            .insert(
              ModificationsCompanion.insert(
                id: recordId,
                createdAt: now,
                updatedAt: now,
                vehicleId: d.vehicleId,
                title: title,
                category: d.category,
                status: d.status,
                date: d.date,
                km: Value(km),
                laborCostCents: Value(d.laborCostCents),
                laborBy: Value(LineItemsSupport.optional(d.laborBy)),
                notes: Value(LineItemsSupport.optional(d.notes)),
                performanceNotes: Value(
                  LineItemsSupport.optional(d.performanceNotes),
                ),
                estimatedCostCents: Value(est),
                requiresRegularization: Value(d.requiresRegularization),
                regularizationStatus: Value(regStatus),
              ),
            );
      } else {
        recordId = id;
        final updated =
            await (_db.update(
              _db.modifications,
            )..where((m) => m.id.equals(id) & m.deletedAt.isNull())).write(
              ModificationsCompanion(
                updatedAt: Value(now),
                vehicleId: Value(d.vehicleId),
                title: Value(title),
                category: Value(d.category),
                status: Value(d.status),
                date: Value(d.date),
                km: Value(km),
                laborCostCents: Value(d.laborCostCents),
                laborBy: Value(LineItemsSupport.optional(d.laborBy)),
                notes: Value(LineItemsSupport.optional(d.notes)),
                performanceNotes: Value(
                  LineItemsSupport.optional(d.performanceNotes),
                ),
                estimatedCostCents: Value(est),
                requiresRegularization: Value(d.requiresRegularization),
                regularizationStatus: Value(regStatus),
              ),
            );
        if (updated == 0) {
          throw ArgumentError.value(id, 'id', 'modification not found');
        }
      }
      await _items.replace(
        LineItemParent.modification,
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
      await _items.softDeleteFor(LineItemParent.modification, id, now);
      await (_db.update(
        _db.modifications,
      )..where((m) => m.id.equals(id) & m.deletedAt.isNull())).write(
        ModificationsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
    });
  }
}
