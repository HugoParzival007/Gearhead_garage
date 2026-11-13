import 'package:diario_de_garagem/app/app.dart';
import 'package:diario_de_garagem/data/database/app_database.dart';
import 'package:diario_de_garagem/data/database/enums.dart';
import 'package:diario_de_garagem/main.dart';
import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App smoke test over an in-memory database: never opens the real one.
void main() {
  testWidgets('opens on the empty garage, registers a vehicle', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );

    // Drift does real async work: let it run outside the fake clock.
    Future<void> settleDb() async {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
    }

    await tester.pumpWidget(
      AppDependencies(db: db, prefs: prefs, child: const DiarioApp()),
    );
    await settleDb();

    expect(find.text('Sua garagem está vazia'), findsOneWidget);

    await tester.tap(find.text('Adicionar veículo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Carro'));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Apelido'),
      'Golzinho',
    );
    await tester.enterText(find.widgetWithText(TextFormField, 'Marca'), 'VW');
    await tester.enterText(find.widgetWithText(TextFormField, 'Modelo'), 'Gol');
    final fuel = find.byType(DropdownButtonFormField<FuelType>);
    await tester.ensureVisible(fuel);
    await tester.tap(fuel);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Flex').last);
    await tester.pumpAndSettle();
    final save = find.text('Salvar veículo');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    await settleDb();

    expect(find.text('Golzinho'), findsOneWidget);
    expect(find.text('VW Gol'), findsOneWidget);
    expect(find.text('Selecionado'), findsOneWidget);
    expect(prefs.getString('selected_vehicle_id'), isNotNull);

    // Dispose the tree so drift's stream subscriptions close before the DB.
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(db.close);
  });
}
