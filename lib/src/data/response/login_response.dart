// Created by huynn109 on 2019-06-04.

import 'package:flutter_app_flavor/src/utils/api_constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  int status = SUCCESS;
  String message;
  Preferences preferences;
  String role;
  @JsonKey(name: "company_id")
  int companyId;
  List<String> teams;
  String name;
  @JsonKey(name: "created_at")
  String createdAt;
  int id;
  String avatar;
  String email;
  bool isLeader;
  String token;
  @JsonKey(name: "token_refresh")
  String tokenRefresh;
  @JsonKey(name: "token_expiration_date")
  int tokenExpirationDate;

  LoginResponse(
      {this.status,
      this.message,
      this.preferences,
      this.role,
      this.companyId,
      this.teams,
      this.name,
      this.createdAt,
      this.id,
      this.avatar,
      this.email,
      this.isLeader,
      this.token,
      this.tokenRefresh,
      this.tokenExpirationDate});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class Preferences {
  Preferences();

  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$PreferencesToJson(this);
}
