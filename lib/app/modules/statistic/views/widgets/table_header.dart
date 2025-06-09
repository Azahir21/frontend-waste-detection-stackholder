import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/controllers/statistic_controller.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/filter_dialog.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/search_filter_row.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/show_entries_dropdown.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/icon_button.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TableHeader extends StatelessWidget {
  final bool isMobile;
  TableHeader({Key? key, required this.isMobile}) : super(key: key);

  final StatisticController controller = Get.find<StatisticController>();

  Widget _buildLocationInfo(BuildContext context) {
    final targetLocation = GetStorage().read('target_location');
    final viewTargetLocationOnly =
        GetStorage().read('view_target_location_only') ?? false;

    if (targetLocation == null || targetLocation.toString().isEmpty) {
      // No target location - don't display any information
      return const SizedBox.shrink();
    }

    String infoText;
    Color textColor;
    IconData icon;

    if (viewTargetLocationOnly) {
      // User has target location and can only see target location data
      infoText = "Viewing data for: $targetLocation (restricted view)";
      textColor = Colors.orange;
      icon = Icons.location_on;
    } else {
      // User has target location but can see other locations too
      infoText =
          "Default location: $targetLocation (can search other locations)";
      textColor = Colors.grey;
      icon = Icons.search;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: textColor,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: AppText.labelSmallDefault(
              infoText,
              color: textColor,
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationInfo(context),
          ShowEntriesDropdown(),
          VerticalGap.formMedium(),
          SearchAndFilterRow(isMobile: isMobile),
        ],
      );
    }
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationInfo(context),
          Row(
            children: [
              ShowEntriesDropdown(),
              HorizontalGap.formBig(),
              // Expanded makes this area take all available space.
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Determine if there is at least 250 pixels available.
                    final fieldWidth = constraints.maxWidth >= 250
                        ? 250.0
                        : constraints.maxWidth;
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: fieldWidth,
                        height: 50,
                        child: TextFormField(
                          initialValue: controller.search.value,
                          decoration: InputDecoration(
                            hintText:
                                "${AppLocalizations.of(context)!.search}...",
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
        ],
      ),
    );
  }
}
