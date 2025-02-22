import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/controllers/user_management_controller.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/views/widgets/page_navigation.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/views/widgets/table_header.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          showFailedSnackbar(
              AppLocalizations.of(context)!.no_data_found,
              AppLocalizations.of(context)!
                  .showing_all_data_widhtout_search_filter);
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
              row.gender == "Laki-laki" || row.gender == "Male"
                  ? AppLocalizations.of(context)!.male
                  : AppLocalizations.of(context)!.female,
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
              row.status!.value
                  ? AppLocalizations.of(context)!.active
                  : AppLocalizations.of(context)!.inactive,
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
                                AppLocalizations.of(context)!.change_status,
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
                            AppLocalizations.of(context)!.activate_confirmation(
                                row.status!.value
                                    ? AppLocalizations.of(context)!.active
                                    : AppLocalizations.of(context)!.inactive,
                                row.username!),
                            context: context,
                            color: Theme.of(context).appColors.textSecondary,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(closeOverlays: true),
                              child: AppText.labelSmallDefault(
                                AppLocalizations.of(context)!.cancel,
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
                                AppLocalizations.of(context)!.ok,
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
                    _buildSortableColumn(
                        context, AppLocalizations.of(context)!.id, 'id', 0),
                    _buildSortableColumn(context,
                        AppLocalizations.of(context)!.full_name, 'fullname', 1),
                    _buildSortableColumn(context,
                        AppLocalizations.of(context)!.gender, 'gender', 2),
                    _buildSortableColumn(context,
                        AppLocalizations.of(context)!.username, 'username', 3),
                    _buildSortableColumn(context,
                        AppLocalizations.of(context)!.email, 'email', 4),
                    _buildSortableColumn(
                        context, AppLocalizations.of(context)!.role, 'role', 5),
                    _buildSortableColumn(context,
                        AppLocalizations.of(context)!.status, 'status', 6),
                    DataColumn(
                      label: AppText.labelSmallEmphasis(
                        AppLocalizations.of(context)!.action,
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
