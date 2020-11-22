import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/project.dart';

class ProjectLocationTablet extends StatefulWidget {
  final Project project;

  ProjectLocationTablet(this.project);

  @override
  _ProjectLocationTabletState createState() => _ProjectLocationTabletState();
}

class _ProjectLocationTabletState extends State<ProjectLocationTablet>
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
