import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectionStatus = Connectivity();
  final RxBool isConnected = true.obs;
  final RxBool isSplashScreen = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectionStatus.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectionStatus.checkConnectivity();
    } catch (e) {
      print("Couldn't check connectivity status: $e");
      return;
    }
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.none:
        isConnected.value = false;
        if (!isSplashScreen.value) {
          _showNoInternetDialog();
        }
        break;
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        if (!isConnected.value) {
          isConnected.value = true;
          if (!isSplashScreen.value) {
            Get.back();
            _showConnectedSnackbar(
                result == ConnectivityResult.wifi ? "Wi-Fi" : "Mobile Data");
          }
        }
        break;
      default:
        break;
    }
  }

  void _showNoInternetDialog() {
    if (Get.isDialogOpen ?? false) return; // Prevent multiple dialogs

    Get.defaultDialog(
      title: "Network Problem",
      middleText: "Please check your connection",
      onWillPop: () async => false,
      titleStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: Colors.red,
      ),
      middleTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      barrierDismissible: false,
    );
  }

  void _showConnectedSnackbar(String connectionType) {
    showSuccessSnackbar(
      "Connected Successfully",
      "You are now connected to $connectionType",
    );
  }

  void setSplashScreenStatus(bool status) {
    isSplashScreen.value = status;
    if (!status && !isConnected.value) {
      _showNoInternetDialog();
    }
  }
}
