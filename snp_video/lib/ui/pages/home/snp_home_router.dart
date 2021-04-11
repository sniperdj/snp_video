import 'package:flutter/material.dart';
import 'package:snp_video/ui/pages/home/snp_home.dart';
// import 'package:snp_video/ui/pages/home/snp_video_detail_page.dart';
// import 'package:qq_food/ui/pages/food/qq_homefooddetail_page.dart';
// import 'package:snpnote/ui/pages/home/snp_home_insist_detail.dart';

class SNPHomeRouter {
  // static final String initialRoute = HYMainScreen.routeName;

  static final Map<String, WidgetBuilder> routes = {
    SNPHomePage.routeName: (ctx) => SNPHomePage(),
    // SNPVideoPlayPage.routeName: (ctx) => SNPVideoPlayPage(),
  };

  // 自己扩展
  static final RouteFactory generateRoute = (settings) {
    return null;
  };

  static final RouteFactory unknownRoute = (settings) {
    return null;
  };
}
