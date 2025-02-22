import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/data/models/total_statistical_data.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/controllers/statistic_controller.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/data_table.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/filter_overlay.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/statistic_chart.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/statistic_header.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:get/get.dart';

class StatisticView extends GetView<StatisticController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Used to show the filter overlay on tablet/desktop.

  StatisticView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        final bool isTab =
            constraints.maxWidth < 900 && constraints.maxWidth >= 600;
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return SizedBox(
                    height: constraints.maxHeight,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                final TotalStatisticalData stats =
                    controller.totalStatisticalData.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VerticalGap.formHuge(),
                    StatisticHeader(isMobile: isMobile),
                    VerticalGap.formHuge(),
                    StatisticCharts(
                        isMobile: isMobile, isTab: isTab, stats: stats),
                    VerticalGap.formHuge(),
                    // On mobile, show the table normally.
                    // On larger screens, wrap it in a Stack to show the filter overlay.
                    isMobile
                        ? DataTableWithPagination(isMobile: isMobile)
                        : Stack(
                            children: [
                              DataTableWithPagination(isMobile: isMobile),
                              Obx(() => controller.showFilterBox.value
                                  ? FilterOverlay(
                                      onCancel: () {
                                        controller.dataType.value =
                                            controller.previousDataType;
                                        controller.status.value =
                                            controller.previousStatus;
                                        controller.showFilterBox.value = false;
                                      },
                                      onOk: () {
                                        controller.fetchDataStats(
                                          page: controller.currentPage.value,
                                          pageSize: controller.pageSize.value,
                                        );
                                        controller.previousDataType =
                                            controller.dataType.value;
                                        controller.previousStatus =
                                            controller.status.value;
                                        controller.showFilterBox.value = false;
                                      },
                                    )
                                  : const SizedBox.shrink()),
                            ],
                          ),
                    VerticalGap.formHuge(),
                  ],
                );
              }),
            ),
          ),
        );
      }),
    );
  }
}
