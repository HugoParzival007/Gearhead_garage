import 'package:diario_de_garagem/app/theme.dart';
import 'package:diario_de_garagem/data/database/enums.dart';
import 'package:diario_de_garagem/data/models/drafts.dart';
import 'package:diario_de_garagem/data/repositories/maintenance_repository.dart';
import 'package:diario_de_garagem/data/repositories/modification_repository.dart';
import 'package:diario_de_garagem/features/records/maintenance_form_page.dart';
import 'package:diario_de_garagem/features/records/modification_form_page.dart';
import 'package:diario_de_garagem/features/records/save_record_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/fixtures.dart';

class _MockMods extends Mock implements ModificationRepository {}

class _MockMaintenance extends Mock implements MaintenanceRepository {}

void main() {
  late _MockMods mods;
  late _MockMaintenance maintenance;

  setUpAll(() {
    registerFallbackValue(
      ModificationDraft(
        vehicleId: 'v',
        title: 't',
        category: ModCategory.other,
        status: ModificationStatus.installed,
        date: DateTime.utc(2026),
      ),
    );
    registerFallbackValue(
      MaintenanceDraft(
        vehicleId: 'v',
        type: MaintenanceType.other,
        date: DateTime.utc(2026),
      ),
    );
  });

  setUp(() {
    mods = _MockMods();
    maintenance = _MockMaintenance();
  });

  Future<void> pump(WidgetTester tester, Widget page) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: BlocProvider(
          create: (_) =>
              SaveRecordCubit(modifications: mods, maintenance: maintenance),
          child: page,
        ),
      ),
    );
  }

  Finder field(String label) => find.widgetWithText(TextFormField, label);

  Future<void> tapVisible(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  group('ModificationFormPage', () {
    testWidgets('"Exige regularização" shows status with "Pendente" selected', (
      tester,
    ) async {
      await pump(tester, const ModificationFormPage(vehicleId: 'v'));

      expect(find.text('Pendente'), findsNothing);
      await tapVisible(tester, find.text('Exige regularização (CSV)'));

      final status = find.byType(SegmentedButton<RegularizationStatus>);
      expect(status, findsOneWidget);
      expect(find.text('Pendente'), findsOneWidget);
      expect(
        tester.widget<SegmentedButton<RegularizationStatus>>(status).selected,
        {RegularizationStatus.pending},
      );
    });

    testWidgets('"Planejada" shows "Custo estimado"; "Instalada" hides it', (
      tester,
    ) async {
      await pump(tester, const ModificationFormPage(vehicleId: 'v'));
      final estimate = field('Custo estimado (R\$)');

      await tapVisible(tester, find.text('Planejada'));
      expect(estimate, findsOneWidget);

      await tapVisible(tester, find.text('Instalada'));
      expect(estimate, findsNothing);
    });

    testWidgets('add two parts and remove one leaves one row', (tester) async {
      await pump(tester, const ModificationFormPage(vehicleId: 'v'));
      final add = find.text('Adicionar peça');

      await tapVisible(tester, add);
      await tapVisible(tester, add);
      expect(field('Nome da peça'), findsNWidgets(2));

      await tapVisible(tester, find.byTooltip('Remover peça').first);
      expect(field('Nome da peça'), findsOneWidget);
    });

    testWidgets('invalid money shows the FormatException message', (
      tester,
    ) async {
      await pump(tester, const ModificationFormPage(vehicleId: 'v'));
      await tester.enterText(field('Título'), 'Escape');
      final labor = field('Mão de obra (R\$)');
      await tester.ensureVisible(labor);
      await tester.enterText(labor, '1.234,567');

      await tapVisible(tester, find.text('Salvar modificação'));

      expect(find.text('Use no máximo 2 casas decimais.'), findsOneWidget);
      verifyNever(() => mods.save(any(), any(), id: any(named: 'id')));
    });

    testWidgets('valid form saves the draft with parts', (tester) async {
      when(() => mods.save(any(), any(), id: any(named: 'id')))
          .thenAnswer((_) async => 'm1');
      await pump(tester, const ModificationFormPage(vehicleId: 'v'));

      await tester.enterText(field('Título'), '  Escape inox ');
      await tapVisible(
        tester,
        find.byType(DropdownButtonFormField<ModCategory>),
      );
      await tester.tap(find.text('Admissão e escape').last);
      await tester.pumpAndSettle();
      await tapVisible(tester, find.text('Adicionar peça'));
      await tester.enterText(field('Nome da peça'), 'Ponteira');
      await tester.enterText(field('Qtd.'), '2');
      await tester.enterText(field('Valor unit. (R\$)'), '150,00');
      final labor = field('Mão de obra (R\$)');
      await tester.ensureVisible(labor);
      await tester.enterText(labor, '80');
      await tapVisible(tester, find.text('Salvar modificação'));

      final captured = verify(
        () => mods.save(captureAny(), captureAny(), id: null),
      ).captured;
      final draft = captured[0] as ModificationDraft;
      expect(draft.title, 'Escape inox');
      expect(draft.vehicleId, 'v');
      expect(draft.status, ModificationStatus.installed);
      expect(draft.category, ModCategory.intakeExhaust);
      expect(draft.laborCostCents, 8000);
      expect(draft.requiresRegularization, isFalse);
      expect(draft.regularizationStatus, isNull);
      expect(draft.estimatedCostCents, isNull);
      expect(captured[1], const [
        LineItemDraft('Ponteira', quantity: 2, unitPriceCents: 15000),
      ]);
    });

    testWidgets('editing asks for confirmation before deleting', (
      tester,
    ) async {
      when(() => mods.softDelete('m')).thenAnswer((_) async {});
      await pump(
        tester,
        ModificationFormPage(
          vehicleId: 'v',
          initial: mod(id: 'm'),
        ),
      );

      expect(find.text('Editar modificação'), findsOneWidget);
      await tapVisible(tester, find.text('Excluir modificação'));
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      verifyNever(() => mods.softDelete(any()));

      await tapVisible(tester, find.text('Excluir modificação'));
      await tester.tap(find.widgetWithText(FilledButton, 'Excluir'));
      await tester.pumpAndSettle();
      verify(() => mods.softDelete('m')).called(1);
    });
  });

  group('MaintenanceFormPage', () {
    testWidgets('has no status or regularization; saves the type', (
      tester,
    ) async {
      when(() => maintenance.save(any(), any(), id: any(named: 'id')))
          .thenAnswer((_) async => 'r1');
      await pump(tester, const MaintenanceFormPage(vehicleId: 'v'));

      expect(find.text('Exige regularização (CSV)'), findsNothing);
      expect(find.text('Planejada'), findsNothing);

      await tapVisible(
        tester,
        find.byType(DropdownButtonFormField<MaintenanceType>),
      );
      await tester.tap(find.text('Troca de óleo').last);
      await tester.pumpAndSettle();
      await tapVisible(tester, find.text('Salvar manutenção'));

      final draft =
          verify(() => maintenance.save(captureAny(), any(), id: null))
                  .captured
                  .single
              as MaintenanceDraft;
      expect(draft.type, MaintenanceType.oilChange);
    });

    testWidgets('missing type shows "Escolha o tipo"', (tester) async {
      await pump(tester, const MaintenanceFormPage(vehicleId: 'v'));

      await tapVisible(tester, find.text('Salvar manutenção'));

      expect(find.text('Escolha o tipo'), findsOneWidget);
    });
  });
}
