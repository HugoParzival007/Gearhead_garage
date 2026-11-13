import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/theme.dart';
import '../../core/money.dart';
import '../../data/database/enums.dart';
import '../../data/models/drafts.dart';

/// Vehicle registration form. Pops the [VehicleDraft] on save.
class VehicleFormPage extends StatefulWidget {
  const VehicleFormPage({super.key});

  /// Same limit the repository and the schema enforce.
  static const nicknameMaxLength = 60;

  @override
  State<VehicleFormPage> createState() => _VehicleFormPageState();
}

class _VehicleFormPageState extends State<VehicleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nickname = TextEditingController();
  final _make = TextEditingController();
  final _model = TextEditingController();
  final _version = TextEditingController();
  final _year = TextEditingController();
  final _engine = TextEditingController();
  final _km = TextEditingController();
  final _plate = TextEditingController();
  final _budget = TextEditingController();

  VehicleType? _type;
  FuelType? _fuel;
  var _autovalidate = AutovalidateMode.disabled;

  @override
  void dispose() {
    for (final c in [
      _nickname,
      _make,
      _model,
      _version,
      _year,
      _engine,
      _km,
      _plate,
      _budget,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  static String? _required(String? v, String message) =>
      (v == null || v.trim().isEmpty) ? message : null;

  static String? _optional(String text) {
    final t = text.trim();
    return t.isEmpty ? null : t;
  }

  String? _validateYear(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return null;
    final max = DateTime.now().year + 1;
    final year = int.tryParse(t);
    if (year == null || year < 1886 || year > max) {
      return 'Informe um ano entre 1886 e $max';
    }
    return null;
  }

  static String? _validateKm(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return null;
    final km = int.tryParse(t);
    if (km == null || km < 0) {
      return 'Informe a quilometragem em números inteiros';
    }
    return null;
  }

  static String? _validateBudget(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return null;
    try {
      parseBrlToCents(t);
      return null;
    } on FormatException catch (e) {
      return e.message;
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidate = AutovalidateMode.onUserInteraction);
      return;
    }
    final budget = _optional(_budget.text);
    final year = _optional(_year.text);
    final km = _optional(_km.text);
    Navigator.of(context).pop(
      VehicleDraft(
        vehicleType: _type!,
        nickname: _nickname.text.trim(),
        make: _make.text.trim(),
        model: _model.text.trim(),
        version: _optional(_version.text),
        year: year == null ? null : int.parse(year),
        engine: _optional(_engine.text),
        fuelType: _fuel!,
        currentKm: km == null ? 0 : int.parse(km),
        plate: _optional(_plate.text)?.toUpperCase(),
        projectBudgetCents: budget == null ? null : parseBrlToCents(budget),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final figures = Theme.of(context).textTheme.bodyLarge
        ?.merge(AppFonts.figures);
    const gap = SizedBox(height: 16);

    return Scaffold(
      appBar: AppBar(title: const Text('Novo veículo')),
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
                FormField<VehicleType>(
                  initialValue: _type,
                  validator: (v) => v == null ? 'Escolha o tipo' : null,
                  builder: (field) => InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Tipo',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      errorText: field.errorText,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SegmentedButton<VehicleType>(
                        segments: const [
                          ButtonSegment(
                            value: VehicleType.car,
                            label: Text('Carro'),
                            icon: Icon(Icons.directions_car_outlined),
                          ),
                          ButtonSegment(
                            value: VehicleType.motorcycle,
                            label: Text('Moto'),
                            icon: Icon(Icons.two_wheeler_outlined),
                          ),
                        ],
                        selected: {?field.value},
                        emptySelectionAllowed: true,
                        showSelectedIcon: false,
                        onSelectionChanged: (s) {
                          final value = s.isEmpty ? null : s.first;
                          setState(() => _type = value);
                          field.didChange(value);
                        },
                      ),
                    ),
                  ),
                ),
                gap,
                TextFormField(
                  controller: _nickname,
                  decoration: const InputDecoration(
                    labelText: 'Apelido',
                    helperText: 'Como você chama o veículo',
                  ),
                  maxLength: VehicleFormPage.nicknameMaxLength,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  validator: (v) => _required(v, 'Informe o apelido'),
                ),
                gap,
                TextFormField(
                  controller: _make,
                  decoration: const InputDecoration(labelText: 'Marca'),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (v) => _required(v, 'Informe a marca'),
                ),
                gap,
                TextFormField(
                  controller: _model,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (v) => _required(v, 'Informe o modelo'),
                ),
                gap,
                TextFormField(
                  controller: _version,
                  decoration: const InputDecoration(
                    labelText: 'Versão (opcional)',
                  ),
                  textInputAction: TextInputAction.next,
                ),
                gap,
                TextFormField(
                  controller: _year,
                  decoration: const InputDecoration(
                    labelText: 'Ano (opcional)',
                  ),
                  style: figures,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  textInputAction: TextInputAction.next,
                  validator: _validateYear,
                ),
                gap,
                TextFormField(
                  controller: _engine,
                  decoration: const InputDecoration(
                    labelText: 'Motor (opcional)',
                  ),
                  textInputAction: TextInputAction.next,
                ),
                gap,
                DropdownButtonFormField<FuelType>(
                  initialValue: _fuel,
                  decoration: const InputDecoration(labelText: 'Combustível'),
                  items: [
                    for (final f in FuelType.values)
                      DropdownMenuItem(value: f, child: Text(f.label)),
                  ],
                  onChanged: (v) => setState(() => _fuel = v),
                  validator: (v) => v == null ? 'Escolha o combustível' : null,
                ),
                gap,
                TextFormField(
                  controller: _km,
                  decoration: const InputDecoration(
                    labelText: 'Quilometragem atual',
                    suffixText: 'km',
                  ),
                  style: figures,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(7),
                  ],
                  textInputAction: TextInputAction.next,
                  validator: _validateKm,
                ),
                gap,
                TextFormField(
                  controller: _plate,
                  decoration: const InputDecoration(
                    labelText: 'Placa (opcional)',
                  ),
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                ),
                gap,
                TextFormField(
                  controller: _budget,
                  decoration: const InputDecoration(
                    labelText: 'Orçamento do projeto (R\$)',
                    helperText: 'Opcional. Ex.: 15.000,00',
                  ),
                  style: figures,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  validator: _validateBudget,
                  onFieldSubmitted: (_) => _save(),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _save,
                  child: const Text('Salvar veículo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
