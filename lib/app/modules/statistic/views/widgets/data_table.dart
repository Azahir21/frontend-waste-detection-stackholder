import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/controllers/statistic_controller.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/map_dialog.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/page_navigation.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/pickup_confirmation_dialog.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/table_header.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DataTableWithPagination extends StatelessWidget {
  final bool isMobile;
  DataTableWithPagination({Key? key, required this.isMobile}) : super(key: key);

  final StatisticController controller = Get.find<StatisticController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dataStats = controller.dataStatistics.value;
      if (dataStats.data == null || dataStats.data!.isEmpty) {
        return const Center(child: Text("No Data Available"));
      }

      final rows = dataStats.data!.map((row) {
        return DataRow(
          cells: [
            DataCell(AppText.labelSmallDefault(
              row.captureTime != null
                  ? DateFormat('yyyy-MM-dd').format(row.captureTime!.toLocal())
                  : '-',
              color: Theme.of(context).appColors.textSecondary,
              context: context,
            )),
            DataCell(AppText.labelSmallDefault(
              row.wasteCount?.toString() ?? '-',
              color: Theme.of(context).appColors.textSecondary,
              context: context,
            )),
            DataCell(AppText.labelSmallDefault(
              row.isWastePile == true
                  ? AppLocalizations.of(context)!.illegal_dumping_site
                  : AppLocalizations.of(context)!.illegal_trash,
              color: Theme.of(context).appColors.textSecondary,
              context: context,
            )),
            DataCell(AppText.labelSmallDefault(
              row.address ?? '-',
              color: Theme.of(context).appColors.textSecondary,
              context: context,
            )),
            DataCell(
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: row.pickupStatus!.value == true
                      ? Colors.green.shade400
                      : Colors.red.shade400,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: AppText.labelSmallDefault(
                  row.pickupStatus!.value == true
                      ? "Collected"
                      : "Not Collected",
                  color: Colors.white,
                  context: context,
                ),
              ),
            ),
            DataCell(AppText.labelSmallDefault(
              row.pickupAt != null
                  ? DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(row.pickupAt.toString()).toLocal())
                  : '-',
              color: Theme.of(context).appColors.textSecondary,
              context: context,
            )),
            DataCell(AppText.labelSmallDefault(
              row.pickupByUser ?? '-',
              color: Theme.of(context).appColors.textSecondary,
              context: context,
            )),
            DataCell(Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.map),
                  iconSize: 30,
                  color: Theme.of(context).appColors.iconPrimary,
                  onPressed: () {
                    Get.dialog(MapDialog(geom: row.geom));
                  },
                ),
                Obx(() => Visibility(
                      visible: !row.pickupStatus!.value,
                      child: Checkbox(
                        value: row.pickupStatus!.value,
                        onChanged: (value) {
                          Get.dialog(PickupConfirmationDialog(
                            rowId: row.id!,
                            onConfirm: () =>
                                controller.markPickupSampah(row.id!),
                          ));
                        },
                      ),
                    )),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TableHeader(isMobile: isMobile),
            VerticalGap.formMedium(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - 128,
                ),
                child: DataTable(
                  dividerThickness: 0.00000000001,
                  sortAscending: controller.ascending.value,
                  sortColumnIndex: controller.columnIndex.value,
                  columns: [
                    _buildSortableColumn(
                        context, "Capture Time", 'capture_time', 0),
                    _buildSortableColumn(
                        context, "Waste Count", 'waste_count', 1),
                    _buildSortableColumn(context, "Type", 'is_waste_pile', 2),
                    _buildSortableColumn(context, "Address", 'address', 3),
                    _buildSortableColumn(context, "Status", 'pickup_status', 4),
                    _buildSortableColumn(context, "Pickup At", 'pickup_at', 5),
                    _buildSortableColumn(
                        context, "Pickup By", 'pickup_by_user', 6),
                    DataColumn(
                      label: AppText.labelSmallEmphasis(
                        'Action',
                        color: Theme.of(context).appColors.textSecondary,
                        context: context,
                      ),
                    ),
                  ],
                  rows: rows,
                ),
              ),
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
