import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_flavor/src/config/flavor_config.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:flutter_offline/flutter_offline.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final FlavorConfig _flavorConfig = FlavorConfig.instance;
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ListTile(
                title: Text("Click me"),
                subtitle: OutlineButton(
                  child: Text(
                    "Button",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  textColor: _flavorConfig.accentColor,
                  highlightedBorderColor: _flavorConfig.accentColor,
                  padding: EdgeInsets.all(8.0),
                  onPressed: () {
//                    showStatus(); // Show status online/offline
                    createRecordEvent(); // Call record event button click
                    try {
                      final crash = List()[144];
                      debugPrint(crash);
                    } catch (error) {
                      debugPrint(error.toString());
                      FlutterCrashlytics().log('Crash report log',
                          priority: 200, tag: 'test crash report');
                      FlutterCrashlytics()
                          .logException(error, error.stackTrace);
                    }
                  },
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ListTile(
                title: new OutlineButton(
                  child: Text(
                    "Error",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  textColor: _flavorConfig.accentColor,
                  highlightedBorderColor: _flavorConfig.accentColor,
                  padding: EdgeInsets.all(8.0),
                  onPressed: () {
                    try {
                      final crash = List()[144]; // Crash test
                    } catch (error) {
                      debugPrint(error.toString());
                      FlutterCrashlytics().setUserInfo(
                          "huynn109",
                          "huynn109@gmail.com",
                          "huy"); // Set up information crash
                      FlutterCrashlytics().log('Crash report log');
                      FlutterCrashlytics().reportCrash(
                          'Crash report log onClickedButton $error', null,
                          forceCrash: false);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createRecordEvent() {
    FirebaseAnalytics firebaseAnalytics = new FirebaseAnalytics();
    String _setNameEvent = defaultTargetPlatform == TargetPlatform.iOS
        ? "ios"
        : "android"; // Platform check
    databaseReference.child("click_me_event").push().set(
        'clicked_$_setNameEvent - ${DateTime.now().toString()}'); // Push record on button clicked
    firebaseAnalytics.logEvent(
        // Custom log event
        name: "custom_event_button_clicked",
        parameters: {'onButtonClicked': 'clicked'});
  }

  void showStatus() {
    AchievementView(context,
        title: "Welcome!",
        subTitle: "You are online",
        icon: Icon(Icons.notifications),
        isCircle: false, listener: (status) {
      print(status);
    }, color: _flavorConfig.accentColor)
      ..show();
  }
}
