import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:monitorlibrary/camera/uploader.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/settlement.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class CameraRun extends StatefulWidget {
  final Project project;
  final Settlement settlement;

  CameraRun({this.project, this.settlement});

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
    print(' 👿  👿  👿  👿 Error: 👿  $code\nError Message: 👿👿  $message');

class _CameraRunState extends State<CameraRun> with WidgetsBindingObserver {
  CameraController controller;
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
    if (widget.project == null && widget.settlement == null) {
      throw Exception('You need a project OR a settlement');
    }
  }

  void _setCamera() async {
    try {
      debugPrint('🥝 🥝 🥝 _setCamera: trying to find cameras  ... 🧩 🧩 ');
      cameras = await availableCameras();
      if (cameras != null) {
        debugPrint(
            '🥝 🥝 🥝 🥝 🥝 🥝 🥝 🥝 🥝 _setCamera: cameras found:  ${cameras.length}  ... 🧩 Yebo!!! 🧩 ');
        setState(() {});
      } else {
        debugPrint('👿👿👿👿👿👿_setCamera: cameras NOT found:  👿👿👿👿 ');
      }
    } on CameraException catch (e) {
      debugPrint('👿👿👿👿👿_setCamera: CameraException $e  👿 ');
      logError(e.code, e.description);
    }
  }

  @override
  void dispose() {
    debugPrint(
        '🥁 dispose: 🥁 🥁 Removing ... WidgetsBinding.instance.removeObserver');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('Main: 🖲🖲🖲🖲🖲 didChangeAppLifecycleState:  🖲 $state');
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                    Expanded(
                      child: Container(
                        child: Center(
                          child: _cameraPreviewWidget(),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(
                            color: controller != null &&
                                    controller.value.isRecordingVideo
                                ? Colors.redAccent
                                : Colors.grey,
                            width: 0.0,
                          ),
                        ),
                      ),
                    ),
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
        ],
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null) {
      return Container();
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
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
              if (controller != null) {
                onNewCameraSelected(controller.description);
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
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(
            Icons.videocam,
            size: 36,
          ),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
              ? onVideoRecordButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(
            Icons.stop,
            size: 36,
          ),
          color: Colors.red,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  controller.value.isRecordingVideo
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
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
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
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
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
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/monitor';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
      if (widget.project != null) {
        debugPrint('🖲🖲🖲🖲🖲🖲  Picture File to send : 🖲🖲 $filePath 🖲🖲');

        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.topLeft,
                duration: Duration(seconds: 2),
                child:
                    FileUploader(filePath: filePath, project: widget.project)));
      }
      if (widget.settlement != null) {
        debugPrint('🖲🖲🖲🖲🖲🖲  Picture File to send : 🖲🖲 $filePath 🖲🖲');
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.topLeft,
                duration: Duration(seconds: 2),
                child: FileUploader(
                    filePath: filePath, settlement: widget.settlement)));
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
  void _onCameraChanged(CameraDescription value) {
    if (controller != null && controller.value.isRecordingVideo) {
      debugPrint(
          '⚔️⚔️⚔️ Ignoring this change .... controller.value.isRecordingVideo');
    } else {
      debugPrint('🧡 🧡 🧡 ️camera selected description: 🔰🔰 ${value.name}  ');
      onNewCameraSelected(value);
      setState(() {
        isCameraSelected = true;
      });
    }
  }
}

List<CameraDescription> cameras;

abstract class CameraListener {
  onPhotoTaken(String filePath);
}
