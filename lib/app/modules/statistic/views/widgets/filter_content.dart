import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/controllers/statistic_controller.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterContent extends StatelessWidget {
  FilterContent({Key? key}) : super(key: key);
  final StatisticController controller = Get.find<StatisticController>();

  Widget _buildCheckboxRow({
    required String label,
    required bool isChecked,
    required VoidCallback onChanged,
  }) {
    return Row(
      children: [
        Checkbox(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Column(
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
              )),
          VerticalGap.formMedium(),
          Obx(() => Column(
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
                    label: AppLocalizations.of(context)!.collected,
                    isChecked: controller.status.value == "collected",
                    onChanged: () {
                      controller.previousStatus = controller.status.value;
                      controller.status.value = "collected";
                    },
                  ),
                  VerticalGap.formSmall(),
                  _buildCheckboxRow(
                    label: AppLocalizations.of(context)!.uncollected,
                    isChecked: controller.status.value == "not_collected",
                    onChanged: () {
                      controller.previousStatus = controller.status.value;
                      controller.status.value = "not_collected";
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
