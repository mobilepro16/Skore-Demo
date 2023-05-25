// Created by huynn109 on 2019-06-04.

import 'dart:async';
import 'dart:io';

import 'package:flutter_app_flavor/src/utils/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseApi {
  Future<http.Response> makeGetRequest(String url) async {
    print("calling -> " + url);
    return await http.get(url);
  }

  Future<http.Response> makePostRequest(String url, dynamic data) async {
    print("calling -> " + url);
    print("request ->  " + data);
    return await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: data,
    );
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("token ->  " + prefs.getString(KEY_SHARE_REFERENCE_TOKEN));
    return prefs.getString(KEY_SHARE_REFERENCE_TOKEN);
  }
}
