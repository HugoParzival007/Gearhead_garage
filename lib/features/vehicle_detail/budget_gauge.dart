import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../app/theme.dart';
import '../../core/money.dart';
import '../../domain/cost_summary.dart';

/// Keeps "R\$" on the same line as its value when the text wraps.
String keepMoneyTogether(String text) => text.replaceAll('R\$ ', 'R\$\u00A0');

/// The budget text: "Gasto R$ X de R$ Y — falta R$ Z",
/// "Acima do orçamento em R$ Z" or, without budget, "Gasto R$ X".
String budgetText(CostSummary s) {
  final budget = s.budgetCents;
  final remaining = s.remainingCents;
  if (budget == null || remaining == null) {
    return 'Gasto ${formatBrl(s.spentCents)}';
  }
  if (remaining < 0) {
    return 'Acima do orçamento em ${formatBrl(-remaining)}';
  }
  return 'Gasto ${formatBrl(s.spentCents)} de ${formatBrl(budget)} '
      '— falta ${formatBrl(remaining)}';
}

/// Budget block of the vehicle detail: text plus, with a budget, the gauge.
/// Read as a single node by screen readers, with the same text.
class BudgetBlock extends StatelessWidget {
  const BudgetBlock({super.key, required this.summary});

  final CostSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = budgetText(summary);
    final budget = summary.budgetCents;
    final over = (summary.remainingCents ?? 0) < 0;
    final red = AppColors.legible(AppColors.faixaVermelha, theme.brightness);
    final style = theme.textTheme.titleLarge
        ?.merge(AppFonts.figures)
        .copyWith(color: over ? red : null);

    return Semantics(
      container: true,
      label: text,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(keepMoneyTogether(text), style: style),
          if (over && budget != null) ...[
            const SizedBox(height: 2),
            Text(
              keepMoneyTogether(
                'Gasto ${formatBrl(summary.spentCents)} de ${formatBrl(budget)}',
              ),
              style: theme.textTheme.bodyMedium
                  ?.merge(AppFonts.figures)
                  .copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
          if (budget != null) ...[
            const SizedBox(height: 12),
            BudgetGauge(spentCents: summary.spentCents, budgetCents: budget),
          ],
        ],
      ),
    );
  }
}

/// Fuel-gauge style bar. The scale runs to 125% of the budget: ticks every
/// 25%, a red line at 100%; spending past it is filled in red.
class BudgetGauge extends StatelessWidget {
  const BudgetGauge({
    super.key,
    required this.spentCents,
    required this.budgetCents,
  });

  final int spentCents;
  final int budgetCents;

  /// End of the scale, as a fraction of the budget.
  static const scaleEnd = 1.25;

  /// Spent as a fraction of the budget, clamped to the scale.
  double get fraction {
    if (budgetCents <= 0) return spentCents > 0 ? scaleEnd : 0;
    return math.min(spentCents / budgetCents, scaleEnd);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final animate = !MediaQuery.disableAnimationsOf(context);
    final _GaugeColors colors = (
      track: AppColors.aco.withValues(alpha: dark ? 0.35 : 0.30),
      redZone: AppColors.faixaVermelha.withValues(alpha: dark ? 0.30 : 0.16),
      fill: AppColors.sinal,
      over: AppColors.faixaVermelha,
      redLine: AppColors.legible(AppColors.faixaVermelha, theme.brightness),
      tick: theme.colorScheme.onSurface,
    );
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: fraction),
      duration: animate ? const Duration(milliseconds: 600) : Duration.zero,
      curve: Curves.easeOutCubic,
      builder: (context, value, _) => CustomPaint(
        size: const Size.fromHeight(28),
        painter: _GaugePainter(value, colors),
      ),
    );
  }
}

/// A record, so equal colors compare equal in [_GaugePainter.shouldRepaint].
typedef _GaugeColors = ({
  Color track,
  Color redZone,
  Color fill,
  Color over,
  Color redLine,
  Color tick,
});

class _GaugePainter extends CustomPainter {
  _GaugePainter(this.fraction, this.colors);

  final double fraction;
  final _GaugeColors colors;

  static const _barTop = 6.0;
  static const _barHeight = 12.0;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    double x(double f) => w * f / BudgetGauge.scaleEnd;
    const top = _barTop, bottom = _barTop + _barHeight;
    final redX = x(1);

    final paint = Paint()..isAntiAlias = false;
    canvas
      ..drawRect(
        Rect.fromLTRB(0, top, redX, bottom),
        paint..color = colors.track,
      )
      ..drawRect(
        Rect.fromLTRB(redX, top, w, bottom),
        paint..color = colors.redZone,
      )
      ..drawRect(
        Rect.fromLTRB(0, top, x(math.min(fraction, 1)), bottom),
        paint..color = colors.fill,
      );
    if (fraction > 1) {
      canvas.drawRect(
        Rect.fromLTRB(redX, top, x(fraction), bottom),
        paint..color = colors.over,
      );
    }

    // Scale ticks every 25%, below the bar like a fuel gauge.
    final tick = Paint()
      ..color = colors.tick
      ..strokeWidth = 1.5;
    for (final f in const [0.0, 0.25, 0.5, 0.75]) {
      final tx = math.max(x(f), 0.75);
      canvas.drawLine(Offset(tx, bottom), Offset(tx, size.height - 2), tick);
    }
    // Red line at 100%, crossing the bar.
    canvas.drawLine(
      Offset(redX, 0),
      Offset(redX, size.height),
      Paint()
        ..color = colors.redLine
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.fraction != fraction || old.colors != colors;
}
