import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide CornerStyle;
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../core/widgets/design_system/tokens/tokens.dart';

/// A single labelled value plotted by [AdminAreaChart] or [AdminDoughnutChart].
final class AdminChartPoint {
  const AdminChartPoint({required this.label, required this.value, this.color});

  final String label;
  final double value;
  final Color? color;
}

/// Theme-aware area chart used for revenue and trend previews.
final class AdminAreaChart extends StatelessWidget {
  const AdminAreaChart({
    required this.points,
    super.key,
    this.height = 200,
    this.valueSuffix = '',
    this.lineColor,
  });

  final List<AdminChartPoint> points;
  final double height;
  final String valueSuffix;
  final Color? lineColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accent = lineColor ?? colorScheme.primary;
    final labelStyle = Theme.of(context).textTheme.labelSmall
        ?.copyWith(color: colorScheme.onSurfaceVariant, fontSize: 10);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: SfCartesianChart(
        backgroundColor: Colors.transparent,
        plotAreaBorderWidth: 0,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        primaryXAxis: CategoryAxis(
          labelStyle: labelStyle,
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
          axisLine: const AxisLine(width: 0),
        ),
        primaryYAxis: NumericAxis(
          labelStyle: labelStyle,
          labelFormat: '{value}$valueSuffix',
          majorGridLines: MajorGridLines(
            width: 0.8,
            color: colorScheme.outlineVariant.withValues(alpha: 0.45),
          ),
          majorTickLines: const MajorTickLines(size: 0),
          axisLine: const AxisLine(width: 0),
        ),
        series: <CartesianSeries<AdminChartPoint, String>>[
          AreaSeries<AdminChartPoint, String>(
            dataSource: points,
            xValueMapper: (point, _) => point.label,
            yValueMapper: (point, _) => point.value,
            color: accent,
            borderColor: accent,
            borderWidth: 2.4,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                accent.withValues(alpha: 0.32),
                accent.withValues(alpha: 0.01),
              ],
            ),
            animationDuration: 0,
            enableTooltip: false,
          ),
        ],
      ),
    );
  }
}

/// Doughnut chart with an optional built-in legend, used to show splits such
/// as sales channels or order sources.
final class AdminDoughnutChart extends StatelessWidget {
  const AdminDoughnutChart({
    required this.points,
    super.key,
    this.height = 200,
    this.showLegend = true,
    this.colors = const [],
  });

  final List<AdminChartPoint> points;
  final double height;
  final bool showLegend;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context).textTheme.labelSmall
        ?.copyWith(color: colorScheme.onSurfaceVariant);
    final palette = colors.isEmpty ? _fallbackPalette(colorScheme) : colors;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: SfCircularChart(
        backgroundColor: Colors.transparent,
        margin: EdgeInsets.zero,
        legend: Legend(
          isVisible: showLegend,
          position: LegendPosition.bottom,
          isResponsive: true,
          overflowMode: LegendItemOverflowMode.wrap,
          textStyle: labelStyle,
          iconHeight: 9,
          iconWidth: 9,
          itemPadding: 10,
        ),
        series: <CircularSeries<AdminChartPoint, String>>[
          DoughnutSeries<AdminChartPoint, String>(
            dataSource: points,
            xValueMapper: (point, _) => point.label,
            yValueMapper: (point, _) => point.value,
            pointColorMapper: (point, index) =>
                point.color ?? palette[index % palette.length],
            radius: '86%',
            innerRadius: '62%',
            strokeColor: colorScheme.surface,
            strokeWidth: 3,
            animationDuration: 0,
            enableTooltip: false,
          ),
        ],
      ),
    );
  }

  static List<Color> _fallbackPalette(ColorScheme colorScheme) {
    return <Color>[
      colorScheme.primary,
      colorScheme.tertiary,
      const Color(0xFF1B8A5A),
      const Color(0xFFB26A00),
      colorScheme.secondary,
    ];
  }
}

/// Compact radial gauge used to show progress against a monthly target.
final class AdminTargetGauge extends StatelessWidget {
  const AdminTargetGauge({
    required this.value,
    required this.label,
    super.key,
    this.height = 190,
    this.color,
  });

  /// Progress from `0` to `100`.
  final double value;
  final String label;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final accent = color ?? colorScheme.primary;
    final progress = value.clamp(0.0, 100.0);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: SfRadialGauge(
        animationDuration: 0,
        axes: <RadialAxis>[
          RadialAxis(
            startAngle: 135,
            endAngle: 45,
            showLabels: false,
            showTicks: false,
            axisLineStyle: AxisLineStyle(
              thickness: 12,
              color: colorScheme.outlineVariant.withValues(alpha: 0.45),
              cornerStyle: CornerStyle.bothCurve,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: progress,
                width: 12,
                color: accent,
                cornerStyle: CornerStyle.bothCurve,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                angle: 90,
                positionFactor: 0.2,
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${progress.round()}%',
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Small legend row for doughnut charts rendered without the built-in legend.
final class AdminChartLegend extends StatelessWidget {
  const AdminChartLegend({required this.points, super.key});

  final List<AdminChartPoint> points;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final total = points.fold<double>(0, (sum, point) => sum + point.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final point in points)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.small),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: point.color ?? colorScheme.primary,
                    borderRadius: BorderRadius.circular(AppRadii.small),
                  ),
                ),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Text(
                    point.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.small),
                Text(
                  total <= 0 ? '' : '${(point.value / total * 100).round()}%',
                  style: textTheme.labelMedium,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
