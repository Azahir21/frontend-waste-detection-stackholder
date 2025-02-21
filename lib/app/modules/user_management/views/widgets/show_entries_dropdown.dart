import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/controllers/user_management_controller.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:get/get.dart';

class ShowEntriesDropdown extends StatelessWidget {
  final UserManagementController controller;
  const ShowEntriesDropdown({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final color = Theme.of(context).appColors;
      return Row(
        children: [
          AppText.labelSmallEmphasis(
            "Show : ",
            context: context,
            color: color.textSecondary,
          ),
          HorizontalGap.formSmall(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: color.backgroundSmoke,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButton<int>(
              value: controller.pageSize.value,
              underline: const SizedBox(),
              items: [10, 25, 50, 100]
                  .map((size) => DropdownMenuItem<int>(
                        value: size,
                        child: Text(
                          '$size',
                          style: TextStyle(
                              fontSize: 16, color: color.textSecondary),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                controller.pageSize.value = value!;
                controller.fetchDataUser(pageSize: value);
              },
            ),
          ),
          HorizontalGap.formSmall(),
          AppText.labelSmallDefault(
            "entries",
            context: context,
            color: color.textSecondary,
          ),
        ],
      );
    });
  }
}
