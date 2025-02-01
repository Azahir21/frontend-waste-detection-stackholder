import 'dart:convert';

import 'package:frontend_waste_management_stackholder/app/data/models/login_model.dart';
import 'package:frontend_waste_management_stackholder/app/data/services/api_service.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management_stackholder/core/values/const.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController
  String _email = '';
  String _password = '';
  get email => _email;
  get password => _password;
  set email(value) => _email = value;
  set password(value) => _password = value;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> login() async {
    try {
      final response = await ApiServices().post(
          UrlConstants.login,
          {
            'username': _email,
            'password': _password,
          },
          contentType: 'application/x-www-form-urlencoded');
      if (response.statusCode != 200) {
        // var message = await translate(jsonDecode(response.body)['detail']);
        var message = jsonDecode(response.body)['detail'];

        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.login_error, message);
        throw ('Login error: ${response.body}');
      }
      Login loginData = Login.fromRawJson(response.body);
      GetStorage().write('token', loginData.accessToken);
      GetStorage().write('username', loginData.username);
      GetStorage().write('role', loginData.role);
      Get.offAllNamed("/home");
    } catch (e) {
      print('Login error: $e');
    }
  }
}
