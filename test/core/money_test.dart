import 'package:diario_de_garagem/core/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseBrlToCents', () {
    test('valores válidos', () {
      expect(parseBrlToCents('1.234,56'), 123456);
      expect(parseBrlToCents('1234,5'), 123450);
      expect(parseBrlToCents('R\$ 10'), 1000);
      expect(parseBrlToCents('0,05'), 5);
      expect(parseBrlToCents(' 7 '), 700);
      expect(parseBrlToCents('  R\$  10,00 '), 1000);
    });

    test('R\$ só como prefixo; espaços só nas pontas', () {
      for (final s in ['1R\$0', '10R\$', '10 5', '1 234,56', '1.234, 56']) {
        expect(
          () => parseBrlToCents(s),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains('inválido'),
            ),
          ),
          reason: s,
        );
      }
    });

    test('rejeita entradas inválidas com mensagem específica', () {
      String msg(String s) {
        try {
          parseBrlToCents(s);
        } on FormatException catch (e) {
          return e.message;
        }
        fail('não lançou para "$s"');
      }

      expect(() => parseBrlToCents(''), throwsFormatException);
      expect(() => parseBrlToCents('-5'), throwsFormatException);
      expect(() => parseBrlToCents('abc'), throwsFormatException);
      expect(() => parseBrlToCents('1,234'), throwsFormatException);
      expect(msg(''), contains('vazio'));
      expect(msg('   '), contains('vazio'));
      expect(msg('-5'), contains('negativo'));
      expect(msg('abc'), contains('inválido'));
      expect(msg('1,234'), contains('2 casas'));
    });
  });

  group('limite de tamanho', () {
    test('rejeita mais de 10 dígitos nos reais', () {
      for (final s in [
        '99999999999999999999',
        '100000000000000',
        '92233720368547759',
        '10000000000',
        '10.000.000.000,00',
      ]) {
        expect(
          () => parseBrlToCents(s),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              'Valor muito grande.',
            ),
          ),
        );
      }
    });

    test('aceita 10 dígitos', () {
      expect(parseBrlToCents('9999999999,99'), 999999999999);
      expect(parseBrlToCents('9.999.999.999,99'), 999999999999);
    });
  });

  group('formatBrl', () {
    test('formata centavos', () {
      expect(formatBrl(123456), 'R\$ 1.234,56');
      expect(formatBrl(5), 'R\$ 0,05');
      expect(formatBrl(0), 'R\$ 0,00');
      expect(formatBrl(-1000), '-R\$ 10,00');
      expect(formatBrl(100000000), 'R\$ 1.000.000,00');
    });
  });
}
