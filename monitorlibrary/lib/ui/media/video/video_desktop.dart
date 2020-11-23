import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/photo.dart';

class VideoDesktop extends StatefulWidget {
  final Video video;

  VideoDesktop(this.video);

  @override
  _VideoDesktopState createState() => _VideoDesktopState();
}

class _VideoDesktopState extends State<VideoDesktop>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
