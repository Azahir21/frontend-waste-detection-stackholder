import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

String formatTanggal(String dateStr) {
  // Parsing string tanggal ke DateTime
  DateTime dateTime = DateTime.parse(dateStr);

  // Mendefinisikan hari dalam bahasa Indonesia
  final List<String> hari = [
    AppLocalizations.of(Get.context!)!.sunday,
    AppLocalizations.of(Get.context!)!.monday,
    AppLocalizations.of(Get.context!)!.tuesday,
    AppLocalizations.of(Get.context!)!.wednesday,
    AppLocalizations.of(Get.context!)!.thursday,
    AppLocalizations.of(Get.context!)!.friday,
    AppLocalizations.of(Get.context!)!.saturday
  ];

  // Mendefinisikan bulan dalam bahasa Indonesia
  final List<String> bulan = [
    AppLocalizations.of(Get.context!)!.january,
    AppLocalizations.of(Get.context!)!.february,
    AppLocalizations.of(Get.context!)!.march,
    AppLocalizations.of(Get.context!)!.april,
    AppLocalizations.of(Get.context!)!.may,
    AppLocalizations.of(Get.context!)!.june,
    AppLocalizations.of(Get.context!)!.july,
    AppLocalizations.of(Get.context!)!.august,
    AppLocalizations.of(Get.context!)!.september,
    AppLocalizations.of(Get.context!)!.october,
    AppLocalizations.of(Get.context!)!.november,
    AppLocalizations.of(Get.context!)!.december
  ];

  // Mendapatkan nama hari dan bulan
  String namaHari = hari[dateTime.weekday % 7];
  String namaBulan = bulan[dateTime.month - 1];

  // Membentuk string dengan format yang diinginkan
  String formattedDate =
      '$namaHari ${dateTime.day} $namaBulan ${dateTime.year}';

  return formattedDate;
}
