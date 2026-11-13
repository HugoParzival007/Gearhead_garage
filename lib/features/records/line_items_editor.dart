import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/theme.dart';
import '../../core/money.dart';
import '../../data/database/app_database.dart';
import '../../data/models/drafts.dart';
import 'form_fields.dart';

/// Text fields of one part line.
class LineItemFields {
  LineItemFields({
    String name = '',
    String brand = '',
    String quantity = '1',
    String price = '',
    this.partCode,
  }) : name = TextEditingController(text: name),
       brand = TextEditingController(text: brand),
       quantity = TextEditingController(text: quantity),
       price = TextEditingController(text: price);

  LineItemFields.fromItem(LineItem i)
    : this(
        name: i.name,
        brand: i.brand ?? '',
        quantity: '${i.quantity}',
        price: centsToInput(i.unitPriceCents),
        partCode: i.partCode,
      );

  final TextEditingController name;
  final TextEditingController brand;
  final TextEditingController quantity;
  final TextEditingController price;

  /// Kept on edit; not editable in M1a.
  final String? partCode;

  /// Call only after the form validated.
  LineItemDraft toDraft() => LineItemDraft(
    name.text.trim(),
    brand: optionalText(brand.text),
    partCode: partCode,
    quantity: int.parse(quantity.text.trim()),
    unitPriceCents: parseBrlToCents(price.text),
  );

  void dispose() {
    name.dispose();
    brand.dispose();
    quantity.dispose();
    price.dispose();
  }
}

/// Owns the part lines of a form.
class LineItemsController extends ChangeNotifier {
  LineItemsController([List<LineItem> initial = const []])
    : _rows = [for (final i in initial) LineItemFields.fromItem(i)];

  final List<LineItemFields> _rows;

  List<LineItemFields> get rows => List.unmodifiable(_rows);

  void add() {
    _rows.add(LineItemFields());
    notifyListeners();
  }

  void remove(LineItemFields row) {
    if (_rows.remove(row)) {
      row.dispose();
      notifyListeners();
    }
  }

  List<LineItemDraft> toDrafts() => [for (final r in _rows) r.toDraft()];

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }
}

/// Add/remove part lines: name, brand, quantity and unit price.
/// Must sit inside a [Form]; its fields validate with it.
class LineItemsEditor extends StatelessWidget {
  const LineItemsEditor({super.key, required this.controller});

  final LineItemsController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final rows = controller.rows;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Peças', style: theme.textTheme.titleLarge),
            if (rows.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Nenhuma peça adicionada.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            for (final (i, row) in rows.indexed)
              _LineItemRow(
                key: ObjectKey(row),
                index: i,
                row: row,
                onRemove: () => controller.remove(row),
              ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: controller.add,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar peça'),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LineItemRow extends StatelessWidget {
  const _LineItemRow({
    super.key,
    required this.index,
    required this.row,
    required this.onRemove,
  });

  final int index;
  final LineItemFields row;
  final VoidCallback onRemove;

  static String? _validateQuantity(String? v) {
    final q = int.tryParse(v?.trim() ?? '');
    return (q == null || q < 1) ? 'Mínimo 1' : null;
  }

  static String? _validatePrice(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Informe o valor';
    return validateOptionalMoney(t);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final figures = theme.textTheme.bodyLarge?.merge(AppFonts.figures);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: Text(
                'Peça ${index + 1}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            IconButton(
              onPressed: onRemove,
              tooltip: 'Remover peça',
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        TextFormField(
          controller: row.name,
          decoration: const InputDecoration(labelText: 'Nome da peça'),
          maxLength: recordTextMaxLength,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Informe o nome da peça' : null,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: row.brand,
          decoration: const InputDecoration(labelText: 'Marca (opcional)'),
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 88,
              child: TextFormField(
                controller: row.quantity,
                decoration: const InputDecoration(labelText: 'Qtd.'),
                style: figures,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                textInputAction: TextInputAction.next,
                validator: _validateQuantity,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: row.price,
                decoration: const InputDecoration(
                  labelText: 'Valor unit. (R\$)',
                ),
                style: figures,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                validator: _validatePrice,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
