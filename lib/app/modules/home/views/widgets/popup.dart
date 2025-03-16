import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/data/models/sampah_detail_model.dart';
import 'package:frontend_waste_management_stackholder/app/data/services/camera_service.dart';
import 'package:frontend_waste_management_stackholder/app/modules/home/controllers/home_controller.dart';
import 'package:frontend_waste_management_stackholder/app/modules/home/views/widgets/item_tiles.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_icon.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/centered_text_button_with_icon.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management_stackholder/app/modules/home/views/widgets/preview_page.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class Popup extends GetView<HomeController> {
  Popup({Key? key, required this.detail}) : super(key: key);
  final SampahDetail detail;

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    var size = MediaQuery.of(context).size;
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      maxChildSize: 1.0,
      minChildSize: 0.12,
      builder: (context, scrollController) {
        return NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            if (notification.extent == notification.minExtent) {
              controller.resetRouteToTPA();
              controller.selectedMarkerDetail.value = null;
            }
            return true;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerticalGap.formMedium(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 6,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ],
                  ),
                  VerticalGap.formHuge(),
                  if (detail.image != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            height: size.width * 0.35,
                            width: size.width * 0.35,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(23.0),
                              image: DecorationImage(
                                image: NetworkImage(
                                  detail.image!,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        HorizontalGap.formBig(),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                              if (detail.address != null)
                                AppText.labelSmallDefault(
                                  detail.address!,
                                  textOverflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  color: color.textSecondary,
                                  context: context,
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  VerticalGap.formMedium(),
                  AppText.labelDefaultEmphasis(
                      AppLocalizations.of(context)!.capture_time,
                      color: color.textSecondary,
                      context: context),
                  VerticalGap.formSmall(),
                  AppText.labelSmallDefault(
                      DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(detail.captureTime!),
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
                          context: context,
                        ),
                        // checkbox widget
                        Checkbox(
                          value: detail.isPickup!,
                          onChanged: (value) {
                            Get.dialog(
                                barrierDismissible: false,
                                Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(32.0),
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
                                          textAlign: TextAlign.center,
                                          color: color.textSecondary,
                                        ),
                                        VerticalGap.formMedium(),
                                        ElevatedButton(
                                            onPressed: () {
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
                                            child:
                                                Text("take evidence picture")),
                                        VerticalGap.formMedium(),
                                        ElevatedButton(
                                            onPressed: () {
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
                                                      "Failed to get evidence position",
                                                      "Please try again, with a valid image",
                                                    );
                                                  }
                                                  // Optionally close the dialog if desired:
                                                  // Get.back();
                                                },
                                              );
                                            },
                                            child:
                                                Text("pick evidence picture")),
                                        Obx(() {
                                          if (controller.capturedImageUrl.value
                                              .isNotEmpty) {
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
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                controller.capturedImageUrl
                                                    .value = "";
                                                Get.back();
                                              },
                                              child: AppText.labelSmallDefault(
                                                AppLocalizations.of(context)!
                                                    .cancel,
                                                color: color.textSecondary,
                                                context: context,
                                              ),
                                            ),
                                            HorizontalGap.formHuge(),
                                            TextButton(
                                              onPressed: () {
                                                controller.markPickupSampah(
                                                    detail.id!);
                                                Get.back();
                                              },
                                              child: AppText.labelSmallDefault(
                                                AppLocalizations.of(context)!
                                                    .already,
                                                color: color.textPrimary,
                                                context: context,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
                              height: size.height * 0.2,
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
                  ),
                  VerticalGap.formBig(),
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
                                  ? AppLocalizations.of(context)!
                                      .nearest_landfill
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
                                      controller.distance.value
                                          .toStringAsFixed(2)),
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
                          label:
                              AppLocalizations.of(context)!.route_to_landfill,
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
      },
    );
  }
}
