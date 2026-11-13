import 'package:diario_de_garagem/data/database/app_database.dart';
import 'package:diario_de_garagem/data/database/enums.dart';
import 'package:diario_de_garagem/data/models/records.dart';

final _t0 = DateTime.utc(2026, 1, 1);

LineItem item({
  String id = 'i',
  required String parentId,
  required LineItemParent parentType,
  int quantity = 1,
  required int unitPriceCents,
  DateTime? deletedAt,
}) => LineItem(
  id: id,
  createdAt: _t0,
  updatedAt: _t0,
  deletedAt: deletedAt,
  parentType: parentType,
  parentId: parentId,
  name: 'Peça',
  quantity: quantity,
  unitPriceCents: unitPriceCents,
);

ModificationWithItems mod({
  String id = 'm',
  ModCategory category = ModCategory.other,
  ModificationStatus status = ModificationStatus.installed,
  DateTime? date,
  int? km,
  int laborCostCents = 0,
  int? estimatedCostCents,
  DateTime? createdAt,
  DateTime? deletedAt,
  List<LineItem> items = const [],
}) => ModificationWithItems(
  Modification(
    id: id,
    createdAt: createdAt ?? _t0,
    updatedAt: _t0,
    deletedAt: deletedAt,
    vehicleId: 'v',
    title: 'Mod $id',
    category: category,
    status: status,
    date: date ?? _t0,
    km: km,
    laborCostCents: laborCostCents,
    estimatedCostCents: estimatedCostCents,
    requiresRegularization: false,
  ),
  items,
);

MaintenanceWithItems maint({
  String id = 'r',
  DateTime? date,
  int? km,
  int laborCostCents = 0,
  DateTime? createdAt,
  DateTime? deletedAt,
  List<LineItem> items = const [],
}) => MaintenanceWithItems(
  MaintenanceRecord(
    id: id,
    createdAt: createdAt ?? _t0,
    updatedAt: _t0,
    deletedAt: deletedAt,
    vehicleId: 'v',
    type: MaintenanceType.service,
    date: date ?? _t0,
    km: km,
    laborCostCents: laborCostCents,
  ),
  items,
);
