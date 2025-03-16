import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/data/models/sampah_detail_model.dart';
import 'package:frontend_waste_management_stackholder/app/data/services/camera_service.dart';
import 'package:frontend_waste_management_stackholder/app/data/services/location_handler.dart';
import 'package:frontend_waste_management_stackholder/app/modules/home/controllers/home_controller.dart';
import 'package:frontend_waste_management_stackholder/app/modules/home/views/widgets/item_tiles.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_icon.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/centered_text_button_with_icon.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';

import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class SideBarDetail extends GetView<HomeController> {
  const SideBarDetail({Key? key, required this.detail}) : super(key: key);
  final SampahDetail detail;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).appColors;
    return Container(
      height: double.infinity,
      width: 450,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.5),
                child: Align(
                  alignment: Alignment.topRight,
                  child: CenteredTextButtonWithIcon.secondary(
                      label: AppLocalizations.of(context)!.back,
                      leftIcon: AppIconName.backButton,
                      width: 150,
                      height: 35,
                      onTap: () {
                        controller.resetRouteToTPA();
                        controller.selectedMarkerDetail.value = null;
                      },
                      context: context),
                ),
              ),
              VerticalGap.formMedium(),
              GestureDetector(
                onTap: () {
                  Get.dialog(
                    Dialog(
                      child: Stack(
                        children: [
                          InteractiveViewer(
                            child: Image.network(detail.image!),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(23),
                    image: DecorationImage(
                      image: NetworkImage(detail.image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              VerticalGap.formMedium(),
              Row(
                children: [
                  AppIcon.custom(
                      size: 20,
                      appIconName: AppIconName.locationv2,
                      context: context),
                  HorizontalGap.formSmall(),
                  AppText.labelSmallEmphasis(
                    AppLocalizations.of(context)!.location,
                    color: color.textSecondary,
                    context: context,
                  ),
                ],
              ),
              VerticalGap.formMedium(),
              AppText.labelSmallDefault(
                detail.address!,
                textOverflow: TextOverflow.ellipsis,
                maxLines: 4,
                color: color.textSecondary,
                context: context,
              ),
              VerticalGap.formMedium(),
              AppText.labelDefaultEmphasis(
                  AppLocalizations.of(context)!.capture_time,
                  color: color.textSecondary,
                  context: context),
              VerticalGap.formSmall(),
              AppText.labelSmallDefault(
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(detail.captureTime!),
                  color: color.textSecondary,
                  context: context),
              VerticalGap.formMedium(),
              AppText.labelDefaultEmphasis(
                AppLocalizations.of(context)!.waste_detected,
                color: color.textSecondary,
                context: context,
              ),
              VerticalGap.formMedium(),
              if (detail.countedObjects != null)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: detail.countedObjects!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ItemTiles(
                      countObject: detail.countedObjects![index],
                    );
                  },
                ),
              VerticalGap.formBig(),
              Row(
                children: [
                  AppText.labelDefaultEmphasis(
                    AppLocalizations.of(context)!.status,
                    color: color.textSecondary,
                    context: context,
                  ),
                  Visibility(
                    visible: detail.isPickup!,
                    replacement: AppText.labelDefaultEmphasis(
                      "   (${AppLocalizations.of(context)!.pickup_false})",
                      context: context,
                      color: color.textRed,
                    ),
                    child: AppText.labelDefaultEmphasis(
                      "   (${AppLocalizations.of(context)!.pickup_true})",
                      context: context,
                      color: color.textPrimary,
                    ),
                  ),
                ],
              ),
              VerticalGap.formMedium(),
              Visibility(
                visible: detail.isPickup!,
                replacement: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.labelSmallDefault(
                        "${AppLocalizations.of(context)!.already_picked_up}?",
                        color: color.textSecondary,
                        context: context),
                    // checkbox widget
                    Checkbox(
                      value: detail.isPickup!,
                      onChanged: (value) {
                        Get.dialog(
                            barrierDismissible: false,
                            Dialog(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                // Adjust width as needed
                                constraints: BoxConstraints(
                                  maxWidth:
                                      400, // Set a maximum width to prevent it from being too wide
                                ),
                                child: IntrinsicWidth(
                                  stepWidth: 56,
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          AppText.labelDefaultEmphasis(
                                            AppLocalizations.of(context)!
                                                .pickup_confirmation,
                                            context: context,
                                            color: color.textSecondary,
                                          ),
                                          VerticalGap.formMedium(),
                                          CenteredTextButton.primary(
                                            height: 35,
                                            onTap: () {
                                              openCameraDialog(
                                                onCaptured:
                                                    (capturedDataUrl) async {
                                                  // Update the controller's captured image URL
                                                  controller.capturedImageUrl
                                                      .value = capturedDataUrl;
                                                  controller.evidencePosition
                                                          .value =
                                                      controller.curruntPosition
                                                          .value;
                                                  // Optionally close the dialog if desired:
                                                  // Get.back();
                                                },
                                              );
                                            },
                                            label: AppLocalizations.of(context)!
                                                .take_evidence_picture,
                                            context: context,
                                          ),
                                          VerticalGap.formMedium(),
                                          CenteredTextButton.primary(
                                            height: 35,
                                            onTap: () {
                                              pickImageFromSystem(
                                                onPicked: (capturedDataUrl,
                                                    latitude, longitude) {
                                                  // Update the controller's captured image URL
                                                  // Update the controller's evidence position
                                                  if (latitude != null &&
                                                      longitude != null) {
                                                    controller.capturedImageUrl
                                                            .value =
                                                        capturedDataUrl;
                                                    controller.evidencePosition
                                                            .value =
                                                        LatLng(latitude,
                                                            longitude);
                                                  } else {
                                                    controller.capturedImageUrl
                                                        .value = "";
                                                    showFailedSnackbar(
                                                      AppLocalizations.of(
                                                              Get.context!)!
                                                          .failed_to_get_evidence_position,
                                                      AppLocalizations.of(
                                                              Get.context!)!
                                                          .try_again_with_valid_image,
                                                    );
                                                  }
                                                  // Optionally close the dialog if desired:
                                                  // Get.back();
                                                },
                                              );
                                            },
                                            label: AppLocalizations.of(context)!
                                                .pick_evidence_picture,
                                            context: context,
                                          ),
                                          Obx(() {
                                            if (controller.capturedImageUrl
                                                .value.isNotEmpty) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  VerticalGap.formMedium(),
                                                  AppText.labelDefaultEmphasis(
                                                    "${AppLocalizations.of(context)!.evidence_image}:",
                                                    color: color.textSecondary,
                                                    context: context,
                                                  ),
                                                  VerticalGap.formSmall(),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Container(
                                                      constraints:
                                                          const BoxConstraints(
                                                        maxHeight: 300,
                                                        maxWidth:
                                                            350, // Constrain width
                                                      ),
                                                      child: Image.network(
                                                        controller
                                                            .capturedImageUrl
                                                            .value,
                                                        fit: BoxFit.contain,
                                                        loadingBuilder: (context,
                                                                child,
                                                                loadingProgress) =>
                                                            loadingProgress ==
                                                                    null
                                                                ? child
                                                                : Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      value: loadingProgress.expectedTotalBytes !=
                                                                              null
                                                                          ? loadingProgress.cumulativeBytesLoaded /
                                                                              loadingProgress.expectedTotalBytes!
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
                                          Wrap(
                                            spacing: 16,
                                            runSpacing: 12,
                                            alignment: WrapAlignment.center,
                                            children: [
                                              CenteredTextButtonWithIcon
                                                  .secondary(
                                                label: AppLocalizations.of(
                                                        context)!
                                                    .cancel,
                                                width: 120,
                                                height: 35,
                                                onTap: () {
                                                  controller.capturedImageUrl
                                                      .value = "";
                                                  Get.back();
                                                },
                                                context: context,
                                              ),
                                              CenteredTextButtonWithIcon
                                                  .primary(
                                                label: AppLocalizations.of(
                                                        context)!
                                                    .already,
                                                width: 120,
                                                height: 35,
                                                onTap: () {
                                                  controller.markPickupSampah(
                                                      detail.id!);
                                                  Get.back();
                                                },
                                                context: context,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ));
                      },
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.labelDefaultEmphasis(
                      "${AppLocalizations.of(context)!.detail_information_pickup} :",
                      color: color.textSecondary,
                      context: context,
                    ),
                    VerticalGap.formSmall(),
                    Row(
                      children: [
                        Flexible(
                          child: AppText.labelSmallEmphasis(
                            "${AppLocalizations.of(context)!.pickup_by}: ",
                            color: color.textSecondary,
                            context: context,
                          ),
                        ),
                        Flexible(
                          child: AppText.labelSmallDefault(
                            detail.pickupByUser ?? "N/A",
                            color: color.textSecondary,
                            context: context,
                          ),
                        ),
                      ],
                    ),
                    VerticalGap.formSmall(),
                    Row(
                      children: [
                        Flexible(
                          child: AppText.labelSmallEmphasis(
                            "${AppLocalizations.of(context)!.pickup_at}: ",
                            color: color.textSecondary,
                            context: context,
                          ),
                        ),
                        Flexible(
                          child: AppText.labelSmallDefault(
                            detail.pickupAt != null
                                ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(detail.pickupAt!)
                                : "N/A",
                            color: color.textSecondary,
                            context: context,
                          ),
                        ),
                      ],
                    ),
                    VerticalGap.formSmall(),
                    if (detail.evidence != null)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.labelSmallEmphasis(
                            "${AppLocalizations.of(context)!.evidence_image}:",
                            color: color.textSecondary,
                            context: context,
                          ),
                          VerticalGap.formSmall(),
                          GestureDetector(
                            onTap: () {
                              Get.dialog(
                                Dialog(
                                  child: Stack(
                                    children: [
                                      InteractiveViewer(
                                        child: Image.network(detail.evidence!),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(23.0),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    detail.evidence!,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              //lj;lj
              Obx(
                () => Visibility(
                  visible: !detail.isPickup!,
                  child: Visibility(
                    visible: controller.routeToTPA.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalGap.formBig(),
                        Visibility(
                          visible: controller.routeError.value,
                          child: Column(
                            children: [
                              AppText.labelDefaultEmphasis(
                                AppLocalizations.of(context)!.no_route,
                                color: color.textRed,
                                context: context,
                              ),
                              VerticalGap.formMedium(),
                            ],
                          ),
                        ),
                        AppText.labelDefaultEmphasis(
                          controller.routeError.value
                              ? AppLocalizations.of(context)!.nearest_landfill
                              : AppLocalizations.of(context)!.landfill_info,
                          color: controller.routeError.value
                              ? color.textRed
                              : color.textSecondary,
                          context: context,
                        ),
                        VerticalGap.formMedium(),
                        Row(
                          children: [
                            AppIcon.custom(
                                size: 20,
                                appIconName: AppIconName.locationv2,
                                context: context),
                            HorizontalGap.formSmall(),
                            AppText.labelSmallEmphasis(
                              AppLocalizations.of(context)!.location,
                              color: color.textSecondary,
                              context: context,
                            ),
                          ],
                        ),
                        VerticalGap.formMedium(),
                        Obx(
                          () => AppText.labelSmallDefault(
                            controller.tpaAddress.value ?? "N/A",
                            textOverflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            color: color.textSecondary,
                            context: context,
                          ),
                        ),
                        VerticalGap.formMedium(),
                        Obx(
                          () => Visibility(
                            visible: !controller.routeError.value,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color: color.textSecondary,
                                ),
                                HorizontalGap.formSmall(),
                                AppText.labelSmallEmphasis(
                                  AppLocalizations.of(context)!.travel_time(
                                      controller.hours.value.toString(),
                                      controller.minutes.value.toString()),
                                  color: color.textSecondary,
                                  context: context,
                                ),
                              ],
                            ),
                          ),
                        ),
                        VerticalGap.formMedium(),
                        Row(
                          children: [
                            Icon(
                              Icons.route,
                              size: 20,
                              color: color.textSecondary,
                            ),
                            HorizontalGap.formSmall(),
                            AppText.labelSmallEmphasis(
                              AppLocalizations.of(context)!.distance(
                                  controller.distance.value.toStringAsFixed(2)),
                              color: color.textSecondary,
                              context: context,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              VerticalGap.formBig(),
              Obx(
                () => Visibility(
                  visible: !detail.isPickup!,
                  child: Visibility(
                    visible: !controller.routeToTPA.value,
                    replacement: CenteredTextButton.tertiary(
                        width: double.infinity,
                        label: AppLocalizations.of(context)!.close_route,
                        onTap: () {
                          controller.resetRouteToTPA();
                        },
                        context: context),
                    child: CenteredTextButton.quaternary(
                      width: double.infinity,
                      label: AppLocalizations.of(context)!.route_to_landfill,
                      onTap: () {
                        controller.getRouteToTPA(detail.geom!);
                      },
                      context: context,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
