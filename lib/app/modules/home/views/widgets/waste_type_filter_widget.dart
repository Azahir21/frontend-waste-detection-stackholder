import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/home/controllers/home_controller.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WasteTypeFilterWidget extends StatefulWidget {
  const WasteTypeFilterWidget({Key? key}) : super(key: key);

  @override
  _WasteTypeFilterWidgetState createState() => _WasteTypeFilterWidgetState();
}

class _WasteTypeFilterWidgetState extends State<WasteTypeFilterWidget> {
  final HomeController controller = Get.find<HomeController>();
  bool _isDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Obx(() {
      // Manage dialog state once after the frame.
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _manageDialogState(isMobile));

      return Visibility(
        visible: controller.showFilter.value,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 32, 100, 32),
          child: Align(
            alignment: Alignment.topRight,
            // On mobile, the filter UI is shown via a dialog.
            child: isMobile ? Container() : _buildWasteTypeBox(),
          ),
        ),
      );
    });
  }

  /// Handles opening/closing the dialog depending on device type.
  void _manageDialogState(bool isMobile) {
    if (controller.showFilter.value) {
      if (isMobile && !_isDialogOpen) {
        _isDialogOpen = true;
        Get.dialog(
          _buildWasteTypeDialog(),
          barrierDismissible: false,
        ).then((_) {
          _isDialogOpen = false;
        });
      } else if (!isMobile && _isDialogOpen) {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        _isDialogOpen = false;
      }
    }
  }

  /// Builds the inline filter box for non-mobile devices.
  Widget _buildWasteTypeBox() {
    final themeColors = Theme.of(context).appColors;
    return Container(
      width: 330,
      decoration: BoxDecoration(
        color: themeColors.iconButtonPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.labelDefaultEmphasis(
                AppLocalizations.of(context)!.filter,
                context: context,
              ),
              VerticalGap.formMedium(),
              _buildFilterOptionsContent(),
              VerticalGap.formMedium(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CenteredTextButton.secondary(
                    width: 125,
                    label: AppLocalizations.of(context)!.cancel,
                    onTap: () {
                      controller.showFilter.value = false;
                      controller.filterDataType.value =
                          controller.previousFilterDataType;
                      controller.filterStatus.value =
                          controller.previousFilterStatus;
                    },
                    context: context,
                  ),
                  CenteredTextButton.primary(
                    width: 125,
                    label: AppLocalizations.of(context)!.apply,
                    onTap: () {
                      if (controller.firstDateController.value.text.isEmpty ||
                          controller.lastDateController.value.text.isEmpty) {
                        controller.getAllSampah();
                      } else {
                        controller.getTimeseriesData();
                      }
                      controller.previousFilterDataType =
                          controller.filterDataType.value;
                      controller.previousFilterStatus =
                          controller.filterStatus.value;
                      controller.showFilter.value = false;
                    },
                    context: context,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the dialog version of the filter for mobile devices.
  Widget _buildWasteTypeDialog() {
    final themeColors = Theme.of(context).appColors;
    return AlertDialog(
      title: AppText.labelDefaultEmphasis(
        AppLocalizations.of(context)!.filter,
        context: context,
      ),
      content: SingleChildScrollView(child: _buildFilterOptionsContent()),
      actions: [
        TextButton(
          onPressed: () {
            controller.showFilter.value = false;
            controller.filterDataType.value = controller.previousFilterDataType;
            controller.filterStatus.value = controller.previousFilterStatus;
            Get.back();
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () {
            if (controller.firstDateController.value.text.isEmpty ||
                controller.lastDateController.value.text.isEmpty) {
              controller.getAllSampah();
            } else {
              controller.getTimeseriesData();
            }
            controller.previousFilterDataType = controller.filterDataType.value;
            controller.previousFilterStatus = controller.filterStatus.value;
            controller.showFilter.value = false;
            Get.back();
          },
          child: Text(AppLocalizations.of(context)!.ok),
        ),
      ],
    );
  }

  /// Combines waste type and status filter options.
  Widget _buildFilterOptionsContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWasteTypeOptions(),
        VerticalGap.formMedium(),
        _buildFilterStatusOptions(),
      ],
    );
  }

  /// Builds the waste type filter options.
  Widget _buildWasteTypeOptions() {
    final themeColors = Theme.of(context).appColors;
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.labelSmallEmphasis(
            AppLocalizations.of(context)!.filter_by_type,
            color: themeColors.textSecondary,
            context: context,
          ),
          VerticalGap.formSmall(),
          _buildCheckboxRow(
            label: AppLocalizations.of(context)!.all_kind_of_waste,
            isChecked: controller.filterDataType.value == "all",
            onChanged: () {
              controller.previousFilterDataType =
                  controller.filterDataType.value;
              controller.filterDataType.value = "all";
            },
          ),
          VerticalGap.formSmall(),
          _buildCheckboxRow(
            label: AppLocalizations.of(context)!.illegal_trash,
            isChecked: controller.filterDataType.value == "garbage_pcs",
            onChanged: () {
              controller.previousFilterDataType =
                  controller.filterDataType.value;
              controller.filterDataType.value = "garbage_pcs";
            },
          ),
          VerticalGap.formSmall(),
          _buildCheckboxRow(
            label: AppLocalizations.of(context)!.illegal_dumping_site,
            isChecked: controller.filterDataType.value == "garbage_pile",
            onChanged: () {
              controller.previousFilterDataType =
                  controller.filterDataType.value;
              controller.filterDataType.value = "garbage_pile";
            },
          ),
        ],
      ),
    );
  }

  /// Builds the filter status options.
  Widget _buildFilterStatusOptions() {
    final themeColors = Theme.of(context).appColors;
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.labelSmallEmphasis(
            AppLocalizations.of(context)!.filter_by_status,
            color: themeColors.textSecondary,
            context: context,
          ),
          VerticalGap.formSmall(),
          _buildCheckboxRow(
            label: AppLocalizations.of(context)!.all_status,
            isChecked: controller.filterStatus.value == "all",
            onChanged: () {
              controller.previousFilterStatus = controller.filterStatus.value;
              controller.filterStatus.value = "all";
            },
          ),
          VerticalGap.formSmall(),
          _buildCheckboxRow(
            label: AppLocalizations.of(context)!.pickup_true,
            isChecked: controller.filterStatus.value == "pickup_true",
            onChanged: () {
              controller.previousFilterStatus = controller.filterStatus.value;
              controller.filterStatus.value = "pickup_true";
            },
          ),
          VerticalGap.formSmall(),
          _buildCheckboxRow(
            label: AppLocalizations.of(context)!.pickup_false,
            isChecked: controller.filterStatus.value == "pickup_false",
            onChanged: () {
              controller.previousFilterStatus = controller.filterStatus.value;
              controller.filterStatus.value = "pickup_false";
            },
          ),
        ],
      ),
    );
  }

  /// Returns a row with a checkbox and its label.
  Widget _buildCheckboxRow({
    required String label,
    required bool isChecked,
    required VoidCallback onChanged,
  }) {
    final themeColors = Theme.of(context).appColors;
    return Row(
      children: [
        Checkbox(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          value: isChecked,
          onChanged: (_) => onChanged(),
        ),
        HorizontalGap.formSmall(),
        AppText.labelSmallDefault(
          label,
          color: themeColors.textSecondary,
          context: context,
        ),
      ],
    );
  }
}
