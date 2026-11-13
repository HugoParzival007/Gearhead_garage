import 'package:bloc_test/bloc_test.dart';
import 'package:diario_de_garagem/app/theme.dart';
import 'package:diario_de_garagem/data/database/app_database.dart';
import 'package:diario_de_garagem/data/database/enums.dart';
import 'package:diario_de_garagem/data/models/drafts.dart';
import 'package:diario_de_garagem/data/repositories/maintenance_repository.dart';
import 'package:diario_de_garagem/data/repositories/modification_repository.dart';
import 'package:diario_de_garagem/data/repositories/vehicle_repository.dart';
import 'package:diario_de_garagem/features/garage/garage_bloc.dart';
import 'package:diario_de_garagem/features/garage/garage_page.dart';
import 'package:diario_de_garagem/features/garage/vehicle_form_page.dart';
import 'package:diario_de_garagem/features/vehicle_detail/vehicle_detail_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockGarageBloc extends MockBloc<GarageEvent, GarageState>
    implements GarageBloc {}

class _MockVehicles extends Mock implements VehicleRepository {}

class _MockMods extends Mock implements ModificationRepository {}

class _MockMaintenance extends Mock implements MaintenanceRepository {}

Vehicle _vehicle(String id, String nickname, VehicleType type) => Vehicle(
  id: id,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  vehicleType: type,
  nickname: nickname,
  make: type == VehicleType.car ? 'VW' : 'Honda',
  model: type == VehicleType.car ? 'Gol' : 'CB 300',
  fuelType: FuelType.flex,
  currentKm: 0,
);

Widget _host(Widget child) => MaterialApp(theme: AppTheme.light(), home: child);

void main() {
  group('GaragePage', () {
    late _MockGarageBloc bloc;

    setUpAll(() => registerFallbackValue(const GarageStarted()));

    setUp(() => bloc = _MockGarageBloc());

    Future<void> pumpPage(WidgetTester tester, GarageState state) async {
      when(() => bloc.state).thenReturn(state);
      // The detail page opened from the list watches these.
      final vehicles = _MockVehicles();
      final mods = _MockMods();
      final maintenance = _MockMaintenance();
      when(() => vehicles.watchById(any())).thenAnswer((_) => Stream.empty());
      when(() => mods.watchByVehicle(any())).thenAnswer((_) => Stream.empty());
      when(() => maintenance.watchByVehicle(any()))
          .thenAnswer((_) => Stream.empty());
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<VehicleRepository>.value(value: vehicles),
            RepositoryProvider<ModificationRepository>.value(value: mods),
            RepositoryProvider<MaintenanceRepository>.value(value: maintenance),
          ],
          child: _host(
            BlocProvider<GarageBloc>.value(
              value: bloc,
              child: const GaragePage(),
            ),
          ),
        ),
      );
    }

    testWidgets('empty garage shows the message and the add button', (
      tester,
    ) async {
      await pumpPage(tester, const GarageState(status: GarageStatus.ready));

      expect(find.text('Sua garagem está vazia'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Adicionar veículo'),
        findsOneWidget,
      );
    });

    testWidgets('add button opens the vehicle form', (tester) async {
      await pumpPage(tester, const GarageState(status: GarageStatus.ready));

      await tester.tap(find.text('Adicionar veículo'));
      await tester.pumpAndSettle();

      expect(find.byType(VehicleFormPage), findsOneWidget);
    });

    testWidgets('lists vehicles with nickname, make/model and type icon', (
      tester,
    ) async {
      await pumpPage(
        tester,
        GarageState(
          status: GarageStatus.ready,
          vehicles: [
            _vehicle('a', 'Golzinho', VehicleType.car),
            _vehicle('b', 'Cebolinha', VehicleType.motorcycle),
          ],
          selectedId: 'b',
        ),
      );

      expect(find.text('Golzinho'), findsOneWidget);
      expect(find.text('VW Gol'), findsOneWidget);
      expect(find.text('Cebolinha'), findsOneWidget);
      expect(find.text('Honda CB 300'), findsOneWidget);
      expect(find.byIcon(Icons.directions_car_outlined), findsOneWidget);
      expect(find.byIcon(Icons.two_wheeler_outlined), findsOneWidget);
      expect(find.text('Selecionado'), findsOneWidget);
    });

    testWidgets('tapping a vehicle selects it and opens the detail', (
      tester,
    ) async {
      await pumpPage(
        tester,
        GarageState(
          status: GarageStatus.ready,
          vehicles: [_vehicle('a', 'Golzinho', VehicleType.car)],
          selectedId: 'a',
        ),
      );

      await tester.tap(find.text('Golzinho'));
      // The detail keeps a loading spinner: pumpAndSettle would not settle.
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      verify(() => bloc.add(const GarageVehicleSelected('a'))).called(1);
      expect(find.byType(VehicleDetailPage), findsOneWidget);
      expect(find.text('Golzinho'), findsWidgets);
    });

    testWidgets('failure shows the error message', (tester) async {
      await pumpPage(
        tester,
        const GarageState(
          status: GarageStatus.failure,
          errorMessage: 'Não foi possível carregar a garagem.',
        ),
      );

      expect(find.text('Não foi possível carregar a garagem.'), findsOneWidget);
    });
  });

  group('VehicleFormPage', () {
    Finder field(String label) => find.widgetWithText(TextFormField, label);

    Future<void> save(WidgetTester tester) async {
      final button = find.widgetWithText(FilledButton, 'Salvar veículo');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
    }

    testWidgets('empty nickname shows "Informe o apelido"', (tester) async {
      await tester.pumpWidget(_host(const VehicleFormPage()));

      await save(tester);

      expect(find.text('Informe o apelido'), findsOneWidget);
      expect(find.text('Escolha o tipo'), findsOneWidget);
      expect(find.text('Informe a marca'), findsOneWidget);
      expect(find.text('Informe o modelo'), findsOneWidget);
      expect(find.text('Escolha o combustível'), findsOneWidget);
    });

    testWidgets('budget "abc" shows the FormatException message', (
      tester,
    ) async {
      await tester.pumpWidget(_host(const VehicleFormPage()));

      final budget = field('Orçamento do projeto (R\$)');
      await tester.ensureVisible(budget);
      await tester.enterText(budget, 'abc');
      await save(tester);

      expect(
        find.text('Valor inválido. Use o formato 1.234,56.'),
        findsOneWidget,
      );
    });

    testWidgets('valid form pops a VehicleDraft', (tester) async {
      VehicleDraft? result;
      await tester.pumpWidget(
        _host(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await Navigator.of(context).push<VehicleDraft>(
                  MaterialPageRoute(builder: (_) => const VehicleFormPage()),
                );
              },
              child: const Text('abrir'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Moto'));
      await tester.enterText(field('Apelido'), '  Cebolinha ');
      await tester.enterText(field('Marca'), 'Honda');
      await tester.enterText(field('Modelo'), 'CB 300');
      final fuel = find.byType(DropdownButtonFormField<FuelType>);
      await tester.ensureVisible(fuel);
      await tester.tap(fuel);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Gasolina').last);
      await tester.pumpAndSettle();
      final km = field('Quilometragem atual');
      await tester.ensureVisible(km);
      await tester.enterText(km, '12345');
      final budget = field('Orçamento do projeto (R\$)');
      await tester.ensureVisible(budget);
      await tester.enterText(budget, '1.500,50');
      await save(tester);

      expect(
        result,
        const VehicleDraft(
          vehicleType: VehicleType.motorcycle,
          nickname: 'Cebolinha',
          make: 'Honda',
          model: 'CB 300',
          fuelType: FuelType.gasoline,
          currentKm: 12345,
          projectBudgetCents: 150050,
        ),
      );
    });

    testWidgets('edit mode pre-fills every field and pops the edited draft', (
      tester,
    ) async {
      final initial = Vehicle(
        id: 'v1',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
        vehicleType: VehicleType.motorcycle,
        nickname: 'Cebolinha',
        make: 'Honda',
        model: 'CB 300',
        version: 'Twister',
        year: 2015,
        engine: '300cc',
        fuelType: FuelType.gasoline,
        currentKm: 12345,
        plate: 'ABC1D23',
        projectBudgetCents: 150050,
      );
      VehicleDraft? result;
      await tester.pumpWidget(
        _host(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await Navigator.of(context).push<VehicleDraft>(
                  MaterialPageRoute(
                    builder: (_) => VehicleFormPage(initial: initial),
                  ),
                );
              },
              child: const Text('abrir'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      expect(find.text('Editar veículo'), findsOneWidget);
      String text(String label) =>
          tester.widget<TextFormField>(field(label)).controller!.text;
      expect(text('Apelido'), 'Cebolinha');
      expect(text('Marca'), 'Honda');
      expect(text('Modelo'), 'CB 300');
      expect(text('Versão (opcional)'), 'Twister');
      expect(text('Ano (opcional)'), '2015');
      expect(text('Motor (opcional)'), '300cc');
      expect(text('Quilometragem atual'), '12345');
      expect(text('Placa (opcional)'), 'ABC1D23');
      expect(text('Orçamento do projeto (R\$)'), '1.500,50');
      expect(find.text('Gasolina'), findsOneWidget);

      final budget = field('Orçamento do projeto (R\$)');
      await tester.ensureVisible(budget);
      await tester.enterText(budget, '20.000');
      await save(tester);

      expect(
        result,
        const VehicleDraft(
          vehicleType: VehicleType.motorcycle,
          nickname: 'Cebolinha',
          make: 'Honda',
          model: 'CB 300',
          version: 'Twister',
          year: 2015,
          engine: '300cc',
          fuelType: FuelType.gasoline,
          currentKm: 12345,
          plate: 'ABC1D23',
          projectBudgetCents: 2000000,
        ),
      );
    });

    testWidgets('nickname is limited to 60 characters', (tester) async {
      await tester.pumpWidget(_host(const VehicleFormPage()));

      await tester.enterText(field('Apelido'), 'x' * 70);
      await tester.pump();

      final editable = tester.widget<EditableText>(
        find.descendant(
          of: field('Apelido'),
          matching: find.byType(EditableText),
        ),
      );
      expect(editable.controller.text.length, 60);
    });
  });
}
