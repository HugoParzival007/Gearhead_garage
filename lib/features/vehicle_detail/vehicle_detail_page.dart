import 'package:material_ui/material_ui.dart';

/// Placeholder until Task 8 builds the real vehicle detail.
class VehicleDetailPage extends StatelessWidget {
  const VehicleDetailPage({
    super.key,
    required this.vehicleId,
    required this.nickname,
  });

  final String vehicleId;
  final String nickname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(nickname)),
      body: const Center(child: Text('Detalhes do veículo em breve')),
    );
  }
}
