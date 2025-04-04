import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/controllers/statistic_controller.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/filter_dialog.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/icon_button.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchAndFilterRow extends StatelessWidget {
  final bool isMobile;
  SearchAndFilterRow({Key? key, required this.isMobile}) : super(key: key);
  final StatisticController controller = Get.find<StatisticController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 225,
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "${AppLocalizations.of(context)!.search}...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
            ),
            onChanged: (value) => controller.search.value = value,
            onFieldSubmitted: (value) {
              controller.fetchDataStats(
                page: controller.currentPage.value,
                pageSize: controller.pageSize.value,
              );
            },
          ),
        ),
        const Spacer(),
        CustomIconButton.primary(
          height: 50,
          width: 50,
          iconName: AppIconName.filter,
          onTap: () {
            if (isMobile) {
              Get.dialog(FilterDialog());
            } else {
              controller.showFilterBox.value = !controller.showFilterBox.value;
            }
          },
          context: context,
        ),
      ],
    );
  }
}
