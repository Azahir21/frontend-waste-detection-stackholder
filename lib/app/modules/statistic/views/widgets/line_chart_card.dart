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
  final List<HistoricalData> allHistoricalData;
  final List<HistoricalData> userHistoricalData;

  const _LineChart({
    Key? key,
    required this.allHistoricalData,
    required this.userHistoricalData,
  }) : super(key: key);

  // Compute month offsets using the combined data from both series.
  Map<String, int> _computeMonthOffsets(List<HistoricalData> data) {
    final monthOffsets = <String, int>{};
    final months = data
        .where((h) => h.monthName != null)
        .map((h) => h.monthName!)
        .toSet()
        .toList();
    months.sort((a, b) {
      final aMin = data
          .where((h) => h.monthName == a)
          .map((h) => h.weekIndex ?? 0)
          .reduce(min);
      final bMin = data
          .where((h) => h.monthName == b)
          .map((h) => h.weekIndex ?? 0)
          .reduce(min);
      return aMin.compareTo(bMin);
    });
    int offset = 0;
    for (final month in months) {
      final weeks = data
          .where((h) => h.monthName == month)
          .map((h) => h.weekInMonth ?? 0)
          .toList();
      if (weeks.isNotEmpty) {
        monthOffsets[month] = offset;
        // Increase offset by the maximum week_in_month for this month.
        final maxWeek = weeks.reduce(max);
        offset += maxWeek;
      }
    }
    return monthOffsets;
  }

  // Get a combined month offset map from both data sources.
  Map<String, int> get combinedMonthOffsets =>
      _computeMonthOffsets([...allHistoricalData, ...userHistoricalData]);

  // Convert all historical data to spots.
  List<FlSpot> get allHistoricalSpots {
    if (allHistoricalData.isEmpty) return [];
    final monthOffsets = combinedMonthOffsets;
    final sortedData = List<HistoricalData>.from(allHistoricalData)
      ..sort((a, b) {
        final aOffset = monthOffsets[a.monthName] ?? 0;
        final bOffset = monthOffsets[b.monthName] ?? 0;
        return (aOffset + (a.weekInMonth ?? 0))
            .compareTo(bOffset + (b.weekInMonth ?? 0));
      });
    return sortedData.map((data) {
      final offset = monthOffsets[data.monthName] ?? 0;
      final x = offset + (data.weekInMonth ?? 0).toDouble();
      final y = (data.totalTransported ?? 0).toDouble();
      return FlSpot(x, y);
    }).toList();
  }

  // Convert user historical data to spots.
  List<FlSpot> get userHistoricalSpots {
    if (userHistoricalData.isEmpty) return [];
    final monthOffsets = combinedMonthOffsets;
    final sortedData = List<HistoricalData>.from(userHistoricalData)
      ..sort((a, b) {
        final aOffset = monthOffsets[a.monthName] ?? 0;
        final bOffset = monthOffsets[b.monthName] ?? 0;
        return (aOffset + (a.weekInMonth ?? 0))
            .compareTo(bOffset + (b.weekInMonth ?? 0));
      });
    return sortedData.map((data) {
      final offset = monthOffsets[data.monthName] ?? 0;
      final x = offset + (data.weekInMonth ?? 0).toDouble();
      final y = (data.totalTransported ?? 0).toDouble();
      return FlSpot(x, y);
    }).toList();
  }

  // Compute axis bounds from both data series.
  double get minX {
    final allSpots = [...allHistoricalSpots, ...userHistoricalSpots];
    if (allSpots.isEmpty) return 0;
    return allSpots.map((s) => s.x).reduce(min);
  }

  double get maxX {
    final allSpots = [...allHistoricalSpots, ...userHistoricalSpots];
    if (allSpots.isEmpty) return 14;
    return allSpots.map((s) => s.x).reduce(max);
  }

  double get maxY {
    final allSpots = [...allHistoricalSpots, ...userHistoricalSpots];
    if (allSpots.isEmpty) return 4;
    final maxYValue = allSpots.map((s) => s.y).reduce(max);
    return maxYValue + 1;
  }

  // Compute center positions for month labels.
  Map<int, String> get monthCenterMapping {
    final mapping = <int, String>{};
    final monthOffsets = combinedMonthOffsets;
    final Map<String, List<double>> monthToX = {};
    for (final data in [...allHistoricalData, ...userHistoricalData]) {
      if (data.monthName == null) continue;
      final offset = monthOffsets[data.monthName] ?? 0;
      final x = offset + (data.weekInMonth ?? 0).toDouble();
      monthToX[data.monthName!] ??= [];
      monthToX[data.monthName!]!.add(x);
    }
    monthToX.forEach((month, xValues) {
      xValues.sort();
      final center = ((xValues.first + xValues.last) / 2).round();
      mapping[center] = _getShortMonth(month);
    });
    return mapping;
  }

  // Convert long month name to a short version.
  String _getShortMonth(String longMonth) {
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

  // Build the chart data with two line series.
  LineChartData get chartData {
    return LineChartData(
      lineTouchData: lineTouchData,
      gridData: gridData,
      titlesData: titlesData,
      borderData: borderData,
      lineBarsData: [
        lineChartBarDataAll,
        lineChartBarDataUser,
      ],
      minX: minX,
      maxX: maxX,
      minY: 0,
      maxY: maxY,
    );
  }

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          fitInsideVertically: true,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            final monthOffsets = combinedMonthOffsets;
            return touchedSpots.map((spot) {
              // Determine text color based on which series the touched spot belongs to.
              Color textColor;
              if (spot.barIndex == 0) {
                textColor = AppColors.contentColorCyan;
              } else if (spot.barIndex == 1) {
                textColor = Colors.orange.shade300;
              } else {
                textColor = Colors.white; // fallback color
              }

              // Search in the correct list based on barIndex.
              final data =
                  (spot.barIndex == 0 ? allHistoricalData : userHistoricalData)
                      .firstWhere(
                (h) {
                  final offset = monthOffsets[h.monthName] ?? 0;
                  final computedX = offset + (h.weekInMonth ?? 0).toDouble();
                  return computedX == spot.x;
                },
                orElse: () => HistoricalData(),
              );
              final weekInMonth = data.weekInMonth ?? 0;
              final monthShortName = _getShortMonth(data.monthName ?? "");
              final transported = data.totalTransported ?? 0;
              final text = AppLocalizations.of(Get.context!)!
                  .week_stats(weekInMonth, monthShortName, transported);
              return LineTooltipItem(
                text,
                TextStyle(color: textColor, fontWeight: FontWeight.bold),
              );
            }).toList();
          },
          getTooltipColor: (_) => Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: bottomTitles),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: leftTitles()),
      );

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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final xVal = value.round();
    const weekStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    const monthStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
      color: Colors.blueGrey,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(xVal.toString(), style: weekStyle),
          const SizedBox(height: 2),
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

  // Line series for all historical data.
  LineChartBarData get lineChartBarDataAll => LineChartBarData(
        isCurved: true,
        color: AppColors.contentColorCyan,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: allHistoricalSpots,
      );

  // Line series for user historical data.
  LineChartBarData get lineChartBarDataUser => LineChartBarData(
        isCurved: true,
        color: Colors.orange.shade300, // a distinct color for user data
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: userHistoricalSpots,
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
  final List<HistoricalData> allHistoricalData;
  final List<HistoricalData> userHistoricalData;

  const LineChartCard({
    Key? key,
    required this.allHistoricalData,
    required this.userHistoricalData,
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
          const SizedBox(height: 10),
          // Legend row: adjust text as needed.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    color: AppColors.contentColorCyan,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "all historical data",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    color: Colors.orange.shade300,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "user historical data",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 6),
              child: _LineChart(
                allHistoricalData: widget.allHistoricalData,
                userHistoricalData: widget.userHistoricalData,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
