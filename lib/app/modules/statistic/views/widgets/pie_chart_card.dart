import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/indicator.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/chart_color.dart';

class PieChartCard extends StatefulWidget {
  final int garbagePile;
  final int illegalTrash;
  final String title;
  const PieChartCard(
      {super.key,
      required this.title,
      required this.garbagePile,
      required this.illegalTrash});

  @override
  State<StatefulWidget> createState() => PieChartCardState();
}

class PieChartCardState extends State<PieChartCard> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    return Container(
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
        children: [
          AppText.labelDefaultEmphasis(widget.title,
              color: color.textSecondary, context: context),
          Container(
            height: 250,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double chartSize = constraints.maxWidth < 400
                          ? constraints.maxWidth * 0.8
                          : 400;
                      return PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: chartSize / 6,
                          sections: showingSections(),
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Indicator(
                      color: AppColors.contentColorBlue,
                      text: AppLocalizations.of(context)!.illegal_dumping_site,
                      isSquare: true,
                    ),
                    const SizedBox(height: 4),
                    Indicator(
                      color: AppColors.contentColorGreen,
                      text: AppLocalizations.of(context)!.illegal_trash,
                      isSquare: true,
                    ),
                    const SizedBox(height: 4),
                    AppText.labelSmallDefault(
                      "Total: ${widget.garbagePile + widget.illegalTrash}",
                      color: color.textSecondary,
                      context: context,
                    ),
                    const SizedBox(height: 18)
                  ],
                ),
                const SizedBox(width: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.contentColorBlue,
            value: widget.garbagePile.toDouble(),
            title: widget.garbagePile.toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: AppColors.contentColorYellow,
            value: widget.illegalTrash.toDouble(),
            title: widget.illegalTrash.toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
