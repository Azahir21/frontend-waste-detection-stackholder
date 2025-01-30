import 'package:get/get.dart';
import 'package:flutter/material.dart';

void showSuccessSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: Colors.green[400],
    colorText: Colors.white,
  );
}

void showFailedSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: Colors.red[400],
    colorText: Colors.white,
  );
}
