import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/clock.dart';
import 'core/id_generator.dart';
import 'data/database/app_database.dart';
import 'data/database/connection.dart';
import 'data/repositories/maintenance_repository.dart';
import 'data/repositories/modification_repository.dart';
import 'data/repositories/selected_vehicle_store.dart';
import 'data/repositories/vehicle_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase(openConnection());
  final prefs = await SharedPreferences.getInstance();
  runApp(AppDependencies(db: db, prefs: prefs, child: const DiarioApp()));
}

/// Builds the repositories once and exposes them to the widget tree.
class AppDependencies extends StatelessWidget {
  const AppDependencies({
    super.key,
    required this.db,
    required this.prefs,
    required this.child,
    this.ids,
    this.clock = systemClock,
  });

  final AppDatabase db;
  final SharedPreferences prefs;
  final IdGenerator? ids;
  final Clock clock;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Lazy `create` providers are built once and cached by the provider.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: db),
        RepositoryProvider<IdGenerator>(
          create: (_) => ids ?? UuidIdGenerator(),
        ),
        RepositoryProvider(
          create: (c) => VehicleRepository(db, ids: c.read(), clock: clock),
        ),
        RepositoryProvider(
          create: (c) =>
              ModificationRepository(db, c.read(), ids: c.read(), clock: clock),
        ),
        RepositoryProvider(
          create: (c) =>
              MaintenanceRepository(db, c.read(), ids: c.read(), clock: clock),
        ),
        RepositoryProvider(create: (_) => SelectedVehicleStore(prefs)),
      ],
      child: child,
    );
  }
}
