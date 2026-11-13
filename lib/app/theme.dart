import 'package:material_ui/material_ui.dart';

/// Color tokens from the M1a visual direction (workshop logbook).
abstract final class AppColors {
  /// Main ink: text, app bar.
  static const grafite = Color(0xFF22303A);

  /// Light background: cold greenish grey, not cream.
  static const papel = Color(0xFFEEF1EC);

  /// Secondary text, dividers, gauge track.
  static const aco = Color(0xFF8A97A3);

  /// Workshop yellow: only the budget gauge fill and the main FAB.
  static const sinal = Color(0xFFF2B705);

  /// Oxidized green: "Instalada" stamp.
  static const instalado = Color(0xFF3F7D5A);

  /// Red line: over budget, pending regularization, errors.
  static const faixaVermelha = Color(0xFFC8102E);

  /// Dark mode background.
  static const fundoEscuro = Color(0xFF141B21);

  /// Dark mode surface.
  static const superficieEscura = Color(0xFF1E2830);

  /// Dark mode text.
  static const textoEscuro = Color(0xFFE3E8E4);

  /// [token] as text or thin lines: in dark mode, lightened 40% toward white
  /// so green and red stay AA-legible on the dark background.
  static Color legible(Color token, Brightness brightness) =>
      brightness == Brightness.dark
      ? Color.lerp(token, Colors.white, 0.4)!
      : token;
}

/// Font families declared in pubspec.yaml.
abstract final class AppFonts {
  static const body = 'Barlow';
  static const condensed = 'BarlowCondensed';

  /// Condensed, tabular figures: nickname, km and money values.
  static const TextStyle figures = TextStyle(
    fontFamily: condensed,
    fontWeight: FontWeight.w600,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}

abstract final class AppTheme {
  static const fieldRadius = BorderRadius.all(Radius.circular(4));

  static ThemeData light() => _build(
    const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.grafite,
      onPrimary: AppColors.papel,
      secondary: AppColors.aco,
      onSecondary: AppColors.grafite,
      tertiary: AppColors.instalado,
      onTertiary: Colors.white,
      error: AppColors.faixaVermelha,
      onError: Colors.white,
      surface: AppColors.papel,
      onSurface: AppColors.grafite,
      onSurfaceVariant: Color(0xFF4F5D68),
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: Color(0xFFF4F6F2),
      surfaceContainer: Color(0xFFE6EAE4),
      surfaceContainerHigh: Color(0xFFDFE4DE),
      surfaceContainerHighest: Color(0xFFD8DDD7),
      outline: AppColors.aco,
      outlineVariant: Color(0xFFC5CDD3),
      inverseSurface: AppColors.grafite,
      onInverseSurface: AppColors.papel,
      shadow: Colors.transparent,
      scrim: Colors.black,
    ),
  );

  static ThemeData dark() => _build(
    ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.textoEscuro,
      onPrimary: AppColors.fundoEscuro,
      secondary: AppColors.aco,
      onSecondary: AppColors.fundoEscuro,
      tertiary: AppColors.instalado,
      onTertiary: Colors.white,
      // #C8102E fails AA on the dark background; dark text on the lighter red.
      error: AppColors.legible(AppColors.faixaVermelha, Brightness.dark),
      onError: AppColors.fundoEscuro,
      surface: AppColors.fundoEscuro,
      onSurface: AppColors.textoEscuro,
      onSurfaceVariant: Color(0xFFAEB8C0),
      surfaceContainerLowest: Color(0xFF10161B),
      surfaceContainerLow: Color(0xFF19222A),
      surfaceContainer: AppColors.superficieEscura,
      surfaceContainerHigh: Color(0xFF253039),
      surfaceContainerHighest: Color(0xFF2C3842),
      outline: AppColors.aco,
      outlineVariant: Color(0xFF3A4752),
      inverseSurface: AppColors.textoEscuro,
      onInverseSurface: AppColors.fundoEscuro,
      shadow: Colors.transparent,
      scrim: Colors.black,
    ),
  );

  static ThemeData _build(ColorScheme scheme) {
    final dark = scheme.brightness == Brightness.dark;
    final appBarBg = dark ? AppColors.superficieEscura : AppColors.grafite;
    final appBarFg = dark ? AppColors.textoEscuro : AppColors.papel;

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: AppFonts.body,
    );
    final text = _textTheme(base.textTheme, scheme.onSurface);

    const shape = RoundedRectangleBorder(borderRadius: fieldRadius);
    const minTap = Size(48, 48);
    final focusSide = BorderSide(color: scheme.primary, width: 2);

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      textTheme: text,
      dividerTheme: DividerThemeData(
        color: dark ? scheme.outlineVariant : AppColors.aco,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: appBarBg,
        foregroundColor: appBarFg,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: text.titleLarge?.copyWith(color: appBarFg),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(borderRadius: fieldRadius),
        enabledBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: focusSide,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: minTap,
          shape: shape,
          elevation: 0,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: minTap,
          shape: shape,
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: minTap,
          shape: shape,
          textStyle: text.labelLarge,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          minimumSize: minTap,
          shape: shape,
          side: BorderSide(color: scheme.outline),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.sinal,
        foregroundColor: AppColors.grafite,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: shape,
      ),
      cardTheme: const CardThemeData(elevation: 0, shape: shape),
      listTileTheme: ListTileThemeData(
        minVerticalPadding: 12,
        iconColor: scheme.onSurface,
        selectedColor: scheme.onSurface,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: shape,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: text.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
      ),
      focusColor: scheme.primary.withValues(alpha: 0.16),
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }

  /// Scale 32/24/20/16/14/12. Condensed for titles, Barlow for body.
  static TextTheme _textTheme(TextTheme base, Color color) {
    const title = TextStyle(
      fontFamily: AppFonts.condensed,
      fontWeight: FontWeight.w600,
    );
    const body = TextStyle(
      fontFamily: AppFonts.body,
      fontWeight: FontWeight.w400,
    );
    const medium = TextStyle(
      fontFamily: AppFonts.body,
      fontWeight: FontWeight.w500,
    );
    return base
        .copyWith(
          displaySmall: title.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: title.copyWith(fontSize: 32),
          headlineSmall: title.copyWith(fontSize: 24),
          titleLarge: title.copyWith(fontSize: 20),
          titleMedium: title.copyWith(fontSize: 16),
          titleSmall: medium.copyWith(fontSize: 14),
          bodyLarge: body.copyWith(fontSize: 16),
          bodyMedium: body.copyWith(fontSize: 14),
          bodySmall: body.copyWith(fontSize: 12),
          labelLarge: medium.copyWith(fontSize: 16),
          labelMedium: medium.copyWith(fontSize: 14),
          labelSmall: medium.copyWith(fontSize: 12),
        )
        .apply(bodyColor: color, displayColor: color);
  }
}
