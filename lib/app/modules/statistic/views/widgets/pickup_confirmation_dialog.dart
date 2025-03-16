import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/data/services/camera_service.dart';
import 'package:frontend_waste_management_stackholder/app/data/services/location_handler.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/controllers/statistic_controller.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/centered_text_button_with_icon.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart';

class PickupConfirmationDialog extends GetView<StatisticController> {
  final int rowId;
  final VoidCallback onConfirm;
  final bool isMobile;
  const PickupConfirmationDialog(
      {Key? key,
      required this.rowId,
      required this.onConfirm,
      required this.isMobile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.labelDefaultEmphasis(
              AppLocalizations.of(context)!.pickup_confirmation,
              context: context,
              textAlign: TextAlign.center,
              color: Theme.of(context).appColors.textSecondary,
            ),
            VerticalGap.formMedium(),
            ElevatedButton(
                onPressed: () {
                  openCameraDialog(
                    onCaptured: (capturedDataUrl) async {
                      // Update the controller's captured image URL
                      controller.capturedImageUrl.value = capturedDataUrl;
                      controller.evidencePosition.value =
                          await getUserCurrentLocation();
                      // Optionally close the dialog if desired:
                      // Get.back();
                    },
                  );
                },
                child: Text("take evidence picture")),
            VerticalGap.formMedium(),
            ElevatedButton(
                onPressed: () {
                  pickImageFromSystem(
                    onPicked: (capturedDataUrl, latitude, longitude) {
                      // Update the controller's captured image URL
                      // Update the controller's evidence position
                      if (latitude != null && longitude != null) {
                        controller.capturedImageUrl.value = capturedDataUrl;
                        controller.evidencePosition.value =
                            LatLng(latitude, longitude);
                      } else {
                        controller.capturedImageUrl.value = "";
                        showFailedSnackbar(
                          "Failed to get evidence position",
                          "Please try again, with a valid image",
                        );
                      }
                      // Optionally close the dialog if desired:
                      // Get.back();
                    },
                  );
                },
                child: Text("pick evidence picture")),
            Obx(() {
              if (controller.capturedImageUrl.value.isNotEmpty) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    VerticalGap.formMedium(),
                    AppText.labelDefaultEmphasis(
                      "Evidence Image:",
                      color: color.textSecondary,
                      context: context,
                    ),
                    VerticalGap.formSmall(),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        constraints: const BoxConstraints(
                          maxHeight: 300,
                          maxWidth: 350, // Constrain width
                        ),
                        child: Image.network(
                          controller.capturedImageUrl.value,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) =>
                              loadingProgress == null
                                  ? child
                                  : Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
            VerticalGap.formBig(),
            isMobile
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          controller.capturedImageUrl.value = "";
                          Get.back();
                        },
                        child: AppText.labelSmallDefault(
                          AppLocalizations.of(context)!.cancel,
                          color: Theme.of(context).appColors.textSecondary,
                          context: context,
                        ),
                      ),
                      HorizontalGap.formHuge(),
                      TextButton(
                        onPressed: () {
                          onConfirm();
                          Get.back();
                        },
                        child: AppText.labelSmallDefault(
                          AppLocalizations.of(context)!.already,
                          color: Theme.of(context).appColors.textPrimary,
                          context: context,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CenteredTextButtonWithIcon.secondary(
                        label: AppLocalizations.of(context)!.cancel,
                        width: 120,
                        height: 35,
                        onTap: () {
                          controller.capturedImageUrl.value = "";
                          Get.back();
                        },
                        context: context,
                      ),
                      HorizontalGap.formHuge(),
                      CenteredTextButtonWithIcon.primary(
                        label: AppLocalizations.of(context)!.already,
                        width: 120,
                        height: 35,
                        onTap: () {
                          onConfirm();
                          Get.back();
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
}
