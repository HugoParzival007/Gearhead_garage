import 'package:diario_de_garagem/data/database/enums.dart';
import 'package:diario_de_garagem/domain/cost_summary.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

void main() {
  test('spent/planned/category/remaining per rules', () {
    final s = CostSummary.compute(
      mods: [
        mod(
          id: 'a',
          category: ModCategory.suspension,
          laborCostCents: 10000,
          items: [
            item(
              parentId: 'a',
              parentType: LineItemParent.modification,
              quantity: 2,
              unitPriceCents: 10000,
            ),
          ],
        ),
        mod(
          id: 'b',
          category: ModCategory.audio,
          status: ModificationStatus.removed,
          laborCostCents: 10000,
        ),
        mod(
          id: 'c',
          category: ModCategory.engine,
          status: ModificationStatus.planned,
          estimatedCostCents: 200000,
        ),
      ],
      maintenance: [maint(laborCostCents: 25000)],
      budgetCents: 50000,
    );
    expect(s.spentCents, 65000);
    expect(s.modsSpentCents, 40000);
    expect(s.maintenanceSpentCents, 25000);
    expect(s.plannedCents, 200000);
    expect(s.spentByCategory, {
      ModCategory.suspension: 30000,
      ModCategory.audio: 10000,
    });
    expect(s.budgetCents, 50000);
    expect(s.remainingCents, -15000);
    expect(
      () => s.spentByCategory[ModCategory.engine] = 1,
      throwsUnsupportedError,
    );
  });

  test('planned with parts/labor uses total, not estimate', () {
    final s = CostSummary.compute(
      mods: [
        mod(
          status: ModificationStatus.planned,
          laborCostCents: 5000,
          estimatedCostCents: 99999,
        ),
      ],
      maintenance: const [],
    );
    expect(s.plannedCents, 5000);
    expect(s.spentCents, 0);
    expect(s.spentByCategory, isEmpty);
  });

  test('planned with only zero-priced parts uses the estimate', () {
    final zeroPriced = mod(
      id: 'p',
      status: ModificationStatus.planned,
      estimatedCostCents: 30000,
      items: [
        item(
          parentId: 'p',
          parentType: LineItemParent.modification,
          unitPriceCents: 0,
        ),
      ],
    );
    expect(hasRecordedCost(zeroPriced), isFalse);
    final s = CostSummary.compute(mods: [zeroPriced], maintenance: const []);
    expect(s.plannedCents, 30000);
  });

  test('hasRecordedCost: live parts or labor above zero', () {
    expect(hasRecordedCost(mod(laborCostCents: 1)), isTrue);
    expect(hasRecordedCost(mod()), isFalse);
    expect(
      hasRecordedCost(
        mod(
          id: 'q',
          items: [
            item(
              parentId: 'q',
              parentType: LineItemParent.modification,
              unitPriceCents: 500,
            ),
          ],
        ),
      ),
      isTrue,
    );
    expect(
      hasRecordedCost(
        mod(
          id: 'd',
          items: [
            item(
              parentId: 'd',
              parentType: LineItemParent.modification,
              unitPriceCents: 500,
              deletedAt: DateTime.utc(2026, 2),
            ),
          ],
        ),
      ),
      isFalse,
    );
  });

  test('no budget -> null budget and remaining', () {
    final s = CostSummary.compute(mods: [mod()], maintenance: const []);
    expect(s.budgetCents, isNull);
    expect(s.remainingCents, isNull);
  });

  test('empty lists -> zeros', () {
    final s = CostSummary.compute(mods: const [], maintenance: const []);
    expect(s.spentCents, 0);
    expect(s.plannedCents, 0);
    expect(s.modsSpentCents, 0);
    expect(s.maintenanceSpentCents, 0);
    expect(s.spentByCategory, isEmpty);
  });

  test('ignores deleted records and deleted items', () {
    final dead = DateTime.utc(2026, 2, 1);
    final s = CostSummary.compute(
      mods: [
        mod(id: 'x', laborCostCents: 1000, deletedAt: dead),
        mod(
          id: 'y',
          laborCostCents: 500,
          items: [
            item(
              parentId: 'y',
              parentType: LineItemParent.modification,
              unitPriceCents: 700,
              deletedAt: dead,
            ),
          ],
        ),
      ],
      maintenance: [
        maint(id: 'z', laborCostCents: 3000, deletedAt: dead),
        maint(
          id: 'w',
          laborCostCents: 100,
          items: [
            item(
              parentId: 'w',
              parentType: LineItemParent.maintenance,
              unitPriceCents: 200,
              deletedAt: dead,
            ),
          ],
        ),
      ],
    );
    expect(s.modsSpentCents, 500);
    expect(s.maintenanceSpentCents, 100);
    expect(s.spentCents, 600);
  });
}
