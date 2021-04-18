import 'package:flutter/material.dart';
import 'package:snp_video/ui/pages/home/snp_home_screen.dart';
import 'package:snp_video/ui/pages/video/snp_video_play_screen.dart';

class SNPHomeRouter {
  // static final String initialRoute = HYMainScreen.routeName;

  static final Map<String, WidgetBuilder> routes = {
    SNPHomeScreen.routeName: (ctx) => SNPHomeScreen(),
    SNPVideoPlayScreen.routeName: (ctx) => SNPVideoPlayScreen(),
  };

  // 自己扩展
  static final RouteFactory generateRoute = (settings) {
    return null;
  };

  static final RouteFactory unknownRoute = (settings) {
    return null;
  };
}
