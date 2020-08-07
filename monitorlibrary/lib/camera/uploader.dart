import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as Img;
import 'package:location/location.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/api/storage_api.dart';
import 'package:monitorlibrary/data/community.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';

abstract class UploaderListener {
  onFileUploaded(String url);
}

class FileUploader extends StatefulWidget {
  final String filePath;
  final Project project;
  final UploaderListener uploaderListener;
  final Community community;

  FileUploader(
      {@required this.filePath,
      this.project,
      this.community,
      @required this.uploaderListener});

  @override
  _FileUploaderState createState() => _FileUploaderState();
}

class _FileUploaderState extends State<FileUploader>
    implements StorageUploadListener {
  bool isBusy = false;
  User user;
  File file;
  @override
  void initState() {
    super.initState();
    assert(widget.uploaderListener != null);
    _getUser();
  }

  _getUser() async {
    file = File(widget.filePath);
    user = await Prefs.getUser();
    //_resizeImage();
  }

  _resizeImage() async {
    var mFile = File(widget.filePath);
    var mFileLength = await mFile.length();
    pp('🔆🔆🔆  🕹🕹 File before resize: 🕹 $mFileLength 🕹');
    Img.Image tempImg = Img.decodeImage(mFile.readAsBytesSync());
    Img.Image resized = Img.copyResize(tempImg,
        height: tempImg.height ~/ 2, width: tempImg.width ~/ 2);
    file = mFile..writeAsBytesSync(Img.encodeJpg(resized));
    var length = await file.length();
    pp('🔆🔆🔆 🕹🕹🕹 File after resize: 🕹 $length 🕹 🔰🔰  RATIO: ${mFileLength / length} 🔰🔰');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        file != null
            ? Image.file(
                file,
                fit: BoxFit.fill,
              )
            : Container(),
        Positioned(
          top: 60,
          left: 10,
          child: Card(
            elevation: 24,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  '🍏🍏 $bytesTransferred KB of $totalByteCount KB uploaded 🧩🧩 '),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: RaisedButton(
            onPressed: _startUploadFile,
            color: Colors.pink,
            child: Text(
              'Upload File',
              style: Styles.whiteSmall,
            ),
          ),
        ),
      ],
    );
  }

  int bytesTransferred = 0, totalByteCount = 0;

  void _startUploadFile() async {
    pp('▶️ Uploader: ▶️ ▶️ ▶️  ............... uploading file, listener should be OK??? : 📮📮 ${file.path}  📮📮');

    await StorageAPI.uploadPhoto(listener: this, file: file);
  }

  @override
  onComplete(String url, int byteCnt, int transferred) async {
    setState(() {
      totalByteCount = byteCnt ~/ 1024;
      bytesTransferred = transferred ~/ 1024;
    });
    pp('🍏🍏🍏 👌👌👌 onComplete: 👌👌👌 bytesTransferred: 🍅 '
        '$bytesTransferred of $totalByteCount 🍅 🍏🍏  url: $url 🍏 🍏 telling uploaderListener ...');
    widget.uploaderListener.onFileUploaded(url);
  }

  _writeToDatabase(String url) async {
    pp('_writeToDatabase: 🍅🍅🍅 $url 🍅🍅🍅');
    var location = Location();
    try {
      var mLocation = await location.getLocation();
      var p = await DataAPI.addProjectPhoto(
          userId: user.userId,
          url: url,
          latitude: mLocation.latitude,
          longitude: mLocation.longitude,
          projectId: widget.project.projectId);

      prettyPrint(p.toJson(), '🖲🖲🖲🖲🖲🖲 RESULT  PROJECT: 🖲🖲🖲🖲🖲🖲');
      Navigator.pop(context);
    } catch (e) {
      throw Exception('Permission denied');
    }
  }

  @override
  onError(String message) {
    pp(message);
    return null;
  }

  @override
  onProgress(int byteCnt, int transferred) {
    pp('🍏🍏🍏  bytesTransferred: $byteCnt of $transferred 🍏🍏 ');
    setState(() {
      totalByteCount = byteCnt ~/ 1024;
      bytesTransferred = transferred ~/ 1024;
    });
  }
}
