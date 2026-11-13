import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/theme.dart';
import '../../data/database/app_database.dart';
import '../../data/database/enums.dart';
import '../../data/models/drafts.dart';
import '../vehicle_detail/vehicle_detail_page.dart';
import 'garage_bloc.dart';
import 'vehicle_form_page.dart';

class GaragePage extends StatelessWidget {
  const GaragePage({super.key});

  static Future<void> _addVehicle(BuildContext context) async {
    final bloc = context.read<GarageBloc>();
    final draft = await Navigator.of(context).push<VehicleDraft>(
      MaterialPageRoute(builder: (_) => const VehicleFormPage()),
    );
    if (draft != null) bloc.add(GarageVehicleCreated(draft));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GarageBloc, GarageState>(
      listenWhen: (prev, next) =>
          next.errorMessage != null &&
          next.errorMessage != prev.errorMessage &&
          next.status != GarageStatus.failure,
      listener: (context, state) =>
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage!))),
      builder: (context, state) {
        final hasVehicles = state.vehicles.isNotEmpty;
        return Scaffold(
          appBar: AppBar(title: const Text('Garagem')),
          floatingActionButton: hasVehicles
              ? FloatingActionButton.extended(
                  onPressed: () => _addVehicle(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar veículo'),
                )
              : null,
          body: switch (state) {
            GarageState(status: GarageStatus.loading) => const Center(
              child: CircularProgressIndicator(),
            ),
            // Local DB failure: retrying would not help, so no action.
            GarageState(status: GarageStatus.failure) when !hasVehicles =>
              _Message(title: state.errorMessage ?? GarageBloc.loadError),
            _ when !hasVehicles => _Message(
              title: 'Sua garagem está vazia',
              body: 'Cadastre seu carro ou moto para começar o diário.',
              actionLabel: 'Adicionar veículo',
              onAction: () => _addVehicle(context),
            ),
            _ => _VehicleList(
              vehicles: state.vehicles,
              selectedId: state.selectedId,
            ),
          },
        );
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.title,
    this.body,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: text.headlineSmall, textAlign: TextAlign.center),
            if (body != null) ...[
              const SizedBox(height: 8),
              Text(
                body!,
                style: text.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class _VehicleList extends StatelessWidget {
  const _VehicleList({required this.vehicles, required this.selectedId});

  final List<Vehicle> vehicles;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // Room for the FAB over the last row.
      padding: const EdgeInsets.only(bottom: 96),
      itemCount: vehicles.length,
      separatorBuilder: (_, _) => const Divider(),
      itemBuilder: (context, i) => _VehicleTile(
        vehicle: vehicles[i],
        selected: vehicles[i].id == selectedId,
      ),
    );
  }
}

class _VehicleTile extends StatelessWidget {
  const _VehicleTile({required this.vehicle, required this.selected});

  final Vehicle vehicle;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCar = vehicle.vehicleType == VehicleType.car;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(
        isCar ? Icons.directions_car_outlined : Icons.two_wheeler_outlined,
        semanticLabel: vehicle.vehicleType.label,
        size: 28,
      ),
      title: Text(
        vehicle.nickname,
        style: theme.textTheme.titleLarge,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${vehicle.make} ${vehicle.model}',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: selected ? const _Stamp('Selecionado') : null,
      selected: selected,
      onTap: () {
        context.read<GarageBloc>().add(GarageVehicleSelected(vehicle.id));
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => VehicleDetailPage(
              vehicleId: vehicle.id,
              nickname: vehicle.nickname,
            ),
          ),
        );
      },
    );
  }
}

/// Rubber-stamp badge: 4dp corners, 1.5dp border.
class _Stamp extends StatelessWidget {
  const _Stamp(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppTheme.fieldRadius,
        border: Border.all(color: color, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium
              ?.copyWith(color: color),
        ),
      ),
    );
  }
}
