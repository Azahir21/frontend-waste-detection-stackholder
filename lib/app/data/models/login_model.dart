import 'dart:convert';

class Login {
  String? accessToken;
  String? tokenType;
  String? username;
  String? role;
  String? targetLocation;
  bool? viewTargetLocationOnly;

  Login({
    this.accessToken,
    this.tokenType,
    this.username,
    this.role,
    this.targetLocation,
    this.viewTargetLocationOnly,
  });

  factory Login.fromRawJson(String str) => Login.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        username: json["username"],
        role: json["role"],
        targetLocation: json["target_location"],
        viewTargetLocationOnly: json["view_target_location_only"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "username": username,
        "role": role,
        "target_location": targetLocation,
        "view_target_location_only": viewTargetLocationOnly,
      };
}
