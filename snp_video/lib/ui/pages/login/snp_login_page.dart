import 'package:flutter/material.dart';
import 'package:snp_video/core/network/snp_network_manager.dart';
import 'package:snp_video/ui/pages/home/snp_home.dart';
import 'package:snp_video/ui/pages/login/snp_login_api.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'snp_login_userinfo.dart';
import 'package:provider/provider.dart';

class SNPLoginPage extends StatefulWidget {
  @override
  _SNPLoginPageState createState() => _SNPLoginPageState();
}

class _SNPLoginPageState extends State<SNPLoginPage> {
  TextEditingController _usernameC = TextEditingController();
  TextEditingController _passwordC = TextEditingController();
  bool _canLogin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: SingleChildScrollView(
        child: loginBodyWidget(),
      ),
    );
  }

  Widget loginBodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20),
        ),
        Container(
          width: 200,
          height: 200,
          alignment: Alignment.center,
          color: Colors.orange,
          child: Text("Logo"),
        ),
        Container(
          // color: Colors.orange,
          padding: EdgeInsets.fromLTRB(40, 80, 40, 20),
          // width: 240,
          child: TextField(
              controller: _usernameC,
              decoration: InputDecoration(
                  hintText: "用户名",
                  // labelText: "label",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4))),
              onChanged: (value) {
                // print("on change usr value ${value}");
                setState(() {
                  if (0 == _passwordC.text.length || 0 == value.length) {
                    _canLogin = false;
                    return;
                  }
                  _canLogin = true;
                });
              }),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
          // width: 240,
          child: TextField(
            obscureText: true,
            controller: _passwordC,
            decoration: InputDecoration(
                hintText: "密码",
                // labelText: "label",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
            onChanged: (value) {
              // print("on change pwd value ${value}");
              setState(() {
                if (0 == _usernameC.text.length || 0 == value.length) {
                  _canLogin = false;
                  return;
                }
                _canLogin = true;
              });
            },
          ),
        ),
        TextButton(
            child: Text("登录"),
            onPressed: !_canLogin
                ? null
                : () {
                    final String username = _usernameC.text;
                    final String password = _passwordC.text;
                    login(username, password);
                    // Navigator.of(context).pushNamed(SNPHomePage.routeName);
                  })
      ],
    );
  }

  void login(String username, String password) {
    Map<String, dynamic> params = {"username": username, "password": password};
    final manager = SNPNetworkManager.instance;
    startLoading();
    var resp = manager.postJson(login_api, params);
    resp.then((resp) {
      print("resp success ${resp.data}");
      if ("000000" != resp.data["code"]) {
        // 错误
        EasyLoading.showToast(resp.data["msg"]);
        return;
      }
      saveUserInfo(resp.data["data"]);
      Navigator.of(context).pushNamed(SNPHomePage.routeName);
    }).onError((error, stackTrace) {
      // print("resp fail ${error}");
    }).whenComplete(() {
      stopLoading();
    });
  }

  void saveUserInfo(Map<String, dynamic> info) {
    // Provider.of<SNPUserInfo>(context)
    //     .setupFromMap(info["username"], true, info["token"]);
    SNPUserInfo userInfo = SNPUserInfo();
    userInfo.username = info["username"];
    userInfo.token = info["token"];
    userInfo.isLogin = true;
    print("login save token : ${userInfo.token}");
  }

  void startLoading() {
    EasyLoading.show(status: 'loading...');
  }

  void stopLoading() {
    EasyLoading.dismiss();
  }
}
