import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/controllers/user_management_controller.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/views/widgets/add_user_button.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/views/widgets/search_bar.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/views/widgets/show_entries_dropdown.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';

class TableHeader extends StatelessWidget {
  final bool isMobile;
  final UserManagementController controller;
  const TableHeader(
      {Key? key, required this.isMobile, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ShowEntriesDropdown(controller: controller),
                  const Spacer(),
                  AddUserButton(isMobile: isMobile, controller: controller),
                ],
              ),
              VerticalGap.formMedium(),
              CustomSearchBar(controller: controller, isMobile: isMobile),
            ],
          )
        : Row(
            children: [
              ShowEntriesDropdown(controller: controller),
              HorizontalGap.formBig(),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: CustomSearchBar(
                        controller: controller, isMobile: isMobile),
                  ),
                ),
              ),
              HorizontalGap.formBig(),
              AddUserButton(isMobile: isMobile, controller: controller),
            ],
          );
  }
}
