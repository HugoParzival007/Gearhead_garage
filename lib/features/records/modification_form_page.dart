import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/theme.dart';
import '../../data/database/enums.dart';
import '../../data/models/drafts.dart';
import '../../data/models/records.dart';
import 'form_fields.dart';
import 'line_items_editor.dart';
import 'save_record_cubit.dart';

/// Creates or edits a modification. Needs a [SaveRecordCubit] above it
/// (see [route]); pops `true` once saved or deleted.
class ModificationFormPage extends StatefulWidget {
  const ModificationFormPage({
    super.key,
    required this.vehicleId,
    this.initial,
  });

  final String vehicleId;

  /// Null for a new modification.
  final ModificationWithItems? initial;

  static Route<bool> route({
    required String vehicleId,
    ModificationWithItems? initial,
  }) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => SaveRecordCubit(
          modifications: context.read(),
          maintenance: context.read(),
        ),
        child: ModificationFormPage(vehicleId: vehicleId, initial: initial),
      ),
    );
  }

  @override
  State<ModificationFormPage> createState() => _ModificationFormPageState();
}

class _ModificationFormPageState extends State<ModificationFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _km;
  late final TextEditingController _labor;
  late final TextEditingController _laborBy;
  late final TextEditingController _notes;
  late final TextEditingController _performance;
  late final TextEditingController _estimate;
  late final LineItemsController _items;

  ModCategory? _category;
  late ModificationStatus _status;
  late DateTime _date;
  late bool _requiresRegularization;
  late RegularizationStatus _regularization;
  var _autovalidate = AutovalidateMode.disabled;

  bool get _editing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final m = widget.initial?.modification;
    _title = TextEditingController(text: m?.title);
    _km = TextEditingController(text: m?.km?.toString());
    _labor = TextEditingController(
      text: (m == null || m.laborCostCents == 0)
          ? ''
          : centsToInput(m.laborCostCents),
    );
    _laborBy = TextEditingController(text: m?.laborBy);
    _notes = TextEditingController(text: m?.notes);
    _performance = TextEditingController(text: m?.performanceNotes);
    _estimate = TextEditingController(
      text: centsToInput(m?.estimatedCostCents),
    );
    _items = LineItemsController(widget.initial?.items ?? const []);
    _category = m?.category;
    _status = m?.status ?? ModificationStatus.installed;
    _date = m?.date ?? recordDay(DateTime.now());
    _requiresRegularization = m?.requiresRegularization ?? false;
    _regularization = m?.regularizationStatus ?? RegularizationStatus.pending;
  }

  @override
  void dispose() {
    for (final c in [
      _title,
      _km,
      _labor,
      _laborBy,
      _notes,
      _performance,
      _estimate,
    ]) {
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
    final planned = _status == ModificationStatus.planned;
    final draft = ModificationDraft(
      vehicleId: widget.vehicleId,
      title: _title.text.trim(),
      category: _category!,
      status: _status,
      date: _date,
      km: km == null ? null : int.parse(km),
      laborCostCents: parseOptionalMoney(_labor.text) ?? 0,
      laborBy: optionalText(_laborBy.text),
      notes: optionalText(_notes.text),
      performanceNotes: optionalText(_performance.text),
      estimatedCostCents: planned ? parseOptionalMoney(_estimate.text) : null,
      requiresRegularization: _requiresRegularization,
      regularizationStatus: _requiresRegularization ? _regularization : null,
    );
    context.read<SaveRecordCubit>().saveModification(
      draft,
      _items.toDrafts(),
      id: widget.initial?.modification.id,
    );
  }

  Future<void> _delete() async {
    final cubit = context.read<SaveRecordCubit>();
    final ok = await confirmDelete(
      context,
      title: 'Excluir modificação?',
      confirmLabel: 'Excluir modificação',
      body:
          'A modificação e as peças dela saem da linha do tempo e dos totais.',
    );
    if (ok) await cubit.deleteModification(widget.initial!.modification.id);
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
            title: Text(_editing ? 'Editar modificação' : 'Nova modificação'),
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
                    TextFormField(
                      controller: _title,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        helperText: 'Ex.: Escape inox, rodas aro 17',
                      ),
                      maxLength: recordTextMaxLength,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Informe o título'
                          : null,
                    ),
                    gap,
                    DropdownButtonFormField<ModCategory>(
                      initialValue: _category,
                      decoration: const InputDecoration(labelText: 'Categoria'),
                      items: [
                        for (final c in ModCategory.values)
                          DropdownMenuItem(value: c, child: Text(c.label)),
                      ],
                      onChanged: (v) => setState(() => _category = v),
                      validator: (v) =>
                          v == null ? 'Escolha a categoria' : null,
                    ),
                    gap,
                    Text('Status', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    SegmentedButton<ModificationStatus>(
                      segments: [
                        for (final s in ModificationStatus.values)
                          ButtonSegment(value: s, label: Text(s.label)),
                      ],
                      selected: {_status},
                      showSelectedIcon: false,
                      onSelectionChanged: (s) =>
                          setState(() => _status = s.first),
                    ),
                    if (_status == ModificationStatus.planned) ...[
                      gap,
                      MoneyFormField(
                        controller: _estimate,
                        label: 'Custo estimado (R\$)',
                        helperText:
                            'Opcional. Usado no "Planejado" enquanto não há '
                            'peças nem mão de obra.',
                      ),
                    ],
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
                      helperText: 'Opcional. Ex.: 350,00',
                    ),
                    gap,
                    TextFormField(
                      controller: _laborBy,
                      decoration: const InputDecoration(
                        labelText: 'Quem fez (opcional)',
                        helperText: 'Oficina, preparador ou "eu mesmo"',
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
                    gap,
                    TextFormField(
                      controller: _performance,
                      decoration: const InputDecoration(
                        labelText: 'Nota de desempenho (opcional)',
                        helperText: 'O que mudou no carro depois da mod',
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 2,
                      maxLines: 5,
                    ),
                    gap,
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Exige regularização (CSV)'),
                      subtitle: const Text(
                        'Mudança que precisa de inspeção e documento',
                      ),
                      value: _requiresRegularization,
                      onChanged: (v) =>
                          setState(() => _requiresRegularization = v),
                    ),
                    if (_requiresRegularization) ...[
                      const SizedBox(height: 8),
                      SegmentedButton<RegularizationStatus>(
                        segments: [
                          for (final s in RegularizationStatus.values)
                            ButtonSegment(value: s, label: Text(s.label)),
                        ],
                        selected: {_regularization},
                        showSelectedIcon: false,
                        onSelectionChanged: (s) =>
                            setState(() => _regularization = s.first),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: busy ? null : _save,
                      child: const Text('Salvar modificação'),
                    ),
                    if (_editing) ...[
                      const SizedBox(height: 12),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: danger,
                          side: BorderSide(color: danger),
                        ),
                        onPressed: busy ? null : _delete,
                        child: const Text('Excluir modificação'),
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
