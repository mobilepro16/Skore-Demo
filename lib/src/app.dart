import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_flavor/src/app/authentication/authentication.dart';
import 'package:flutter_app_flavor/src/app/common/common.dart';
import 'package:flutter_app_flavor/src/app/home/home.dart';
import 'package:flutter_app_flavor/src/app/login/login.dart';
import 'package:flutter_app_flavor/src/app/splash/splash.dart';
import 'package:flutter_app_flavor/src/config/flavor_banner.dart';
import 'package:flutter_app_flavor/src/config/flavor_config.dart';
import 'package:flutter_app_flavor/src/repos/user/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationBloc _authenticationBloc;
  FirebaseMessaging _fireBaseMessaging = FirebaseMessaging();
  UserRepository get _userRepository => widget.userRepository;

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.dispatch(AppStarted());
    super.initState();
    _retrieveDynamicLink();
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var config = FlavorConfig.instance;
    return BlocProvider<AuthenticationBloc>(
      bloc: _authenticationBloc,
      child: MaterialApp(
        title: config.name,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: config.primaryColor,
          accentColor: config.accentColor,
        ),
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationUninitialized) {
              return FlavorBanner(child: SplashPage());
            }
            if (state is AuthenticationAuthenticated) {
              return FlavorBanner(child: HomePage());
            }
            if (state is AuthenticationUnauthenticated) {
              return FlavorBanner(
                child: LoginPage(userRepository: _userRepository),
              );
            }
            if (state is AuthenticationLoading) {
              return LoadingIndicator();
            }
          },
        ),
      ),
    );
  }

  Future<void> _retrieveDynamicLink() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.retrieveDynamicLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print(deepLink.path);
      Navigator.pushNamed(context, deepLink.path);
    }
  }

  void fireBaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();
    _fireBaseMessaging.getToken().then((token) {
      print(token);
    });

    _fireBaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        Firestore.instance.collection("notifications").document().setData({
          'title': '${message['notification']['title']} onMessage',
          'body': '${message['notification']['body']} onMessage'
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        Firestore.instance.collection("notifications").document().setData({
          'title': '${message['notification']['title']} onLaunch',
          'body': '${message['notification']['body']} onLaunch'
        });
      },
    );
  }

  void iOSPermission() {
    _fireBaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _fireBaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}

