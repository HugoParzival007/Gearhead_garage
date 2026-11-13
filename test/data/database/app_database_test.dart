import 'package:diario_de_garagem/data/database/app_database.dart';
import 'package:diario_de_garagem/data/database/enums.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  final now = DateTime.utc(2026, 1, 1);

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('inserts and reads linked vehicle, modification, line item', () async {
    await db.into(db.vehicles).insert(VehiclesCompanion.insert(
          id: 'v1',
          createdAt: now,
          updatedAt: now,
          vehicleType: VehicleType.motorcycle,
          nickname: 'Moto',
          make: 'Honda',
          model: 'CB 500',
          fuelType: FuelType.gasoline,
        ));
    await db.into(db.modifications).insert(ModificationsCompanion.insert(
          id: 'm1',
          createdAt: now,
          updatedAt: now,
          vehicleId: 'v1',
          title: 'Escape',
          category: ModCategory.intakeExhaust,
          status: ModificationStatus.installed,
          date: now,
        ));
    await db.into(db.lineItems).insert(LineItemsCompanion.insert(
          id: 'l1',
          createdAt: now,
          updatedAt: now,
          parentType: LineItemParent.modification,
          parentId: 'm1',
          name: 'Ponteira',
          unitPriceCents: 15000,
        ));

    final v = await db.select(db.vehicles).getSingle();
    final m = await db.select(db.modifications).getSingle();
    final l = await db.select(db.lineItems).getSingle();
    expect(v.vehicleType, VehicleType.motorcycle);
    expect(v.currentKm, 0);
    expect(v.deletedAt, isNull);
    expect(m.requiresRegularization, false);
    expect(m.laborCostCents, 0);
    expect(l.quantity, 1);
    expect(l.parentType, LineItemParent.modification);
  });

  test('foreign key enforced', () async {
    expect(
      () => db.into(db.modifications).insert(ModificationsCompanion.insert(
            id: 'm1',
            createdAt: now,
            updatedAt: now,
            vehicleId: 'nope',
            title: 'X',
            category: ModCategory.other,
            status: ModificationStatus.planned,
            date: now,
          )),
      throwsA(isA<SqliteException>()),
    );
  });
}
