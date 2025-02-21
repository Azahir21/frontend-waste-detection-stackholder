import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
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
import 'package:latlong2/latlong.dart';

class StatisticView extends GetView<StatisticController> {
  StatisticView({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// RxBool used for showing the filter overlay in tablet/desktop.
  final RxBool showFilterBox = false.obs;

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
      // Mobile: 3 charts in one column
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
      // Tablet: Two pie charts on top, line chart below
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
      // Desktop: All three charts in one row
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
            DataCell(Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.map),
                  iconSize: 30,
                  color: Theme.of(Get.context!).appColors.iconPrimary,
                  onPressed: () {
                    Get.dialog(Dialog(
                      child: Container(
                        height: 400,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Stack(
                          children: [
                            FlutterMap(
                              options: MapOptions(
                                initialCenter: row.geom!,
                                initialZoom: 17,
                                maxZoom: 18,
                                minZoom: 3,
                                cameraConstraint: CameraConstraint.contain(
                                  bounds: LatLngBounds(
                                    const LatLng(-90, -180),
                                    const LatLng(90, 180),
                                  ),
                                ),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                                  tileProvider: CancellableNetworkTileProvider(
                                    silenceExceptions: true,
                                  ),
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      width: 80.0,
                                      height: 80.0,
                                      point: row.geom!,
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 50,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        onPressed: () {
                                          Get.back(closeOverlays: true);
                                        },
                                        color: Colors.white,
                                        icon: Icon(Icons.close)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ));
                  },
                ),
                Obx(
                  () => Visibility(
                    visible: !row.pickupStatus!.value,
                    child: Checkbox(
                        value: row.pickupStatus!.value,
                        onChanged: (value) {
                          Get.dialog(Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AppText.labelDefaultEmphasis(
                                    AppLocalizations.of(Get.context!)!
                                        .pickup_confirmation,
                                    context: Get.context!,
                                    textAlign: TextAlign.center,
                                    color: Theme.of(Get.context!)
                                        .appColors
                                        .textSecondary,
                                  ),
                                  VerticalGap.formMedium(),
                                  AppText.labelSmallDefault(
                                      AppLocalizations.of(Get.context!)!
                                          .pickup_confirmation_message,
                                      color: Theme.of(Get.context!)
                                          .appColors
                                          .textSecondary,
                                      textAlign: TextAlign.center,
                                      context: Get.context!),
                                  VerticalGap.formBig(),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CenteredTextButtonWithIcon.secondary(
                                        label:
                                            AppLocalizations.of(Get.context!)!
                                                .cancel,
                                        width: 120,
                                        height: 35,
                                        onTap: () {
                                          Get.back();
                                        },
                                        context: Get.context!,
                                      ),
                                      HorizontalGap.formHuge(),
                                      CenteredTextButtonWithIcon.primary(
                                        label:
                                            AppLocalizations.of(Get.context!)!
                                                .already,
                                        width: 120,
                                        height: 35,
                                        onTap: () {
                                          controller.markPickupSampah(row.id!);
                                          Get.back();
                                        },
                                        context: Get.context!,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ));
                        }),
                  ),
                ),
              ],
            )),
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
            _buildPageNavigation(dataStats, isMobile),
          ],
        ),
      );
    });
  }

  Widget _buildPageNavigation(DataStatistics dataStats, bool isMobile) {
    final currentPage = dataStats.page ?? 1;
    final totalPages = dataStats.totalPages ?? 1;

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

  Widget _buildTableHeader(BuildContext context, bool isMobile) {
    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShowEntriesDropdown(),
              VerticalGap.formMedium(),
              _buildSearchAndFilter(context, isMobile),
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
                  onTap: () {
                    if (isMobile) {
                      // Mobile: open filter in a dialog.
                      Get.dialog(
                        _filterDialog(context),
                      );
                    } else {
                      // Tablet/Desktop: toggle the filter overlay.
                      showFilterBox.value = !showFilterBox.value;
                    }
                  },
                  context: context)
            ],
          );
  }

  Widget _buildSearchAndFilter(BuildContext context, bool isMobile) {
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
            onTap: () {
              if (isMobile) {
                Get.dialog(
                  _filterDialog(context),
                );
              } else {
                showFilterBox.value = !showFilterBox.value;
              }
            },
            context: context),
      ],
    );
  }

  Widget _buildCheckboxRow({
    required String label,
    required bool isChecked,
    required VoidCallback onChanged,
  }) {
    return Row(
      children: [
        Checkbox(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          value: isChecked,
          onChanged: (_) => onChanged(),
        ),
        HorizontalGap.formSmall(),
        AppText.labelSmallDefault(
          label,
          color: Theme.of(Get.context!).appColors.textSecondary,
          context: Get.context!,
        ),
      ],
    );
  }

  /// This method builds the filter content that is used in both the dialog (mobile)
  /// and the overlay (tablet/desktop).
  Widget _buildFilterContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.labelSmallEmphasis(
                  AppLocalizations.of(context)!.filter_by_type,
                  color: Theme.of(context).appColors.textSecondary,
                  context: context,
                ),
                VerticalGap.formSmall(),
                _buildCheckboxRow(
                  label: AppLocalizations.of(context)!.all_kind_of_waste,
                  isChecked: controller.dataType.value == "all",
                  onChanged: () {
                    controller.previousDataType = controller.dataType.value;
                    controller.dataType.value = "all";
                  },
                ),
                VerticalGap.formSmall(),
                _buildCheckboxRow(
                  label: AppLocalizations.of(context)!.illegal_trash,
                  isChecked: controller.dataType.value == "garbage_pcs",
                  onChanged: () {
                    controller.previousDataType = controller.dataType.value;
                    controller.dataType.value = "garbage_pcs";
                  },
                ),
                VerticalGap.formSmall(),
                _buildCheckboxRow(
                  label: AppLocalizations.of(context)!.illegal_dumping_site,
                  isChecked: controller.dataType.value == "garbage_pile",
                  onChanged: () {
                    controller.previousDataType = controller.dataType.value;
                    controller.dataType.value = "garbage_pile";
                  },
                ),
              ],
            ),
          ),
          VerticalGap.formMedium(),
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.labelSmallEmphasis(
                  AppLocalizations.of(context)!.filter_by_status,
                  color: Theme.of(context).appColors.textSecondary,
                  context: context,
                ),
                VerticalGap.formSmall(),
                _buildCheckboxRow(
                  label: AppLocalizations.of(context)!.all_status,
                  isChecked: controller.status.value == "all",
                  onChanged: () {
                    controller.previousStatus = controller.status.value;
                    controller.status.value = "all";
                  },
                ),
                VerticalGap.formSmall(),
                _buildCheckboxRow(
                  label: AppLocalizations.of(context)!.pickup_true,
                  isChecked: controller.status.value == "collected",
                  onChanged: () {
                    controller.previousStatus = controller.status.value;
                    controller.status.value = "collected";
                  },
                ),
                VerticalGap.formSmall(),
                _buildCheckboxRow(
                  label: AppLocalizations.of(context)!.pickup_false,
                  isChecked: controller.status.value == "not_collected",
                  onChanged: () {
                    controller.previousStatus = controller.status.value;
                    controller.status.value = "not_collected";
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// For mobile, the filter is shown in a dialog.
  AlertDialog _filterDialog(BuildContext context) {
    return AlertDialog(
      title: AppText.labelDefaultEmphasis(
        AppLocalizations.of(context)!.filter,
        context: context,
      ),
      content: _buildFilterContent(context),
      actions: [
        TextButton(
          onPressed: () {
            controller.dataType.value = controller.previousDataType;
            controller.status.value = controller.previousStatus;
            Get.back();
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () {
            controller.fetchDataStats(
                page: controller.currentPage.value,
                pageSize: controller.pageSize.value);
            controller.previousDataType = controller.dataType.value;
            controller.previousStatus = controller.status.value;
            Get.back();
          },
          child: Text(AppLocalizations.of(context)!.ok),
        ),
      ],
    );
  }

  /// For tablet/desktop, the filter overlay is shown on top of the table.
  Widget _buildFilterOverlay(BuildContext context) {
    return Positioned(
      top: 0,
      right: 100,
      child: Card(
        elevation: 4,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header row with title and close button.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.labelDefaultEmphasis(
                    AppLocalizations.of(context)!.filter,
                    context: context,
                  ),
                ],
              ),
              _buildFilterContent(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      controller.dataType.value = controller.previousDataType;
                      controller.status.value = controller.previousStatus;
                      showFilterBox.value = false;
                    },
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.fetchDataStats(
                          page: controller.currentPage.value,
                          pageSize: controller.pageSize.value);
                      controller.previousDataType = controller.dataType.value;
                      controller.previousStatus = controller.status.value;
                      showFilterBox.value = false;
                    },
                    child: Text(AppLocalizations.of(context)!.ok),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
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
                      // For mobile, show table normally;
                      // For tablet/desktop, wrap table in a Stack so that the filter overlay can appear.
                      isMobile
                          ? _buildDataTableWithPagination(isMobile)
                          : Stack(
                              children: [
                                _buildDataTableWithPagination(isMobile),
                                Obx(() => showFilterBox.value
                                    ? _buildFilterOverlay(context)
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
        },
      ),
    );
  }
}
