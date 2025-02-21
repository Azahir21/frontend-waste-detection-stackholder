import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/controllers/user_management_controller.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/views/widgets/page_navigation.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/views/widgets/table_header.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:get/get.dart';

class UserDataTable extends StatelessWidget {
  final bool isMobile;
  final UserManagementController controller =
      Get.find<UserManagementController>();

  UserDataTable({Key? key, required this.isMobile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dataUsers = controller.dataUsers.value;
      if (dataUsers.users == null || dataUsers.users!.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showFailedSnackbar("No data found", "Search another data");
          controller.search.value = '';
          controller.fetchDataUser(
            page: controller.currentPage.value,
            pageSize: controller.pageSize.value,
          );
        });
      }

      final rows = dataUsers.users!.map((row) {
        return DataRow(
          cells: [
            DataCell(AppText.labelSmallDefault(
              row.id.toString(),
              color: Theme.of(context).appColors.textSecondary,
              context: context,
            )),
            DataCell(AppText.labelSmallDefault(
              row.fullName ?? '-',
              color: Theme.of(context).appColors.textSecondary,
              context: context,
            )),
            DataCell(AppText.labelSmallDefault(
              row.gender ?? '-',
              color: Theme.of(context).appColors.textSecondary,
              context: context,
            )),
            DataCell(AppText.labelSmallDefault(
              row.username ?? '-',
              color: Theme.of(context).appColors.textSecondary,
              context: context,
            )),
            DataCell(AppText.labelSmallDefault(
              row.email ?? '-',
              color: Theme.of(context).appColors.textSecondary,
              context: context,
            )),
            DataCell(AppText.labelSmallDefault(
              row.role ?? '-',
              color: Theme.of(context).appColors.textSecondary,
              context: context,
            )),
            DataCell(AppText.labelSmallDefault(
              row.status!.value ? "active" : "deactivate",
              color: Theme.of(context).appColors.textSecondary,
              context: context,
            )),
            DataCell(Obx(() => Visibility(
                  visible: row.role != "user",
                  child: Switch(
                    value: row.status!.value,
                    onChanged: (value) {
                      Get.dialog(
                        AlertDialog(
                          title: Row(
                            children: [
                              AppText.labelDefaultEmphasis(
                                "Change Status",
                                context: context,
                                color:
                                    Theme.of(context).appColors.textSecondary,
                              ),
                              const Spacer(),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () => Get.back(),
                                  icon: const Icon(Icons.cancel_outlined),
                                ),
                              ),
                            ],
                          ),
                          content: AppText.labelSmallDefault(
                            "Are you sure want to ${row.status!.value ? "deactivate" : "activate"} ${row.username} ?",
                            context: context,
                            color: Theme.of(context).appColors.textSecondary,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(closeOverlays: true),
                              child: AppText.labelSmallDefault(
                                "Cancel",
                                context: context,
                                color:
                                    Theme.of(context).appColors.textSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.changeStatus(
                                  row.id!.toString(),
                                  row.username!,
                                );
                                Get.back(closeOverlays: true);
                              },
                              child: AppText.labelSmallDefault(
                                "Yes",
                                context: context,
                                color:
                                    Theme.of(context).appColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ))),
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
            TableHeader(isMobile: isMobile, controller: controller),
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
                    _buildSortableColumn(context, "ID", 'id', 0),
                    _buildSortableColumn(context, "Full Name", 'fullname', 1),
                    _buildSortableColumn(context, "Gender", 'gender', 2),
                    _buildSortableColumn(context, "Username", 'username', 3),
                    _buildSortableColumn(context, "Email", 'email', 4),
                    _buildSortableColumn(context, "Role", 'role', 5),
                    _buildSortableColumn(context, "Status", 'status', 6),
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
            PageNavigation(
              dataUsers: dataUsers,
              isMobile: isMobile,
              controller: controller,
            ),
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
        controller.fetchDataUser(
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
