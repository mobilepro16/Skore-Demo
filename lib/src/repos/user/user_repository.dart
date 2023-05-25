// Created by huynn109 on 2019-06-04.

import 'dart:async';
import 'dart:convert';

import 'package:flutter_app_flavor/src/base/network/base_api.dart';
import 'package:flutter_app_flavor/src/base/network/endpoints.dart';
import 'package:flutter_app_flavor/src/data/request/login_request.dart';
import 'package:flutter_app_flavor/src/data/response/login_response.dart';
import 'package:flutter_app_flavor/src/utils/api_constants.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository extends BaseApi {
  Future<LoginResponse> authenticate({
    @required String username,
    @required String password,
    @required String companyId,
  }) async {
    final response = await makePostRequest(Endpoints.loginUrl(),
        jsonEncode(new LoginRequest(username, password, companyId)));
    return LoginResponse.fromJson(json.decode(response.body));
  }

  Future<void> deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(KEY_SHARE_REFERENCE_TOKEN, "");
    return;
  }

  Future<void> persistToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(KEY_SHARE_REFERENCE_TOKEN, token);
    return;
  }

  Future<bool> hasToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(KEY_SHARE_REFERENCE_TOKEN);
    return token != null && token.isNotEmpty;
  }
}
