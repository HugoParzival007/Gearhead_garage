import 'package:bloc_test/bloc_test.dart';
import 'package:diario_de_garagem/data/database/enums.dart';
import 'package:diario_de_garagem/data/models/drafts.dart';
import 'package:diario_de_garagem/data/repositories/maintenance_repository.dart';
import 'package:diario_de_garagem/data/repositories/modification_repository.dart';
import 'package:diario_de_garagem/features/records/save_record_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockMods extends Mock implements ModificationRepository {}

class _MockMaintenance extends Mock implements MaintenanceRepository {}

final _mod = ModificationDraft(
  vehicleId: 'v',
  title: 'Escape',
  category: ModCategory.intakeExhaust,
  status: ModificationStatus.installed,
  date: DateTime.utc(2026, 3, 1),
);

final _maint = MaintenanceDraft(
  vehicleId: 'v',
  type: MaintenanceType.oilChange,
  date: DateTime.utc(2026, 3, 1),
);

const _items = [LineItemDraft('Ponteira', unitPriceCents: 30000)];

void main() {
  late _MockMods mods;
  late _MockMaintenance maintenance;

  setUpAll(() {
    registerFallbackValue(_mod);
    registerFallbackValue(_maint);
  });

  setUp(() {
    mods = _MockMods();
    maintenance = _MockMaintenance();
  });

  SaveRecordCubit build() =>
      SaveRecordCubit(modifications: mods, maintenance: maintenance);

  blocTest<SaveRecordCubit, SaveRecordState>(
    'saveModification: saving then saved, passes id through',
    setUp: () =>
        when(() => mods.save(any(), any(), id: any(named: 'id')))
            .thenAnswer((_) async => 'm1'),
    build: build,
    act: (c) => c.saveModification(_mod, _items, id: 'm1'),
    expect: () => const [
      SaveRecordState(SaveRecordStatus.saving),
      SaveRecordState(SaveRecordStatus.saved),
    ],
    verify: (_) => verify(() => mods.save(_mod, _items, id: 'm1')).called(1),
  );

  blocTest<SaveRecordCubit, SaveRecordState>(
    'repository ArgumentError becomes failure with a pt-BR message',
    setUp: () =>
        when(() => mods.save(any(), any(), id: any(named: 'id')))
            .thenThrow(ArgumentError.value('', 'title', 'must be 1-80 chars')),
    build: build,
    act: (c) => c.saveModification(_mod, _items),
    expect: () => [
      const SaveRecordState(SaveRecordStatus.saving),
      isA<SaveRecordState>()
          .having((s) => s.status, 'status', SaveRecordStatus.failure)
          .having((s) => s.message, 'message', isNotEmpty)
          .having((s) => s.message, 'message', contains('título')),
    ],
  );

  blocTest<SaveRecordCubit, SaveRecordState>(
    'saveMaintenance with unknown error still fails with a message',
    setUp: () =>
        when(() => maintenance.save(any(), any(), id: any(named: 'id')))
            .thenThrow(StateError('disk')),
    build: build,
    act: (c) => c.saveMaintenance(_maint, const []),
    expect: () => [
      const SaveRecordState(SaveRecordStatus.saving),
      isA<SaveRecordState>()
          .having((s) => s.status, 'status', SaveRecordStatus.failure)
          .having((s) => s.message, 'message', isNotEmpty),
    ],
  );

  blocTest<SaveRecordCubit, SaveRecordState>(
    'deleteMaintenance soft-deletes and ends saved',
    setUp: () =>
        when(() => maintenance.softDelete('r1')).thenAnswer((_) async {}),
    build: build,
    act: (c) => c.deleteMaintenance('r1'),
    expect: () => const [
      SaveRecordState(SaveRecordStatus.saving),
      SaveRecordState(SaveRecordStatus.saved),
    ],
    verify: (_) => verify(() => maintenance.softDelete('r1')).called(1),
  );

  blocTest<SaveRecordCubit, SaveRecordState>(
    'deleteModification soft-deletes and ends saved',
    setUp: () => when(() => mods.softDelete('m1')).thenAnswer((_) async {}),
    build: build,
    act: (c) => c.deleteModification('m1'),
    expect: () => const [
      SaveRecordState(SaveRecordStatus.saving),
      SaveRecordState(SaveRecordStatus.saved),
    ],
  );
}
