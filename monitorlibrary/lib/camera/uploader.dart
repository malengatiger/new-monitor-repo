import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/settlement.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/api/storage_api.dart';
import 'package:location/location.dart';
import 'package:image/image.dart' as  Img;

class FileUploader extends StatefulWidget  {
  final String filePath;
  final Project project;
  final Settlement  settlement;


  FileUploader({@required this.filePath, this.project, this.settlement});

  @override
  _FileUploaderState createState() => _FileUploaderState();
}

class _FileUploaderState extends State<FileUploader> implements UploadListener {
  bool isBusy = false;
  User  user;
  File file;
  @override
  void initState() {
    super.initState();
    _getUser();
  }
  _getUser() async {
    file = File(widget.filePath);
    user = await Prefs.getUser();
    //_resizeImage();

  }
  _resizeImage()  async {
    var mFile  = File(widget.filePath);
    var mFileLength  = await mFile.length();
    debugPrint('🔆🔆🔆  🕹🕹 File before resize: 🕹 $mFileLength 🕹');
    Img.Image tempImg = Img.decodeImage(mFile.readAsBytesSync());
    Img.Image resized = Img.copyResize(tempImg, height: tempImg.height ~/ 2, width: tempImg.width ~/ 2);
    file = mFile
      ..writeAsBytesSync(Img.encodeJpg(resized));
    var length = await file.length();
    debugPrint('🔆🔆🔆 🕹🕹🕹 File after resize: 🕹 $length 🕹 🔰🔰  RATIO: ${mFileLength / length} 🔰🔰');
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        file != null?  Image.file(file, fit: BoxFit.fill,) : Container(),
        Positioned(
          top: 60, left: 10,
          child: Card(
            elevation: 24,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('🍏🍏 $bytesTransferred KB of $totalByteCount KB uploaded 🧩🧩 '),
            ),
          ),
        ),
        Positioned(
          bottom: 10, right: 10,
          child: RaisedButton(
            onPressed: _uploadFile,
            color: Colors.pink,
            child: Text('Upload File', style: Styles.whiteSmall,),
          ),
        ),
      ],
    );
  }

  int bytesTransferred = 0, totalByteCount = 0;

  void _uploadFile() async {
    debugPrint('▶️ Uploader: ▶️▶️▶️▶️▶️▶️  uploading file: 📮📮 ${widget.filePath}  📮📮');
    await StorageAPI.uploadPhoto(listener: this, file: file);
  }

  @override
  onComplete(String url, int byteCnt, int transferred) async {
    setState(() {
      totalByteCount = byteCnt ~/ 1024;
      bytesTransferred = transferred ~/ 1024;
    });
    debugPrint('🍏🍏🍏 👌👌👌 onComplete: 👌👌👌 bytesTransferred: 🍅 $bytesTransferred of $totalByteCount 🍅 🍏🍏  url: $url 🍏🍏');
    _writeToDatabase(url);

    return null;
  }
  _writeToDatabase(String  url) async {
    debugPrint('_writeToDatabase: 🍅🍅🍅 $url 🍅🍅🍅');
    var location = Location();
    try {
      var mLocation = await location.getLocation();
      var p  = await DataAPI.addProjectPhoto(userId: user.userId,
          url: url, latitude: mLocation.latitude, longitude: mLocation.longitude,
          projectId: widget.project.projectId);
      debugPrint('🖲🖲🖲🖲🖲🖲  Uploader, check project photo : 🖲🖲🖲🖲');
      prettyPrint(p.toJson(), '🖲🖲🖲🖲🖲🖲 RESULT  PROJECT: 🖲🖲🖲🖲🖲🖲');
      Navigator.pop(context);
    } catch (e) {
      throw Exception('Permission denied');
    }
  }

  @override
  onError(String message) {
    debugPrint(message);
    return null;
  }

  @override
  onProgress(int byteCnt, int transferred) {
    debugPrint('🍏🍏🍏  bytesTransferred: $byteCnt of $transferred 🍏🍏 ');
    setState(() {
      totalByteCount = byteCnt ~/ 1024;
      bytesTransferred = transferred ~/ 1024;
    });
  }
}
