import 'package:drift/drift.dart';

import 'enums.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Vehicles, Modifications, MaintenanceRecords, LineItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
