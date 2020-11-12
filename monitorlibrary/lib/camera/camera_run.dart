import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/api/storage_api.dart';
import 'package:monitorlibrary/data/community.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class CameraRun extends StatefulWidget {
  final Project project;
  final Community community;

  CameraRun({this.project, this.community});

  @override
  _CameraRunState createState() {
    return _CameraRunState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    pp(' 👿  👿  👿  👿 Error: 👿  $code\nError Message: 👿👿  $message');

class _CameraRunState extends State<CameraRun>
    with WidgetsBindingObserver
    implements StorageUploadListener {
  CameraController cameraController;
  String imagePath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setCamera();
    if (widget.project == null && widget.community == null) {
      throw Exception('You need a project OR a settlement');
    }
  }

  void _setCamera() async {
    try {
      pp('🥝 🥝 🥝 _setCamera: trying to find cameras  ... 🧩 🧩 ');
      cameras = await availableCameras();
      if (cameras != null) {
        pp('🥝 🥝 🥝 🥝 🥝 🥝 🥝 🥝 🥝 _setCamera: cameras found:  ${cameras.length}  ... 🧩 Yebo!!! 🧩 ');
        setState(() {});
      } else {
        pp('👿👿👿👿👿👿_setCamera: cameras NOT found:  👿👿👿👿 ');
      }
    } on CameraException catch (e) {
      pp('👿👿👿👿👿_setCamera: CameraException $e  👿 ');
      logError(e.code, e.description);
    }
  }

  @override
  void dispose() {
    pp('🥁 dispose: 🥁 🥁 Removing ... WidgetsBinding.instance.removeObserver');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    pp('Main: 🖲🖲🖲🖲🖲 didChangeAppLifecycleState:  🖲 $state');
    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (cameraController != null) {
        onNewCameraSelected(cameraController.description);
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int totalBytes, bytesTransferred;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Photos & Videos'),
      ),
      body: Stack(
        children: <Widget>[
          isCameraSelected
              ? Column(
                  children: <Widget>[
                    // Expanded(
                    //   child: Container(
                    //     child: Center(
                    //       child: _cameraPreviewWidget(),
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: Colors.black,
                    //       border: Border.all(
                    //         color: cameraController != null &&
                    //                 cameraController.value.isRecordingVideo
                    //             ? Colors.redAccent
                    //             : Colors.grey,
                    //         width: 0.0,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    _captureControlRowWidget(),
                    _toggleAudioWidget(),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _thumbnailWidget(),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(),
          !isCameraSelected ? _cameraList() : Container(),
          totalBytes == null
              ? Container()
              : Positioned(
                  left: 20,
                  top: 20,
                  child: Container(
                    width: 300,
                    height: 40,
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text('Transferred'),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              '$bytesTransferred',
                              style: Styles.pinkBoldSmall,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text('of'),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              '$totalBytes',
                              style: Styles.blackBoldSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
        ],
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (cameraController == null) {
      return Container();
    }

    return AspectRatio(
      aspectRatio: cameraController.value.aspectRatio,
      child: CameraPreview(cameraController),
    );
  }

  /// Toggle recording audio
  Widget _toggleAudioWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Row(
        children: <Widget>[
          const Text('Enable Audio:'),
          Switch(
            value: enableAudio,
            onChanged: (bool value) {
              enableAudio = value;
              if (cameraController != null) {
                onNewCameraSelected(cameraController.description);
              }
            },
          ),
        ],
      ),
    );
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            videoController == null && imagePath == null
                ? Container()
                : SizedBox(
                    child: (videoController == null)
                        ? Image.file(File(imagePath))
                        : Container(
                            child: Center(
                              child: AspectRatio(
                                  aspectRatio:
                                      videoController.value.size != null
                                          ? videoController.value.aspectRatio
                                          : 1.0,
                                  child: VideoPlayer(videoController)),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.pink)),
                          ),
                    width: 64.0,
                    height: 64.0,
                  ),
          ],
        ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.camera_alt,
            size: 36,
          ),
          color: Colors.blue,
          onPressed: cameraController != null &&
                  cameraController.value.isInitialized &&
                  !cameraController.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(
            Icons.videocam,
            size: 36,
          ),
          color: Colors.blue,
          onPressed: cameraController != null &&
                  cameraController.value.isInitialized &&
                  !cameraController.value.isRecordingVideo
              ? onVideoRecordButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(
            Icons.stop,
            size: 36,
          ),
          color: Colors.red,
          onPressed: cameraController != null &&
                  cameraController.value.isInitialized &&
                  cameraController.value.isRecordingVideo
              ? onStopButtonPressed
              : null,
        )
      ],
    );
  }

  Widget _cameraList() {
    if (cameras == null || cameras.isEmpty) {
      return Center(
        child: Text(
          'No cameras found',
          style: Styles.purpleBoldLarge,
        ),
      );
    }

    return ListView.builder(
      itemCount: cameras.length,
      itemBuilder: (BuildContext context, int index) {
        var cam = cameras.elementAt(index);
        var name;
        if (cam.lensDirection.toString().contains('front')) {
          name = 'Front Camera';
        }
        if (cam.lensDirection.toString().contains('back')) {
          name = 'Back Camera';
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              onNewCameraSelected(cam);
              setState(() {
                isCameraSelected = true;
              });
            },
            child: Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text(
                  '$name',
                  style: Styles.blackBoldMedium,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController.dispose();
    }
    cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
    );

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    pp('🍊 🍊 🍊onTakePictureButtonPressed .. takePicture ... ');
    isVideo = false;
    takePicture().then((String filePath) {
      pp('🍊 🍊 🍊 onTakePictureButtonPressed filePath: filePath: $filePath 🍊');
      if (mounted) {
        setState(() {
          imagePath = filePath;
          videoController?.dispose();
          videoController = null;
        });
        //if (filePath != null) showInSnackBar('Picture saved to $filePath');
        //show in pic upload page .... upload from there

      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
      if (filePath != null) showInSnackBar('Saving video to $filePath');
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recorded to: $videoPath');
    });
  }

  Future<String> startVideoRecording() async {
    if (!cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    isVideo = true;
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await cameraController.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      await cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    await _startVideoPlayer();
  }

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vcontroller =
        VideoPlayerController.file(File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imagePath = null;
        videoController = vcontroller;
      });
    }
    await vcontroller.play();
  }

  Future<String> takePicture() async {
    if (!cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/monitor';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await cameraController.takePicture(filePath);
      if (widget.project != null) {
        pp('🖲🖲🖲🖲🖲🖲  Picture File to send : 🖲🖲 $filePath 🖲🖲');
        var file = File(filePath);
        var url = StorageAPI.uploadPhoto(listener: this, file: file);
        pp(' 🥝 🥝 🥝 🥝 🥝 Uploaded project file url arrived at camera module, use for photo record: $url');
      }
      if (widget.community != null) {
        pp('🖲🖲🖲🖲🖲🖲  Picture File to send : 🖲🖲 $filePath 🖲🖲');
        var file = File(filePath);
        var url = StorageAPI.uploadPhoto(listener: this, file: file);
        pp(' 🥝 🥝 🥝 🥝 🥝 Uploaded community file url arrived at camera module, use for photo record: $url');
      }
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  bool isCameraSelected = false;
  bool isVideo = false;

  void _onCameraChanged(CameraDescription value) {
    if (cameraController != null && cameraController.value.isRecordingVideo) {
      pp('⚔️⚔️⚔️ Ignoring this change .... controller.value.isRecordingVideo');
    } else {
      pp('🧡 🧡 🧡 ️camera selected description: 🔰🔰 ${value.name}  ');
      onNewCameraSelected(value);
      setState(() {
        isCameraSelected = true;
      });
    }
  }

  @override
  onUploadComplete(String url, int totalByteCount, int bytesTransferred) async {
    await savePhoto(url, totalByteCount, bytesTransferred);
  }

  Future savePhoto(String url, int totalByteCount, int bytesTransferred) async {
    var user = await Prefs.getUser();
    pp('📩 📩 📩 CameraRun:: Uploaded file url arrived at camera module, use for photo record: $url');
    pp('📩 📩 📩 CameraRun:: Uploaded file bytes: 🍊 $totalByteCount 🍊 transferred: $bytesTransferred');
    //todo - use and create a monitor report .... in another widget StartMonitorReport
    if (isVideo) {
      if (widget.project != null) {
        var video = Video(
            url: url,
            userId: user.userId,
            created: DateTime.now().toUtc().toIso8601String());
        widget.project.videos.add(video);
        Prefs.saveActiveProject(widget.project);
        pp('📩 📩 📩 CameraRun:: ........... popping off now!');
//        Navigator.pop(context);
      } else {
        if (widget.community != null) {
          var photo = Photo(
              url: url,
              userId: user.userId,
              created: DateTime.now().toUtc().toIso8601String());
//          widget.community.photos.add(photo);
//          Prefs.saveActiveProject(widget.project);
//          pp('📩 📩 📩 CameraRun:: ........... popping off now!');
//          Navigator.pop(context);
        }
      }
    } else {
      if (widget.project != null) {
        var photo = Photo(
            url: url,
            userId: user.userId,
            created: DateTime.now().toUtc().toIso8601String());
        widget.project.photos.add(photo);
        Prefs.saveActiveProject(widget.project);
        pp('📩 📩 📩 CameraRun:: ........... popping off now!');
//        Navigator.pop(context);
      } else {
        if (widget.community != null) {
          var photo = Photo(
              url: url,
              userId: user.userId,
              created: DateTime.now().toUtc().toIso8601String());
//          widget.community.photos.add(photo);
//          Prefs.saveActiveProject(widget.project);
//          pp('📩 📩 📩 CameraRun:: ........... popping off now!');
//          Navigator.pop(context);
        }
      }
    }
  }

  @override
  onError(String message) {
    // TODO: implement onError
    throw UnimplementedError();
  }

  @override
  onProgress(int totalByteCount, int bytesTransferred) {
    pp('📩 📩 📩 CameraRun: 🍊 bytesTransferred: 🍊 $bytesTransferred of $totalByteCount 🍊');
    setState(() {
      this.bytesTransferred = bytesTransferred;
      this.totalBytes = totalByteCount;
    });
  }
}

List<CameraDescription> cameras;

abstract class CameraListener {
  onPhotoTaken(String filePath);
}
