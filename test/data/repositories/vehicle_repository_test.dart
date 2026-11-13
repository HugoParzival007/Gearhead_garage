import 'package:diario_de_garagem/core/id_generator.dart';
import 'package:diario_de_garagem/data/database/app_database.dart';
import 'package:diario_de_garagem/data/database/enums.dart';
import 'package:diario_de_garagem/data/models/drafts.dart';
import 'package:diario_de_garagem/data/repositories/vehicle_repository.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class _SeqIds implements IdGenerator {
  int _n = 0;
  @override
  String newId() => 'id-${++_n}';
}

VehicleDraft _draft({String nickname = 'Gol', int km = 60000}) => VehicleDraft(
  vehicleType: VehicleType.car,
  nickname: nickname,
  make: 'VW',
  model: 'Gol',
  fuelType: FuelType.flex,
  currentKm: km,
);

void main() {
  late AppDatabase db;
  late VehicleRepository repo;
  late DateTime t;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    t = DateTime.utc(2026, 1, 1);
    repo = VehicleRepository(
      db,
      ids: _SeqIds(),
      clock: () {
        t = t.add(const Duration(minutes: 1));
        return t;
      },
    );
  });
  tearDown(() => db.close());

  test('create appears in watchActive with createdAt == updatedAt', () async {
    final id = await repo.create(_draft());
    final list = await repo.watchActive().first;
    expect(list.map((v) => v.id), [id]);
    expect(list.single.createdAt, list.single.updatedAt);
  });

  test('watchActive orders by createdAt asc', () async {
    final a = await repo.create(_draft(nickname: 'A'));
    final b = await repo.create(_draft(nickname: 'B'));
    expect((await repo.watchActive().first).map((v) => v.id), [a, b]);
  });

  test('update bumps updatedAt and stores trimmed values', () async {
    final id = await repo.create(_draft());
    await repo.update(id, _draft(nickname: '  Novo  '));
    final v = (await repo.watchById(id).first)!;
    expect(v.updatedAt.isAfter(v.createdAt), isTrue);
    expect(v.nickname, 'Novo');
  });

  test('raiseKm only writes when higher', () async {
    final id = await repo.create(_draft(km: 60000));
    final before = (await repo.watchById(id).first)!;
    await repo.raiseKm(id, 50000);
    var v = (await repo.watchById(id).first)!;
    expect(v.currentKm, 60000);
    expect(v.updatedAt, before.updatedAt);
    await repo.raiseKm(id, 70000);
    v = (await repo.watchById(id).first)!;
    expect(v.currentKm, 70000);
    expect(v.updatedAt.isAfter(before.updatedAt), isTrue);
    expect(() => repo.raiseKm(id, -1), throwsArgumentError);
  });

  test('softDelete cascades to mods, maintenance and line items', () async {
    final id = await repo.create(_draft());
    final other = await repo.create(_draft(nickname: 'Outro'));
    final old = DateTime.utc(2025, 5, 5);
    final now = DateTime.utc(2026, 1, 1);
    Future<void> mod(String mid, String vid, {DateTime? deleted}) => db
        .into(db.modifications)
        .insert(
          ModificationsCompanion.insert(
            id: mid,
            createdAt: now,
            updatedAt: now,
            deletedAt: Value(deleted),
            vehicleId: vid,
            title: 'T',
            category: ModCategory.other,
            status: ModificationStatus.installed,
            date: now,
          ),
        );
    Future<void> maint(String mid, String vid) => db
        .into(db.maintenanceRecords)
        .insert(
          MaintenanceRecordsCompanion.insert(
            id: mid,
            createdAt: now,
            updatedAt: now,
            vehicleId: vid,
            type: MaintenanceType.oilChange,
            date: now,
          ),
        );
    Future<void> item(String iid, LineItemParent p, String pid) => db
        .into(db.lineItems)
        .insert(
          LineItemsCompanion.insert(
            id: iid,
            createdAt: now,
            updatedAt: now,
            parentType: p,
            parentId: pid,
            name: 'Peça',
            unitPriceCents: 100,
          ),
        );
    await mod('m1', id);
    await mod('m2', id, deleted: old);
    await mod('mo', other);
    await maint('r1', id);
    await maint('ro', other);
    await item('i1', LineItemParent.modification, 'm1');
    await item('i2', LineItemParent.maintenance, 'r1');
    await item('io', LineItemParent.modification, 'mo');

    await repo.softDelete(id);

    expect((await repo.watchActive().first).map((v) => v.id), [other]);
    expect(await repo.watchById(id).first, isNull);
    final v = await (db.select(
      db.vehicles,
    )..where((x) => x.id.equals(id))).getSingle();
    final d = v.deletedAt;
    expect(d, isNotNull);
    final mods = {
      for (final m in await db.select(db.modifications).get()) m.id: m,
    };
    expect(mods['m1']!.deletedAt, d);
    expect(mods['m2']!.deletedAt, old);
    expect(mods['mo']!.deletedAt, isNull);
    final ms = {
      for (final m in await db.select(db.maintenanceRecords).get()) m.id: m,
    };
    expect(ms['r1']!.deletedAt, d);
    expect(ms['ro']!.deletedAt, isNull);
    final items = {
      for (final i in await db.select(db.lineItems).get()) i.id: i,
    };
    expect(items['i1']!.deletedAt, d);
    expect(items['i2']!.deletedAt, d);
    expect(items['io']!.deletedAt, isNull);

    expect(v.updatedAt, d);
    expect(mods['m1']!.updatedAt, d);
    expect(mods['m2']!.updatedAt, now);
    expect(mods['mo']!.updatedAt, now);
    expect(ms['r1']!.updatedAt, d);
    expect(items['i1']!.updatedAt, d);
    expect(items['i2']!.updatedAt, d);
    expect(items['io']!.updatedAt, now);
  });

  test('create validates input', () {
    expect(() => repo.create(_draft(nickname: '   ')), throwsArgumentError);
    expect(() => repo.create(_draft(nickname: '')), throwsArgumentError);
    expect(() => repo.create(_draft(km: -1)), throwsArgumentError);
    expect(
      () => repo.create(
        VehicleDraft(
          vehicleType: VehicleType.car,
          nickname: 'x',
          make: ' ',
          model: 'm',
          fuelType: FuelType.flex,
          currentKm: 0,
        ),
      ),
      throwsArgumentError,
    );
    expect(
      () => repo.create(
        VehicleDraft(
          vehicleType: VehicleType.car,
          nickname: 'x',
          make: 'a',
          model: 'm',
          fuelType: FuelType.flex,
          currentKm: 0,
          projectBudgetCents: -5,
        ),
      ),
      throwsArgumentError,
    );
  });
}
