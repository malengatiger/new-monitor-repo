import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/project.dart';

class MediaListTablet extends StatefulWidget {
  final Project project;

  MediaListTablet(this.project);

  @override
  _MediaListTabletState createState() => _MediaListTabletState();
}

class _MediaListTabletState extends State<MediaListTablet>
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
