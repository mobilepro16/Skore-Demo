// Created by huynn109 on 2019-06-01.

import 'package:flutter/material.dart';
import 'package:flutter_app_flavor/src/config/flavor_config.dart';

class FlavorBanner extends StatelessWidget {
  final Widget child;
  BannerConfig bannerConfig;

  FlavorBanner({@required this.child});

  @override
  Widget build(BuildContext context) {
    if (FlavorConfig.isProduction()) return child;
    bannerConfig ??= _getDefaultBanner();
    return Stack(
      children: <Widget>[child, _buildBanner(context)],
    );
  }

  BannerConfig _getDefaultBanner() {
    return BannerConfig(
        bannerName: FlavorConfig.instance.name,
        bannerColor: FlavorConfig.instance.accentColor);
  }

  Widget _buildBanner(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: 50,
        height: 50,
        child: CustomPaint(
          painter: BannerPainter(
              message: bannerConfig.bannerName,
              textDirection: Directionality.of(context),
              layoutDirection: Directionality.of(context),
              location: BannerLocation.topStart,
              color: bannerConfig.bannerColor),
        ),
      ),
    );
  }
}

class BannerConfig {
  final String bannerName;
  final Color bannerColor;

  BannerConfig({@required this.bannerName, @required this.bannerColor});
}
