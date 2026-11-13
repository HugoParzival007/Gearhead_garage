import 'package:equatable/equatable.dart';

import '../data/database/app_database.dart';
import '../data/database/enums.dart';
import '../data/models/records.dart';

int _liveItemsTotal(List<LineItem> items) => items
    .where((i) => i.deletedAt == null)
    .fold(0, (sum, i) => sum + i.quantity * i.unitPriceCents);

int _modTotal(ModificationWithItems m) =>
    _liveItemsTotal(m.items) + m.modification.laborCostCents;

/// Whether a modification has a recorded cost: live parts plus labor above
/// zero. A planned one without it counts (and shows) its estimate instead.
/// Single rule for [CostSummary] and the timeline.
bool hasRecordedCost(ModificationWithItems m) => _modTotal(m) > 0;

int _maintTotal(MaintenanceWithItems m) =>
    _liveItemsTotal(m.items) + m.record.laborCostCents;

/// Aggregated project cost. Pure: derived only from the given records.
class CostSummary extends Equatable {
  const CostSummary({
    required this.spentCents,
    required this.plannedCents,
    required this.modsSpentCents,
    required this.maintenanceSpentCents,
    required this.spentByCategory,
    this.budgetCents,
    this.remainingCents,
  });

  final int spentCents;
  final int plannedCents;
  final int modsSpentCents;
  final int maintenanceSpentCents;

  /// Mods only; categories with value > 0. Unmodifiable.
  final Map<ModCategory, int> spentByCategory;
  final int? budgetCents;

  /// budget - spent; null without budget; may be negative.
  final int? remainingCents;

  /// Installed and removed mods count as spent; planned only as planned.
  /// All maintenance counts as spent. Soft-deleted records/items are ignored.
  static CostSummary compute({
    required List<ModificationWithItems> mods,
    required List<MaintenanceWithItems> maintenance,
    int? budgetCents,
  }) {
    var modsSpent = 0;
    var planned = 0;
    final byCategory = <ModCategory, int>{};
    for (final m in mods) {
      final mod = m.modification;
      if (mod.deletedAt != null) continue;
      final total = _modTotal(m);
      switch (mod.status) {
        case ModificationStatus.installed:
        case ModificationStatus.removed:
          modsSpent += total;
          if (total > 0) {
            byCategory[mod.category] = (byCategory[mod.category] ?? 0) + total;
          }
        case ModificationStatus.planned:
          planned += hasRecordedCost(m) ? total : (mod.estimatedCostCents ?? 0);
      }
    }
    var maintSpent = 0;
    for (final m in maintenance) {
      if (m.record.deletedAt != null) continue;
      maintSpent += _maintTotal(m);
    }
    final spent = modsSpent + maintSpent;
    return CostSummary(
      spentCents: spent,
      plannedCents: planned,
      modsSpentCents: modsSpent,
      maintenanceSpentCents: maintSpent,
      spentByCategory: Map.unmodifiable(byCategory),
      budgetCents: budgetCents,
      remainingCents: budgetCents == null ? null : budgetCents - spent,
    );
  }

  @override
  List<Object?> get props => [
    spentCents,
    plannedCents,
    modsSpentCents,
    maintenanceSpentCents,
    spentByCategory,
    budgetCents,
    remainingCents,
  ];
}
