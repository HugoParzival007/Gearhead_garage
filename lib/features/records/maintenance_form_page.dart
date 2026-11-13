import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/theme.dart';
import '../../data/database/enums.dart';
import '../../data/models/drafts.dart';
import '../../data/models/records.dart';
import 'form_fields.dart';
import 'line_items_editor.dart';
import 'save_record_cubit.dart';

/// Creates or edits a maintenance record. Needs a [SaveRecordCubit] above it
/// (see [route]); pops `true` once saved or deleted.
class MaintenanceFormPage extends StatefulWidget {
  const MaintenanceFormPage({super.key, required this.vehicleId, this.initial});

  final String vehicleId;

  /// Null for a new record.
  final MaintenanceWithItems? initial;

  static Route<bool> route({
    required String vehicleId,
    MaintenanceWithItems? initial,
  }) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => SaveRecordCubit(
          modifications: context.read(),
          maintenance: context.read(),
        ),
        child: MaintenanceFormPage(vehicleId: vehicleId, initial: initial),
      ),
    );
  }

  @override
  State<MaintenanceFormPage> createState() => _MaintenanceFormPageState();
}

class _MaintenanceFormPageState extends State<MaintenanceFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _km;
  late final TextEditingController _labor;
  late final TextEditingController _laborBy;
  late final TextEditingController _place;
  late final TextEditingController _notes;
  late final LineItemsController _items;

  MaintenanceType? _type;
  late DateTime _date;
  var _autovalidate = AutovalidateMode.disabled;

  bool get _editing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final r = widget.initial?.record;
    _km = TextEditingController(text: r?.km?.toString());
    _labor = TextEditingController(
      text: (r == null || r.laborCostCents == 0)
          ? ''
          : centsToInput(r.laborCostCents),
    );
    _laborBy = TextEditingController(text: r?.laborBy);
    _place = TextEditingController(text: r?.place);
    _notes = TextEditingController(text: r?.notes);
    _items = LineItemsController(widget.initial?.items ?? const []);
    _type = r?.type;
    _date = r?.date ?? recordDay(DateTime.now());
  }

  @override
  void dispose() {
    for (final c in [_km, _labor, _laborBy, _place, _notes]) {
      c.dispose();
    }
    _items.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidate = AutovalidateMode.onUserInteraction);
      return;
    }
    final km = optionalText(_km.text);
    final draft = MaintenanceDraft(
      vehicleId: widget.vehicleId,
      type: _type!,
      date: _date,
      km: km == null ? null : int.parse(km),
      laborCostCents: parseOptionalMoney(_labor.text) ?? 0,
      laborBy: optionalText(_laborBy.text),
      place: optionalText(_place.text),
      notes: optionalText(_notes.text),
    );
    context.read<SaveRecordCubit>().saveMaintenance(
      draft,
      _items.toDrafts(),
      id: widget.initial?.record.id,
    );
  }

  Future<void> _delete() async {
    final cubit = context.read<SaveRecordCubit>();
    final ok = await confirmDelete(
      context,
      title: 'Excluir manutenção?',
      body: 'A manutenção e as peças dela saem da linha do tempo e dos totais.',
    );
    if (ok) await cubit.deleteMaintenance(widget.initial!.record.id);
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 16);
    final theme = Theme.of(context);
    final danger = AppColors.legible(AppColors.faixaVermelha, theme.brightness);

    return BlocConsumer<SaveRecordCubit, SaveRecordState>(
      listener: (context, state) {
        switch (state.status) {
          case SaveRecordStatus.saved:
            Navigator.of(context).pop(true);
          case SaveRecordStatus.failure:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? SaveRecordCubit.saveError),
              ),
            );
          case SaveRecordStatus.idle || SaveRecordStatus.saving:
            break;
        }
      },
      builder: (context, state) {
        final busy = state.status == SaveRecordStatus.saving;
        return Scaffold(
          appBar: AppBar(
            title: Text(_editing ? 'Editar manutenção' : 'Nova manutenção'),
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidate,
              // Not a ListView: lazily built fields would skip validation.
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<MaintenanceType>(
                      initialValue: _type,
                      decoration: const InputDecoration(labelText: 'Tipo'),
                      items: [
                        for (final t in MaintenanceType.values)
                          DropdownMenuItem(value: t, child: Text(t.label)),
                      ],
                      onChanged: (v) => setState(() => _type = v),
                      validator: (v) => v == null ? 'Escolha o tipo' : null,
                    ),
                    gap,
                    DateFormField(
                      value: _date,
                      onChanged: (d) => setState(() => _date = d),
                    ),
                    gap,
                    KmFormField(controller: _km),
                    const SizedBox(height: 24),
                    LineItemsEditor(controller: _items),
                    const SizedBox(height: 24),
                    MoneyFormField(
                      controller: _labor,
                      label: 'Mão de obra (R\$)',
                      helperText: 'Opcional. Ex.: 120,00',
                    ),
                    gap,
                    TextFormField(
                      controller: _laborBy,
                      decoration: const InputDecoration(
                        labelText: 'Quem fez (opcional)',
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                    ),
                    gap,
                    TextFormField(
                      controller: _place,
                      decoration: const InputDecoration(
                        labelText: 'Local (opcional)',
                        helperText: 'Oficina ou endereço',
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                    ),
                    gap,
                    TextFormField(
                      controller: _notes,
                      decoration: const InputDecoration(
                        labelText: 'Notas (opcional)',
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 2,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: busy ? null : _save,
                      child: const Text('Salvar manutenção'),
                    ),
                    if (_editing) ...[
                      const SizedBox(height: 12),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: danger,
                          side: BorderSide(color: danger),
                        ),
                        onPressed: busy ? null : _delete,
                        child: const Text('Excluir manutenção'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
