// Created by huynn109 on 2019-06-01.

import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_flavor/src/app.dart';
import 'package:flutter_app_flavor/src/base/bloc_delegate.dart';
import 'package:flutter_app_flavor/src/config/flavor_config.dart';
import 'package:flutter_app_flavor/src/repos/user/user_repository.dart';

void main() {
  BlocSupervisor.delegate = AppBlocDelegate();
  FlavorConfig(
      flavor: Flavor.PRODUCTION,
      primaryColor: Colors.white,
      accentColor: Colors.redAccent,
      backgroundColor: Colors.red,
      values: FlavorValues(baseUrl: "https://customera.skore.io/", companyId: "5735"));
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors to Crashlytics.
  FlutterError.onError = (FlutterErrorDetails details) {
    Crashlytics.instance.onError(details);
  };
//  runApp(App(userRepository: UserRepository()));
  runApp(new MaterialApp(
    routes: <String, WidgetBuilder>{
      '/': (BuildContext context) => new App(userRepository: new UserRepository())
    },
  ));

}
