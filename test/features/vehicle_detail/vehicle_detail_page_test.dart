import 'package:bloc_test/bloc_test.dart';
import 'package:diario_de_garagem/app/theme.dart';
import 'package:diario_de_garagem/data/database/app_database.dart';
import 'package:diario_de_garagem/data/database/enums.dart';
import 'package:diario_de_garagem/data/models/records.dart';
import 'package:diario_de_garagem/data/repositories/maintenance_repository.dart';
import 'package:diario_de_garagem/data/repositories/modification_repository.dart';
import 'package:diario_de_garagem/domain/cost_summary.dart';
import 'package:diario_de_garagem/domain/timeline.dart';
import 'package:diario_de_garagem/features/records/maintenance_form_page.dart';
import 'package:diario_de_garagem/features/records/modification_form_page.dart';
import 'package:diario_de_garagem/features/vehicle_detail/budget_gauge.dart';
import 'package:diario_de_garagem/features/vehicle_detail/vehicle_detail_bloc.dart';
import 'package:diario_de_garagem/features/vehicle_detail/vehicle_detail_page.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/fixtures.dart';

class _MockBloc extends MockBloc<VehicleDetailEvent, VehicleDetailState>
    implements VehicleDetailBloc {}

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
  currentKm: 123456,
  projectBudgetCents: budget,
);

VehicleDetailState _ready({
  int? budget,
  List<ModificationWithItems> mods = const [],
  List<MaintenanceWithItems> maintenance = const [],
}) => VehicleDetailState(
  status: VehicleDetailStatus.ready,
  vehicle: _vehicle(budget: budget),
  timeline: buildTimeline(mods, maintenance),
  summary: CostSummary.compute(
    mods: mods,
    maintenance: maintenance,
    budgetCents: budget,
  ),
);

void main() {
  late _MockBloc bloc;

  setUp(() => bloc = _MockBloc());

  Future<void> pump(WidgetTester tester, VehicleDetailState state) async {
    when(() => bloc.state).thenReturn(state);
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ModificationRepository>.value(value: _MockMods()),
          RepositoryProvider<MaintenanceRepository>.value(
            value: _MockMaintenance(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: BlocProvider<VehicleDetailBloc>.value(
            value: bloc,
            child: const VehicleDetailView(nickname: 'Golzinho'),
          ),
        ),
      ),
    );
  }

  final spent = maint(id: 'r', laborCostCents: 120000);

  testWidgets('header shows nickname, type and current km', (tester) async {
    await pump(tester, _ready());

    expect(find.text('Golzinho'), findsWidgets);
    expect(find.textContaining('Carro'), findsOneWidget);
    expect(find.text('123.456 km'), findsOneWidget);
  });

  testWidgets('within budget: spent, budget and remaining + gauge', (
    tester,
  ) async {
    await pump(tester, _ready(budget: 500000, maintenance: [spent]));

    expect(
      find.text(
        keepMoneyTogether(
          'Gasto R\$ 1.200,00 de R\$ 5.000,00 — falta R\$ 3.800,00',
        ),
      ),
      findsOneWidget,
    );
    expect(find.byType(BudgetGauge), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        'Gasto R\$ 1.200,00 de R\$ 5.000,00 — falta R\$ 3.800,00',
      ),
      findsOneWidget,
    );
  });

  testWidgets('over budget: "Acima do orçamento em"', (tester) async {
    await pump(tester, _ready(budget: 100000, maintenance: [spent]));

    expect(
      find.text(keepMoneyTogether('Acima do orçamento em R\$ 200,00')),
      findsOneWidget,
    );
    expect(find.byType(BudgetGauge), findsOneWidget);
  });

  testWidgets('no budget: only "Gasto", no gauge', (tester) async {
    await pump(tester, _ready(maintenance: [spent]));

    expect(find.text(keepMoneyTogether('Gasto R\$ 1.200,00')), findsOneWidget);
    expect(find.byType(BudgetGauge), findsNothing);
  });

  testWidgets('planned total and spending by category', (tester) async {
    await pump(
      tester,
      _ready(
        mods: [
          mod(id: 'a', category: ModCategory.suspension, laborCostCents: 70000),
          mod(
            id: 'b',
            status: ModificationStatus.planned,
            estimatedCostCents: 250000,
          ),
        ],
      ),
    );

    expect(find.text('Planejado: R\$ 2.500,00'), findsOneWidget);
    expect(find.text('Suspensão'), findsOneWidget);
    expect(find.text('R\$ 700,00'), findsWidgets);
  });

  testWidgets('timeline shows status stamps, type and pending regularization', (
    tester,
  ) async {
    final pending = mod(id: 'p', status: ModificationStatus.installed);
    final withReg = ModificationWithItems(
      pending.modification.copyWith(
        requiresRegularization: true,
        regularizationStatus: const Value(RegularizationStatus.pending),
        title: 'Rebaixamento',
      ),
      const [],
    );
    await pump(tester, _ready(mods: [withReg], maintenance: [spent]));

    final timeline = find.byKey(const Key('timeline'));
    await tester.scrollUntilVisible(timeline, 200);
    expect(find.text('Rebaixamento'), findsOneWidget);
    expect(find.text('Instalada'), findsOneWidget);
    expect(find.text('Regularização pendente'), findsOneWidget);
    expect(find.text('Revisão'), findsOneWidget);
  });

  testWidgets('tapping a modification opens its edit form', (tester) async {
    await pump(tester, _ready(mods: [mod(id: 'm')]));

    final row = find.text('Mod m');
    await tester.scrollUntilVisible(row, 200);
    await tester.tap(row);
    await tester.pumpAndSettle();

    expect(find.byType(ModificationFormPage), findsOneWidget);
    expect(find.text('Editar modificação'), findsOneWidget);
  });

  testWidgets('add button offers new modification and new maintenance', (
    tester,
  ) async {
    await pump(tester, _ready());

    await tester.tap(find.text('Adicionar registro'));
    await tester.pumpAndSettle();
    expect(find.text('Nova modificação'), findsOneWidget);
    await tester.tap(find.text('Nova manutenção'));
    await tester.pumpAndSettle();

    expect(find.byType(MaintenanceFormPage), findsOneWidget);
  });

  testWidgets('last timeline row clears the FAB above the bottom inset', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3;
    // Edge-to-edge gesture bar: both padding and viewPadding.
    tester.view.padding = const FakeViewPadding(bottom: 48 * 3);
    tester.view.viewPadding = const FakeViewPadding(bottom: 48 * 3);
    addTearDown(tester.view.reset);
    await pump(
      tester,
      _ready(mods: [for (var i = 0; i < 12; i++) mod(id: '$i')]),
    );

    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, -5000),
      3000,
    );
    await tester.pumpAndSettle();

    final lastRow = tester.getRect(
      find.ancestor(of: find.text('Mod 11'), matching: find.byType(InkWell)),
    );
    final fab = tester.getRect(find.byType(FloatingActionButton));
    expect(lastRow.bottom, lessThan(fab.top));
  });

  testWidgets('notFound shows a message', (tester) async {
    await pump(
      tester,
      const VehicleDetailState(status: VehicleDetailStatus.notFound),
    );

    expect(find.text('Este veículo foi excluído.'), findsOneWidget);
  });
}
