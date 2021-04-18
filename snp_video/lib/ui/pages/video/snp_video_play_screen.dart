import 'dart:io';
import 'package:flutter/material.dart';
import 'package:awsome_video_player/awsome_video_player.dart';

class SNPVideoPlayScreen extends StatefulWidget {
  static const String routeName = "/video_play";

  @override
  _SNPVideoPlayScreenState createState() => _SNPVideoPlayScreenState();
}

class _SNPVideoPlayScreenState extends State<SNPVideoPlayScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    final file = args["file"];
    final filePath = args["filePath"];
    return Scaffold(
      appBar: AppBar(
        title: Text("视频"),
      ),
      body: Center(
        child: AwsomeVideoPlayer(filePath),
      ),
    );
  }
}
