import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool> handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    showFailedSnackbar(
      AppLocalizations.of(Get.context!)!.location_services_disabled,
      AppLocalizations.of(Get.context!)!.please_enable_services,
    );
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showFailedSnackbar(
        AppLocalizations.of(Get.context!)!.location_permissions_denied,
        AppLocalizations.of(Get.context!)!.please_enable_permissions,
      );
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    showFailedSnackbar(
      AppLocalizations.of(Get.context!)!.location_permissions_denied_forever,
      AppLocalizations.of(Get.context!)!.cannot_request_permissions,
    );
    return false;
  }
  return true;
}

Future<String> getAddressFromLatLng(LatLng position) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
  } catch (e) {
    debugPrint(e.toString());
    throw Exception('Failed to get address from coordinates');
  }
}
