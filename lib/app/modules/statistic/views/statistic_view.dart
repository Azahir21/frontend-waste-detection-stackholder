import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/data/models/data_statistics_model.dart';
import 'package:frontend_waste_management_stackholder/app/data/models/total_statistical_data.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/controllers/statistic_controller.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/line_chart_card.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/pie_chart_card.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/centered_text_button_with_icon.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/icon_button.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';

import 'package:get/get.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class StatisticView extends GetView<StatisticController> {
  StatisticView({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Builds the header text widget.
  Widget _buildHeader(BuildContext context, bool isMobile) {
    var color = Theme.of(context).appColors;
    Widget headerText = AppText.customSize(
      AppLocalizations.of(context)!.statistics,
      size: isMobile ? 28 : 40,
      fontWeight: FontWeight.w600,
      color: color.textSecondary,
      context: context,
    );

    return Padding(
      padding: isMobile
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 80.0),
      child: isMobile ? Center(child: headerText) : headerText,
    );
  }

  Widget _buildStatisticCharts({
    required bool isMobile,
    required bool isTab,
    required TotalStatisticalData stats,
  }) {
    if (isMobile) {
      // Mobile: 3 columns in one row
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PieChartCard(
            title: "Collected Garbage",
            garbagePile: stats.collectedGarbagePile!,
            illegalTrash: stats.collectedGarbagePcs!,
          ),
          VerticalGap.formMedium(),
          PieChartCard(
            title: "Uncollected Garbage",
            garbagePile: stats.notCollectedGarbagePile!,
            illegalTrash: stats.notCollectedGarbagePcs!,
          ),
          VerticalGap.formMedium(),
          LineChartCard(),
        ],
      );
    } else if (isTab) {
      // Tablet: Two PieChartCards in the first column (stacked), LineChartCard in the second column
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: PieChartCard(
                  title: "Collected Garbage",
                  garbagePile: stats.collectedGarbagePile!,
                  illegalTrash: stats.collectedGarbagePcs!,
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: PieChartCard(
                  title: "Uncollected Garbage",
                  garbagePile: stats.notCollectedGarbagePile!,
                  illegalTrash: stats.notCollectedGarbagePcs!,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LineChartCard(),
        ],
      );
    } else {
      // Desktop: 3 widgets in one row
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: PieChartCard(
              title: "Collected Garbage",
              garbagePile: stats.collectedGarbagePile!,
              illegalTrash: stats.collectedGarbagePcs!,
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: PieChartCard(
              title: "Uncollected Garbage",
              garbagePile: stats.notCollectedGarbagePile!,
              illegalTrash: stats.notCollectedGarbagePcs!,
            ),
          ),
          const SizedBox(width: 30),
          const Expanded(
            child: LineChartCard(),
          ),
        ],
      );
    }
  }

  Widget _buildDataTableWithPagination(bool isMobile) {
    return Obx(() {
      final dataStats = controller.dataStatistics.value;
      if (dataStats.data == null || dataStats.data!.isEmpty) {
        return const Center(child: Text("No Data Available"));
      }

      // Map each DataStatistic into a DataRow.
      final rows = dataStats.data!.map((row) {
        return DataRow(
          cells: [
            DataCell(AppText.labelSmallDefault(
              row.captureTime != null
                  ? DateFormat('yyyy-MM-dd').format(row.captureTime!.toLocal())
                  : '-',
              color: Theme.of(Get.context!).appColors.textSecondary,
              context: Get.context!,
            )),
            DataCell(AppText.labelSmallDefault(
                row.wasteCount?.toString() ?? '-',
                color: Theme.of(Get.context!).appColors.textSecondary,
                context: Get.context!)),
            DataCell(AppText.labelSmallDefault(
                row.isWastePile == true
                    ? AppLocalizations.of(Get.context!)!.illegal_dumping_site
                    : AppLocalizations.of(Get.context!)!.illegal_trash,
                color: Theme.of(Get.context!).appColors.textSecondary,
                context: Get.context!)),
            DataCell(
              AppText.labelSmallDefault(row.address ?? '-',
                  color: Theme.of(Get.context!).appColors.textSecondary,
                  context: Get.context!),
            ),
            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: row.pickupStatus == true
                      ? Colors.green.shade400
                      : Colors.red.shade400,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: AppText.labelSmallDefault(
                  row.pickupStatus == true ? "Collected" : "Not Collected",
                  color: Colors.white,
                  context: Get.context!,
                ),
              ),
            ),
            DataCell(
              AppText.labelSmallDefault(
                row.pickupAt != null
                    ? DateFormat('yyyy-MM-dd').format(
                        DateTime.parse(row.pickupAt.toString()).toLocal())
                    : '-',
                color: Theme.of(Get.context!).appColors.textSecondary,
                context: Get.context!,
              ),
            ),
            DataCell(AppText.labelSmallDefault(row.pickupByUser ?? '-',
                color: Theme.of(Get.context!).appColors.textSecondary,
                context: Get.context!)),
            DataCell(
              ElevatedButton(
                onPressed: () {},
                child: const Text('Action'),
              ),
            ),
          ],
        );
      }).toList();

      return Padding(
        padding: isMobile
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTableHeader(Get.context!, isMobile),
            VerticalGap.formMedium(),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(Get.context!).size.width - 128,
                ),
                child: DataTable(
                  dividerThickness: 0.00000000001,
                  sortAscending: controller.ascending.value,
                  sortColumnIndex: controller.columnIndex.value,
                  columns: [
                    DataColumn(
                        onSort: (columnIndex, ascending) {
                          controller.ascending.value =
                              !controller.ascending.value;
                          controller.sortBy.value = 'capture_time';
                          controller.columnIndex.value = columnIndex;
                          if (controller.ascending.value) {
                            controller.sortOrder.value = 'desc';
                          } else {
                            controller.sortOrder.value = 'asc';
                          }
                          controller.fetchDataStats(
                              page: controller.currentPage.value,
                              pageSize: controller.pageSize.value);
                        },
                        label: AppText.labelSmallEmphasis('Capture Time',
                            color:
                                Theme.of(Get.context!).appColors.textSecondary,
                            context: Get.context!)),
                    DataColumn(
                        onSort: (columnIndex, ascending) {
                          controller.ascending.value =
                              !controller.ascending.value;
                          controller.sortBy.value = 'waste_count';
                          controller.columnIndex.value = columnIndex;
                          if (controller.ascending.value) {
                            controller.sortOrder.value = 'desc';
                          } else {
                            controller.sortOrder.value = 'asc';
                          }
                          controller.fetchDataStats(
                              page: controller.currentPage.value,
                              pageSize: controller.pageSize.value);
                        },
                        label: AppText.labelSmallEmphasis('Waste Count',
                            color:
                                Theme.of(Get.context!).appColors.textSecondary,
                            context: Get.context!)),
                    DataColumn(
                        onSort: (columnIndex, ascending) {
                          controller.ascending.value =
                              !controller.ascending.value;
                          controller.sortBy.value = 'is_waste_pile';
                          controller.columnIndex.value = columnIndex;
                          if (controller.ascending.value) {
                            controller.sortOrder.value = 'desc';
                          } else {
                            controller.sortOrder.value = 'asc';
                          }
                          controller.fetchDataStats(
                              page: controller.currentPage.value,
                              pageSize: controller.pageSize.value);
                        },
                        label: AppText.labelSmallEmphasis('Type',
                            color:
                                Theme.of(Get.context!).appColors.textSecondary,
                            context: Get.context!)),
                    DataColumn(
                        onSort: (columnIndex, ascending) {
                          controller.ascending.value =
                              !controller.ascending.value;
                          controller.sortBy.value = 'address';
                          controller.columnIndex.value = columnIndex;
                          if (controller.ascending.value) {
                            controller.sortOrder.value = 'desc';
                          } else {
                            controller.sortOrder.value = 'asc';
                          }
                          controller.fetchDataStats(
                              page: controller.currentPage.value,
                              pageSize: controller.pageSize.value);
                        },
                        label: AppText.labelSmallEmphasis('Address',
                            color:
                                Theme.of(Get.context!).appColors.textSecondary,
                            context: Get.context!)),
                    DataColumn(
                        onSort: (columnIndex, ascending) {
                          controller.ascending.value =
                              !controller.ascending.value;
                          controller.sortBy.value = 'pickup_status';
                          controller.columnIndex.value = columnIndex;
                          if (controller.ascending.value) {
                            controller.sortOrder.value = 'desc';
                          } else {
                            controller.sortOrder.value = 'asc';
                          }
                          controller.fetchDataStats(
                              page: controller.currentPage.value,
                              pageSize: controller.pageSize.value);
                        },
                        label: AppText.labelSmallEmphasis('Status',
                            color:
                                Theme.of(Get.context!).appColors.textSecondary,
                            context: Get.context!)),
                    DataColumn(
                        onSort: (columnIndex, ascending) {
                          controller.ascending.value =
                              !controller.ascending.value;
                          controller.sortBy.value = 'pickup_at';
                          controller.columnIndex.value = columnIndex;
                          if (controller.ascending.value) {
                            controller.sortOrder.value = 'desc';
                          } else {
                            controller.sortOrder.value = 'asc';
                          }
                          controller.fetchDataStats(
                              page: controller.currentPage.value,
                              pageSize: controller.pageSize.value);
                        },
                        label: AppText.labelSmallEmphasis('Pickup At',
                            color:
                                Theme.of(Get.context!).appColors.textSecondary,
                            context: Get.context!)),
                    DataColumn(
                        onSort: (columnIndex, ascending) {
                          controller.ascending.value =
                              !controller.ascending.value;
                          controller.sortBy.value = 'pickup_by_user';
                          controller.columnIndex.value = columnIndex;
                          if (controller.ascending.value) {
                            controller.sortOrder.value = 'desc';
                          } else {
                            controller.sortOrder.value = 'asc';
                          }
                          controller.fetchDataStats(
                              page: controller.currentPage.value,
                              pageSize: controller.pageSize.value);
                        },
                        label: AppText.labelSmallEmphasis('Pickup By',
                            color:
                                Theme.of(Get.context!).appColors.textSecondary,
                            context: Get.context!)),
                    DataColumn(
                        label: AppText.labelSmallEmphasis('Action',
                            color:
                                Theme.of(Get.context!).appColors.textSecondary,
                            context: Get.context!)),
                  ],
                  rows: rows,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Build the page navigation buttons.
            _buildPageNavigation(dataStats, isMobile),
          ],
        ),
      );
    });
  }

  Widget _buildPageNavigation(DataStatistics dataStats, bool isMobile) {
    final currentPage = dataStats.page ?? 1;
    final totalPages = dataStats.totalPages ?? 1;

    // Optionally, you could also add "Previous" and "Next" buttons.
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (currentPage > 1)
          isMobile
              ? CustomIconButton.primary(
                  iconName: AppIconName.back,
                  onTap: () => controller.fetchDataStats(
                      page: currentPage - 1,
                      pageSize: controller.pageSize.value),
                  context: Get.context!,
                )
              : CenteredTextButtonWithIcon.secondary(
                  label: "Sebelumnya",
                  leftIcon: AppIconName.back,
                  height: 36,
                  width: 186,
                  onTap: () => controller.fetchDataStats(
                      page: currentPage - 1,
                      pageSize: controller.pageSize.value),
                  context: Get.context!,
                )
        else
          isMobile
              ? const SizedBox(height: 50, width: 50)
              : const SizedBox(height: 36, width: 186),
        HorizontalGap.formSmall(),
        Text('Page $currentPage of $totalPages'),
        HorizontalGap.formSmall(),
        if (currentPage < totalPages)
          isMobile
              ? CustomIconButton.primary(
                  iconName: AppIconName.next,
                  onTap: () => controller.fetchDataStats(
                      page: currentPage + 1,
                      pageSize: controller.pageSize.value),
                  context: Get.context!,
                )
              : CenteredTextButtonWithIcon.primary(
                  label: "Berikutnya",
                  rightIcon: AppIconName.next,
                  height: 36,
                  width: 186,
                  onTap: () => controller.fetchDataStats(
                      page: currentPage + 1,
                      pageSize: controller.pageSize.value),
                  context: Get.context!,
                )
        else
          isMobile
              ? const SizedBox(height: 50, width: 50)
              : const SizedBox(height: 36, width: 186),
      ],
    );
  }

  Widget _buildTableHeader(BuildContext context, bool isMobile) {
    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShowEntriesDropdown(),
              VerticalGap.formMedium(),
              _buildSearchAndFilter(context),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildShowEntriesDropdown(),
              HorizontalGap.formBig(),
              SizedBox(
                width: 250,
                height: 50,
                child: TextFormField(
                  initialValue: controller.search.value,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  onChanged: (value) {
                    controller.search.value = value;
                  },
                  onFieldSubmitted: (value) {
                    controller.fetchDataStats(
                        page: controller.currentPage.value,
                        pageSize: controller.pageSize.value);
                  },
                ),
              ),
              const Spacer(),
              CustomIconButton.primary(
                  height: 50,
                  width: 50,
                  iconName: AppIconName.filter,
                  onTap: () {},
                  context: context)
            ],
          );
  }

  Widget _buildSearchAndFilter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 225,
          height: 50,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
            ),
            onChanged: (value) {},
          ),
        ),
        const Spacer(),
        CustomIconButton.primary(
            height: 50,
            width: 50,
            iconName: AppIconName.filter,
            onTap: () {},
            context: context)
      ],
    );
  }

  Widget _buildShowEntriesDropdown() {
    return Obx(() {
      return Row(
        children: [
          AppText.labelSmallEmphasis("Show : ",
              context: Get.context!,
              color: Theme.of(Get.context!).appColors.textSecondary),
          HorizontalGap.formSmall(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(Get.context!).appColors.backgroundSmoke,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButton<int>(
              value: controller.pageSize.value,
              underline: const SizedBox(),
              items: [10, 25, 50, 100].map((size) {
                return DropdownMenuItem<int>(
                  value: size,
                  child: Text(
                    '$size',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(Get.context!).appColors.textSecondary,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                controller.pageSize.value = value!;
                controller.fetchDataStats(pageSize: value);
              },
            ),
          ),
          HorizontalGap.formSmall(),
          AppText.labelSmallDefault("entries",
              context: Get.context!,
              color: Theme.of(Get.context!).appColors.textSecondary),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).appColors;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 600;
          final bool isTab =
              constraints.maxWidth < 900 && constraints.maxWidth >= 600;
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Obx(() {
                  // Show a progress indicator while loading.
                  if (controller.isLoading.value) {
                    return SizedBox(
                      height: constraints.maxHeight,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  final stats = controller.totalStatisticalData.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerticalGap.formHuge(),
                      _buildHeader(context, isMobile),
                      VerticalGap.formHuge(),
                      _buildStatisticCharts(
                        isMobile: isMobile,
                        isTab: isTab,
                        stats: stats,
                      ),
                      VerticalGap.formHuge(),
                      _buildDataTableWithPagination(isMobile),
                      VerticalGap.formHuge(),
                    ],
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
