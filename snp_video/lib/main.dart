import 'package:flutter/material.dart';
import 'package:snp_video/ui/pages/login/snp_login_userinfo.dart';
import 'ui/pages/home/snp_home.dart';
import 'ui/pages/login/snp_login_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:snp_video/ui/pages/home/snp_home_router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final userInfo = SNPUserInfo();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SNPUserInfo>(create: (_) => SNPUserInfo()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: userInfo.isLogin // 登录了就去home 否则就去登录页
            ? SNPHomePage()
            : SNPLoginPage(),
        builder: EasyLoading.init(),
        routes: SNPHomeRouter.routes,
      ),
    );
  }
}
