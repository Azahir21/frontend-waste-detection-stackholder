import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/data/models/data_statistics_model.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/controllers/statistic_controller.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/centered_text_button_with_icon.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/icon_button.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PageNavigation extends StatelessWidget {
  final DataStatistics dataStats;
  final bool isMobile;
  const PageNavigation(
      {Key? key, required this.dataStats, required this.isMobile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StatisticController controller = Get.find<StatisticController>();
    final currentPage = dataStats.page ?? 1;
    final totalPages = dataStats.totalPages ?? 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (currentPage > 1)
          isMobile
              ? CustomIconButton.primary(
                  iconName: AppIconName.back,
                  onTap: () => controller.fetchDataStats(
                      page: currentPage - 1,
                      pageSize: controller.pageSize.value),
                  context: context,
                )
              : CenteredTextButtonWithIcon.secondary(
                  label: AppLocalizations.of(context)!.previous,
                  leftIcon: AppIconName.back,
                  height: 36,
                  width: 186,
                  onTap: () => controller.fetchDataStats(
                      page: currentPage - 1,
                      pageSize: controller.pageSize.value),
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
                  onTap: () => controller.fetchDataStats(
                      page: currentPage + 1,
                      pageSize: controller.pageSize.value),
                  context: context,
                )
              : CenteredTextButtonWithIcon.primary(
                  label: AppLocalizations.of(context)!.next,
                  rightIcon: AppIconName.next,
                  height: 36,
                  width: 186,
                  onTap: () => controller.fetchDataStats(
                      page: currentPage + 1,
                      pageSize: controller.pageSize.value),
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
