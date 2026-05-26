// lib/widgets/trend_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/historical.dart';
import '../utils/app_theme.dart';

enum ChartType { cases, deaths, recovered }

class TrendChart extends StatefulWidget {
  final HistoricalTimeline timeline;

  const TrendChart({super.key, required this.timeline});

  @override
  State<TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends State<TrendChart> {
  ChartType _selected = ChartType.cases;

  Map<String, int> get _data => switch (_selected) {
        ChartType.cases => widget.timeline.cases,
        ChartType.deaths => widget.timeline.deaths,
        ChartType.recovered => widget.timeline.recovered,
      };

  Color get _lineColor => switch (_selected) {
        ChartType.cases => AppTheme.accent,
        ChartType.deaths => AppTheme.danger,
        ChartType.recovered => AppTheme.success,
      };

  List<FlSpot> get _spots {
    final entries = _data.entries.toList();
    return List.generate(
      entries.length,
      (i) => FlSpot(i.toDouble(), entries[i].value.toDouble()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle chips
        Row(
          children: [
            _Chip(
              label: 'Cases',
              color: AppTheme.accent,
              selected: _selected == ChartType.cases,
              onTap: () => setState(() => _selected = ChartType.cases),
            ),
            const SizedBox(width: 8),
            _Chip(
              label: 'Deaths',
              color: AppTheme.danger,
              selected: _selected == ChartType.deaths,
              onTap: () => setState(() => _selected = ChartType.deaths),
            ),
            const SizedBox(width: 8),
            _Chip(
              label: 'Recovered',
              color: AppTheme.success,
              selected: _selected == ChartType.recovered,
              onTap: () => setState(() => _selected = ChartType.recovered),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: AppTheme.divider,
                  strokeWidth: 1,
                ),
              ),
              titlesData: const FlTitlesData(
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: _spots,
                  isCurved: true,
                  color: _lineColor,
                  barWidth: 2.5,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _lineColor.withOpacity(0.3),
                        _lineColor.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.2) : AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? color : AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
