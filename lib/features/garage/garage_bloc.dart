import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/database/app_database.dart';
import '../../data/models/drafts.dart';
import '../../data/repositories/selected_vehicle_store.dart';
import '../../data/repositories/vehicle_repository.dart';

sealed class GarageEvent extends Equatable {
  const GarageEvent();

  @override
  List<Object?> get props => [];
}

/// Starts watching the active vehicles.
final class GarageStarted extends GarageEvent {
  const GarageStarted();
}

final class GarageVehicleSelected extends GarageEvent {
  const GarageVehicleSelected(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

final class GarageVehicleCreated extends GarageEvent {
  const GarageVehicleCreated(this.draft);

  final VehicleDraft draft;

  @override
  List<Object?> get props => [draft];
}

enum GarageStatus { loading, ready, failure }

class GarageState extends Equatable {
  const GarageState({
    this.status = GarageStatus.loading,
    this.vehicles = const [],
    this.selectedId,
    this.errorMessage,
  });

  final GarageStatus status;
  final List<Vehicle> vehicles;
  final String? selectedId;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, vehicles, selectedId, errorMessage];
}

class GarageBloc extends Bloc<GarageEvent, GarageState> {
  GarageBloc({required this._vehicles, required this._selection})
    : super(const GarageState()) {
    on<GarageStarted>(_onStarted);
    on<GarageVehicleSelected>(_onSelected);
    on<GarageVehicleCreated>(_onCreated);
  }

  static const loadError = 'Não foi possível carregar a garagem.';
  static const createError = 'Não foi possível salvar o veículo.';

  final VehicleRepository _vehicles;
  final SelectedVehicleStore _selection;

  Future<void> _onStarted(GarageStarted event, Emitter<GarageState> emit) {
    emit(const GarageState(status: GarageStatus.loading));
    return emit.forEach<List<Vehicle>>(
      _vehicles.watchActive(),
      onData: (list) {
        final saved = state.selectedId ?? _selection.read();
        final selected = list.any((v) => v.id == saved)
            ? saved
            : (list.isEmpty ? null : list.first.id);
        if (selected != _selection.read()) {
          unawaited(_selection.write(selected));
        }
        return GarageState(
          status: GarageStatus.ready,
          vehicles: list,
          selectedId: selected,
        );
      },
      onError: (_, _) => GarageState(
        status: GarageStatus.failure,
        vehicles: state.vehicles,
        selectedId: state.selectedId,
        errorMessage: loadError,
      ),
    );
  }

  Future<void> _onSelected(
    GarageVehicleSelected event,
    Emitter<GarageState> emit,
  ) async {
    emit(_withSelection(event.id));
    await _selection.write(event.id);
  }

  Future<void> _onCreated(
    GarageVehicleCreated event,
    Emitter<GarageState> emit,
  ) async {
    final String id;
    try {
      id = await _vehicles.create(event.draft);
    } on Object {
      emit(
        GarageState(
          status: state.status,
          vehicles: state.vehicles,
          selectedId: state.selectedId,
          errorMessage: createError,
        ),
      );
      return;
    }
    emit(_withSelection(id));
    await _selection.write(id);
  }

  GarageState _withSelection(String id) => GarageState(
    status: state.status,
    vehicles: state.vehicles,
    selectedId: id,
  );
}
