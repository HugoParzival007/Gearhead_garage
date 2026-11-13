import 'package:diario_de_garagem/domain/timeline.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

String idOf(TimelineEntry e) => switch (e) {
  ModificationEntry(:final value) => value.modification.id,
  MaintenanceEntry(:final value) => value.record.id,
};

void main() {
  test('orders by date desc across kinds', () {
    final t = buildTimeline(
      [
        mod(id: 'm1', date: DateTime.utc(2026, 1, 1)),
        mod(id: 'm2', date: DateTime.utc(2026, 3, 1)),
      ],
      [maint(id: 'r1', date: DateTime.utc(2026, 2, 1))],
    );
    expect(t.map(idOf), ['m2', 'r1', 'm1']);
  });

  test('same date: higher km first, null km last, then createdAt desc', () {
    final d = DateTime.utc(2026, 5, 1);
    final t = buildTimeline(
      [
        mod(id: 'nokm', date: d),
        mod(id: 'lo', date: d, km: 100),
        mod(id: 'tieOld', date: d, km: 50, createdAt: DateTime.utc(2026, 1, 1)),
      ],
      [
        maint(id: 'hi', date: d, km: 900),
        maint(
          id: 'tieNew',
          date: d,
          km: 50,
          createdAt: DateTime.utc(2026, 1, 2),
        ),
      ],
    );
    expect(t.map(idOf), ['hi', 'lo', 'tieNew', 'tieOld', 'nokm']);
  });
}
