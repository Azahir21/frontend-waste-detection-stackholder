import 'dart:convert';

import 'package:get/get.dart';

class UsersData {
  List<User>? users;
  int? totalCount;
  int? page;
  int? pageSize;
  int? totalPages;

  UsersData({
    this.users,
    this.totalCount,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  factory UsersData.fromRawJson(String str) =>
      UsersData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UsersData.fromJson(Map<String, dynamic> json) => UsersData(
        users: json["users"] == null
            ? []
            : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
        totalCount: json["total_count"],
        page: json["page"],
        pageSize: json["page_size"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
        "total_count": totalCount,
        "page": page,
        "page_size": pageSize,
        "total_pages": totalPages,
      };
}

class User {
  int? id;
  String? fullName;
  String? gender;
  String? username;
  String? email;
  String? role;
  RxBool? status;

  User({
    this.id,
    this.fullName,
    this.gender,
    this.username,
    this.email,
    this.role,
    this.status,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["full_name"],
        gender: json["gender"]!,
        username: json["username"],
        email: json["email"],
        role: json["role"]!,
        status: json["status"] == null ? null : RxBool(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "gender": gender,
        "username": username,
        "email": email,
        "role": role,
        "status": status?.value,
      };
}
