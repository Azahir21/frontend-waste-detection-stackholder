import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/data/models/data_statistics_model.dart';
import 'package:frontend_waste_management_stackholder/app/data/models/total_statistical_data.dart';
import 'package:frontend_waste_management_stackholder/app/data/services/api_service.dart';
import 'package:frontend_waste_management_stackholder/app/data/services/location_handler.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management_stackholder/core/values/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:universal_html/html.dart' as html;

class StatisticController extends GetxController {
  //TODO: Implement StatisticController
  final isLoading = true.obs;
  final totalStatisticalData = TotalStatisticalData().obs;
  final dataStatistics = DataStatistics().obs;
  final currentPage = 1.obs;
  final totalPages = 0.obs;
  final pageSize = 10.obs;
  final totalDataCount = 0.obs;
  final indexStartData = 1.obs;
  final indexEndData = 10.obs;
  final dataType = 'all'.obs;
  final status = 'all'.obs;
  String previousDataType = 'all';
  String previousStatus = 'all';
  final sortBy = 'capture_time'.obs;
  final search = ''.obs;
  final ascending = true.obs;
  final columnIndex = 0.obs;
  final sortOrder = 'desc'.obs;
  final RxBool showFilterBox = false.obs;
  final dataTypeDownload = 'all'.obs;
  final statusDownload = 'all'.obs;
  final searchDownload = ''.obs;
  String previousDataTypeDownload = 'all';
  String previousStatusDownload = 'all';
  final firstDate = DateTime.now().obs;
  final lastDate = DateTime.now().obs;
  final firstDateController = TextEditingController().obs;
  final lastDateController = TextEditingController().obs;
  final capturedImageUrl = ''.obs;
  final evidencePosition = LatLng(0, 0).obs;

  @override
  void onInit() async {
    super.onInit();
    final targetLocation = GetStorage().read('target_location');
    if (targetLocation != null && targetLocation.toString().isNotEmpty) {
      search.value = targetLocation.toString();
      searchDownload.value = targetLocation.toString();
    }
    await fetchTotalStatisticalData();
    await fetchDataStats();
  }

  Future<void> fetchTotalStatisticalData() async {
    isLoading.value = true;
    try {
      final response = await ApiServices().get(UrlConstants.totalStatsData);
      if (response.statusCode != 200) {
        final message = jsonDecode(response.body)['detail'];
        showFailedSnackbar(
          AppLocalizations.of(Get.context!)!
              .failed_to_load_total_statistics_data,
          message,
        );
        throw ('${AppLocalizations.of(Get.context!)!.statistic_error}: ${response.body}');
      }
      final data = TotalStatisticalData.fromRawJson(response.body);
      totalStatisticalData.value = data;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDataStats({int page = 1, int pageSize = 10}) async {
    isLoading.value = true;
    try {
      bool viewTargetLocationOnly =
          GetStorage().read('view_target_location_only') ?? false;
      final queryString =
          "?data_type=${dataType.value}&status=${status.value}&sort_by=${sortBy.value}&sort_order=${sortOrder.value}&search=${search.value}&page=$page&page_size=$pageSize&target_location=${viewTargetLocationOnly ? GetStorage().read('target_location') : ''}";

      final response =
          await ApiServices().get('${UrlConstants.dataStats}$queryString');

      if (response.statusCode != 200) {
        final message = jsonDecode(response.body)['detail'];
        showFailedSnackbar(
          AppLocalizations.of(Get.context!)!.failed_to_load_data_statistics,
          message,
        );
        throw ('Error: ${response.body}');
      }
      final data = DataStatistics.fromRawJson(response.body);
      dataStatistics.value = data;
    } catch (e) {
      debugPrint('Error fetching dataStats: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markPickupSampah(int id, LatLng location) async {
    if (capturedImageUrl.value.isEmpty) {
      showFailedSnackbar(
        AppLocalizations.of(Get.context!)!.mark_pickup_error,
        AppLocalizations.of(Get.context!)!.capture_evidence_first,
      );
      capturedImageUrl.value = "";
      return;
    }

    try {
      // showFailedSnackbar(
      //   AppLocalizations.of(Get.context!)!.mark_pickup_error,
      //   "You are too far from the selected waste pile.",
      // );

      final response = await ApiServices().put(
        "${UrlConstants.sampah}/pickup/$id",
        {
          "image_base64": capturedImageUrl.value,
        },
      );

      if (response.statusCode != 200) {
        final message = jsonDecode(response.body)['detail'];
        showFailedSnackbar(
          AppLocalizations.of(Get.context!)!.mark_pickup_error,
          message,
        );
        capturedImageUrl.value = "";
        throw ('Mark pickup error: ${response.body}');
      }

      showSuccessSnackbar(
        AppLocalizations.of(Get.context!)!.mark_pickup_success,
        AppLocalizations.of(Get.context!)!.mark_pickup_success_message,
      );
      capturedImageUrl.value = "";

      await fetchTotalStatisticalData();
      await fetchDataStats(
        page: currentPage.value,
        pageSize: pageSize.value,
      );
    } catch (e) {
      debugPrint('${AppLocalizations.of(Get.context!)!.mark_pickup_error}: $e');
    }
  }

  void resetDownloadFilter() {
    dataTypeDownload.value = 'all';
    statusDownload.value = 'all';
    searchDownload.value = GetStorage().read('target_location') ?? '';
    firstDate.value = DateTime.now();
    lastDate.value = DateTime.now();
    firstDateController.value.text = '';
    lastDateController.value.text = '';
  }

  Future<void> downloadStatisticsExcel() async {
    try {
      // Initialize searchDownload with target_location if it exists and searchDownload is empty
      final targetLocation = GetStorage().read('target_location');
      if (targetLocation != null &&
          targetLocation.toString().isNotEmpty &&
          searchDownload.value.isEmpty) {
        searchDownload.value = targetLocation.toString();
      }

      bool viewTargetLocationOnly =
          GetStorage().read('view_target_location_only') ?? false;

      final queryParameters = {
        'data_type': dataTypeDownload.value,
        'status': statusDownload.value,
        'search': searchDownload.value,
        'target_location': viewTargetLocationOnly && targetLocation != null
            ? targetLocation.toString()
            : '',
      };

      if (firstDateController.value.text.isNotEmpty) {
        queryParameters['start_date'] = firstDate.value.toString();
      }

      if (lastDateController.value.text.isNotEmpty) {
        queryParameters['end_date'] = lastDate.value.toString();
      }

      final Uri url = Uri.parse(
              'https://backend.laraan.id/api/v1/stackholder/data_statistic_sheet')
          .replace(queryParameters: queryParameters);

      // 2. Make API request with authentication
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${GetStorage().read('token')}',
          'Accept':
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        },
      );

      if (response.statusCode == 200) {
        // 3. Create a blob from response
        final blob = html.Blob([response.bodyBytes]);

        // 4. Create download URL
        final url = html.Url.createObjectUrlFromBlob(blob);

        // 5. Create filename from headers or use default
        String filename = 'statistics_report_${DateTime.now()}.xlsx';
        if (response.headers['content-disposition'] != null) {
          final contentDisposition = response.headers['content-disposition']!;
          final filenameMatch =
              RegExp(r'filename=([^;]+)').firstMatch(contentDisposition);
          if (filenameMatch != null) {
            filename = filenameMatch.group(1) ?? filename;
          }
        }

        // 6. Create anchor element and trigger download
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', filename)
          ..style.display = 'none';

        html.document.body!.children.add(anchor);
        anchor.click();

        // 7. Clean up
        html.document.body!.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
      } else {
        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.failed_to_download_file,
            response.body);
        throw Exception('Failed to download file: ${response.body}');
      }
    } catch (e) {
      print('Error downloading file: $e');
      rethrow;
    }
  }
}
