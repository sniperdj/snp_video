import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:snp_video/core/network/snp_network_manager.dart';
import 'package:snp_video/ui/pages/home/snp_home_video_cell.dart';
import 'package:snp_video/ui/pages/login/snp_login_userinfo.dart';
import 'snp_home_api.dart';

class SNPHomeScreen extends StatefulWidget {
  static const String routeName = "/home_video";

  @override
  _SNPHomeScreenState createState() => _SNPHomeScreenState();
}

class _SNPHomeScreenState extends State<SNPHomeScreen>
    with SingleTickerProviderStateMixin {
  final _picker = ImagePicker();
  File _mainFile;
  String _mainFilePath;
  File _bgFile;
  String _bgFilePath;
  Timer _timer;
  int _countdownTime = 0;
  String _videoResultId;

  TabController _tabController;
  List tabs = ["视频", "图片", "历史"];

  @override
  void initState() {
    super.initState();
    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
        bottom: TabBar(
          tabs: tabs.map((e) => Text(e)).toList(),
          controller: _tabController,
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        videoHandle(),
        videoHandle(),
        videoHandle(),
        // imageHandle(),
        // historyList()
      ]),
    );
  }

  // UI =============================
  Widget videoHandle() {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    SNPUserInfo userInfo = SNPUserInfo();

    return SingleChildScrollView(
      child: Column(children: [
        SNPHomeVideoCell("人像视频", "请选择", (String filePath) {
          setState(() {
            _mainFilePath = filePath;
            uploadVideo("video", _mainFilePath);
          });
        }),
        SNPHomeVideoCell("背景视频", "请选择", (String filePath) {
          setState(() {
            _bgFilePath = filePath;
            uploadVideo("background", _bgFilePath);
          });
        }),
        TextButton(
          child: Text("上传"),
          onPressed: () {
            if (_bgFilePath == null) {
              EasyLoading.showToast("背景视频不能为空");
              return;
            }
            if (_mainFilePath == null) {
              EasyLoading.showToast("人像视频不能为空");
              return;
            }
            // uploadVideo();
          },
        ),
        TextButton(
          child: Text("查询"),
          onPressed: () {
            fetchMergeProgress();
          },
        )
      ]),
    );
  }

  void uploadVideo(String videoType, String filePath) {
    final manager = SNPNetworkManager.instance;
    SNPUserInfo userInfo = SNPUserInfo();
    print("upload with token ${userInfo.token}");
    String fileName = "${videoType}.mp4";
    Map<String, dynamic> params = {
      videoType: MultipartFile.fromFileSync(filePath, filename: fileName),
    };
    final header = {"authorization": "JWT ${userInfo.token}"};
    manager.uploadFile(upload_video_api, params, headers: header,
        progressCallback: (double percent) {
      print("progress : ${percent}");
      // EasyLoading.showProgress(percent);
    }).then((resp) {
      Map<String, dynamic> response = resp.data;
      Map<String, dynamic> data = response['data'];
      print("id : ${data['id']}");
      // {"code":"999999","msg":"{'foreground_video_file': [ErrorDetail(string='提交的数据不是一个文件。请检查表单的编码类型。', code='invalid')], 'background_video_file': [ErrorDetail(string='提交的数据不是一个文件。请检查表单的编码类型。', code='invalid')]}"}
      if ("000000" != response["code"]) {
        // 出错了
        final msg = response["msg"];
        EasyLoading.showError(msg);
        return;
      }
      setState(() {
        print("set state id : ${data['id']}");
        _videoResultId = data["id"];
        print("id ??? ${_videoResultId}");
        EasyLoading.showToast("upload success");
      });
    }).onError((error, stackTrace) {
      EasyLoading.showToast("err : ${error}");
    });
  }

  void circleLoadingProgress() {
    const timeInterval = const Duration(seconds: 4);

    var callback = (timer) {
      setState(() {
        EasyLoading.showProgress(_countdownTime / 100.0);
        if (_countdownTime >= 100) {
          _timer.cancel();
        } else {
          _countdownTime = _countdownTime + 4;
          fetchMergeProgress();
        }
      });
    };

    _timer = Timer.periodic(timeInterval, callback);
  }

  void fetchMergeProgress() {
    final manager = SNPNetworkManager.instance;
    SNPUserInfo userInfo = SNPUserInfo();
    print("merge upload with token ${userInfo.token}");
    final header = {"authorization": "JWT ${userInfo.token}"};
    print("wtf");
    String url = "${upload_progress_api}/55/";
    print("fetch merge url : ${url}");
    manager.getData(url, headers: header).then((json) {
      print("upload progress value : ${json.data}");
      Map<String, dynamic> resp = json.data;
      if ("000003" == resp["code"]) {
        Map<String, dynamic> data = resp["data"];
        print("progress is : ${data['progress']}");
      }
      // print("msg : ${resp['msg']}");
      // print("data : ${resp['data']}");
      // print("progress : ${resp['data']['progress']}");
    });
  }
}
