import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TokenService {
  Future<bool> checkToken() async {
    OverlayLoadingProgress.stop();
    final token = GetStorage().read('token');
    if (token == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/login');
      });
      return false;
    }
    if (token != null && JwtDecoder.isExpired(token)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GetStorage().remove('token');
        showSuccessSnackbar(
          AppLocalizations.of(Get.context!)!.session_expired,
          AppLocalizations.of(Get.context!)!.please_login_again,
        );
        Get.offAllNamed('/login');
      });
      return false;
    }
    return true;
  }
}
