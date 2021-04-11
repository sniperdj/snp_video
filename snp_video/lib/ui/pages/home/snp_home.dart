import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:snp_video/core/network/snp_network_manager.dart';
// import 'package:snp_video/ui/pages/home/snp_video_detail_page.dart';
import 'package:snp_video/ui/pages/login/snp_login_userinfo.dart';
import 'snp_home_api.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';

class SNPHomePage extends StatefulWidget {
  static const String routeName = "/home_video";

  @override
  _SNPHomePageState createState() => _SNPHomePageState();
}

class _SNPHomePageState extends State<SNPHomePage>
    with SingleTickerProviderStateMixin {
  final _picker = ImagePicker();
  File _mainFile;
  String _mainFilePath;
  File _bgFile;
  String _bgFilePath;

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
      body: homeContent(),
    );
  }

  // UI =============================
  Widget homeContent() {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    SNPUserInfo userInfo = SNPUserInfo();

    return SingleChildScrollView(
      child: Column(
        children: [
          _mainFile == null ? Text("file") : Image.file(_mainFile),
          TextButton(
              child: Text("select main file"),
              onPressed: () {
                selectImg("mainFile");
              }),
          TextButton(
              child: Text("select bg file"),
              onPressed: () {
                selectImg("bgFile");
              }),
          TextButton(
              child: Text("upload"),
              onPressed: () {
                uploadVideo();
              }),
          TextButton(
              child: Text("go to see"),
              onPressed: () {
                // Navigator.of(context).pushNamed(SNPVideoPlayPage.routeName);
              })
        ],
      ),
    );
  }

  // Widget videoMerge() {
  //   return Column(
  //     children: [],
  //   );
  // }

  // Widget videoItem(String title, String btnName) {
  //   return
  // }

  // Event ==================================
  void selectImg(String myType) async {
    PickedFile video = await _picker.getVideo(source: ImageSource.gallery);
    if (video.path == null) {
      Navigator.pop(context);
      return;
    }
    print("video path : ${video.path}");

    setState(() {
      if ("mainFile" == myType) {
        _mainFilePath = video.path;
        // _mainFile = File(video.path);
      } else {
        _bgFilePath = video.path;
        // _bgFile = File(video.path);
      }
    });
    // Navigator.pop(context);
  }

  void uploadVideo() {
    final manager = SNPNetworkManager.instance;
    SNPUserInfo userInfo = SNPUserInfo();
    print("upload with token ${userInfo.token}");
    final params = {
      "foreground_video_file": MultipartFile.fromFile(_mainFilePath,
          filename: "foreground_video_file.mp4",
          contentType: MediaType("video", "mp4")),
      "background_video_file": MultipartFile.fromFile(_bgFilePath,
          filename: "background_video_file.mp4",
          contentType: MediaType("video", "mp4")),
      "user": userInfo.username
    };
    final header = {"authorization": "JWT ${userInfo.token}"};
    manager.uploadFile(upload_video_api, params, headers: header,
        progressCallback: (double percent) {
      EasyLoading.showProgress(percent);
    }).then((resp) {
      print("upload success value : ${resp.data}");
      // {"code":"999999","msg":"{'foreground_video_file': [ErrorDetail(string='提交的数据不是一个文件。请检查表单的编码类型。', code='invalid')], 'background_video_file': [ErrorDetail(string='提交的数据不是一个文件。请检查表单的编码类型。', code='invalid')]}"}
      if ("000000" != resp.data["code"]) {
        // 出错了
        final msg = resp.data["msg"];
        EasyLoading.showError(msg);
        return;
      }
      EasyLoading.showToast("upload success");
    }).onError((error, stackTrace) {
      EasyLoading.showToast("err : ${error}");
    });
  }
}
