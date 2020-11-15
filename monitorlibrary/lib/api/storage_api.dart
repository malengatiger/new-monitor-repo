import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../functions.dart';

class StorageAPI {
  static FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  static Random rand = new Random(new DateTime.now().millisecondsSinceEpoch);

  // ignore: missing_return

  // ignore: missing_return
  static Future<String> uploadPhoto(
      {@required StorageUploadListener listener,
      @required File file,
      @required String projectId,
      @required bool isVideo}) async {
    rand = new Random(new DateTime.now().millisecondsSinceEpoch);
    var name = 'media@$projectId@' +
        DateTime.now().toUtc().toIso8601String() +
        '.${isVideo ? 'mp4' : 'jpg'}';
    try {
      pp('☕️☕️☕️ StorageAPI.uploadPhoto ------------ ..... ☕️ path: ${file.path}');
      var firebaseStorageRef =
          FirebaseStorage.instance.ref().child("monitorPhotos").child(name);

      var uploadTask = firebaseStorageRef.putFile(file);

      uploadTask.snapshotEvents.listen((event) {
        var totalByteCount = event.totalBytes;
        var bytesTransferred = event.bytesTransferred;
        var bt = (bytesTransferred / 1024).toStringAsFixed(2) + ' KB';
        var tot = (totalByteCount / 1024).toStringAsFixed(2) + ' KB';
        pp('☕️☕️☕️ StorageAPI.uploadPhoto:  💚 progress ******* 🧩 $bt KB of $tot KB 🧩 transferred');
        if (listener != null)
          listener.onFileProgress(event.totalBytes, event.bytesTransferred);
      });

      uploadTask.whenComplete(() => null).then((snap) async {
        var totalByteCount = snap.totalBytes;
        var bytesTransferred = snap.bytesTransferred;
        var bt = (bytesTransferred / 1024).toStringAsFixed(2) + ' KB';
        var tot = (totalByteCount / 1024).toStringAsFixed(2) + ' KB';

        pp('☕️☕️☕️ StorageAPI.uploadPhoto:  💚 💚 💚 💚 💚 💚 '
            'photo upload complete '
            '******* 🧩 $bt KB of $tot KB 🧩 transferred.'
            ' ${DateTime.now().toIso8601String()}\n\n');
        var url = await firebaseStorageRef.getDownloadURL();
        if (listener != null) {
          listener.onFileUploadComplete(
              url, snap.totalBytes, snap.bytesTransferred);
          if (!isVideo) {
            var thumb = await getThumbnail(file);
            _uploadThumbnail(
                listener: listener, file: thumb, projectId: projectId);
          }
        } else {
          pp('Listener is null ... FIX this! ............................');
        }
        return url;
      }).catchError((e) {
        pp(e);
        if (listener != null) listener.onError('👿👿👿👿 Photo upload failed');
      });
    } catch (e) {
      pp(e);
      if (listener != null)
        listener.onError('👿👿👿👿 Houston, we have a problem $e');
    }
  }

  static Future<File> getThumbnail(File file) async {
    img.Image image = img.decodeImage(file.readAsBytesSync());
    var thumbnail = img.copyResize(image, width: 160);
    final Directory directory = await getApplicationDocumentsDirectory();
    final File mFile = File(
        '${directory.path}/thumbnail${DateTime.now().millisecondsSinceEpoch}.jpg');
    var thumb = mFile..writeAsBytesSync(img.encodeJpg(thumbnail, quality: 100));
    var len = await thumb.length();
    pp('....... 💜  .... thumb: 😡 ${(len / 1024).toStringAsFixed(1)} KB');
    return thumb;
  }

  // ignore: missing_return
  static Future<String> _uploadThumbnail(
      {@required StorageUploadListener listener,
      @required File file,
      @required String projectId}) async {
    rand = new Random(new DateTime.now().millisecondsSinceEpoch);
    var name =
        'thumb@$projectId@' + DateTime.now().toUtc().toIso8601String() + '.jpg';
    try {
      pp('☕️☕️☕️ StorageAPI.uploadThumbnail ------------ ..... ☕️ path: ${file.path}');
      var firebaseStorageRef =
          FirebaseStorage.instance.ref().child("monitorPhotos").child(name);

      var uploadTask = firebaseStorageRef.putFile(file);

      uploadTask.snapshotEvents.listen((event) {
        var totalByteCount = event.totalBytes;
        var bytesTransferred = event.bytesTransferred;
        var bt = (bytesTransferred / 1024).toStringAsFixed(2) + ' KB';
        var tot = (totalByteCount / 1024).toStringAsFixed(2) + ' KB';
        pp('☕️☕️☕️ StorageAPI.uploadThumbnail:  🥦 progress ******* 🍓 $bt KB of $tot KB 🍓 transferred');
        if (listener != null)
          listener.onThumbnailProgress(
              event.totalBytes, event.bytesTransferred);
      });

      uploadTask.whenComplete(() => null).then((snap) async {
        var totalByteCount = snap.totalBytes;
        var bytesTransferred = snap.bytesTransferred;
        var bt = (bytesTransferred / 1024).toStringAsFixed(2) + ' KB';
        var tot = (totalByteCount / 1024).toStringAsFixed(2) + ' KB';
        //file.delete();
        pp('☕️☕️☕️ StorageAPI.uploadThumbnail:  🥦 🥦 🥦 🥦 '
            'thumbnail upload complete '
            '******* 🍓 $bt KB of $tot KB 🍓 transferred.'
            ' ${DateTime.now().toIso8601String()}\n\n');
        var url = await firebaseStorageRef.getDownloadURL();
        if (listener != null) {
          listener.onThumbnailUploadComplete(
              url, snap.totalBytes, snap.bytesTransferred);
        } else {
          pp('Listener is null ... FIX this! ............................');
        }
        return url;
      }).catchError((e) {
        pp(e);
        if (listener != null)
          listener.onError('👿👿👿👿 thumbnail upload failed');
      });
    } catch (e) {
      pp(e);
      if (listener != null)
        listener.onError('👿👿👿👿 Houston, we have a problem $e');
    }
  }

  // ignore: missing_return
  static Future<int> deleteFolder(String folderName) async {
    pp('StorageAPI.deleteFolder ######## deleting $folderName');
    var task = _firebaseStorage.ref().child(folderName).delete();
    await task.then((f) {
      pp('StorageAPI.deleteFolder $folderName deleted from FirebaseStorage');
      return 0;
    }).catchError((e) {
      pp('StorageAPI.deleteFolder ERROR $e');
      return 1;
    });
  }

  // ignore: missing_return
  static Future<int> deleteFile(String folderName, String name) async {
    pp('StorageAPI.deleteFile ######## deleting $folderName : $name');
    var task = _firebaseStorage.ref().child(folderName).child(name).delete();
    task.then((f) {
      pp('StorageAPI.deleteFile $folderName : $name deleted from FirebaseStorage');
      return 0;
    }).catchError((e) {
      pp('StorageAPI.deleteFile ERROR $e');
      return 1;
    });
  }
}

abstract class StorageUploadListener {
  onFileProgress(int totalByteCount, int bytesTransferred);
  onFileUploadComplete(String url, int totalByteCount, int bytesTransferred);

  onThumbnailProgress(int totalByteCount, int bytesTransferred);
  onThumbnailUploadComplete(
      String url, int totalByteCount, int bytesTransferred);

  onError(String message);
}
