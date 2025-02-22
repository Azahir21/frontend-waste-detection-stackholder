import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/controllers/statistic_controller.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/filter_content.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class FilterDialog extends StatelessWidget {
  FilterDialog({Key? key}) : super(key: key);
  final StatisticController controller = Get.find<StatisticController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: AppText.labelDefaultEmphasis(
        AppLocalizations.of(context)!.filter,
        context: context,
      ),
      content: FilterContent(),
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
              pageSize: controller.pageSize.value,
            );
            controller.previousDataType = controller.dataType.value;
            controller.previousStatus = controller.status.value;
            Get.back();
          },
          child: Text(AppLocalizations.of(context)!.ok),
        ),
      ],
    );
  }
}
