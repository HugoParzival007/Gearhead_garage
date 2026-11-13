import 'package:drift/drift.dart';

import 'enums.dart';

/// Columns shared by every syncable table. Deletion is always logical
/// (`deletedAt`), never a SQL DELETE.
mixin SyncColumns on Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Vehicles extends Table with SyncColumns {
  TextColumn get vehicleType => textEnum<VehicleType>()();
  TextColumn get nickname => text().withLength(min: 1, max: 60)();
  TextColumn get make => text()();
  TextColumn get model => text()();
  TextColumn get version => text().nullable()();
  IntColumn get year => integer().nullable()();
  TextColumn get engine => text().nullable()();
  TextColumn get fuelType => textEnum<FuelType>()();
  IntColumn get currentKm => integer().withDefault(const Constant(0))();

  /// No FK: attachments table arrives in M1c.
  TextColumn get coverPhotoId => text().nullable()();
  TextColumn get plate => text().nullable()();
  IntColumn get projectBudgetCents => integer().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
}

class Modifications extends Table with SyncColumns {
  TextColumn get vehicleId => text().references(Vehicles, #id)();
  TextColumn get title => text().withLength(min: 1, max: 80)();
  TextColumn get category => textEnum<ModCategory>()();
  TextColumn get status => textEnum<ModificationStatus>()();
  DateTimeColumn get date => dateTime()();
  IntColumn get km => integer().nullable()();
  IntColumn get laborCostCents => integer().withDefault(const Constant(0))();
  TextColumn get laborBy => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get performanceNotes => text().nullable()();
  IntColumn get estimatedCostCents => integer().nullable()();
  BoolColumn get requiresRegularization =>
      boolean().withDefault(const Constant(false))();
  TextColumn get regularizationStatus =>
      textEnum<RegularizationStatus>().nullable()();
}

class MaintenanceRecords extends Table with SyncColumns {
  TextColumn get vehicleId => text().references(Vehicles, #id)();
  TextColumn get type => textEnum<MaintenanceType>()();
  DateTimeColumn get date => dateTime()();
  IntColumn get km => integer().nullable()();
  IntColumn get laborCostCents => integer().withDefault(const Constant(0))();
  TextColumn get laborBy => text().nullable()();
  TextColumn get place => text().nullable()();
  TextColumn get notes => text().nullable()();
}

@TableIndex(name: 'line_items_parent', columns: {#parentType, #parentId})
class LineItems extends Table with SyncColumns {
  TextColumn get parentType => textEnum<LineItemParent>()();

  /// Polymorphic (modification or maintenance): no FK.
  TextColumn get parentId => text()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get brand => text().nullable()();
  TextColumn get partCode => text().nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  IntColumn get unitPriceCents => integer()();
}
