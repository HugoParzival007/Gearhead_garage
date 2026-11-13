/// Dinheiro sempre em centavos (`int`). Sem `double` em lugar nenhum.
library;

final RegExp _intPart = RegExp(r'^(\d+|\d{1,3}(\.\d{3})+)$');
final RegExp _decPart = RegExp(r'^\d+$');

/// Converte texto em reais (ex.: `1.234,56`, `R$ 10`) para centavos exatos.
///
/// `R$` só é aceito como prefixo; espaços só nas pontas. No máximo 10
/// dígitos nos reais (R$ 9.999.999.999,99), para que quantidade x preço
/// não estoure `int`.
///
/// Lança [FormatException] com mensagem em pt-BR pronta para a UI.
int parseBrlToCents(String input) {
  final trimmed = input.trim();
  final s = trimmed.startsWith('R\$')
      ? trimmed.substring(2).trimLeft()
      : trimmed;
  if (s.isEmpty) {
    throw const FormatException('O valor está vazio. Informe um valor.');
  }
  if (s.startsWith('-')) {
    throw const FormatException('O valor não pode ser negativo.');
  }
  final parts = s.split(',');
  if (parts.length > 2) {
    throw const FormatException('Valor inválido. Use o formato 1.234,56.');
  }
  final intText = parts[0];
  final decText = parts.length == 2 ? parts[1] : '';
  if (!_intPart.hasMatch(intText) ||
      (parts.length == 2 && !_decPart.hasMatch(decText))) {
    throw const FormatException('Valor inválido. Use o formato 1.234,56.');
  }
  if (decText.length > 2) {
    throw const FormatException('Use no máximo 2 casas decimais.');
  }
  final reaisText = intText.replaceAll('.', '');
  if (reaisText.length > 10) {
    throw const FormatException('Valor muito grande.');
  }
  final reais = int.parse(reaisText);
  final cents = decText.isEmpty ? 0 : int.parse(decText.padRight(2, '0'));
  return reais * 100 + cents;
}

/// Formata centavos como `R$ 1.234,56` (negativo: `-R$ 10,00`).
String formatBrl(int cents) {
  final negative = cents < 0;
  final abs = cents.abs();
  final reais = (abs ~/ 100).toString();
  final cc = (abs % 100).toString().padLeft(2, '0');
  final buf = StringBuffer();
  for (var i = 0; i < reais.length; i++) {
    if (i > 0 && (reais.length - i) % 3 == 0) buf.write('.');
    buf.write(reais[i]);
  }
  return '${negative ? '-' : ''}R\$ $buf,$cc';
}
