import 'dart:convert';
import 'package:latlong2/latlong.dart';

class SampahDetail {
  int? id;
  bool? isWastePile;
  String? address;
  LatLng? geom;
  String? image;
  String? evidence;
  DateTime? captureTime;
  bool? isPickup;
  DateTime? pickupAt;
  String? pickupByUser;
  int? point;
  int? totalSampah;
  List<SampahItem>? sampahItems;
  List<CountedObject>? countedObjects;

  SampahDetail({
    this.id,
    this.isWastePile,
    this.address,
    this.geom,
    this.image,
    this.evidence,
    this.captureTime,
    this.isPickup,
    this.pickupAt,
    this.pickupByUser,
    this.point,
    this.totalSampah,
    this.sampahItems,
    this.countedObjects,
  });

  factory SampahDetail.fromRawJson(String str) =>
      SampahDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SampahDetail.fromJson(Map<String, dynamic> json) => SampahDetail(
        id: json["id"],
        isWastePile: json["is_waste_pile"],
        address: json["address"],
        geom: json["geom"] == null ? null : _parseWktToLatLng(json["geom"]),
        image: json["image"],
        evidence: json["evidence"],
        captureTime: json["captureTime"] == null
            ? null
            : DateTime.parse(json["captureTime"]),
        isPickup: json["is_pickup"],
        pickupAt:
            json["pickupAt"] == null ? null : DateTime.parse(json["pickupAt"]),
        pickupByUser: json["pickup_by_user"],
        point: json["point"],
        totalSampah: json["total_sampah"],
        sampahItems: json["sampah_items"] == null
            ? []
            : List<SampahItem>.from(
                json["sampah_items"]!.map((x) => SampahItem.fromJson(x))),
        countedObjects: json["count_items"] == null
            ? []
            : List<CountedObject>.from(
                json["count_items"]!.map((x) => CountedObject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "geom": geom == null
            ? null
            : 'POINT (${geom!.longitude} ${geom!.latitude})',
        "image": image,
        "evidence": evidence,
        "captureTime": captureTime?.toIso8601String(),
        "point": point,
        "total_sampah": totalSampah,
        "sampah_items": sampahItems == null
            ? []
            : List<dynamic>.from(sampahItems!.map((x) => x.toJson())),
        "count_items": countedObjects == null
            ? []
            : List<dynamic>.from(countedObjects!.map((x) => x.toJson())),
      };

  // Helper method to parse WKT to LatLng
  static LatLng _parseWktToLatLng(String wkt) {
    final pattern = RegExp(r'POINT\s*\(([-\d.]+)\s+([-\d.]+)\)');
    final match = pattern.firstMatch(wkt);
    if (match != null) {
      final lat = double.parse(match.group(2)!);
      final lng = double.parse(match.group(1)!);
      return LatLng(lat, lng);
    }
    throw FormatException('Invalid WKT format');
  }
}

class SampahItem {
  String? nama;
  int? point;

  SampahItem({
    this.nama,
    this.point,
  });

  factory SampahItem.fromRawJson(String str) =>
      SampahItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SampahItem.fromJson(Map<String, dynamic> json) => SampahItem(
        nama: json["nama"],
        point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "point": point,
      };
}

class CountedObject {
  String? name;
  int? count;
  int? point;

  CountedObject({
    this.name,
    this.count,
    this.point,
  });

  factory CountedObject.fromRawJson(String str) =>
      CountedObject.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CountedObject.fromJson(Map<String, dynamic> json) => CountedObject(
        name: json["name"],
        count: json["count"],
        point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "count": count,
        "point": point,
      };
}

List<SampahDetail> parseSampahDetail(String str) {
  final parsed = json.decode(str).cast<Map<String, dynamic>>();
  return parsed
      .map<SampahDetail>((json) => SampahDetail.fromJson(json))
      .toList();
}

SampahDetail parseSampahDetailSingle(String str) {
  return SampahDetail.fromJson(json.decode(str));
}
