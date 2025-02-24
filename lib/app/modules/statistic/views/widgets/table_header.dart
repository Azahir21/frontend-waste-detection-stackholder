import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/controllers/statistic_controller.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/filter_dialog.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/search_filter_row.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/show_entries_dropdown.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/icon_button.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TableHeader extends StatelessWidget {
  final bool isMobile;
  TableHeader({Key? key, required this.isMobile}) : super(key: key);

  final StatisticController controller = Get.find<StatisticController>();

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShowEntriesDropdown(),
          VerticalGap.formMedium(),
          SearchAndFilterRow(isMobile: isMobile),
        ],
      );
    }
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          ShowEntriesDropdown(),
          HorizontalGap.formBig(),
          // Expanded makes this area take all available space.
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Determine if there is at least 250 pixels available.
                final fieldWidth =
                    constraints.maxWidth >= 250 ? 250.0 : constraints.maxWidth;
                return Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: fieldWidth,
                    height: 50,
                    child: TextFormField(
                      initialValue: controller.search.value,
                      decoration: InputDecoration(
                        hintText: "${AppLocalizations.of(context)!.search}...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
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
                );
              },
            ),
          ),
          // A small gap if needed between the search field and filter button.
          HorizontalGap.formBig(),
          CustomIconButton.primary(
            height: 50,
            width: 50,
            iconName: AppIconName.filter,
            onTap: () {
              if (isMobile) {
                Get.dialog(FilterDialog());
              } else {
                controller.showFilterBox.value =
                    !controller.showFilterBox.value;
              }
            },
            context: context,
          ),
        ],
      ),
    );
  }
}
