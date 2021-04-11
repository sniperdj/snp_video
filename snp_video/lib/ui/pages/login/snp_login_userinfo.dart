import 'package:flutter/material.dart';

class SNPUserInfo extends ChangeNotifier {
  String username;
  bool isLogin = false;
  String token;
  // String resultMergeUrl;

  // SNPUserInfo(this.username, this.isLogin, this.token);

  static final SNPUserInfo _instance = SNPUserInfo._internal();

  factory SNPUserInfo() {
    return _instance;
  }

  SNPUserInfo._internal() {
    bool isLogin = false;
  }

  // void setupFromMap(String username, bool isLogin, String token) {
  //   this.username = username;
  //   this.isLogin = isLogin;
  //   this.token = token;
  //   notifyListeners();
  // }

  void saveLoginStatusToDisk() {}
}
