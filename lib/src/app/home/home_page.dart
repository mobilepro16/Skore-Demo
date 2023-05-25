import 'package:flutter/material.dart';
import 'package:flutter_app_flavor/src/app/authentication/authentication.dart';
import 'package:flutter_app_flavor/src/app/authentication/authentication_bloc.dart';
import 'package:flutter_app_flavor/src/app/home/home_widget/home_widget.dart';
import 'package:flutter_app_flavor/src/app/home/notification_widget/notification_widget.dart';
import 'package:flutter_app_flavor/src/config/flavor_config.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_offline/flutter_offline.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlavorConfig config = FlavorConfig.instance;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _children = <Widget>[
    HomeWidget(),
    NotificationWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
    BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Notifications'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: config.accentColor,
        onTap: onTapTapped,
      ),
      body: OfflineBuilder(
          connectivityBuilder: (BuildContext context,
              ConnectivityResult connectivity, Widget child) {
            final bool connected = connectivity != ConnectivityResult.none;
            return Stack(
              fit: StackFit.expand,
              children: [
                child,
                Positioned(
                  height: 32.0,
                  left: 0.0,
                  right: 0.0,
                  child: AnimatedOpacity(
                    opacity: connected ? 0 : 1,
                    duration: Duration(seconds: 1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: connected
                            ? Text('ONLINE')
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('OFFLINE'),
                            SizedBox(width: 8.0),
                            SizedBox(
                              width: 12.0,
                              height: 12.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        child: _children[_selectedIndex],
      ),
    );
  }

  void onTapTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
