import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/data/models/total_statistical_data.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/chart_color.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class _LineChart extends StatelessWidget {
  final List<HistoricalData> historicalData;
  const _LineChart({Key? key, required this.historicalData}) : super(key: key);

  // 1. Convert historical data into spots.
  List<FlSpot> get historicalSpots {
    if (historicalData.isEmpty) return [];
    final sortedData = List<HistoricalData>.from(historicalData)
      ..sort((a, b) => (a.weekIndex ?? 0).compareTo(b.weekIndex ?? 0));
    return sortedData.map((data) {
      final x = (data.weekIndex ?? 0).toDouble();
      final y = (data.totalTransported ?? 0).toDouble();
      return FlSpot(x, y);
    }).toList();
  }

  // 2. Determine axis bounds.
  double get minX => historicalSpots.isEmpty ? 0 : historicalSpots.first.x;
  double get maxX => historicalSpots.isEmpty ? 14 : historicalSpots.last.x;
  double get maxY {
    if (historicalSpots.isEmpty) return 4;
    final maxYValue = historicalSpots.map((s) => s.y).reduce(max);
    return maxYValue + 1; // add some padding
  }

  // 3. Group historical data by monthName and determine the center week.
  Map<int, String> get monthCenterMapping {
    // Map each month (using its long version) to its week indices.
    final Map<String, List<int>> monthToWeeks = {};
    for (final h in historicalData) {
      if (h.monthName == null || h.weekIndex == null) continue;
      monthToWeeks[h.monthName!] ??= [];
      monthToWeeks[h.monthName!]!.add(h.weekIndex!);
    }
    // Build mapping: center week -> short month name.
    final Map<int, String> mapping = {};
    // Sort months by their earliest week index.
    final monthsInOrder = monthToWeeks.keys.toList()
      ..sort((a, b) {
        final aMin = monthToWeeks[a]!.reduce(min);
        final bMin = monthToWeeks[b]!.reduce(min);
        return aMin.compareTo(bMin);
      });
    for (final month in monthsInOrder) {
      final weeks = monthToWeeks[month]!..sort();
      final startWeek = weeks.first;
      final endWeek = weeks.last;
      // Compute center week (rounding to the nearest integer).
      final centerWeek = ((startWeek + endWeek) / 2).round();
      mapping[centerWeek] = _getShortMonth(month);
    }
    return mapping;
  }

  // 4. Convert a long month name to a short version.
  String _getShortMonth(String longMonth) {
    // Adjust the mapping as needed (here "December" becomes "Des").
    switch (longMonth.toLowerCase()) {
      case 'january':
        return AppLocalizations.of(Get.context!)!.january;
      case 'february':
        return AppLocalizations.of(Get.context!)!.february;
      case 'march':
        return AppLocalizations.of(Get.context!)!.march;
      case 'april':
        return AppLocalizations.of(Get.context!)!.april;
      case 'may':
        return AppLocalizations.of(Get.context!)!.may;
      case 'june':
        return AppLocalizations.of(Get.context!)!.june;
      case 'july':
        return AppLocalizations.of(Get.context!)!.july;
      case 'august':
        return AppLocalizations.of(Get.context!)!.august;
      case 'september':
        return AppLocalizations.of(Get.context!)!.september;
      case 'october':
        return AppLocalizations.of(Get.context!)!.october;
      case 'november':
        return AppLocalizations.of(Get.context!)!.november;
      case 'december':
        return AppLocalizations.of(Get.context!)!.december;
      default:
        return longMonth.substring(0, 3);
    }
  }

  // 5. Build the chart data.
  LineChartData get chartData {
    return LineChartData(
      lineTouchData: lineTouchData,
      gridData: gridData,
      titlesData: titlesData,
      borderData: borderData,
      lineBarsData: [lineChartBarData],
      minX: minX,
      maxX: maxX,
      minY: 0,
      maxY: maxY,
    );
  }

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              final weekIndex = spot.x.toInt();
              // Find the HistoricalData object corresponding to this week index.
              final data = historicalData.firstWhere(
                (h) => h.weekIndex == weekIndex,
                orElse: () => HistoricalData(),
              );
              // Use weekInMonth from data, or fallback to weekIndex if null.
              final weekInMonth = data.weekInMonth ?? weekIndex;
              final monthShortName = _getShortMonth(data.monthName ?? "");
              final transported = data.totalTransported ?? 0;
              // Format the tooltip text as requested.
              final text = AppLocalizations.of(Get.context!)!
                  .week_stats(weekInMonth, monthShortName, transported);
              return LineTooltipItem(
                text,
                const TextStyle(color: Colors.white),
              );
            }).toList();
          },
          getTooltipColor: (_) => Colors.blueGrey.withOpacity(0.8),
        ),
      );

  // 6. Configure titles for the axes.
  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: bottomTitles),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: leftTitles()),
      );

  // Left axis: simple numeric labels.
  SideTitles leftTitles() => SideTitles(
        showTitles: true,
        interval: 1,
        reservedSize: 40,
        getTitlesWidget: (value, meta) {
          return Text(
            value.toInt().toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          );
        },
      );

  // 7. Bottom axis: display week numbers on top and, if applicable, the month abbreviation below.
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final int xVal = value.toInt();
    const weekStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    const monthStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
      color: Colors.blueGrey,
    );

    // Build a column: always show the week number.
    // Also, if this x is the center of a month group, show the short month name.
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(xVal.toString(), style: weekStyle),
          const SizedBox(height: 2),
          // Only display the month if xVal is a center.
          Text(
            monthCenterMapping[xVal] ?? "",
            style: monthStyle,
          ),
        ],
      ),
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 40,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom:
              BorderSide(color: AppColors.primary.withOpacity(0.2), width: 4),
          left: BorderSide.none,
          right: BorderSide.none,
          top: BorderSide.none,
        ),
      );

  LineChartBarData get lineChartBarData => LineChartBarData(
        isCurved: true,
        color: AppColors.contentColorCyan,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: historicalSpots,
      );

  @override
  Widget build(BuildContext context) {
    return LineChart(
      chartData,
      duration: const Duration(milliseconds: 250),
    );
  }
}

class LineChartCard extends StatefulWidget {
  final List<HistoricalData> historicalData;

  const LineChartCard({
    Key? key,
    required this.historicalData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LineChartCardState();
}

class LineChartCardState extends State<LineChartCard> {
  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    return Container(
      height: 300,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.backgroundSmoke,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: color.borderPrimary,
          width: 2,
        ),
      ),
      child: Column(
        children: <Widget>[
          Center(
            child: AppText.labelDefaultEmphasis(
              AppLocalizations.of(context)!.collection_rate_weekly,
              color: color.textSecondary,
              context: context,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 6),
              // Pass your historicalData to the chart
              child: _LineChart(historicalData: widget.historicalData),
            ),
          ),
        ],
      ),
    );
  }
}
