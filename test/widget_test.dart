import 'package:diario_de_garagem/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('abre com garagem vazia', (tester) async {
    await tester.pumpWidget(const DiarioApp());

    expect(find.text('Sua garagem está vazia'), findsOneWidget);
  });
}
