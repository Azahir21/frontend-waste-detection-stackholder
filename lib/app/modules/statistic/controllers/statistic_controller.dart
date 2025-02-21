import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/data/models/data_statistics_model.dart';
import 'package:frontend_waste_management_stackholder/app/data/models/total_statistical_data.dart';
import 'package:frontend_waste_management_stackholder/app/data/services/api_service.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management_stackholder/core/values/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

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
  final sortBy = 'capture_time'.obs;
  final search = ''.obs;
  final ascending = true.obs;
  final columnIndex = 0.obs;
  final sortOrder = 'desc'.obs;

  @override
  void onInit() async {
    super.onInit();
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
      final queryString =
          "?data_type=${dataType.value}&status=${status.value}&sort_by=${sortBy.value}&sort_order=${sortOrder.value}&search=${search.value}&page=$page&page_size=$pageSize";

      final response =
          await ApiServices().get('${UrlConstants.dataStats}$queryString');

      if (response.statusCode != 200) {
        final message = jsonDecode(response.body)['detail'];
        showFailedSnackbar("Failed to load data statistics", message);
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
}
