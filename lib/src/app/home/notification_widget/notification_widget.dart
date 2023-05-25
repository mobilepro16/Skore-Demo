import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationWidget extends StatefulWidget {
  NotificationWidget({Key key}) : super(key: key);

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  FirebaseMessaging _fireBaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    fireBaseCloudMessagingListeners();
  }

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('notifications').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  leading: Icon(Icons.notifications),
                  title: new Text(document['title']),
                  subtitle: new Text(document['body']),
                );
              }).toList(),
            );
        }
      },
    );
  }
  void fireBaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();
    _fireBaseMessaging.getToken().then((token) {
      print(token);
    });

    _fireBaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage');
        print('onMessage ${message['notification']['title']}');
        print('onMessage ${message['notification']['body']}');
        Firestore.instance.collection("notifications").document().setData({
          'title': message['notification']['title'],
          'body': message['notification']['body']
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
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

class NotificationData {
  final String title;
  final String body;

  NotificationData(this.title, this.body);
}
