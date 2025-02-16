import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:frontend_waste_management_stackholder/app/modules/home/views/widgets/maps_type_dialog.dart';
import 'package:frontend_waste_management_stackholder/app/modules/home/views/widgets/popup.dart';
import 'package:frontend_waste_management_stackholder/app/modules/home/views/widgets/sidebar_detail.dart';
import 'package:frontend_waste_management_stackholder/app/modules/home/views/widgets/timeseries_filter_widget.dart';
import 'package:frontend_waste_management_stackholder/app/modules/home/views/widgets/waste_type_filter_widget.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/centered_text_button_with_icon.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/icon_button.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/text_button.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.put(HomeController());

  List<Map<double, MaterialColor>> gradients = [
    HeatMapOptions.defaultGradient,
  ];
  bool _isDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        return SafeArea(
          child: Stack(
            children: [
              Obx(
                () => Visibility(
                  visible: !controller.isLoading.value,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: Obx(
                    () => FlutterMap(
                      options: MapOptions(
                        initialCenter: controller.curruntPosition.value,
                        initialZoom: 12,
                        maxZoom: 18,
                        minZoom: 3,
                        cameraConstraint: CameraConstraint.contain(
                          bounds: LatLngBounds(
                            const LatLng(-90, -180),
                            const LatLng(90, 180),
                          ),
                        ),
                        onPositionChanged:
                            (MapPosition position, bool hasGesture) {
                          if (hasGesture &&
                              controller.alignPositionOnUpdate !=
                                  AlignOnUpdate.never) {
                            setState(() {
                              controller.alignPositionOnUpdate.value =
                                  AlignOnUpdate.never;
                            });
                          }
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              // 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                          // 'https://tiles.stadiamaps.com/tiles/alidade_satellite/{z}/{x}/{y}{r}.jpg',
                          // retinaMode: true,
                          tileProvider: CancellableNetworkTileProvider(
                            silenceExceptions: true,
                          ),
                        ),
                        MarkerLayer(markers: controller.facilityMarkers),
                        Obx(
                          () {
                            // Show layer based on the selected mode
                            if (controller.mapsMode.value == 'heatmap') {
                              return controller.weightedLatLng.isNotEmpty
                                  ? HeatMapLayer(
                                      heatMapDataSource:
                                          InMemoryHeatMapDataSource(
                                        data:
                                            controller.weightedLatLng.toList(),
                                      ),
                                      heatMapOptions: HeatMapOptions(
                                        gradient: gradients[0],
                                        minOpacity: 0.1,
                                      ),
                                      reset: controller
                                          .streamController.value.stream,
                                    )
                                  : Center(
                                      child: AppText.labelSmallDefault(
                                        AppLocalizations.of(context)!
                                            .no_data_found,
                                        color: color.textSecondary,
                                        context: context,
                                      ),
                                    );
                            } else if (controller.mapsMode.value == 'cluster') {
                              return controller.markers.isNotEmpty
                                  ? SuperclusterLayer.mutable(
                                      initialMarkers:
                                          controller.markers.toList(),
                                      controller: controller
                                          .superclusterController.value,
                                      clusterWidgetSize: const Size(40, 40),
                                      indexBuilder: IndexBuilders.rootIsolate,
                                      builder: (context, position, markerCount,
                                          extraClusterData) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: controller.interpolateColor(
                                              markerCount / 20,
                                              controller.defaultGradient,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              markerCount.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Center(
                                      child: AppText.labelSmallDefault(
                                        AppLocalizations.of(context)!
                                            .no_data_found,
                                        color: color.textSecondary,
                                        context: context,
                                      ),
                                    );
                            } else if (controller.mapsMode.value == 'marker') {
                              return controller.markers.isNotEmpty
                                  ? MarkerLayer(
                                      markers: controller.markers.toList())
                                  : Center(
                                      child: AppText.labelSmallDefault(
                                        AppLocalizations.of(context)!
                                            .no_data_found,
                                        color: color.textSecondary,
                                        context: context,
                                      ),
                                    );
                            } else {
                              return Container(); // Default empty layer if no mode matches
                            }
                          },
                        ),
                        const MapCompass.cupertino(
                            hideIfRotatedNorth: true,
                            padding: EdgeInsets.fromLTRB(32, 230, 35, 32)),
                        CurrentLocationLayer(
                          alignPositionStream: controller
                              .alignPositionStreamController.value.stream,
                          alignPositionOnUpdate:
                              controller.alignPositionOnUpdate.value,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // filter button jangan dihapus
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: CustomIconButton.primary(
                      iconName: AppIconName.filter,
                      onTap: () {
                        controller.showFilter.value =
                            !controller.showFilter.value;

                        if (controller.showFilter.value == true &&
                            (controller.filterDataType.value !=
                                    controller.previousFilterDataType ||
                                controller.filterStatus.value !=
                                    controller.previousFilterStatus)) {
                          controller.filterDataType.value =
                              controller.previousFilterDataType;
                          controller.filterStatus.value =
                              controller.previousFilterStatus;
                          print(controller.filterDataType.value);
                          print(controller.filterStatus.value);
                          print(controller.previousFilterDataType);
                          print(controller.previousFilterStatus);
                        }

                        if (controller.showTimeSeries.value == true ||
                            controller.showMapsType.value == true) {
                          controller.showTimeSeries.value = false;
                          controller.showMapsType.value = false;
                        }
                        // Get.dialog(
                        //   barrierDismissible: false,
                        //   timeseriesDialog(),
                        // );
                      },
                      context: context),
                ),
              ),

              const WasteTypeFilterWidget(),

              // heatmap button jangan dihapus
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 100, 32, 32),
                child: Align(
                  alignment: Alignment.topRight,
                  child: CustomIconButton.primary(
                      iconName: AppIconName.timeseries,
                      onTap: () {
                        controller.showTimeSeries.value =
                            !controller.showTimeSeries.value;

                        if (controller.showFilter.value == true ||
                            controller.showMapsType.value == true) {
                          controller.showFilter.value = false;
                          controller.showMapsType.value = false;
                          controller.filterDataType.value =
                              controller.previousFilterDataType;
                          controller.filterStatus.value =
                              controller.previousFilterStatus;
                        }

                        // Get.dialog(
                        //   barrierDismissible: false,
                        //   filterDialog(),
                        // );
                      },
                      context: context),
                ),
              ),

              const TimeSeriesFilterWidget(),

              // centered camera button jangan dihapus
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 168, 32, 32),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Obx(
                    () => Column(
                      children: [
                        CustomIconButton.activeBordered(
                          iconName: controller.mapsMode.value == 'marker'
                              ? AppIconName.markermap
                              : controller.mapsMode.value == 'cluster'
                                  ? AppIconName.cluster
                                  : AppIconName.heatmap,
                          onTap: () {
                            controller.showMapsType.value =
                                !controller.showMapsType.value;

                            if (controller.showFilter.value == true ||
                                controller.showTimeSeries.value == true) {
                              controller.showFilter.value = false;
                              controller.showTimeSeries.value = false;
                              controller.filterDataType.value =
                                  controller.previousFilterDataType;
                              controller.filterStatus.value =
                                  controller.previousFilterStatus;
                            }
                          },
                          context: context,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Obx(
                () => Visibility(
                  visible: controller.showMapsType.value,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 168, 100, 32),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: MapsTypeDialog(),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(32, 236, 32, 32),
                child: Align(
                  alignment: Alignment.topRight,
                  child: CustomIconButton.primary(
                    iconSize: 24,
                    iconName: AppIconName.myLocation,
                    onTap: () {
                      setState(
                        () => controller.alignPositionOnUpdate.value =
                            AlignOnUpdate.always,
                      );
                      controller.alignPositionStreamController.value.add(18);
                    },
                    context: context,
                  ),
                ),
              ),

              // Inside your widget where the slider box is located
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(32),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Visibility(
                      visible: controller.timeseriesData
                          .isNotEmpty, // Show only if timeseries data exists
                      child: Container(
                        width: double.infinity,
                        height: 138,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18, 10, 18, 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextButton.primary(
                                    text: AppLocalizations.of(context)!.reset,
                                    onPressed: () {
                                      controller.resetTimeSeries();
                                    },
                                    context: context,
                                  ),
                                  // Play/Pause/Restart Button
                                  GestureDetector(
                                    onTap: () {
                                      controller
                                          .togglePlayPause(); // Toggle play/pause/restart
                                    },
                                    child: Icon(
                                      controller.selectedDay.value ==
                                              controller.difference.value
                                          ? Icons
                                              .restart_alt // Show restart icon if at the last day
                                          : controller.isPlaying.value
                                              ? Icons
                                                  .pause // Show pause icon if playing
                                              : Icons.play_arrow,
                                      // Show play icon if paused
                                    ),
                                  ),
                                  AppText.labelSmallEmphasis(
                                    AppLocalizations.of(context)!.day_count(
                                        controller.selectedDay.value),
                                    color: color.textSecondary,
                                    context: context,
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Slider(
                                value: controller.selectedDay.toDouble(),
                                onChanged: (value) {
                                  setState(() {
                                    controller.sliderChanged(value);
                                  });
                                },
                                min: 1,
                                max: controller.difference.toDouble(),
                                thumbColor: color.iconDefault,
                                activeColor: color.iconDefault,
                                divisions: controller.difference.value,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18, 0, 18, 5),
                              child: Obx(() => SizedBox(
                                    height: 35,
                                    child: ToggleButtons(
                                      isSelected: [
                                        !controller.switcher.value,
                                        controller.switcher.value
                                      ],
                                      onPressed: (int index) {
                                        controller.switcher.value = index == 1;
                                        controller.sliderChanged(controller
                                            .selectedDay.value
                                            .toDouble());
                                      },
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: AppText.labelTinyDefault(
                                            color: color.textSecondary,
                                            AppLocalizations.of(context)!
                                                .daily_data,
                                            context: context,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: AppText.labelTinyDefault(
                                            AppLocalizations.of(context)!
                                                .cumulative_data,
                                            color: color.textSecondary,
                                            context: context,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Obx(() {
                if (controller.selectedMarkerDetail.value != null) {
                  if (isMobile) {
                    return Popup(
                        detail: controller.selectedMarkerDetail.value!);
                  } else {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: SideBarDetail(
                        detail: controller.selectedMarkerDetail.value!,
                      ),
                    );
                  }
                }
                return Container(); // Return empty container when no marker is selected
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget wasteTypeDialog() {
    var color = Theme.of(context).appColors;
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: color.iconButtonPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text("filter"),
    );
  }
}
