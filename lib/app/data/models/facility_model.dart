import 'dart:convert';

class Facility {
  String? name;
  String? latitude;
  String? longitude;
  String? iconUrl;
  String? facilityType;
  String? id;
  String? address;

  Facility({
    this.name,
    this.latitude,
    this.longitude,
    this.iconUrl,
    this.facilityType,
    this.id,
    this.address,
  });

  factory Facility.fromRawJson(String str) =>
      Facility.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Facility.fromJson(Map<String, dynamic> json) => Facility(
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        iconUrl: json["icon_url"],
        facilityType: json["facility_type"],
        id: json["id"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "icon_url": iconUrl,
        "facility_type": facilityType,
        "id": id,
        "address": address,
      };
}
