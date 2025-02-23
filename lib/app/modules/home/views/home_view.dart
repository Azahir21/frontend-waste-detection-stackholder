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
import 'package:frontend_waste_management_stackholder/app/widgets/app_icon.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/icon_button.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/text_button.dart';
import 'package:frontend_waste_management_stackholder/core/theme/color_theme.dart';
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

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    controller.tickerProvider =
        this; // Provide this TickerProvider to the controller.
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determine mobile view based on screen width.
          bool isMobile = constraints.maxWidth < 600;
          return SafeArea(
            child: Row(
              children: [
                // Sidebar on the left (only for non-mobile screens).
                if (!isMobile)
                  Obx(
                    () => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: controller.selectedMarkerDetail.value != null
                          ? 450
                          : 0,
                      child: controller.selectedMarkerDetail.value != null
                          ? SideBarDetail(
                              detail: controller.selectedMarkerDetail.value!)
                          : null,
                    ),
                  ),
                // Map Area (with floating buttons and timeseries slider) takes the remaining space.
                Expanded(
                  child: Stack(
                    children: [
                      // Flutter Map with its layers.
                      Obx(
                        () => Visibility(
                          visible: !controller.isLoading.value,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: Obx(
                            () => FlutterMap(
                              mapController: controller.mapController,
                              options: MapOptions(
                                initialCenter: controller.curruntPosition.value,
                                initialZoom: 12,
                                maxZoom: 18,
                                minZoom: 5,
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
                                // Tile Layer.
                                TileLayer(
                                  urlTemplate:
                                      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                                  tileProvider: CancellableNetworkTileProvider(
                                    silenceExceptions: true,
                                  ),
                                ),

                                Visibility(
                                  visible: controller.routeToTPA.value,
                                  child: PolylineLayer(
                                    polylines: [
                                      Polyline(
                                        points: controller.points,
                                        strokeWidth: 5.0,
                                        color: Colors.cyan,
                                      ),
                                    ],
                                  ),
                                ),

                                controller.routeToTPA.value
                                    ? MarkerLayer(markers: [
                                        Marker(
                                          width: 40.0,
                                          height: 40.0,
                                          point: controller.tpaLocation.value!,
                                          child: AppIcon.custom(
                                            appIconName:
                                                AppIconName.tpaPinlocation,
                                            context: Get.context!,
                                          ),
                                        ),
                                        Marker(
                                          width: 40.0,
                                          height: 40.0,
                                          point: controller.selectedMarkerDetail
                                              .value!.geom!,
                                          child: AppIcon.custom(
                                            appIconName: controller
                                                    .selectedMarkerDetail
                                                    .value!
                                                    .isWastePile!
                                                ? AppIconName.pilePinlocation
                                                : AppIconName.pcsPinlocation,
                                            context: Get.context!,
                                          ),
                                        ),
                                      ])
                                    : Container(),

                                Visibility(
                                  visible: !controller.routeToTPA.value,
                                  child: Obx(
                                    () {
                                      if (controller.mapsMode.value ==
                                          'heatmap') {
                                        return controller
                                                .weightedLatLng.isNotEmpty
                                            ? HeatMapLayer(
                                                heatMapDataSource:
                                                    InMemoryHeatMapDataSource(
                                                  data: controller
                                                      .weightedLatLng
                                                      .toList(),
                                                ),
                                                heatMapOptions: HeatMapOptions(
                                                  gradient: controller
                                                      .defaultGradient,
                                                  minOpacity: 0.1,
                                                ),
                                                reset: controller
                                                    .streamController
                                                    .value
                                                    .stream,
                                              )
                                            : Center(
                                                child:
                                                    AppText.labelSmallDefault(
                                                  AppLocalizations.of(context)!
                                                      .no_data_found,
                                                  color: color.textSecondary,
                                                  context: context,
                                                ),
                                              );
                                      } else if (controller.mapsMode.value ==
                                          'cluster') {
                                        return controller.markers.isNotEmpty
                                            ? SuperclusterLayer.mutable(
                                                initialMarkers:
                                                    controller.markers.toList(),
                                                controller: controller
                                                    .superclusterController
                                                    .value,
                                                clusterWidgetSize:
                                                    const Size(40, 40),
                                                indexBuilder:
                                                    IndexBuilders.rootIsolate,
                                                builder: (context,
                                                    position,
                                                    markerCount,
                                                    extraClusterData) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      color: controller
                                                          .interpolateColor(
                                                        markerCount / 20,
                                                        controller
                                                            .defaultGradient,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        markerCount.toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : Center(
                                                child:
                                                    AppText.labelSmallDefault(
                                                  AppLocalizations.of(context)!
                                                      .no_data_found,
                                                  color: color.textSecondary,
                                                  context: context,
                                                ),
                                              );
                                      } else if (controller.mapsMode.value ==
                                          'marker') {
                                        return controller.markers.isNotEmpty
                                            ? MarkerLayer(
                                                markers:
                                                    controller.markers.toList(),
                                              )
                                            : Center(
                                                child:
                                                    AppText.labelSmallDefault(
                                                  AppLocalizations.of(context)!
                                                      .no_data_found,
                                                  color: color.textSecondary,
                                                  context: context,
                                                ),
                                              );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                                // Map Compass.
                                const MapCompass.cupertino(
                                  hideIfRotatedNorth: true,
                                  padding: EdgeInsets.fromLTRB(32, 304, 35, 32),
                                ),
                                // Current Location Marker.
                                CurrentLocationLayer(
                                  alignPositionStream: controller
                                      .alignPositionStreamController
                                      .value
                                      .stream,
                                  alignPositionOnUpdate:
                                      controller.alignPositionOnUpdate.value,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 32,
                        right: 32,
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
                            }
                            if (controller.showTimeSeries.value == true ||
                                controller.showMapsType.value == true) {
                              controller.showTimeSeries.value = false;
                              controller.showMapsType.value = false;
                            }
                          },
                          context: context,
                        ),
                      ),
                      // WasteTypeFilterWidget.
                      const WasteTypeFilterWidget(),
                      // Timeseries Filter Button.
                      Positioned(
                        top: 100,
                        right: 32,
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
                          },
                          context: context,
                        ),
                      ),
                      // Timeseries Filter Widget.
                      const TimeSeriesFilterWidget(),
                      // Maps Type switcher button.
                      Positioned(
                        top: 168,
                        right: 32,
                        child: Obx(
                          () => CustomIconButton.activeBordered(
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
                        ),
                      ),
                      Obx(
                        () => Visibility(
                          visible: controller.showMapsType.value,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(32, 168, 100, 32),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: MapsTypeDialog(),
                            ),
                          ),
                        ),
                      ),

                      // Maps Type Dialog.
                      if (controller.showMapsType.value)
                        Positioned(
                          top: 168,
                          right: 100,
                          child: MapsTypeDialog(),
                        ),
                      // My Location Button.
                      Positioned(
                        top: 236,
                        right: 32,
                        child: CustomIconButton.primary(
                          iconSize: 24,
                          iconName: AppIconName.myLocation,
                          onTap: () {
                            setState(
                              () => controller.alignPositionOnUpdate.value =
                                  AlignOnUpdate.always,
                            );
                            controller.alignPositionStreamController.value
                                .add(18);
                          },
                          context: context,
                        ),
                      ),
                      _buildTimeseriesSlider(context, color),
                      // For mobile devices, show the Popup detail overlay.
                      if (isMobile)
                        Obx(() {
                          if (controller.selectedMarkerDetail.value != null) {
                            return Popup(
                                detail: controller.selectedMarkerDetail.value!);
                          }
                          return const SizedBox.shrink();
                        }),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Timeseries slider at the bottom of the map area.
  Widget _buildTimeseriesSlider(BuildContext context, AppColorsTheme color) {
    return Obx(
      () => Positioned(
        bottom: 32,
        left: 32,
        right: 32,
        child: Visibility(
          visible: controller.timeseriesData.isNotEmpty,
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
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextButton.primary(
                        text: AppLocalizations.of(context)!.reset,
                        onPressed: () {
                          controller.resetTimeSeries();
                        },
                        context: context,
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.togglePlayPause();
                        },
                        child: Icon(
                          controller.selectedDay.value ==
                                  controller.difference.value
                              ? Icons.restart_alt
                              : controller.isPlaying.value
                                  ? Icons.pause
                                  : Icons.play_arrow,
                        ),
                      ),
                      AppText.labelSmallEmphasis(
                        AppLocalizations.of(context)!
                            .day_count(controller.selectedDay.value),
                        color: color.textSecondary,
                        context: context,
                      ),
                    ],
                  ),
                ),
                Slider(
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 5),
                  child: Obx(
                    () => SizedBox(
                      height: 35,
                      child: ToggleButtons(
                        isSelected: [
                          !controller.switcher.value,
                          controller.switcher.value,
                        ],
                        onPressed: (int index) {
                          controller.switcher.value = index == 1;
                          controller.sliderChanged(
                              controller.selectedDay.value.toDouble());
                        },
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: AppText.labelTinyDefault(
                              AppLocalizations.of(context)!.daily_data,
                              color: color.textSecondary,
                              context: context,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: AppText.labelTinyDefault(
                              AppLocalizations.of(context)!.cumulative_data,
                              color: color.textSecondary,
                              context: context,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
