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

/// Part/material line of a modification or maintenance, before persistence.
class LineItemDraft extends Equatable {
  const LineItemDraft(
    this.name, {
    this.brand,
    this.partCode,
    this.quantity = 1,
    required this.unitPriceCents,
  });

  final String name;
  final String? brand;
  final String? partCode;
  final int quantity;
  final int unitPriceCents;

  @override
  List<Object?> get props => [name, brand, partCode, quantity, unitPriceCents];
}

/// Editable modification fields, before persistence.
class ModificationDraft extends Equatable {
  const ModificationDraft({
    required this.vehicleId,
    required this.title,
    required this.category,
    required this.status,
    required this.date,
    this.km,
    this.laborCostCents = 0,
    this.laborBy,
    this.notes,
    this.performanceNotes,
    this.estimatedCostCents,
    this.requiresRegularization = false,
    this.regularizationStatus,
  });

  final String vehicleId;
  final String title;
  final ModCategory category;
  final ModificationStatus status;
  final DateTime date;
  final int? km;
  final int laborCostCents;
  final String? laborBy;
  final String? notes;
  final String? performanceNotes;
  final int? estimatedCostCents;
  final bool requiresRegularization;
  final RegularizationStatus? regularizationStatus;

  @override
  List<Object?> get props => [
    vehicleId,
    title,
    category,
    status,
    date,
    km,
    laborCostCents,
    laborBy,
    notes,
    performanceNotes,
    estimatedCostCents,
    requiresRegularization,
    regularizationStatus,
  ];
}

/// Editable maintenance fields, before persistence.
class MaintenanceDraft extends Equatable {
  const MaintenanceDraft({
    required this.vehicleId,
    required this.type,
    required this.date,
    this.km,
    this.laborCostCents = 0,
    this.laborBy,
    this.place,
    this.notes,
  });

  final String vehicleId;
  final MaintenanceType type;
  final DateTime date;
  final int? km;
  final int laborCostCents;
  final String? laborBy;
  final String? place;
  final String? notes;

  @override
  List<Object?> get props => [
    vehicleId,
    type,
    date,
    km,
    laborCostCents,
    laborBy,
    place,
    notes,
  ];
}
