import '../database/app_database.dart';

int _partsTotal(List<LineItem> items) =>
    items.fold(0, (sum, i) => sum + i.quantity * i.unitPriceCents);

/// A modification with its (non-deleted) parts.
class ModificationWithItems {
  const ModificationWithItems(this.modification, this.items);

  final Modification modification;
  final List<LineItem> items;

  int get partsTotalCents => _partsTotal(items);
  int get totalCents => partsTotalCents + modification.laborCostCents;
}

/// A maintenance record with its (non-deleted) parts.
class MaintenanceWithItems {
  const MaintenanceWithItems(this.record, this.items);

  final MaintenanceRecord record;
  final List<LineItem> items;

  int get partsTotalCents => _partsTotal(items);
  int get totalCents => partsTotalCents + record.laborCostCents;
}
