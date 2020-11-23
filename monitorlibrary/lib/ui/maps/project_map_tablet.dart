import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/project_position.dart';

class ProjectMapTablet extends StatefulWidget {
  final Project project;
  final List<ProjectPosition> projectPositions;
  ProjectMapTablet({this.project, this.projectPositions});

  @override
  _ProjectMapTabletState createState() => _ProjectMapTabletState();
}

class _ProjectMapTabletState extends State<ProjectMapTablet>
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
