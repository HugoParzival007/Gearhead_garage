import 'package:diario_de_garagem/core/id_generator.dart';
import 'package:diario_de_garagem/data/database/app_database.dart';
import 'package:diario_de_garagem/data/database/enums.dart';
import 'package:diario_de_garagem/data/models/drafts.dart';
import 'package:diario_de_garagem/data/models/records.dart';
import 'package:diario_de_garagem/data/repositories/modification_repository.dart';
import 'package:diario_de_garagem/data/repositories/vehicle_repository.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';

class _SeqIds implements IdGenerator {
  int _n = 0;
  @override
  String newId() => 'id-${++_n}';
}

ModificationDraft _d(
  String vid, {
  String title = 'Turbo',
  int labor = 10000,
  int? km,
  DateTime? date,
  bool reg = false,
  RegularizationStatus? regStatus,
  int? est,
}) => ModificationDraft(
  vehicleId: vid,
  title: title,
  category: ModCategory.engine,
  status: ModificationStatus.installed,
  date: date ?? DateTime.utc(2026, 3, 1),
  km: km,
  laborCostCents: labor,
  requiresRegularization: reg,
  regularizationStatus: regStatus,
  estimatedCostCents: est,
);

void main() {
  late AppDatabase db;
  late VehicleRepository vehicles;
  late ModificationRepository repo;
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
    repo = ModificationRepository(db, vehicles, ids: ids, clock: clock);
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

  Future<List<ModificationWithItems>> list() => repo.watchByVehicle(vid).first;

  test('totals: 2x150 + 1x80 + labor 100 = 48000', () async {
    await repo.save(_d(vid), const [
      LineItemDraft('Bico', quantity: 2, unitPriceCents: 15000),
      LineItemDraft('Filtro', unitPriceCents: 8000),
    ]);
    final m = (await list()).single;
    expect(m.partsTotalCents, 38000);
    expect(m.totalCents, 48000);
  });

  test('edit replaces items: no orphans, old ones soft-deleted', () async {
    final id = await repo.save(_d(vid), const [
      LineItemDraft('Bico', quantity: 2, unitPriceCents: 15000),
      LineItemDraft('Filtro', unitPriceCents: 8000),
    ]);
    final created = (await list()).single.modification;
    await repo.save(_d(vid), const [
      LineItemDraft('Peça', unitPriceCents: 20000),
    ], id: id);
    final m = (await list()).single;
    expect(m.items.length, 1);
    expect(m.totalCents, 30000);
    expect(m.modification.createdAt, created.createdAt);
    expect(m.modification.updatedAt.isAfter(created.updatedAt), isTrue);
    final all = await db.select(db.lineItems).get();
    expect(all.length, 3);
    final deleted = all.where((i) => i.deletedAt != null).toList();
    for (final i in deleted) {
      expect(i.updatedAt, i.deletedAt);
    }
    expect(deleted.length, 2);
    expect(deleted.map((i) => i.deletedAt).toSet().length, 1);
  });

  test('items saved together reopen in insertion order', () async {
    // Same createdAt for all; ids sort differently ('id-10' < 'id-2').
    final names = [for (var i = 12; i >= 1; i--) 'Peça $i'];
    await repo.save(_d(vid), [
      for (final n in names) LineItemDraft(n, unitPriceCents: 100),
    ]);
    final m = (await list()).single;
    expect(m.items.map((i) => i.name), names);
    expect(m.items.map((i) => i.createdAt).toSet().length, 1);
  });

  test('stream re-emits when only items change', () async {
    final id = await repo.save(_d(vid), const [
      LineItemDraft('A', unitPriceCents: 100),
    ]);
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
    expect(id, isNotEmpty);
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
    final rec = (await db.select(db.modifications).get()).single;
    expect(rec.deletedAt, isNotNull);
    expect(rec.updatedAt, rec.deletedAt);
  });

  test('orders by date desc then createdAt desc', () async {
    final a = await repo.save(_d(vid, date: DateTime.utc(2026, 1, 1)), []);
    final b = await repo.save(_d(vid, date: DateTime.utc(2026, 5, 1)), []);
    final c = await repo.save(_d(vid, date: DateTime.utc(2026, 5, 1)), []);
    expect((await list()).map((m) => m.modification.id), [c, b, a]);
  });

  test('requiresRegularization without status stores pending', () async {
    await repo.save(_d(vid, reg: true), []);
    expect(
      (await list()).single.modification.regularizationStatus,
      RegularizationStatus.pending,
    );
  });

  test('validation errors', () async {
    await expectLater(
      () => repo.save(_d(vid, regStatus: RegularizationStatus.pending), []),
      throwsArgumentError,
    );
    await expectLater(
      () => repo.save(_d(vid, title: '  '), []),
      throwsArgumentError,
    );
    await expectLater(
      () => repo.save(_d(vid, labor: -1), []),
      throwsArgumentError,
    );
    await expectLater(
      () => repo.save(_d(vid, est: -1), []),
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

  test('trims title', () async {
    await repo.save(_d(vid, title: '  Turbo  '), []);
    expect((await list()).single.modification.title, 'Turbo');
  });

  test('km raises vehicle odometer', () async {
    await repo.save(_d(vid, km: 80000), []);
    expect((await vehicles.watchById(vid).first)!.currentKm, 80000);
    await repo.save(_d(vid, km: 70000), []);
    expect((await vehicles.watchById(vid).first)!.currentKm, 80000);
  });
}
