import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/controllers/statistic_controller.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/map_dialog.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/page_navigation.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/pickup_confirmation_dialog.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/table_header.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class DataTableWithPagination extends StatelessWidget {
  final bool isMobile;
  DataTableWithPagination({Key? key, required this.isMobile}) : super(key: key);

  final StatisticController controller = Get.find<StatisticController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dataStats = controller.dataStatistics.value;
      if (dataStats.data == null || dataStats.data!.isEmpty) {
        return Center(
            child: Text(AppLocalizations.of(context)!.no_data_available));
      }

      return Padding(
        padding: isMobile
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TableHeader(isMobile: isMobile),
            VerticalGap.formMedium(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Scrollable part of the table (all columns except the last one)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width -
                            128 -
                            100, // Subtract action column width
                      ),
                      child: DataTable(
                        sortAscending: controller.ascending.value,
                        sortColumnIndex: controller.columnIndex.value,
                        columns: [
                          _buildSortableColumn(
                              context,
                              AppLocalizations.of(context)!.capture_time,
                              'capture_time',
                              0),
                          _buildSortableColumn(
                              context,
                              AppLocalizations.of(context)!.waste_count,
                              'waste_count',
                              1),
                          _buildSortableColumn(
                              context,
                              AppLocalizations.of(context)!.type,
                              'is_waste_pile',
                              2),
                          _buildSortableColumn(
                              context,
                              AppLocalizations.of(context)!.address,
                              'address',
                              3),
                          _buildSortableColumn(
                              context,
                              AppLocalizations.of(context)!.status,
                              'pickup_status',
                              4),
                          _buildSortableColumn(
                              context,
                              AppLocalizations.of(context)!.pickup_at,
                              'pickup_at',
                              5),
                          _buildSortableColumn(
                              context,
                              AppLocalizations.of(context)!.pickup_by,
                              'pickup_by_user',
                              6),
                        ],
                        rows: dataStats.data!.map((row) {
                          return DataRow(
                            cells: [
                              DataCell(AppText.labelSmallDefault(
                                row.captureTime != null
                                    ? DateFormat('yyyy-MM-dd')
                                        .format(row.captureTime!.toLocal())
                                    : '-',
                                color:
                                    Theme.of(context).appColors.textSecondary,
                                context: context,
                              )),
                              DataCell(AppText.labelSmallDefault(
                                row.wasteCount?.toString() ?? '-',
                                color:
                                    Theme.of(context).appColors.textSecondary,
                                context: context,
                              )),
                              DataCell(AppText.labelSmallDefault(
                                row.isWastePile == true
                                    ? AppLocalizations.of(context)!
                                        .illegal_dumping_site
                                    : AppLocalizations.of(context)!
                                        .illegal_trash,
                                color:
                                    Theme.of(context).appColors.textSecondary,
                                context: context,
                              )),
                              DataCell(AppText.labelSmallDefault(
                                row.address != null && row.address!.length > 50
                                    ? row.address!.replaceAllMapped(
                                        RegExp(r'(.{1,50})(\s|,|$)'),
                                        (match) => '${match.group(1)}\n')
                                    : row.address ?? '-',
                                color:
                                    Theme.of(context).appColors.textSecondary,
                                context: context,
                              )),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: row.pickupStatus!.value == true
                                        ? Colors.green.shade400
                                        : Colors.red.shade400,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: AppText.labelSmallDefault(
                                    row.pickupStatus!.value == true
                                        ? AppLocalizations.of(context)!
                                            .collected
                                        : AppLocalizations.of(context)!
                                            .uncollected,
                                    color: Colors.white,
                                    context: context,
                                  ),
                                ),
                              ),
                              DataCell(AppText.labelSmallDefault(
                                row.pickupAt != null
                                    ? DateFormat('yyyy-MM-dd').format(
                                        DateTime.parse(row.pickupAt.toString())
                                            .toLocal())
                                    : '-',
                                color:
                                    Theme.of(context).appColors.textSecondary,
                                context: context,
                              )),
                              DataCell(AppText.labelSmallDefault(
                                row.pickupByUser ?? '-',
                                color:
                                    Theme.of(context).appColors.textSecondary,
                                context: context,
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                // Fixed action column
                SizedBox(
                  width: 120, // Fixed width for action column
                  child: Column(
                    children: [
                      // Action column header
                      Container(
                        height: 56, // Match DataTable header height
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).dividerColor,
                              width: 1,
                            ),
                            left: BorderSide(
                              color: Theme.of(context).dividerColor,
                              width: 2, // Thicker border for emphasis
                            ),
                          ),
                        ),
                        child: AppText.labelSmallEmphasis(
                          'Action',
                          color: Theme.of(context).appColors.textSecondary,
                          context: context,
                        ),
                      ),
                      // Action column cells
                      ...dataStats.data!.map((row) {
                        return Container(
                          height: 48, // Match DataTable row height
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 0.5,
                              ),
                              left: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 2, // Thicker border for emphasis
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.map),
                                iconSize: 30,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                color: Theme.of(context).appColors.iconPrimary,
                                onPressed: () {
                                  Get.dialog(MapDialog(
                                    geom: row.geom,
                                    isWastePile: row.isWastePile!,
                                  ));
                                },
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.image),
                                iconSize: 30,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                color: Theme.of(context).appColors.iconPrimary,
                                onPressed: () {
                                  Get.dialog(
                                    Dialog(
                                      child: Stack(
                                        children: [
                                          InteractiveViewer(
                                            child: Image.network(row.imageUrl!),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (row.evidenceUrl != null) ...[
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.remove_red_eye),
                                  iconSize: 30,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  color:
                                      Theme.of(context).appColors.iconPrimary,
                                  onPressed: () {
                                    Get.dialog(
                                      Dialog(
                                        child: Stack(
                                          children: [
                                            InteractiveViewer(
                                              child: Image.network(
                                                  row.evidenceUrl!),
                                            ),
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ] else if (row.pickupStatus!.value == false) ...[
                                const SizedBox(width: 8),
                                Checkbox(
                                  value: row.pickupStatus!.value,
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (value) {
                                    Get.dialog(
                                      barrierDismissible: false,
                                      PickupConfirmationDialog(
                                        rowId: row.id!,
                                        onConfirm: () {
                                          final distance = Distance().as(
                                            LengthUnit.Meter,
                                            controller.evidencePosition.value,
                                            row.geom!,
                                          );

                                          if (distance > 1000000) {
                                            // Log the error for debugging
                                            print(
                                                "Evidence Position: ${controller.evidencePosition.value}");
                                            print("Distance: $distance");

                                            // Show the snackbar
                                            Future.delayed(Duration.zero, () {
                                              showFailedSnackbar(
                                                AppLocalizations.of(
                                                        Get.context!)!
                                                    .mark_pickup_error,
                                                AppLocalizations.of(
                                                        Get.context!)!
                                                    .too_far_from_waste_pile(
                                                        distance),
                                              );
                                              controller
                                                  .capturedImageUrl.value = "";
                                            });

                                            return;
                                          }

                                          controller.markPickupSampah(
                                            row.id!,
                                            row.geom!,
                                          );
                                        },
                                        isMobile: isMobile,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            PageNavigation(dataStats: dataStats, isMobile: isMobile),
          ],
        ),
      );
    });
  }

  DataColumn _buildSortableColumn(
      BuildContext context, String label, String sortBy, int columnIndex) {
    return DataColumn(
      onSort: (colIndex, ascending) {
        controller.ascending.value = !controller.ascending.value;
        controller.sortBy.value = sortBy;
        controller.columnIndex.value = columnIndex;
        controller.sortOrder.value =
            controller.ascending.value ? 'desc' : 'asc';
        controller.fetchDataStats(
          page: controller.currentPage.value,
          pageSize: controller.pageSize.value,
        );
      },
      label: AppText.labelSmallEmphasis(
        label,
        color: Theme.of(context).appColors.textSecondary,
        context: context,
      ),
    );
  }
}
