import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snp_video/ui/pages/video/snp_video_play_screen.dart';

class SNPHomeVideoCell extends StatefulWidget {
  final String title;
  final String btnName;
  final ValueChanged<String> callbackFunc;

  SNPHomeVideoCell(this.title, this.btnName, this.callbackFunc);

  @override
  _SNPHomeVideoCellState createState() => _SNPHomeVideoCellState();
}

class _SNPHomeVideoCellState extends State<SNPHomeVideoCell> {
  File _file;
  String _filePath;
  ImagePicker _picker = ImagePicker();

  TextEditingController _filePathC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          widget.title == null ? "主要视频" : widget.title,
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(40, 80, 40, 20),
          // width: double.infinity,
          color: Colors.orange,
          child: TextField(
            controller: _filePathC,
            decoration: InputDecoration(
              hintText: "",
              // labelText: "label",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextButton(
          child: Text(
            widget.title == null ? "选择视频" : widget.btnName,
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () async {
            print("select video btn click");
            PickedFile video =
                await _picker.getVideo(source: ImageSource.gallery);
            if (video.path == null) {
              Navigator.pop(context);
              return;
            }
            setState(() {
              _filePath = video.path;
              print("file path : ${_filePath}");
              _file = File(_filePath);
              print("file : ${_file}");
              _filePathC.text = _filePath;
              widget.callbackFunc(video.path);
            });
          },
        )
      ],
    );
  }
}


// _filePath == null
//                 ? Center(
//                     child: Text("请选择一个视频文件"),
//                   )
//                 : TextButton(
//                     child: Text("已选择的视频"),
//                     onPressed: () {
//                       if (_file != null) {
//                         Map<String, dynamic> param = {
//                           "file": _file,
//                           "filePath": _filePath
//                         };
//                         Navigator.of(context).pushNamed(
//                             SNPVideoPlayScreen.routeName,
//                             arguments: param);
//                       }
//                     }))