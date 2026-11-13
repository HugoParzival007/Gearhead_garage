import 'package:diario_de_garagem/app/theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('light theme is built from the tokens', () {
    final t = AppTheme.light();
    expect(t.colorScheme.surface, AppColors.papel);
    expect(t.colorScheme.onSurface, AppColors.grafite);
    expect(t.colorScheme.error, AppColors.faixaVermelha);
    expect(t.appBarTheme.backgroundColor, AppColors.grafite);
    expect(t.floatingActionButtonTheme.backgroundColor, AppColors.sinal);
    expect(t.textTheme.titleLarge?.fontFamily, AppFonts.condensed);
    expect(t.textTheme.bodyMedium?.fontFamily, AppFonts.body);
  });

  test('dark theme uses the dark tokens', () {
    final t = AppTheme.dark();
    expect(t.colorScheme.brightness, Brightness.dark);
    expect(t.colorScheme.surface, AppColors.fundoEscuro);
    expect(t.colorScheme.surfaceContainer, AppColors.superficieEscura);
    expect(t.colorScheme.onSurface, AppColors.textoEscuro);
  });

  test('dark error is the legible red, with dark text on it', () {
    final s = AppTheme.dark().colorScheme;
    final legibleRed = AppColors.legible(
      AppColors.faixaVermelha,
      Brightness.dark,
    );
    expect(s.error, legibleRed);
    expect(s.error, isNot(AppColors.faixaVermelha));
    expect(s.onError, AppColors.fundoEscuro);

    double contrast(Color a, Color b) {
      final la = a.computeLuminance(), lb = b.computeLuminance();
      final (hi, lo) = la > lb ? (la, lb) : (lb, la);
      return (hi + 0.05) / (lo + 0.05);
    }

    // AA for normal text: error text on the background, onError on error.
    expect(contrast(s.error, s.surface), greaterThanOrEqualTo(4.5));
    expect(contrast(s.onError, s.error), greaterThanOrEqualTo(4.5));
  });
}
