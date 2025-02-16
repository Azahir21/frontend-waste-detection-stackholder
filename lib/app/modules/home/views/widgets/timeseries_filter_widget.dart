import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/home/controllers/home_controller.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeSeriesFilterWidget extends StatefulWidget {
  const TimeSeriesFilterWidget({
    Key? key,
  }) : super(key: key);

  @override
  _TimeSeriesFilterWidgetState createState() => _TimeSeriesFilterWidgetState();
}

class _TimeSeriesFilterWidgetState extends State<TimeSeriesFilterWidget> {
  final HomeController controller = Get.find<HomeController>();
  bool _isDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < 600;

    return Obx(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.showTimeSeries.value) {
          if (isMobile && !_isDialogOpen) {
            _isDialogOpen = true;
            Get.dialog(
              timeseriesDialog(),
              barrierDismissible: false,
            ).then((_) {
              _isDialogOpen = false;
              // controller.showTimeSeries.value = false;
            });
          } else if (!isMobile && _isDialogOpen) {
            if (Get.isDialogOpen ?? false) {
              Get.back();
            }
            _isDialogOpen = false;
          }
        }
      });

      return Visibility(
        visible: controller.showTimeSeries.value,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 100, 100, 32),
          child: Align(
            alignment: Alignment.topRight,
            child: isMobile ? Container() : timeseriesBox(),
          ),
        ),
      );
    });
  }

  Widget timeseriesBox() {
    final themeColors = Theme.of(context).appColors;
    return Container(
      width: 330,
      decoration: BoxDecoration(
        color: themeColors.iconButtonPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.labelDefaultEmphasis(
              AppLocalizations.of(context)!.filter_timeseries,
              context: context,
            ),
            VerticalGap.formSmall(),
            _buildStartDateField(),
            VerticalGap.formMedium(),
            _buildEndDateField(),
            VerticalGap.formBig(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CenteredTextButton.secondary(
                  width: 125,
                  label: AppLocalizations.of(context)!.cancel,
                  onTap: () {
                    controller.showTimeSeries.value = false;
                  },
                  context: context,
                ),
                CenteredTextButton.primary(
                  width: 125,
                  label: AppLocalizations.of(context)!.apply,
                  onTap: () {
                    if (controller.firstDateController.value.text.isEmpty ||
                        controller.lastDateController.value.text.isEmpty) {
                      showFailedSnackbar(
                        AppLocalizations.of(context)!.failed_to_apply,
                        AppLocalizations.of(context)!
                            .please_input_start_and_end_date,
                      );
                      return;
                    }

                    controller.getTimeseriesData();
                    controller.showTimeSeries.value = false;
                  },
                  context: context,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the AlertDialog for mobile devices.
  Widget timeseriesDialog() {
    final themeColors = Theme.of(context).appColors;
    return AlertDialog(
      title: AppText.labelDefaultEmphasis(
        AppLocalizations.of(context)!.filter_timeseries,
        context: context,
      ),
      content: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStartDateField(),
            _buildEndDateField(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.firstDateController.value.text = "";
            controller.lastDateController.value.text = "";
            Get.back();
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () {
            controller.getTimeseriesData();
            Get.back();
          },
          child: Text(AppLocalizations.of(context)!.ok),
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
