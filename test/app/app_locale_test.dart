import 'package:diario_de_garagem/app/app.dart';
import 'package:diario_de_garagem/data/database/app_database.dart';
import 'package:diario_de_garagem/features/garage/garage_page.dart';
import 'package:diario_de_garagem/main.dart';
import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('date picker speaks pt-BR and reads dd/mm/aaaa', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    await tester.pumpWidget(
      AppDependencies(db: db, prefs: prefs, child: const DiarioApp()),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(GaragePage));
    expect(Localizations.localeOf(context), const Locale('pt', 'BR'));
    showDatePicker(
      context: context,
      initialDate: DateTime(2026, 3, 15),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('março'), findsWidgets);

    // Text entry mode uses the pt-BR format.
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    expect(find.text('15/03/2026'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(db.close);
  });
}
