import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/drafts.dart';
import '../../data/repositories/maintenance_repository.dart';
import '../../data/repositories/modification_repository.dart';

enum SaveRecordStatus { idle, saving, saved, failure }

class SaveRecordState extends Equatable {
  const SaveRecordState(this.status, [this.message]);

  final SaveRecordStatus status;

  /// pt-BR message, only on [SaveRecordStatus.failure].
  final String? message;

  @override
  List<Object?> get props => [status, message];
}

/// Saves or deletes one modification or maintenance record.
class SaveRecordCubit extends Cubit<SaveRecordState> {
  SaveRecordCubit({required this._modifications, required this._maintenance})
    : super(const SaveRecordState(SaveRecordStatus.idle));

  static const saveError = 'Não foi possível salvar o registro.';
  static const deleteError = 'Não foi possível excluir o registro.';

  final ModificationRepository _modifications;
  final MaintenanceRepository _maintenance;

  Future<void> saveModification(
    ModificationDraft draft,
    List<LineItemDraft> items, {
    String? id,
  }) => _run(() => _modifications.save(draft, items, id: id), saveError);

  Future<void> saveMaintenance(
    MaintenanceDraft draft,
    List<LineItemDraft> items, {
    String? id,
  }) => _run(() => _maintenance.save(draft, items, id: id), saveError);

  Future<void> deleteModification(String id) =>
      _run(() => _modifications.softDelete(id), deleteError);

  Future<void> deleteMaintenance(String id) =>
      _run(() => _maintenance.softDelete(id), deleteError);

  Future<void> _run(Future<Object?> Function() action, String fallback) async {
    if (state.status == SaveRecordStatus.saving) return;
    emit(const SaveRecordState(SaveRecordStatus.saving));
    try {
      await action();
    } on ArgumentError catch (e) {
      emit(SaveRecordState(SaveRecordStatus.failure, messageFor(e)));
      return;
    } on Object {
      emit(SaveRecordState(SaveRecordStatus.failure, fallback));
      return;
    }
    emit(const SaveRecordState(SaveRecordStatus.saved));
  }

  /// Maps the repositories' [ArgumentError]s to pt-BR text for the UI.
  static String messageFor(ArgumentError e) => switch (e.name) {
    'title' => 'Informe um título com até 80 caracteres.',
    'name' => 'Cada peça precisa de um nome com até 80 caracteres.',
    'quantity' => 'A quantidade de cada peça deve ser pelo menos 1.',
    'unitPriceCents' => 'O valor das peças não pode ser negativo.',
    'laborCostCents' => 'A mão de obra não pode ser negativa.',
    'estimatedCostCents' => 'O custo estimado não pode ser negativo.',
    'km' => 'A quilometragem não pode ser negativa.',
    'vehicleId' => 'O veículo não foi encontrado. Ele pode ter sido excluído.',
    'id' => 'O registro não foi encontrado. Ele pode ter sido excluído.',
    _ => 'Confira os dados e tente de novo.',
  };
}
