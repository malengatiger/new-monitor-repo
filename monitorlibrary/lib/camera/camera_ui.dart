import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:monitorlibrary/camera/camera_run.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/settlement.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:page_transition/page_transition.dart';

class CameraMain extends StatefulWidget {
  final Project project;
  final Settlement settlement;

  CameraMain({this.project, this.settlement});

  @override
  _CameraMainState createState() => _CameraMainState();
}

class _CameraMainState extends State<CameraMain> {
  String name = '';
  bool isProject;
  bool showPreview = false;

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      name = widget.project.name;
      isProject = true;
    }
    if (widget.settlement != null) {
      name = widget.settlement.settlementName;
      isProject = false;
    }
    //_setupCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos and Videos'),
        backgroundColor: Colors.teal[300],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Column(
            children: <Widget>[
              Text(
                name,
                style: Styles.whiteBoldMedium,
                overflow: TextOverflow.clip,
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.brown[100],
      body: showPreview
          ? AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Photographs and Video clips to be made and uploaded for $name ',
                        style: Styles.blackMedium,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.teal[400],
                            elevation: 8,
                            child: Text(
                              'Video',
                              style: Styles.whiteSmall,
                            ),
//                      onPressed: _onVideo,
                          ),
                          RaisedButton(
                            color: Colors.pink[400],
                            elevation: 8,
                            child: Text(
                              'Photo',
                              style: Styles.whiteSmall,
                            ),
                            onPressed: _onPhoto,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _onVideo() {
    debugPrint('🧩 🧩 🧩 _onVideo: 🧩 🧩 ');

    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 2),
            child: CameraRun(
              project: widget.project,
            )));
  }

  void _onPhoto() {
    debugPrint('🥝 🥝 🥝 _onPhoto: 🧩 🧩 ');
    if (widget.project != null) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.topLeft,
              duration: Duration(seconds: 2),
              child: CameraRun(
                project: widget.project,
              )));
    }
    if (widget.settlement != null) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.topLeft,
              duration: Duration(seconds: 2),
              child: CameraRun(
                settlement: widget.settlement,
              )));
    }
  }

  CameraController controller;
  _setupCamera() async {
    debugPrint('🥝 🥝 🥝 _setupCamera: availableCameras: 🧩 🧩 ');
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      debugPrint('👿👿👿👿 No cameras found on the device');
      return;
    }
    final firstCamera = cameras.first;
    controller = CameraController(firstCamera, ResolutionPreset.medium);
    controller.initialize().then((_) {
      debugPrint('🎲 🎲 🎲 🎲  camera controller 🎲 initialized: 🧩 🧩 ');
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }
}
