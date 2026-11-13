import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/database/app_database.dart';
import '../../data/models/records.dart';
import '../../data/repositories/maintenance_repository.dart';
import '../../data/repositories/modification_repository.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../domain/cost_summary.dart';
import '../../domain/timeline.dart';

sealed class VehicleDetailEvent extends Equatable {
  const VehicleDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Starts watching the vehicle, its modifications and its maintenance.
final class VehicleDetailStarted extends VehicleDetailEvent {
  const VehicleDetailStarted();
}

enum VehicleDetailStatus { loading, ready, notFound, failure }

class VehicleDetailState extends Equatable {
  const VehicleDetailState({
    this.status = VehicleDetailStatus.loading,
    this.vehicle,
    this.timeline = const [],
    this.summary,
  });

  final VehicleDetailStatus status;
  final Vehicle? vehicle;
  final List<TimelineEntry> timeline;
  final CostSummary? summary;

  @override
  List<Object?> get props => [status, vehicle, timeline, summary];
}

/// Latest value of each source stream.
typedef _Snapshot = ({
  Vehicle? vehicle,
  List<ModificationWithItems> mods,
  List<MaintenanceWithItems> maintenance,
});

class VehicleDetailBloc extends Bloc<VehicleDetailEvent, VehicleDetailState> {
  VehicleDetailBloc(
    this.vehicleId, {
    required this._vehicles,
    required this._modifications,
    required this._maintenance,
  }) : super(const VehicleDetailState()) {
    on<VehicleDetailStarted>(_onStarted);
  }

  final String vehicleId;
  final VehicleRepository _vehicles;
  final ModificationRepository _modifications;
  final MaintenanceRepository _maintenance;

  Future<void> _onStarted(
    VehicleDetailStarted event,
    Emitter<VehicleDetailState> emit,
  ) {
    emit(const VehicleDetailState());
    return emit.forEach<_Snapshot>(
      _combined(),
      onData: (s) {
        final vehicle = s.vehicle;
        if (vehicle == null) {
          return const VehicleDetailState(status: VehicleDetailStatus.notFound);
        }
        return VehicleDetailState(
          status: VehicleDetailStatus.ready,
          vehicle: vehicle,
          timeline: buildTimeline(s.mods, s.maintenance),
          summary: CostSummary.compute(
            mods: s.mods,
            maintenance: s.maintenance,
            budgetCents: vehicle.projectBudgetCents,
          ),
        );
      },
      onError: (_, _) => VehicleDetailState(
        status: VehicleDetailStatus.failure,
        vehicle: state.vehicle,
        timeline: state.timeline,
        summary: state.summary,
      ),
    );
  }

  /// Emits the latest of the three streams once each has emitted at least
  /// once, then on every later emission. Cancelling the result cancels all
  /// three subscriptions.
  Stream<_Snapshot> _combined() {
    late final StreamController<_Snapshot> out;
    final subs = <StreamSubscription<Object?>>[];
    Vehicle? vehicle;
    List<ModificationWithItems>? mods;
    List<MaintenanceWithItems>? maintenance;
    var hasVehicle = false;

    void push() {
      final m = mods, r = maintenance;
      if (!hasVehicle || m == null || r == null) return;
      out.add((vehicle: vehicle, mods: m, maintenance: r));
    }

    out = StreamController<_Snapshot>(
      onListen: () {
        subs
          ..add(
            _vehicles.watchById(vehicleId).listen((v) {
              vehicle = v;
              hasVehicle = true;
              push();
            }, onError: out.addError),
          )
          ..add(
            _modifications.watchByVehicle(vehicleId).listen((v) {
              mods = v;
              push();
            }, onError: out.addError),
          )
          ..add(
            _maintenance.watchByVehicle(vehicleId).listen((v) {
              maintenance = v;
              push();
            }, onError: out.addError),
          );
      },
      onCancel: () => Future.wait([for (final s in subs) s.cancel()]),
    );
    return out.stream;
  }
}
