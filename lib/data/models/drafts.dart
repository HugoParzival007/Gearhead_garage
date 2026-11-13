import 'package:equatable/equatable.dart';

import '../database/enums.dart';

/// Editable vehicle fields, before persistence.
class VehicleDraft extends Equatable {
  const VehicleDraft({
    required this.vehicleType,
    required this.nickname,
    required this.make,
    required this.model,
    required this.fuelType,
    required this.currentKm,
    this.version,
    this.year,
    this.engine,
    this.plate,
    this.projectBudgetCents,
  });

  final VehicleType vehicleType;
  final String nickname;
  final String make;
  final String model;
  final String? version;
  final int? year;
  final String? engine;
  final FuelType fuelType;
  final int currentKm;
  final String? plate;
  final int? projectBudgetCents;

  @override
  List<Object?> get props => [
    vehicleType,
    nickname,
    make,
    model,
    version,
    year,
    engine,
    fuelType,
    currentKm,
    plate,
    projectBudgetCents,
  ];
}
