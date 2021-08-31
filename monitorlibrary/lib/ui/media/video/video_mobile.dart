import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:video_player/video_player.dart';

class VideoMobile extends StatefulWidget {
  final Video video;

  VideoMobile(this.video);

  @override
  _VideoMobileState createState() => _VideoMobileState();
}

class _VideoMobileState extends State<VideoMobile>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  ChewieController? chewieController;
  Chewie? playerWidget;
  VideoPlayerController? _videoPlayerController1;
  VideoPlayerController? _videoPlayerController2;

  Future<void> _setPlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(widget.video.url!);
    await _videoPlayerController1!.initialize();
    pp('🍏 🍏 🍏 🍏 🍏 VidePlayerController has been initialized');

    chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1!,
      autoPlay: true,
      looping: true,
    );
    chewieController!.enterFullScreen();

    playerWidget = Chewie(
      controller: chewieController!,
    );
    pp('🍏 🍏 🍏 🍏 🍏 Chewie playerWidget has been set up');
    chewieController!.enterFullScreen();

    setState(() {});
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _setPlayer();
  }

  @override
  void dispose() {
    _controller!.dispose();
    _videoPlayerController1!.dispose();
    chewieController!.dispose();
    _changeToPortrait();
    super.dispose();
  }

  void _changeToLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    setState(() {
      isLandscape = true;
    });
  }

  void _changeToPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setState(() {
      isLandscape = false;
    });
  }

  bool isLandscape = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.video.projectName!,
            style: Styles.whiteSmall,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(16),
            child: Column(
              children: [
                Text(
                  '${getFormattedDateLongWithTime(widget.video.created!, context)}',
                  style: Styles.blackBoldSmall,
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: isLandscape ? Icon(Icons.portrait) : Icon(Icons.landscape),
              onPressed: () {
                if (isLandscape) {
                  _changeToLandscape();
                } else {
                  _changeToPortrait();
                }
                isLandscape = !isLandscape;
              },
            )
          ],
        ),
        backgroundColor: Colors.brown[100],
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4),
              child: Card(
                color: Colors.black,
                elevation: 4,
                child: Container(
                  child: Center(
                    child: chewieController != null &&
                            chewieController!
                                .videoPlayerController.value.isInitialized
                        ? Chewie(
                            controller: chewieController!,
                          )
                        : Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                              backgroundColor: Colors.black,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 12,
              bottom: 4,
              child: Card(
                color: Colors.brown[100],
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Text('Distance from Project'),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        widget.video.distanceFromProjectPosition!
                            .toStringAsFixed(1),
                        style: Styles.blackBoldMedium,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('metres'),
                      SizedBox(
                        width: 28,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 24,
              child: FloatingActionButton(
                elevation: 8,
                mini: true,
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.map,
                  color: Colors.white,
                ),
                onPressed: () {
                  pp(' 😡  😡  😡  😡  😡 Go do something, Joe!');
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  TargetPlatform? _platform;
}
