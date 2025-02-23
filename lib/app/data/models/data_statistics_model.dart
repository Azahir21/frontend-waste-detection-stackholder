import 'dart:convert';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class DataStatistics {
  List<DataStatistic>? data;
  int? totalCount;
  int? page;
  int? pageSize;
  int? totalPages;

  DataStatistics({
    this.data,
    this.totalCount,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  factory DataStatistics.fromRawJson(String str) =>
      DataStatistics.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataStatistics.fromJson(Map<String, dynamic> json) => DataStatistics(
        data: json["data"] == null
            ? []
            : List<DataStatistic>.from(
                json["data"]!.map((x) => DataStatistic.fromJson(x))),
        totalCount: json["total_count"],
        page: json["page"],
        pageSize: json["page_size"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_count": totalCount,
        "page": page,
        "page_size": pageSize,
        "total_pages": totalPages,
      };
}

class DataStatistic {
  int? id;
  bool? isWastePile;
  String? address;
  LatLng? geom;
  dynamic pickupAt;
  DateTime? captureTime;
  int? wasteCount;
  dynamic pickupByUser;
  RxBool? pickupStatus;
  String? imageUrl;

  DataStatistic({
    this.id,
    this.isWastePile,
    this.address,
    this.geom,
    this.pickupAt,
    this.captureTime,
    this.wasteCount,
    this.pickupByUser,
    this.pickupStatus,
    this.imageUrl,
  });

  factory DataStatistic.fromRawJson(String str) =>
      DataStatistic.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataStatistic.fromJson(Map<String, dynamic> json) => DataStatistic(
        id: json["id"],
        isWastePile: json["is_waste_pile"],
        address: json["address"],
        geom: json["geom"] == null ? null : _parseLatLng(json["geom"]),
        pickupAt: json["pickup_at"],
        captureTime: json["capture_time"] == null
            ? null
            : DateTime.parse(json["capture_time"]),
        wasteCount: json["waste_count"],
        pickupByUser: json["pickup_by_user"],
        pickupStatus: json["pickup_status"] == null
            ? null
            : RxBool(json["pickup_status"]),
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_waste_pile": isWastePile,
        "address": address,
        "geom": geom == null ? null : _latLngToWkt(geom!),
        "pickup_at": pickupAt,
        "capture_time": captureTime?.toIso8601String(),
        "waste_count": wasteCount,
        "pickup_by_user": pickupByUser,
        "pickup_status": pickupStatus!.value,
        "image_url": imageUrl,
      };

  // Helper method to convert a WKT POINT string to a LatLng object.
  static LatLng _parseLatLng(String wkt) {
    // Expected format: "POINT (112.7930704 -7.2773463)"
    final pattern = RegExp(r'POINT\s*\(\s*([-\d.]+)\s+([-\d.]+)\s*\)');
    final match = pattern.firstMatch(wkt);
    if (match != null && match.groupCount == 2) {
      // In WKT, the first number is longitude and the second is latitude.
      final longitude = double.parse(match.group(1)!);
      final latitude = double.parse(match.group(2)!);
      return LatLng(latitude, longitude);
    }
    throw FormatException('Invalid WKT format for LatLng: $wkt');
  }

  // Helper method to convert a LatLng object back to a WKT POINT string.
  static String _latLngToWkt(LatLng latLng) {
    return 'POINT (${latLng.longitude} ${latLng.latitude})';
  }
}
