import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/controllers/statistic_controller.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:get/get.dart';

class ShowEntriesDropdown extends StatelessWidget {
  ShowEntriesDropdown({Key? key}) : super(key: key);
  final StatisticController controller = Get.find<StatisticController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          AppText.labelSmallEmphasis(
            "Show : ",
            context: context,
            color: Theme.of(context).appColors.textSecondary,
          ),
          HorizontalGap.formSmall(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).appColors.backgroundSmoke,
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
                      color: Theme.of(context).appColors.textSecondary,
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
          AppText.labelSmallDefault(
            "entries",
            context: context,
            color: Theme.of(context).appColors.textSecondary,
          ),
        ],
      );
    });
  }
}
