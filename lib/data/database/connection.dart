import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

QueryExecutor openConnection() => driftDatabase(name: 'diario_de_garagem');
