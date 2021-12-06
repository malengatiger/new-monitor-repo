import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/position.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/location/loc_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../functions.dart';
import 'data_api.dart';

final StorageBloc storageBloc = StorageBloc();

class StorageBloc {
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Random rand = new Random(new DateTime.now().millisecondsSinceEpoch);
  static const mm = '☕️ ☕️ ☕️ ☕️ ☕️ ☕️ StorageBloc: 💚 ';
  List<StorageMediaBag> _mediaBags = [];
  StreamController<List<StorageMediaBag>> _mediaStreamController = StreamController.broadcast();
  Stream<List<StorageMediaBag>> get mediaStream => _mediaStreamController.stream;

  User? _user;

  close() {
    _mediaStreamController.close();
  }

  // ignore: missing_return

  final storageName = 'monitorPhotos';
  // ignore: missing_return
  Future<String?> uploadPhotoOrVideo(
      {required StorageBlocListener listener,
      required File file,
      required File thumbnailFile,
      required Project project,
      required String projectPositionId,
      required Position projectPosition,
      required bool isVideo}) async {
    rand = new Random(new DateTime.now().millisecondsSinceEpoch);
    var name = 'media@${project.projectId}@' +
        DateTime.now().toUtc().toIso8601String() +
        '.${isVideo ? 'mp4' : 'jpg'}';
    try {
      pp('$mm️ uploadPhoto ☕️ file path: ${file.path}');
      var firebaseStorageRef = FirebaseStorage.instance.ref().child(storageName).child(name);

      var uploadTask = firebaseStorageRef.putFile(file);
      _reportProgress(uploadTask, listener);

      uploadTask.whenComplete(() => null).then((snapShot) async {
        var totalByteCount = snapShot.totalBytes;
        var bytesTransferred = snapShot.bytesTransferred;
        var bt = (bytesTransferred / 1024).toStringAsFixed(2) + ' KB';
        var tot = (totalByteCount / 1024).toStringAsFixed(2) + ' KB';
        pp('$mm uploadTask: 💚 💚 '
            'photo upload complete '
            ' 🧩 $bt of $tot 🧩 transferred.'
            ' date: ${DateTime.now().toIso8601String()}\n\n');

        var fileUrl = await firebaseStorageRef.getDownloadURL();
        listener.onFileUploadComplete(fileUrl, snapShot.totalBytes, snapShot.bytesTransferred);

        var mType = isVideo ? 'mp4' : 'jpg';

        _uploadThumbnail(
            listener: listener,
            file: file,
            type: mType,
            thumbnailFile: thumbnailFile,
            position: projectPosition,
            isVideo: isVideo,
            fileUrl: fileUrl,
            projectPositionId: projectPositionId,
            project: project);
      }).catchError((e) {
        pp(e);
        listener.onError('👿👿👿👿 Photo upload failed');
      });
    } catch (e) {
      pp(e);
      listener.onError('👿👿👿👿 Houston, we have a problem $e');
    }
    return null;
  }

  void _reportProgress(UploadTask uploadTask, StorageBlocListener listener) {
    uploadTask.snapshotEvents.listen((event) {
      var totalByteCount = event.totalBytes;
      var bytesTransferred = event.bytesTransferred;
      var bt = (bytesTransferred / 1024).toStringAsFixed(2) + ' KB';
      var tot = (totalByteCount / 1024).toStringAsFixed(2) + ' KB';
      pp('☕️☕️☕️ .uploadPhoto:  💚 progress ******* 🧩 $bt KB of $tot KB 🧩 transferred');
      listener.onFileProgress(event.totalBytes, event.bytesTransferred);
    });
  }

  Future<String?> _uploadThumbnail(
      {required StorageBlocListener listener,
      required File file,
      required File thumbnailFile,
      required type,
      required Project project,
      required Position position,
      required bool isVideo,
      required String projectPositionId,
      required String fileUrl}) async {
    rand = new Random(new DateTime.now().millisecondsSinceEpoch);
    var name = 'thumb@${project.projectId}@' + DateTime.now().toUtc().toIso8601String() + '.$type';
    String thumbnailUrl;
    final size = ImageSizeGetter.getSize(FileInput(file));
    pp('$mm uploadThumbnail:  💚 image height: ${size.height} width: ${size.width}');
    try {
      if (isVideo) {
        _addVideoBagToStream(
            fileUrl: fileUrl,
            project: project,
            position: position,
            file: file,
            projectPositionId: projectPositionId);
        return null;
      }
      pp('$mm uploadThumbnail  ☕️ file path: ${thumbnailFile.path}');
      var firebaseStorageRef = FirebaseStorage.instance.ref().child("monitorPhotos").child(name);

      var uploadTask = firebaseStorageRef.putFile(thumbnailFile);
      thumbnailProgress(uploadTask, listener);
      uploadTask.whenComplete(() => null).then((snap) async {
        var totalByteCount = snap.totalBytes;
        var bytesTransferred = snap.bytesTransferred;
        var bt = (bytesTransferred / 1024).toStringAsFixed(2) + ' KB';
        var tot = (totalByteCount / 1024).toStringAsFixed(2) + ' KB';

        pp('$mm uploadTask: 🥦 🥦 🥦 🥦 '
            'thumbnail upload complete '
            ' 🍓 $bt of $tot 🍓 transferred.'
            ' ${DateTime.now().toIso8601String()}\n\n');

        thumbnailUrl = await firebaseStorageRef.getDownloadURL();
        pp('$mm uploadThumbnail:  🥦 🥦 🥦 🥦 thumbnailUrl from storage: $thumbnailUrl');
        listener.onThumbnailUploadComplete(thumbnailUrl, snap.totalBytes, snap.bytesTransferred);
        _writePhoto(
            project: project,
            projectPosition: position,
            fileUrl: fileUrl,
            thumbnailUrl: thumbnailUrl,
            projectPositionId: projectPositionId,
            height: size.height,
            width: size.width);
        var mediaBag = StorageMediaBag(
            url: fileUrl,
            thumbnailUrl: thumbnailUrl,
            isVideo: isVideo,
            file: file,
            date: getFormattedDate(DateTime.now().toString()),
            thumbnailFile: thumbnailFile);

        _mediaBags.add(mediaBag);
        pp('$mm 🍇 uploadTask.whenComplete: 🇿🇦 💙💙 mediaStream: '
            '......... Sending result of upload in mediaBag to stream: '
            '🍇 ${_mediaBags.length} 🍇 mediaBags in stream\n\n');
        _mediaStreamController.sink.add(_mediaBags);
      }).catchError((e) {
        pp(e);
        listener.onError('👿👿👿👿 thumbnail upload failed');
      });
    } catch (e) {
      pp(e);
      listener.onError('👿👿👿👿 Houston, we have a problem $e');
    }
    return null;
  }

  void _addVideoBagToStream(
      {required String fileUrl,
      required File file,
      required Project project,
      required String projectPositionId,
      required Position position}) {
    var mediaBag = StorageMediaBag(
      url: fileUrl,
      thumbnailUrl: '',
      isVideo: true,
      file: file,
      date: getFormattedDate(DateTime.now().toString()),
    );

    _mediaBags.add(mediaBag);
    pp('\n\n🍇🍇🍇🍇 uploadTask.whenComplete: 🇿🇦 💙💙 💙💙 💙💙 mediaStream: '
        '......... Sending result of upload in mediaBag to stream: '
        '🍇 ${_mediaBags.length} 🍇 mediaBags in stream\n\n');
    _mediaStreamController.sink.add(_mediaBags);
    _writeVideo(
        project: project,
        projectPosition: position,
        fileUrl: fileUrl,
        projectPositionId: projectPositionId,
        thumbnailUrl: 'not available');
  }

  void thumbnailProgress(UploadTask uploadTask, StorageBlocListener listener) {
    uploadTask.snapshotEvents.listen((event) {
      var totalByteCount = event.totalBytes;
      var bytesTransferred = event.bytesTransferred;
      var bt = (bytesTransferred / 1024).toStringAsFixed(2) + ' KB';
      var tot = (totalByteCount / 1024).toStringAsFixed(2) + ' KB';
      pp('☕️☕️☕️ .uploadThumbnail:  🥦 progress ******* 🍓 $bt KB of $tot KB 🍓 transferred');
      listener.onThumbnailProgress(event.totalBytes, event.bytesTransferred);
    });
  }

  void _writePhoto(
      {required Project project,
      required Position projectPosition,
      required String fileUrl,
      required String thumbnailUrl,
      required String projectPositionId,
      required int height,
      required int width}) async {
    pp('🎽 🎽 🎽 🎽 StorageBloc: _writePhoto : 🎽 🎽 adding photo .....');
    if (_user == null) {
      await getUser();
    }
    var distance = await locationBloc.getDistanceFromCurrentPosition(
        latitude: projectPosition.coordinates[1], longitude: projectPosition.coordinates[0]);

    pp('🎽 🎽 🎽 🎽 StorageBloc: _writePhoto : 🎽 🎽 adding photo ..... 😡😡 distance: $distance 😡😡');
    var u = Uuid();

    var photo = Photo(
        url: fileUrl,
        caption: 'tbd',
        created: DateTime.now().toIso8601String(),
        userId: _user!.userId,
        userName: _user!.name,
        projectPosition: projectPosition,
        distanceFromProjectPosition: distance,
        projectId: project.projectId,
        thumbnailUrl: thumbnailUrl,
        projectName: project.name,
        organizationId: _user!.organizationId,
        height: height,
        width: width,
        projectPositionId: projectPositionId,
        photoId: u.v4());

    var result = await DataAPI.addPhoto(photo);
    pp('🎽 🎽 🎽 🎽 🎁 🎁 StorageBloc: Photo has been added to database: 🎁 $result');
  }

  void _writeVideo(
      {required Project project,
      required Position projectPosition,
      required String projectPositionId,
      required String fileUrl,
      required String thumbnailUrl}) async {
    pp('🎽 🎽 🎽 🎽 StorageBloc: _writeVideo : 🎽 🎽 adding video .....');
    if (_user == null) {
      await getUser();
    }
    var distance = await locationBloc.getDistanceFromCurrentPosition(
        latitude: projectPosition.coordinates[1], longitude: projectPosition.coordinates[0]);

    pp('🎽 🎽 🎽 🎽 StorageBloc: _writeVideo : 🎽 🎽 adding video ..... 😡😡 distance: $distance 😡😡');
    var u = Uuid();
    var video = Video(
        url: fileUrl,
        caption: 'tbd',
        created: DateTime.now().toIso8601String(),
        userId: _user!.userId,
        userName: _user!.name,
        projectPosition: projectPosition,
        distanceFromProjectPosition: distance,
        projectId: project.projectId,
        thumbnailUrl: thumbnailUrl,
        projectName: project.name,
        projectPositionId: projectPositionId,
        organizationId: _user!.organizationId,
        videoId: u.v4());

    var result = await DataAPI.addVideo(video);
    pp('🎽 🎽 🎽 🎽 🎁 🎁 Video has been added to database: 🎁 $result');
  }

  Future<File> downloadFile(String url) async {
    pp('🌿🌿🌿🌿🌿🌿🌿 : downloadFile: 😡😡😡 $url ....');
    final http.Response response = await http.get(Uri.parse(url)).catchError((e) {
      pp('😡😡😡 Download failed: 😡😡😡 $e');
      throw Exception('😡😡😡 Download failed: $e');
    });

    pp('🌿🌿🌿🌿🌿🌿🌿 : downloadFile: OK?? 💜💜💜💜'
        '  statusCode: ${response.statusCode}');

    if (response.statusCode == 200) {
      final Directory directory = await getApplicationDocumentsDirectory();
      var type = 'jpg';
      if (url.contains('mp4')) {
        type = 'mp4';
      }
      final File mFile =
          File('${directory.path}/download${DateTime.now().millisecondsSinceEpoch}.$type');
      pp('🌿🌿🌿🌿🌿🌿🌿 : downloadFile: 💜  .... new file: ${mFile.path}');
      mFile.writeAsBytesSync(response.bodyBytes);
      var len = await mFile.length();
      pp('🌿🌿🌿🌿🌿🌿🌿 : downloadFile: 💜  .... file downloaded length: 😡 '
          '${(len / 1024).toStringAsFixed(1)} KB - path: ${mFile.path}');
      return mFile;
    } else {
      pp('🌿🌿🌿🌿🌿🌿🌿 : downloadFile: Download failed: 😡😡😡 statusCode ${response.statusCode} 😡 ${response.body} 😡');
      throw Exception('Download failed: statusCode: ${response.statusCode}');
    }
  }

  // ignore: missing_return
  Future<int> deleteFolder(String folderName) async {
    pp('.deleteFolder ######## deleting $folderName');
    var task = _firebaseStorage.ref().child(folderName).delete();
    await task.then((f) {
      pp('.deleteFolder $folderName deleted from FirebaseStorage');
      return 0;
    }).catchError((e) {
      pp('.deleteFolder ERROR $e');
      return 1;
    });
    return 0;
  }

  // ignore: missing_return
  Future<int> deleteFile(String folderName, String name) async {
    pp('.deleteFile ######## deleting $folderName : $name');
    var task = _firebaseStorage.ref().child(folderName).child(name).delete();
    task.then((f) {
      pp('.deleteFile $folderName : $name deleted from FirebaseStorage');
      return 0;
    }).catchError((e) {
      pp('.deleteFile ERROR $e');
      return 1;
    });
    return 0;
  }

  StorageBloc() {
    pp('🍇 🍇 🍇 🍇 🍇 StorageBloc constructor 🍇 🍇 🍇 🍇 🍇');
    getUser();
  }
  Future? getUser() async {
    _user = await Prefs.getUser();
    return _user;
  }
}

abstract class StorageBlocListener {
  onFileProgress(int totalByteCount, int bytesTransferred);
  onFileUploadComplete(String url, int totalByteCount, int bytesTransferred);

  onThumbnailProgress(int totalByteCount, int bytesTransferred);
  onThumbnailUploadComplete(String url, int totalByteCount, int bytesTransferred);

  onError(String message);
}

class StorageMediaBag {
  String url, thumbnailUrl, date;
  bool isVideo;
  File? file;
  File? thumbnailFile;

  StorageMediaBag(
      {required this.url,
      required this.file,
      required this.thumbnailUrl,
      required this.isVideo,
      this.thumbnailFile,
      required this.date});
}
