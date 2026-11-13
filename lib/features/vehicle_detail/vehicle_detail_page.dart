import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/theme.dart';
import '../../core/money.dart';
import '../../data/database/app_database.dart';
import '../../data/database/enums.dart';
import '../../domain/cost_summary.dart';
import '../../domain/timeline.dart';
import '../records/form_fields.dart';
import '../records/maintenance_form_page.dart';
import '../records/modification_form_page.dart';
import 'budget_gauge.dart';
import 'vehicle_detail_bloc.dart';

/// `123456` -> `123.456 km`.
String formatKm(int km) {
  final digits = km.toString();
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write('.');
    buf.write(digits[i]);
  }
  return '$buf km';
}

/// Vehicle detail: header, budget, costs by category and the timeline.
/// Builds its [VehicleDetailBloc] from the repositories above it.
class VehicleDetailPage extends StatelessWidget {
  const VehicleDetailPage({
    super.key,
    required this.vehicleId,
    required this.nickname,
  });

  final String vehicleId;

  /// Shown in the app bar until the vehicle loads.
  final String nickname;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VehicleDetailBloc(
        vehicleId,
        vehicles: context.read(),
        modifications: context.read(),
        maintenance: context.read(),
      )..add(const VehicleDetailStarted()),
      child: VehicleDetailView(nickname: nickname),
    );
  }
}

class VehicleDetailView extends StatelessWidget {
  const VehicleDetailView({super.key, required this.nickname});

  final String nickname;

  static Future<void> _addRecord(BuildContext context, String vehicleId) async {
    final navigator = Navigator.of(context);
    final route = await showModalBottomSheet<Route<bool>>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.build_outlined),
              title: const Text('Nova modificação'),
              onTap: () =>
                  Navigator.of(context)
                      .pop(ModificationFormPage.route(vehicleId: vehicleId)),
            ),
            ListTile(
              leading: const Icon(Icons.oil_barrel_outlined),
              title: const Text('Nova manutenção'),
              onTap: () =>
                  Navigator.of(context)
                      .pop(MaintenanceFormPage.route(vehicleId: vehicleId)),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (route != null) await navigator.push(route);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleDetailBloc, VehicleDetailState>(
      builder: (context, state) {
        final vehicle = state.vehicle;
        final summary = state.summary;
        final ready = vehicle != null && summary != null;
        return Scaffold(
          appBar: AppBar(title: Text(vehicle?.nickname ?? nickname)),
          floatingActionButton: ready
              ? FloatingActionButton.extended(
                  onPressed: () => _addRecord(context, vehicle.id),
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar registro'),
                )
              : null,
          body: switch (state.status) {
            _ when ready => _Body(
              vehicle: vehicle,
              summary: summary,
              timeline: state.timeline,
            ),
            VehicleDetailStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            VehicleDetailStatus.notFound => const _Message(
              'Este veículo foi excluído.',
            ),
            _ => const _Message('Não foi possível carregar o veículo.'),
          },
        );
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.vehicle,
    required this.summary,
    required this.timeline,
  });

  final Vehicle vehicle;
  final CostSummary summary;
  final List<TimelineEntry> timeline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final muted = theme.colorScheme.onSurfaceVariant;
    const pad = EdgeInsets.symmetric(horizontal: 16);
    const section = SizedBox(height: 32);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          sliver: SliverList.list(
            children: [
              _Header(vehicle: vehicle),
              section,
              Text('Orçamento do projeto', style: text.titleLarge),
              const SizedBox(height: 8),
              BudgetBlock(summary: summary),
              const SizedBox(height: 16),
              Text(
                'Planejado: ${formatBrl(summary.plannedCents)}',
                style: text.bodyLarge?.merge(AppFonts.figures),
              ),
              section,
              Text('Gasto por categoria', style: text.titleLarge),
              const SizedBox(height: 4),
              _CategoryList(summary: summary),
              section,
              Text(
                'Linha do tempo',
                key: const Key('timeline'),
                style: text.titleLarge,
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
        if (timeline.isEmpty)
          SliverPadding(
            padding: pad,
            sliver: SliverToBoxAdapter(
              child: Text(
                'Nenhum registro ainda. Use "Adicionar registro" para lançar '
                'uma modificação ou manutenção.',
                style: text.bodyMedium?.copyWith(color: muted),
              ),
            ),
          )
        else
          SliverList.separated(
            itemCount: timeline.length,
            separatorBuilder: (_, _) =>
                const Divider(indent: 16, endIndent: 16),
            itemBuilder: (context, i) =>
                _TimelineRow(entry: timeline[i], vehicleId: vehicle.id),
          ),
        // Room for the FAB over the last row, above the system bottom inset.
        SliverToBoxAdapter(
          child: SizedBox(height: 96 + MediaQuery.paddingOf(context).bottom),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final isCar = vehicle.vehicleType == VehicleType.car;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(
                isCar
                    ? Icons.directions_car_outlined
                    : Icons.two_wheeler_outlined,
                size: 28,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  '${vehicle.vehicleType.label} · ${vehicle.make} '
                  '${vehicle.model}',
                  style: theme.textTheme.bodyLarge?.copyWith(color: muted),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Km atual',
              style: theme.textTheme.bodySmall?.copyWith(color: muted),
            ),
            Text(
              formatKm(vehicle.currentKm),
              style: theme.textTheme.headlineSmall?.merge(AppFonts.figures),
            ),
          ],
        ),
      ],
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({required this.summary});

  final CostSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = <(String, int)>[
      for (final c in ModCategory.values)
        if (summary.spentByCategory[c] case final cents?) (c.label, cents),
      if (summary.maintenanceSpentCents > 0)
        ('Manutenção', summary.maintenanceSpentCents),
    ];
    if (rows.isEmpty) {
      return Text(
        'Nenhum gasto registrado ainda.',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }
    final value = theme.textTheme.bodyLarge?.merge(AppFonts.figures);
    return Column(
      children: [
        for (final (i, (label, cents)) in rows.indexed) ...[
          if (i > 0) const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
                Text(formatBrl(cents), style: value),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.entry, required this.vehicleId});

  final TimelineEntry entry;
  final String vehicleId;

  void _open(BuildContext context) {
    final route = switch (entry) {
      ModificationEntry(:final value) => ModificationFormPage.route(
        vehicleId: vehicleId,
        initial: value,
      ),
      MaintenanceEntry(:final value) => MaintenanceFormPage.route(
        vehicleId: vehicleId,
        initial: value,
      ),
    };
    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final muted = theme.colorScheme.onSurfaceVariant;
    final red = AppColors.legible(AppColors.faixaVermelha, theme.brightness);
    final km = entry.km;

    final (
      String title,
      String detail,
      Widget? stamp,
      bool pending,
    ) = switch (entry) {
      ModificationEntry(:final value) => (
        value.modification.title,
        _modDetail(value.modification, value.totalCents),
        _Stamp(
          value.modification.status.label,
          color: switch (value.modification.status) {
            ModificationStatus.installed => AppColors.legible(
              AppColors.instalado,
              theme.brightness,
            ),
            _ => muted,
          },
        ),
        value.modification.requiresRegularization &&
            value.modification.regularizationStatus ==
                RegularizationStatus.pending,
      ),
      MaintenanceEntry(:final value) => (
        value.record.type.label,
        'Manutenção · ${formatBrl(value.totalCents)}',
        null,
        false,
      ),
    };

    return InkWell(
      onTap: () => _open(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 88,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatRecordDate(entry.date),
                    softWrap: false,
                    style: text.bodyLarge?.merge(AppFonts.figures),
                  ),
                  if (km != null)
                    Text(
                      formatKm(km),
                      style: text.bodyMedium
                          ?.merge(AppFonts.figures)
                          .copyWith(color: muted),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: text.titleLarge?.copyWith(height: 1.15)),
                  const SizedBox(height: 2),
                  Text(
                    keepMoneyTogether(detail),
                    style: text.bodyMedium?.copyWith(color: muted),
                  ),
                  if (pending) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.report_outlined, size: 18, color: red),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Regularização pendente',
                            style: text.labelMedium?.copyWith(color: red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (stamp != null) ...[const SizedBox(width: 8), stamp],
          ],
        ),
      ),
    );
  }

  static String _modDetail(Modification m, int totalCents) {
    final category = m.category.label;
    if (m.status == ModificationStatus.planned && totalCents == 0) {
      final est = m.estimatedCostCents;
      return est == null ? category : '$category · estimado ${formatBrl(est)}';
    }
    return '$category · ${formatBrl(totalCents)}';
  }
}

/// Rubber-stamp badge: 4dp corners, 1.5dp border.
class _Stamp extends StatelessWidget {
  const _Stamp(this.label, {required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
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
