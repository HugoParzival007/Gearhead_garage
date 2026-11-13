import 'package:diario_de_garagem/core/id_generator.dart';
import 'package:diario_de_garagem/data/database/app_database.dart';
import 'package:diario_de_garagem/data/database/enums.dart';
import 'package:diario_de_garagem/data/models/drafts.dart';
import 'package:diario_de_garagem/data/models/records.dart';
import 'package:diario_de_garagem/data/repositories/maintenance_repository.dart';
import 'package:diario_de_garagem/data/repositories/vehicle_repository.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class _SeqIds implements IdGenerator {
  int _n = 0;
  @override
  String newId() => 'id-${++_n}';
}

MaintenanceDraft _d(String vid, {int labor = 10000, int? km, DateTime? date}) =>
    MaintenanceDraft(
      vehicleId: vid,
      type: MaintenanceType.oilChange,
      date: date ?? DateTime.utc(2026, 3, 1),
      km: km,
      laborCostCents: labor,
      place: '  Oficina  ',
    );

void main() {
  late AppDatabase db;
  late VehicleRepository vehicles;
  late MaintenanceRepository repo;
  late DateTime t;
  late String vid;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    t = DateTime.utc(2026, 1, 1);
    DateTime clock() {
      t = t.add(const Duration(minutes: 1));
      return t;
    }

    final ids = _SeqIds();
    vehicles = VehicleRepository(db, ids: ids, clock: clock);
    repo = MaintenanceRepository(db, vehicles, ids: ids, clock: clock);
    vid = await vehicles.create(
      const VehicleDraft(
        vehicleType: VehicleType.car,
        nickname: 'Gol',
        make: 'VW',
        model: 'Gol',
        fuelType: FuelType.flex,
        currentKm: 60000,
      ),
    );
  });
  tearDown(() => db.close());

  Future<List<MaintenanceWithItems>> list() => repo.watchByVehicle(vid).first;

  test('totals: 2x150 + 1x80 + labor 100 = 48000', () async {
    await repo.save(_d(vid), const [
      LineItemDraft('Óleo', quantity: 2, unitPriceCents: 15000),
      LineItemDraft('Filtro', unitPriceCents: 8000),
    ]);
    final m = (await list()).single;
    expect(m.partsTotalCents, 38000);
    expect(m.totalCents, 48000);
    expect(m.record.place, 'Oficina');
  });

  test('edit replaces items: no orphans', () async {
    final id = await repo.save(_d(vid), const [
      LineItemDraft('Óleo', quantity: 2, unitPriceCents: 15000),
      LineItemDraft('Filtro', unitPriceCents: 8000),
    ]);
    final created = (await list()).single.record;
    await repo.save(_d(vid), const [
      LineItemDraft('Peça', unitPriceCents: 20000),
    ], id: id);
    final m = (await list()).single;
    expect(m.items.length, 1);
    expect(m.totalCents, 30000);
    expect(m.record.createdAt, created.createdAt);
    expect(m.record.updatedAt.isAfter(created.updatedAt), isTrue);
    final all = await db.select(db.lineItems).get();
    expect(all.length, 3);
    for (final i in all.where((i) => i.deletedAt != null)) {
      expect(i.updatedAt, i.deletedAt);
    }
  });

  test('stream re-emits when only items change', () async {
    await repo.save(_d(vid), const [LineItemDraft('A', unitPriceCents: 100)]);
    final totals = <int>[];
    final sub = repo
        .watchByVehicle(vid)
        .listen((l) => totals.add(l.single.partsTotalCents));
    await pumpEventQueue();
    await db
        .update(db.lineItems)
        .write(const LineItemsCompanion(unitPriceCents: Value(999)));
    await pumpEventQueue();
    await sub.cancel();
    expect(totals.first, 100);
    expect(totals.last, 999);
  });

  test('softDelete hides record and items', () async {
    final id = await repo.save(_d(vid), const [
      LineItemDraft('A', unitPriceCents: 100),
    ]);
    await repo.softDelete(id);
    expect(await list(), isEmpty);
    final it = (await db.select(db.lineItems).get()).single;
    expect(it.deletedAt, isNotNull);
    expect(it.updatedAt, it.deletedAt);
    final rec = (await db.select(db.maintenanceRecords).get()).single;
    expect(rec.deletedAt, isNotNull);
    expect(rec.updatedAt, rec.deletedAt);
  });

  test('orders by date desc then createdAt desc', () async {
    final a = await repo.save(_d(vid, date: DateTime.utc(2026, 1, 1)), []);
    final b = await repo.save(_d(vid, date: DateTime.utc(2026, 5, 1)), []);
    final c = await repo.save(_d(vid, date: DateTime.utc(2026, 5, 1)), []);
    expect((await list()).map((m) => m.record.id), [c, b, a]);
  });

  test('validation errors', () async {
    await expectLater(
      () => repo.save(_d(vid, labor: -1), []),
      throwsArgumentError,
    );
    await expectLater(
      () => repo.save(_d(vid, km: -1), []),
      throwsArgumentError,
    );
    await expectLater(
      () => repo.save(_d(vid), const [
        LineItemDraft('A', quantity: 0, unitPriceCents: 1),
      ]),
      throwsArgumentError,
    );
    await expectLater(
      () => repo.save(_d(vid), const [LineItemDraft('A', unitPriceCents: -1)]),
      throwsArgumentError,
    );
    await expectLater(() => repo.save(_d('nope'), []), throwsArgumentError);
    await expectLater(
      () => repo.save(_d(vid), [], id: 'missing'),
      throwsArgumentError,
    );
    expect(await list(), isEmpty);
  });

  test('save with deleted id throws', () async {
    final id = await repo.save(_d(vid), []);
    await repo.softDelete(id);
    await expectLater(
      () => repo.save(_d(vid), [], id: id),
      throwsArgumentError,
    );
  });

  test('km raises vehicle odometer', () async {
    await repo.save(_d(vid, km: 80000), []);
    expect((await vehicles.watchById(vid).first)!.currentKm, 80000);
  });
}
