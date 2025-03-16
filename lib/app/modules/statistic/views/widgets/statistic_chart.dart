import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/data/models/total_statistical_data.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/line_chart_card.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/pie_chart_card.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatisticCharts extends StatelessWidget {
  final bool isMobile;
  final bool isTabSmall;
  final bool isTabBig;
  final TotalStatisticalData stats;
  const StatisticCharts({
    Key? key,
    required this.isMobile,
    required this.isTabSmall,
    required this.isTabBig,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      // Mobile: charts in a single column.
      return Column(
        children: [
          PieChartCard(
              title: "Overall statistics",
              garbagePile: (stats.collectedGarbagePile! +
                  stats.notCollectedGarbagePile!),
              illegalTrash:
                  (stats.collectedGarbagePcs! + stats.notCollectedGarbagePcs!)),
          VerticalGap.formMedium(),
          PieChartCard(
            title: AppLocalizations.of(context)!.collected_garbage,
            garbagePile: stats.collectedGarbagePile!,
            illegalTrash: stats.collectedGarbagePcs!,
          ),
          VerticalGap.formMedium(),
          PieChartCard(
            title: AppLocalizations.of(context)!.uncollected_garbage,
            garbagePile: stats.notCollectedGarbagePile!,
            illegalTrash: stats.notCollectedGarbagePcs!,
          ),
          VerticalGap.formMedium(),
          LineChartCard(
              allHistoricalData: stats.allHistoricalData ?? [],
              userHistoricalData: stats.userHistoricalData ?? []),
        ],
      );
    } else if (isTabSmall) {
      // Tablet: two pie charts on top, line chart below.
      return Column(
        children: [
          PieChartCard(
              title: "Overall statistics",
              garbagePile: (stats.collectedGarbagePile! +
                  stats.notCollectedGarbagePile!),
              illegalTrash:
                  (stats.collectedGarbagePcs! + stats.notCollectedGarbagePcs!)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: PieChartCard(
                  title: AppLocalizations.of(context)!.collected_garbage,
                  garbagePile: stats.collectedGarbagePile!,
                  illegalTrash: stats.collectedGarbagePcs!,
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: PieChartCard(
                  title: AppLocalizations.of(context)!.uncollected_garbage,
                  garbagePile: stats.notCollectedGarbagePile!,
                  illegalTrash: stats.notCollectedGarbagePcs!,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LineChartCard(
              allHistoricalData: stats.allHistoricalData ?? [],
              userHistoricalData: stats.userHistoricalData ?? []),
        ],
      );
    } else if (isTabBig) {
      // Large tablet: two pie charts side by side, line chart below.
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: PieChartCard(
                  title: "Overall statistics",
                  garbagePile: (stats.collectedGarbagePile! +
                      stats.notCollectedGarbagePile!),
                  illegalTrash: (stats.collectedGarbagePcs! +
                      stats.notCollectedGarbagePcs!),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: PieChartCard(
                  title: AppLocalizations.of(context)!.collected_garbage,
                  garbagePile: stats.collectedGarbagePile!,
                  illegalTrash: stats.collectedGarbagePcs!,
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: PieChartCard(
                  title: AppLocalizations.of(context)!.uncollected_garbage,
                  garbagePile: stats.notCollectedGarbagePile!,
                  illegalTrash: stats.notCollectedGarbagePcs!,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LineChartCard(
              allHistoricalData: stats.allHistoricalData ?? [],
              userHistoricalData: stats.userHistoricalData ?? []),
        ],
      );
    } else {
      // Desktop: all charts in one row.
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: PieChartCard(
                  title: "Overall statistics",
                  garbagePile: (stats.collectedGarbagePile! +
                      stats.notCollectedGarbagePile!),
                  illegalTrash: (stats.collectedGarbagePcs! +
                      stats.notCollectedGarbagePcs!),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: PieChartCard(
                  title: AppLocalizations.of(context)!.collected_garbage,
                  garbagePile: stats.collectedGarbagePile!,
                  illegalTrash: stats.collectedGarbagePcs!,
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: PieChartCard(
                  title: AppLocalizations.of(context)!.uncollected_garbage,
                  garbagePile: stats.notCollectedGarbagePile!,
                  illegalTrash: stats.notCollectedGarbagePcs!,
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                  child: LineChartCard(
                      allHistoricalData: stats.allHistoricalData ?? [],
                      userHistoricalData: stats.userHistoricalData ?? [])),
            ],
          ),
        ],
      );
    }
  }
}
