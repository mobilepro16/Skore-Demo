// Created by huynn109 on 2019-06-01.

import 'package:flutter_app_flavor/src/utils/string_utils.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

enum Flavor { STAGING, PRODUCTION }

class FlavorValues {
  FlavorValues({@required this.baseUrl, @required this.companyId});

  final String baseUrl;
  final String companyId;
//Add other flavor specific values, e.g database name
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final FlavorValues values;
  static FlavorConfig _instance;

  factory FlavorConfig(
      {@required Flavor flavor,
      String name,
      Color primaryColor: Colors.blue,
      Color accentColor: Colors.cyan,
      Color backgroundColor: Colors.white,
      @required FlavorValues values}) {
    _instance ??= FlavorConfig._internal(
        flavor,
        StringUtils.enumName(flavor.toString()),
        primaryColor,
        accentColor,
        backgroundColor,
        values);
    return _instance;
  }

  FlavorConfig._internal(
      this.flavor, this.name, this.primaryColor, this.accentColor, this.backgroundColor, this.values);

  static FlavorConfig get instance {
    return _instance;
  }

  static bool isProduction() => _instance.flavor == Flavor.PRODUCTION;

  static bool isStaging() => _instance.flavor == Flavor.STAGING;
}
