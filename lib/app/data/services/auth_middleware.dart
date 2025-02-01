import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final token = GetStorage().read('token');
    if (token == null) {
      return const RouteSettings(name: '/login');
    }
    if (token != null && JwtDecoder.isExpired(token)) {
      GetStorage().remove('token');
      return const RouteSettings(name: '/login');
    }
    return null;
  }
}
