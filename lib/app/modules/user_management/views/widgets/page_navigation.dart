import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/data/models/data_users_model.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/controllers/user_management_controller.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/centered_text_button_with_icon.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/icon_button.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';

class PageNavigation extends StatelessWidget {
  final UsersData dataUsers;
  final bool isMobile;
  final UserManagementController controller;
  const PageNavigation({
    Key? key,
    required this.dataUsers,
    required this.isMobile,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentPage = dataUsers.page ?? 1;
    final totalPages = dataUsers.totalPages ?? 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (currentPage > 1)
          isMobile
              ? CustomIconButton.primary(
                  iconName: AppIconName.back,
                  onTap: () => controller.fetchDataUser(
                    page: currentPage - 1,
                    pageSize: controller.pageSize.value,
                  ),
                  context: context,
                )
              : CenteredTextButtonWithIcon.secondary(
                  label: "Sebelumnya",
                  leftIcon: AppIconName.back,
                  height: 36,
                  width: 186,
                  onTap: () => controller.fetchDataUser(
                    page: currentPage - 1,
                    pageSize: controller.pageSize.value,
                  ),
                  context: context,
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
                  onTap: () => controller.fetchDataUser(
                    page: currentPage + 1,
                    pageSize: controller.pageSize.value,
                  ),
                  context: context,
                )
              : CenteredTextButtonWithIcon.primary(
                  label: "Berikutnya",
                  rightIcon: AppIconName.next,
                  height: 36,
                  width: 186,
                  onTap: () => controller.fetchDataUser(
                    page: currentPage + 1,
                    pageSize: controller.pageSize.value,
                  ),
                  context: context,
                )
        else
          isMobile
              ? const SizedBox(height: 50, width: 50)
              : const SizedBox(height: 36, width: 186),
      ],
    );
  }
}
