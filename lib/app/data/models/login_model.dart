import 'dart:convert';

class Login {
  String? accessToken;
  String? tokenType;
  String? username;
  String? role;
  String? targetLocation;

  Login({
    this.accessToken,
    this.tokenType,
    this.username,
    this.role,
    this.targetLocation,
  });

  factory Login.fromRawJson(String str) => Login.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        username: json["username"],
        role: json["role"],
        targetLocation: json["target_location"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "username": username,
        "role": role,
        "target_location": targetLocation,
      };
}
