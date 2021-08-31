import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/photo.dart';

class VideoTablet extends StatefulWidget {
  final Video video;

  VideoTablet(this.video);

  @override
  _VideoTabletState createState() => _VideoTabletState();
}

class _VideoTabletState extends State<VideoTablet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
