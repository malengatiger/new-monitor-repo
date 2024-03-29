import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/project.dart';

class MediaListDesktop extends StatefulWidget {
  final Project project;

  MediaListDesktop(this.project);

  @override
  _MediaListDesktopState createState() => _MediaListDesktopState();
}

class _MediaListDesktopState extends State<MediaListDesktop>
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
