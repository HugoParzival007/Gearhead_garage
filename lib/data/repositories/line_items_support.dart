import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/enums.dart';
import '../models/drafts.dart';

/// Shared by the modification and maintenance repositories: validation,
/// replacement, loading and logical deletion of line items.
class LineItemsSupport {
  LineItemsSupport(this._db);

  final AppDatabase _db;

  /// Trims and validates; throws [ArgumentError].
  static List<LineItemDraft> validate(List<LineItemDraft> items) {
    return [
      for (final i in items)
        () {
          final name = i.name.trim();
          if (name.isEmpty || name.length > 80) {
            throw ArgumentError.value(i.name, 'name', 'must be 1-80 chars');
          }
          if (i.quantity < 1) {
            throw ArgumentError.value(i.quantity, 'quantity', 'must be >= 1');
          }
          if (i.unitPriceCents < 0) {
            throw ArgumentError.value(
              i.unitPriceCents,
              'unitPriceCents',
              'must be >= 0',
            );
          }
          return LineItemDraft(
            name,
            brand: optional(i.brand),
            partCode: optional(i.partCode),
            quantity: i.quantity,
            unitPriceCents: i.unitPriceCents,
          );
        }(),
    ];
  }

  static String? optional(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  /// Trimmed, non-blank, at most 80 chars.
  static String requiredTitle(String v, String name) {
    final t = v.trim();
    if (t.isEmpty || t.length > 80) {
      throw ArgumentError.value(v, name, 'must be 1-80 chars');
    }
    return t;
  }

  Future<void> requireActiveVehicle(String vehicleId) async {
    final row =
        await (_db.select(_db.vehicles)
              ..where((v) => v.id.equals(vehicleId) & v.deletedAt.isNull()))
            .getSingleOrNull();
    if (row == null) {
      throw ArgumentError.value(vehicleId, 'vehicleId', 'vehicle not found');
    }
  }

  /// Soft-deletes the current items of [parentId], then inserts [items].
  Future<void> replace(
    LineItemParent type,
    String parentId,
    List<LineItemDraft> items,
    DateTime now,
    String Function() newId,
  ) async {
    await softDeleteFor(type, parentId, now);
    for (final i in items) {
      await _db
          .into(_db.lineItems)
          .insert(
            LineItemsCompanion.insert(
              id: newId(),
              createdAt: now,
              updatedAt: now,
              parentType: type,
              parentId: parentId,
              name: i.name,
              brand: Value(i.brand),
              partCode: Value(i.partCode),
              quantity: Value(i.quantity),
              unitPriceCents: i.unitPriceCents,
            ),
          );
    }
  }

  Future<void> softDeleteFor(
    LineItemParent type,
    String parentId,
    DateTime now,
  ) {
    return (_db.update(_db.lineItems)..where(
          (i) =>
              i.parentType.equalsValue(type) &
              i.parentId.equals(parentId) &
              i.deletedAt.isNull(),
        ))
        .write(LineItemsCompanion(deletedAt: Value(now)));
  }

  Future<Map<String, List<LineItem>>> load(
    LineItemParent type,
    List<String> parentIds,
  ) async {
    if (parentIds.isEmpty) return {};
    final rows =
        await (_db.select(_db.lineItems)
              ..where(
                (i) =>
                    i.parentType.equalsValue(type) &
                    i.parentId.isIn(parentIds) &
                    i.deletedAt.isNull(),
              )
              ..orderBy([(i) => OrderingTerm.asc(i.createdAt)]))
            .get();
    final map = <String, List<LineItem>>{};
    for (final r in rows) {
      (map[r.parentId] ??= []).add(r);
    }
    return map;
  }
}
