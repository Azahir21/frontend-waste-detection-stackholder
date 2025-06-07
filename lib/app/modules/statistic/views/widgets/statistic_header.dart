import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/icon_button.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/controllers/statistic_controller.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';
import 'package:get/get.dart';

class StatisticHeader extends StatefulWidget {
  final bool isMobile;
  StatisticHeader({Key? key, required this.isMobile}) : super(key: key);

  @override
  State<StatisticHeader> createState() => _StatisticHeaderState();
}

class _StatisticHeaderState extends State<StatisticHeader> {
  final controller = Get.find<StatisticController>();

  @override
  Widget build(BuildContext context) {
    final headerText = AppText.customSize(
      AppLocalizations.of(context)!.statistics,
      size: widget.isMobile ? 28 : 40,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).appColors.textSecondary,
      context: context,
    );
    return Padding(
      padding: widget.isMobile
          ? EdgeInsets.zero
          : const EdgeInsets.only(left: 80.0, right: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.isMobile
              ? SizedBox(
                  width: 50,
                  height: 50,
                )
              : SizedBox.shrink(),
          widget.isMobile ? Center(child: headerText) : headerText,
          CustomIconButton.primary(
              iconName: AppIconName.download,
              onTap: () {
                Get.dialog(AlertDialog(
                  title: Center(
                    child: AppText.labelDefaultEmphasis(
                      AppLocalizations.of(context)!.filter_download,
                      context: context,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText.labelSmallEmphasis(
                                  AppLocalizations.of(context)!.filter_by_type,
                                  color:
                                      Theme.of(context).appColors.textSecondary,
                                  context: context,
                                ),
                                VerticalGap.formSmall(),
                                _buildCheckboxRow(
                                  label: AppLocalizations.of(context)!
                                      .all_kind_of_waste,
                                  isChecked:
                                      controller.dataTypeDownload.value ==
                                          "all",
                                  onChanged: () {
                                    controller.previousDataTypeDownload =
                                        controller.dataTypeDownload.value;
                                    controller.dataTypeDownload.value = "all";
                                  },
                                ),
                                VerticalGap.formSmall(),
                                _buildCheckboxRow(
                                  label: AppLocalizations.of(context)!
                                      .illegal_trash,
                                  isChecked:
                                      controller.dataTypeDownload.value ==
                                          "garbage_pcs",
                                  onChanged: () {
                                    controller.previousDataTypeDownload =
                                        controller.dataTypeDownload.value;
                                    controller.dataTypeDownload.value =
                                        "garbage_pcs";
                                  },
                                ),
                                VerticalGap.formSmall(),
                                _buildCheckboxRow(
                                  label: AppLocalizations.of(context)!
                                      .illegal_dumping_site,
                                  isChecked:
                                      controller.dataTypeDownload.value ==
                                          "garbage_pile",
                                  onChanged: () {
                                    controller.previousDataTypeDownload =
                                        controller.dataTypeDownload.value;
                                    controller.dataTypeDownload.value =
                                        "garbage_pile";
                                  },
                                ),
                              ],
                            )),
                        VerticalGap.formMedium(),
                        Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.labelSmallEmphasis(
                                AppLocalizations.of(context)!.filter_by_status,
                                color:
                                    Theme.of(context).appColors.textSecondary,
                                context: context,
                              ),
                              VerticalGap.formSmall(),
                              _buildCheckboxRow(
                                label: AppLocalizations.of(context)!.all_status,
                                isChecked:
                                    controller.statusDownload.value == "all",
                                onChanged: () {
                                  controller.previousStatus =
                                      controller.statusDownload.value;
                                  controller.statusDownload.value = "all";
                                },
                              ),
                              VerticalGap.formSmall(),
                              _buildCheckboxRow(
                                label: AppLocalizations.of(context)!.collected,
                                isChecked: controller.statusDownload.value ==
                                    "collected",
                                onChanged: () {
                                  controller.previousStatus =
                                      controller.statusDownload.value;
                                  controller.statusDownload.value = "collected";
                                },
                              ),
                              VerticalGap.formSmall(),
                              _buildCheckboxRow(
                                label:
                                    AppLocalizations.of(context)!.uncollected,
                                isChecked: controller.statusDownload.value ==
                                    "not_collected",
                                onChanged: () {
                                  controller.previousStatus =
                                      controller.statusDownload.value;
                                  controller.statusDownload.value =
                                      "not_collected";
                                },
                              ),
                            ],
                          ),
                        ),
                        VerticalGap.formMedium(),
                        AppText.labelSmallEmphasis(
                            AppLocalizations.of(context)!.search_location,
                            color: Theme.of(context).appColors.textSecondary,
                            context: context),
                        VerticalGap.formSmall(),
                        SizedBox(
                          width: 300,
                          child: Obx(
                            () => TextFormField(
                              initialValue: controller.searchDownload.value,
                              decoration: InputDecoration(
                                hintText: "Jawa Timur",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onChanged: (value) =>
                                  controller.searchDownload.value = value,
                            ),
                          ),
                        ),
                        VerticalGap.formMedium(),
                        AppText.labelSmallEmphasis(
                            AppLocalizations.of(context)!.start_date,
                            color: Theme.of(context).appColors.textSecondary,
                            context: context),
                        VerticalGap.formSmall(),
                        _buildStartDateField(),
                        VerticalGap.formMedium(),
                        AppText.labelSmallEmphasis(
                            AppLocalizations.of(context)!.end_date,
                            color: Theme.of(context).appColors.textSecondary,
                            context: context),
                        VerticalGap.formSmall(),
                        _buildEndDateField(),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back(closeOverlays: true);
                        controller.resetDownloadFilter();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (controller
                                .firstDateController.value.text.isNotEmpty &&
                            controller.lastDateController.value.text.isEmpty) {
                          showFailedSnackbar(
                            AppLocalizations.of(context)!
                                .failed_to_pick_end_date,
                            AppLocalizations.of(context)!
                                .please_input_start_and_end_date,
                          );
                          return;
                        }
                        controller.downloadStatisticsExcel();
                        controller.resetDownloadFilter();

                        Get.back(closeOverlays: true);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.ok,
                      ),
                    ),
                  ],
                ));
              },
              context: context)
        ],
      ),
    );
  }

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

  Widget _buildStartDateField() {
    return Obx(
      () => TextFormField(
        controller: controller.firstDateController.value,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.start_date,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2024, 5),
            lastDate: DateTime.now(),
          );

          if (pickedDate != null) {
            setState(() {
              controller.firstDate.value = pickedDate;
              controller.firstDateController.value.text = pickedDate.toString();
            });
          }
        },
      ),
    );
  }

  Widget _buildEndDateField() {
    return Obx(
      () => TextFormField(
        controller: controller.lastDateController.value,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.end_date,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () async {
          if (controller.firstDateController.value.text.isEmpty) {
            showFailedSnackbar(
              AppLocalizations.of(context)!.failed_to_pick_end_date,
              AppLocalizations.of(context)!.please_input_start_date_first,
            );
            return;
          }

          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: controller.firstDate.value,
            firstDate: controller.firstDate.value,
            lastDate: DateTime.now(),
          );

          if (pickedDate != null) {
            setState(() {
              controller.lastDate.value = pickedDate;
              controller.lastDateController.value.text = pickedDate.toString();
            });
          }
        },
      ),
    );
  }
}
