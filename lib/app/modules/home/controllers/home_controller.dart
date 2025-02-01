import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:frontend_waste_management_stackholder/app/data/models/sampah_detail_model.dart';
import 'package:frontend_waste_management_stackholder/app/data/services/api_service.dart';
import 'package:frontend_waste_management_stackholder/app/data/services/token_chacker.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_icon.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';
import 'package:frontend_waste_management_stackholder/core/values/const.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final isLoading = false.obs;
  final isHeatmap = false.obs;
  final curruntPosition = const LatLng(0, 0).obs;
  final sampahsData = <SampahDetail>[].obs;
  final alignPositionOnUpdate = AlignOnUpdate.always.obs;
  final alignPositionStreamController = StreamController<double?>().obs;
  final streamController = StreamController().obs;
  final markers = <Marker>[].obs;
  final weightedLatLng = <WeightedLatLng>[].obs;
  final firstDate = DateTime.now().obs;
  final lastDate = DateTime.now().obs;
  final firstDateController = TextEditingController().obs;
  final lastDateController = TextEditingController().obs;
  final timeseriesData = <SampahDetail>[].obs;
  final RxInt difference = 1.obs;
  final _tokenService = TokenService();
  final selectedDay = 1.obs;
  final switcher = false.obs;
  late final Rx<SuperclusterMutableController> superclusterController;
  final selectedMarkerDetail = Rx<SampahDetail?>(null);
  final isPlaying = false.obs;
  Timer? _sliderTimer;

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    superclusterController = SuperclusterMutableController().obs;
    alignPositionOnUpdate.value = AlignOnUpdate.always;
    alignPositionStreamController.value = StreamController<double?>();
    streamController.value = StreamController.broadcast();
    firstDateController.value.text = "";
    lastDateController.value.text = "";
    await getAllSampah();
    isLoading.value = false;
  }

  @override
  void onClose() {
    alignPositionStreamController.value.close();
    streamController.value.close();
    superclusterController.value.dispose();
    super.onClose();
  }

  Future<void> getAllSampah() async {
    if (!await _tokenService.checkToken()) {
      return;
    }
    try {
      final response = await ApiServices().get(UrlConstants.sampah);
      if (response.statusCode != 200) {
        // var message = await translate(jsonDecode(response.body)['detail']);
        var message = jsonDecode(response.body)['detail'];

        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.waste_data_error, message);
        throw ('Sampah error: ${response.body}');
      }
      sampahsData.value = parseSampahDetail(response.body);
      weightedLatLng.value = sampahsData
          .map(
            (e) => WeightedLatLng(
              e.geom!,
              e.totalSampah!.toDouble(),
            ),
          )
          .toList();
      markers.value = sampahsData
          .map(
            (e) => Marker(
              width: 40.0,
              height: 40.0,
              point: e.geom!,
              rotate: true,
              child: GestureDetector(
                  onTap: () {
                    selectedMarkerDetail.value = e;
                  },
                  child: e.isWastePile!
                      ? AppIcon.custom(
                          appIconName: AppIconName.pilePinlocation,
                          context: Get.context!)
                      : AppIcon.custom(
                          appIconName: AppIconName.pcsPinlocation,
                          context: Get.context!)),
            ),
          )
          .toList();
    } catch (e) {
      debugPrint('${AppLocalizations.of(Get.context!)!.waste_data_error}: $e');
    }
  }

  Future<void> getTimeseriesData() async {
    try {
      if (!await _tokenService.checkToken()) {
        return;
      }
      alignPositionOnUpdate.value = AlignOnUpdate.always;
      alignPositionStreamController.value = StreamController<double?>();
      isLoading.value = true;

      final response = await ApiServices().get(
          "${UrlConstants.sampah}/timeseries?start_date=${firstDate.value.toIso8601String()}&end_date=${lastDate.value.toIso8601String()}");

      if (response.statusCode != 200) {
        var message = jsonDecode(response.body)['detail'];
        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.waste_time_series_error,
            message);
        throw ('Timeseries error: ${response.body}');
      }

      timeseriesData.value = parseSampahDetail(response.body);

      if (timeseriesData.isEmpty) {
        showFailedSnackbar(
          AppLocalizations.of(Get.context!)!.no_data,
          AppLocalizations.of(Get.context!)!.show_previous_data,
        );
      } else {
        difference.value =
            lastDate.value.difference(firstDate.value).inDays + 1;
        weightedLatLng.value = timeseriesData
            .map(
              (e) => WeightedLatLng(
                e.geom!,
                e.totalSampah!.toDouble(),
              ),
            )
            .toList();
        markers.value = timeseriesData
            .map(
              (e) => Marker(
                width: 40.0,
                height: 40.0,
                point: e.geom!,
                rotate: true,
                child: GestureDetector(
                  onTap: () {
                    selectedMarkerDetail.value = e;
                  },
                  child: e.isWastePile!
                      ? AppIcon.custom(
                          appIconName: AppIconName.pilePinlocation,
                          context: Get.context!)
                      : AppIcon.custom(
                          appIconName: AppIconName.pcsPinlocation,
                          context: Get.context!),
                ),
              ),
            )
            .toList();
        sliderChanged(1);
      }

      isLoading.value = false;
    } catch (e) {
      debugPrint(
          '${AppLocalizations.of(Get.context!)!.waste_time_series_error}: $e');
    }
  }

  void resetTimeSeries() {
    firstDateController.value.text = "";
    lastDateController.value.text = "";
    selectedDay.value = 1;
    difference.value = 1;
    timeseriesData.clear();
    getAllSampah();
    showSuccessSnackbar(
      "Time Series Reset",
      "All data is now displayed without any date filter.",
    );
    superclusterController.value.replaceAll(markers.value);
  }

  void sliderChanged(double value) {
    selectedDay.value = value.toInt(); // Update selected day

    if (switcher.value) {
      // Cumulative Data Mode
      // Accumulate data from Day 1 to the selected day
      final cumulativeWeightedLatLng = timeseriesData
          .where((element) =>
              element.captureTime!.difference(firstDate.value).inDays <=
              selectedDay.value - 1)
          .map((e) => WeightedLatLng(e.geom!, e.totalSampah!.toDouble()))
          .toList();

      final cumulativeMarkers = timeseriesData
          .where((element) =>
              element.captureTime!.difference(firstDate.value).inDays <=
              selectedDay.value - 1)
          .map((e) => Marker(
                width: 40.0,
                height: 40.0,
                point: e.geom!,
                rotate: true,
                child: GestureDetector(
                  onTap: () {
                    selectedMarkerDetail.value = e;
                  },
                  child: e.isWastePile!
                      ? AppIcon.custom(
                          appIconName: AppIconName.pilePinlocation,
                          context: Get.context!)
                      : AppIcon.custom(
                          appIconName: AppIconName.pcsPinlocation,
                          context: Get.context!),
                ),
              ))
          .toList();

      // Update cumulative data
      weightedLatLng.value = [...cumulativeWeightedLatLng];
      markers.value = [...cumulativeMarkers];
    } else {
      // Daily Data Mode
      // Clear and show only data for the selected day
      final dailyWeightedLatLng = timeseriesData
          .where((element) =>
              element.captureTime!.difference(firstDate.value).inDays ==
              selectedDay.value - 1)
          .map((e) => WeightedLatLng(e.geom!, e.totalSampah!.toDouble()))
          .toList();

      final dailyMarkers = timeseriesData
          .where((element) =>
              element.captureTime!.difference(firstDate.value).inDays ==
              selectedDay.value - 1)
          .map(
            (e) => Marker(
              width: 40.0,
              height: 40.0,
              point: e.geom!,
              rotate: true,
              child: GestureDetector(
                  onTap: () {
                    selectedMarkerDetail.value = e;
                  },
                  child: e.isWastePile!
                      ? AppIcon.custom(
                          appIconName: AppIconName.pilePinlocation,
                          context: Get.context!)
                      : AppIcon.custom(
                          appIconName: AppIconName.pcsPinlocation,
                          context: Get.context!)),
            ),
          )
          .toList();

      // Update daily data
      weightedLatLng.value = [...dailyWeightedLatLng];
      markers.value = [...dailyMarkers];
    }

    weightedLatLng.refresh();
    markers.refresh();
    superclusterController.value.replaceAll(markers.value);
    streamController.value.add(null);
  }

  Color interpolateColor(double value, Map<double, Color> gradient) {
    List<double> keys = gradient.keys.toList()..sort();
    for (int i = 0; i < keys.length - 1; i++) {
      double lower = keys[i];
      double upper = keys[i + 1];
      if (value <= upper) {
        double range = upper - lower;
        double rangeRatio = (value - lower) / range;
        Color lowerColor = gradient[lower]!;
        Color upperColor = gradient[upper]!;
        return Color.lerp(lowerColor, upperColor, rangeRatio)!;
      }
    }
    return gradient[keys.last]!;
  }

  Map<double, Color> defaultGradient = {
    0.25: Colors.blue,
    0.55: Colors.green,
    0.85: Colors.yellow,
    1.0: Colors.red,
  };

  void playSlider() {
    // Start or resume the timer
    isPlaying.value = true;
    _sliderTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (selectedDay.value < difference.value) {
        selectedDay.value++; // Move to the next day
        sliderChanged(selectedDay.value.toDouble());
      } else {
        stopSlider(); // Stop when we reach the last day
      }
    });
  }

  void stopSlider() {
    // Stop the timer
    _sliderTimer?.cancel();
    isPlaying.value = false;
  }

  void restartSlider() {
    // Reset the slider to the first day and restart playback
    selectedDay.value = 1;
    sliderChanged(selectedDay.value.toDouble());
    playSlider(); // Start playing again from day 1
  }

  void togglePlayPause() {
    if (selectedDay.value == difference.value) {
      // If slider is at the end, restart from the beginning
      restartSlider();
    } else if (isPlaying.value) {
      // Pause the slider if it is playing
      stopSlider();
    } else {
      // Play the slider if it is paused
      playSlider();
    }
  }
}
