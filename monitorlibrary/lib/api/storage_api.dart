import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageAPI {
  static FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  static Random rand = new Random(new DateTime.now().millisecondsSinceEpoch);

  // ignore: missing_return

  // ignore: missing_return
  static uploadPhoto({UploadListener listener, File file}) async {
    rand = new Random(new DateTime.now().millisecondsSinceEpoch);
    var name = 'photo@' + DateTime.now().toUtc().toIso8601String() + '_${rand.nextInt(1000)} +.jpg';
    try {
      debugPrint('☕️☕️☕️ StorageAPI.uploadPhoto ------------ ☕️ path: ${file.path}');
      final StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("monitorPhotos").child(name);

      var task = firebaseStorageRef.putFile(file);
      task.events.listen((event) {
        var totalByteCount = event.snapshot.totalByteCount;
        var bytesTransferred = event.snapshot.bytesTransferred;
        var bt = (bytesTransferred / 1024).toStringAsFixed(2) + ' KB';
        var tot = (totalByteCount / 1024).toStringAsFixed(2) + ' KB';
        debugPrint(
            '☕️☕️☕️ StorageAPI.uploadPhoto:  💚 progress ******* 🧩 $bt KB of $tot KB 🧩 transferred');
        if (listener != null) listener.onProgress(event.snapshot.totalByteCount, event.snapshot.bytesTransferred);
      });
      task.onComplete.then((snap) async {
        var totalByteCount = snap.totalByteCount;
        var bytesTransferred = snap.bytesTransferred;
        var bt = (bytesTransferred / 1024).toStringAsFixed(2) + ' KB';
        var tot = (totalByteCount / 1024).toStringAsFixed(2) + ' KB';
        file.delete();
        debugPrint(
            '☕️☕️☕️ StorageAPI.uploadPhoto:  💚 💚 💚 photo upload complete ******* 🧩 $bt KB of $tot KB 🧩 transferred. ${DateTime.now().toIso8601String()}\n\n');
        var url = await firebaseStorageRef.getDownloadURL();
        if (listener != null)
          listener.onComplete(
              url, snap.totalByteCount, snap.bytesTransferred);
      }).catchError((e) {
        print(e);
        if (listener != null) listener.onError('👿👿👿👿 Photo upload failed');
      });
    } catch (e) {
      print(e);
      if (listener != null) listener.onError('👿👿👿👿 Houston, we have a problem $e');
    }
  }

  // ignore: missing_return
  static Future<int> deleteFolder(String folderName) async {
    debugPrint('StorageAPI.deleteFolder ######## deleting $folderName');
    var task = _firebaseStorage.ref().child(folderName).delete();
    await task.then((f) {
      debugPrint(
          'StorageAPI.deleteFolder $folderName deleted from FirebaseStorage');
      return 0;
    }).catchError((e) {
      debugPrint('StorageAPI.deleteFolder ERROR $e');
      return 1;
    });
  }

  // ignore: missing_return
  static Future<int> deleteFile(String folderName, String name) async {
    debugPrint('StorageAPI.deleteFile ######## deleting $folderName : $name');
    var task = _firebaseStorage.ref().child(folderName).child(name).delete();
    task.then((f) {
      debugPrint(
          'StorageAPI.deleteFile $folderName : $name deleted from FirebaseStorage');
      return 0;
    }).catchError((e) {
      debugPrint('StorageAPI.deleteFile ERROR $e');
      return 1;
    });
  }
}

abstract class UploadListener {
  onProgress(int totalByteCount, int bytesTransferred);
  onComplete(String url, int totalByteCount, int bytesTransferred);
  onError(String message);
}
