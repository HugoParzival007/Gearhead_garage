import 'package:bloc_test/bloc_test.dart';
import 'package:diario_de_garagem/data/database/app_database.dart';
import 'package:diario_de_garagem/data/database/enums.dart';
import 'package:diario_de_garagem/data/models/drafts.dart';
import 'package:diario_de_garagem/data/repositories/selected_vehicle_store.dart';
import 'package:diario_de_garagem/data/repositories/vehicle_repository.dart';
import 'package:diario_de_garagem/features/garage/garage_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockVehicleRepository extends Mock implements VehicleRepository {}

class _MockSelectedVehicleStore extends Mock implements SelectedVehicleStore {}

Vehicle _vehicle(String id, String nickname) => Vehicle(
  id: id,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  vehicleType: VehicleType.car,
  nickname: nickname,
  make: 'VW',
  model: 'Gol',
  fuelType: FuelType.flex,
  currentKm: 0,
);

const _draft = VehicleDraft(
  vehicleType: VehicleType.motorcycle,
  nickname: 'CB',
  make: 'Honda',
  model: 'CB 300',
  fuelType: FuelType.gasoline,
  currentKm: 1000,
);

void main() {
  late _MockVehicleRepository repo;
  late _MockSelectedVehicleStore store;
  final a = _vehicle('a', 'Gol');
  final b = _vehicle('b', 'Fusca');

  setUpAll(() => registerFallbackValue(_draft));

  setUp(() {
    repo = _MockVehicleRepository();
    store = _MockSelectedVehicleStore();
    when(() => store.write(any())).thenAnswer((_) async {});
  });

  GarageBloc build() => GarageBloc(vehicles: repo, selection: store);

  blocTest<GarageBloc, GarageState>(
    'GarageStarted with saved id of the second vehicle selects it',
    setUp: () {
      when(() => repo.watchActive()).thenAnswer((_) => Stream.value([a, b]));
      when(() => store.read()).thenReturn('b');
    },
    build: build,
    act: (bloc) => bloc.add(const GarageStarted()),
    expect: () => [
      const GarageState(status: GarageStatus.loading),
      GarageState(
        status: GarageStatus.ready,
        vehicles: [a, b],
        selectedId: 'b',
      ),
    ],
    verify: (_) => verifyNever(() => store.write(any())),
  );

  blocTest<GarageBloc, GarageState>(
    'saved id that no longer exists selects the first and persists it',
    setUp: () {
      when(() => repo.watchActive()).thenAnswer((_) => Stream.value([a, b]));
      when(() => store.read()).thenReturn('gone');
    },
    build: build,
    act: (bloc) => bloc.add(const GarageStarted()),
    expect: () => [
      const GarageState(status: GarageStatus.loading),
      GarageState(
        status: GarageStatus.ready,
        vehicles: [a, b],
        selectedId: 'a',
      ),
    ],
    verify: (_) => verify(() => store.write('a')).called(1),
  );

  blocTest<GarageBloc, GarageState>(
    'empty garage selects nothing and clears a stale saved id',
    setUp: () {
      when(() => repo.watchActive()).thenAnswer((_) => Stream.value([]));
      when(() => store.read()).thenReturn('gone');
    },
    build: build,
    act: (bloc) => bloc.add(const GarageStarted()),
    expect: () => [
      const GarageState(status: GarageStatus.loading),
      const GarageState(status: GarageStatus.ready),
    ],
    verify: (_) => verify(() => store.write(null)).called(1),
  );

  blocTest<GarageBloc, GarageState>(
    'GarageVehicleCreated calls create and selects the returned id',
    setUp: () {
      when(() => repo.create(any())).thenAnswer((_) async => 'new-id');
    },
    build: build,
    seed: () =>
        GarageState(status: GarageStatus.ready, vehicles: [a], selectedId: 'a'),
    act: (bloc) => bloc.add(const GarageVehicleCreated(_draft)),
    expect: () => [
      GarageState(
        status: GarageStatus.ready,
        vehicles: [a],
        selectedId: 'new-id',
      ),
    ],
    verify: (_) {
      verify(() => repo.create(_draft)).called(1);
      verify(() => store.write('new-id')).called(1);
    },
  );

  blocTest<GarageBloc, GarageState>(
    'GarageVehicleSelected selects and persists the id',
    build: build,
    seed: () => GarageState(
      status: GarageStatus.ready,
      vehicles: [a, b],
      selectedId: 'a',
    ),
    act: (bloc) => bloc.add(const GarageVehicleSelected('b')),
    expect: () => [
      GarageState(
        status: GarageStatus.ready,
        vehicles: [a, b],
        selectedId: 'b',
      ),
    ],
    verify: (_) => verify(() => store.write('b')).called(1),
  );

  blocTest<GarageBloc, GarageState>(
    'repository stream error emits failure with a message',
    setUp: () {
      when(() => repo.watchActive())
          .thenAnswer((_) => Stream.error(StateError('disk')));
      when(() => store.read()).thenReturn(null);
    },
    build: build,
    act: (bloc) => bloc.add(const GarageStarted()),
    expect: () => [
      const GarageState(status: GarageStatus.loading),
      isA<GarageState>()
          .having((s) => s.status, 'status', GarageStatus.failure)
          .having((s) => s.errorMessage, 'errorMessage', isNotEmpty),
    ],
  );

  blocTest<GarageBloc, GarageState>(
    'create that throws keeps the list and sets errorMessage',
    setUp: () {
      when(() => repo.create(any()))
          .thenThrow(ArgumentError.value('', 'nickname', 'must not be blank'));
    },
    build: build,
    seed: () =>
        GarageState(status: GarageStatus.ready, vehicles: [a], selectedId: 'a'),
    act: (bloc) => bloc.add(const GarageVehicleCreated(_draft)),
    expect: () => [
      isA<GarageState>()
          .having((s) => s.status, 'status', GarageStatus.ready)
          .having((s) => s.vehicles, 'vehicles', [a])
          .having((s) => s.selectedId, 'selectedId', 'a')
          .having((s) => s.errorMessage, 'errorMessage', isNotEmpty),
    ],
    verify: (_) => verifyNever(() => store.write(any())),
  );
}
