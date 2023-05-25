// Created by huynn109 on 2019-06-02.

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_flavor/src/app.dart';
import 'package:flutter_app_flavor/src/base/bloc_delegate.dart';
import 'package:flutter_app_flavor/src/config/flavor_config.dart';
import 'package:flutter_app_flavor/src/repos/user/user_repository.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';

Future main() async {
  BlocSupervisor.delegate = AppBlocDelegate();
  FlavorConfig(
      flavor: Flavor.STAGING,
      primaryColor: Colors.white,
      accentColor: Colors.cyan[600],
      backgroundColor: Colors.cyan,
      values: FlavorValues(baseUrl: "https://customerb-staging.skore.io/", companyId: "5736"));
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  bool isInDebugMode = false;

  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
      Zone.current.handleUncaughtError(details.exception, details.stack);
    } else {
      // In production mode report to the application zone to report to
      // Crashlytics.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  await FlutterCrashlytics().initialize();

  runZoned<Future<Null>>(() async {
    runApp(App(userRepository: UserRepository()));
  }, onError: (error, stackTrace) async {
    // Whenever an error occurs, call the `reportCrash` function. This will send
    // Dart errors to our dev console or Crashlytics depending on the environment.
//    debugPrint(error.toString());
    await FlutterCrashlytics().reportCrash(error, stackTrace, forceCrash: false);
  });
//  runApp(App(userRepository: UserRepository()));
}


