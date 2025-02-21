import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/data/models/data_users_model.dart';
import 'package:frontend_waste_management_stackholder/app/data/services/api_service.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management_stackholder/core/values/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class UserManagementController extends GetxController {
  //TODO: Implement UserManagementController
  final isLoading = true.obs;
  final dataUsers = UsersData().obs;
  final currentPage = 1.obs;
  final totalPages = 0.obs;
  final pageSize = 10.obs;
  final totalDataCount = 0.obs;
  final sortBy = 'capture_time'.obs;
  final search = ''.obs;
  final ascending = true.obs;
  final columnIndex = 0.obs;
  final sortOrder = 'desc'.obs;
  String fullName = "";
  String gender = "";
  String username = "";
  String email = "";
  String password = "";
  final RxBool validPassword = true.obs;
  final massage = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchDataUser();
  }

  Future<void> fetchDataUser({int page = 1, int pageSize = 10}) async {
    isLoading.value = true;
    try {
      final queryString =
          "?sort_by=${sortBy.value}&sort_order=${sortOrder.value}&search=${search.value}&page=$page&page_size=$pageSize";
      final response =
          await ApiServices().get('${UrlConstants.dataUsers}$queryString');

      if (response.statusCode != 200) {
        final message = response.body.isNotEmpty
            ? jsonDecode(response.body)['detail']
            : 'Unknown error';
        showFailedSnackbar("Failed to load data statistics", message);
        throw ('Error: ${response.body}');
      }
      final data = UsersData.fromRawJson(response.body);
      dataUsers.value = data;
    } catch (e) {
      debugPrint('Error fetching dataStats: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeStatus(String id, String username) async {
    try {
      debugPrint('${UrlConstants.deactivateUser}?id=$id');
      final response = await ApiServices().put(
        '${UrlConstants.deactivateUser}?id=$id',
      );
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      if (response.statusCode != 200) {
        final message = jsonDecode(response.body)['detail'];
        showFailedSnackbar(
          "Failed to change status of $username",
          message,
        );
        throw ('Error: ${response.body}');
      }
      showSuccessSnackbar(
        "Success changing status of $username",
        "Status of $username has been changed",
      );
      fetchDataUser();
    } catch (e) {
      debugPrint('Error changing status: $e');
    }
  }

  Future<void> register() async {
    try {
      final response = await ApiServices().post(
        UrlConstants.register,
        {
          "fullName": fullName,
          "jenisKelamin": gender,
          "username": username,
          "email": email,
          "password": password,
        },
      );
      if (response.statusCode != 200) {
        // var message = await translate(jsonDecode(response.body)['detail']);
        var message = jsonDecode(response.body)['detail'];

        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.register_error, message);
        throw ('Registration error: ${response.body}');
      }
      showSuccessSnackbar(
        AppLocalizations.of(Get.context!)!.register_success,
        AppLocalizations.of(Get.context!)!.register_success_message,
      );
      Get.back();
    } catch (e) {
      print('Registration error: $e');
    }
  }

  bool validateEmail(String email) {
    if (!GetUtils.isEmail(email)) {
      showFailedSnackbar(AppLocalizations.of(Get.context!)!.attention,
          AppLocalizations.of(Get.context!)!.email_not_valid);
      return false;
    }
    return true;
  }

  void validatePassword(String password) {
    validPassword.value = true;
    if (password.length < 8) {
      massage.value =
          AppLocalizations.of(Get.context!)!.password_has_8_characters;
      validPassword.value = false;
      return;
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      massage.value = AppLocalizations.of(Get.context!)!.password_has_uppercase;
      validPassword.value = false;
      return;
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      massage.value = AppLocalizations.of(Get.context!)!.password_has_lowercase;
      validPassword.value = false;
      return;
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      massage.value = AppLocalizations.of(Get.context!)!.password_has_number;
      validPassword.value = false;
      return;
    }
    massage.value = "valid";
  }
}
