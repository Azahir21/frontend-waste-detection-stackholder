import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

void showSuccessSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    maxWidth: 600,
    backgroundColor: Theme.of(Get.context!).appColors.snackbarSuccess,
    colorText: Colors.white,
  );
}

void showFailedSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    maxWidth: 600,
    backgroundColor: Theme.of(Get.context!).appColors.snackbarError,
    colorText: Colors.white,
  );
}
