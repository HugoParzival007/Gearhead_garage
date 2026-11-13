import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const DiarioApp());
}

class DiarioApp extends StatelessWidget {
  const DiarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Diário de Garagem',
      home: Scaffold(
        body: Center(child: Text('Sua garagem está vazia')),
      ),
    );
  }
}
