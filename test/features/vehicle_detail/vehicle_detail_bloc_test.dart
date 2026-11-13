import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:diario_de_garagem/data/database/app_database.dart';
import 'package:diario_de_garagem/data/database/enums.dart';
import 'package:diario_de_garagem/data/models/records.dart';
import 'package:diario_de_garagem/data/repositories/maintenance_repository.dart';
import 'package:diario_de_garagem/data/repositories/modification_repository.dart';
import 'package:diario_de_garagem/data/repositories/vehicle_repository.dart';
import 'package:diario_de_garagem/features/vehicle_detail/vehicle_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/fixtures.dart';

class _MockVehicles extends Mock implements VehicleRepository {}

class _MockMods extends Mock implements ModificationRepository {}

class _MockMaintenance extends Mock implements MaintenanceRepository {}

Vehicle _vehicle({int? budget}) => Vehicle(
  id: 'v',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  vehicleType: VehicleType.car,
  nickname: 'Golzinho',
  make: 'VW',
  model: 'Gol',
  fuelType: FuelType.flex,
  currentKm: 50000,
  projectBudgetCents: budget,
);

void main() {
  late _MockVehicles vehicles;
  late _MockMods mods;
  late _MockMaintenance maintenance;

  setUp(() {
    vehicles = _MockVehicles();
    mods = _MockMods();
    maintenance = _MockMaintenance();
  });

  VehicleDetailBloc build() => VehicleDetailBloc(
    'v',
    vehicles: vehicles,
    modifications: mods,
    maintenance: maintenance,
  );

  final installed = mod(
    id: 'm1',
    status: ModificationStatus.installed,
    laborCostCents: 10000,
    items: [
      item(
        parentId: 'm1',
        parentType: LineItemParent.modification,
        quantity: 2,
        unitPriceCents: 25000,
      ),
    ],
  );
  final oil = maint(id: 'r1', laborCostCents: 8000);

  blocTest<VehicleDetailBloc, VehicleDetailState>(
    '1 installed mod and 1 maintenance: timeline of 2, spent is the sum',
    setUp: () {
      when(() => vehicles.watchById('v'))
          .thenAnswer((_) => Stream.value(_vehicle(budget: 100000)));
      when(() => mods.watchByVehicle('v'))
          .thenAnswer((_) => Stream.value([installed]));
      when(() => maintenance.watchByVehicle('v'))
          .thenAnswer((_) => Stream.value([oil]));
    },
    build: build,
    act: (bloc) => bloc.add(const VehicleDetailStarted()),
    expect: () => [
      const VehicleDetailState(),
      isA<VehicleDetailState>()
          .having((s) => s.status, 'status', VehicleDetailStatus.ready)
          .having((s) => s.vehicle?.id, 'vehicle', 'v')
          .having((s) => s.timeline.length, 'timeline.length', 2)
          .having(
            (s) => s.summary?.spentCents,
            'spentCents',
            installed.totalCents + oil.totalCents,
          )
          .having((s) => s.summary?.budgetCents, 'budgetCents', 100000),
    ],
  );

  blocTest<VehicleDetailBloc, VehicleDetailState>(
    'deleted vehicle emits notFound',
    setUp: () {
      when(() => vehicles.watchById('v')).thenAnswer((_) => Stream.value(null));
      when(() => mods.watchByVehicle('v')).thenAnswer((_) => Stream.value([]));
      when(() => maintenance.watchByVehicle('v'))
          .thenAnswer((_) => Stream.value([]));
    },
    build: build,
    act: (bloc) => bloc.add(const VehicleDetailStarted()),
    expect: () => [
      const VehicleDetailState(),
      const VehicleDetailState(status: VehicleDetailStatus.notFound),
    ],
  );

  blocTest<VehicleDetailBloc, VehicleDetailState>(
    'waits for all three streams, then follows later emissions',
    build: build,
    setUp: () {
      final v = StreamController<Vehicle?>();
      final m = StreamController<List<ModificationWithItems>>();
      final r = StreamController<List<MaintenanceWithItems>>();
      when(() => vehicles.watchById('v')).thenAnswer((_) => v.stream);
      when(() => mods.watchByVehicle('v')).thenAnswer((_) => m.stream);
      when(() => maintenance.watchByVehicle('v')).thenAnswer((_) => r.stream);
      Future<void>(() async {
        v.add(_vehicle());
        m.add([installed]);
        await Future<void>.delayed(Duration.zero);
        r.add([]);
        await Future<void>.delayed(Duration.zero);
        r.add([oil]);
        await Future<void>.delayed(Duration.zero);
        v.add(null);
      });
    },
    act: (bloc) => bloc.add(const VehicleDetailStarted()),
    wait: const Duration(milliseconds: 20),
    expect: () => [
      const VehicleDetailState(),
      isA<VehicleDetailState>().having((s) => s.timeline.length, 'len', 1),
      isA<VehicleDetailState>().having((s) => s.timeline.length, 'len', 2),
      const VehicleDetailState(status: VehicleDetailStatus.notFound),
    ],
  );

  blocTest<VehicleDetailBloc, VehicleDetailState>(
    'stream error emits failure',
    setUp: () {
      when(() => vehicles.watchById('v'))
          .thenAnswer((_) => Stream.error(StateError('disk')));
      when(() => mods.watchByVehicle('v')).thenAnswer((_) => Stream.value([]));
      when(() => maintenance.watchByVehicle('v'))
          .thenAnswer((_) => Stream.value([]));
    },
    build: build,
    act: (bloc) => bloc.add(const VehicleDetailStarted()),
    expect: () => [
      const VehicleDetailState(),
      isA<VehicleDetailState>().having(
        (s) => s.status,
        'status',
        VehicleDetailStatus.failure,
      ),
    ],
  );

  test('close cancels the three subscriptions', () async {
    final v = StreamController<Vehicle?>();
    final m = StreamController<List<ModificationWithItems>>();
    final r = StreamController<List<MaintenanceWithItems>>();
    when(() => vehicles.watchById('v')).thenAnswer((_) => v.stream);
    when(() => mods.watchByVehicle('v')).thenAnswer((_) => m.stream);
    when(() => maintenance.watchByVehicle('v')).thenAnswer((_) => r.stream);

    final bloc = build()..add(const VehicleDetailStarted());
    await Future<void>.delayed(Duration.zero);
    expect([v.hasListener, m.hasListener, r.hasListener], [true, true, true]);

    await bloc.close();
    expect(
      [v.hasListener, m.hasListener, r.hasListener],
      [false, false, false],
    );
  });
}
