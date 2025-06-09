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
  String targetLocation = "";
  final RxBool viewTargetLocationOnly = false.obs;
  final RxBool validPassword = true.obs;
  final massage = "".obs;
  final RxBool isEditMode = false.obs;
  String editUserId = "";

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
        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.failed_load_user, message);
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
          AppLocalizations.of(Get.context!)!.failed_change_status(username),
          message,
        );
        throw ('Error: ${response.body}');
      }
      showSuccessSnackbar(
          AppLocalizations.of(Get.context!)!.success_change_status(username),
          AppLocalizations.of(Get.context!)!.status_changed(
            username,
          ));
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
          "targetLocation": targetLocation.isEmpty ? null : targetLocation,
          "viewTargetLocationOnly": viewTargetLocationOnly.value,
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
      resetForm();
      fetchDataUser();
      Get.back();
    } catch (e) {
      print('Registration error: $e');
    }
  }

  Future<void> updateUser() async {
    try {
      final requestBody = {
        "fullName": fullName,
        "jenisKelamin": gender,
        "username": username,
        "email": email,
        "password": password.isEmpty ? null : password,
        "targetLocation": targetLocation.isEmpty ? null : targetLocation,
        "viewTargetLocationOnly": viewTargetLocationOnly.value,
      };

      debugPrint('Update request body: $requestBody');

      final response = await ApiServices().put(
        '${UrlConstants.updateUser}?id=$editUserId',
        requestBody,
      );

      if (response.statusCode != 200) {
        // Handle different error response formats
        String message;
        try {
          final responseData = jsonDecode(response.body);
          if (responseData is Map) {
            if (responseData.containsKey('detail')) {
              final detail = responseData['detail'];
              if (detail is List && detail.isNotEmpty) {
                // Handle validation errors array
                message = detail
                    .map((error) => error['msg'] ?? error.toString())
                    .join(', ');
              } else {
                message = detail.toString();
              }
            } else if (responseData.containsKey('msg')) {
              message = responseData['msg'].toString();
            } else {
              message = 'Update failed';
            }
          } else {
            message = responseData.toString();
          }
        } catch (e) {
          message = 'Update failed: ${response.body}';
        }

        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.update_error, message);
        throw ('Update error: ${response.body}');
      }

      showSuccessSnackbar(
        AppLocalizations.of(Get.context!)!.update_success,
        AppLocalizations.of(Get.context!)!.update_success_message,
      );

      resetForm();
      fetchDataUser();
    } catch (e) {
      debugPrint('Update error: $e');
    }
  }

  void prepareForEdit(User user) {
    isEditMode.value = true;
    editUserId = user.id.toString();
    fullName = user.fullName ?? "";
    gender = user.gender ?? "";
    username = user.username ?? "";
    email = user.email ?? "";
    password = ""; // Don't pre-fill password for security
    targetLocation = user.targetLocation ?? "";
    viewTargetLocationOnly.value = user.viewTargetLocationOnly?.value ?? false;
  }

  void prepareForAdd() {
    isEditMode.value = false;
    editUserId = "";
    resetForm();
  }

  void resetForm() {
    fullName = "";
    gender = "";
    username = "";
    email = "";
    password = "";
    targetLocation = "";
    viewTargetLocationOnly.value = false;
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
