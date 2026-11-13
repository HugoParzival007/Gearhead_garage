import 'package:diario_de_garagem/core/clock.dart';
import 'package:diario_de_garagem/core/id_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UuidIdGenerator gera ids distintos no formato UUID', () {
    final gen = UuidIdGenerator();
    final a = gen.newId();
    final b = gen.newId();
    expect(a, isNot(b));
    expect(a, matches(RegExp(r'^[0-9a-f-]{36}$')));
    expect(b, matches(RegExp(r'^[0-9a-f-]{36}$')));
  });

  test('systemClock devolve UTC', () {
    expect(systemClock().isUtc, isTrue);
  });
}
