import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/theme.dart';
import '../../core/money.dart';

/// Same limit the repositories enforce on titles and part names.
const recordTextMaxLength = 80;

final _date = DateFormat('dd/MM/yyyy');

/// Record dates are calendar days stored as UTC midnight.
String formatRecordDate(DateTime d) =>
    _date.format(DateTime(d.year, d.month, d.day));

DateTime recordDay(DateTime d) => DateTime.utc(d.year, d.month, d.day);

String? optionalText(String text) {
  final t = text.trim();
  return t.isEmpty ? null : t;
}

/// Optional money field: null when blank, else the [FormatException] text.
String? validateOptionalMoney(String? v) {
  final t = v?.trim() ?? '';
  if (t.isEmpty) return null;
  try {
    parseBrlToCents(t);
    return null;
  } on FormatException catch (e) {
    return e.message;
  }
}

int? parseOptionalMoney(String text) {
  final t = optionalText(text);
  return t == null ? null : parseBrlToCents(t);
}

String? validateOptionalKm(String? v) {
  final t = v?.trim() ?? '';
  if (t.isEmpty) return null;
  final km = int.tryParse(t);
  return (km == null || km < 0)
      ? 'Informe a quilometragem em números inteiros'
      : null;
}

/// Cents as text the form accepts back (`1234,56`); empty for null.
String centsToInput(int? cents) {
  if (cents == null) return '';
  return '${cents ~/ 100},${(cents % 100).toString().padLeft(2, '0')}';
}

class MoneyFormField extends StatelessWidget {
  const MoneyFormField({
    super.key,
    required this.controller,
    required this.label,
    this.helperText,
  });

  final TextEditingController controller;
  final String label;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        helperMaxLines: 2,
      ),
      style: Theme.of(context).textTheme.bodyLarge?.merge(AppFonts.figures),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      validator: validateOptionalMoney,
    );
  }
}

class KmFormField extends StatelessWidget {
  const KmFormField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Quilometragem (opcional)',
        suffixText: 'km',
      ),
      style: Theme.of(context).textTheme.bodyLarge?.merge(AppFonts.figures),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(7),
      ],
      textInputAction: TextInputAction.next,
      validator: validateOptionalKm,
    );
  }
}

/// Read-only field that opens the date picker.
class DateFormField extends StatelessWidget {
  const DateFormField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(value.year, value.month, value.day),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 5),
      helpText: 'Escolha a data',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );
    if (picked != null) onChanged(recordDay(picked));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pick(context),
      borderRadius: AppTheme.fieldRadius,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Data',
          suffixIcon: Icon(Icons.calendar_today_outlined),
        ),
        child: Text(
          formatRecordDate(value),
          style: Theme.of(context).textTheme.bodyLarge?.merge(AppFonts.figures),
        ),
      ),
    );
  }
}

/// Asks before a destructive action. Returns true on confirm.
/// [confirmLabel] is verb + object, e.g. "Excluir modificação".
Future<bool> confirmDelete(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.faixaVermelha,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return ok ?? false;
}
