// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return LoginResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      preferences: json['preferences'] == null
          ? null
          : Preferences.fromJson(json['preferences'] as Map<String, dynamic>),
      role: json['role'] as String,
      companyId: json['company_id'] as int,
      teams: (json['teams'] as List)?.map((e) => e as String)?.toList(),
      name: json['name'] as String,
      createdAt: json['created_at'] as String,
      id: json['id'] as int,
      avatar: json['avatar'] as String,
      email: json['email'] as String,
      isLeader: json['isLeader'] as bool,
      token: json['token'] as String,
      tokenRefresh: json['token_refresh'] as String,
      tokenExpirationDate: json['token_expiration_date'] as int);
}

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'preferences': instance.preferences,
      'role': instance.role,
      'company_id': instance.companyId,
      'teams': instance.teams,
      'name': instance.name,
      'created_at': instance.createdAt,
      'id': instance.id,
      'avatar': instance.avatar,
      'email': instance.email,
      'isLeader': instance.isLeader,
      'token': instance.token,
      'token_refresh': instance.tokenRefresh,
      'token_expiration_date': instance.tokenExpirationDate
    };

Preferences _$PreferencesFromJson(Map<String, dynamic> json) {
  return Preferences();
}

Map<String, dynamic> _$PreferencesToJson(Preferences instance) =>
    <String, dynamic>{};
